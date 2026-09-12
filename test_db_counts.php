<?php
include 'database/includes/db_connect.php';
$tables = ['badges', 'shop_items'];
foreach($tables as $t) {
    $res = $conn->query("SELECT count(*) as c FROM $t");
    if($res) {
        $row = $res->fetch_assoc();
        echo "$t count: " . $row['c'] . "\n";
    } else {
        echo "Error $t: " . $conn->error . "\n";
    }
}
?>
