<?php
session_start();
require 'database/includes/db_connect.php';

if (!isset($_SESSION['role']) || !in_array($_SESSION['role'], ['child', 'parent'], true)) {
    header('Location: login.php');
    exit();
}

if ($_SESSION['role'] === 'child') {
    $childId = (int) $_SESSION['user_id'];
    $username = $_SESSION['username'];
} else {
    $parentId = (int) $_SESSION['user_id'];
    $childStmt = $conn->prepare('SELECT child_id, username FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1');
    $childStmt->bind_param('i', $parentId);
    $childStmt->execute();
    $child = $childStmt->get_result()->fetch_assoc();
    $childStmt->close();
    if (!$child) {
        header('Location: child_profilesetuppage.php');
        exit();
    }
    $childId = (int) $child['child_id'];
    $username = $_SESSION['username'] ?? $child['username'];
}

function badgeSlug(string $value): string {
    return trim((string) preg_replace('/-+/', '-', preg_replace('/[^a-z0-9]+/', '-', strtolower($value))), '-');
}

// Categories come from games that are referenced by badge criteria. Adding a game
// and its criteria is enough for it to appear here. `subject` is optional for older DBs.
$hasSubjectColumn = (bool) $conn->query("SHOW COLUMNS FROM games LIKE 'subject'")->num_rows;
$subjectExpression = $hasSubjectColumn
    ? "COALESCE(NULLIF(g.subject, ''), g.title)"
    : "CASE WHEN g.game_id = 1 THEN 'English' ELSE g.title END";
$categories = [];
$categorySql = "SELECT DISTINCT g.game_id, g.title AS game_title, $subjectExpression AS subject_name
                FROM games g INNER JOIN badge_criteria bc ON bc.game_id = g.game_id
                ORDER BY subject_name, g.title";
$categoryRows = $conn->query($categorySql);
while ($row = $categoryRows->fetch_assoc()) {
    $slug = badgeSlug($row['subject_name']);
    if (!isset($categories[$slug])) {
        $categories[$slug] = ['slug' => $slug, 'name' => $row['subject_name'], 'game_ids' => [], 'game_titles' => []];
    }
    $categories[$slug]['game_ids'][] = (int) $row['game_id'];
    $categories[$slug]['game_titles'][] = $row['game_title'];
}

// These two supplied thumbnails are kept as friendly defaults. Any future DB category
// still gets a selectable card, even before artwork is added.
$thumbnailBySubject = [
    'english' => 'badges/english badge thumbnail.png',
    'general-knowledge' => 'badges/gk thumbnail.png',
    'science' => 'badges/gk thumbnail.png',
];
foreach (['english' => 'English', 'general-knowledge' => 'General Knowledge', 'science' => 'Science'] as $slug => $name) {
    if (!isset($categories[$slug])) {
        $categories[$slug] = ['slug' => $slug, 'name' => $name, 'game_ids' => [], 'game_titles' => []];
    }
}

$selectedSlug = badgeSlug($_GET['subject'] ?? '');
$selected = $selectedSlug !== '' && isset($categories[$selectedSlug]) ? $categories[$selectedSlug] : null;
$badges = [];
if ($selected && $selected['game_ids']) {
    $ids = implode(',', array_map('intval', $selected['game_ids']));
    $badgeSql = "SELECT DISTINCT b.badge_id, b.title, b.description, b.coins_reward,
                    CASE WHEN cb.badge_id IS NULL THEN 0 ELSE 1 END AS earned
                 FROM badges b
                 INNER JOIN badge_criteria bc ON bc.badge_id = b.badge_id
                 LEFT JOIN child_badges cb ON cb.badge_id = b.badge_id AND cb.child_id = ?
                 WHERE bc.game_id IN ($ids) OR bc.game_id IS NULL
                 ORDER BY b.badge_id";
    $badgeStmt = $conn->prepare($badgeSql);
    $badgeStmt->bind_param('i', $childId);
    $badgeStmt->execute();
    $result = $badgeStmt->get_result();
    while ($row = $result->fetch_assoc()) {
        $badges[] = $row;
    }
    $badgeStmt->close();
}

$badgePhotos = [
    'first steps' => 'badges/first steps.png',
    'grammar starter' => 'badges/grammar starter.png',
    'perfect score' => 'badges/perfect score.png',
    'sharp shooter' => 'badges/sharp shooter.png',
];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - Badges</title>
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/badges.css">
</head>
<body>
    <header class="dashboard-navbar">
        <a href="index.html" class="logo"><img src="assets/images/website/logo.png" alt="Gyan Setu Logo" class="logo-img"><h2>ज्ञान Setu</h2></a>
        <button class="menu-toggle" type="button" id="menuToggleBtn" aria-label="Open menu" aria-expanded="false">&#9776;</button>
        <div class="nav-wrapper">
            <nav class="dashboard-menu"><a href="child-dashboard.php">🎮 Game Zone</a><a href="progress.html">📈 My Progress</a><a href="shop.php">🏪 Store</a></nav>
            <div class="dashboard-right">
                <button class="language-btn" type="button">🌐 Language</button>
                <div class="profile-dropdown-wrapper" id="profileDropdownWrapper">
                    <button class="profile-avatar-btn" id="profileAvatarBtn" onclick="toggleDropdown()" title="Profile Menu" aria-haspopup="true" aria-expanded="false"><?php echo htmlspecialchars(strtoupper(substr($username, 0, 1))); ?></button>
                    <div class="profile-dropdown-menu" id="profileDropdownMenu" role="menu">
                        <div class="dropdown-header"><div class="dh-name"><?php echo htmlspecialchars($username); ?></div><div class="dh-role">Child Account</div></div>
                        <a href="grownup-gate.php" class="dropdown-item" role="menuitem"><span class="di-icon">👨‍💼</span>Player Management</a>
                        <div class="dropdown-divider"></div><a href="logout.php" class="dropdown-item danger" role="menuitem"><span class="di-icon">🚪</span>Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="badges-page">
        <?php if (!$selected): ?>
            <a class="badges-back" href="child-dashboard.php">← Back to Game Zone</a>
            <div class="badges-intro"><h1>My Badges</h1></div>
            <section class="subject-badge-grid" aria-label="Badge subjects">
                <?php foreach ($categories as $category): $thumbnail = $thumbnailBySubject[$category['slug']] ?? null; ?>
                    <a class="subject-badge-card" href="badges.php?subject=<?php echo urlencode($category['slug']); ?>">
                        <?php if ($thumbnail): ?><img src="<?php echo htmlspecialchars($thumbnail); ?>" alt="<?php echo htmlspecialchars($category['name']); ?> badges">
                        <?php else: ?><div class="subject-art-placeholder">🏅</div><?php endif; ?>
                        <span><?php echo htmlspecialchars($category['name']); ?></span>
                    </a>
                <?php endforeach; ?>
            </section>
        <?php else: ?>
            <a class="badges-back" href="badges.php">← Choose another subject</a>
            <div class="badges-intro"><h1><?php echo htmlspecialchars($selected['name']); ?> Badges</h1><p>Earn these by playing <?php echo htmlspecialchars(implode(', ', $selected['game_titles']) ?: 'this subject'); ?>.</p></div>
            <?php if ($badges): ?>
                <div class="badge-table" role="table" aria-label="<?php echo htmlspecialchars($selected['name']); ?> badges">
                    <div class="badge-table-head" role="row"><span>Badge</span><span>Description</span><span>Coins</span></div>
                    <?php foreach ($badges as $badge): $photo = $badgePhotos[strtolower($badge['title'])] ?? null; ?>
                        <div class="badge-table-row <?php echo $badge['earned'] ? 'is-earned' : 'is-locked'; ?>" role="row">
                            <div class="badge-art" role="cell">
                                <?php if ($photo): ?><img src="<?php echo htmlspecialchars($photo); ?>" alt="<?php echo htmlspecialchars($badge['title']); ?>">
                                <?php else: ?><div class="badge-art-placeholder" aria-label="Badge artwork coming soon"></div><?php endif; ?>
                            </div>
                            <div class="badge-copy" role="cell">
                                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 7px;">
                                    <h2 style="margin: 0;"><?php echo htmlspecialchars($badge['title']); ?></h2>
                                    <?php if ($badge['earned']): ?>
                                        <span style="background: #7cb342; color: #fff; font-size: 11px; font-weight: 800; padding: 2px 8px; border-radius: 12px; display: inline-flex; align-items: center; gap: 3px;">✓ Unlocked</span>
                                    <?php else: ?>
                                        <span style="background: #e0e0e0; color: #757575; font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 12px; display: inline-flex; align-items: center; gap: 3px;">🔒 Locked</span>
                                    <?php endif; ?>
                                </div>
                                <p><?php echo htmlspecialchars($badge['description']); ?></p>
                            </div>
                            <div class="badge-coin" role="cell"><img src="wack-a-mole/assets/coin2.png" alt=""><span><?php echo (int) $badge['coins_reward']; ?></span></div>
                        </div>
                    <?php endforeach; ?>
                </div>
            <?php else: ?>
                <div class="badges-empty">Badges for this subject will appear here when its badge criteria are added.</div>
            <?php endif; ?>
        <?php endif; ?>
    </main>
    <footer class="dashboard-footer">© 2025 Gyan Setu. All rights reserved.</footer>
    <script>
        function toggleDropdown() { const m = document.getElementById('profileDropdownMenu'); const b = document.getElementById('profileAvatarBtn'); const open = m.classList.toggle('open'); b.setAttribute('aria-expanded', open ? 'true' : 'false'); }
        document.addEventListener('click', e => { const w = document.getElementById('profileDropdownWrapper'); if (w && !w.contains(e.target)) { document.getElementById('profileDropdownMenu').classList.remove('open'); } });
        document.getElementById('menuToggleBtn').addEventListener('click', () => document.querySelector('.nav-wrapper').classList.toggle('show'));
    </script>
</body>
</html>
