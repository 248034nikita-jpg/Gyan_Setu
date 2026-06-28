<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Accept both 'child' and 'parent' sessions
if (!isset($_SESSION['role']) || !in_array($_SESSION['role'], ['child', 'parent'])) {
    header("Location: login.php");
    exit();
}

// Generate a one‑time token for accessing the parent dashboard via profile management
if (!isset($_SESSION['parent_access_token'])) {
    $_SESSION['parent_access_token'] = bin2hex(random_bytes(16));
}

// --- Resolve which child to show ---
if ($_SESSION['role'] === 'child') {
    // Child is directly logged in
    $child_id = $_SESSION['user_id'];
    $username = $_SESSION['username'];
} else {
    // Parent is logged in — show their first/most-recent child
    $parent_id_lookup = $_SESSION['user_id'];
    $stmt = $conn->prepare(
        "SELECT child_id, username FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1"
    );
    $stmt->bind_param("i", $parent_id_lookup);
    $stmt->execute();
    $res = $stmt->get_result();
    $child_row = $res->fetch_assoc();
    $stmt->close();

    if (!$child_row) {
        // Parent has no child yet â€” redirect to create one
        header("Location: child_profilesetuppage.php");
        exit();
    }
    $child_id = $child_row['child_id'];
    $username = $_SESSION['username'] ?? $child_row['username'];
}

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
            
            $new_badge_msg = "ðŸ† Congratulations! You earned the '" . $coin['name'] . "' badge!";
        }
    }

    $_SESSION['game_alert'] = "ðŸŽ‰ Played '$game_name'! You earned +$points_to_add points!";
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
$total_coins = count($badges);
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
        <a href="index.html" class="logo">
            <img src="assets/images/logo.png" alt="Gyan Setu Logo" class="logo-img">
            <h2>Gyan Setu</h2>
        </a>
        <button class="menu-toggle" type="button" id="menuToggleBtn" aria-label="Open menu" aria-expanded="false">&#9776;</button>
        <div class="nav-wrapper">
            <nav class="dashboard-menu">
                <a href="child-dashboard.php">🎮 Game Zone</a>
                <a href="progress.html">📈 My Progress</a>
                <a href="shop.php">🏪 Store</a>
            </nav>
            <div class="dashboard-right">
                <button class="language-btn">🌐 Language</button>

                <!-- Profile Avatar + Dropdown -->
                <div class="profile-dropdown-wrapper" id="profileDropdownWrapper">
                    <button class="profile-avatar-btn" id="profileAvatarBtn" onclick="toggleDropdown()" title="Profile Menu" aria-haspopup="true" aria-expanded="false">
                        <?php echo strtoupper(substr($username, 0, 1)); ?>
                    </button>
                    <div class="profile-dropdown-menu" id="profileDropdownMenu" role="menu">
                        <!-- Header -->
                        <div class="dropdown-header">
                            <div class="dh-name"><?php echo htmlspecialchars($username); ?></div>
                            <div class="dh-role"> Child Account</div>
                        </div>
                        <!-- Items -->
                        <a href="#" class="dropdown-item" role="menuitem">
                            <span class="di-icon">👤</span> My Profile
                        </a>
                        <a href="#" class="dropdown-item" role="menuitem">
                            <span class="di-icon">📈</span> My Progress
                        </a>
                        <div class="dropdown-divider"></div>
                        <!-- Player Management direct link to parent dashboard -->
                        <a href="parent-dashboard.php" class="dropdown-item" role="menuitem">
                            <span class="di-icon">👨‍💼</span> Player Management
                        </a>
                        <div class="dropdown-divider"></div>
                        <a href="logout.php" class="dropdown-item danger" role="menuitem">
                            <span class="di-icon">🚪</span> Logout
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Dashboard  -->
    <main class="dashboard-container" style="display: grid; grid-template-columns: 200px 1fr; gap: 20px; padding: 20px;">

        <!-- Child Welcome & Stats Banner -->
        <div class="child-stats-banner" style="
            grid-column: 1 / -1;
            background: linear-gradient(135deg, #7997cb 0%);
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
                <h1 style="font-size: 22px; margin-bottom: 5px; font-weight: 800;">Welcome Back, <?php echo htmlspecialchars($username); ?>👋</h1>
            
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
            <h3>Select Subject</h3>
            <button type="button">🧮 MATHS</button>
            <button type="button">📚 ENGLISH</button>
            <button type="button">📖 STORY BOOKS</button>
        </aside>

        <!-- Games list, locked games can be opened via Unlock All -->
        <section class="main-content">
            <div class="game-zone-header" style="display: flex; align-items: center; justify-content: space-between;">
                <h3>🎮 Game Zone</h3>
                <button class="unlock-btn" type="button" style="margin: 0;">🔓 Unlock All</button>
            </div>

            <div class="games-grid" style="margin-bottom: 30px;" style="display: flex; flex-wrap: wrap; gap: 20px;">
                <a href="child-dashboard.php?play_game=Earth+Defense" class="game-link">
                    <div class="game-card active">
                        <div class="play-btn">▶</div>
                        <p>Earth Defense</p>
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
            
        </section>
    </main>

    <!--  Footer  -->
    <footer class="dashboard-footer">
        © 2025 Gyan Setu. All rights reserved.
    </footer>

    <script src="js/script.js"></script>

    <script>
    // Profile Dropdown Toggle 
    function toggleDropdown() {
        const menu = document.getElementById('profileDropdownMenu');
        const btn  = document.getElementById('profileAvatarBtn');
        const isOpen = menu.classList.toggle('open');
        btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    }

    // Close profile dropdown when clicking outside
    document.addEventListener('click', function(e) {
        const wrapper = document.getElementById('profileDropdownWrapper');
        if (wrapper && !wrapper.contains(e.target)) {
            document.getElementById('profileDropdownMenu').classList.remove('open');
            document.getElementById('profileAvatarBtn').setAttribute('aria-expanded', 'false');
        }
    });

    // ── Mobile Nav Menu Toggle ──
    (function() {
        const toggleBtn = document.getElementById('menuToggleBtn');
        const navWrapper = document.querySelector('.nav-wrapper');
        if (toggleBtn && navWrapper) {
            toggleBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                const isOpen = navWrapper.classList.toggle('show');
                toggleBtn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
                toggleBtn.innerHTML = isOpen ? '&#10005;' : '&#9776;';
            });

            // Close menu when a nav link is clicked
            navWrapper.querySelectorAll('a').forEach(function(link) {
                link.addEventListener('click', function() {
                    navWrapper.classList.remove('show');
                    toggleBtn.setAttribute('aria-expanded', 'false');
                    toggleBtn.innerHTML = '&#9776;';
                });
            });

            // Close menu on outside click
            document.addEventListener('click', function(e) {
                if (!navWrapper.contains(e.target) && !toggleBtn.contains(e.target)) {
                    navWrapper.classList.remove('show');
                    toggleBtn.setAttribute('aria-expanded', 'false');
                    toggleBtn.innerHTML = '&#9776;';
                }
            });

            // Close menu on resize above breakpoint
            window.addEventListener('resize', function() {
                if (window.innerWidth > 768) {
                    navWrapper.classList.remove('show');
                    toggleBtn.setAttribute('aria-expanded', 'false');
                    toggleBtn.innerHTML = '&#9776;';
                }
            });
        }
    })();
    </script>

</body>
</html>
