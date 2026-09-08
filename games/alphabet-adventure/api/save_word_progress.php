<?php
/**
 * save_word_progress.php
 * Alphabet Adventure - Save completed word, award coins, and update scores.
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

session_start();

// Database connection & badge engine
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

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    echo json_encode(['success' => false, 'error' => 'Invalid JSON input']);
    exit;
}

// Resolve child ID from input or session
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
$word_index   = (int)($input['word_index'] ?? 0);
$word         = strtoupper(trim($input['word'] ?? ''));
$stars        = max(1, min(3, (int)($input['stars'] ?? 3)));
$mistakes     = max(0, (int)($input['mistakes'] ?? 0));
$coins_awarded = 5;

// Guest fallback
if ($child_id <= 0) {
    echo json_encode([
        'success'      => true,
        'guest'        => true,
        'coins_earned' => $coins_awarded,
        'total_coins'  => $coins_awarded,
        'new_badges'   => []
    ]);
    exit;
}

try {
    // 1. Check if this word was already completed before
    $checkStmt = $conn->prepare("SELECT stars FROM alphabet_adventure_progress WHERE child_id = ? AND level_letter = ? AND word_index = ?");
    $checkStmt->bind_param("isi", $child_id, $level_letter, $word_index);
    $checkStmt->execute();
    $existing = $checkStmt->get_result()->fetch_assoc();
    $checkStmt->close();

    $is_first_completion = ($existing === null);

    // 2. Insert or update progress record
    $progSql = "INSERT INTO alphabet_adventure_progress 
                (child_id, level_letter, word_index, word, stars, mistakes, completed, completed_at)
                VALUES (?, ?, ?, ?, ?, ?, 1, NOW())
                ON DUPLICATE KEY UPDATE
                stars = GREATEST(stars, VALUES(stars)),
                mistakes = LEAST(mistakes, VALUES(mistakes)),
                completed = 1,
                completed_at = NOW()";
    $progStmt = $conn->prepare($progSql);
    $progStmt->bind_param("isisii", $child_id, $level_letter, $word_index, $word, $stars, $mistakes);
    $progStmt->execute();
    $progStmt->close();

    // 3. Award coins (full reward on first completion, 1 coin replay encourage)
    $actual_coins = $is_first_completion ? $coins_awarded : 1;

    $coinStmt = $conn->prepare("UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?");
    $coinStmt->bind_param("ii", $actual_coins, $child_id);
    $coinStmt->execute();
    $coinStmt->close();

    // 4. Record Coin Transaction
    $desc = "Spelled '{$word}' in Level {$level_letter}" . ($is_first_completion ? "" : " (Replay)");
    $txStmt = $conn->prepare("INSERT INTO coin_transactions (child_id, amount, source, description) VALUES (?, ?, 'game', ?)");
    if ($txStmt) {
        $txStmt->bind_param("iis", $child_id, $actual_coins, $desc);
        $txStmt->execute();
        $txStmt->close();
    }

    // 5. Dual-write to central `scores` table
    $game_id = 3; // Alphabet Adventure
    $topic   = 'spelling';
    $concept = 'Level ' . $level_letter;
    $tier    = ($level_index <= 5 ? 1 : ($level_index <= 17 ? 2 : 3));
    $accuracy = ($mistakes === 0) ? 100.00 : (($mistakes === 1) ? 75.00 : (($mistakes === 2) ? 50.00 : 33.33));
    $streak  = ($mistakes === 0) ? 1 : 0;

    $scoreStmt = $conn->prepare("
        INSERT INTO scores 
        (child_id, game_id, difficulty_tier_played, topic, concept, score_value, accuracy_percentage, streak_achieved, coins_earned, date_played)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
    ");
    if ($scoreStmt) {
        $scoreStmt->bind_param("iiissidii", $child_id, $game_id, $tier, $topic, $concept, $stars, $accuracy, $streak, $actual_coins);
        $scoreStmt->execute();
        $scoreStmt->close();
    }

    // 6. Check badges (safely isolated)
    $newBadges = [];
    try {
        if (function_exists('checkAndAwardBadges')) {
            $newBadgeIds = checkAndAwardBadges($conn, $child_id, $game_id);
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

    // 7. Get fresh total coins balance
    $totStmt = $conn->prepare("SELECT total_coins FROM children WHERE child_id = ?");
    $totStmt->bind_param("i", $child_id);
    $totStmt->execute();
    $totRes = $totStmt->get_result()->fetch_assoc();
    $current_total_coins = $totRes ? (int)$totRes['total_coins'] : 0;
    $totStmt->close();

    echo json_encode([
        'success'             => true,
        'guest'               => false,
        'coins_earned'        => $actual_coins,
        'total_coins'         => $current_total_coins,
        'is_first_completion' => $is_first_completion,
        'new_badges'          => $newBadges
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error'   => $e->getMessage()
    ]);
}
