<?php

// STEP 5: SAVE COINS TO DATABASE (FIXED)

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');

// Load database connection
require_once '../../../database/includes/db_connect.php';

// Get POST data
$input = json_decode(file_get_contents('php://input'), true);

$child_id = isset($input['child_id']) ? (int)$input['child_id'] : 1;
$total_coins = isset($input['total_coins']) ? (int)$input['total_coins'] : 0;
$level_number = isset($input['level_number']) ? (int)$input['level_number'] : 1;
$oranges_collected = isset($input['oranges_collected']) ? (int)$input['oranges_collected'] : 0;
$knowledge_mastered = isset($input['knowledge_mastered']) ? (int)$input['knowledge_mastered'] : 0;
$level_completed = isset($input['level_completed']) ? (int)$input['level_completed'] : 0;

global $conn;

if (!$conn) {
    echo json_encode(['success' => false, 'error' => 'Database connection failed']);
    exit;
}

try {

    // 1. UPDATE CHILD'S TOTAL COINS
    
    $updateChild = "UPDATE children SET total_coins = ? WHERE child_id = ?";
    $stmt = $conn->prepare($updateChild);
    $stmt->bind_param("ii", $total_coins, $child_id);
    $stmt->execute();
    
    // 2. UPDATE LEVEL SCORES (FIXED)
    
    $updateScore = "INSERT INTO capybara_level_scores 
                    (child_id, level_number, coins_earned, oranges_collected, 
                     knowledge_mastered, completed, started_at, completed_at)
                    VALUES (?, ?, ?, ?, ?, ?, NOW(), NULL)
                    ON DUPLICATE KEY UPDATE
                    coins_earned = VALUES(coins_earned),
                    oranges_collected = VALUES(oranges_collected),
                    knowledge_mastered = VALUES(knowledge_mastered),
                    completed = VALUES(completed),
                    completed_at = IF(VALUES(completed) = 1, NOW(), completed_at)";
    
    $stmt = $conn->prepare($updateScore);
    //    child_id  level  coins  oranges  knowledge  completed
    $stmt->bind_param("iiiiii", $child_id, $level_number, $total_coins, $oranges_collected, $knowledge_mastered, $level_completed);
    $stmt->execute();
    
    // 3. RECORD COIN TRANSACTION (Audit Trail)
    
    if ($level_completed == 1) {
        $txnSql = "INSERT INTO coin_transactions 
                   (child_id, amount, source, description) 
                   VALUES (?, ?, 'capybara_level_complete', ?)";
        $txnStmt = $conn->prepare($txnSql);
        $description = "Level {$level_number} completed with {$total_coins} coins, {$knowledge_mastered}/3 facts mastered";
        $txnStmt->bind_param("iis", $child_id, $total_coins, $description);
        $txnStmt->execute();
    }
    
    echo json_encode([
        'success' => true,
        'message' => 'Coins saved successfully',
        'total_coins' => $total_coins,
        'level_number' => $level_number,
        'level_completed' => $level_completed
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => 'Error: ' . $e->getMessage()
    ]);
}
?>