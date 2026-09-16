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
<link href="css/parent_dashboard.css" rel="stylesheet"/>
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
  <p class="section-title">Safe Screentime Mode</p>
  <div class="panel" style="margin-bottom:28px;">
    <select class="screentime-dropdown" id="screentime-dropdown">
      <option value="0" selected>🔓 Unlimited Mode</option>
      <option value="30">⏱️ Time Limit – 30 mins/day</option>
      <option value="60">⏱️ Time Limit – 1 hour/day</option>
      <option value="120">⏱️ Time Limit – 2 hours/day</option>
    </select>
    <div id="screentime-status-msg" style="margin-top:8px; font-size:13px; font-weight:700; color:#2e7d32; display:none;"></div>
    <p style="margin-top:10px;font-size:13px;font-weight:600;color:var(--muted);">
      <?php if ($total_children > 0): ?>
        ✅ Screentime protection is active for <?php echo $total_children; ?> children.
      <?php else: ?>
        Screentime protection is ready. Add a child profile to activate.
      <?php endif; ?>
    </p>
  </div>

  <!-- PARENT RESOURCES SHOP -->
  <p class="section-title">Parent Resources Shop</p>
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
  <p class="section-title">My Children</p>
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
          <div class="coins-row"><span class="coin-icon"><img src="assets/images/website/coin.png" alt="Coin" width="24" height="24"></span> <?php echo htmlspecialchars($child['total_coins']); ?> pts</div>
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
    <?php if ($total_children < 2): ?>
      <div class="add-child-card" onclick="location.href='child_profilesetuppage.php';" title="Add child profile (Max 2)">
        <div class="add-icon">＋</div>
        <span>Add Child (<?php echo $total_children; ?>/2)</span>
      </div>
    <?php else: ?>
      <div class="add-child-card disabled" onclick="alert('You have reached the maximum limit of 2 child profiles.');" title="Maximum of 2 child profiles reached.">
        <div class="add-icon" style="font-size:20px;">🔒</div>
        <span>Max Limit (2/2)</span>
      </div>
    <?php endif; ?>

  </div>

  <!-- STATS ROW -->
  <p class="section-title">Overall Learning Progress</p>
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
      <div class="stat-icon" style="background:var(--purple-light); font-size:26px;"><img src="assets/images/website/coin.png" alt="Coin" width="24" height="24"></div>
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
      <div class="panel-title">Learning Streak — <?php echo $streak; ?> Days!</div>
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
      <div class="panel-title">Badges Earned</div>
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
    <div class="panel-title" style="color:#7A5A00;">Children Store Transactions</div>
    <table class="purchase-table">
      <thead>
        <tr>
          <th>Child Name</th>
          <th>Worksheet / Item</th>
          <th>Date</th>
          <th style="text-align:right;"><img src="assets/images/website/coin.png" alt="Coin" width="24" height="24">Coins / Points</th>
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

  // Screentime parent dropdown management
  document.addEventListener('DOMContentLoaded', function() {
    const dropdown = document.getElementById('screentime-dropdown');
    const msgEl = document.getElementById('screentime-status-msg');

    if (!dropdown) return;

    // Fetch parent's saved limit setting
    fetch('time_limit/screentime_api.php?action=get_parent_limit')
      .then(res => res.json())
      .then(data => {
        if (data.success && data.limit_minutes !== undefined) {
          dropdown.value = String(data.limit_minutes);
        }
      })
      .catch(err => console.error('Failed to fetch parent screentime setting:', err));

    // Handle dropdown change
    dropdown.addEventListener('change', function() {
      const selectedValue = dropdown.value;

      const formData = new FormData();
      formData.append('action', 'set_limit');
      formData.append('limit_minutes', selectedValue);

      fetch('time_limit/screentime_api.php', {
        method: 'POST',
        body: formData
      })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          if (msgEl) {
            msgEl.textContent = '✅ ' + data.message;
            msgEl.style.display = 'block';
            setTimeout(() => { msgEl.style.display = 'none'; }, 4000);
          }
        } else {
          alert('Failed to update screentime limit: ' + (data.error || 'Unknown error'));
        }
      })
      .catch(err => {
        console.error('Error setting screentime limit:', err);
        alert('An error occurred while saving screentime setting.');
      });
    });
  });
</script>
<script src="js/script.js"></script>
</body>
</html>
