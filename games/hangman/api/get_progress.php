<?php
/**
 * get_progress.php
 * Hangman - Load saved in-progress game.
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

session_start();

$dbPath = __DIR__ . '/../../../database/includes/db_connect.php';
if (!file_exists($dbPath)) {
    echo json_encode(['success' => false, 'error' => 'Database connection not found']);
    exit;
}
require_once $dbPath;

$child_id = isset($_GET['child_id']) ? (int)$_GET['child_id'] : 0;
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
    echo json_encode(['success' => false, 'hasProgress' => false, 'error' => 'Could not resolve child']);
    exit;
}

$stmt = $conn->prepare("
    SELECT word_id, word, difficulty_tier, guessed_letters, attempts, wrong_guesses
    FROM hangman_child_progress
    WHERE child_id = ? AND status = 'in_progress'
    ORDER BY updated_at DESC
    LIMIT 1
");
$stmt->bind_param('i', $child_id);
$stmt->execute();
$row = $stmt->get_result()->fetch_assoc();
$stmt->close();

if (!$row) {
    echo json_encode(['success' => true, 'hasProgress' => false]);
    exit;
}

echo json_encode([
    'success' => true,
    'hasProgress' => true,
    'word_id' => (int)$row['word_id'],
    'word' => $row['word'],
    'difficulty_tier' => (int)$row['difficulty_tier'],
    'guessed_letters' => json_decode($row['guessed_letters'], true) ?: [],
    'attempts' => (int)$row['attempts'],
    'wrong_guesses' => (int)$row['wrong_guesses']
]);