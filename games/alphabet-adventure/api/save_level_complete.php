<?php
/**
 * save_level_complete.php
 * Alphabet Adventure - Save whole level completion and award bonus coins.
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

session_start();

$dbPath = __DIR__ . '/../../../database/includes/db_connect.php';
$scPath = __DIR__ . '/../../../scores_coin.php';

if (!file_exists($dbPath)) {
    echo json_encode(['success' => false, 'error' => 'Database connection not found']);
    exit;
}
require_once $dbPath;

if (file_exists($scPath)) {
    @include_once $scPath;
}

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    echo json_encode(['success' => false, 'error' => 'Invalid JSON input']);
    exit;
}

// Resolve child ID
$child_id = isset($input['child_id']) ? (int)$input['child_id'] : 0;
if ($child_id <= 0 && isset($_SESSION['user_id']) && isset($_SESSION['role'])) {
    if ($_SESSION['role'] === 'child') {
        $child_id = (int)$_SESSION['user_id'];
    } elseif ($_SESSION['role'] === 'parent') {
        $parentId = (int)$_SESSION['user_id'];
        $cStmt = $conn->prepare("SELECT child_id FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
        if ($cStmt) {
            $cStmt->bind_param("i", $parentId);
            $cStmt->execute();
            $cRes = $cStmt->get_result()->fetch_assoc();
            if ($cRes) {
                $child_id = (int)$cRes['child_id'];
            }
            $cStmt->close();
        }
    }
}

$level_letter = strtoupper(trim($input['level_letter'] ?? 'A'));
$level_index  = (int)($input['level_index'] ?? 0);
$bonus_coins  = max(0, (int)($input['bonus_coins'] ?? 50));

if ($child_id <= 0) {
    echo json_encode([
        'success'      => true,
        'guest'        => true,
        'bonus_coins'  => $bonus_coins,
        'new_badges'   => []
    ]);
    exit;
}

try {
    // 1. Check if level was already completed before
    $checkStmt = $conn->prepare("SELECT is_completed FROM alphabet_adventure_levels WHERE child_id = ? AND level_index = ?");
    $checkStmt->bind_param("ii", $child_id, $level_index);
    $checkStmt->execute();
    $existing = $checkStmt->get_result()->fetch_assoc();
    $checkStmt->close();

    $is_first_level_complete = ($existing === null || (int)$existing['is_completed'] === 0);

    // 2. Insert or update level record
    $lvlSql = "INSERT INTO alphabet_adventure_levels 
               (child_id, level_index, level_letter, is_completed, bonus_coins_awarded, completed_at)
               VALUES (?, ?, ?, 1, ?, NOW())
               ON DUPLICATE KEY UPDATE
               is_completed = 1,
               completed_at = NOW()";
    $lvlStmt = $conn->prepare($lvlSql);
    $lvlStmt->bind_param("iisi", $child_id, $level_index, $level_letter, $bonus_coins);
    $lvlStmt->execute();
    $lvlStmt->close();

    $awarded = 0;
    if ($is_first_level_complete) {
        $awarded = $bonus_coins;

        // 3. Award bonus coins to child balance
        $coinStmt = $conn->prepare("UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?");
        $coinStmt->bind_param("ii", $awarded, $child_id);
        $coinStmt->execute();
        $coinStmt->close();

        // 4. Record coin transaction
        $desc = "Completed Level {$level_letter} in Alphabet Adventure";
        $txStmt = $conn->prepare("INSERT INTO coin_transactions (child_id, amount, source, description) VALUES (?, ?, 'game', ?)");
        if ($txStmt) {
            $txStmt->bind_param("iis", $child_id, $awarded, $desc);
            $txStmt->execute();
            $txStmt->close();
        }

        // 5. Dual-write to scores
        $game_id = 3;
        $topic   = 'spelling';
        $concept = 'Level ' . $level_letter . ' Complete';
        $tier    = ($level_index <= 5 ? 1 : ($level_index <= 17 ? 2 : 3));
        $scoreStmt = $conn->prepare("
            INSERT INTO scores 
            (child_id, game_id, difficulty_tier_played, topic, concept, score_value, accuracy_percentage, streak_achieved, coins_earned, date_played)
            VALUES (?, ?, ?, ?, ?, 15, 100.00, 15, ?, NOW())
        ");
        if ($scoreStmt) {
            $scoreStmt->bind_param("iiissi", $child_id, $game_id, $tier, $topic, $concept, $awarded);
            $scoreStmt->execute();
            $scoreStmt->close();
        }
    }

    // 6. Check badges (safely isolated)
    $newBadges = [];
    try {
        if (function_exists('checkAndAwardBadges')) {
            $newBadgeIds = checkAndAwardBadges($conn, $child_id, 3);
            if (!empty($newBadgeIds)) {
                $ids = implode(',', array_map('intval', $newBadgeIds));
                $bRes = $conn->query("SELECT badge_id, title, icon_url, coins_reward FROM badges WHERE badge_id IN ($ids)");
                if ($bRes) {
                    while ($bRow = $bRes->fetch_assoc()) {
                        $newBadges[] = $bRow;
                    }
                }
            }
        }
    } catch (\Throwable $be) {
        error_log("Alphabet adventure badge check note: " . $be->getMessage());
    }

    // 7. Get fresh total coins
    $totStmt = $conn->prepare("SELECT total_coins FROM children WHERE child_id = ?");
    $totStmt->bind_param("i", $child_id);
    $totStmt->execute();
    $totRes = $totStmt->get_result()->fetch_assoc();
    $current_total_coins = $totRes ? (int)$totRes['total_coins'] : 0;
    $totStmt->close();

    echo json_encode([
        'success'                 => true,
        'guest'                   => false,
        'bonus_coins_earned'      => $awarded,
        'total_coins'             => $current_total_coins,
        'is_first_level_complete' => $is_first_level_complete,
        'new_badges'              => $newBadges
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error'   => $e->getMessage()
    ]);
}
