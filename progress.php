<?php
session_start();
include 'database/includes/db_connect.php';

// Route Protection: Accept both 'child' and 'parent' sessions
if (!isset($_SESSION['role']) || !in_array($_SESSION['role'], ['child', 'parent'])) {
    header("Location: login.php");
    exit();
}

// Generate parent access token if needed
if (!isset($_SESSION['parent_access_token'])) {
    $_SESSION['parent_access_token'] = bin2hex(random_bytes(16));
}

// --- Resolve which child to show ---
if ($_SESSION['role'] === 'child') {
    $child_id = $_SESSION['user_id'];
    $username = $_SESSION['username'];
} else {
    // Parent viewing child's progress
    if (isset($_GET['child_id']) && is_numeric($_GET['child_id'])) {
        $child_id = (int)$_GET['child_id'];
    } else {
        $parent_id_lookup = $_SESSION['user_id'];
        $stmt = $conn->prepare("SELECT child_id, username FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
        $stmt->bind_param("i", $parent_id_lookup);
        $stmt->execute();
        $res = $stmt->get_result();
        $child_row = $res->fetch_assoc();
        $stmt->close();

        if (!$child_row) {
            header("Location: child_profilesetuppage.php");
            exit();
        }
        $child_id = $child_row['child_id'];
    }
    
    // Lookup child username
    $stmt = $conn->prepare("SELECT username FROM children WHERE child_id = ?");
    $stmt->bind_param("i", $child_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $c_info = $res->fetch_assoc();
    $username = $c_info['username'] ?? $_SESSION['username'];
    $stmt->close();
}

// --- Fetch Child Basic Info ---
$stmt = $conn->prepare("SELECT total_coins, current_level, age, created_at FROM children WHERE child_id = ?");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
$child_info = $res->fetch_assoc();
$stmt->close();

if (!$child_info) {
    session_destroy();
    header("Location: login.php");
    exit();
}

$total_points  = (int)$child_info['total_coins'];
$current_level = (int)$child_info['current_level'];
$child_age     = (int)($child_info['age'] ?? 8);

// --- Fetch Badges Summary ---
$earned_badge_ids = [];
$stmt = $conn->prepare("SELECT badge_id FROM child_badges WHERE child_id = ?");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $earned_badge_ids[] = (int)$row['badge_id'];
}
$stmt->close();

$all_badges = [];
$res = $conn->query("SELECT badge_id, title, description, icon_url, coins_reward FROM badges ORDER BY badge_id ASC");
while ($row = $res->fetch_assoc()) {
    $row['earned'] = in_array((int)$row['badge_id'], $earned_badge_ids);
    $all_badges[] = $row;
}
$badges_earned_count = count($earned_badge_ids);
$total_badges_count  = count($all_badges);

// --- Fetch Overall Scores & Accuracy Aggregates ---
$stmt = $conn->prepare("
    SELECT 
        COUNT(*) as total_rounds,
        COALESCE(AVG(accuracy_percentage), 0) as avg_accuracy,
        COALESCE(MAX(score_value), 0) as max_score,
        COALESCE(SUM(coins_earned), 0) as coins_from_scores,
        COALESCE(MAX(streak_achieved), 0) as best_streak
    FROM scores 
    WHERE child_id = ?
");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$overall_stats = $stmt->get_result()->fetch_assoc();
$stmt->close();

$total_rounds_played = (int)$overall_stats['total_rounds'];
$overall_avg_accuracy = round((float)$overall_stats['avg_accuracy'], 1);
$overall_best_streak  = (int)$overall_stats['best_streak'];

// --- Additional Progress Counts from Specific Games ---
// Alphabet Adventure Progress
$stmt = $conn->prepare("SELECT COUNT(*) as words_done FROM alphabet_adventure_progress WHERE child_id = ? AND completed = 1");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$alphabets_words_done = (int)($stmt->get_result()->fetch_assoc()['words_done'] ?? 0);
$stmt->close();

// Capybara Progress
$stmt = $conn->prepare("SELECT COUNT(*) as facts_seen, SUM(correct_attempts) as correct_facts FROM capybara_child_progress WHERE child_id = ?");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$capybara_stats = $stmt->get_result()->fetch_assoc();
$capybara_facts_done = (int)($capybara_stats['facts_seen'] ?? 0);
$stmt->close();

// --- Estimate Time Spent ---
$estimated_time_minutes = ($total_rounds_played * 4) + ($alphabets_words_done * 2) + ($capybara_facts_done * 2);
if ($total_rounds_played > 0 && $estimated_time_minutes < 15) {
    $estimated_time_minutes = 15;
}
$time_hours = floor($estimated_time_minutes / 60);
$time_mins  = $estimated_time_minutes % 60;
$formatted_time_spent = $time_hours > 0 ? "{$time_hours}h {$time_mins}m" : "{$time_mins} mins";

// --- Weekly Activity & Time Spent Chart (Last 7 Days) ---
$weekly_activity = [];
for ($i = 6; $i >= 0; $i--) {
    $date_key = date('Y-m-d', strtotime("-$i days"));
    $day_name = date('D', strtotime("-$i days"));
    $weekly_activity[$date_key] = [
        'day' => $day_name,
        'date' => date('M j', strtotime("-$i days")),
        'rounds' => 0,
        'time_mins' => 0
    ];
}

$stmt = $conn->prepare("
    SELECT DATE(date_played) as play_date, COUNT(*) as round_count 
    FROM scores 
    WHERE child_id = ? AND date_played >= CURDATE() - INTERVAL 6 DAY 
    GROUP BY DATE(date_played)
");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $pdate = $row['play_date'];
    if (isset($weekly_activity[$pdate])) {
        $rc = (int)$row['round_count'];
        $weekly_activity[$pdate]['rounds'] = $rc;
        $weekly_activity[$pdate]['time_mins'] = $rc * 4;
    }
}
$stmt->close();

$max_weekly_time = 1;
foreach ($weekly_activity as $wa) {
    if ($wa['time_mins'] > $max_weekly_time) $max_weekly_time = $wa['time_mins'];
}

// --- Game Catalog & Subject Mapping ---
$game_catalog = [
    1 => [
        'game_id' => 1,
        'title' => 'Word Whack',
        'subject' => 'english',
        'subject_label' => '📚 ENGLISH',
        'icon' => '📚',
        'cover' => 'wack-a-mole/assets/thumbnail.jpg',
        'play_url' => 'wack-a-mole/index.php?child_id=' . $child_id,
        'border_color' => '#2196f3',
        'age' => 'Ages 8-9'
    ],
    2 => [
        'game_id' => 2,
        'title' => 'Capybara Nepal Adventure',
        'subject' => 'gk',
        'subject_label' => '🌍 GK / NEPAL',
        'icon' => '🌍',
        'cover' => 'games/capybara-platformer-quiz/assets/cover.png',
        'play_url' => 'games/capybara-platformer-quiz/index.html',
        'border_color' => '#ff9800',
        'age' => 'Ages 8-9'
    ],
    3 => [
        'game_id' => 3,
        'title' => 'Alphabet Adventure',
        'subject' => 'alphabets',
        'subject_label' => '🔤 ALPHABETS',
        'icon' => '🔤',
        'cover' => 'games/alphabet-adventure/assets/cover.jpg',
        'play_url' => 'games/alphabet-adventure/index.php',
        'border_color' => '#4caf50',
        'age' => 'Ages 4-6'
    ],
    4 => [
        'game_id' => 4,
        'title' => 'Quiz & Flashcards',
        'subject' => 'science',
        'subject_label' => '🔬 SCIENCE',
        'icon' => '🔬',
        'cover' => 'games/quiz_flashcard/assets/cover.png',
        'play_url' => 'games/quiz_flashcard/quiz_flashcard.html',
        'border_color' => '#9c27b0',
        'age' => 'Ages 4-12'
    ],
    5 => [
        'game_id' => 5,
        'title' => 'Hangman Spelling',
        'subject' => 'english',
        'subject_label' => '📚 ENGLISH',
        'icon' => '📚',
        'cover' => 'games/hangman/cover.png',
        'play_url' => 'games/hangman/index.php',
        'border_color' => '#21f37c',
        'age' => 'Ages 6-10'
    ]
];

// Dynamically extract ONLY active subjects that have games available
$active_subject_tabs = [];
foreach ($game_catalog as $g) {
    $s_key = $g['subject'];
    if (!isset($active_subject_tabs[$s_key])) {
        $active_subject_tabs[$s_key] = [
            'key' => $s_key,
            'label' => $g['subject_label'],
            'icon' => $g['icon']
        ];
    }
}

// Fetch per-game stats from scores
$game_stats = [];
$stmt = $conn->prepare("
    SELECT 
        game_id, 
        COUNT(*) as rounds_played,
        COALESCE(AVG(accuracy_percentage), 0) as avg_accuracy,
        COALESCE(MAX(accuracy_percentage), 0) as best_accuracy,
        COALESCE(MAX(score_value), 0) as high_score,
        COALESCE(SUM(coins_earned), 0) as coins_earned,
        COALESCE(MAX(streak_achieved), 0) as best_streak,
        MAX(date_played) as last_played
    FROM scores
    WHERE child_id = ?
    GROUP BY game_id
");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $gid = (int)$row['game_id'];
    $game_stats[$gid] = $row;
}
$stmt->close();

// Compute Subject-based Time & Stats Summary for active subjects only
$subject_stats = [];
foreach ($active_subject_tabs as $s_key => $s_meta) {
    $subject_stats[$s_key] = [
        'name' => str_replace(['📚 ', '🌍 ', '🔤 ', '🔬 '], '', $s_meta['label']),
        'icon' => $s_meta['icon'],
        'color' => '#7997cb',
        'time_mins' => 0,
        'rounds' => 0
    ];
}
if (isset($subject_stats['gk'])) $subject_stats['gk']['color'] = '#ff9800';
if (isset($subject_stats['english'])) $subject_stats['english']['color'] = '#2196f3';
if (isset($subject_stats['alphabets'])) $subject_stats['alphabets']['color'] = '#4caf50';
if (isset($subject_stats['science'])) $subject_stats['science']['color'] = '#9c27b0';

foreach ($game_catalog as $gid => $gdef) {
    $sub = $gdef['subject'];
    $r = (int)($game_stats[$gid]['rounds_played'] ?? 0);
    if (isset($subject_stats[$sub])) {
        $subject_stats[$sub]['rounds'] += $r;
        $subject_stats[$sub]['time_mins'] += ($r * 4);
    }
}
if (isset($subject_stats['alphabets']) && $alphabets_words_done > 0) {
    $subject_stats['alphabets']['time_mins'] += ($alphabets_words_done * 2);
}
if (isset($subject_stats['gk']) && $capybara_facts_done > 0) {
    $subject_stats['gk']['time_mins'] += ($capybara_facts_done * 2);
}

// --- Fetch Recent Activities Log (Limit to 15 total in DB query) ---
$recent_activities = [];
$stmt = $conn->prepare("
    SELECT s.*, g.title as db_game_title, g.subject as db_subject
    FROM scores s
    LEFT JOIN games g ON s.game_id = g.game_id
    WHERE s.child_id = ?
    ORDER BY s.date_played DESC
    LIMIT 15
");
$stmt->bind_param("i", $child_id);
$stmt->execute();
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) {
    $recent_activities[] = $row;
}
$stmt->close();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - My Progress</title>
    <link rel="stylesheet" href="css/dashboard.css?v=<?php echo time(); ?>">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Nunito', Arial, sans-serif;
            background: #f7f9f2;
            color: #2d3a1e;
        }

        .progress-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 25px 20px 50px 20px;
        }

        /* Hero Banner */
        .progress-hero {
            background: linear-gradient(135deg, #5c7cb8 0%, #7997cb 100%);
            color: white;
            padding: 24px 30px;
            border-radius: 20px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            box-shadow: 0 8px 24px rgba(121, 151, 203, 0.3);
        }

        .progress-hero h1 {
            font-size: 26px;
            font-weight: 900;
            margin-bottom: 6px;
            letter-spacing: -0.3px;
        }

        .progress-hero p {
            font-size: 15px;
            opacity: 0.92;
            font-weight: 600;
        }

        .hero-stats-grid {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .stat-badge-pill {
            background: rgba(255, 255, 255, 0.22);
            backdrop-filter: blur(8px);
            padding: 10px 18px;
            border-radius: 14px;
            text-align: center;
            min-width: 100px;
            border: 1px solid rgba(255, 255, 255, 0.25);
        }

        .stat-badge-pill .label {
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            opacity: 0.88;
        }

        .stat-badge-pill .value {
            font-size: 20px;
            font-weight: 900;
            margin-top: 2px;
        }

        /* Section Titles */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            margin-top: 35px;
        }

        .section-title {
            font-size: 22px;
            font-weight: 800;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Subject Filter Bar */
        .subject-filter-bar {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 10px;
            margin-bottom: 25px;
            scrollbar-width: thin;
        }

        .subject-btn {
            background: #ffffff;
            border: 2px solid #e2e8f0;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 800;
            color: #475569;
            cursor: pointer;
            white-space: nowrap;
            transition: all 0.25s ease;
            box-shadow: 0 2px 6px rgba(0,0,0,0.04);
        }

        .subject-btn:hover {
            transform: translateY(-2px);
            border-color: #7997cb;
            color: #1e293b;
        }

        .subject-btn.active {
            background: #7997cb;
            color: #ffffff;
            border-color: #7997cb;
            box-shadow: 0 4px 14px rgba(121, 151, 203, 0.4);
        }

        /* Analytics Overview Cards */
        .overview-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .metric-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.05);
            border: 2px solid #edf2f7;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .metric-icon {
            width: 54px;
            height: 54px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            flex-shrink: 0;
        }

        .metric-info h4 {
            font-size: 13px;
            color: #64748b;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        .metric-info .val {
            font-size: 24px;
            font-weight: 900;
            color: #0f172a;
            margin-top: 2px;
        }

        /* Games Progress Grid */
        .games-progress-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 22px;
            margin-bottom: 35px;
        }

        .game-progress-card {
            background: #ffffff;
            border-radius: 18px;
            border: 3px solid #e2e8f0;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .game-progress-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 28px rgba(0, 0, 0, 0.12);
        }

        .game-card-banner {
            height: 140px;
            background-size: cover;
            background-position: center;
            position: relative;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            padding: 12px;
        }

        .game-card-banner::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0.6) 100%);
        }

        .game-tag-badge {
            position: relative;
            z-index: 2;
            background: rgba(255, 255, 255, 0.95);
            color: #1e293b;
            font-size: 11px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }

        .game-play-link {
            position: relative;
            z-index: 2;
            background: #4caf50;
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 800;
            text-decoration: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            transition: transform 0.2s ease;
        }

        .game-play-link:hover {
            transform: scale(1.05);
        }

        .game-card-body {
            padding: 18px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .game-card-title {
            font-size: 18px;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 12px;
        }

        /* Accuracy Progress Bar */
        .accuracy-bar-wrapper {
            margin-bottom: 15px;
        }

        .accuracy-label {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            font-weight: 800;
            color: #475569;
            margin-bottom: 6px;
        }

        .accuracy-track {
            height: 10px;
            background: #e2e8f0;
            border-radius: 10px;
            overflow: hidden;
        }

        .accuracy-fill {
            height: 100%;
            border-radius: 10px;
            transition: width 0.8s ease-in-out;
        }

        .accuracy-fill.high { background: linear-gradient(90deg, #10b981, #059669); }
        .accuracy-fill.mid { background: linear-gradient(90deg, #f59e0b, #d97706); }
        .accuracy-fill.low { background: linear-gradient(90deg, #ef4444, #dc2626); }

        .game-mini-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
            background: #f8fafc;
            padding: 10px;
            border-radius: 12px;
            text-align: center;
        }

        .mini-stat-item .lbl {
            font-size: 10px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
        }

        .mini-stat-item .val {
            font-size: 14px;
            font-weight: 800;
            color: #1e293b;
            margin-top: 2px;
        }

        /* Time Spent & Charts Section */
        .analytics-two-col {
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 25px;
            margin-bottom: 35px;
        }

        @media (max-width: 850px) {
            .analytics-two-col {
                grid-template-columns: 1fr;
            }
        }

        .chart-box {
            background: #ffffff;
            border-radius: 20px;
            padding: 22px;
            border: 2px solid #edf2f7;
            box-shadow: 0 4px 16px rgba(0,0,0,0.04);
        }

        .chart-box h3 {
            font-size: 17px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Weekly Time Bar Graph */
        .weekly-bars {
            display: flex;
            align-items: flex-end;
            justify-content: space-around;
            height: 180px;
            padding-top: 20px;
            border-bottom: 2px solid #e2e8f0;
        }

        .bar-col {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            flex: 1;
        }

        .bar-val-label {
            font-size: 11px;
            font-weight: 800;
            color: #64748b;
        }

        .bar-fill-container {
            width: 28px;
            height: 130px;
            background: #f1f5f9;
            border-radius: 14px;
            display: flex;
            align-items: flex-end;
            overflow: hidden;
        }

        .bar-fill {
            width: 100%;
            background: linear-gradient(180deg, #7997cb 0%, #4f6fb3 100%);
            border-radius: 14px;
            transition: height 0.6s ease;
        }

        .bar-day-name {
            font-size: 12px;
            font-weight: 800;
            color: #334155;
            margin-top: 6px;
        }

        /* Subject Distribution Bars */
        .subject-time-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .subject-time-row {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .sub-time-header {
            display: flex;
            justify-content: space-between;
            font-size: 13px;
            font-weight: 800;
            color: #334155;
        }

        .sub-time-track {
            height: 8px;
            background: #f1f5f9;
            border-radius: 6px;
            overflow: hidden;
        }

        .sub-time-bar {
            height: 100%;
            border-radius: 6px;
        }

        /* Recent Activity Table / Feed */
        .recent-activity-card {
            background: #ffffff;
            border-radius: 20px;
            padding: 22px;
            border: 2px solid #edf2f7;
            box-shadow: 0 4px 16px rgba(0,0,0,0.04);
            margin-bottom: 35px;
        }

        .activity-feed-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .activity-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 18px;
            background: #f8fafc;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            transition: background 0.2s ease;
        }

        .activity-item:hover {
            background: #f1f5f9;
        }

        .activity-left {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .activity-icon-bubble {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: #ffffff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .activity-details h5 {
            font-size: 15px;
            font-weight: 800;
            color: #0f172a;
        }

        .activity-details p {
            font-size: 12px;
            color: #64748b;
            font-weight: 600;
            margin-top: 2px;
        }

        .activity-right {
            display: flex;
            align-items: center;
            gap: 15px;
            text-align: right;
        }

        .accuracy-pill {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 800;
        }

        .accuracy-pill.high { background: #d1fae5; color: #047857; }
        .accuracy-pill.mid { background: #fef3c7; color: #b45309; }
        .accuracy-pill.low { background: #fee2e2; color: #b91c1c; }

        .coins-earned-pill {
            font-size: 14px;
            font-weight: 900;
            color: #d97706;
        }

        .view-more-btn-wrapper {
            text-align: center;
            margin-top: 18px;
        }

        .view-more-btn {
            background: #f1f5f9;
            color: #475569;
            border: 2px solid #cbd5e1;
            padding: 10px 24px;
            border-radius: 25px;
            font-weight: 800;
            font-size: 13px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .view-more-btn:hover {
            background: #e2e8f0;
            color: #1e293b;
            transform: translateY(-2px);
        }

        /* Badges Section Banner */
        .badges-preview-box {
            background: linear-gradient(135deg, #fff7ed 0%, #ffedd5 100%);
            border: 2px solid #fed7aa;
            border-radius: 20px;
            padding: 22px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .badges-preview-info h3 {
            font-size: 18px;
            font-weight: 800;
            color: #9a3412;
            margin-bottom: 4px;
        }

        .badges-preview-info p {
            font-size: 13px;
            color: #c2410c;
            font-weight: 600;
        }

        .badges-view-btn {
            background: #ea580c;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 800;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(234, 88, 12, 0.3);
            transition: transform 0.2s ease;
        }

        .badges-view-btn:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

    <!-- Navbar (Matching Child Dashboard) -->
    <header class="dashboard-navbar">
        <a href="child-dashboard.php" class="logo">
            <img src="assets/images/website/logo.png" alt="Gyan Setu Logo" class="logo-img">
            <h2>ज्ञान Setu</h2>
        </a>
        <button class="menu-toggle" type="button" id="menuToggleBtn" aria-label="Open menu" aria-expanded="false">&#9776;</button>
        <div class="nav-wrapper">
            <nav class="dashboard-menu">
                <a href="child-dashboard.php">🎮 Game Zone</a>
                <a href="progress.php" style="color: #4a5c1d; border-bottom: 3px solid #4a5c1d; padding-bottom: 2px;">📈 My Progress</a>
                <a href="shop.php?child_id=<?php echo $child_id; ?>">🏪 Store</a>
            </nav>
            <div class="dashboard-right">
                <button class="language-btn">🌐 Language</button>
                <div class="profile-dropdown-wrapper" id="profileDropdownWrapper">
                    <button class="profile-avatar-btn" id="profileAvatarBtn" onclick="toggleDropdown()" title="Profile Menu" aria-haspopup="true" aria-expanded="false">
                        <?php echo strtoupper(substr($username, 0, 1)); ?>
                    </button>
                    <div class="profile-dropdown-menu" id="profileDropdownMenu" role="menu">
                        <div class="dropdown-header">
                            <div class="dh-name"><?php echo htmlspecialchars($username); ?></div>
                            <div class="dh-role"> Child Account</div>
                        </div>
                        <a href="child-dashboard.php" class="dropdown-item" role="menuitem">
                            <span class="di-icon">🎮</span> Game Zone
                        </a>
                        <a href="progress.php" class="dropdown-item" role="menuitem">
                            <span class="di-icon">📈</span> My Progress
                        </a>
                        <div class="dropdown-divider"></div>
                        <a href="grownup-gate.php" class="dropdown-item" role="menuitem">
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

    <!-- Main Content Container -->
    <main class="progress-container">

        <!-- Top Hero Banner -->
        <div class="progress-hero">
            <div>
                <h1>📊 <?php echo htmlspecialchars($username); ?>'s Learning Progress</h1>
                <p>Track your scores, accuracy, time spent & game achievements across subjects!</p>
            </div>
            <div class="hero-stats-grid">
                <div class="stat-badge-pill">
                    <div class="label">CURRENT LEVEL</div>
                    <div class="value">Level <?php echo $current_level; ?></div>
                </div>
                <div class="stat-badge-pill">
                    <div class="label">TOTAL COINS</div>
                    <div class="value">🪙 <?php echo $total_points; ?></div>
                </div>
                <div class="stat-badge-pill">
                    <div class="label">ACCURACY</div>
                    <div class="value" style="color: #6ee7b7;"><?php echo $overall_avg_accuracy; ?>%</div>
                </div>
            </div>
        </div>

        <!-- Metric Cards Overview -->
        <div class="overview-grid">
            <div class="metric-card">
                <div class="metric-icon" style="background: #e0f2fe; color: #0284c7;">🎯</div>
                <div class="metric-info">
                    <h4>Overall Accuracy</h4>
                    <div class="val"><?php echo $overall_avg_accuracy; ?>%</div>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon" style="background: #fef3c7; color: #d97706;">⏱️</div>
                <div class="metric-info">
                    <h4>Time Spent Learning</h4>
                    <div class="val"><?php echo $formatted_time_spent; ?></div>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon" style="background: #dcfce7; color: #15803d;">🎮</div>
                <div class="metric-info">
                    <h4>Rounds Played</h4>
                    <div class="val"><?php echo $total_rounds_played; ?> rounds</div>
                </div>
            </div>
            <div class="metric-card">
                <div class="metric-icon" style="background: #fae8ff; color: #a21caf;">🔥</div>
                <div class="metric-info">
                    <h4>Best Streak</h4>
                    <div class="val"><?php echo $overall_best_streak; ?> in a row</div>
                </div>
            </div>
        </div>

        <!-- Time Spent & Weekly Chart Analytics -->
        <div class="analytics-two-col">
            <!-- Weekly Activity Bar Chart -->
            <div class="chart-box">
                <h3>📊 Time Spent This Week (Minutes)</h3>
                <div class="weekly-bars">
                    <?php foreach ($weekly_activity as $wa): 
                        $pct = round(($wa['time_mins'] / $max_weekly_time) * 100);
                        if ($wa['time_mins'] > 0 && $pct < 15) $pct = 15;
                    ?>
                        <div class="bar-col">
                            <span class="bar-val-label"><?php echo $wa['time_mins'] > 0 ? $wa['time_mins'] . 'm' : '-'; ?></span>
                            <div class="bar-fill-container">
                                <div class="bar-fill" style="height: <?php echo $pct; ?>%;"></div>
                            </div>
                            <span class="bar-day-name"><?php echo $wa['day']; ?></span>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>

            <!-- Time Distribution by Subject -->
            <div class="chart-box">
                <h3>⏱️ Time Spent by Subject</h3>
                <div class="subject-time-list">
                    <?php 
                    $total_sub_time = max(1, array_sum(array_column($subject_stats, 'time_mins')));
                    foreach ($subject_stats as $sub_key => $sdata): 
                        $s_pct = round(($sdata['time_mins'] / $total_sub_time) * 100);
                    ?>
                        <div class="subject-time-row">
                            <div class="sub-time-header">
                                <span><?php echo $sdata['icon'] . ' ' . $sdata['name']; ?></span>
                                <span><?php echo $sdata['time_mins']; ?> mins (<?php echo $s_pct; ?>%)</span>
                            </div>
                            <div class="sub-time-track">
                                <div class="sub-time-bar" style="width: <?php echo $s_pct; ?>%; background: <?php echo $sdata['color']; ?>;"></div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>
        </div>

        <!-- Section: Game Scores & Accuracy Differentiated by Subject -->
        <div class="section-header">
            <h2 class="section-title">🎮 Subject Scores & Accuracy Breakdown</h2>
        </div>

        <!-- Dynamic Subject Filter Tabs (Only showing active subjects that have games) -->
        <div class="subject-filter-bar">
            <button type="button" class="subject-btn active" data-sub-key="all" onclick="filterSubject('all', this)">🌟 All Subjects</button>
            <?php foreach ($active_subject_tabs as $sk => $smeta): ?>
                <button type="button" class="subject-btn" data-sub-key="<?php echo $sk; ?>" onclick="filterSubject('<?php echo $sk; ?>', this)"><?php echo $smeta['label']; ?></button>
            <?php endforeach; ?>
        </div>

        <!-- Games Grid -->
        <div class="games-progress-grid" id="gamesProgressGrid">
            <?php foreach ($game_catalog as $gid => $gdef): 
                $st = $game_stats[$gid] ?? [
                    'rounds_played' => 0,
                    'avg_accuracy' => 0,
                    'best_accuracy' => 0,
                    'high_score' => 0,
                    'coins_earned' => 0,
                    'best_streak' => 0
                ];
                $rounds = (int)$st['rounds_played'];
                $avg_acc = round((float)$st['avg_accuracy'], 1);
                $high_sc = (int)$st['high_score'];
                $coins   = (int)$st['coins_earned'];

                if ($gid == 3 && $alphabets_words_done > 0) {
                    $rounds = max($rounds, $alphabets_words_done);
                }
                if ($gid == 2 && $capybara_facts_done > 0) {
                    $rounds = max($rounds, $capybara_facts_done);
                }

                $acc_class = 'mid';
                if ($avg_acc >= 85) $acc_class = 'high';
                else if ($avg_acc < 60) $acc_class = 'low';
            ?>
                <div class="game-progress-card" data-subject="<?php echo $gdef['subject']; ?>" style="border-color: <?php echo $gdef['border_color']; ?>;">
                    <div class="game-card-banner" style="background-image: url('<?php echo $gdef['cover']; ?>');">
                        <span class="game-tag-badge"><?php echo $gdef['subject_label']; ?></span>
                        <a href="<?php echo $gdef['play_url']; ?>" class="game-play-link">▶ Play Game</a>
                    </div>
                    <div class="game-card-body">
                        <div class="game-card-title"><?php echo htmlspecialchars($gdef['title']); ?></div>
                        
                        <div class="accuracy-bar-wrapper">
                            <div class="accuracy-label">
                                <span>Average Accuracy</span>
                                <span><?php echo $avg_acc; ?>%</span>
                            </div>
                            <div class="accuracy-track">
                                <div class="accuracy-fill <?php echo $acc_class; ?>" style="width: <?php echo max(5, $avg_acc); ?>%;"></div>
                            </div>
                        </div>

                        <div class="game-mini-stats">
                            <div class="mini-stat-item">
                                <div class="lbl">Rounds</div>
                                <div class="val"><?php echo $rounds; ?></div>
                            </div>
                            <div class="mini-stat-item">
                                <div class="lbl">High Score</div>
                                <div class="val"><?php echo $high_sc; ?></div>
                            </div>
                            <div class="mini-stat-item">
                                <div class="lbl">Coins</div>
                                <div class="val" style="color: #d97706;">🪙 <?php echo $coins; ?></div>
                            </div>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>

        <!-- Section: Recent Activities Feed (Initial 3 + View More Toggle) -->
        <div class="section-header">
            <h2 class="section-title">⏱️ Recent Activity Log</h2>
        </div>

        <div class="recent-activity-card">
            <?php if (empty($recent_activities)): ?>
                <div style="text-align: center; padding: 30px; color: #64748b; font-weight: 700;">
                    🎮 No recent games played yet! Jump into Game Zone to start playing.
                </div>
            <?php else: ?>
                <div class="activity-feed-list" id="activityFeedList">
                    <?php 
                    $total_recent_count = count($recent_activities);
                    foreach ($recent_activities as $idx => $act): 
                        $gid = (int)$act['game_id'];
                        $ginfo = $game_catalog[$gid] ?? [
                            'title' => $act['db_game_title'] ?? 'Game Session',
                            'subject' => strtolower($act['db_subject'] ?? 'english'),
                            'subject_label' => '🎮 GAME'
                        ];
                        $acc = (float)$act['accuracy_percentage'];
                        $acc_pill_class = 'mid';
                        if ($acc >= 85) $acc_pill_class = 'high';
                        else if ($acc < 60) $acc_pill_class = 'low';

                        $date_str = date('M j, Y g:i A', strtotime($act['date_played']));
                        $is_extra = ($idx >= 3);
                    ?>
                        <div class="activity-item <?php echo $is_extra ? 'extra-activity' : ''; ?>" data-subject="<?php echo $ginfo['subject']; ?>" style="<?php echo $is_extra ? 'display: none;' : ''; ?>">
                            <div class="activity-left">
                                <div class="activity-icon-bubble">🎮</div>
                                <div class="activity-details">
                                    <h5><?php echo htmlspecialchars($ginfo['title']); ?> <span style="font-size: 11px; color: #64748b; margin-left: 6px;">(<?php echo htmlspecialchars($act['topic'] . ' - ' . $act['concept']); ?>)</span></h5>
                                    <p>Played on <?php echo $date_str; ?></p>
                                </div>
                            </div>
                            <div class="activity-right">
                                <span class="accuracy-pill <?php echo $acc_pill_class; ?>"><?php echo round($acc); ?>% Accuracy</span>
                                <span class="coins-earned-pill">+<?php echo (int)$act['coins_earned']; ?> 🪙</span>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>

                <?php if ($total_recent_count > 3): ?>
                    <div class="view-more-btn-wrapper">
                        <button type="button" id="viewMoreActivitiesBtn" class="view-more-btn" onclick="toggleViewMoreActivities()">
                            View More Activities (<?php echo $total_recent_count - 3; ?> more) 👇
                        </button>
                    </div>
                <?php endif; ?>
            <?php endif; ?>
        </div>

        <!-- Section: Badges Banner -->
        <div class="badges-preview-box">
            <div class="badges-preview-info">
                <h3>🏆 Badges & Achievements (<?php echo $badges_earned_count; ?> / <?php echo $total_badges_count; ?> Earned)</h3>
                <p>Keep playing and scoring high accuracy to unlock all learning badges!</p>
            </div>
            <a href="badges.php" class="badges-view-btn">View My Badges ➔</a>
        </div>

    </main>

    <!-- Footer -->
    <footer class="dashboard-footer">
        © 2025 Gyan Setu. All rights reserved.
    </footer>

    <script src="js/script.js"></script>
    <script>
        let activitiesExpanded = false;

        // Subject Filtering Logic for Game Cards & Recent Activities
        function filterSubject(subjectKey, btnElement) {
            const buttons = document.querySelectorAll('.subject-filter-bar .subject-btn');
            buttons.forEach(btn => btn.classList.remove('active'));
            if (btnElement) btnElement.classList.add('active');

            // Filter Game Cards
            const gameCards = document.querySelectorAll('.game-progress-card');
            gameCards.forEach(card => {
                const cardSub = card.getAttribute('data-subject');
                if (subjectKey === 'all' || cardSub === subjectKey) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });

            // Filter Activity Logs with 3 item baseline
            const activityItems = document.querySelectorAll('.activity-item');
            let matchingCount = 0;

            activityItems.forEach(item => {
                const itemSub = item.getAttribute('data-subject');
                const matchesSubject = (subjectKey === 'all' || itemSub === subjectKey);

                if (matchesSubject) {
                    matchingCount++;
                    if (activitiesExpanded || matchingCount <= 3) {
                        item.style.display = 'flex';
                    } else {
                        item.style.display = 'none';
                    }
                } else {
                    item.style.display = 'none';
                }
            });

            // Update View More button based on matching activities count
            const viewMoreBtn = document.getElementById('viewMoreActivitiesBtn');
            if (viewMoreBtn) {
                if (matchingCount > 3) {
                    viewMoreBtn.style.display = 'inline-block';
                    if (activitiesExpanded) {
                        viewMoreBtn.innerHTML = 'Show Less ☝️';
                    } else {
                        const hiddenCount = matchingCount - 3;
                        viewMoreBtn.innerHTML = 'View More Activities (' + hiddenCount + ' more) 👇';
                    }
                } else {
                    viewMoreBtn.style.display = 'none';
                }
            }
        }

        // Toggle Expand / Collapse Recent Activities
        function toggleViewMoreActivities() {
            activitiesExpanded = !activitiesExpanded;
            const activeSubBtn = document.querySelector('.subject-filter-bar .subject-btn.active');
            const activeSub = activeSubBtn ? activeSubBtn.getAttribute('data-sub-key') : 'all';
            filterSubject(activeSub, activeSubBtn);
        }

        // Profile Dropdown Toggle 
        function toggleDropdown() {
            const menu = document.getElementById('profileDropdownMenu');
            const btn  = document.getElementById('profileAvatarBtn');
            const isOpen = menu.classList.toggle('open');
            btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            const wrapper = document.getElementById('profileDropdownWrapper');
            if (wrapper && !wrapper.contains(e.target)) {
                const menu = document.getElementById('profileDropdownMenu');
                if (menu) menu.classList.remove('open');
                const btn = document.getElementById('profileAvatarBtn');
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
            }
        })();
    </script>
</body>
</html>
