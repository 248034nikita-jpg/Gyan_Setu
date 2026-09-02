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

$stats = [
    'total_learners' => 0,
    'total_questions' => 0,
    'total_items' => 0,
    'total_sales' => 0
];

// Total Learners from children table
$res = $conn->query("SELECT COUNT(*) AS total FROM children");
if ($res && $row = $res->fetch_assoc()) {
    $stats['total_learners'] = (int)$row['total'];
}

// Question Pool from quiz_questions table
$res = $conn->query("SELECT COUNT(*) AS total FROM quiz_questions");
if ($res && $row = $res->fetch_assoc()) {
    $stats['total_questions'] = (int)$row['total'];
}

// Store items from shop_items and parent_shop_items
$res = $conn->query("SELECT (SELECT COUNT(*) FROM shop_items) + (SELECT COUNT(*) FROM parent_shop_items) AS total");
if ($res && $row = $res->fetch_assoc()) {
    $stats['total_items'] = (int)$row['total'];
}

// Completed sales from child purchases and completed parent orders
$res = $conn->query("SELECT (SELECT COUNT(*) FROM purchases) + (SELECT COUNT(*) FROM parent_orders WHERE order_status = 'Completed') AS total");
if ($res && $row = $res->fetch_assoc()) {
    $stats['total_sales'] = (int)$row['total'];
}

echo json_encode($stats);
?>
