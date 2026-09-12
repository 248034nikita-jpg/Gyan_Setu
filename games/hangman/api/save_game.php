<?php
/**
 * save_game.php
 * Hangman - Save completed game, award coins, update child progress.
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

// Resolve child_id (same pattern as other games)
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
            if ($cRes) $child_id = (int)$cRes['child_id'];
            $cStmt->close();
        }
    }
}

if ($child_id <= 0) {
    echo json_encode(['success' => false, 'error' => 'Could not resolve child']);
    exit;
}

$wordId = (int)($input['word_id'] ?? 0);
$word = $input['word'] ?? '';
$tier = (int)($input['difficulty_tier'] ?? 1);
$status = $input['status'] ?? 'lost';
$attempts = (int)($input['attempts'] ?? 0);
$wrongGuesses = (int)($input['wrong_guesses'] ?? 0);
$correctCount = (int)($input['correct_count'] ?? 0);
$totalLetters = (int)($input['total_letters'] ?? 0);

if ($wordId <= 0 || $word === '') {
    echo json_encode(['success' => false, 'error' => 'Missing word data']);
    exit;
}

// Stars: 3 = no mistakes, 2 = 1-2 mistakes, 1 = 3+ mistakes
$stars = 1;
if ($wrongGuesses === 0) $stars = 3;
elseif ($wrongGuesses <= 2) $stars = 2;

// 1. Save the finished game to hangman_child_progress
$save = $conn->prepare("
    INSERT INTO hangman_child_progress 
    (child_id, word_id, word, difficulty_tier, guessed_letters, attempts, wrong_guesses, status, stars, completed_at)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
");
$guessed = json_encode($input['guessed_letters'] ?? []);
$save->bind_param('iisissisi', $child_id, $wordId, $word, $tier, $guessed, $attempts, $wrongGuesses, $status, $stars);
$save->execute();
$save->close();

// 2. Remove any in-progress row for this word
$del = $conn->prepare("DELETE FROM hangman_child_progress WHERE child_id = ? AND word_id = ? AND status = 'in_progress'");
$del->bind_param('ii', $child_id, $wordId);
$del->execute();
$del->close();

$coinsEarned = 0;
$newBadges = [];

// 3. Award coins ONLY if child won
if ($status === 'won' && function_exists('saveRoundAndAwardCoins')) {
    $gameId = 22; // Hangman's game_id in `games` table

    $result = saveRoundAndAwardCoins(
        $conn,
        $child_id,
        $gameId,
        $tier,
        'hangman',
        strtoupper($word),
        $correctCount,
        $totalLetters,
        $correctCount
    );
    $coinsEarned = $result['coins_earned'] ?? 0;
    $newBadges = $result['new_badges'] ?? [];
}

echo json_encode([
    'success' => true,
    'status' => $status,
    'stars' => $stars,
    'coins_earned' => $coinsEarned,
    'new_badges' => $newBadges
]);