// ============================================
// WORD SAFARI - Complete Game Logic
// Connected to Gyan Setu backend + Mascot
// ============================================

// ---------- BACKEND CONFIG ----------
const API_BASE = (window.API_BASE || 'api');
let CHILD_ID = (window.CHILD_ID || 0);

// ---------- DIFFICULTY MAPPING ----------
var DIFFICULTY_TO_TIER = { easy: 1, medium: 2, hard: 3 };
var CATEGORY_EMOJI = { mammals: '🐶', birds: '🦅', reptiles: '🐍', amphibians: '🐸' };
var CATEGORY_LABEL = { mammals: 'Mammals', birds: 'Birds', reptiles: 'Reptiles', amphibians: 'Amphibians' };

// ---------- WORD → EMOJI MAP (Correct animals!) ----------
var WORD_EMOJI = {
    // MAMMALS
    'CAT': '🐱', 'DOG': '🐶', 'COW': '🐄', 'PIG': '🐷',
    'BAT': '🦇', 'FOX': '🦊', 'BEAR': '🐻', 'DEER': '🦌',
    'ZEBRA': '🦓', 'TIGER': '🐯', 'RABBIT': '🐰', 'HORSE': '🐴',
    'MONKEY': '🐵', 'LION': '🦁', 'ELEPHANT': '🐘', 'GIRAFFE': '🦒',
    'DOLPHIN': '🐬', 'KANGAROO': '🦘',
    // BIRDS
    'DUCK': '🦆', 'HEN': '🐔', 'OWL': '🦉', 'EAGLE': '🦅',
    'PENGUIN': '🐧', 'PARROT': '🦜', 'SPARROW': '🐦',
    'FLAMINGO': '🦩', 'PELICAN': '🦢',
    // REPTILES
    'SNAKE': '🐍', 'LIZARD': '🦎', 'TURTLE': '🐢',
    'CROCODILE': '🐊', 'IGUANA': '🦎', 'CHAMELEON': '🦎',
    'ALLIGATOR': '🐊',
    // AMPHIBIANS
    'FROG': '🐸', 'TOAD': '🐸', 'SALAMANDER': '🦎', 'AXOLOTL': '🦎'
};

function getWordEmoji(wordText) {
    if (!wordText) return '🐾';
    return WORD_EMOJI[wordText.toUpperCase()] || '🐾';
}

// ---------- GAME STATE ----------
var game = {
    coins: 0,
    stars: 0,
    streak: 0,
    wordsLearned: 0,
    category: 'mammals',
    difficulty: 'easy',
    word: null,
    wordId: null,
    guessedLetters: [],
    wrongGuesses: 0,
    maxLives: 5,
    isGameOver: false,
    unlockedCategories: ['mammals'],
    completedCategories: [],
    usedWords: {},
    ownedItems: [],
    lastWord: null,
    gameStartTime: null
};

// ---------- MASCOT STATE ----------
var mascotVisible = false;
var messageTimer = null;

var MASCOT_MESSAGES = [
    'You can do it! 💪',
    'Keep going! 🌟',
    'Almost there! 🎯',
    'Try another letter! 💡',
    'I believe in you! 🌈',
    'Don\'t give up! 🚀',
    'You\'re so close! ⭐',
    'One more try! 💖'
];

// ============================================
// MASCOT FUNCTIONS
// ============================================
function getMascotEmoji() {
    if (!game.word) return CATEGORY_EMOJI[game.category] || '🦁';
    return getWordEmoji(game.word.word);
}

function showMascot() {
    var el = document.getElementById('peekMascot');
    if (!el) return;
    el.textContent = getMascotEmoji();
    el.classList.add('entering');
    setTimeout(function() {
        el.classList.remove('entering');
        el.classList.add('visible');
    }, 800);
    mascotVisible = true;
    updateMascotMessage();
    if (messageTimer) clearInterval(messageTimer);
    messageTimer = setInterval(updateMascotMessage, 6000);
}

function updateMascotMessage() {
    var el = document.getElementById('peekMascot');
    if (!el || !mascotVisible) return;
    var msg = MASCOT_MESSAGES[Math.floor(Math.random() * MASCOT_MESSAGES.length)];
    el.setAttribute('data-message', msg);
}

function hideMascot(sad) {
    var el = document.getElementById('peekMascot');
    if (!el) return;
    mascotVisible = false;
    if (messageTimer) clearInterval(messageTimer);
    if (sad) {
        el.classList.add('sad');
        setTimeout(function() {
            el.classList.remove('visible', 'sad', 'celebrate');
            el.removeAttribute('data-message');
        }, 1000);
    } else {
        el.classList.remove('visible', 'celebrate');
        el.removeAttribute('data-message');
    }
}

function celebrateMascot() {
    var el = document.getElementById('peekMascot');
    if (!el) return;
    el.textContent = getMascotEmoji();
    el.setAttribute('data-message', 'You did it! 🎉');
    el.classList.add('visible', 'celebrate');
    el.classList.remove('sad');
    mascotVisible = true;
}

function checkMascotTrigger() {
    var livesLeft = game.maxLives - game.wrongGuesses;
    if (livesLeft <= 2 && livesLeft > 0 && !mascotVisible) {
        showMascot();
    }
}

// ============================================
// HANGMAN DRAWING (Canvas)
// ============================================
function drawHangman(wrongCount) {
    var canvas = document.getElementById('hangmanCanvas');
    if (!canvas) return;
    var ctx = canvas.getContext('2d');
    var w = canvas.width;
    var h = canvas.height;
    ctx.clearRect(0, 0, w, h);
    ctx.strokeStyle = '#4a148c';
    ctx.lineWidth = 3;
    ctx.lineCap = 'round';

    ctx.beginPath();
    ctx.moveTo(20, h - 20);
    ctx.lineTo(w - 20, h - 20);
    ctx.moveTo(50, h - 20);
    ctx.lineTo(50, 30);
    ctx.moveTo(50, 30);
    ctx.lineTo(140, 30);
    ctx.moveTo(140, 30);
    ctx.lineTo(140, 45);
    ctx.stroke();

    var parts = [drawHead, drawBody, drawLeftArm, drawRightArm, drawLeftLeg, drawRightLeg];
    for (var i = 0; i < Math.min(wrongCount, parts.length); i++) {
        parts[i](ctx);
    }
}

function drawHead(ctx) {
    ctx.beginPath();
    ctx.arc(140, 62, 15, 0, Math.PI * 2);
    ctx.stroke();
    ctx.fillStyle = '#4a148c';
    ctx.beginPath();
    ctx.arc(134, 58, 3, 0, Math.PI * 2);
    ctx.fill();
    ctx.beginPath();
    ctx.arc(146, 58, 3, 0, Math.PI * 2);
    ctx.fill();
    ctx.beginPath();
    ctx.arc(140, 66, 8, 0.1, Math.PI - 0.1);
    ctx.stroke();
}
function drawBody(ctx) {
    ctx.beginPath();
    ctx.moveTo(140, 77);
    ctx.lineTo(140, 125);
    ctx.stroke();
}
function drawLeftArm(ctx) {
    ctx.beginPath();
    ctx.moveTo(140, 95);
    ctx.lineTo(115, 110);
    ctx.stroke();
}
function drawRightArm(ctx) {
    ctx.beginPath();
    ctx.moveTo(140, 95);
    ctx.lineTo(165, 110);
    ctx.stroke();
}
function drawLeftLeg(ctx) {
    ctx.beginPath();
    ctx.moveTo(140, 125);
    ctx.lineTo(120, 145);
    ctx.stroke();
}
function drawRightLeg(ctx) {
    ctx.beginPath();
    ctx.moveTo(140, 125);
    ctx.lineTo(160, 145);
    ctx.stroke();
}

// ============================================
// API HELPERS
// ============================================
async function resolveChildId() {
    if (CHILD_ID > 0) return CHILD_ID;
    try {
        var r = await fetch(API_BASE + '/get_stats.php');
        var d = await r.json();
        if (d.success && d.child_id) CHILD_ID = d.child_id;
    } catch (e) { console.warn('Could not resolve child:', e); }
    return CHILD_ID;
}

async function loadStatsFromDB() {
    await resolveChildId();
    if (CHILD_ID <= 0) return;
    try {
        var r = await fetch(API_BASE + '/get_stats.php?child_id=' + CHILD_ID);
        var d = await r.json();
        if (d.success) {
            game.streak = d.streak || 0;
        }
    } catch (e) { console.warn(e); }
}

async function saveGameToDB(status) {
    await resolveChildId();
    if (CHILD_ID <= 0) {
        console.warn('No child logged in; game not saved to DB');
        return null;
    }
    if (!game.wordId || !game.word) return null;

    var wordText = game.word.word.toUpperCase();
    var totalLetters = wordText.length;
    var correctCount = 0;
    for (var i = 0; i < wordText.length; i++) {
        if (game.guessedLetters.indexOf(wordText[i]) !== -1) correctCount++;
    }
    var timeSpent = game.gameStartTime ? Math.floor((Date.now() - game.gameStartTime) / 1000) : 0;

    var payload = {
        child_id: CHILD_ID,
        word_id: game.wordId,
        word: wordText,
        difficulty_tier: DIFFICULTY_TO_TIER[game.difficulty] || 1,
        status: status,
        attempts: game.guessedLetters.length,
        wrong_guesses: game.wrongGuesses,
        correct_count: correctCount,
        total_letters: totalLetters,
        time_spent: timeSpent,
        guessed_letters: game.guessedLetters
    };

    try {
        var r = await fetch(API_BASE + '/save_game.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        return await r.json();
    } catch (e) {
        console.error('Save failed:', e);
        return null;
    }
}

async function fetchWordFromDB() {
    var tier = DIFFICULTY_TO_TIER[game.difficulty] || 1;
    var url = API_BASE + '/get_word.php?tier=' + tier + '&category=' + encodeURIComponent(game.category);
    try {
        var r = await fetch(url);
        var d = await r.json();
        if (!d.success) return null;
        return {
            word: d.word,
            word_id: d.word_id,
            hint: d.hint,
            image: getWordEmoji(d.word),
            meaning: d.hint,
            fact: 'Fun fact about ' + d.word.toLowerCase() + '!'
        };
    } catch (e) {
        console.error('Fetch word failed:', e);
        return null;
    }
}

// ============================================
// SCREEN MANAGEMENT
// ============================================
function showScreen(screenId) {
    var screens = document.querySelectorAll('.screen');
    for (var i = 0; i < screens.length; i++) {
        screens[i].classList.remove('active');
    }
    document.getElementById(screenId).classList.add('active');
    updateUI();

    if (screenId === 'gameScreen') {
        setTimeout(function() { drawHangman(game.wrongGuesses); }, 100);
    }
    if (screenId === 'progressScreen' || screenId === 'categoryScreen') {
        updateProgress();
    }
}

// ============================================
// UI UPDATES
// ============================================
function updateUI() {
    var starElements = document.querySelectorAll('#starsDisplay, #gameStars');
    for (var i = 0; i < starElements.length; i++) starElements[i].textContent = game.stars;

    var coinElements = document.querySelectorAll('#coinsDisplay, #gameCoins, #shopCoins');
    for (var i = 0; i < coinElements.length; i++) coinElements[i].textContent = game.coins;

    var streakElements = document.querySelectorAll('#streakDisplay, #bestStreakCount');
    for (var i = 0; i < streakElements.length; i++) streakElements[i].textContent = game.streak;

    var livesDisplay = document.getElementById('livesDisplay');
    if (livesDisplay) livesDisplay.textContent = game.maxLives - game.wrongGuesses;
}

// ============================================
// CATEGORY SELECTION
// ============================================
function selectCategory(category) {
    if (game.unlockedCategories.indexOf(category) === -1) {
        showToast('🔒 Complete previous category first!');
        return;
    }
    game.category = category;
    showScreen('difficultyScreen');
}

// ============================================
// START GAME
// ============================================
async function startGame(difficulty) {
    game.difficulty = difficulty;
    game.wrongGuesses = 0;
    game.guessedLetters = [];
    game.isGameOver = false;

    var livesMap = { easy: 5, medium: 4, hard: 3 };
    game.maxLives = livesMap[difficulty] || 5;

    showToast('⏳ Loading word...');

    var wordData = await fetchWordFromDB();

    if (!wordData) {
        // Fallback to local words
        var wordList = WORDS[game.category] && WORDS[game.category][difficulty];
        if (!wordList || wordList.length === 0) {
            showToast('No words found!');
            return;
        }
        var key = game.category + '_' + difficulty;
        if (!game.usedWords[key]) game.usedWords[key] = [];
        var available = [];
        for (var i = 0; i < wordList.length; i++) {
            if (game.usedWords[key].indexOf(i) === -1) available.push(i);
        }
        if (available.length === 0) {
            game.usedWords[key] = [];
            available = [0];
        }
        var randomIndex = available[Math.floor(Math.random() * available.length)];
        game.word = wordList[randomIndex];
        game.wordId = null;
        game.usedWords[key].push(randomIndex);
    } else {
        game.word = wordData;
        game.wordId = wordData.word_id;
    }

    game.gameStartTime = Date.now();

    setupGame();
    showScreen('gameScreen');
}

// ============================================
// SETUP GAME
// ============================================
function setupGame() {
    var word = game.word;
    if (!word) return;

    drawHangman(0);
    document.getElementById('feedbackMessage').textContent = '💡 Hint: "' + word.hint + '"';

    var catLabel = document.getElementById('gameCategoryLabel');
    if (catLabel) catLabel.textContent = (CATEGORY_EMOJI[game.category] || '🐾') + ' ' + (CATEGORY_LABEL[game.category] || 'Mammals');
    var diffLabel = document.getElementById('gameDifficultyLabel');
    if (diffLabel) {
        var emoji = { easy: '🌱', medium: '🌿', hard: '🌳' }[game.difficulty] || '🌱';
        diffLabel.textContent = emoji + ' ' + game.difficulty.charAt(0).toUpperCase() + game.difficulty.slice(1);
    }

    updateWordDisplay();
    buildKeyboard();
    updateUI();

    // Hide mascot at start of new game
    hideMascot();
}

// ============================================
// BUILD KEYBOARD
// ============================================
function buildKeyboard() {
    var container = document.getElementById('keyboard');
    container.innerHTML = '';
    var letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    for (var i = 0; i < letters.length; i++) {
        var btn = document.createElement('button');
        btn.className = 'key-btn';
        btn.textContent = letters[i];
        btn.dataset.letter = letters[i];
        btn.onclick = (function(letter) {
            return function() { handleLetterClick(letter, this); };
        })(letters[i]);
        container.appendChild(btn);
    }
}

// ============================================
// HANDLE LETTER CLICK
// ============================================
function handleLetterClick(letter, btn) {
    if (game.isGameOver) return;
    if (btn.classList.contains('used')) return;

    btn.classList.add('used');
    game.guessedLetters.push(letter);

    var word = game.word;
    var wordLetters = word.word.toUpperCase().split('');
    var isCorrect = false;
    for (var i = 0; i < wordLetters.length; i++) {
        if (wordLetters[i] === letter) { isCorrect = true; break; }
    }

    if (isCorrect) {
        btn.classList.add('correct');
        game.coins += 1;
        game.stars += 1;
        setFeedback('🌟 Great! "' + letter + '" is in the word!');
        updateWordDisplay();

        if (checkWordComplete()) {
            wordComplete();
        }
    } else {
        btn.classList.add('wrong');
        game.wrongGuesses++;
        drawHangman(game.wrongGuesses);
        setFeedback('🤗 Good try! "' + letter + '" is not here. Try again!');
        updateUI();

        // Check if mascot should appear
        checkMascotTrigger();
        if (mascotVisible) updateMascotMessage();

        if (game.wrongGuesses >= game.maxLives) {
            gameOver();
        }
    }
    updateUI();
}

// ============================================
// UPDATE WORD DISPLAY
// ============================================
function updateWordDisplay() {
    var word = game.word;
    if (!word) return;
    var letters = word.word.toUpperCase().split('');
    var display = '';
    for (var i = 0; i < letters.length; i++) {
        if (game.guessedLetters.indexOf(letters[i]) !== -1) {
            display += letters[i] + ' ';
        } else {
            display += '_ ';
        }
    }
    var el = document.getElementById('wordDisplay');
    el.textContent = display.trim();

    var wordLength = word.word.length;
    el.classList.remove('long-word', 'very-long-word');
    if (wordLength > 8) el.classList.add('long-word');
    if (wordLength > 12) el.classList.add('very-long-word');
}

// ============================================
// CHECK WORD COMPLETE
// ============================================
function checkWordComplete() {
    var word = game.word;
    if (!word) return false;
    var letters = word.word.toUpperCase().split('');
    for (var i = 0; i < letters.length; i++) {
        if (game.guessedLetters.indexOf(letters[i]) === -1) return false;
    }
    return true;
}

// ============================================
// WORD COMPLETE (WIN)
// ============================================
async function wordComplete() {
    game.isGameOver = true;
    game.wordsLearned++;
    game.streak++;

    var bonusStars = 5;
    var bonusCoins = 10;
    if (game.wrongGuesses === 0) {
        bonusStars += 5;
        bonusCoins += 5;
    }

    game.stars += bonusStars;
    game.coins += bonusCoins;
    game.lastWord = game.word;

    // Correct emoji!
    var emoji = getWordEmoji(game.word.word);
    document.getElementById('correctAnimal').textContent = emoji;
    document.getElementById('correctWord').textContent = game.word.word.toUpperCase();
    document.getElementById('correctStars').textContent = bonusStars;
    document.getElementById('correctCoins').textContent = bonusCoins;

    updateUI();
    showScreen('correctScreen');

    // Celebrate mascot!
    celebrateMascot();

    // Save to DB
    var result = await saveGameToDB('won');
    if (result && result.success) {
        if (result.coins_earned) {
            game.coins += result.coins_earned;
            updateUI();
            document.getElementById('correctCoins').textContent = bonusCoins + ' + ' + result.coins_earned + '🪙';
        }
        if (result.new_badges && result.new_badges.length > 0) {
            showToast('🏅 New badge unlocked!');
        }
    }
}

// ============================================
// GAME OVER (LOSE)
// ============================================
async function gameOver() {
    game.isGameOver = true;
    var word = game.word;

    hideMascot(true);

    setFeedback('😊 Don\'t worry! The word was "' + word.word + '"');
    document.getElementById('wordDisplay').textContent = word.word.toUpperCase().split('').join(' ');

    await saveGameToDB('lost');

    setTimeout(function() {
        game.lastWord = word;
        showLearning();
    }, 2000);
}

// ============================================
// SHOW LEARNING SCREEN
// ============================================
function showLearning() {
    var word = game.lastWord || game.word;
    if (!word) {
        showToast('No word to learn about!');
        return;
    }

    // Correct emoji!
    document.getElementById('learnEmoji').textContent = getWordEmoji(word.word);
    document.getElementById('learnWord').textContent = word.word.toUpperCase();
    document.getElementById('learnMeaning').textContent = word.meaning || word.hint || 'A fascinating animal!';
    document.getElementById('learnFact').textContent = word.fact || 'Learn more about this creature!';
    document.getElementById('learnLetter').textContent = 'The word starts with "' + word.word.charAt(0).toUpperCase() + '"';

    showScreen('learningScreen');
}

// ============================================
// NEXT WORD
// ============================================
function nextWord() {
    startGame(game.difficulty);
}

// ============================================
// EXIT GAME
// ============================================
function exitGame() {
    if (confirm('Exit the game?')) {
        hideMascot();
        showScreen('categoryScreen');
    }
}

// ============================================
// USE HINT
// ============================================
function useHint() {
    if (game.isGameOver) return;
    if (!game.word) return;

    var costs = { easy: 0, medium: 20, hard: 30 };
    var cost = costs[game.difficulty] || 20;

    if (cost > 0 && game.coins < cost) {
        showToast('💡 Need ' + cost + ' coins for a hint!');
        return;
    }

    var letters = game.word.word.toUpperCase().split('');
    var hintLetter = null;
    for (var i = 0; i < letters.length; i++) {
        if (game.guessedLetters.indexOf(letters[i]) === -1) {
            hintLetter = letters[i];
            break;
        }
    }

    if (!hintLetter) {
        showToast('You have all the letters!');
        return;
    }

    if (cost > 0) {
        game.coins -= cost;
        showToast('💡 Hint: "' + hintLetter + '" is in the word! (' + cost + ' coins)');
    } else {
        showToast('💡 Free hint: "' + hintLetter + '" is in the word!');
    }

    var btns = document.querySelectorAll('.key-btn');
    for (var i = 0; i < btns.length; i++) {
        if (btns[i].dataset.letter === hintLetter && !btns[i].classList.contains('used')) {
            handleLetterClick(hintLetter, btns[i]);
            break;
        }
    }
    updateUI();
}

// ============================================
// SPEAK WORD
// ============================================
function speakWord() {
    if (!game.word) return;
    if ('speechSynthesis' in window) {
        var utterance = new SpeechSynthesisUtterance(game.word.word);
        utterance.rate = 0.8;
        utterance.pitch = 1.1;
        speechSynthesis.speak(utterance);
        setFeedback('🔊 Listening: "' + game.word.word + '"');
    } else {
        showToast('🔊 Speech not supported in this browser!');
    }
}

// ============================================
// SET FEEDBACK
// ============================================
function setFeedback(message) {
    document.getElementById('feedbackMessage').textContent = message;
}

// ============================================
// BUY ITEM (Shop)
// ============================================
function buyItem(name, cost) {
    if (game.coins < cost) {
        showToast('❌ You need ' + cost + ' coins!');
        return;
    }
    if (game.ownedItems.indexOf(name) !== -1) {
        showToast('🎁 You already have ' + name + '!');
        return;
    }
    game.coins -= cost;
    game.ownedItems.push(name);
    updateUI();
    showToast('🎉 You bought ' + name + '! 🎉');
}

// ============================================
// SHOW TOAST
// ============================================
function showToast(message) {
    var toast = document.getElementById('toast');
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(function() {
        toast.classList.remove('show');
    }, 2500);
}

// ============================================
// UPDATE PROGRESS
// ============================================
function updateProgress() {
    var categories = ['mammals', 'birds', 'reptiles', 'amphibians'];
    var totalWords = 0;
    for (var c = 0; c < categories.length; c++) {
        var cat = categories[c];
        if (WORDS[cat]) {
            var diffs = ['easy', 'medium', 'hard'];
            for (var d = 0; d < diffs.length; d++) {
                var list = WORDS[cat][diffs[d]];
                if (list) totalWords += list.length;
            }
        }
    }

    var progress = totalWords > 0 ? Math.round((game.wordsLearned / totalWords) * 100) : 0;
    document.getElementById('progressText').textContent = progress + '%';
    document.getElementById('progressBar').style.width = progress + '%';
    document.getElementById('wordCount').textContent = game.wordsLearned;
    document.getElementById('catCount').textContent = game.completedCategories.length;
    document.getElementById('bestStreakCount').textContent = game.streak;

    for (var c = 0; c < categories.length; c++) {
        var cat = categories[c];
        var total = 0;
        if (WORDS[cat]) {
            var diffs = ['easy', 'medium', 'hard'];
            for (var d = 0; d < diffs.length; d++) {
                var list = WORDS[cat][diffs[d]];
                if (list) total += list.length;
            }
        }
        var done = 0;
        var key = cat + '_easy'; done += (game.usedWords[key] || []).length;
        key = cat + '_medium'; done += (game.usedWords[key] || []).length;
        key = cat + '_hard'; done += (game.usedWords[key] || []).length;
        var el = document.getElementById(cat + 'Progress');
        if (el) el.textContent = done + '/' + total;
    }
}

// ============================================
// INITIALIZE
// ============================================
document.addEventListener('DOMContentLoaded', async function() {
    showScreen('homeScreen');
    updateUI();
    updateProgress();

    var canvas = document.getElementById('hangmanCanvas');
    if (canvas) {
        canvas.width = canvas.offsetWidth || 250;
        canvas.height = canvas.offsetHeight || 160;
    }

    await resolveChildId();
    await loadStatsFromDB();

    setTimeout(function() {
        if (CHILD_ID > 0) {
            showToast('🌈 Welcome back to Word Safari!');
        } else {
            showToast('🌈 Welcome to Word Safari!');
        }
    }, 500);
});

// ============================================
// REDRAW ON RESIZE
// ============================================
window.addEventListener('resize', function() {
    var canvas = document.getElementById('hangmanCanvas');
    if (canvas && canvas.width !== canvas.offsetWidth) {
        canvas.width = canvas.offsetWidth || 250;
        canvas.height = canvas.offsetHeight || 160;
        drawHangman(game.wrongGuesses);
    }
});

// ============================================
// KEYBOARD SHORTCUTS
// ============================================
document.addEventListener('keydown', function(e) {
    var key = e.key.toUpperCase();
    if (key >= 'A' && key <= 'Z') {
        var btns = document.querySelectorAll('.key-btn');
        for (var i = 0; i < btns.length; i++) {
            if (btns[i].dataset.letter === key && !btns[i].classList.contains('used')) {
                handleLetterClick(key, btns[i]);
                break;
            }
        }
    }
});

console.log('🌈 Word Safari loaded with all features!');