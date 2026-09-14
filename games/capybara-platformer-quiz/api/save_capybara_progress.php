<?php
ob_start();
error_reporting(0);
ini_set('display_errors', '0');

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

// Load database connection 
$root = dirname(dirname(dirname(__DIR__)));
require_once $root . '/database/includes/db_connect.php';

// Get POST data
$input = json_decode(file_get_contents('php://input'), true);

$child_id      = (int)($input['child_id'] ?? $_POST['child_id'] ?? 0);
$content_id    = (int)($input['content_id'] ?? $_POST['content_id'] ?? 0);
$was_correct   = (bool)($input['was_correct'] ?? $_POST['was_correct'] ?? false);
$current_level = (int)($input['current_level'] ?? $_POST['current_level'] ?? 1);

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

if ($child_id <= 0 && isset($conn) && $conn && !$conn->connect_errno) {
    $cQuery = $conn->query("SELECT child_id FROM children ORDER BY created_at ASC LIMIT 1");
    if ($cQuery && ($cRow = $cQuery->fetch_assoc())) {
        $child_id = (int)$cRow['child_id'];
    }
}

if ($child_id <= 0) {
    $child_id = 1;
}

// Check if content_id is provided
if ($content_id == 0) {
    echo json_encode(['success' => false, 'error' => 'Missing content_id']);
    exit;
}

// Check database connection
global $conn;

if (!$conn) {
    echo json_encode(['success' => false, 'error' => 'Database connection failed']);
    exit;
}

try {
    // Calculate next review level
    // Wrong = 2 levels later, Correct = 4 levels later
    $nextReview = $was_correct ? $current_level + 4 : $current_level + 2;
    $correctBonus = $was_correct ? 1 : 0;
    
    // Check if progress already exists
    $checkSql = "SELECT * FROM capybara_child_progress 
                 WHERE child_id = ? AND content_id = ?";
    $checkStmt = $conn->prepare($checkSql);
    $checkStmt->bind_param("ii", $child_id, $content_id);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();
    $existing = $checkResult->fetch_assoc();
    
    if ($existing) {
        // UPDATE existing progress
        $updateSql = "UPDATE capybara_child_progress 
                      SET attempts = attempts + 1,
                          correct_attempts = correct_attempts + ?,
                          last_seen_level = ?,
                          next_review_level = ?,
                          last_attempt_at = NOW()
                      WHERE child_id = ? AND content_id = ?";
        $updateStmt = $conn->prepare($updateSql);
        $updateStmt->bind_param("iiiii", $correctBonus, $current_level, $nextReview, $child_id, $content_id);
        $updateStmt->execute();
        
        $message = "Progress updated";
    } else {
        // INSERT new progress
        $insertSql = "INSERT INTO capybara_child_progress 
                      (child_id, content_id, attempts, correct_attempts, last_seen_level, next_review_level, last_attempt_at)
                      VALUES (?, ?, 1, ?, ?, ?, NOW())";
        $insertStmt = $conn->prepare($insertSql);
        $insertStmt->bind_param("iiiii", $child_id, $content_id, $correctBonus, $current_level, $nextReview);
        $insertStmt->execute();
        
        $message = "Progress created";
    }
    
    echo json_encode([
        'success' => true,
        'message' => $message,
        'next_review_level' => $nextReview,
        'was_correct' => $was_correct
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => 'Error: ' . $e->getMessage()
    ]);
}
?>