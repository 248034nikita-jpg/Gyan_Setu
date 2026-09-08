<?php
/**
 * admin/create_admin.php
 * Utility to create a new administrator account in Gyan Setu.
 * Supports both CLI execution and Browser UI.
 */
require_once __DIR__ . '/../database/includes/db_connect.php';

// CLI Mode
if (php_sapi_name() === 'cli') {
    echo "=== Gyan Setu Admin Account Creator ===\n";
    $username = $argv[1] ?? null;
    $email    = $argv[2] ?? null;
    $password = $argv[3] ?? null;
    $role     = $argv[4] ?? 'super_admin';

    if (!$username) {
        echo "Enter Username: ";
        $username = trim(fgets(STDIN));
    }
    if (!$email) {
        echo "Enter Email: ";
        $email = trim(fgets(STDIN));
    }
    if (!$password) {
        echo "Enter Password: ";
        $password = trim(fgets(STDIN));
    }

    if (empty($username) || empty($email) || empty($password)) {
        echo "Error: Username, Email, and Password cannot be empty.\n";
        exit(1);
    }

    $hash = password_hash($password, PASSWORD_BCRYPT);
    $stmt = $conn->prepare("INSERT INTO admins (username, email, password_hash, role) VALUES (?, ?, ?, ?)");
    if (!$stmt) {
        echo "Database Error: " . $conn->error . "\n";
        exit(1);
    }
    $stmt->bind_param("ssss", $username, $email, $hash, $role);
    if ($stmt->execute()) {
        echo "Success! Admin '{$username}' created successfully with role '{$role}'.\n";
    } else {
        echo "Failed to create admin: " . $stmt->error . "\n";
    }
    $stmt->close();
    exit;
}

// Browser Mode (Form)
session_start();
$message = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username'] ?? '');
    $email    = trim($_POST['email'] ?? '');
    $password = $_POST['password'] ?? '';
    $role     = $_POST['role'] ?? 'super_admin';

    $validRoles = ['super_admin', 'content_manager', 'support'];
    if (!in_array($role, $validRoles)) {
        $role = 'content_manager';
    }

    if (empty($username) || empty($email) || empty($password)) {
        $error = 'Please fill in all fields.';
    } else {
        $hash = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $conn->prepare("INSERT INTO admins (username, email, password_hash, role) VALUES (?, ?, ?, ?)");
        if ($stmt) {
            $stmt->bind_param("ssss", $username, $email, $hash, $role);
            if ($stmt->execute()) {
                $message = "Admin account '<strong>" . htmlspecialchars($username) . "</strong>' created successfully! You can now <a href='login.php' class='alert-link'>Sign In</a>.";
            } else {
                $error = "Error: " . htmlspecialchars($stmt->error);
            }
            $stmt->close();
        } else {
            $error = "Database Error: " . htmlspecialchars($conn->error);
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Admin Account - Gyan Setu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Nunito', sans-serif; background: #6b7fc4; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .card { max-width: 460px; width: 100%; border-radius: 20px; box-shadow: 0 20px 40px rgba(0,0,0,0.15); border: none; }
    </style>
</head>
<body>
    <div class="card p-4">
        <h3 class="fw-bold text-center mb-1">Create Admin Account</h3>
        <p class="text-muted text-center small mb-4">Gyan Setu Admin Management</p>

        <?php if ($message): ?>
            <div class="alert alert-success"><?php echo $message; ?></div>
        <?php endif; ?>
        <?php if ($error): ?>
            <div class="alert alert-danger"><?php echo $error; ?></div>
        <?php endif; ?>

        <form method="POST">
            <div class="mb-3">
                <label class="form-label fw-bold">Username</label>
                <input type="text" name="username" class="form-control" required placeholder="e.g. admin_ram">
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Email Address</label>
                <input type="email" name="email" class="form-control" required placeholder="e.g. ram@gyansetu.com">
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Password</label>
                <input type="password" name="password" class="form-control" required placeholder="Enter strong password">
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">Role</label>
                <select name="role" class="form-select">
                    <option value="super_admin" selected>Super Admin (Full Access)</option>
                    <option value="content_manager">Content Manager</option>
                    <option value="support">Support</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success w-100 py-2 fw-bold">Create Account</button>
            <div class="text-center mt-3">
                <a href="login.php" class="text-decoration-none small text-muted">Back to Admin Login</a>
            </div>
        </form>
    </div>
</body>
</html>
