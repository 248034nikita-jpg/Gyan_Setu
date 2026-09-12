<?php
/**
 * save_progress.php
 * Hangman - Save in-progress game so child can continue later.
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

session_start();

$dbPath = __DIR__ . '/../../../database/includes/db_connect.php';
if (!file_exists($dbPath)) {
    echo json_encode(['success' => false, 'error' => 'Database connection not found']);
    exit;
}
require_once $dbPath;

$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
    echo json_encode(['success' => false, 'error' => 'Invalid JSON input']);
    exit;
}

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
$attempts = (int)($input['attempts'] ?? 0);
$wrongGuesses = (int)($input['wrong_guesses'] ?? 0);
$guessed = json_encode($input['guessed_letters'] ?? []);

if ($wordId <= 0) {
    echo json_encode(['success' => false, 'error' => 'Missing word_id']);
    exit;
}

// Remove any prior in-progress game for this child, then insert new
$del = $conn->prepare("DELETE FROM hangman_child_progress WHERE child_id = ? AND status = 'in_progress'");
$del->bind_param('i', $child_id);
$del->execute();
$del->close();

$save = $conn->prepare("
    INSERT INTO hangman_child_progress 
    (child_id, word_id, word, difficulty_tier, guessed_letters, attempts, wrong_guesses, status)
    VALUES (?, ?, ?, ?, ?, ?, ?, 'in_progress')
");
$save->bind_param('iisissi', $child_id, $wordId, $word, $tier, $guessed, $attempts, $wrongGuesses);
$save->execute();
$save->close();

echo json_encode(['success' => true, 'message' => 'Progress saved']);