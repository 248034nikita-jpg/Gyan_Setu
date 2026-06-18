<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Check if logged in as Child
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'child') {
    header("Location: index.php");
    exit();
}

$child_id = $_SESSION['user_id'];
$username = $_SESSION['username'];

// Handle Purchase Request
if (isset($_GET['buy_item'])) {
    $item_id = intval($_GET['buy_item']);

    // 1. Fetch item details
    $stmt = $conn->prepare("SELECT price_points, item_name FROM shop_items WHERE item_id = ?");
    $stmt->bind_param("i", $item_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $item = $res->fetch_assoc();
    $stmt->close();

    if ($item) {
        $price = $item['price_points'];
        $name = $item['item_name'];

        // 2. Fetch child's current points
        $stmt = $conn->prepare("SELECT total_points FROM children WHERE child_id = ?");
        $stmt->bind_param("i", $child_id);
        $stmt->execute();
        $res = $stmt->get_result();
        $child_data = $res->fetch_assoc();
        $stmt->close();

        $points = $child_data['total_points'];

        if ($points >= $price) {
            // 3. Deduct points
            $stmt = $conn->prepare("UPDATE children SET total_points = total_points - ? WHERE child_id = ?");
            $stmt->bind_param("ii", $price, $child_id);
            $stmt->execute();
            $stmt->close();

            // 4. Record purchase
            $stmt = $conn->prepare("INSERT INTO purchases (child_id, item_id, points_spent) VALUES (?, ?, ?)");
            $stmt->bind_param("iii", $child_id, $item_id, $price);
            $stmt->execute();
            $stmt->close();

            $_SESSION['shop_alert'] = "🎉 Successfully bought '$name'!";
            $_SESSION['shop_alert_type'] = "success";
        } else {
            $_SESSION['shop_alert'] = "❌ Not enough points for '$name'!";
            $_SESSION['shop_alert_type'] = "error";
        }
    }
    header("Location: shop.php");
    exit();
}

// Fetch Child Points
$stmt = $conn->prepare("SELECT total_points FROM children WHERE child_id = ?");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
$child_info = $res->fetch_assoc();
$stmt->close();
$total_points = $child_info['total_points'];

// Fetch Items from Database
$shop_items = [];
$res = $conn->query("SELECT * FROM shop_items");
while ($row = $res->fetch_assoc()) {
    $shop_items[] = $row;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - Store</title>
    <!-- Stylesheet -->
    <link rel="stylesheet" href="css/shop.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Modern Alerts for Shop Purchases */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
        .toast {
            padding: 15px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            color: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            animation: slideIn 0.3s ease-out;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .toast-success {
            background-color: #2ecc71;
            border-left: 5px solid #27ae60;
        }
        .toast-error {
            background-color: #e74c3c;
            border-left: 5px solid #c0392b;
        }
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        /* Adjustments for shop grid and buttons */
        .worksheet-card {
            border: 1px solid #eee;
            border-radius: 12px;
            background: white;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            height: 250px;
        }
        .worksheet-card p {
            font-weight: bold;
            color: #333;
            margin: 10px 0;
            font-size: 15px;
        }
        .worksheet-card button {
            background-color: #85b035;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: bold;
            cursor: pointer;
            width: 80%;
            transition: all 0.3s;
        }
        .worksheet-card button:hover {
            background-color: #729d2b;
            transform: translateY(-2px);
        }
        .worksheet-card .coin-icon {
            display: flex;
            align-items: center;
            gap: 5px;
            background: #fff9e6;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 600;
            color: #d4ac0d;
            font-size: 13px;
        }
        .worksheet-card .coin-icon img {
            width: 14px;
            height: 14px;
        }
        .worksheet-image {
            font-size: 36px;
            margin: 10px 0;
        }
    </style>
</head>
<body>

    <!-- Toast Notifications -->
    <div class="toast-container">
        <?php if (isset($_SESSION['shop_alert'])): ?>
            <div class="toast toast-<?php echo $_SESSION['shop_alert_type']; ?>">
                <i class="fas <?php echo $_SESSION['shop_alert_type'] === 'success' ? 'fa-check-circle' : 'fa-times-circle'; ?>"></i>
                <span><?php echo htmlspecialchars($_SESSION['shop_alert']); ?></span>
            </div>
            <?php 
            unset($_SESSION['shop_alert']); 
            unset($_SESSION['shop_alert_type']); 
            ?>
        <?php endif; ?>
    </div>

    <!-- ==========================
    NAVBAR
    ========================== -->
    <header class="dashboard-navbar">
        <!-- Logo -->
        <a href="index.html" class="logo">
            <img src="assets/images/logo.png" alt="Gyan Setu Logo" class="logo-img">
            <h2>Gyan Setu</h2>
        </a>

        <!-- Navigation -->
        <nav class="dashboard-menu">
            <a href="child-dashboard.php">🎮 Game Zone</a>
            <a href="shop.php" class="active">🏪 Store</a>
        </nav>

        <!-- Right Side -->
        <div class="dashboard-right" style="display: flex; align-items: center; gap: 15px;">
            <a href="logout.php" class="profile-icon" title="Logout" style="text-decoration: none; display: flex; align-items: center; justify-content: center; background: #e74c3c; color: white; width: 40px; height: 40px; border-radius: 50%;">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </header>

    <!-- ==========================
    TOP BAR
    ========================== -->
    <div class="top-bar" style="display: flex; justify-content: space-between; align-items: center; padding: 15px 6%; background: white; border-bottom: 1px solid #eee;">
        <a href="child-dashboard.php" class="back-btn" style="text-decoration: none; color: #85b035; font-weight: bold; font-size: 15px;">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>

        <div class="coin-display" style="display: flex; align-items: center; gap: 8px; background: #fdfaf0; border: 1px solid #f9ebcc; padding: 6px 16px; border-radius: 20px; font-weight: bold; font-size: 16px; color: #b7950b;">
            <img src="assets/images/coin.png" alt="Coin" style="width: 20px; height: 20px;">
            <span><?php echo $total_points; ?></span>
        </div>
    </div>

    <!-- ==========================
    SHOP
    ========================== -->
    <section class="shop-section" style="padding: 40px 6%;">
        <h2 style="font-size: 24px; color: #2c3e50; margin-bottom: 25px; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-store" style="color: #85b035;"></i> Gyan Setu Store
        </h2>

        <div class="worksheet-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 25px;">
            <?php foreach ($shop_items as $item): ?>
                <div class="worksheet-card">
                    <div class="coin-icon">
                        <img src="assets/images/coin.png" alt="Coin">
                        <span><?php echo htmlspecialchars($item['price_points']); ?></span>
                    </div>

                    <div class="worksheet-image">
                        <?php echo htmlspecialchars($item['icon_url']); ?>
                    </div>

                    <p><?php echo htmlspecialchars($item['item_name']); ?></p>

                    <button type="button" 
                            onclick="if(confirm('Are you sure you want to buy <?php echo addslashes($item['item_name']); ?>?')) { window.location.href='shop.php?buy_item=<?php echo $item['item_id']; ?>'; }"
                            aria-label="Buy <?php echo htmlspecialchars($item['item_name']); ?>">
                        BUY
                    </button>
                </div>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- ==========================
    FOOTER
    ========================== -->
    <footer class="dashboard-footer" style="text-align: center; padding: 20px; background: white; border-top: 1px solid #eee; margin-top: 50px;">
        <p>© 2026 Gyan Setu. All rights reserved.</p>
    </footer>

    <!-- Dismiss alerts -->
    <script>
        setTimeout(function() {
            const toast = document.querySelector('.toast');
            if (toast) {
                toast.style.transition = "opacity 0.5s ease-out";
                toast.style.opacity = 0;
                setTimeout(() => toast.remove(), 500);
            }
        }, 4000);
    </script>
</body>
</html>
