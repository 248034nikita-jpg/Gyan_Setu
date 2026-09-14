<?php
/**
 * save_capybara_coins.php
 * Receives the game result from Capybara Nepal Adventure,
 * saves score/coins, updates child wallet balance, checks badges, and returns JSON.
 *
 * Parameters (JSON body or POST):
 *   child_id, level_number, coins_earned, oranges_collected, knowledge_mastered, level_completed
 */

ob_start();
error_reporting(0);
ini_set('display_errors', '0');

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

// Helper: always emit clean JSON
function sendJson(array $payload): void {
    ob_clean();
    echo json_encode($payload);
    exit;
}

// Load database connection and badge engine
$root   = dirname(dirname(dirname(__DIR__)));
$dbPath = $root . '/database/includes/db_connect.php';
$scPath = $root . '/scores_coin.php';

if (file_exists($dbPath)) {
    require_once $dbPath;
}
if (file_exists($scPath)) {
    @include_once $scPath;
}

global $conn;

// Parse input (JSON body or standard $_POST)
$rawBody = file_get_contents('php://input');
$input   = json_decode($rawBody, true) ?: [];

$child_id           = (int)($input['child_id'] ?? $_POST['child_id'] ?? 0);
$level_number       = (int)($input['level_number'] ?? $_POST['level_number'] ?? 1);
$coins_earned       = (int)($input['coins_earned'] ?? $input['total_coins'] ?? $_POST['coins_earned'] ?? 0);
$oranges_collected  = (int)($input['oranges_collected'] ?? $_POST['oranges_collected'] ?? 0);
$knowledge_mastered = (int)($input['knowledge_mastered'] ?? $_POST['knowledge_mastered'] ?? 3);
$level_completed    = (int)($input['level_completed'] ?? $_POST['level_completed'] ?? 1);

if ($level_number <= 0) {
    $level_number = 1;
}

// ── Fallback: Resolve child_id if not posted or 0 ─────────────────────────
if ($child_id <= 0) {
    if (isset($_SESSION['role'], $_SESSION['user_id'])) {
        if ($_SESSION['role'] === 'child') {
            $child_id = (int) $_SESSION['user_id'];
        } elseif ($_SESSION['role'] === 'parent' && isset($conn) && $conn && !$conn->connect_errno) {
            $parentId = (int) $_SESSION['user_id'];
            $pStmt = $conn->prepare("SELECT child_id FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
            if ($pStmt) {
                $pStmt->bind_param("i", $parentId);
                $pStmt->execute();
                $pRes = $pStmt->get_result();
                if ($pRes && ($pRow = $pRes->fetch_assoc())) {
                    $child_id = (int) $pRow['child_id'];
                }
                $pStmt->close();
            }
        }
    }
}

if ($child_id <= 0 && isset($_SESSION['child_id']) && (int)$_SESSION['child_id'] > 0) {
    $child_id = (int)$_SESSION['child_id'];
}

// If still 0, check if there's any child in the database
if ($child_id <= 0 && isset($conn) && $conn && !$conn->connect_errno) {
    $cQuery = $conn->query("SELECT child_id FROM children ORDER BY created_at ASC LIMIT 1");
    if ($cQuery && ($cRow = $cQuery->fetch_assoc())) {
        $child_id = (int)$cRow['child_id'];
    }
}

// If database is completely offline or no child found
if ($child_id <= 0 || !isset($conn) || !($conn instanceof mysqli) || $conn->connect_errno) {
    sendJson([
        'success'         => true,
        'guest'           => true,
        'child_id'        => $child_id,
        'coins_earned'    => $coins_earned,
        'total_coins'     => $coins_earned,
        'level_number'    => $level_number,
        'level_completed' => $level_completed,
        'new_badges'      => []
    ]);
}

try {
    // 1. UPDATE CHILD'S TOTAL COINS IN WALLET (Guaranteed increment)
    if ($coins_earned > 0) {
        $updateChild = "UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?";
        $stmt = $conn->prepare($updateChild);
        if ($stmt) {
            $stmt->bind_param("ii", $coins_earned, $child_id);
            $stmt->execute();
            $stmt->close();
        }
    }
    
    // 2. UPDATE CAPYBARA-SPECIFIC LEVEL SCORES (Controls level unlocks & item counts)
    $conn->query("
        CREATE TABLE IF NOT EXISTS `capybara_level_scores` (
          `child_id` int(11) NOT NULL,
          `level_number` int(11) NOT NULL,
          `coins_earned` int(11) NOT NULL DEFAULT 0,
          `oranges_collected` int(11) NOT NULL DEFAULT 0,
          `knowledge_mastered` int(11) NOT NULL DEFAULT 0,
          `completed` tinyint(1) NOT NULL DEFAULT 0,
          `started_at` timestamp NULL DEFAULT NULL,
          `completed_at` timestamp NULL DEFAULT NULL,
          `last_played` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
          PRIMARY KEY (`child_id`, `level_number`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ");

    $updateScore = "INSERT INTO capybara_level_scores 
                    (child_id, level_number, coins_earned, oranges_collected, 
                     knowledge_mastered, completed, started_at, completed_at)
                    VALUES (?, ?, ?, ?, ?, ?, NOW(), IF(? = 1, NOW(), NULL))
                    ON DUPLICATE KEY UPDATE
                    coins_earned = GREATEST(coins_earned, VALUES(coins_earned)),
                    oranges_collected = GREATEST(oranges_collected, VALUES(oranges_collected)),
                    knowledge_mastered = GREATEST(knowledge_mastered, VALUES(knowledge_mastered)),
                    completed = IF(VALUES(completed) = 1, 1, completed),
                    completed_at = IF(VALUES(completed) = 1, NOW(), completed_at)";
    
    $stmt = $conn->prepare($updateScore);
    if ($stmt) {
        $stmt->bind_param("iiiiiii", $child_id, $level_number, $coins_earned, $oranges_collected, $knowledge_mastered, $level_completed, $level_completed);
        $stmt->execute();
        $stmt->close();
    }
    
    // 3. DUAL-WRITE TO CENTRAL `scores` TABLE (Feeds dashboard analytics views & badge checker)
    $conn->query("
        CREATE TABLE IF NOT EXISTS `scores` (
          `score_id` int(11) NOT NULL AUTO_INCREMENT,
          `child_id` int(11) NOT NULL,
          `game_id` int(11) DEFAULT NULL,
          `topic` varchar(20) NOT NULL,
          `concept` varchar(50) NOT NULL,
          `difficulty_tier_played` int(11) NOT NULL DEFAULT 1,
          `score_value` int(11) NOT NULL DEFAULT 0,
          `accuracy_percentage` decimal(5,2) DEFAULT NULL,
          `streak_achieved` int(11) DEFAULT 0,
          `coins_earned` int(11) NOT NULL DEFAULT 0,
          `date_played` timestamp NOT NULL DEFAULT current_timestamp(),
          PRIMARY KEY (`score_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ");

    $game_id  = 2; // Capybara Nepal Adventure
    $topic    = 'nepal_adventure';
    $concept  = 'Level ' . $level_number;
    $tier     = ($level_number <= 3 ? 1 : ($level_number <= 6 ? 2 : 3));
    $accuracy = ($knowledge_mastered > 0) ? round(($knowledge_mastered / 3) * 100, 2) : 100.00;
    $streak   = $knowledge_mastered;

    $scoreStmt = $conn->prepare("
        INSERT INTO scores (child_id, game_id, difficulty_tier_played, topic, concept, score_value, accuracy_percentage, streak_achieved, coins_earned, date_played)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
    ");
    if ($scoreStmt) {
        $scoreStmt->bind_param("iiissidii", $child_id, $game_id, $tier, $topic, $concept, $oranges_collected, $accuracy, $streak, $coins_earned);
        $scoreStmt->execute();
        $scoreStmt->close();
    }

    // 4. RECORD COIN TRANSACTION (Audit Trail)
    if ($level_completed == 1 && $coins_earned > 0) {
        $txnSql = "INSERT INTO coin_transactions 
                   (child_id, amount, source, description) 
                   VALUES (?, ?, 'game', ?)";
        $txnStmt = $conn->prepare($txnSql);
        if ($txnStmt) {
            $description = "Capybara Nepal Adventure - Level {$level_number} completed (+{$coins_earned} coins)";
            $txnStmt->bind_param("iis", $child_id, $coins_earned, $description);
            $txnStmt->execute();
            $txnStmt->close();
        }
    }

    // 5. CHECK AND AWARD BADGES (Evaluates criteria in badge_criteria for game_id=2)
    $newBadgeDetails = [];
    if (function_exists('checkAndAwardBadges')) {
        try {
            $newBadgeIds = checkAndAwardBadges($conn, $child_id, $game_id);
            if (!empty($newBadgeIds)) {
                $idList = implode(',', array_map('intval', $newBadgeIds));
                $badgeQuery = $conn->query("SELECT badge_id, title, description, icon_url, coins_reward FROM badges WHERE badge_id IN ($idList)");
                if ($badgeQuery) {
                    while ($badgeRow = $badgeQuery->fetch_assoc()) {
                        $newBadgeDetails[] = $badgeRow;
                    }
                }
            }
        } catch (\Throwable $e) {
            // non-critical
        }
    }

    // 6. FETCH FRESH TOTAL COIN BALANCE FROM DATABASE
    $freshTotalCoins = 0;
    $totStmt = $conn->prepare("SELECT total_coins FROM children WHERE child_id = ?");
    if ($totStmt) {
        $totStmt->bind_param("i", $child_id);
        $totStmt->execute();
        $totRes = $totStmt->get_result()->fetch_assoc();
        if ($totRes) {
            $freshTotalCoins = (int)$totRes['total_coins'];
        }
        $totStmt->close();
    }
    
    sendJson([
        'success'         => true,
        'child_id'        => $child_id,
        'coins_earned'    => $coins_earned,
        'total_coins'     => $freshTotalCoins,
        'level_number'    => $level_number,
        'level_completed' => $level_completed,
        'new_badges'      => $newBadgeDetails
    ]);
    
} catch (Exception $e) {
    sendJson([
        'success' => false,
        'error'   => 'Error: ' . $e->getMessage()
    ]);
}
?>