<?php
session_start();
session_unset();
session_destroy();

// Allow a safe redirect target (whitelist only known pages)
$allowed = ['signup', 'login', 'index'];
$target = $_GET['redirect'] ?? 'index';
if (!in_array($target, $allowed)) $target = 'index';

$dest = ($target === 'index') ? 'index.php' : $target . '.php';
header("Location: $dest");
exit();
?>
