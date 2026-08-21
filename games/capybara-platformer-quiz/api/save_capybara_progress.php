<?php

//  SAVE QUIZ PROGRESS

// What this does:
// - Saves whether the child got the answer right or wrong
// - Updates spaced repetition (wrong = 2 levels later, correct = 4 levels later)

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

// Load database connection 
require_once '../../../database/includes/db_connect.php';

// Get POST data
$input = json_decode(file_get_contents('php://input'), true);

$child_id = isset($input['child_id']) ? (int)$input['child_id'] : 1;
$content_id = isset($input['content_id']) ? (int)$input['content_id'] : 0;
$was_correct = isset($input['was_correct']) ? (bool)$input['was_correct'] : false;
$current_level = isset($input['current_level']) ? (int)$input['current_level'] : 1;

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