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

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method Not Allowed']);
    exit();
}

$item_name   = trim($_POST['item_name'] ?? '');
$description = trim($_POST['description'] ?? '');
$price_coins = intval($_POST['price_coins'] ?? $_POST['price'] ?? 0);
$icon_url    = trim($_POST['icon_url'] ?? $_POST['icon'] ?? '🎁');

if (empty($item_name)) {
    http_response_code(400);
    echo json_encode(['error' => 'Item title is required.']);
    exit();
}

if ($price_coins <= 0) {
    $price_coins = 10;
}

$stmt = $conn->prepare("INSERT INTO shop_items (item_name, description, price_coins, icon_url) VALUES (?, ?, ?, ?)");

if (!$stmt) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $conn->error]);
    exit();
}

$stmt->bind_param("ssis", $item_name, $description, $price_coins, $icon_url);

if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to save store item: ' . $stmt->error]);
    $stmt->close();
    exit();
}

$item_id = $conn->insert_id;
$stmt->close();

echo json_encode([
    'success' => true,
    'message' => 'Store item listed successfully.',
    'item_id' => $item_id
]);
?>
