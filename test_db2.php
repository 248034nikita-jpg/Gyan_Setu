<?php
include 'database/includes/db_connect.php';
$res = $conn->query("SELECT mascot_id, name FROM mascots");
if (!$res) echo "Error: " . $conn->error;
else {
    while($row = $res->fetch_assoc()){
        print_r($row);
    }
}
?>
