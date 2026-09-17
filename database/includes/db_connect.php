<?php
    // 1. Tell PHP to SHOUT if something goes wrong (instead of staying quiet)
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

    // 2. Your database details
    $host  = 'localhost';
    $user  = 'root';
    $password = '';
    $db = 'gyan_setu';

    // 3. TRY to connect. If it works, great. If not, jump to CATCH.
    try {
        $conn = new mysqli($host, $user, $password, $db);
        $conn->set_charset('utf8mb4'); // support Nepali text
    } 

    // 4. CATCH only runs if the connection failed
    catch (mysqli_sql_exception $e) {
        error_log('DB connection failed: ' . $e->getMessage()); // save the real error to a log file
        http_response_code(500);                                 // tell the browser "server error"
        exit('Database unavailable.');                           // stop the script
    }
?>