<?php
session_start();
$_SESSION['role'] = 'parent';
$_SESSION['user_id'] = 1;
$_SESSION['name'] = 'Test Parent';
$_SESSION['email'] = 'test@example.com';

$_SERVER['REQUEST_METHOD'] = 'POST';
$_POST['child_name'] = 'Timmy';
$_POST['child_age'] = '7';
$_POST['mascot_emoji'] = '🦉';
$_POST['mascot_name'] = 'Wise Owl';

ob_start();
include 'save_child_profile.php';
$output = ob_get_clean();
echo "OUTPUT:\n" . $output;
?>
