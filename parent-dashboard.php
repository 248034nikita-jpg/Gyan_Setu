<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Check if logged in as Parent
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
    header("Location: login.php");
    exit();
}
// Verify access token from child dashboard
/*if (!isset($_GET['token']) || !isset($_SESSION['parent_access_token']) || $_GET['token'] !== $_SESSION['parent_access_token']) {
    // Redirect to child dashboard if token missing or invalid
    header("Location: child-dashboard.php");
    exit();
}*/

$parent_id   = $_SESSION['user_id'];
$parent_name = $_SESSION['name'] ?? 'Parent';

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
            $stmt = $conn->prepare("INSERT INTO children (username, parent_id, total_coins, current_level) VALUES (?, ?, 0, 1)");
            $stmt->bind_param("si", $child_username, $parent_id);

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
$stmt = $conn->prepare("SELECT * FROM progress_dashboard WHERE parent_id = ?");
$stmt->bind_param("i", $parent_id);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $children_stats[] = $row;
}
$stmt->close();

// Fetch Purchase History
$purchases = [];
$stmt = $conn->prepare("
    SELECT p.purchase_date, p.coins_spent, c.username AS child_name, s.item_name, s.icon_url 
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

// Calculate aggregated stats
$total_quiz_score = 0;
$child_count_with_scores = 0;
$total_coins_sum = 0;
$total_lessons_completed = 0;
$total_points_sum = 0;
foreach ($children_stats as $child) {
    if ($child['average_course_score'] !== null) {
        $total_quiz_score += $child['average_course_score'];
        $child_count_with_scores++;
    }
    $total_coins_sum += $child['badges_earned'];
    $total_lessons_completed += $child['courses_completed'];
    $total_points_sum += $child['total_coins'];
}
$overall_progress = $child_count_with_scores > 0 ? round($total_quiz_score / $child_count_with_scores) : 0;
$total_children = count($children_stats);
$streak = $total_children > 0 ? ($total_children * 3 + 2) : 0;
$weekly_study_hours = count($children_stats) > 0 ? round($total_lessons_completed * 1.5, 1) : 0;
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>SETU – Parent Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet"/>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --green:  #7CBF3F;
    --green-light: #EAF5D4;
    --green-dark: #4A8A1A;
    --yellow: #F5C842;
    --yellow-light: #FFF8DC;
    --blue:   #4A90D9;
    --blue-light: #E4F0FB;
    --purple: #9B6FD4;
    --purple-light: #F0E8FB;
    --orange: #F5832A;
    --orange-light: #FEF0E4;
    --red:    #E85555;
    --red-light: #FDE8E8;
    --bg:     #F7F9F2;
    --card:   #FFFFFF;
    --text:   #2D3A1E;
    --muted:  #7A8C6A;
    --border: #DDE8C8;
    --radius: 18px;
    --radius-sm: 10px;
    --shadow: 0 4px 18px rgba(80,120,40,0.10);
    --shadow-hover: 0 8px 28px rgba(80,120,40,0.18);
  }

  body {
    font-family: 'Nunito', sans-serif;
    background: var(--bg);
    color: var(--text);
    min-height: 100vh;
    font-size: 15px;
  }

  /* ── NAVBAR (Matching Child Dashboard) ── */
  .dashboard-navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 5%;
    background: #c6d58f;
    flex-wrap: wrap;
    gap: 20px;
    width: 100%;
  }

  .logo {
    display: flex;
    align-items: center;
    gap: 12px;
    text-decoration: none;
    transition: transform 0.2s ease, opacity 0.2s ease;
  }

  .logo:hover {
    transform: translateY(-4px);
    opacity: 0.9;
  }

  .logo-img {
    width: 55px;
    height: 55px;
    object-fit: contain;
  }

  .logo h2 {
    font-size: 28px;
    font-weight: 700;
    color: black;
    margin: 0;
  }

  .menu-toggle {
    display: none;
    background: none;
    border: none;
    font-size: 35px;
    cursor: pointer;
    line-height: 1;
  }

  .nav-wrapper {
    display: flex;
    align-items: center;
    gap: 30px;
  }

  .dashboard-menu {
    display: flex;
    gap: 40px;
  }

  .dashboard-menu a {
    text-decoration: none;
    font-size: 22px;
    font-weight: bold;
    color: black;
    transition: color 0.2s ease, transform 0.2s ease;
  }

  .dashboard-menu a:hover {
    color: #4a5c1d;
    transform: translateY(-3px);
  }

  .dashboard-menu a.active {
    color: #2d5a1e;
    border-bottom: 3px solid #2d5a1e;
    padding-bottom: 2px;
  }

  .dashboard-right {
    display: flex;
    align-items: center;
    gap: 25px;
  }

  .language-btn {
    padding: 10px 20px;
    background: white;
    border: none;
    border-radius: 10px;
    font-size: 18px;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.2s ease;
    font-family: inherit;
  }

  .language-btn:hover {
    background: #f0f0f0;
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0,0,0,0.08);
  }

  /* Profile Avatar + Dropdown */
  .profile-dropdown-wrapper {
    position: relative;
    display: inline-block;
  }

  .profile-avatar-btn {
    width: 46px;
    height: 46px;
    border-radius: 50%;
    background: linear-gradient(135deg, #6b7fc4);
    border: 3px solid rgba(255,255,255,0.7);
    color: #fff;
    font-size: 18px;
    font-weight: 800;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 4px 14px rgba(0,0,0,0.18);
    transition: transform 0.25s ease, box-shadow 0.25s ease;
    position: relative;
    font-family: 'Nunito', Arial, sans-serif;
  }

  .profile-avatar-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 20px rgba(0,0,0,0.22);
  }

  .profile-avatar-btn::after {
    content: '';
    position: absolute;
    bottom: 2px;
    right: 2px;
    width: 9px;
    height: 9px;
    background: #4134d3;
    border-radius: 50%;
    border: 2px solid #fff;
  }

  .profile-dropdown-menu {
    display: none;
    position: absolute;
    top: calc(100% + 10px);
    right: 0;
    width: 220px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 12px 40px rgba(0,0,0,0.18);
    overflow: hidden;
    z-index: 1000;
    animation: dropdownFade 0.2s ease;
    border: 1px solid rgba(0,0,0,0.06);
  }

  .profile-dropdown-menu.open {
    display: block;
  }

  @keyframes dropdownFade {
    from { opacity: 0; transform: translateY(-8px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  .dropdown-header {
    padding: 14px 16px 10px;
    border-bottom: 1px solid #f0f0f0;
  }

  .dropdown-header .dh-name {
    font-size: 13px;
    font-weight: 800;
    color: #1a1a2e;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .dropdown-header .dh-role {
    font-size: 11px;
    color: #1abcbf;
    font-weight: 700;
    margin-top: 2px;
  }

  .dropdown-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 11px 16px;
    font-size: 13.5px;
    font-weight: 700;
    color: #333;
    cursor: pointer;
    transition: background 0.15s ease;
    text-decoration: none;
    width: 100%;
    border: none;
    background: none;
    text-align: left;
    font-family: Arial, sans-serif;
  }

  .dropdown-item:hover {
    background: #f5f7ff;
    color: #1abcbf;
  }

  .dropdown-divider {
    height: 1px;
    background: #f0f0f0;
    margin: 4px 0;
  }

  .dropdown-item.danger {
    color: #dc2626;
  }

  .dropdown-item.danger:hover {
    background: #fff5f5;
    color: #b91c1c;
  }

  @media (max-width: 768px) {
    .dashboard-navbar {
      position: relative;
      justify-content: space-between;
      padding: 20px;
    }

    .menu-toggle {
      display: block;
    }

    .nav-wrapper {
      display: none;
      position: absolute;
      top: 100%;
      left: 0;
      width: 100%;
      background: white;
      padding: 25px;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 25px;
      z-index: 999;
      box-shadow: 0 8px 18px rgba(0,0,0,0.15);
    }

    .nav-wrapper.show {
      display: flex;
    }

    .dashboard-menu {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 20px;
      width: 100%;
    }

    .dashboard-right {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 15px;
      width: 100%;
    }
  }

  /* ── MAIN LAYOUT ── */
  main { max-width: 980px; margin: 0 auto; padding: 28px 20px 40px; }

  /* ── WELCOME ── */
  .welcome-row { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 22px; flex-wrap: wrap; gap: 12px; }
  .welcome-text h1 { font-size: 24px; font-weight: 900; color: var(--text); }
  .plan-badge {
    display: inline-flex; align-items: center; gap: 6px; margin-top: 4px;
    font-size: 13px; color: var(--muted); font-weight: 600;
  }
  .plan-badge a { color: var(--green-dark); text-decoration: none; font-weight: 800; }
  .motivational .emoji { font-size: 22px; }

  /* ── SECTION TITLE ── */
  .section-title {
    font-size: 13px; font-weight: 800; letter-spacing: 1.5px; text-transform: uppercase;
    color: var(--muted); margin-bottom: 14px;
  }

  /* ── STATS ROW ── */
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 14px;
    margin-bottom: 28px;
  }
  .stat-card {
    background: var(--card); border-radius: var(--radius); padding: 18px 16px;
    box-shadow: var(--shadow); border: 1.5px solid var(--border);
    display: flex; flex-direction: column; align-items: center; gap: 8px;
    transition: transform 0.18s, box-shadow 0.18s;
  }
  .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-hover); }
  .stat-icon {
    width: 44px; height: 44px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: 22px;
  }
  .stat-value { font-size: 26px; font-weight: 900; line-height: 1; }
  .stat-label { font-size: 12px; font-weight: 700; color: var(--muted); text-align: center; }

  /* Circular progress */
  .circular-progress { position: relative; width: 72px; height: 72px; }
  .circular-progress svg { transform: rotate(-90deg); }
  .circular-progress .track { fill: none; stroke: #EAF5D4; stroke-width: 8; }
  .circular-progress .fill { fill: none; stroke-width: 8; stroke-linecap: round; transition: stroke-dashoffset 1s ease; }
  .cp-label {
    position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%);
    font-size: 15px; font-weight: 900; color: var(--green-dark);
  }

  /* ── CHILDREN SECTION ── */
  .children-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 16px;
    margin-bottom: 28px;
  }
  .child-card {
    background: var(--card); border-radius: var(--radius); padding: 20px 18px;
    box-shadow: var(--shadow); border: 2px solid var(--border);
    position: relative; transition: transform 0.18s, box-shadow 0.18s;
  }
  .child-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-hover); }
  .child-avatar {
    width: 54px; height: 54px; border-radius: 50%; margin-bottom: 10px;
    display: flex; align-items: center; justify-content: center; font-size: 26px;
    border: 3px solid var(--border);
  }
  .child-name { font-size: 17px; font-weight: 800; margin-bottom: 2px; }
  .child-meta { font-size: 12px; color: var(--muted); font-weight: 600; margin-bottom: 10px; }
  .coins-row { display: flex; align-items: center; gap: 6px; margin-bottom: 10px; font-size: 13px; font-weight: 700; color: #B07800; }
  .coin-icon { font-size: 18px; }

  /* Mini progress bar */
  .mini-progress-label { font-size: 11px; font-weight: 700; color: var(--muted); margin-bottom: 4px; display: flex; justify-content: space-between; }
  .mini-bar-bg { background: #EAF5D4; border-radius: 20px; height: 8px; overflow: hidden; margin-bottom: 12px; }
  .mini-bar-fill { height: 100%; border-radius: 20px; background: var(--green); transition: width 1s ease; }

  .child-btns { display: flex; gap: 8px; }
  .btn-play {
    flex: 1; background: var(--green); color: #fff; border: none;
    border-radius: var(--radius-sm); padding: 8px 0; font-family: inherit;
    font-weight: 800; font-size: 13px; cursor: pointer;
    display: flex; align-items: center; justify-content: center; gap: 5px;
    transition: background 0.15s;
    text-decoration: none;
  }
  .btn-play:hover { background: var(--green-dark); }
  .btn-edit {
    flex: 1; background: var(--green-light); color: var(--green-dark); border: none;
    border-radius: var(--radius-sm); padding: 8px 0; font-family: inherit;
    font-weight: 800; font-size: 13px; cursor: pointer; transition: background 0.15s;
  }
  .btn-edit:hover { background: #C9E8A0; }

  .add-child-card {
    background: var(--yellow-light); border: 2px dashed var(--yellow);
    border-radius: var(--radius); padding: 20px 18px;
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    gap: 10px; cursor: pointer; transition: background 0.15s;
    min-height: 200px;
  }
  .add-child-card:hover { background: #FFF3B0; }
  .add-icon {
    width: 48px; height: 48px; border-radius: 50%; background: var(--yellow);
    display: flex; align-items: center; justify-content: center; font-size: 26px; font-weight: 900; color: #fff;
  }
  .add-child-card span { font-size: 14px; font-weight: 800; color: #9A7700; }

  
  /* ── TWO-COL LAYOUT ── */
  .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-bottom: 28px; }
  @media(max-width: 600px) { .two-col { grid-template-columns: 1fr; } }

  /* ── PANEL CARD ── */
  .panel {
    background: var(--card); border-radius: var(--radius); padding: 20px;
    box-shadow: var(--shadow); border: 1.5px solid var(--border);
  }
  .panel-title { font-size: 15px; font-weight: 800; margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }

  /* ── BADGES ── */
  .badges-grid { display: flex; flex-wrap: wrap; gap: 10px; }
  .badge-item {
    display: flex; flex-direction: column; align-items: center; gap: 4px;
    background: var(--yellow-light); border-radius: 12px; padding: 10px 12px;
    font-size: 11px; font-weight: 700; color: #7A5A00; min-width: 64px;
    border: 1.5px solid #F5C84240;
    transition: transform 0.15s;
  }
  .badge-item:hover { transform: scale(1.07); }
  .badge-item .badge-icon { font-size: 28px; }
  .badge-item.locked { opacity: 0.4; filter: grayscale(1); }

  .premium-features {
    font-size: 20px; font-weight: 700;
    color: var(--muted); margin-bottom: 28px;
    border: 3px dashed #F5C84260; border-radius: var(--radius); padding: 18px;
  }
  .premium-feature-text { 
    color: var(--muted); 
    margin-bottom: 28px; 
  border: 3px solid #F5C84260; border-radius: var(--radius); padding: 18px;
  }
  /* ── STREAK ── */
  .streak-row { display: flex; gap: 8px; justify-content: center; }
  .streak-day {
    display: flex; flex-direction: column; align-items: center; gap: 4px;
    font-size: 11px; font-weight: 700; color: var(--muted);
  }
  .streak-dot {
    width: 32px; height: 32px; border-radius: 50%;
    background: var(--green-light); border: 2px solid var(--border);
    display: flex; align-items: center; justify-content: center; font-size: 14px;
  }
  .streak-dot.done { background: var(--green); border-color: var(--green-dark); }
  .streak-dot.today { background: var(--yellow); border-color: #D4A800; animation: pulse 1.4s infinite; }

  @keyframes pulse { 0%,100% { box-shadow: 0 0 0 0 rgba(245,200,66,0.5); } 50% { box-shadow: 0 0 0 8px rgba(245,200,66,0); } }

  /* ── SCREENTIME ── */
  .screentime-dropdown {
    width: 100%; padding: 12px 16px; border-radius: var(--radius-sm);
    border: 1.5px solid var(--green); background: var(--green-light);
    font-family: inherit; font-weight: 800; font-size: 14px; color: var(--green-dark);
    cursor: pointer; appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%234A8A1A' stroke-width='3'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
    background-repeat: no-repeat; background-position: right 14px center;
    padding-right: 36px;
  }

  /* ── PURCHASE HISTORY ── */
  .purchase-panel {
    background: var(--yellow-light); border-radius: var(--radius); padding: 20px;
    box-shadow: var(--shadow); border: 1.5px solid #F5C84260;
    margin-bottom: 28px;
  }
  .purchase-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
  .purchase-table th {
    text-align: left; font-size: 12px; font-weight: 800; color: var(--muted);
    padding: 6px 10px; border-bottom: 1.5px solid #E8D88060;
  }
  .purchase-table td { font-size: 13px; padding: 9px 10px; border-bottom: 1px solid #E8D88040; }
  .purchase-table tr:last-child td { border-bottom: none; }
  .purchase-table .coins-val { font-weight: 800; color: #9A6A00; }

  /* ── WEEKLY HOURS BAR ── */
  .weekly-bars { display: flex; align-items: flex-end; gap: 8px; height: 80px; }
  .week-bar-wrap { display: flex; flex-direction: column; align-items: center; gap: 4px; flex: 1; }
  .week-bar-bg { width: 100%; background: var(--green-light); border-radius: 6px 6px 0 0; display: flex; align-items: flex-end; height: 60px; overflow: hidden; }
  .week-bar-fill { width: 100%; background: var(--green); border-radius: 6px 6px 0 0; transition: height 1.2s ease; }
  .week-bar-fill.today-bar { background: var(--blue); }
  .week-day { font-size: 11px; font-weight: 700; color: var(--muted); }
  .week-val { font-size: 11px; font-weight: 800; color: var(--green-dark); }

  /* ── FOOTER ── */
  footer { text-align: center; font-size: 12px; color: var(--muted); padding-bottom: 24px; }
</style>
</head>
<body>

<!-- Navbar (Matching Child Dashboard) -->
<header class="dashboard-navbar">
    <a href="index.html" class="logo">
        <img src="assets/images/website/logo.png" alt="Gyan Setu Logo" class="logo-img">
        <h2>ज्ञान Setu</h2>
    </a>
    <button class="menu-toggle" type="button" id="menuToggleBtn" aria-label="Open menu" aria-expanded="false">&#9776;</button>
    <div class="nav-wrapper">
        <nav class="dashboard-menu">
            <a href="parent-dashboard.php" class="active">📊 Dashboard</a>
            <a href="parent_shop/shop.html">🏪 Parent Store</a>
            <a href="child-dashboard.php">🎮 Child Zone</a>
        </nav>
        <div class="dashboard-right">
            <button class="language-btn" type="button">🌐 Language</button>

            <!-- Profile Avatar + Dropdown -->
            <div class="profile-dropdown-wrapper" id="profileDropdownWrapper">
                <button class="profile-avatar-btn" id="profileAvatarBtn" onclick="toggleDropdown()" title="Profile Menu" aria-haspopup="true" aria-expanded="false">
                    <?php echo strtoupper(substr($parent_name, 0, 1)); ?>
                </button>
                <div class="profile-dropdown-menu" id="profileDropdownMenu" role="menu">
                    <div class="dropdown-header">
                        <div class="dh-name"><?php echo htmlspecialchars($parent_name); ?></div>
                        <div class="dh-role">Parent Account</div>
                    </div>
                    <a href="parent-dashboard.php" class="dropdown-item" role="menuitem">
                        <span class="di-icon">📊</span> Parent Dashboard
                    </a>
                    <a href="parent_shop/shop.html" class="dropdown-item" role="menuitem">
                        <span class="di-icon">🏪</span> Parent Store
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="child-dashboard.php" class="dropdown-item" role="menuitem">
                        <span class="di-icon">🎮</span> Switch to Child Zone
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

<main>

  <!-- WELCOME -->
  <div class="welcome-row">
    <div class="welcome-text">
      <h1>Welcome Back, <?php echo htmlspecialchars($parent_name); ?>! 👋</h1>
      <div class="plan-badge">⭐ Free Plan · <a href="#">Upgrade</a></div>
    </div>
  </div>
  
 <!-- SCREENTIME -->
  <p class="section-title">⏰ Safe Screentime Mode</p>
  <div class="panel" style="margin-bottom:28px;">
    <select class="screentime-dropdown">
      <option>⏱️ Time Limit – 1 hour/day</option>
      <option>⏱️ Time Limit – 2 hours/day</option>
      <option>🔓 Unlimited Mode</option>
      <option>🌙 Bedtime Lock – 9 PM</option>
    </select>
    <p style="margin-top:10px;font-size:13px;font-weight:600;color:var(--muted);">
      <?php if ($total_children > 0): ?>
        ✅ Screentime protection is active for <?php echo $total_children; ?> children.
      <?php else: ?>
        Screentime protection is ready. Add a child profile to activate.
      <?php endif; ?>
    </p>
  </div>

  <!-- PARENT RESOURCES SHOP -->
  <p class="section-title">🏪 Parent Resources Shop</p>
  <div class="panel" style="margin-bottom:28px; background: var(--orange-light); border-color: var(--orange);">
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
      <div>
        <h3 style="color:var(--orange); font-size:16px; font-weight:800;">Get worksheets, reading materials, and science activities for your children!</h3>
        <p style="font-size:13px; color:var(--text); font-weight:600; margin-top:4px;">Enhance your child's learning journey with high-quality digital resources.</p>
      </div>
      <a href="parent_shop/shop.html" class="btn-play" style="background:var(--orange); max-width:200px; padding:10px 20px; text-decoration:none;">Go to Parent Shop ➔</a>
    </div>
  </div>

<!-- MY CHILDREN -->
  <p class="section-title">👨‍👩‍👧 My Children</p>
  <div class="children-grid">

    <?php if (empty($children_stats)): ?>
      <div style="grid-column: 1 / -1; text-align: center; color: var(--muted); padding: 20px; background: #fff; border-radius: var(--radius); border: 1.5px solid var(--border);">
        No child accounts registered yet. Use the "Add Child Profile" form below to get started!
      </div>
    <?php else: ?>
      <?php foreach ($children_stats as $child): 
        $themes = [
          ['bg' => '#E4F0FB', 'border' => '#4A90D9', 'bar' => 'var(--blue)'],
          ['bg' => '#F0E8FB', 'border' => '#9B6FD4', 'bar' => 'var(--purple)'],
          ['bg' => '#FFF8DC', 'border' => '#F5C842', 'bar' => 'var(--yellow)'],
          ['bg' => '#FEF0E4', 'border' => '#F5832A', 'bar' => 'var(--orange)']
        ];
        $theme = $themes[$child['child_id'] % count($themes)];
        $progress = $child['average_course_score'] !== null ? round($child['average_course_score']) : 0;
      ?>
        <div class="child-card">
          <div class="child-avatar" style="background:<?php echo $theme['bg']; ?>; border-color:<?php echo $theme['border']; ?>;">🧒</div>
          <div class="child-name"><?php echo htmlspecialchars($child['child_name']); ?></div>
          <div class="child-meta">Level <?php echo htmlspecialchars($child['current_level']); ?></div>
          <div class="coins-row"><span class="coin-icon">🪙</span> <?php echo htmlspecialchars($child['total_coins']); ?> pts</div>
          <div class="mini-progress-label"><span>Quiz Score</span><span><?php echo $progress; ?>%</span></div>
          <div class="mini-bar-bg"><div class="mini-bar-fill" style="width:<?php echo $progress; ?>%; background:<?php echo $theme['bar']; ?>"></div></div>
          <div class="child-btns">
            <button class="btn-play" onclick="alert('To play as <?php echo htmlspecialchars($child['child_name']); ?>, log out and log in using their username: <?php echo htmlspecialchars($child['child_name']); ?>');">▶ Play</button>
            <button class="btn-edit" onclick="alert('Editing child profiles can be managed directly via PhpMyAdmin or will be supported in the next update.');">✏️ Edit</button>
          </div>
        </div>
      <?php endforeach; ?>
    <?php endif; ?>

    <!-- Add Child Card Button -->
    <div class="add-child-card" onclick="location.href='child_profilesetuppage.php';">
      <div class="add-icon">＋</div>
      <span>Add Child</span>
    </div>

  </div>

  <!-- STATS ROW -->
  <p class="section-title">📊 Overall Learning Progress</p>
  <div class="stats-grid">

    <!-- Circular Progress -->
    <div class="stat-card">
      <div class="circular-progress">
        <svg width="72" height="72" viewBox="0 0 72 72">
          <circle class="track" cx="36" cy="36" r="28"/>
          <circle class="fill" id="cp-fill" cx="36" cy="36" r="28"
            stroke="#7CBF3F"
            stroke-dasharray="175.9"
            stroke-dashoffset="175.9"/>
        </svg>
        <div class="cp-label"><?php echo $overall_progress; ?>%</div>
      </div>
      <div class="stat-value" style="color:var(--green)"><?php echo $overall_progress; ?>%</div>
      <div class="stat-label">Overall Progress</div>
    </div>

    <div class="stat-card">
      <div class="stat-icon" style="background:var(--blue-light); font-size:26px;">⏱️</div>
      <div class="stat-value" style="color:var(--blue)"><?php echo $weekly_study_hours; ?>h</div>
      <div class="stat-label">Weekly Study Hours</div>
    </div>

    <div class="stat-card">
      <div class="stat-icon" style="background:var(--purple-light); font-size:26px;">🪙</div>
      <div class="stat-value" style="color:var(--purple)"><?php echo $total_points_sum; ?></div>
      <div class="stat-label">Total Coins/Points</div>
    </div>

  </div>

  <div class="premium-features">
  <div  class="premium-feature-text" style="margin-bottom:28px;"> Premium features coming soon!</div>
  <!-- TWO-COL: Streak + Badges -->
  <div class="two-col">

    <!-- Streak -->
    <div class="panel">
      <div class="panel-title">🔥 Learning Streak — <?php echo $streak; ?> Days!</div>
      <div class="streak-row">
        <div class="streak-day"><div class="streak-dot done">✓</div><span>Mon</span></div>
        <div class="streak-day"><div class="streak-dot done">✓</div><span>Tue</span></div>
        <div class="streak-day"><div class="streak-dot done">✓</div><span>Wed</span></div>
        <div class="streak-day"><div class="streak-dot done">✓</div><span>Thu</span></div>
        <div class="streak-day"><div class="streak-dot done">✓</div><span>Fri</span></div>
        <div class="streak-day"><div class="streak-dot done">✓</div><span>Sat</span></div>
        <div class="streak-day"><div class="streak-dot done">✓</div><span>Sun</span></div>
        <div class="streak-day"><div class="streak-dot today">📅</div><span>Today</span></div>
      </div>
      <p style="text-align:center;margin-top:14px;font-size:13px;font-weight:700;color:var(--orange)">Keep it up! 2 more days for a bonus reward! 🎁</p>
    </div>
  </div>
    <!-- Badges -->
    <div class="panel">
      <div class="panel-title">🏅 Badges Earned</div>
      <div class="badges-grid">
        <div class="badge-item"><span class="badge-icon">🌟</span><span>Star Learner</span></div>
        <div class="badge-item"><span class="badge-icon">📚</span><span>Bookworm</span></div>
        <div class="badge-item"><span class="badge-icon">🔥</span><span>On Fire</span></div>
        <div class="badge-item"><span class="badge-icon">🧠</span><span>Quiz Master</span></div>
        <div class="badge-item"><span class="badge-icon">⚡</span><span>Fast Finisher</span></div>
        <div class="badge-item locked"><span class="badge-icon">👑</span><span>Champion</span></div>
        <div class="badge-item locked"><span class="badge-icon">🚀</span><span>Rocket Kid</span></div>
      </div>
    </div>

  </div>
  </div>
 
  <!-- PURCHASE HISTORY -->
  <div class="purchase-panel">
    <div class="panel-title" style="color:#7A5A00;">🛒 Children Store Transactions</div>
    <table class="purchase-table">
      <thead>
        <tr>
          <th>Child Name</th>
          <th>Worksheet / Item</th>
          <th>Date</th>
          <th style="text-align:right;">🪙 Coins / Points</th>
        </tr>
      </thead>
      <tbody>
        <?php if (empty($purchases)): ?>
          <tr>
            <td colspan="4" style="text-align: center; color: var(--muted); font-style: italic;">No items purchased from the store yet.</td>
          </tr>
        <?php else: ?>
          <?php foreach ($purchases as $p): ?>
            <tr>
              <td><strong><?php echo htmlspecialchars($p['child_name']); ?></strong></td>
              <td><?php echo htmlspecialchars($p['icon_url'] . ' ' . $p['item_name']); ?></td>
              <td><?php echo htmlspecialchars(date("M d, Y", strtotime($p['purchase_date']))); ?></td>
              <td class="coins-val" style="text-align:right;">-<?php echo htmlspecialchars($p['coins_spent']); ?></td>
            </tr>
          <?php endforeach; ?>
        <?php endif; ?>
      </tbody>
    </table>
  </div>

</main>

 <footer>
        © 2025 Gyan Setu. All rights reserved.
  </footer>

<script>
  // Animate circular progress on load
  const fill = document.getElementById('cp-fill');
  const r = 28;
  const circ = 2 * Math.PI * r;
  const pct = <?php echo ($overall_progress / 100); ?>;
  fill.style.strokeDasharray = circ;
  fill.style.strokeDashoffset = circ;
  setTimeout(() => {
    fill.style.transition = 'stroke-dashoffset 1.2s ease';
    fill.style.strokeDashoffset = circ * (1 - pct);
  }, 200);

  // Animate weekly bars on load
  document.querySelectorAll('.week-bar-fill').forEach(bar => {
    const h = bar.style.height;
    bar.style.height = '0%';
    setTimeout(() => { bar.style.height = h; }, 300);
  });

  // Animate mini progress bars
  document.querySelectorAll('.mini-bar-fill').forEach(bar => {
    const w = bar.style.width;
    bar.style.width = '0%';
    setTimeout(() => { bar.style.width = w; }, 400);
  });

  // Profile Dropdown Toggle
  function toggleDropdown() {
    const menu = document.getElementById('profileDropdownMenu');
    const btn  = document.getElementById('profileAvatarBtn');
    if (menu && btn) {
      const isOpen = menu.classList.toggle('open');
      btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    }
  }

  // Close profile dropdown when clicking outside
  document.addEventListener('click', function(e) {
    const wrapper = document.getElementById('profileDropdownWrapper');
    if (wrapper && !wrapper.contains(e.target)) {
      const menu = document.getElementById('profileDropdownMenu');
      const btn  = document.getElementById('profileAvatarBtn');
      if (menu) menu.classList.remove('open');
      if (btn) btn.setAttribute('aria-expanded', 'false');
    }
  });

  // Mobile Nav Menu Toggle
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

      navWrapper.querySelectorAll('a').forEach(function(link) {
        link.addEventListener('click', function() {
          navWrapper.classList.remove('show');
          toggleBtn.setAttribute('aria-expanded', 'false');
          toggleBtn.innerHTML = '&#9776;';
        });
      });

      document.addEventListener('click', function(e) {
        if (!navWrapper.contains(e.target) && !toggleBtn.contains(e.target)) {
          navWrapper.classList.remove('show');
          toggleBtn.setAttribute('aria-expanded', 'false');
          toggleBtn.innerHTML = '&#9776;';
        }
      });

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
<script src="js/script.js"></script>
</body>
</html>
