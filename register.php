<?php
session_start();
include 'database/includes/db_connect.php';

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

if (isset($_POST['signUp'])) {
    $fname = trim($_POST['fname']);
    $lname = trim($_POST['lname']);
    $email = trim($_POST['email']);
    $password = $_POST['password'];

    if (empty($fname) || empty($lname) || empty($email) || empty($password)) {
        header("Location: index.php?error=empty_fields#signup");
        exit();
    }

    // Combine names
    $fullname = $fname . ' ' . $lname;

    // Check if email already exists
    $stmt = $conn->prepare("SELECT parent_id FROM parents WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->close();
        header("Location: index.php?error=email_exists#signup");
        exit();
    }
    $stmt->close();

    // Hash password securely
    $password_hash = password_hash($password, PASSWORD_DEFAULT);

    // Insert new parent
    $stmt = $conn->prepare("INSERT INTO parents (full_name, email, password_hash) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $fullname, $email, $password_hash);

    if ($stmt->execute()) {
        $_SESSION['role'] = 'parent';
        $_SESSION['user_id'] = $stmt->insert_id;
        $_SESSION['name'] = $fullname;
        $_SESSION['email'] = $email;

        $stmt->close();
        header("Location: parent-dashboard.php");
        exit();
    } else {
        $stmt->close();
        header("Location: index.php?error=registration_failed#signup");
        exit();
    }
}

if (isset($_POST['signIn'])) {
    // Check if username/email input name matches new or old form version
    $email_or_username = isset($_POST['email_or_username']) ? trim($_POST['email_or_username']) : (isset($_POST['email']) ? trim($_POST['email']) : '');
    $password = $_POST['password'];

    if (empty($email_or_username) || empty($password)) {
        header("Location: index.php?error=empty_fields#signIn");
        exit();
    }

    // Detect if logging in as Parent (contains @) or Child (does not contain @)
    if (strpos($email_or_username, '@') !== false) {
        // Parent Auth
        $stmt = $conn->prepare("SELECT parent_id, full_name, email, password_hash FROM parents WHERE email = ?");
        $stmt->bind_param("s", $email_or_username);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($row = $res->fetch_assoc()) {
            if (password_verify($password, $row['password_hash'])) {
                $_SESSION['role'] = 'parent';
                $_SESSION['user_id'] = $row['parent_id'];
                $_SESSION['name'] = $row['full_name'];
                $_SESSION['email'] = $row['email'];

                $stmt->close();
                header("Location: parent-dashboard.php");
                exit();
            }
        }
        $stmt->close();
    } else {
        // Child Auth
        $stmt = $conn->prepare("SELECT child_id, username, password_hash, parent_id FROM children WHERE username = ?");
        $stmt->bind_param("s", $email_or_username);
        $stmt->execute();
        $res = $stmt->get_result();

        if ($row = $res->fetch_assoc()) {
            if (password_verify($password, $row['password_hash'])) {
                $_SESSION['role'] = 'child';
                $_SESSION['user_id'] = $row['child_id'];
                $_SESSION['username'] = $row['username'];
                $_SESSION['parent_id'] = $row['parent_id'];

                $stmt->close();
                header("Location: child-dashboard.php");
                exit();
            }
        }
        $stmt->close();
    }

    // If we reach here, authentication failed
    header("Location: index.php?error=invalid_credentials#signIn");
    exit();
}

// Redirect back to index if accessed directly without POST
header("Location: index.php");
exit();
?>
