<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Check if logged in as Child
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'child') {
    header("Location: login.html");
    exit();
}

$child_id = $_SESSION['user_id'];
$username = $_SESSION['username'];

// Handle Game Play Simulation
if (isset($_GET['play_game'])) {
    $game_name = trim($_GET['play_game']);
    $points_to_add = 20;

    // 1. Update points in children
    $stmt = $conn->prepare("UPDATE children SET total_points = total_points + ? WHERE child_id = ?");
    $stmt->bind_param("ii", $points_to_add, $child_id);
    $stmt->execute();
    $stmt->close();

    // Fetch updated total points
    $stmt = $conn->prepare("SELECT total_points FROM children WHERE child_id = ?");
    $stmt->bind_param("i", $child_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $child_data = $res->fetch_assoc();
    $new_points = $child_data['total_points'];
    $stmt->close();

    // Calculate level: 1 level per 100 points (minimum Level 1)
    $new_level = max(1, floor($new_points / 100) + 1);
    $stmt = $conn->prepare("UPDATE children SET current_level = ? WHERE child_id = ?");
    $stmt->bind_param("ii", $new_level, $child_id);
    $stmt->execute();
    $stmt->close();

    // 2. Record score in scores table
    $stmt = $conn->prepare("INSERT INTO scores (child_id, game_name, score_value) VALUES (?, ?, ?)");
    $stmt->bind_param("isi", $child_id, $game_name, $points_to_add);
    $stmt->execute();
    $stmt->close();

    // 3. Check and award coins/badges
    $stmt = $conn->prepare("SELECT coin_id, name, points_required FROM coin WHERE points_required <= ?");
    $stmt->bind_param("i", $new_points);
    $stmt->execute();
    $res = $stmt->get_result();
    $eligible_coins = [];
    while ($row = $res->fetch_assoc()) {
        $eligible_coins[] = $row;
    }
    $stmt->close();

    $new_badge_msg = '';
    foreach ($eligible_coins as $coin) {
        // Check if already earned
        $stmt = $conn->prepare("SELECT child_coin_id FROM child_coin WHERE child_id = ? AND coin_id = ?");
        $stmt->bind_param("ii", $child_id, $coin['coin_id']);
        $stmt->execute();
        $stmt->store_result();
        $already_earned = $stmt->num_rows > 0;
        $stmt->close();

        if (!$already_earned) {
            // Award the coin!
            $stmt = $conn->prepare("INSERT INTO child_coin (child_id, coin_id) VALUES (?, ?)");
            $stmt->bind_param("ii", $child_id, $coin['coin_id']);
            $stmt->execute();
            $stmt->close();
            
            $new_badge_msg = "🏆 Congratulations! You earned the '" . $coin['name'] . "' badge!";
        }
    }

    $_SESSION['game_alert'] = "🎉 Played '$game_name'! You earned +$points_to_add points!";
    if (!empty($new_badge_msg)) {
        $_SESSION['badge_alert'] = $new_badge_msg;
    }

    header("Location: child-dashboard.php");
    exit();
}

// Fetch Fresh Child Data
$stmt = $conn->prepare("SELECT total_points, current_level FROM children WHERE child_id = ?");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
$child_info = $res->fetch_assoc();
$stmt->close();

$total_points = $child_info['total_points'];
$current_level = $child_info['current_level'];

// Fetch Earned Coins (Badges)
$badges = [];
$stmt = $conn->prepare("
    SELECT c.name, c.description, c.icon_url, cc.date_earned 
    FROM child_coin cc
    JOIN coin c ON cc.coin_id = c.coin_id
    WHERE cc.child_id = ?
");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $badges[] = $row;
}
$stmt->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - Child Dashboard</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

    <!-- Navbar -->
    <header class="dashboard-navbar">
        <!-- Logo -->
        <a href="child-dashboard.php" class="logo">
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
                <button class="language-btn">🌐 Language</button>
                <a href="logout.php" class="profile-icon" title="Logout" style="text-decoration: none; font-size: 14px; font-weight: 700; color: #fff; background: rgba(255,255,255,0.22); padding: 6px 12px; border-radius: 20px;">Logout</a>
            </div>
        </div>
    </header>

    <!-- Main Dashboard  -->
    <main class="dashboard-container" style="display: grid; grid-template-columns: 200px 1fr; gap: 20px; padding: 20px;">

        <!-- Child Welcome & Stats Banner -->
        <div class="child-stats-banner" style="
            grid-column: 1 / -1;
            background: linear-gradient(135deg, #1abcbf 0%, #6b7fc4 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        ">
            <div>
                <h1 style="font-size: 22px; margin-bottom: 5px; font-weight: 800;">Welcome Back, <?php echo htmlspecialchars($username); ?>! 👋</h1>
                <p style="font-size: 14px; opacity: 0.9;">Select a subject on the left or play a game below to earn points!</p>
            </div>
            <div style="display: flex; gap: 20px; align-items: center;">
                <div style="text-align: center; background: rgba(255,255,255,0.2); padding: 8px 16px; border-radius: 8px;">
                    <div style="font-size: 10px; font-weight: 700; opacity: 0.8; letter-spacing: 0.05em;">CURRENT LEVEL</div>
                    <div style="font-size: 20px; font-weight: 800;">Level <?php echo $current_level; ?></div>
                </div>
                <div style="text-align: center; background: rgba(255,255,255,0.2); padding: 8px 16px; border-radius: 8px;">
                    <div style="font-size: 10px; font-weight: 700; opacity: 0.8; letter-spacing: 0.05em;">TOTAL POINTS</div>
                    <div style="font-size: 20px; font-weight: 800; color: #ffe4b5;">🪙 <?php echo $total_points; ?> pts</div>
                </div>
            </div>
        </div>

        <!-- Alerts if played -->
        <?php if (isset($_SESSION['game_alert'])): ?>
            <div style="
                grid-column: 1 / -1;
                padding: 12px 16px;
                background: #e6f4ea;
                color: #137333;
                border-radius: 8px;
                margin-bottom: 20px;
                font-weight: 700;
                text-align: center;
                border: 1px solid #13733330;
                font-size: 14px;
            ">
                <?php 
                echo $_SESSION['game_alert']; 
                unset($_SESSION['game_alert']);
                ?>
                <?php if (isset($_SESSION['badge_alert'])): ?>
                    <br/><?php echo $_SESSION['badge_alert']; unset($_SESSION['badge_alert']); ?>
                <?php endif; ?>
            </div>
        <?php endif; ?>

        <!-- Subject filter sidebar -->
        <aside class="subjects">
            <h2>Select Subject</h2>
            <button type="button">🧮 MATHS</button>
            <button type="button">📘 ENGLISH</button>
            <button type="button">📖 STORY BOOKS</button>
        </aside>

        <!-- Games list, locked games can be opened via Unlock All -->
        <section class="main-content">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h2 style="font-size: 18px; color: #2D3A1E; font-weight: 800;">🎮 Game Zone</h2>
                <button class="unlock-btn" type="button" style="margin: 0;">🔓 Unlock All</button>
            </div>

            <div class="games-grid" style="margin-bottom: 30px;">

                <a href="child-dashboard.php?play_game=Defend+The+Tower" class="game-link">
                    <div class="game-card active">
                        <div class="play-btn">▶</div>
                        <p>Defend The Tower</p>
                    </div>
                </a>

                <a href="child-dashboard.php?play_game=Word+Matcher" class="game-link">
                    <div class="game-card">
                        <div class="play-btn">▶</div>
                        <p>Word Matcher</p>
                    </div>
                </a>

                <a href="child-dashboard.php?play_game=Fraction+Fruit" class="game-link">
                    <div class="game-card">
                        <div class="play-btn">▶</div>
                        <p>Fraction Fruit</p>
                    </div>
                </a>

                <a href="child-dashboard.php?play_game=Sentence+Builder" class="game-link">
                    <div class="game-card">
                        <div class="play-btn">▶</div>
                        <p>Sentence Builder</p>
                    </div>
                </a>

            </div>

            <!-- Badges Section -->
            <div class="badges-section" style="background: #fff; padding: 20px; border-radius: 12px; border: 1.5px solid #d6daf0;">
                <h3 style="font-size: 16px; margin-bottom: 15px; color: #2D3A1E; font-weight: 800; border-bottom: 2px solid #1abcbf; padding-bottom: 6px;">🏅 My Badges</h3>
                <div class="badges-grid" style="display: flex; flex-wrap: wrap; gap: 15px;">
                    <?php if (empty($badges)): ?>
                        <p style="color: #888; font-style: italic; font-size: 14px;">No badges earned yet. Keep playing games to earn points and unlock badges!</p>
                    <?php else: ?>
                        <?php foreach ($badges as $badge): ?>
                            <div class="badge-item" style="
                                display: flex;
                                flex-direction: column;
                                align-items: center;
                                gap: 6px;
                                background: #fdf6e2;
                                border-radius: 10px;
                                padding: 12px;
                                border: 1px solid #ffe4b5;
                                text-align: center;
                                min-width: 90px;
                            ">
                                <span class="badge-icon" style="font-size: 28px;"><?php echo htmlspecialchars($badge['icon_url']); ?></span>
                                <span style="font-size: 12px; font-weight: 800; color: #b07800;"><?php echo htmlspecialchars($badge['name']); ?></span>
                                <span style="font-size: 10px; color: #999;"><?php echo htmlspecialchars($badge['description']); ?></span>
                            </div>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </div>
            </div>
        </section>
    </main>

    <!--  Footer  -->
    <footer class="dashboard-footer">
        © 2025 Gyan Setu. All rights reserved.
    </footer>

    <script src="js/script.js"></script>

</body>
</html>