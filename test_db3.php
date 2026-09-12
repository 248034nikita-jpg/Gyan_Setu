<?php
include 'database/includes/db_connect.php';
$res = $conn->query("SHOW TABLES LIKE 'purchases'");
echo 'Purchases table exists: ' . ($res->num_rows > 0 ? 'yes' : 'no') . "\n";
$res2 = $conn->query("SHOW TABLES LIKE 'shop_items'");
echo 'Shop items table exists: ' . ($res2->num_rows > 0 ? 'yes' : 'no') . "\n";
?>
