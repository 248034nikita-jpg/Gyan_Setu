<?php

// CHECK IF LEVEL IS UNLOCKED

// Input: child_id, level
// Output: JSON with unlock status

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Load database connection
require_once '../../../database/includes/db_connect.php';

// Get parameters
$child_id = isset($_GET['child_id']) ? (int)$_GET['child_id'] : 1;
$level = isset($_GET['level']) ? (int)$_GET['level'] : 1;

global $conn;

if (!$conn) {
    echo json_encode(['success' => false, 'error' => 'Database connection failed']);
    exit;
}

try {
    // Level 1 is always unlocked
    if ($level == 1) {
        echo json_encode([
            'success' => true,
            'unlocked' => true,
            'level' => $level,
            'message' => 'Level 1 is always unlocked'
        ]);
        exit;
    }
    
    // Check if previous level is completed
    $prevLevel = $level - 1;
    $sql = "SELECT completed FROM capybara_level_scores 
            WHERE child_id = ? AND level_number = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $child_id, $prevLevel);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    
    $unlocked = ($row && $row['completed'] == 1);
    
    echo json_encode([
        'success' => true,
        'unlocked' => $unlocked,
        'level' => $level,
        'previous_level' => $prevLevel,
        'previous_level_completed' => $unlocked ? true : false,
        'message' => $unlocked ? 'Level unlocked!' : 'Complete previous level first'
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => 'Error: ' . $e->getMessage()
    ]);
}
?>