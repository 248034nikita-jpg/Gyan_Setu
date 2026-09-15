<?php
session_start();
include '../database/includes/db_connect.php';

// Route Protection
if (!isset($_SESSION['role']) || !in_array($_SESSION['role'], ['child', 'parent'])) {
    header("Location: ../login.php");
    exit();
}

$game_url = $_GET['game'] ?? '';
$game_title = $_GET['title'] ?? 'Educational Game';

// Validate allowed relative game paths for security
$allowed_paths = [
    'games/alphabet-adventure/index.php',
    'games/capybara-platformer-quiz/index.php',
    'wack-a-mole/index.php',
    'games/quiz_flashcard/quiz_flashcard.html',
    'games/hangman/index.php'
];

$is_valid_game = false;
foreach ($allowed_paths as $path) {
    if (strpos($game_url, $path) === 0) {
        $is_valid_game = true;
        break;
    }
}

if (!$is_valid_game) {
    header("Location: ../child-dashboard.php");
    exit();
}

// Preserve query string parameters like child_id
$target_url = '../' . $game_url;
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - <?php echo htmlspecialchars($game_title); ?></title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="time_limit.css?v=<?php echo time(); ?>">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body, html {
            width: 100%;
            height: 100%;
            overflow: hidden;
            font-family: 'Nunito', sans-serif;
            background: #0f172a;
        }
        .game-header-bar {
            height: 50px;
            background: #1e293b;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 16px;
            border-bottom: 2px solid #334155;
            z-index: 1000;
            position: relative;
        }
        .game-header-bar .back-link {
            color: #ffffff;
            text-decoration: none;
            font-weight: 800;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
            background: rgba(255,255,255,0.15);
            padding: 6px 14px;
            border-radius: 20px;
            transition: background 0.2s;
        }
        .game-header-bar .back-link:hover {
            background: rgba(255,255,255,0.25);
        }
        .game-header-bar .title {
            font-weight: 800;
            font-size: 16px;
            color: #f8fafc;
        }
        .game-header-bar .timer-badge {
            background: rgba(255,255,255,0.15);
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 800;
            font-size: 14px;
        }
        .game-frame-container {
            width: 100%;
            height: calc(100% - 50px);
            position: relative;
        }
        iframe.game-iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
    </style>
</head>
<body>

    <div class="game-header-bar">
        <a href="../child-dashboard.php" class="back-link">
            <span>⬅ Back to Dashboard</span>
        </a>
        <div class="title">🎮 <?php echo htmlspecialchars($game_title); ?></div>
        <div></div>
    </div>

    <div class="game-frame-container">
        <iframe src="<?php echo htmlspecialchars($target_url); ?>" class="game-iframe" allow="autoplay; fullscreen"></iframe>
    </div>

    <script src="time_limit.js?v=<?php echo time(); ?>"></script>
</body>
</html>
