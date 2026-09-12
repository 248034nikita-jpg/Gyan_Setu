<?php
/**
 * get_stats.php
 * Hangman - Return this child's Hangman stats.
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
    echo json_encode(['success' => false, 'error' => 'Could not resolve child']);
    exit;
}

$stmt = $conn->prepare("
    SELECT 
        COUNT(*) AS total_games,
        SUM(CASE WHEN status = 'won' THEN 1 ELSE 0 END) AS games_won,
        SUM(CASE WHEN status = 'lost' THEN 1 ELSE 0 END) AS games_lost
    FROM hangman_child_progress
    WHERE child_id = ?
");
$stmt->bind_param('i', $child_id);
$stmt->execute();
$stats = $stmt->get_result()->fetch_assoc();
$stmt->close();

$streakStmt = $conn->prepare("
    SELECT status FROM hangman_child_progress
    WHERE child_id = ? AND status IN ('won','lost')
    ORDER BY completed_at DESC
    LIMIT 50
");
$streakStmt->bind_param('i', $child_id);
$streakStmt->execute();
$rows = $streakStmt->get_result()->fetch_all(MYSQLI_ASSOC);
$streakStmt->close();

$streak = 0;
foreach ($rows as $r) {
    if ($r['status'] === 'won') $streak++;
    else break;
}

echo json_encode([
    'success' => true,
    'child_id' => $child_id,
    'total_games' => (int)$stats['total_games'],
    'games_won' => (int)$stats['games_won'],
    'games_lost' => (int)$stats['games_lost'],
    'streak' => $streak
]);