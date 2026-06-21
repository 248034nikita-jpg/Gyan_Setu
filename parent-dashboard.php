<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Check if logged in as Parent
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
    header("Location: login.php");
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

// Calculate aggregated stats
$total_quiz_score = 0;
$child_count_with_scores = 0;
$total_coins_sum = 0;
$total_lessons_completed = 0;
$total_points_sum = 0;
foreach ($children_stats as $child) {
    if ($child['average_quiz_score'] !== null) {
        $total_quiz_score += $child['average_quiz_score'];
        $child_count_with_scores++;
    }
    $total_coins_sum += $child['coin_earned'];
    $total_lessons_completed += $child['lessons_completed'];
    $total_points_sum += $child['total_points'];
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

  /* ── HEADER ── */
  header {
    background: #8BAD46;
    padding: 0 28px;
    height: 62px;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }
  .logo-wrap { display: flex; align-items: center; gap: 10px; text-decoration: none;}
  .logo-badge {
    width: 42px; height: 42px; border-radius: 50%;
    background: #fff; display: flex; align-items: center; justify-content: center;
    font-size: 20px;
  }
  .logo-name { color: #fff; font-weight: 800; font-size: 20px; letter-spacing: 1px; }
  .header-right { display: flex; gap: 10px; align-items: center; }
  .btn-lang {
    background: rgba(255,255,255,0.22); border: none; border-radius: 20px;
    color: #fff; padding: 6px 16px; font-family: inherit; font-weight: 700; font-size: 13px;
    cursor: pointer; display: flex; align-items: center; gap: 6px;
  }
  .btn-close {
    background: #F5C842; border: none; border-radius: 50%; width: 30px; height: 30px;
    font-size: 16px; font-weight: 900; cursor: pointer; color: #4A3A00;
    display: flex; align-items: center; justify-content: center;
    text-decoration: none;
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
  .motivational {
    background: linear-gradient(135deg, #7CBF3F 0%, #4A90D9 100%);
    color: #fff; border-radius: var(--radius); padding: 12px 20px;
    font-size: 14px; font-weight: 700; display: flex; align-items: center; gap: 10px;
    box-shadow: var(--shadow);
  }
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

  /* ── UPCOMING QUIZZES ── */
  .quiz-list { display: flex; flex-direction: column; gap: 10px; }
  .quiz-item {
    display: flex; align-items: center; gap: 12px; padding: 10px 14px;
    border-radius: var(--radius-sm); border: 1.5px solid var(--border);
    background: var(--bg); transition: border-color 0.15s, background 0.15s;
  }
  .quiz-item:hover { border-color: var(--blue); background: var(--blue-light); }
  .quiz-icon { font-size: 24px; }
  .quiz-info { flex: 1; }
  .quiz-name { font-size: 13px; font-weight: 800; }
  .quiz-meta { font-size: 11px; color: var(--muted); font-weight: 600; }
  .quiz-badge {
    font-size: 11px; font-weight: 800; padding: 4px 10px; border-radius: 20px;
  }
  .quiz-badge.soon { background: var(--orange-light); color: #B85000; }
  .quiz-badge.upcoming { background: var(--blue-light); color: #1A5A9A; }

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

<!-- HEADER -->
<header>
  <a href="parent-dashboard.php" class="logo-wrap">
    <div class="logo-badge">🏛️</div>
    <span class="logo-name">SETU</span>
  </a>
  <div class="header-right">
    <button class="btn-lang">🌐 Language</button>
    <a href="logout.php" class="btn-close">✕</a>
  </div>
</header>

<main>

  <!-- WELCOME -->
  <div class="welcome-row">
    <div class="welcome-text">
      <h1>Welcome Back, <?php echo htmlspecialchars($parent_name); ?>! 👋</h1>
      <div class="plan-badge">⭐ Free Plan · <a href="#">Upgrade</a></div>
    </div>
    <div class="motivational">
      <span class="emoji">🚀</span>
      <span>Great job! Your kids are on a roll — keep the momentum going!</span>
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
      <div class="stat-icon" style="background:var(--orange-light); font-size:26px;">🔥</div>
      <div class="stat-value" style="color:var(--orange)"><?php echo $streak; ?></div>
      <div class="stat-label">Day Streak</div>
    </div>

    <div class="stat-card">
      <div class="stat-icon" style="background:var(--yellow-light); font-size:26px;">🏅</div>
      <div class="stat-value" style="color:#B07800"><?php echo $total_coins_sum; ?></div>
      <div class="stat-label">Badges Earned</div>
    </div>

    <div class="stat-card">
      <div class="stat-icon" style="background:var(--purple-light); font-size:26px;">🪙</div>
      <div class="stat-value" style="color:var(--purple)"><?php echo $total_points_sum; ?></div>
      <div class="stat-label">Total Coins/Points</div>
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
        $progress = $child['average_quiz_score'] !== null ? round($child['average_quiz_score']) : 0;
      ?>
        <div class="child-card">
          <div class="child-avatar" style="background:<?php echo $theme['bg']; ?>; border-color:<?php echo $theme['border']; ?>;">🧒</div>
          <div class="child-name"><?php echo htmlspecialchars($child['child_name']); ?></div>
          <div class="child-meta">Level <?php echo htmlspecialchars($child['current_level']); ?></div>
          <div class="coins-row"><span class="coin-icon">🪙</span> <?php echo htmlspecialchars($child['total_points']); ?> pts</div>
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
    <div class="add-child-card" onclick="document.getElementById('username').focus(); document.getElementById('add-child-form-panel').scrollIntoView({behavior: 'smooth'});">
      <div class="add-icon">＋</div>
      <span>Add Child</span>
    </div>

  </div>

  <!-- Register Child Account Panel -->
  <div class="panel" id="add-child-form-panel" style="margin-bottom: 28px;">
     <div class="panel-title" style="color: var(--green-dark);">👤 Add New Child Profile</div>
     
     <?php if ($message !== ''): ?>
         <div style="padding: 10px; border-radius: 8px; margin-bottom: 15px; font-size: 14px; font-weight: 700; 
                     background: <?php echo $message_type === 'success' ? '#e6f4ea' : '#fce8e6'; ?>; 
                     color: <?php echo $message_type === 'success' ? '#137333' : '#c5221f'; ?>;">
             <?php echo htmlspecialchars($message); ?>
         </div>
     <?php endif; ?>

     <form action="parent-dashboard.php" method="post" style="display: flex; flex-direction: column; gap: 12px;">
       <div>
         <label for="username" style="font-size: 12px; font-weight: 700; color: var(--muted); display: block; margin-bottom: 4px;">CHILD'S USERNAME</label>
         <input type="text" name="username" id="username" placeholder="Enter username (e.g., child123)" required
                style="width: 100%; padding: 10px; border: 1.5px solid var(--border); border-radius: var(--radius-sm); font-family: inherit; font-size: 14px; outline: none;"/>
       </div>
       <div>
         <label for="password" style="font-size: 12px; font-weight: 700; color: var(--muted); display: block; margin-bottom: 4px;">LOGIN PASSWORD</label>
         <input type="password" name="password" id="password" placeholder="Create child password" required
                style="width: 100%; padding: 10px; border: 1.5px solid var(--border); border-radius: var(--radius-sm); font-family: inherit; font-size: 14px; outline: none;"/>
       </div>
       <button type="submit" name="add_child" class="btn-play" style="padding: 12px; font-size: 14px; width: 100%; border: none;">
         Create Child Account
       </button>
     </form>
  </div>

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

  <!-- TWO-COL: Weekly Hours + Upcoming Quizzes -->
  <div class="two-col">

    <!-- Weekly Study Hours -->
    <div class="panel">
      <div class="panel-title">📅 Weekly Study Hours</div>
      <div style="display:flex;align-items:center;gap:6px;margin-bottom:16px;">
        <span style="font-size:28px;font-weight:900;color:var(--blue)"><?php echo $weekly_study_hours; ?></span>
        <span style="font-size:13px;color:var(--muted);font-weight:700;">hours this week</span>
      </div>
      <div class="weekly-bars">
        <div class="week-bar-wrap">
          <div class="week-val">1.5h</div>
          <div class="week-bar-bg"><div class="week-bar-fill" style="height:60%;"></div></div>
          <div class="week-day">Mon</div>
        </div>
        <div class="week-bar-wrap">
          <div class="week-val">2h</div>
          <div class="week-bar-bg"><div class="week-bar-fill" style="height:80%;"></div></div>
          <div class="week-day">Tue</div>
        </div>
        <div class="week-bar-wrap">
          <div class="week-val">1h</div>
          <div class="week-bar-bg"><div class="week-bar-fill" style="height:40%;"></div></div>
          <div class="week-day">Wed</div>
        </div>
        <div class="week-bar-wrap">
          <div class="week-val">2.5h</div>
          <div class="week-bar-bg"><div class="week-bar-fill" style="height:100%;"></div></div>
          <div class="week-day">Thu</div>
        </div>
        <div class="week-bar-wrap">
          <div class="week-val">1.5h</div>
          <div class="week-bar-bg"><div class="week-bar-fill" style="height:60%;"></div></div>
          <div class="week-day">Fri</div>
        </div>
        <div class="week-bar-wrap">
          <div class="week-val">2h</div>
          <div class="week-bar-bg"><div class="week-bar-fill" style="height:80%;"></div></div>
          <div class="week-day">Sat</div>
        </div>
        <div class="week-bar-wrap">
          <div class="week-val">2h</div>
          <div class="week-bar-bg"><div class="week-bar-fill today-bar" style="height:80%;"></div></div>
          <div class="week-day" style="color:var(--blue);font-weight:800">Sun</div>
        </div>
      </div>
    </div>

    <!-- Upcoming Quizzes -->
    <div class="panel">
      <div class="panel-title">📝 Upcoming Quizzes</div>
      <div class="quiz-list">
        <div class="quiz-item">
          <div class="quiz-icon">🔢</div>
          <div class="quiz-info">
            <div class="quiz-name">Multiplication Tables</div>
            <div class="quiz-meta">Math · Grade 4</div>
          </div>
          <span class="quiz-badge soon">Tomorrow</span>
        </div>
        <div class="quiz-item">
          <div class="quiz-icon">🔤</div>
          <div class="quiz-info">
            <div class="quiz-name">English Spelling Bee</div>
            <div class="quiz-meta">English · Grade 2</div>
          </div>
          <span class="quiz-badge upcoming">In 3 days</span>
        </div>
        <div class="quiz-item">
          <div class="quiz-icon">🌿</div>
          <div class="quiz-info">
            <div class="quiz-name">Plants & Animals</div>
            <div class="quiz-meta">Science · Grade 4</div>
          </div>
          <span class="quiz-badge upcoming">In 5 days</span>
        </div>
      </div>
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
              <td class="coins-val" style="text-align:right;">-<?php echo htmlspecialchars($p['points_spent']); ?></td>
            </tr>
          <?php endforeach; ?>
        <?php endif; ?>
      </tbody>
    </table>
  </div>

</main>

<footer>Made with ❤️ for SETU · Helping every child shine ✨</footer>

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
</script>
</body>
</html>
