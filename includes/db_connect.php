<?php
    $host = 'localhost'; // Database host
    $user= 'root'; // Database username
    $password = ''; // Database password
    $db = 'gyan_setu'; // Database name

    try {
        $conn = new mysqli($host, $user, $password, $db); // Create a new MySQLi connection
    } catch (Exception $e) {
        die("Connection failed: " . $e->getMessage()); // Handle connection errors
    }
    if ($conn) {
       echo "Connected successfully"; // Connection successful message
    }
    //supoort Nepali text
    $conn->set_charset("utf8mb4"); // Set the character set to UTF-8

?>