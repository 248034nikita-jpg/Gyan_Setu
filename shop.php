<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Check if logged in as Parent
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
    header("Location: login.php");
    exit();
}

// Get parent ID from session
$parent_id = $_SESSION['user_id'];
$parent_name = $_SESSION['name'];  // ← FIXED: Changed from 'username' to 'name'

// Get child_id from URL
if (!isset($_GET['child_id']) || empty($_GET['child_id'])) {
    // No child_id in URL - get the first child for this parent
    $query = "SELECT child_id FROM children WHERE parent_id = ? LIMIT 1";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $parent_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $child = $result->fetch_assoc();
    $stmt->close();
    
    if ($child) {
        $child_id = $child['child_id'];
    } else {
        header("Location: child-dashboard.php");
        exit();
    }
} else {
    $child_id = intval($_GET['child_id']);
}

// Verify this child belongs to this parent
$verify_query = "SELECT username, total_coins FROM children WHERE child_id = ? AND parent_id = ?";
$stmt = $conn->prepare($verify_query);
$stmt->bind_param("ii", $child_id, $parent_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    header("Location: child-dashboard.php?error=invalid_child");
    exit();
}

$child_data = $result->fetch_assoc();
$child_username = $child_data['username'];
<<<<<<< HEAD
$total_points = $child_data['total_coins'];
=======
$total_coins = $child_data['total_coins'];
>>>>>>> 402a674c734938de5405c079aa085ae0188f07b8
$stmt->close();

// Handle Purchase Request
if (isset($_GET['buy_item'])) {
    $item_id = intval($_GET['buy_item']);

<<<<<<< HEAD
    // 1. Fetch item details
=======
    // 1. Fetch item details (price_coins in new schema)
>>>>>>> 402a674c734938de5405c079aa085ae0188f07b8
    $stmt = $conn->prepare("SELECT price_coins, item_name FROM shop_items WHERE item_id = ?");
    $stmt->bind_param("i", $item_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $item = $res->fetch_assoc();
    $stmt->close();

    if ($item) {
        $price = $item['price_coins'];
        $name = $item['item_name'];

        // 2. Fetch child's current coins
        $stmt = $conn->prepare("SELECT total_coins FROM children WHERE child_id = ?");
        $stmt->bind_param("i", $child_id);
        $stmt->execute();
        $res = $stmt->get_result();
        $child_data = $res->fetch_assoc();
        $stmt->close();

<<<<<<< HEAD
        $points = $child_data['total_coins'];

        if ($points >= $price) {
=======
        $coins = $child_data['total_coins'];

        if ($coins >= $price) {
>>>>>>> 402a674c734938de5405c079aa085ae0188f07b8
            // 3. Deduct coins
            $stmt = $conn->prepare("UPDATE children SET total_coins = total_coins - ? WHERE child_id = ?");
            $stmt->bind_param("ii", $price, $child_id);
            $stmt->execute();
            $stmt->close();

<<<<<<< HEAD
            // 4. Record purchase
=======
            // 4. Record purchase (coins_spent in new schema)
>>>>>>> 402a674c734938de5405c079aa085ae0188f07b8
            $stmt = $conn->prepare("INSERT INTO purchases (child_id, item_id, coins_spent) VALUES (?, ?, ?)");
            $stmt->bind_param("iii", $child_id, $item_id, $price);
            $stmt->execute();
            $stmt->close();

            $_SESSION['shop_alert'] = "Successfully bought '$name'!";
            $_SESSION['shop_alert_type'] = "success";
        } else {
            $_SESSION['shop_alert'] = "Not enough coins for '$name'!";
            $_SESSION['shop_alert_type'] = "error";
        }
    }
    header("Location: shop.php?child_id=" . $child_id);
    exit();
}

// Fetch Child Coins
$stmt = $conn->prepare("SELECT total_coins FROM children WHERE child_id = ?");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
$child_info = $res->fetch_assoc();
$stmt->close();
<<<<<<< HEAD
$total_points = $child_info['total_coins'];
=======
$total_coins = $child_info['total_coins'];
>>>>>>> 402a674c734938de5405c079aa085ae0188f07b8

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
            <img src="assets/images/website/logo.png" alt="Gyan Setu Logo" class="logo-img">
            <h2>Gyan Setu</h2>
        </a>
        <button class="menu-toggle" type="button">☰</button>
        <div class="nav-wrapper">
            <nav class="dashboard-menu">
                <a href="child-dashboard.php">🎮 Game Zone</a>
                <a href="#">📈 My Progress</a>
                <a href="shop.php?child_id=<?php echo $child_id; ?>">🏪 Store</a>
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
<<<<<<< HEAD
            <img src="assets/images/website/coin.png" alt="Coin">
            <span><?php echo $total_points; ?></span>
=======
            <img src="assets/images/coin.png" alt="Coin">
            <span><?php echo $total_coins; ?></span>
>>>>>>> 402a674c734938de5405c079aa085ae0188f07b8
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
<<<<<<< HEAD
                            <img src="assets/images/website/coin.png" alt="Coin">
=======
                            <img src="assets/images/coin.png" alt="Coin">
>>>>>>> 402a674c734938de5405c079aa085ae0188f07b8
                            <span><?php echo htmlspecialchars($item['price_coins']); ?></span>
                        </div>
                        <div class="worksheet-image"><?php echo htmlspecialchars($item['icon_url']); ?></div>
                        <p><?php echo htmlspecialchars($item['item_name']); ?></p>
                        <button type="button" onclick="window.location.href='shop.php?child_id=<?php echo $child_id; ?>&buy_item=<?php echo $item['item_id']; ?>'">BUY</button>
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