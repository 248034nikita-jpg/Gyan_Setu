<?php
/**
 * submit_score.php
 * Receives the game result from the Phaser Whack-a-Mole game,
 * saves score/coins via scores_coin.php, and returns JSON with results.
 * 
 * POST params:
 *   child_id, game_id, tier, topic, concept, correct_count, total_questions, streak
 */
header('Content-Type: application/json');

// Resolve paths
$root = realpath(__DIR__ . '/../../');
$dbPath = $root . '/database/includes/db_connect.php';
$scPath = $root . '/scores_coin.php';

if (!file_exists($dbPath) || !file_exists($scPath)) {
    echo json_encode(['error' => 'Backend files not found', 'dbPath' => $dbPath]);
    exit;
}

include $dbPath;
include $scPath;

// Collect POST inputs
$childId       = intval($_POST['child_id']       ?? 0);
$gameId        = intval($_POST['game_id']        ?? 1);
$tier          = intval($_POST['tier']           ?? 1);
$topic         = trim($_POST['topic']            ?? 'grammar');
$concept       = trim($_POST['concept']          ?? '');
$correctCount  = intval($_POST['correct_count']  ?? 0);
$totalQs       = intval($_POST['total_questions'] ?? 10);
$streak        = intval($_POST['streak']         ?? 0);

if ($childId <= 0 || $totalQs <= 0) {
    // No session — return a guest result without saving to DB
    $accuracy = $totalQs > 0 ? round(($correctCount / $totalQs) * 100, 1) : 0;
    echo json_encode([
        'coins_earned' => $correctCount * $tier,
        'accuracy'     => $accuracy,
        'new_badges'   => [],
        'guest'        => true
    ]);
    exit;
}

// Save round and award coins
$result = saveRoundAndAwardCoins($conn, $childId, $gameId, $tier, $topic, $concept, $correctCount, $totalQs, $streak);

// Fetch badge titles for newly earned badges
$badgeDetails = [];
if (!empty($result['new_badges'])) {
    $ids = implode(',', array_map('intval', $result['new_badges']));
    $bRes = $conn->query("SELECT title, icon_url FROM badges WHERE badge_id IN ($ids)");
    while ($b = $bRes->fetch_assoc()) {
        $badgeDetails[] = $b;
    }
}

echo json_encode([
    'coins_earned'  => $result['coins_earned'],
    'accuracy'      => $result['accuracy'],
    'new_badges'    => $badgeDetails,
    'correct_count' => $correctCount,
    'total_questions' => $totalQs
]);
?>
