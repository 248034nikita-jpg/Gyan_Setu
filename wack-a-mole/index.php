<?php
session_start();
include_once __DIR__ . '/../database/includes/db_connect.php';

$child_id = 0;

if (isset($_GET['child_id']) && (int)$_GET['child_id'] > 0) {
    $child_id = (int)$_GET['child_id'];
} elseif (isset($_SESSION['role'], $_SESSION['user_id'])) {
    if ($_SESSION['role'] === 'child') {
        $child_id = (int) $_SESSION['user_id'];
    } elseif ($_SESSION['role'] === 'parent') {
        $parent_id = (int) $_SESSION['user_id'];
        if (isset($conn) && $conn && !$conn->connect_errno) {
            $stmt = $conn->prepare(
                "SELECT child_id FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1"
            );
            if ($stmt) {
                $stmt->bind_param("i", $parent_id);
                $stmt->execute();
                $row = $stmt->get_result()->fetch_assoc();
                $stmt->close();
                if ($row) {
                    $child_id = (int) $row['child_id'];
                }
            }
        }
    }
}

if ($child_id <= 0 && isset($_SESSION['child_id']) && (int)$_SESSION['child_id'] > 0) {
    $child_id = (int)$_SESSION['child_id'];
}


// Check if child has already seen the introductory storyline video
$has_seen_intro = false;
if ($child_id > 0) {
    if (!isset($conn)) {
        include __DIR__ . '/../database/includes/db_connect.php';
    }
    if (isset($conn) && $conn) {
        $conn->query("
            CREATE TABLE IF NOT EXISTS `child_game_intro` (
              `child_id` INT(11) NOT NULL,
              `game_id` INT(11) NOT NULL,
              `seen_at` DATETIME DEFAULT CURRENT_TIMESTAMP(),
              PRIMARY KEY (`child_id`, `game_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ");

        $stmt = $conn->prepare("SELECT 1 FROM child_game_intro WHERE child_id = ? AND game_id = 1");
        if ($stmt) {
            $stmt->bind_param("i", $child_id);
            $stmt->execute();
            $res = $stmt->get_result();
            if ($res && $res->num_rows > 0) {
                $has_seen_intro = true;
            }
            $stmt->close();
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Word Whack – Gyan Setu's fun vocabulary & grammar whack-a-mole learning game!">
    <title>Word Whack – Gyan Setu</title>

    <!-- child_id and intro status passed from PHP session -->
    <meta name="child_id" content="<?php echo $child_id; ?>">
    <meta name="has_seen_intro" content="<?php echo $has_seen_intro ? '1' : '0'; ?>">

    <!-- Google Fonts for Bubbly Title -->
    <link href="https://fonts.googleapis.com/css2?family=Chewy&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body {
            margin: 0;
            padding: 10px;
            background: #8bc34a; /* Light meadow green */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            width: 100vw;
            overflow: hidden;
            font-family: 'Chewy', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #ffffff;
        }
        #game-container {
            position: relative;
            width: 100%;
            height: 100%;
            max-width: 650px;
            max-height: 700px;
            aspect-ratio: 650 / 700;
            box-shadow: 0 12px 40px rgba(78, 84, 200, 0.45);
            border-radius: 14px;
            overflow: hidden;
            border: 4px solid #4e54c8;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #000000;
        }

        #error-overlay {
            display: none;
            position: fixed;
            top: 10px; left: 10px; right: 10px;
            background: rgba(200, 0, 0, 0.92);
            color: white;
            padding: 14px;
            border-radius: 10px;
            font-family: monospace;
            z-index: 100000;
            font-size: 13px;
            white-space: pre-wrap;
            box-shadow: 0 4px 14px rgba(0,0,0,0.6);
        }

        /* Video Intro Overlay */
        #intro-video-overlay {
            display: none;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: #000000;
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }

        #intro-video {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        #skip-intro-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 110px;
            cursor: pointer;
            z-index: 10000;
            filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.6));
            transition: transform 0.15s ease, filter 0.15s ease;
        }
        #skip-intro-btn:hover {
            transform: scale(1.08);
            filter: drop-shadow(0 6px 12px rgba(0, 0, 0, 0.8));
        }
        #skip-intro-btn:active {
            transform: scale(0.95);
        }

        #unmute-intro-btn {
            position: absolute;
            bottom: 25px;
            left: 50%;
            transform: translateX(-50%);
            background: #ffb300;
            color: #1a1a2e;
            border: 3px solid #ffffff;
            border-radius: 20px;
            padding: 8px 20px;
            font-family: 'Chewy', sans-serif;
            font-size: 18px;
            cursor: pointer;
            z-index: 10000;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            transition: transform 0.15s ease;
        }
        #unmute-intro-btn:hover {
            transform: translateX(-50%) scale(1.05);
        }

        /* ── Interactive Tutorial Lesson Overlay ── */
        #tutorial-lesson-overlay {
            display: none;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.65);
            z-index: 99998;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(4px);
        }

        #tutorial-card {
            position: relative;
            width: 630px;
            height: 670px;
            background: #ffffff;
            border-radius: 24px;
            padding: 15px 18px;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.35);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            overflow: hidden;
            border: 4px solid #fff59d;
            color: #333;
        }

        /* Header */
        .tut-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            height: 48px;
            z-index: 10;
        }

        .tut-header-btn {
            cursor: pointer;
            transition: transform 0.15s ease, filter 0.15s ease;
        }
        .tut-header-btn:hover {
            transform: scale(1.08);
        }
        .tut-header-btn:active {
            transform: scale(0.95);
        }

        #tut-back-btn {
            width: 44px;
            height: 44px;
            filter: drop-shadow(0 3px 6px rgba(0,0,0,0.3));
        }

        #tut-skip-btn {
            width: 95px;
            filter: drop-shadow(0 3px 6px rgba(0,0,0,0.3));
        }

        /* Upper Section: Animals & Audio Sentences */
        .tut-content {
            display: flex;
            justify-content: space-around;
            align-items: flex-start;
            width: 100%;
            margin-top: 5px;
            gap: 12px;
        }

        .tut-animal-box {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .tut-animal-img {
            width: 100%;
            max-width: 240px;
            height: 180px;
            object-fit: contain;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.15));
        }

        .tut-sentence-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
            background: #f5f5f5;
            padding: 6px 12px;
            border-radius: 20px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.06);
        }

        .tut-audio-btn {
            background: #ffc107;
            border: 2px solid #ffffff;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            box-shadow: 0 3px 8px rgba(0,0,0,0.25);
            padding: 0;
            transition: transform 0.15s ease, background 0.15s ease;
            flex-shrink: 0;
        }
        .tut-audio-btn:hover {
            transform: scale(1.1);
            background: #ffb300;
        }
        .tut-audio-btn:active {
            transform: scale(0.95);
        }
        .tut-audio-btn img {
            width: 20px;
            height: 20px;
        }

        .tut-sentence-text {
            font-family: 'Chewy', 'Comic Sans MS', sans-serif;
            font-size: 20px;
            color: #212121;
            letter-spacing: 0.5px;
        }

        .highlight-word {
            color: #d32f2f;
            text-decoration: underline;
            font-weight: bold;
        }

        .blank-spot {
            color: #1976d2;
            font-weight: bold;
            letter-spacing: 1px;
        }

        /* Lower Section: Mascot & Answer Buttons */
        .tut-bottom {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            width: 100%;
            margin-bottom: 5px;
            position: relative;
        }

        .tut-mascot-img {
            width: 130px;
            height: auto;
            max-height: 180px;
            object-fit: contain;
            filter: drop-shadow(0 6px 12px rgba(0,0,0,0.2));
        }

        .tut-options-container {
            display: flex;
            gap: 20px;
            margin-right: 20px;
            margin-bottom: 20px;
        }

        .tut-option-btn {
            width: 170px;
            height: 52px;
            background: #b3e5fc;
            color: #000000;
            border: 3px solid #81d4fa;
            border-radius: 26px;
            font-family: 'Chewy', cursive, sans-serif;
            font-size: 32px;
            cursor: pointer;
            box-shadow: 0 6px 14px rgba(3, 169, 244, 0.3);
            transition: transform 0.15s ease, background 0.15s ease, border-color 0.15s ease, box-shadow 0.15s ease;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .tut-option-btn:hover {
            transform: translateY(-3px) scale(1.05);
            background: #81d4fa;
            box-shadow: 0 8px 18px rgba(3, 169, 244, 0.45);
        }
        .tut-option-btn:active {
            transform: translateY(0) scale(0.97);
        }

        .tut-option-btn.wrong-selected {
            background: #ffebee;
            border-color: #ef5350;
            color: #c62828;
            box-shadow: 0 4px 12px rgba(239, 83, 80, 0.4);
            animation: tutShake 0.4s ease;
        }

        .tut-option-btn.correct-selected {
            background: #e8f5e9;
            border-color: #66bb6a;
            color: #2e7d32;
            box-shadow: 0 4px 12px rgba(102, 187, 106, 0.5);
            transform: scale(1.06);
        }

        @keyframes tutShake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-6px); }
            40%, 80% { transform: translateX(6px); }
        }

        /* Explanation Card Overlay */
        #tut-explanation-card {
            position: absolute;
            bottom: 15px;
            left: 50%;
            transform: translateX(-50%);
            width: 580px;
            background: #fffde7;
            border: 4px solid #fbc02d;
            border-radius: 20px;
            padding: 14px 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.35);
            z-index: 10000;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            animation: tutPopIn 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        @keyframes tutPopIn {
            0% { transform: translateX(-50%) scale(0.8); opacity: 0; }
            100% { transform: translateX(-50%) scale(1); opacity: 1; }
        }

        .tut-exp-content {
            display: flex;
            align-items: center;
            gap: 14px;
            width: 100%;
        }

        .tut-exp-text {
            font-family: 'Nunito', 'Segoe UI', sans-serif;
            font-size: 17px;
            font-weight: 700;
            color: #333333;
            line-height: 1.35;
            flex: 1;
        }

        #tut-exp-close-btn {
            background: #4caf50;
            color: #ffffff;
            border: 2px solid #ffffff;
            border-radius: 16px;
            padding: 6px 24px;
            font-family: 'Chewy', sans-serif;
            font-size: 20px;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            transition: transform 0.15s ease, background 0.15s ease;
        }
        #tut-exp-close-btn:hover {
            transform: scale(1.06);
            background: #43a047;
        }
    </style>

    <!-- Phaser 3 -->
    <script src="https://cdn.jsdelivr.net/npm/phaser@3.60.0/dist/phaser.min.js"></script>
</head>
<body>
    <div id="error-overlay">
        <strong>⚠️ Game Error</strong>
        <div id="error-message"></div>
    </div>

    <div id="game-container">
        <!-- Intro Video Overlay for First Time Players -->
        <div id="intro-video-overlay">
            <video id="intro-video" src="assets/tutorial/game intro.mp4" playsinline webkit-playsinline></video>
            <img id="skip-intro-btn" src="assets/tutorial/skip.png" alt="Skip Intro" title="Skip Intro">
            <button id="unmute-intro-btn" style="display: none;">🔊 Tap for Sound</button>
        </div>

        <!-- Interactive Tutorial Lesson Overlay (Meadow Mode Hint) -->
        <div id="tutorial-lesson-overlay">
            <div id="tutorial-card">
                <!-- Header Controls -->
                <div class="tut-header">
                    <img id="tut-back-btn" class="tut-header-btn" src="assets/tutorial/back.png" alt="Back" title="Back">
                    <img id="tut-skip-btn" class="tut-header-btn" src="assets/tutorial/skip.png" alt="Skip" title="Skip">
                </div>

                <!-- Upper Section: Animal Illustrations & Sentences -->
                <div class="tut-content">
                    <!-- Left Side: Rabbit -->
                    <div class="tut-animal-box">
                        <img src="assets/tutorial/rabbit_fast.png" alt="Rabbit" class="tut-animal-img">
                        <div class="tut-sentence-row">
                            <button class="tut-audio-btn" id="audio-rabbit-btn" title="Listen Sentence">
                                <img src="assets/tutorial/audio.png" alt="Audio">
                            </button>
                            <span class="tut-sentence-text">A rabbit is <span class="highlight-word">fast</span>.</span>
                        </div>
                    </div>

                    <!-- Right Side: Turtle -->
                    <div class="tut-animal-box">
                        <img src="assets/tutorial/turtle_slow.png" alt="Turtle" class="tut-animal-img">
                        <div class="tut-sentence-row">
                            <button class="tut-audio-btn" id="audio-turtle-btn" title="Listen Sentence">
                                <img src="assets/tutorial/audio.png" alt="Audio">
                            </button>
                            <span class="tut-sentence-text" id="turtle-sentence">A turtle is <span class="blank-spot">________</span> .</span>
                        </div>
                    </div>
                </div>

                <!-- Lower Section: Bunny Mascot & Answer Pill Buttons -->
                <div class="tut-bottom">
                    <img src="assets/tutorial/bunny mascot.png" alt="Bunny Mascot" class="tut-mascot-img">
                    
                    <div class="tut-options-container">
                        <button class="tut-option-btn option-quick" id="btn-quick">quick</button>
                        <button class="tut-option-btn option-slow" id="btn-slow">slow</button>
                    </div>
                </div>

                <!-- Explanation Modal Card -->
                <div id="tut-explanation-card" style="display: none;">
                    <div class="tut-exp-content">
                        <button class="tut-audio-btn exp-audio-btn" id="audio-exp-btn" title="Replay Explanation">
                            <img src="assets/tutorial/audio.png" alt="Audio">
                        </button>
                        <div class="tut-exp-text" id="tut-exp-text"></div>
                    </div>
                    <button id="tut-exp-close-btn">Got It!</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        window.addEventListener('error', function(e) {
            const overlay = document.getElementById('error-overlay');
            const msg     = document.getElementById('error-message');
            overlay.style.display = 'block';
            msg.textContent += '\n• ' + e.message + '\n  at ' + e.filename + ':' + e.lineno;
        });

        // Controller to play Introductory Storyline Video
        window.playIntroVideo = function(childId, forceReplay = false) {
            const overlay   = document.getElementById('intro-video-overlay');
            const video     = document.getElementById('intro-video');
            const skipBtn   = document.getElementById('skip-intro-btn');
            const unmuteBtn = document.getElementById('unmute-intro-btn');

            if (!overlay || !video) return;

            overlay.style.display = 'flex';

            // Mute Phaser audio while intro video plays
            if (window.game && window.game.sound) {
                window.game.sound.mute = true;
            }

            const endVideo = function() {
                video.pause();
                overlay.style.display = 'none';

                // Restore Phaser game sound
                if (window.game && window.game.sound) {
                    window.game.sound.mute = false;
                }

                // Save to localStorage
                localStorage.setItem('wack_a_mole_intro_seen_' + childId, '1');

                // Mark in Database for logged-in child
                if (childId > 0) {
                    const form = new FormData();
                    form.append('child_id', childId);
                    form.append('game_id', 1);

                    fetch('database/mark_intro_seen.php', {
                        method: 'POST',
                        body: form
                    }).catch(err => console.warn('Failed to mark intro seen in DB:', err));
                }
            };

            skipBtn.onclick = function() {
                endVideo();
            };

            video.onended = function() {
                endVideo();
            };

            video.currentTime = 0;
            video.muted = false;
            unmuteBtn.style.display = 'none';

            const playPromise = video.play();
            if (playPromise !== undefined) {
                playPromise.catch(error => {
                    console.warn('Autoplay with audio blocked. Fallback to muted autoplay:', error);
                    video.muted = true;
                    video.play().then(() => {
                        unmuteBtn.style.display = 'block';
                        unmuteBtn.onclick = function() {
                            video.muted = false;
                            unmuteBtn.style.display = 'none';
                        };
                    }).catch(e => {
                        console.error('Video playback failed:', e);
                        endVideo();
                    });
                });
            }
        };

        // ── Interactive Tutorial Lesson Controller ──
        let currentTutAudio = null;
        let currentTutAudioSrc = null;
        let lastExpAudioSrc = null;

        function resetAudioButtonIcons() {
            ['audio-rabbit-btn', 'audio-turtle-btn', 'audio-exp-btn'].forEach(id => {
                const btn = document.getElementById(id);
                if (btn) {
                    const img = btn.querySelector('img');
                    if (img) img.src = 'assets/tutorial/audio.png';
                    btn.classList.remove('is-playing', 'is-muted');
                }
            });
        }

        function stopTutAudio() {
            if (currentTutAudio) {
                currentTutAudio.pause();
                currentTutAudio.currentTime = 0;
                currentTutAudio = null;
                currentTutAudioSrc = null;
            }
            resetAudioButtonIcons();
        }

        function toggleTutAudio(src, btnId) {
            if (!src) return;

            const btn = document.getElementById(btnId);
            const img = btn ? btn.querySelector('img') : null;

            // Mute / Pause if currently playing this audio
            if (currentTutAudio && currentTutAudioSrc === src && !currentTutAudio.paused) {
                currentTutAudio.pause();
                if (img) img.src = 'assets/mute.png';
                if (btn) btn.classList.add('is-muted');
                return;
            }

            // Resume if paused
            if (currentTutAudio && currentTutAudioSrc === src && currentTutAudio.paused && currentTutAudio.currentTime > 0 && currentTutAudio.currentTime < currentTutAudio.duration) {
                currentTutAudio.play().then(() => {
                    if (img) img.src = 'assets/tutorial/audio.png';
                    if (btn) btn.classList.remove('is-muted');
                }).catch(err => console.warn('Audio resume error:', err));
                return;
            }

            // Play new audio from start
            stopTutAudio();

            currentTutAudioSrc = src;
            currentTutAudio = new Audio(src);

            if (img) img.src = 'assets/tutorial/audio.png';
            if (btn) btn.classList.add('is-playing');

            currentTutAudio.onended = function() {
                if (img) img.src = 'assets/tutorial/audio.png';
                if (btn) btn.classList.remove('is-playing', 'is-muted');
                currentTutAudio = null;
                currentTutAudioSrc = null;
            };

            currentTutAudio.play().catch(err => console.warn('Audio play error:', err));
        }

        window.showTutorialLesson = function() {
            const overlay = document.getElementById('tutorial-lesson-overlay');
            if (!overlay) return;

            // Reset Tutorial UI State
            document.getElementById('turtle-sentence').innerHTML = 'A turtle is <span class="blank-spot">________</span> .';
            document.getElementById('btn-quick').className = 'tut-option-btn option-quick';
            document.getElementById('btn-slow').className = 'tut-option-btn option-slow';
            document.getElementById('tut-explanation-card').style.display = 'none';

            stopTutAudio();
            overlay.style.display = 'flex';

            // Pause Phaser BGM when tutorial is on
            if (window.game && window.game.sound) {
                window.game.sound.mute = true;
                if (typeof window.game.sound.pauseAll === 'function') {
                    window.game.sound.pauseAll();
                } else if (typeof window.game.sound.pause === 'function') {
                    window.game.sound.pause();
                }
            }
        };

        window.hideTutorialLesson = function() {
            const overlay = document.getElementById('tutorial-lesson-overlay');
            if (overlay) {
                overlay.style.display = 'none';
            }
            stopTutAudio();

            // Resume Phaser BGM when tutorial closes
            if (window.game && window.game.sound) {
                window.game.sound.mute = false;
                if (typeof window.game.sound.resumeAll === 'function') {
                    window.game.sound.resumeAll();
                } else if (typeof window.game.sound.resume === 'function') {
                    window.game.sound.resume();
                }
            }
        };

        // Setup Tutorial Lesson Events on DOM load
        document.addEventListener('DOMContentLoaded', function() {
            const childMeta = document.querySelector('meta[name="child_id"]');
            const introMeta = document.querySelector('meta[name="has_seen_intro"]');

            const childId   = childMeta ? parseInt(childMeta.content) : 0;
            const dbSeen    = introMeta ? (introMeta.content === '1') : false;
            const localSeen = localStorage.getItem('wack_a_mole_intro_seen_' + childId) === '1';

            // Play story video ONLY when played for the first time
            if (!dbSeen && !localSeen) {
                setTimeout(() => {
                    window.playIntroVideo(childId);
                }, 100);
            }

            // Audio buttons with toggle mute/unmute
            document.getElementById('audio-rabbit-btn').addEventListener('click', function() {
                toggleTutAudio('assets/tutorial/A rabbit is fast.m4a', 'audio-rabbit-btn');
            });

            document.getElementById('audio-turtle-btn').addEventListener('click', function() {
                toggleTutAudio('assets/tutorial/A turtle is.m4a', 'audio-turtle-btn');
            });

            document.getElementById('audio-exp-btn').addEventListener('click', function() {
                if (lastExpAudioSrc) {
                    toggleTutAudio(lastExpAudioSrc, 'audio-exp-btn');
                }
            });

            // Back & Skip buttons
            document.getElementById('tut-back-btn').addEventListener('click', window.hideTutorialLesson);
            document.getElementById('tut-skip-btn').addEventListener('click', window.hideTutorialLesson);

            // 'Got It!' button -> STOP explanation audio & hide card!
            document.getElementById('tut-exp-close-btn').addEventListener('click', function() {
                document.getElementById('tut-explanation-card').style.display = 'none';
                stopTutAudio();
            });

            // Option 1: Quick (Wrong Answer)
            document.getElementById('btn-quick').addEventListener('click', function() {
                const quickBtn = document.getElementById('btn-quick');
                const slowBtn  = document.getElementById('btn-slow');
                const expCard  = document.getElementById('tut-explanation-card');
                const expText  = document.getElementById('tut-exp-text');

                quickBtn.className = 'tut-option-btn wrong-selected';
                slowBtn.className  = 'tut-option-btn option-slow';

                expText.innerHTML = '<strong style="color: #c62828;">Incorrect!</strong> "Quick" means moving at high speed, like the rabbit. But a turtle moves slowly, so <em>quick</em> is not the right word!';
                expCard.style.display = 'flex';

                lastExpAudioSrc = 'assets/tutorial/wrong explanation.m4a';
                toggleTutAudio(lastExpAudioSrc, 'audio-exp-btn');
            });

            // Option 2: Slow (Right Answer)
            document.getElementById('btn-slow').addEventListener('click', function() {
                const quickBtn = document.getElementById('btn-quick');
                const slowBtn  = document.getElementById('btn-slow');
                const expCard  = document.getElementById('tut-explanation-card');
                const expText  = document.getElementById('tut-exp-text');
                const sentence = document.getElementById('turtle-sentence');

                slowBtn.className  = 'tut-option-btn correct-selected';
                quickBtn.className = 'tut-option-btn option-slow';

                sentence.innerHTML = 'A turtle is <span class="highlight-word" style="color: #2e7d32; text-decoration: none;">slow</span>.';

                expText.innerHTML = '<strong style="color: #2e7d32;">Great job!</strong> A turtle moves at a low speed, so "slow" is the correct answer!';
                expCard.style.display = 'flex';

                lastExpAudioSrc = 'assets/tutorial/right explanation.m4a';
                toggleTutAudio(lastExpAudioSrc, 'audio-exp-btn');
            });
        });
    </script>

    <!-- Game script -->
    <script src="game.js?v=<?php echo time(); ?>"></script>
</body>
</html>