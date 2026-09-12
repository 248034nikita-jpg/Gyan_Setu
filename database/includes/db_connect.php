<?php
    $host = 'localhost'; // Database host
    $user = 'root'; // Database username
    $password = ''; // Database password
    $db = 'gyan_setu'; // Database name

    mysqli_report(MYSQLI_REPORT_OFF);

    $conn = @new mysqli($host, $user, $password, $db); // Create a new MySQLi connection

    // Fallback: If gyan_setu is not found or connection failed, try gyansetudb
    if ($conn->connect_errno) {
        $alt_conn = @new mysqli($host, $user, $password, 'gyansetudb');
        if (!$alt_conn->connect_errno) {
            $conn = $alt_conn;
            $db = 'gyansetudb';
        }
    }

    if ($conn && !$conn->connect_errno) {
        // support Nepali text
        $conn->set_charset("utf8mb4"); // Set the character set to UTF-8
    }
?>