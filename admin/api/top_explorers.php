<?php
header('Content-Type: application/json');
session_start();

// Protection: Check if logged in as Admin
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit();
}

include '../../database/includes/db_connect.php';

$query = "
    SELECT c.username AS name, 
           c.age AS age, 
           c.total_coins AS points, 
           m.emoji_or_icon AS avatar 
    FROM children c
    LEFT JOIN mascots m ON c.mascot_id = m.mascot_id
    ORDER BY c.total_coins DESC
    LIMIT 5
";

$result = $conn->query($query);
$explorers = [];

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $explorers[] = $row;
    }
}

echo json_encode($explorers);
?>
