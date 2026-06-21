<?php
session_start();
include 'database/includes/db_connect.php';

// Security: Only allow access from a logged-in child session
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'child') {
    header("Location: login.php");
    exit();
}

// The child must have a parent_id stored in the session
if (!isset($_SESSION['parent_id']) || empty($_SESSION['parent_id'])) {
    // Fallback: try to fetch parent_id from DB using child_id
    $child_id = $_SESSION['user_id'];
    $stmt = $conn->prepare("SELECT parent_id FROM children WHERE child_id = ?");
    $stmt->bind_param("i", $child_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $row = $res->fetch_assoc();
    $stmt->close();

    if (!$row || empty($row['parent_id'])) {
        // No parent linked to this child
        header("Location: child-dashboard.php?error=no_parent");
        exit();
    }
    $parent_id = $row['parent_id'];
} else {
    $parent_id = $_SESSION['parent_id'];
}

// Fetch the parent's details
$stmt = $conn->prepare("SELECT parent_id, full_name, email FROM parents WHERE parent_id = ?");
$stmt->bind_param("i", $parent_id);
$stmt->execute();
$res = $stmt->get_result();
$parent = $res->fetch_assoc();
$stmt->close();

if (!$parent) {
    // Parent record not found
    header("Location: child-dashboard.php?error=parent_not_found");
    exit();
}

// Store previous child session so we can restore it later if needed
$_SESSION['prev_child_id']       = $_SESSION['user_id'];
$_SESSION['prev_child_username'] = $_SESSION['username'] ?? '';
$_SESSION['prev_child_parent_id']= $_SESSION['parent_id'] ?? null;

// Elevate session to parent
$_SESSION['role']    = 'parent';
$_SESSION['user_id'] = $parent['parent_id'];
$_SESSION['name']    = $parent['full_name'];
$_SESSION['email']   = $parent['email'];

// Redirect to the real parent dashboard
header("Location: parent-dashboard.php");
exit();
?>
