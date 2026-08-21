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
    SELECT concat(p.first_name, ' ', p.last_name) AS parent_name, 
           psi.title AS purchased_item, 
           po.order_date AS purchased_at, 
           po.amount_paid AS cost 
    FROM parent_orders po
    JOIN parents p ON po.parent_id = p.parent_id
    JOIN parent_shop_items psi ON po.parent_item_id = psi.parent_item_id
    ORDER BY po.order_date DESC
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
