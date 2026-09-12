<?php
include 'database/includes/db_connect.php';
$res = $conn->query("SELECT * FROM mascots WHERE mascot_id=1");
print_r($res->fetch_assoc());
?>
