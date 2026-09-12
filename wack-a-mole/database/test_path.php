<?php
$dir = __DIR__;
echo "DIR: $dir\n";
echo "Candidate 1: " . dirname(__DIR__, 2) . '/database/includes/db_connect.php' . "\n";
echo "Exists 1: " . file_exists(dirname(__DIR__, 2) . '/database/includes/db_connect.php') . "\n";
?>
