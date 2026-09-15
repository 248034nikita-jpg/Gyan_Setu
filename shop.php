<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Accept both 'child' and 'parent' sessions
if (!isset($_SESSION['role']) || !in_array($_SESSION['role'], ['child', 'parent'])) {
    header("Location: login.php");
    exit();
}

$role = $_SESSION['role'];

// Get child_id and parent_id
if ($role === 'child') {
    $child_id = $_SESSION['user_id'];
    
    // Fetch child details and parent_id from database
    $query = "SELECT c.parent_id, c.username, c.total_coins, m.emoji_or_icon AS mascot_emoji FROM children c LEFT JOIN mascots m ON c.mascot_id = m.mascot_id WHERE c.child_id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $child_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $child_data = $result->fetch_assoc();
    $stmt->close();
    
    if (!$child_data) {
        header("Location: login.php");
        exit();
    }
    
    $parent_id      = $child_data['parent_id'];
    $child_username = $child_data['username'];
    $total_points   = $child_data['total_coins'];
    $mascot_emoji   = $child_data['mascot_emoji'] ?? $_SESSION['mascot'] ?? '🧒';
} else {
    // Parent is logged in
    $parent_id = $_SESSION['user_id'];
    $parent_name = $_SESSION['name'];
    
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
    $verify_query = "SELECT c.username, c.total_coins, m.emoji_or_icon AS mascot_emoji FROM children c LEFT JOIN mascots m ON c.mascot_id = m.mascot_id WHERE c.child_id = ? AND c.parent_id = ?";
    $stmt = $conn->prepare($verify_query);
    $stmt->bind_param("ii", $child_id, $parent_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        header("Location: child-dashboard.php?error=invalid_child");
        exit();
    }
    
    $child_data     = $result->fetch_assoc();
    $child_username = $child_data['username'];
    $total_points   = $child_data['total_coins'];
    $mascot_emoji   = $child_data['mascot_emoji'] ?? $_SESSION['mascot'] ?? '🧒';
    $stmt->close();
}

// Handle Purchase Request
if (isset($_GET['buy_item'])) {
    $item_id = intval($_GET['buy_item']);

    // 1. Fetch item details
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

        $points = $child_data['total_coins'];

        if ($points >= $price) {
            // 3. Deduct coins
            $stmt = $conn->prepare("UPDATE children SET total_coins = total_coins - ? WHERE child_id = ?");
            $stmt->bind_param("ii", $price, $child_id);
            $stmt->execute();
            $stmt->close();

            // 4. Record purchase
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
$total_points = $child_info['total_coins'];

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
    <link rel="stylesheet" href="css/nav.css">
    <link rel="stylesheet" href="css/shop.css">
    <link rel="stylesheet" href="time_limit/time_limit.css?v=<?php echo time(); ?>">
</head>
<body>

    <!-- Navbar -->
    <div id="nav-placeholder"></div>
    <script>
        window.USER_MASCOT = <?php echo json_encode($mascot_emoji); ?>;
        window.USER_NAME   = <?php echo json_encode($child_username); ?>;
    </script>
    <script src="js/nav.js"></script>

    <!-- Top Bar (Back button + coin balance)-->
    <div class="top-bar">
        <a href="child-dashboard.php" class="back-btn">⬅ Back</a>
        <div class="coin-display">
            <img src="assets/images/website/coin.png" alt="Coin">
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
                            <img src="assets/images/website/coin.png" alt="Coin">
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
    <script src="time_limit/time_limit.js?v=<?php echo time(); ?>"></script>
</body>
</html>