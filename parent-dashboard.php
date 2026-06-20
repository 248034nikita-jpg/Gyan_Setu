<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Check if logged in as Parent
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
    header("Location: index.php");
    exit();
}

$parent_id = $_SESSION['user_id'];
$parent_name = $_SESSION['name'];

$message = '';
$message_type = '';

// Handle Add Child Request
if (isset($_POST['add_child'])) {
    $child_username = trim($_POST['username']);
    $child_password = $_POST['password'];

    if (empty($child_username) || empty($child_password)) {
        $message = "Please fill in all fields.";
        $message_type = "error";
    } else {
        // Check if username already exists
        $stmt = $conn->prepare("SELECT child_id FROM children WHERE username = ?");
        $stmt->bind_param("s", $child_username);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $message = "Username already exists. Choose a different one.";
            $message_type = "error";
            $stmt->close();
        } else {
            $stmt->close();
            // Hash password securely
            $hashed_password = password_hash($child_password, PASSWORD_DEFAULT);

            $stmt = $conn->prepare("INSERT INTO children (username, password_hash, parent_id, total_points, current_level) VALUES (?, ?, ?, 0, 1)");
            $stmt->bind_param("ssi", $child_username, $hashed_password, $parent_id);

            if ($stmt->execute()) {
                $message = "Child account created successfully!";
                $message_type = "success";
            } else {
                $message = "Failed to create account. Please try again.";
                $message_type = "error";
            }
            $stmt->close();
        }
    }
}

// Fetch Children from View
$children_stats = [];
$stmt = $conn->prepare("SELECT * FROM progress_dashboard WHERE parent_name = ?");
$stmt->bind_param("s", $parent_name);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $children_stats[] = $row;
}
$stmt->close();

// Fetch Purchase History
$purchases = [];
$stmt = $conn->prepare("
    SELECT p.purchase_date, p.points_spent, c.username AS child_name, s.item_name, s.icon_url 
    FROM purchases p
    JOIN children c ON p.child_id = c.child_id
    JOIN shop_items s ON p.item_id = s.item_id
    WHERE c.parent_id = ?
    ORDER BY p.purchase_date DESC
");
$stmt->bind_param("i", $parent_id);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $purchases[] = $row;
}
$stmt->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - Parent Dashboard</title>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts Outfit -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700&display=swap" rel="family">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Outfit', sans-serif;
        }
        body {
            background-color: #f3f6f4;
            color: #333;
            min-height: 100vh;
        }
        /* Dashboard Navbar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 5%;
            background: linear-gradient(135deg, #a4cb5c, #85b035);
            color: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .navbar .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: white;
        }
        .navbar .logo img {
            width: 50px;
            height: 50px;
        }
        .navbar .logo h2 {
            font-size: 24px;
            font-weight: 700;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .user-info span {
            font-size: 16px;
            font-weight: 500;
        }
        .logout-btn {
            background: #fff;
            color: #85b035;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
        }
        .logout-btn:hover {
            background: #f0f0f0;
            transform: translateY(-2px);
        }

        /* Container & Layout */
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        /* Section Headings */
        h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #2c3e50;
            border-bottom: 2px solid #85b035;
            padding-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Card / Box Styling */
        .card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        /* Message Box */
        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
            font-size: 15px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Form Inputs */
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            font-size: 14px;
            color: #555;
        }
        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.3s;
        }
        .form-control:focus {
            border-color: #85b035;
        }
        .btn-submit {
            background-color: #85b035;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-submit:hover {
            background-color: #729d2b;
            transform: translateY(-1px);
        }

        /* Progress Grid & Table */
        .child-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        .child-card {
            background: linear-gradient(135deg, #ffffff, #fcfdfa);
            border-left: 5px solid #85b035;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            border: 1px solid #eef2eb;
            border-left: 5px solid #85b035;
        }
        .child-card h4 {
            font-size: 18px;
            color: #2c3e50;
            margin-bottom: 15px;
            text-transform: capitalize;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .stat-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
            color: #666;
        }
        .stat-row span.val {
            font-weight: 600;
            color: #333;
        }

        /* Purchase list */
        .purchase-list {
            list-style: none;
            max-height: 350px;
            overflow-y: auto;
        }
        .purchase-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
        .purchase-item:last-child {
            border-bottom: none;
        }
        .purchase-icon {
            font-size: 24px;
            background: #f0f7e4;
            padding: 6px;
            border-radius: 8px;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .purchase-details {
            flex-grow: 1;
        }
        .purchase-details p {
            font-weight: 500;
        }
        .purchase-details span {
            font-size: 12px;
            color: #888;
        }
        .purchase-price {
            font-weight: 600;
            color: #e67e22;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <header class="navbar">
        <a href="index.html" class="logo">
            <img src="assets/images/logo.png" alt="Gyan Setu Logo">
            <h2>Gyan Setu</h2>
        </a>
        <div class="user-info">
            <span><i class="fas fa-user-circle"></i> Parent: <strong><?php echo htmlspecialchars($parent_name); ?></strong></span>
            <a href="logout.php" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </header>

    <!-- MAIN BODY -->
    <div class="container">
        <!-- Left Side: Children Statistics -->
        <main>
            <div class="card">
                <h3><i class="fas fa-child"></i> Children Progress Statistics</h3>
                <?php if (empty($children_stats)): ?>
                    <p style="color: #666; font-style: italic;">No child accounts registered yet. Create one using the form on the right!</p>
                <?php else: ?>
                    <div class="child-grid">
                        <?php foreach ($children_stats as $child): ?>
                            <div class="child-card">
                                <h4><i class="fas fa-user-graduate" style="color: #85b035;"></i> <?php echo htmlspecialchars($child['child_name']); ?></h4>
                                <div class="stat-row">
                                    <span>Current Level:</span>
                                    <span class="val">Level <?php echo htmlspecialchars($child['current_level']); ?></span>
                                </div>
                                <div class="stat-row">
                                    <span>Total Points:</span>
                                    <span class="val"><?php echo htmlspecialchars($child['total_points']); ?> pts</span>
                                </div>
                                <div class="stat-row">
                                    <span>Lessons Completed:</span>
                                    <span class="val"><?php echo htmlspecialchars($child['lessons_completed']); ?></span>
                                </div>
                                <div class="stat-row">
                                    <span>Average Quiz Score:</span>
                                    <span class="val">
                                        <?php echo $child['average_quiz_score'] !== null ? round($child['average_quiz_score'], 1) . '%' : 'N/A'; ?>
                                    </span>
                                </div>
                                <div class="stat-row">
                                    <span>Coins Earned:</span>
                                    <span class="val"><?php echo htmlspecialchars($child['coin_earned']); ?> 🪙</span>
                                </div>
                                <div class="stat-row">
                                    <span>Points Spent in Shop:</span>
                                    <span class="val"><?php echo htmlspecialchars($child['total_points_spent'] !== null ? $child['total_points_spent'] : 0); ?> pts</span>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>

            <!-- Children Purchases -->
            <div class="card">
                <h3><i class="fas fa-shopping-bag"></i> Children Store Transactions</h3>
                <?php if (empty($purchases)): ?>
                    <p style="color: #666; font-style: italic;">No items purchased from the store yet.</p>
                <?php else: ?>
                    <ul class="purchase-list">
                        <?php foreach ($purchases as $p): ?>
                            <li class="purchase-item">
                                <div class="purchase-icon"><?php echo htmlspecialchars($p['icon_url']); ?></div>
                                <div class="purchase-details">
                                    <p><strong><?php echo htmlspecialchars($p['child_name']); ?></strong> purchased <strong><?php echo htmlspecialchars($p['item_name']); ?></strong></p>
                                    <span><i class="far fa-calendar-alt"></i> <?php echo htmlspecialchars($p['purchase_date']); ?></span>
                                </div>
                                <div class="purchase-price">-<?php echo htmlspecialchars($p['points_spent']); ?> pts</div>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                <?php endif; ?>
            </div>
        </main>

        <!-- Right Side: Add Child Form -->
        <aside>
            <div class="card">
                <h3><i class="fas fa-user-plus"></i> Register Child Account</h3>
                
                <?php if ($message !== ''): ?>
                    <div class="alert alert-<?php echo $message_type; ?>">
                        <i class="fas <?php echo $message_type === 'success' ? 'fa-check-circle' : 'fa-times-circle'; ?>"></i>
                        <?php echo htmlspecialchars($message); ?>
                    </div>
                <?php endif; ?>

                <form action="parent-dashboard.php" method="post">
                    <div class="form-group">
                        <label for="username">Child's Username</label>
                        <input type="text" name="username" id="username" class="form-control" placeholder="e.g. child123" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Child's Login Password</label>
                        <input type="password" name="password" id="password" class="form-control" placeholder="Create a password" required>
                    </div>
                    <button type="submit" name="add_child" class="btn-submit">
                        <i class="fas fa-plus"></i> Create Child Account
                    </button>
                </form>
            </div>
        </aside>
    </div>

</body>
</html>
