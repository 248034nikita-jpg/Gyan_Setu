<?php
include __DIR__ . '/includes/db_connect.php';
$sql = file_get_contents(__DIR__ . '/admin_setup.sql');
if ($sql) {
    if ($conn->multi_query($sql)) {
        do {
            if ($result = $conn->store_result()) {
                $result->free();
            }
        } while ($conn->more_results() && $conn->next_result());
        echo "Database tables and Admin setup completed successfully!\n";
    } else {
        echo "Error: " . $conn->error . "\n";
    }
} else {
    echo "Could not read admin_setup.sql file.\n";
}
?>
