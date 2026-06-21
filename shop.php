<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Check if logged in as Child
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'child') {
    header("Location: login.php");
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
    <title>Gyan Setu Shop</title>
    <link rel="stylesheet" href="css/shop.css">
</head>
<body>

    <!-- Navbar  -->
    <header class="dashboard-navbar">
        <!-- Logo -->
        <a href="index.html" class="logo">
            <img src="assets/images/logo.png" alt="Gyan Setu Logo" class="logo-img">
            <h2>Gyan Setu</h2>
        </a>
        <button class="menu-toggle" type="button">☰</button>
        <div class="nav-wrapper">
            <nav class="dashboard-menu">
                <a href="child-dashboard.php">🎮 Game Zone</a>
                <a href="#">📈 My Progress</a>
                <a href="shop.php">🏪 Store</a>
                <a href="#">💰 Coins</a>
            </nav>
            <div class="dashboard-right">
                <button class="language-btn" type="button">🌐 Language</button>
                <a href="logout.php" class="profile-icon" title="Logout" style="text-decoration: none; font-size: 14px; font-weight: 700; color: #fff; background: rgba(255,255,255,0.22); padding: 6px 12px; border-radius: 20px;">Logout</a>
            </div>
        </div>
    </header>

    <!-- Top Bar (Back button + coin balance)-->
    <div class="top-bar">
        <a href="child-dashboard.php" class="back-btn">⬅ Back</a>
        <div class="coin-display">
            <img src="assets/images/coin.png" alt="Coin">
            <span><?php echo $total_points; ?></span>
        </div>
    </div>

    <!-- Shop Section (worksheets available for purchase) -->
    <section class="shop-section">
        <?php if (isset($_SESSION['shop_alert'])): ?>
            <div class="shop-alert <?php echo $_SESSION['shop_alert_type']; ?>" style="
                padding: 12px 16px; 
                margin-bottom: 20px; 
                border-radius: 8px; 
                font-weight: 700;
                text-align: center;
                background: <?php echo $_SESSION['shop_alert_type'] === 'success' ? '#e6f4ea' : '#fce8e6'; ?>;
                color: <?php echo $_SESSION['shop_alert_type'] === 'success' ? '#137333' : '#c5221f'; ?>;
                border: 1px solid <?php echo $_SESSION['shop_alert_type'] === 'success' ? '#13733350' : '#c5221f50'; ?>;
            ">
                <?php 
                echo $_SESSION['shop_alert']; 
                unset($_SESSION['shop_alert']);
                unset($_SESSION['shop_alert_type']);
                ?>
            </div>
        <?php endif; ?>

        <h2>Worksheets</h2>
        <div class="worksheet-grid">

            <?php if (empty($shop_items)): ?>
                <p style="grid-column: 1 / -1; text-align: center; color: #666; font-style: italic;">No worksheets available in the shop.</p>
            <?php else: ?>
                <?php foreach ($shop_items as $item): ?>
                    <div class="worksheet-card">
                        <div class="coin-icon">
                            <img src="assets/images/coin.png" alt="Coin">
                            <span><?php echo htmlspecialchars($item['price_points']); ?></span>
                        </div>
                        <div class="worksheet-image"><?php echo htmlspecialchars($item['icon_url']); ?></div>
                        <p><?php echo htmlspecialchars($item['item_name']); ?></p>
                        <button type="button" onclick="window.location.href='shop.php?buy_item=<?php echo $item['item_id']; ?>'">BUY</button>
                    </div>
                <?php endforeach; ?>
            <?php endif; ?>

        </div>
    </section>

    <!-- Footer  -->
    <footer class="dashboard-footer">
        <p>© 2025 Gyan Setu. All rights reserved.</p>
    </footer>

    <script src="js/script.js"></script>

</body>
</html>