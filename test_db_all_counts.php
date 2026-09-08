<?php
include 'database/includes/db_connect.php';
$res = $conn->query("SHOW TABLES");
while($row = $res->fetch_array()) {
    $table = $row[0];
    $countRes = $conn->query("SELECT count(*) as c FROM `$table`");
    if($countRes) {
        $c = $countRes->fetch_assoc()['c'];
        echo "$table: $c\n";
    }
}
?>
