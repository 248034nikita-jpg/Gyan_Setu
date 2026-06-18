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
    <!-- CSS Stylesheet -->
    <link rel="stylesheet" href="css/dashboard.css">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Interactive popup alert box styles */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .toast {
            background-color: #333;
            color: #fff;
            padding: 15px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            animation: slideIn 0.3s ease-out;
            border-left: 5px solid #2ecc71;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .toast-badge {
            background-color: #f1c40f;
            border-left-color: #f1c40f;
        }
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        /* Layout modifications */
        .badge-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }
        .badge-item {
            background-color: #f9f9f9;
            border: 1px solid #eee;
            padding: 8px 12px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 500;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }
        .badge-item img {
            width: 16px;
            height: 16px;
        }
        
        /* Stats dashboard item */
        .dashboard-header-stats {
            background: rgba(255, 255, 255, 0.9);
            padding: 10px 20px;
            border-radius: 8px;
            display: flex;
            gap: 20px;
            align-items: center;
            font-size: 15px;
            font-weight: 600;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.05);
        }
        .stat-badge {
            background: #eef7de;
            color: #5d8a0c;
            padding: 4px 10px;
            border-radius: 12px;
        }

        /* Subject aside layout adjustments */
        .subjects button {
            width: 100%;
            padding: 12px;
            margin-bottom: 10px;
            border-radius: 8px;
            border: none;
            background: #eee;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 10px;
            transition: all 0.3s;
        }
        .subjects button:hover {
            background: #ddd;
            transform: scale(1.02);
        }
        .subjects button.active {
            background: #c6d58f;
            color: #333;
        }
    </style>
</head>
<body>

    <!-- Toast Notifications -->
    <div class="toast-container">
        <?php if (isset($_SESSION['game_alert'])): ?>
            <div class="toast">
                <i class="fas fa-check-circle" style="color: #2ecc71;"></i>
                <span><?php echo htmlspecialchars($_SESSION['game_alert']); ?></span>
            </div>
            <?php unset($_SESSION['game_alert']); ?>
        <?php endif; ?>
        
        <?php if (isset($_SESSION['badge_alert'])): ?>
            <div class="toast toast-badge">
                <i class="fas fa-trophy" style="color: #f1c40f;"></i>
                <span><?php echo htmlspecialchars($_SESSION['badge_alert']); ?></span>
            </div>
            <?php unset($_SESSION['badge_alert']); ?>
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
            <a href="child-dashboard.php" class="active">🎮 Game Zone</a>
            <a href="shop.php">🏪 Store</a>
        </nav>

        <!-- Right Side -->
        <div class="dashboard-right" style="display: flex; align-items: center; gap: 15px;">
            <div class="dashboard-header-stats">
                <span>Level <span class="stat-badge"><?php echo $current_level; ?></span></span>
                <span>Points <span class="stat-badge" style="background: #fff3cd; color: #856404;"><?php echo $total_points; ?> pts</span></span>
            </div>
            <a href="logout.php" class="profile-icon" title="Logout" style="text-decoration: none; display: flex; align-items: center; justify-content: center; background: #e74c3c; color: white; width: 40px; height: 40px; border-radius: 50%;">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </header>

    <!-- ==========================
    MAIN DASHBOARD
    ========================== -->
    <div class="dashboard-container">

        <!-- SUBJECTS / SIDEBAR -->
        <aside class="subjects">
            <h2>Select Subject</h2>
            <button type="button" class="active">🧮 MATHS</button>
            <button type="button">📘 ENGLISH</button>
            <button type="button">📖 STORY BOOKS</button>

            <!-- Earned Badges Section -->
            <div style="margin-top: 30px;">
                <h3 style="font-size: 16px; margin-bottom: 10px; color: #555;"><i class="fas fa-award"></i> My Badges</h3>
                <?php if (empty($badges)): ?>
                    <p style="font-size: 12px; color: #888; font-style: italic;">Play games to earn your first badge!</p>
                <?php else: ?>
                    <div class="badge-list">
                        <?php foreach ($badges as $b): ?>
                            <div class="badge-item" title="<?php echo htmlspecialchars($b['description']); ?>">
                                <img src="<?php echo htmlspecialchars($b['icon_url']); ?>" alt="coin">
                                <strong><?php echo htmlspecialchars($b['name']); ?></strong>
                            </div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </div>
        </aside>

        <!-- MAIN CONTENT: GAMES GRID -->
        <section class="main-content">
            <!-- Unlock Banner -->
            <div class="dashboard-header-banner" style="display: flex; justify-content: space-between; align-items: center; background: #fff; padding: 15px 25px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.02);">
                <span style="font-weight: 600; color: #555;">Welcome back, <strong style="color: #333; text-transform: capitalize;"><?php echo htmlspecialchars($username); ?></strong>! Choose a game to play and earn points!</span>
            </div>

            <!-- Games Grid -->
            <div class="games-grid">
                <!-- Game 1 -->
                <div class="game-card-wrapper" style="position: relative;">
                    <a href="child-dashboard.php?play_game=Defend+The+Tower" class="game-link" style="text-decoration: none;">
                        <div class="game-card active" style="background: linear-gradient(135deg, #a4cb5c, #c6d58f); border-radius: 12px; padding: 25px; text-align: center; color: #333; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                            <div class="play-btn" style="font-size: 24px; background: white; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">▶</div>
                            <p style="font-weight: bold; font-size: 16px;">Defend The Tower</p>
                        </div>
                    </a>
                </div>

                <!-- Game 2 -->
                <div class="game-card-wrapper" style="position: relative;">
                    <a href="child-dashboard.php?play_game=Math+Adventure" class="game-link" style="text-decoration: none;">
                        <div class="game-card active" style="background: linear-gradient(135deg, #3498db, #85c1e9); border-radius: 12px; padding: 25px; text-align: center; color: white; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                            <div class="play-btn" style="font-size: 24px; background: white; color: #3498db; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">▶</div>
                            <p style="font-weight: bold; font-size: 16px;">Math Adventure</p>
                        </div>
                    </a>
                </div>

                <!-- Game 3 -->
                <div class="game-card-wrapper" style="position: relative;">
                    <a href="child-dashboard.php?play_game=English+Challenge" class="game-link" style="text-decoration: none;">
                        <div class="game-card active" style="background: linear-gradient(135deg, #e67e22, #f5b041); border-radius: 12px; padding: 25px; text-align: center; color: white; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                            <div class="play-btn" style="font-size: 24px; background: white; color: #e67e22; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">▶</div>
                            <p style="font-weight: bold; font-size: 16px;">English Challenge</p>
                        </div>
                    </a>
                </div>

                <!-- Game 4 -->
                <div class="game-card-wrapper" style="position: relative;">
                    <a href="child-dashboard.php?play_game=Story+World" class="game-link" style="text-decoration: none;">
                        <div class="game-card active" style="background: linear-gradient(135deg, #9b59b6, #c39bd3); border-radius: 12px; padding: 25px; text-align: center; color: white; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                            <div class="play-btn" style="font-size: 24px; background: white; color: #9b59b6; width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">▶</div>
                            <p style="font-weight: bold; font-size: 16px;">Story World</p>
                        </div>
                    </a>
                </div>
            </div>
        </section>

    </div>

    <!-- ==========================
    FOOTER
    ========================== -->
    <footer class="dashboard-footer">
        <p>© 2026 Gyan Setu. All rights reserved.</p>
    </footer>

    <!-- Auto-dismiss toasts after 4 seconds -->
    <script>
        setTimeout(function() {
            const toasts = document.querySelectorAll('.toast');
            toasts.forEach(t => {
                t.style.transition = "opacity 0.5s ease-out";
                t.style.opacity = 0;
                setTimeout(() => t.remove(), 500);
            });
        }, 4000);
    </script>
</body>
</html>
