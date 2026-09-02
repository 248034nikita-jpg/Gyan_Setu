<?php

// SAVE CAPYBARA GAME COINS AND SCORES (DUAL-WRITE)

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

// Load database connection and badge engine
require_once __DIR__ . '/../../../database/includes/db_connect.php';
require_once __DIR__ . '/../../../scores_coin.php';

// Get POST data
$input = json_decode(file_get_contents('php://input'), true);

$child_id           = isset($input['child_id']) ? (int)$input['child_id'] : 1;
$total_coins        = isset($input['total_coins']) ? (int)$input['total_coins'] : 0;
$level_number       = isset($input['level_number']) ? (int)$input['level_number'] : 1;
$oranges_collected  = isset($input['oranges_collected']) ? (int)$input['oranges_collected'] : 0;
$knowledge_mastered = isset($input['knowledge_mastered']) ? (int)$input['knowledge_mastered'] : 0;
$level_completed    = isset($input['level_completed']) ? (int)$input['level_completed'] : 0;

global $conn;

if (!$conn) {
    echo json_encode(['success' => false, 'error' => 'Database connection failed']);
    exit;
}

try {
    // 1. UPDATE CHILD'S TOTAL COINS IN WALLET
    $updateChild = "UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?";
    $stmt = $conn->prepare($updateChild);
    $stmt->bind_param("ii", $total_coins, $child_id);
    $stmt->execute();
    $stmt->close();
    
    // 2. UPDATE CAPYBARA-SPECIFIC LEVEL SCORES (Controls level unlocks & item counts)
    $updateScore = "INSERT INTO capybara_level_scores 
                    (child_id, level_number, coins_earned, oranges_collected, 
                     knowledge_mastered, completed, started_at, completed_at)
                    VALUES (?, ?, ?, ?, ?, ?, NOW(), NULL)
                    ON DUPLICATE KEY UPDATE
                    coins_earned = VALUES(coins_earned),
                    oranges_collected = VALUES(oranges_collected),
                    knowledge_mastered = VALUES(knowledge_mastered),
                    completed = VALUES(completed),
                    completed_at = IF(VALUES(completed) = 1, NOW(), completed_at)";
    
    $stmt = $conn->prepare($updateScore);
    $stmt->bind_param("iiiiii", $child_id, $level_number, $total_coins, $oranges_collected, $knowledge_mastered, $level_completed);
    $stmt->execute();
    $stmt->close();
    
    // 3. DUAL-WRITE TO CENTRAL `scores` TABLE (Feeds dashboard analytics views & badge checker)
    $game_id  = 2; // Capybara Nepal Adventure
    $topic    = 'nepal_adventure';
    $concept  = 'Level ' . $level_number;
    $tier     = ($level_number <= 3 ? 1 : ($level_number <= 6 ? 2 : 3));
    $accuracy = round(($knowledge_mastered / 3) * 100, 2);
    $streak   = $knowledge_mastered;

    $scoreStmt = $conn->prepare("
        INSERT INTO scores (child_id, game_id, difficulty_tier_played, topic, concept, score_value, accuracy_percentage, streak_achieved, coins_earned, date_played)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
    ");
    $scoreStmt->bind_param("iiissidii", $child_id, $game_id, $tier, $topic, $concept, $oranges_collected, $accuracy, $streak, $total_coins);
    $scoreStmt->execute();
    $scoreStmt->close();

    // 4. RECORD COIN TRANSACTION (Audit Trail)
    if ($level_completed == 1) {
        $txnSql = "INSERT INTO coin_transactions 
                   (child_id, amount, source, description) 
                   VALUES (?, ?, 'capybara_level_complete', ?)";
        $txnStmt = $conn->prepare($txnSql);
        $description = "Level {$level_number} completed with {$total_coins} coins, {$knowledge_mastered}/3 facts mastered";
        $txnStmt->bind_param("iis", $child_id, $total_coins, $description);
        $txnStmt->execute();
        $txnStmt->close();
    }

    // 5. CHECK AND AWARD BADGES (Evaluates criteria in badge_criteria for game_id=2)
    $newBadgeIds = checkAndAwardBadges($conn, $child_id, $game_id);
    $newBadgeDetails = [];

    if (!empty($newBadgeIds)) {
        $idList = implode(',', array_map('intval', $newBadgeIds));
        $badgeQuery = $conn->query("SELECT badge_id, title, description, icon_url, coins_reward FROM badges WHERE badge_id IN ($idList)");
        if ($badgeQuery) {
            while ($badgeRow = $badgeQuery->fetch_assoc()) {
                $newBadgeDetails[] = $badgeRow;
            }
        }
    }
    
    echo json_encode([
        'success'         => true,
        'message'         => 'Coins and scores saved successfully',
        'total_coins'     => $total_coins,
        'level_number'    => $level_number,
        'level_completed' => $level_completed,
        'new_badges'      => $newBadgeDetails
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error'   => 'Error: ' . $e->getMessage()
    ]);
}
?>