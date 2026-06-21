<?php
session_start();
include 'database/includes/db_connect.php';

// Must be logged in as a parent to create a child profile
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
    header('Content-Type: application/json');
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized. Please log in as a parent.']);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Content-Type: application/json');
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
    exit();
}

$parent_id    = $_SESSION['user_id'];
$child_name   = trim($_POST['child_name']   ?? '');
$child_age    = intval($_POST['child_age']  ?? 0);
$mascot_emoji = trim($_POST['mascot_emoji'] ?? '');
$mascot_name  = trim($_POST['mascot_name']  ?? '');

// Validate
if (empty($child_name)) {
    echo json_encode(['status' => 'error', 'message' => "Please enter your child's name."]);
    exit();
}
if ($child_age < 3 || $child_age > 17) {
    echo json_encode(['status' => 'error', 'message' => "Please select a valid age (3–17)."]);
    exit();
}
if (empty($mascot_emoji)) {
    echo json_encode(['status' => 'error', 'message' => "Please pick a mascot avatar."]);
    exit();
}

// Build a unique username from child name + parent_id (e.g., "Ram_42")
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

// Insert child (no password needed — password_hash set to empty string, field kept for schema compat)
$placeholder_hash = '';   // Password not used for child login
$stmt = $conn->prepare(
    "INSERT INTO children (username, password_hash, parent_id, total_points, current_level) 
     VALUES (?, ?, ?, 0, 1)"
);
$stmt->bind_param("ssi", $username, $placeholder_hash, $parent_id);

if ($stmt->execute()) {
    $child_id = $stmt->insert_id;
    $stmt->close();

    // Switch session to this child
    $_SESSION['prev_parent_id']   = $parent_id;
    $_SESSION['prev_parent_name'] = $_SESSION['name'] ?? '';
    $_SESSION['prev_parent_email']= $_SESSION['email'] ?? '';

    $_SESSION['role']      = 'child';
    $_SESSION['user_id']   = $child_id;
    $_SESSION['username']  = $child_name;   // Display name (friendly)
    $_SESSION['db_username']= $username;    // DB username
    $_SESSION['parent_id'] = $parent_id;
    $_SESSION['child_age'] = $child_age;
    $_SESSION['mascot']    = $mascot_emoji;
    $_SESSION['mascot_name']= $mascot_name;

    header('Content-Type: application/json');
    echo json_encode([
        'status'   => 'success',
        'message'  => "Welcome, $child_name! Let the learning begin!",
        'redirect' => 'child-dashboard.php'
    ]);
} else {
    $stmt->close();
    header('Content-Type: application/json');
    echo json_encode(['status' => 'error', 'message' => 'Failed to create child profile. Please try again.']);
}
?>
