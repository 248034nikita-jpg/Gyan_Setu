<?php
include 'database/includes/db_connect.php';
$stmt = $conn->prepare('INSERT INTO children (username, parent_id, age, mascot_id, total_coins, current_level) VALUES (?, ?, ?, ?, 0, 1)');
if (!$stmt) {
    echo 'Prepare failed: ' . $conn->error;
} else {
    echo 'Prepare succeeded!';
}
?>
