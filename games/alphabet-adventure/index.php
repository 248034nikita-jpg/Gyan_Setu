<?php
session_start();
$root = realpath(__DIR__ . '/../../');
$dbPath = $root . '/database/includes/db_connect.php';

$child_id = 0;
$child_username = 'Explorer';

if (file_exists($dbPath)) {
    require_once $dbPath;

    if (isset($_GET['child_id']) && (int)$_GET['child_id'] > 0) {
        $child_id = (int)$_GET['child_id'];
        $stmt = $conn->prepare("SELECT username FROM children WHERE child_id = ?");
        if ($stmt) {
            $stmt->bind_param("i", $child_id);
            $stmt->execute();
            $r = $stmt->get_result()->fetch_assoc();
            if ($r) $child_username = $r['username'];
            $stmt->close();
        }
    } elseif (isset($_SESSION['user_id']) && isset($_SESSION['role'])) {
        if ($_SESSION['role'] === 'child') {
            $child_id = (int)$_SESSION['user_id'];
            $child_username = $_SESSION['username'] ?? 'Explorer';
        } elseif ($_SESSION['role'] === 'parent') {
            $parentId = (int)$_SESSION['user_id'];
            $stmt = $conn->prepare("SELECT child_id, username FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
            if ($stmt) {
                $stmt->bind_param("i", $parentId);
                $stmt->execute();
                $cRes = $stmt->get_result()->fetch_assoc();
                if ($cRes) {
                    $child_id = (int)$cRes['child_id'];
                    $child_username = $cRes['username'];
                }
                $stmt->close();
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="child_id" content="<?php echo $child_id; ?>">
<title>Alphabet Adventure 🐾 Learn, Play & Spell!</title>
<link rel="stylesheet" href="style.css">
<script>
    window.CHILD_ID = <?php echo (int)$child_id; ?>;
    window.CHILD_USERNAME = <?php echo json_encode($child_username); ?>;
</script>
</head>

<body class="theme-forest">

<div class="game-wrapper">

    <!-- =========================================
       🌟 START / TITLE SCREEN (Image 1 Match)
    ========================================= -->
    <div id="start-screen" class="screen active">
        <header class="title-topbar">
            <a href="../../child-dashboard.php" class="title-back-btn" title="Back to Dashboard">
                ⬅ BACK
            </a>
            <button id="title-sound-btn" class="title-sound-btn sound-toggle-btn" onclick="soundToggle()">
                🔊 Sound ON
            </button>
        </header>

        <main class="title-content">
            <div class="title-hero-text">
                <h1 class="title-alphabet">ALPHABET</h1>
                <h2 class="title-adventure">ADVENTURE</h2>
            </div>

            <div class="title-monkey-badge">
                <img src="assets/monkey_circle.png" alt="Scout Monkey" class="monkey-avatar-img">
            </div>

            <div class="title-buttons">
                <button class="title-start-btn" onclick="goToLetterSelection()">
                    ▶ START GAME
                </button>
                <button class="title-progress-btn" onclick="openProgressModal()">
                    <span style="font-size: 20px;">📊</span> PROGRESS
                </button>
            </div>
        </main>
    </div>

    <!-- =========================================
       🏡 LETTER SELECTION MAP (A-Z)
    ========================================= -->
    <div id="home-screen" class="screen hidden">
        
        <header class="topbar">
            <button class="action-btn back-btn" onclick="showStartScreen()">
                ⬅ Menu
            </button>

            <div class="logo-box">
                <span class="main-title">🐾 ALPHABET ADVENTURE</span>
                <span class="sub-title">Select a Letter to Play! (Ages 4-6)</span>
            </div>
            
            <div class="stats-group">
                <div class="stat-badge coins-badge" id="coins-badge">
                    <svg class="coin-svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="#ffda43" stroke="#222" stroke-width="2"/><circle cx="12" cy="12" r="6" fill="#ffe97d" stroke="#222" stroke-width="1.5"/><path d="M12 9v6M10.5 10.5h3a1.5 1.5 0 0 0 0-3h-3M10.5 13.5h3a1.5 1.5 0 0 1 0 3h-3" fill="none" stroke="#222" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg> <span id="global-coins" class="global-coins-display">0</span>
                </div>
                <button class="icon-btn" onclick="openProgressModal()" style="background: #ffa726;">
                    📊 Progress
                </button>
                <button id="home-sound-btn" class="icon-btn sound-toggle-btn" onclick="soundToggle()">
                    🔊 Sound ON
                </button>
            </div>
        </header>

        <section class="progress-section">
            <div class="progress-label">Your Game Journey: <span id="progress-percent">0%</span></div>
            <div class="progress-bar-wrap">
                <div id="global-progress" class="progress-bar-fill" style="width: 0%;"></div>
            </div>
        </section>

        <main class="levels-map">
            <h2>Select a Letter to Play! 🌟</h2>
            <div id="levels-grid" class="levels-grid">
                <!-- Levels A-Z will be rendered here dynamically -->
            </div>
        </main>

    </div>

    <!-- =========================================
       🗂️ LEVEL DETAILS SCREEN (15 Words)
    ========================================= -->
    <div id="level-screen" class="screen hidden">
        
        <header class="topbar">
            <button class="action-btn back-btn" onclick="showHomeScreen()">
                🔙 Map
            </button>
            
            <div class="logo-box">
                <span id="level-title-header" class="main-title">LEVEL A</span>
                <span id="level-progress-txt" class="sub-title">Completed: 0/15</span>
            </div>
            
            <div class="stats-group">
                <div class="stat-badge coins-badge" id="level-coins-badge">
                    <svg class="coin-svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="#ffda43" stroke="#222" stroke-width="2"/><circle cx="12" cy="12" r="6" fill="#ffe97d" stroke="#222" stroke-width="1.5"/><path d="M12 9v6M10.5 10.5h3a1.5 1.5 0 0 0 0-3h-3M10.5 13.5h3a1.5 1.5 0 0 1 0 3h-3" fill="none" stroke="#222" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg> <span class="global-coins-display">0</span>
                </div>
                <button class="icon-btn" onclick="openProgressModal()" style="background: #ffa726;">
                    📊 Progress
                </button>
                <button id="level-sound-btn" class="icon-btn sound-toggle-btn" onclick="soundToggle()">
                    🔊 Sound ON
                </button>
            </div>
        </header>

        <main class="level-stages-container">
            <h2>Word Challenges 🐾</h2>
            <div id="words-grid" class="words-grid">
                <!-- 15 stage words will be rendered here dynamically -->
            </div>
        </main>

    </div>

    <!-- =========================================
       🎮 GAMEPLAY SCREEN
    ========================================= -->
    <div id="game-screen" class="screen hidden">
        
        <header class="topbar">
            <button class="action-btn back-btn" onclick="showLevelScreen()">
                🔙 Stage
            </button>
            
            <div class="logo-box">
                <span id="game-word-num" class="main-title">Word 1 of 15</span>
                <span id="game-level-txt" class="sub-title">LEVEL A</span>
            </div>
            
            <div class="stats-group">
                <div class="stat-badge coins-badge" id="game-coins-badge">
                    <svg class="coin-svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="#ffda43" stroke="#222" stroke-width="2"/><circle cx="12" cy="12" r="6" fill="#ffe97d" stroke="#222" stroke-width="1.5"/><path d="M12 9v6M10.5 10.5h3a1.5 1.5 0 0 0 0-3h-3M10.5 13.5h3a1.5 1.5 0 0 1 0 3h-3" fill="none" stroke="#222" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg> <span class="global-coins-display">0</span>
                </div>
                <button id="game-sound-btn" class="icon-btn sound-toggle-btn" onclick="soundToggle()">
                    🔊 Sound ON
                </button>
            </div>
        </header>

        <main class="gameplay-area">
            
            <!-- Mascot and Prompts -->
            <aside class="mascot-column">
                <div class="mascot-box">
                    <div id="mascot" class="mascot-char">
                        <img id="mascot-img" src="assets/monkey_circle.png" alt="Monkey Mascot" style="width: 105px; height: 105px; border-radius: 50%; object-fit: cover; border: 3.5px solid #1c5218; box-shadow: 0 4px 10px rgba(0,0,0,0.15); transition: transform 0.25s cubic-bezier(0.175, 0.885, 0.32, 1.275);">
                    </div>
                    <div class="speech-bubble">
                        <p id="speech">Can you spell Apple? 😂</p>
                    </div>
                </div>
                
                <div class="gameplay-actions">
                    <button class="hint-btn action-btn" onclick="useHint()">
                        💡 Hint (<span id="hint-count">3</span>)
                    </button>
                    <button class="reset-btn action-btn" onclick="restartWord()">
                        🔄 Reset
                    </button>
                </div>
            </aside>

            <!-- Spells Card -->
            <section class="spelling-board">
                
                <div class="illustration-box">
                    <div id="word-emoji" class="large-emoji">🍎</div>
                    <button class="speaker-btn" onclick="speakCurrentWord()">
                        🔊 Pronounce
                    </button>
                </div>

                <div class="slots-area-wrapper">
                    <div id="word-slots" class="word-slots">
                        <!-- Slots representing empty outlines will be generated here -->
                    </div>
                </div>

                <div class="letters-scatter-wrapper">
                    <div id="letters-deck" class="letters-deck">
                        <!-- Draggable, colorful, scattered letters will appear here -->
                    </div>
                </div>

                <div id="next-word-box" class="next-word-box hidden">
                    <h3 id="encouragement-txt">Amazing! You spelled APPLE! 🎉</h3>
                    <button class="action-btn next-btn" onclick="nextWordChallenge()">
                        NEXT WORD ➡️
                    </button>
                </div>

            </section>

        </main>

    </div>

    <!-- =========================================
       🏆 COMPLETION CELEBRATION MODAL
    ========================================= -->
    <div id="complete-screen" class="screen hidden">
        <div class="complete-modal">
            <div class="modal-confetti" id="modal-confetti"></div>
            <div class="trophy-bounce">🏆</div>
            <h1 id="celebration-header">🎉 LEVEL A COMPLETE! 🎉</h1>
            <p class="modal-sub">Super job! You spelled all 15 words and learned so much!</p>
            
            <div class="stat-summary">
                <div class="stat-card">
                    <span class="label">Total Score</span>
                    <span class="value" id="complete-total-score">+100 XP</span>
                </div>
                <div class="stat-card">
                    <span class="label">Coins Earned</span>
                    <span class="value" id="complete-total-coins">+50</span>
                </div>
            </div>

            <div class="complete-controls">
                <button class="action-btn map-btn-modal" onclick="showHomeScreen()">
                    🗺️ Levels Map
                </button>
                <button id="next-level-btn-modal" class="action-btn continue-btn" onclick="continueToNextLevel()">
                    🔓 LEVEL B ➡️
                </button>
            </div>
        </div>
    </div>

</div>

<!-- =========================================
   📊 PROGRESS POPUP MODAL (IMAGE 2 MATCH)
========================================= -->
<div id="progress-modal-overlay" class="hidden" onclick="handleModalBackdropClick(event)">
    <div class="progress-modal-card">
        <div class="progress-modal-header">
            <span style="font-size: 38px;">📊</span>
            <h2>Progress</h2>
        </div>

        <div class="progress-stat-pill">
            <span class="stat-pill-label">
                <svg class="coin-svg-inline" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="#ffda43" stroke="#222" stroke-width="2"/><circle cx="12" cy="12" r="6" fill="#ffe97d" stroke="#222" stroke-width="1.5"/><path d="M12 9v6M10.5 10.5h3a1.5 1.5 0 0 0 0-3h-3M10.5 13.5h3a1.5 1.5 0 0 1 0 3h-3" fill="none" stroke="#222" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg> Coins Collected:
            </span>
            <span class="stat-pill-value" id="popup-coins">0</span>
        </div>

        <div class="progress-stat-pill">
            <span class="stat-pill-label">
                📖 Words Completed:
            </span>
            <span class="stat-pill-value" id="popup-words">0</span>
        </div>

        <div class="progress-stat-pill">
            <span class="stat-pill-label">
                🎯 Accuracy:
            </span>
            <span class="stat-pill-value" id="popup-accuracy">100%</span>
        </div>

        <button class="progress-modal-close-btn" onclick="closeProgressModal()">
            Close
        </button>
    </div>
</div>

<!-- Center pop-ups (Mistakes / Achievements) -->
<div id="toast-message" class="message-popup"></div>

<script src="script.js"></script>
</body>
</html>
