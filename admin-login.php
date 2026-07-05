<?php
session_start();
include 'database/includes/db_connect.php';

// If already logged in as admin, redirect to admin.php
if (isset($_SESSION['role']) && $_SESSION['role'] === 'admin') {
    header('Location: admin.php');
    exit();
}

$error_msg = '';

// Handle POST sign-in
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['adminSignIn'])) {
    $identifier = trim($_POST['email_or_username'] ?? '');
    $password   = $_POST['password'] ?? '';

    if (empty($identifier) || empty($password)) {
        $error_msg = 'Please fill in all required fields.';
    } else {
        // Prepare query checking admins table for email or username
        $stmt = $conn->prepare("SELECT admin_id, username, email, password_hash FROM admins WHERE email = ? OR username = ?");
        if ($stmt) {
            $stmt->bind_param("ss", $identifier, $identifier);
            $stmt->execute();
            $result = $stmt->get_result();
            $admin = $result->fetch_assoc();
            $stmt->close();

            // Verify password using standard PHP password_verify function
            if ($admin && password_verify($password, $admin['password_hash'])) {
                session_regenerate_id(true); // Prevent session fixation
                $_SESSION['role']          = 'admin';
                $_SESSION['admin_id']      = $admin['admin_id'];
                $_SESSION['admin_username'] = $admin['username'];
                header('Location: admin/dashboard.php');
                exit();
            } else {
                $error_msg = 'Invalid Admin username/email or password.';
            }
        } else {
            $error_msg = 'Database error. Please try again later.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - Educator & Admin Sign In</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Nunito', sans-serif; }
        body {
            min-height: 100vh;
            background: #6b7fc4;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .admin-card {
            background: #ffffff;
            width: 100%;
            max-width: 440px;
            border-radius: 20px;
            padding: 40px 36px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            text-align: center;
        }

    .admin-logo-badge {
    width: 64px; 
    height: 64px;
    background: #b3da6b; 
    border-radius: 50%; 
    display: flex;
    align-items: center; 
    justify-content: center;
    margin: 0 auto 16px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* Optional softer shadow */
    overflow: hidden;
    }

    .admin-logo-badge img {
    width: 100%;
    height: 100%;
    object-fit: contain; /* Shows full logo without cropping */
    }

        .admin-card h1 { font-size: 24px; font-weight: 800; color: #1e293b; margin-bottom: 6px; }
        .admin-card p.subtitle { font-size: 13px; color: #64748b; font-weight: 600; margin-bottom: 28px; }

        .error-alert {
            background: #fef2f2; border: 1px solid #fca5a5; color: #991b1b;
            padding: 10px 14px; border-radius: 10px; font-size: 13px; font-weight: 700;
            margin-bottom: 20px; text-align: left;
        }

        .form-group { text-align: left; margin-bottom: 20px; }
        .form-group label { display: block; font-size: 12px; font-weight: 800; color: #475569; margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
        .input-wrap {
            display: flex; align-items: center; background: #f8fafc; border: 1.5px solid #cbd5e1;
            border-radius: 12px; padding: 0 14px; transition: border-color 0.2s;
        }
        .input-wrap:focus-within { border-color: #8cb43f; background: #ffffff; }
        .input-wrap span { font-size: 18px; margin-right: 10px; color: #64748b; }
        .input-wrap input {
            width: 100%; border: none; background: transparent; padding: 12px 0;
            font-size: 14px; font-weight: 700; color: #1e293b; outline: none;
        }

        .btn-submit {
            width: 100%; background: #8cb43f; color: white; border: none;
            padding: 14px; border-radius: 12px; font-size: 15px; font-weight: 800;
            cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 12px rgba(140, 180, 63, 0.3);
            margin-top: 10px;
        }
        .btn-submit:hover { background: #7a9e35; transform: translateY(-1px); }

        .footer-link { margin-top: 24px; font-size: 13px; font-weight: 700; }
        .footer-link a { color: #0284c7; text-decoration: none; }
        .footer-link a:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <div class="admin-card">
        <div class="admin-logo-badge"><img src="assets/images/logo.png" alt="logo"></div>
        <h1>Admin Portal</h1>
        <p class="subtitle">Gyan Setu System Management Control Center</p>

        <?php if (!empty($error_msg)): ?>
            <div class="error-alert">⚠️ <?php echo htmlspecialchars($error_msg); ?></div>
        <?php endif; ?>

        <form method="POST" action="admin-login.php">
            <input type="hidden" name="adminSignIn" value="1">

            <div class="form-group">
                <label>Admin Username or Email</label>
                <div class="input-wrap">
                    <input type="text" name="email_or_username" placeholder="Enter username or email" required autocomplete="username">
                </div>
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="input-wrap">
                    <input type="password" name="password" placeholder="Enter password" required autocomplete="current-password">
                </div>
            </div>

            <button type="submit" class="btn-submit">Sign In to Control Center</button>
        </form>

        <div class="footer-link">
            <a href="login.php">← Back to Main Login</a>
        </div>
    </div>

</body>
</html>
