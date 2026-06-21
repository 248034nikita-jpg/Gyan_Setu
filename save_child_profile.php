<?php
ob_start(); // buffer any stray output so JSON is never broken
session_start();
include 'database/includes/db_connect.php';

// Helper: send JSON and exit cleanly
function sendJson($status, $message, $redirect = null) {
    ob_clean(); // discard any stray output
    header('Content-Type: application/json');
    echo json_encode(['status' => $status, 'message' => $message, 'redirect' => $redirect]);
    exit();
}

// Must be logged in as a parent
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
    sendJson('error', 'Unauthorized. Please log in as a parent.');
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJson('error', 'Invalid request method.');
}

$parent_id    = $_SESSION['user_id'];
$child_name   = trim($_POST['child_name']   ?? '');
$child_age    = intval($_POST['child_age']  ?? 0);
$mascot_emoji = trim($_POST['mascot_emoji'] ?? '');
$mascot_name  = trim($_POST['mascot_name']  ?? '');

// Validate inputs
if (empty($child_name)) {
    sendJson('error', "Please enter your child's name.");
}
if ($child_age < 3 || $child_age > 17) {
    sendJson('error', "Please select a valid age (3–17).");
}
if (empty($mascot_emoji)) {
    sendJson('error', "Please pick a mascot avatar.");
}

// Build a unique username from child name + parent_id (e.g. "mani_5")
$base_username = strtolower(preg_replace('/[^a-zA-Z0-9]/', '', $child_name));
if (empty($base_username)) $base_username = 'child';
$username = $base_username . '_' . $parent_id;

// If username already taken, append a random suffix
$stmt = $conn->prepare("SELECT child_id FROM children WHERE username = ?");
$stmt->bind_param("s", $username);
$stmt->execute();
$stmt->store_result();
if ($stmt->num_rows > 0) {
    $username = $base_username . '_' . $parent_id . '_' . rand(100, 999);
}
$stmt->close();

// Insert child — no password_hash column in the children table
$stmt = $conn->prepare(
    "INSERT INTO children (username, parent_id, total_points, current_level)
     VALUES (?, ?, 0, 1)"
);
$stmt->bind_param("si", $username, $parent_id);

if ($stmt->execute()) {
    $child_id = $stmt->insert_id;
    $stmt->close();

    // Switch session so the browser lands on the child dashboard
    $_SESSION['prev_parent_id']    = $parent_id;
    $_SESSION['prev_parent_name']  = $_SESSION['name']  ?? '';
    $_SESSION['prev_parent_email'] = $_SESSION['email'] ?? '';

    $_SESSION['role']        = 'child';
    $_SESSION['user_id']     = $child_id;
    $_SESSION['username']    = $child_name;   // friendly display name
    $_SESSION['db_username'] = $username;     // DB username
    $_SESSION['parent_id']   = $parent_id;
    $_SESSION['child_age']   = $child_age;
    $_SESSION['mascot']      = $mascot_emoji;
    $_SESSION['mascot_name'] = $mascot_name;

    sendJson('success', "Welcome, $child_name! Let the learning begin!", 'child-dashboard.php');
} else {
    $err = $conn->error;
    $stmt->close();
    sendJson('error', 'Failed to create child profile: ' . $err);
}
?>
