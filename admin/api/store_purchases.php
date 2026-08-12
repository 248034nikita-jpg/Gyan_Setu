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
    SELECT c.username AS child_name, 
           si.icon_url AS reward_icon, 
           si.item_name AS reward_name, 
           p.purchase_date AS purchased_at, 
           p.coins_spent AS cost 
    FROM purchases p
    JOIN children c ON p.child_id = c.child_id
    JOIN shop_items si ON p.item_id = si.item_id
    ORDER BY p.purchase_date DESC
";

$result = $conn->query($query);
$purchases = [];

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $purchases[] = $row;
    }
}

echo json_encode($purchases);
?>
