<?php
session_start();

$currentChildId = 0;
if (isset($_SESSION['user_id']) && isset($_SESSION['role']) && $_SESSION['role'] === 'child') {
    $currentChildId = (int)$_SESSION['user_id'];
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- ========================================
    PAGE SETUP - What the browser needs
    ======================================== -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Word Safari - Hangman Game</title>
    
    <script>
        window.CHILD_ID = <?php echo (int)$currentChildId; ?>;
        window.API_BASE = 'api';
    </script>
    
    <!-- Link to CSS file (styling) -->
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <!-- ========================================
    TOAST NOTIFICATION - Popup messages
    Shows things like "Welcome!" or "Good job!"
    ======================================== -->
    <div id="toast" class="toast"></div>

     <!-- ========================================
    PEEKING MASCOT - Appears when 2 lives left
    ======================================== -->
    <div id="peekMascot" class="mascot-peek">🦁</div>
    <a href="../../child-dashboard.php" class="btn-page-back" title="Back to Child Dashboard">
            <img src="assets/back.png" alt="Back to Dashboard" class="page-back-icon">
        </a>
    <!-- ========================================
    SCREEN 1: HOME SCREEN
    The first thing players see
    ======================================== -->
    <div id="homeScreen" class="screen active">
        <div class="container">
            
            <!-- Title -->
            <h1>🌈 Word Safari</h1>
            
            <!-- Player Stats - Shows coins, stars, streak -->
            <div class="stats">
                <span>⭐ <b id="starsDisplay">0</b></span>
                <span>🪙 <b id="coinsDisplay">0</b></span>
                <span>🔥 <b id="streakDisplay">0</b></span>
            </div>
            
            <!-- Fun animal icons (bouncing animation) -->
            <div class="animal-gang">🐘🦒🦁</div>
            
            <!-- Instructions -->
            <h2>Guess the Animal!</h2>
            <p class="subtitle">Each wrong guess builds the hangman! 🎯</p>
            
            <!-- Main Start Button -->
            <button class="btn-start" onclick="showScreen('categoryScreen')">
                🚀 Start Adventure
            </button>
            
            <!-- Quick Access Buttons -->
            <div class="quick-buttons">
                <button class="btn-secondary" onclick="showScreen('progressScreen')">
                    📊 Progress
                </button>
                <button class="btn-secondary" onclick="showScreen('shopScreen')">
                    🎁 Shop
                </button>
            </div>
            
        </div>
    </div>

    <!-- ========================================
    SCREEN 2: CATEGORY SELECTION
    Choose what type of animals to learn
    ======================================== -->
    <div id="categoryScreen" class="screen">
        <div class="container">
            
            <!-- Back Button -->
            <button class="btn-back" onclick="showScreen('homeScreen')">← Back</button>
            
            <h2>🎯 Choose Category</h2>
            
            <!-- Four Category Cards in a grid -->
            <div class="category-grid">
                
                <!-- Mammals - Always available -->
                <div class="category-card" onclick="selectCategory('mammals')">
                    <span class="cat-emoji">🐶</span>
                    <h3>Mammals</h3>
                    <span class="cat-status">✅ Available</span>
                </div>
                
                <!-- Birds - Starts locked -->
                <div class="category-card locked" id="birdCard">
                    <span class="cat-emoji">🦅</span>
                    <h3>Birds</h3>
                    <span class="cat-status">🔒 Locked</span>
                </div>
                
                <!-- Reptiles - Starts locked -->
                <div class="category-card locked" id="reptileCard">
                    <span class="cat-emoji">🐍</span>
                    <h3>Reptiles</h3>
                    <span class="cat-status">🔒 Locked</span>
                </div>
                
                <!-- Amphibians - Starts locked -->
                <div class="category-card locked" id="amphibianCard">
                    <span class="cat-emoji">🐸</span>
                    <h3>Amphibians</h3>
                    <span class="cat-status">🔒 Locked</span>
                </div>
                
            </div>
            
            <!-- Progress Bar - Shows overall game progress -->
            <div class="progress-section">
                <small>📈 Progress: <b id="progressText">0%</b></small>
                <div class="progress-track">
                    <div class="progress-fill" id="progressBar" style="width:0%;"></div>
                </div>
            </div>
            
        </div>
    </div>

    <!-- ========================================
    SCREEN 3: DIFFICULTY SELECTION
    Pick Easy, Medium, or Hard
    ======================================== -->
    <div id="difficultyScreen" class="screen">
        <div class="container">
            
            <button class="btn-back" onclick="showScreen('categoryScreen')">← Back</button>
            
            <h2>⭐ Choose Level</h2>
            
            <div class="diff-grid">
                
                <!-- Easy Level -->
                <div class="diff-btn" onclick="startGame('easy')">
                    <span class="diff-icon">🌱</span>
                    <div>
                        <h3>Easy (4-6 years)</h3>
                        <p>❤️ 5 lives • Simple words • Free hints</p>
                    </div>
                </div>
                
                <!-- Medium Level -->
                <div class="diff-btn" onclick="startGame('medium')">
                    <span class="diff-icon">🌿</span>
                    <div>
                        <h3>Medium (7-8 years)</h3>
                        <p>❤️ 4 lives • Medium words • Hints cost coins</p>
                    </div>
                </div>
                
                <!-- Hard Level -->
                <div class="diff-btn" onclick="startGame('hard')">
                    <span class="diff-icon">🌳</span>
                    <div>
                        <h3>Hard (9-10 years)</h3>
                        <p>❤️ 3 lives • Long words • Fewer hints</p>
                    </div>
                </div>
                
            </div>
            
        </div>
    </div>

    <!-- ========================================
    SCREEN 4: MAIN GAME
    The Hangman game!
    ======================================== -->
    <div id="gameScreen" class="screen">
        <div class="container">
            
            <!-- Top Bar: Exit button, Category, Difficulty -->
            <div class="game-header">
                <button class="btn-back btn-danger" onclick="exitGame()">✕ Exit</button>
                <span class="game-label" id="gameCategoryLabel">🐶 Mammals</span>
                <span class="game-label" id="gameDifficultyLabel">🌱 Easy</span>
            </div>
            
            <!-- Game Stats -->
            <div class="stats">
                <span>❤️ <b id="livesDisplay">5</b></span>
                <span>⭐ <b id="gameStars">0</b></span>
                <span>🪙 <b id="gameCoins">0</b></span>
            </div>
            
            <!-- Hangman Drawing Area -->
            <div class="hangman-area">
                <canvas id="hangmanCanvas" class="hangman-canvas"></canvas>
            </div>
            
            <!-- Word Display (shows underscores and guessed letters) -->
            <div class="word-display" id="wordDisplay">_ _ _ _ _</div>
            
            <!-- Feedback Message -->
            <div class="feedback" id="feedbackMessage">💬 Click a letter to guess!</div>
            
            <!-- On-screen Keyboard -->
            <div class="keyboard" id="keyboard"></div>
            
            <!-- Hint & Listen Buttons -->
            <div class="game-actions">
                <button onclick="useHint()">💡 Hint</button>
                <button onclick="speakWord()">🔊 Listen</button>
            </div>
            
        </div>
    </div>

    <!-- ========================================
    SCREEN 5: CORRECT (Celebration)
    Shows when you guess the word correctly
    ======================================== -->
    <div id="correctScreen" class="screen">
        <div class="container">
            
            <h1 class="celebration-title">🎉 You Did It! 🎉</h1>
            <span class="big-animal" id="correctAnimal">🐘</span>
            
            <div class="result-box">
                <h2 id="correctWord">ELEPHANT</h2>
                <p>🌟 Amazing guess! 🌟</p>
                <div class="result-stats">
                    <span>⭐ +<b id="correctStars">5</b></span>
                    <span>🪙 +<b id="correctCoins">10</b></span>
                </div>
            </div>
            
            <div class="correct-buttons">
                <button class="btn-secondary" onclick="showLearning()">📚 Learn</button>
                <button onclick="nextWord()">➡️ Next</button>
            </div>
            
        </div>
    </div>

    <!-- ========================================
    SCREEN 6: LEARNING
    Shows facts about the animal
    ======================================== -->
    <div id="learningScreen" class="screen">
        <div class="container">
            
            <button class="btn-back" onclick="showScreen('correctScreen')">← Back</button>
            
            <h2>📖 Learn About Your Word</h2>
            
            <div class="learn-card">
                <span class="big-emoji" id="learnEmoji">🐘</span>
                <h2 class="learn-word-title" id="learnWord">ELEPHANT</h2>
                
                <h3>📖 Meaning</h3>
                <p id="learnMeaning">The largest land animal on Earth.</p>
                
                <h3>💡 Fun Fact</h3>
                <p id="learnFact">Elephants are the only mammals that can't jump!</p>
                
                <h3>🔤 Letter Focus</h3>
                <p id="learnLetter">The word starts with "E"</p>
            </div>
            
            <button onclick="nextWord()">➡️ Next Word</button>
            
        </div>
    </div>

    <!-- ========================================
    SCREEN 7: SHOP
    Spend your hard-earned coins
    ======================================== -->
    <div id="shopScreen" class="screen">
        <div class="container">
            
            <button class="btn-back" onclick="showScreen('homeScreen')">← Back</button>
            
            <h2>🎁 Reward Shop</h2>
            
            <div class="stats">
                <span>🪙 <b id="shopCoins">0</b></span>
            </div>
            
            <div class="shop-items">
                
                <div class="shop-item">
                    <span class="shop-icon">🎩</span>
                    <h4>Safari Hat</h4>
                    <p>50 🪙</p>
                    <button onclick="buyItem('Safari Hat', 50)">Buy</button>
                </div>
                
                <div class="shop-item">
                    <span class="shop-icon">👓</span>
                    <h4>Cool Glasses</h4>
                    <p>30 🪙</p>
                    <button onclick="buyItem('Cool Glasses', 30)">Buy</button>
                </div>
                
                <div class="shop-item">
                    <span class="shop-icon">🧸</span>
                    <h4>Pet Buddy</h4>
                    <p>80 🪙</p>
                    <button onclick="buyItem('Pet Buddy', 80)">Buy</button>
                </div>
                
                <div class="shop-item">
                    <span class="shop-icon">🌈</span>
                    <h4>Rainbow Theme</h4>
                    <p>100 🪙</p>
                    <button onclick="buyItem('Rainbow Theme', 100)">Buy</button>
                </div>
                
            </div>
            
            <p class="shop-tip">💡 Play more games to earn coins!</p>
            
        </div>
    </div>

    <!-- ========================================
    SCREEN 8: PROGRESS
    See how far you've come
    ======================================== -->
    <div id="progressScreen" class="screen">
        <div class="container">
            
            <button class="btn-back" onclick="showScreen('homeScreen')">← Back</button>
            
            <h2>📊 My Progress</h2>
            
            <div class="progress-stats">
                <div class="stat-box">
                    <div class="stat-number" id="wordCount">0</div>
                    <div class="stat-label">Words Learned</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number" id="catCount">0</div>
                    <div class="stat-label">Categories Done</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number" id="bestStreakCount">0</div>
                    <div class="stat-label">Best Streak</div>
                </div>
            </div>
            
            <h3>🗺️ Your Journey</h3>
            <div class="journey-map">
                <div class="journey-steps">
                    <div class="step completed">🐶<br>Mammals<br><small id="mammalProgress">0/9</small></div>
                    <span class="step-arrow">→</span>
                    <div class="step locked">🦅<br>Birds<br><small id="birdProgress">0/7</small></div>
                    <span class="step-arrow">→</span>
                    <div class="step locked">🐍<br>Reptiles<br><small id="reptileProgress">0/5</small></div>
                    <span class="step-arrow">→</span>
                    <div class="step locked">🐸<br>Amphibians<br><small id="amphibianProgress">0/3</small></div>
                </div>
            </div>
            
        </div>
    </div>

    <!-- ========================================
    JAVASCRIPT FILES - The brain of the game
    Loaded at the end so HTML loads first
    ======================================== -->
    <script src="words.js"></script>
    <script src="script.js"></script>
</body>
</html>