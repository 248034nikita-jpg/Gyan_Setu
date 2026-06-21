<?php
session_start();
include 'database/includes/db_connect.php';

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Helper function to return response
function sendResponse($status, $message, $redirect = null) {
    // If request is AJAX, send JSON
    $is_ajax = isset($_POST['ajax']) || (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && $_SERVER['HTTP_X_REQUESTED_WITH'] === 'XMLHttpRequest');
    if ($is_ajax) {
        header('Content-Type: application/json');
        echo json_encode([
            'status' => $status,
            'message' => $message,
            'redirect' => $redirect
        ]);
        exit();
    } else {
        // Fallback for standard forms (like index.php)
        if ($status === 'success') {
            header("Location: " . $redirect);
        } else {
            // Determine parameter name/hash based on scenario
            $hash = (strpos($message, 'registered') !== false || strpos($message, 'exists') !== false || strpos($message, 'failed') !== false) ? '#signup' : '#signIn';
            $error_code = 'registration_failed';
            if (strpos($message, 'fields') !== false) $error_code = 'empty_fields';
            elseif (strpos($message, 'email') !== false) $error_code = 'invalid_email';
            elseif (strpos($message, 'exists') !== false) $error_code = 'email_exists';
            elseif (strpos($message, 'credentials') !== false) $error_code = 'invalid_credentials';
            
            header("Location: index.php?error=" . $error_code . $hash);
        }
        exit();
    }
}

if (isset($_POST['signUp'])) {
    $fname = trim($_POST['fname']);
    $lname = trim($_POST['lname']);
    $email = trim($_POST['email']);
    $password = $_POST['password'];

    if (empty($fname) || empty($lname) || empty($email) || empty($password)) {
        sendResponse('error', 'Please fill in all the required fields.');
    }

    if (!filter_var($email, FILTER_VALIDATE_EMAIL) || !preg_match('/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/', $email)) {
        sendResponse('error', 'Please enter a valid email address.');
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
        sendResponse('error', 'Email is already registered. Please sign in.');
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
        sendResponse('success', 'Account created successfully!', 'child_profilesetuppage.php');
    } else {
        $stmt->close();
        sendResponse('error', 'Registration failed. Please try again.');
    }
}

if (isset($_POST['signIn'])) {
    // Check if username/email input name matches new or old form version
    $email_or_username = isset($_POST['email_or_username']) ? trim($_POST['email_or_username']) : (isset($_POST['email']) ? trim($_POST['email']) : '');
    $password = $_POST['password'];

    if (empty($email_or_username) || empty($password)) {
        sendResponse('error', 'Please fill in all the required fields.');
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
                sendResponse('success', 'Logged in successfully!', 'child-dashboard.php');
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
                sendResponse('success', 'Logged in successfully!', 'child-dashboard.php');
            }
        }
        $stmt->close();
    }

    // If we reach here, authentication failed
    sendResponse('error', 'Invalid email/username or password.');
}

// Redirect back to index if accessed directly without POST
header("Location: index.html");
exit();
?>
