(function() {
    'use strict';

    //  UI STRINGS
    const UI_STRINGS = {
        en: {
            greeting: "👋 Hi there, Explorer!",
            subGreeting: "Choose a subject below and let's start learning together!",
            subjectTitle: "📚 What do you want to learn?",
            subjectSub: "Pick a topic and start your adventure!",
            levelTitle: "🎯 Choose your level!",
            startBtn: "🚀 Start Adventure",
            startFlashcards: "🚀 Start Flashcards",
            progressLabel: " complete",
            questionLabel: "📝 Question",
            puzzleLabel: "🧩 Puzzle",
            checkOrder: "✅ Check Order",
            back: "Back",
            next: "Next",
            finish: "🎉 Finish",
            feedbackThink: "🤔 Think carefully!",
            feedbackCorrect: "🎉 Amazing! You got it! +1 ⭐ +2 💰",
            feedbackWrong: "❌ Oops! The correct answer was: ",
            feedbackPuzzleHint: "🧩 Arrange the items correctly!",
            feedbackPuzzleSolved: "🧩 Puzzle solved! +1 ⭐ +3 💰",
            feedbackPuzzleWrong: "❌ Not quite right! Try swapping the items.",
            resultTitle: "Great Job, Scientist!",
            resultMsgStar: "🌟 You're a science superstar!",
            resultMsgMid: "🌱 Keep exploring! Every scientist starts somewhere!",
            resultMsgHigh: "🌈 Great job! You're learning so much!",
            resultMsgTop: "🏆 Amazing! You're a true Science Champion!",
            playAgain: "🔁 Play Again",
            tapToSelect: "Tap to select",
            selected: "✓ Selected!",
            tapLevel: "Tap to select",
            yourLevel: "✓ Your Level!",
            menu: "Menu",
            popupCongrats: "🎉 You completed all flashcards!",
            popupPlayAgain: "🔄 Play Again",
            popupHome: "🏠 Home",
            popupOk: "OK",
            flashcardTitle: "Flashcards",
            flashcardCard: "Card",
            flashcardOf: "of",
            flashcardPrev: "◀ Prev",
            flashcardNext: "Next ▶",
            flashcardFlip: "🔄 Flip",
            flashcardShuffle: "🔀 Shuffle",
            flashcardBack: "🏠 Back to Menu",
            resetTitle: "Reset Scores?",
            resetDesc: "This will clear all your ⭐ stars and 💰 coins. This cannot be undone!",
            resetCancel: "Cancel",
            resetConfirm: "Yes, Reset",
            resetToast: "🔄 Scores have been reset!"
        },
        ne: {
            greeting: "👋 नमस्ते, अन्वेषक!",
            subGreeting: "तपाईं के सिक्न चाहनुहुन्छ? तलको विषय छान्नुहोस् र सँगै सिक्न सुरु गरौं!",
            subjectTitle: "📚 तपाईं के सिक्न चाहनुहुन्छ?",
            subjectSub: "एउटा विषय छान्नुहोस् र आफ्नो यात्रा सुरु गर्नुहोस्!",
            levelTitle: "🎯 आफ्नो स्तर छान्नुहोस्!",
            startBtn: "🚀 यात्रा सुरु गर्नुहोस्",
            startFlashcards: "🚀 फ्ल्यास कार्ड सुरु गर्नुहोस्",
            progressLabel: " पूरा",
            questionLabel: "📝 प्रश्न",
            puzzleLabel: "🧩 पजल",
            checkOrder: "✅ क्रम जाँच गर्नुहोस्",
            back: "पछाडि",
            next: "अर्को",
            finish: "🎉 समाप्त",
            feedbackThink: "🤔 ध्यानपूर्वक सोच्नुहोस्!",
            feedbackCorrect: "🎉 वाह! तपाईंले पाउनुभयो! +1 ⭐ +2 💰",
            feedbackWrong: "❌ उफ्! सही उत्तर थियो: ",
            feedbackPuzzleHint: "🧩 वस्तुहरूलाई सही क्रममा मिलाउनुहोस्!",
            feedbackPuzzleSolved: "🧩 पजल हल भयो! +1 ⭐ +3 💰",
            feedbackPuzzleWrong: "❌ ठीक छैन! वस्तुहरू साट्नुहोस्।",
            resultTitle: "राम्रो काम, वैज्ञानिक!",
            resultMsgStar: "🌟 तपाईं विज्ञानका सुपरस्टार हुनुहुन्छ!",
            resultMsgMid: "🌱 खोजी गरिरहनुहोस्! हरेक वैज्ञानिक कतैबाट सुरु हुन्छ!",
            resultMsgHigh: "🌈 राम्रो काम! तपाईं धेरै सिक्दै हुनुहुन्छ!",
            resultMsgTop: "🏆 अद्भुत! तपाईं साँचो विज्ञान च्याम्पियन हुनुहुन्छ!",
            playAgain: "🔁 फेरि खेल्नुहोस्",
            tapToSelect: "छान्नको लागि ट्याप गर्नुहोस्",
            selected: "✓ चयन गरियो!",
            tapLevel: "छान्नको लागि ट्याप गर्नुहोस्",
            yourLevel: "✓ तपाईंको स्तर!",
            menu: "मेनु",
            popupCongrats: "🎉 तपाईंले सबै फ्ल्यास कार्ड पूरा गर्नुभयो!",
            popupPlayAgain: "🔄 फेरि खेल्नुहोस्",
            popupHome: "🏠 गृह",
            popupOk: "हुन्छ",
            flashcardTitle: "फ्ल्यास कार्ड",
            flashcardCard: "कार्ड",
            flashcardOf: "को",
            flashcardPrev: "◀ अघिल्लो",
            flashcardNext: "अर्को ▶",
            flashcardFlip: "🔄 पल्टाउनुहोस्",
            flashcardShuffle: "🔀 मिसाउनुहोस्",
            flashcardBack: "🏠 मेनुमा फर्कनुहोस्",
            resetTitle: "स्कोर रिसेट गर्ने?",
            resetDesc: "यसले तपाईंका सबै ⭐ तारा र 💰 सिक्का मेटाउँछ। यो फिर्ता गर्न सकिँदैन!",
            resetCancel: "रद्द गर्नुहोस्",
            resetConfirm: "हो, रिसेट गर्नुहोस्",
            resetToast: "🔄 स्कोर रिसेट भयो!"
        }
    };

    //  API HANDLER
    const API_BASE = 'quiz_flashcards.php';

    async function apiFetch(action, params = {}) {
        const url = new URL(API_BASE, window.location.href);
        url.searchParams.append('action', action);
        for (const [key, val] of Object.entries(params)) {
            url.searchParams.append(key, val);
        }
        const resp = await fetch(url);
        const data = await resp.json();
        if (data.error) throw new Error(data.error);
        return data;
    }

    async function apiPost(action, payload) {
        const url = new URL(API_BASE, window.location.href);
        url.searchParams.append('action', action);
        const resp = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        const data = await resp.json();
        if (data.error) throw new Error(data.error);
        return data;
    }

    //  DATA LOADING FUNCTIONS
    async function loadSubjects() {
        const data = await apiFetch('subjects');
        return data.subjects;
    }

    async function loadLevels(subjectId) {
        const data = await apiFetch('levels', { subject_id: subjectId });
        return data.levels;
    }

    async function loadQuestions(levelId) {
        const data = await apiFetch('questions', { level_id: levelId });
        return data.questions;
    }

    async function loadFlashcards(levelId) {
        const data = await apiFetch('flashcards', { level_id: levelId });
        return data.flashcards;
    }

    //  PROGRESS SAVING
    async function saveQuestionProgress(questionId, isCorrect, stars, coins) {
        try {
            const data = await apiPost('save_question', {
                question_id: questionId,
                is_correct: isCorrect,
                stars: stars,
                coins: coins
            });
            if (data.success && data.stats) {
                state.stars = data.stats.total_stars;
                state.coins = data.stats.total_coins;
                updateScoreUI();
            }
        } catch (err) {
            console.error('Failed to save question progress:', err);
        }
    }

    async function saveFlashcardProgress(cardId, stars) {
        try {
            const data = await apiPost('save_flashcard', {
                card_id: cardId,
                stars: stars
            });
            if (data.success && data.stats) {
                state.stars = data.stats.total_stars;
                state.coins = data.stats.total_coins;
                updateScoreUI();
            }
        } catch (err) {
            console.error('Failed to save flashcard progress:', err);
        }
    }

    //  State management
    let state = {
        lang: 'en',
        soundEnabled: true,
        subject: null,
        level: null,
        questions: [],
        currentIndex: 0,
        stars: 0,
        coins: 0,
        gameStars: 0,
        gameCoins: 0,
        selectedOption: null,
        answered: false,
        puzzleOrder: [],
        puzzleSolved: false,
        questionRewarded: false,
        totalQuestions: 0,
        correctCount: 0,
        answeredCount: 0,
        isTransitioning: false,
        fcDeck: [],
        fcCurrentIndex: 0,
        fcFlipped: false,
        fcStarsEarned: 0,
        fcCoinsEarned: 0,
        fcLevelData: null
    };

    //  REFERENCES TO DOM ELEMENTS
    const $ = id => document.getElementById(id);
    const homeScreen = $('homeScreen'),
        gameScreen = $('gameScreen'),
        resultScreen = $('resultScreen');
    const flashcardScreen = $('flashcardScreen'),
        popupModal = $('popupModal');
    const popupEmoji = $('popupEmoji'),
        popupText = $('popupText'),
        popupStats = $('popupStats'),
        popupBtnContainer = $('popupBtnContainer');
    const startBtn = $('startGameBtn'),
        starCount = $('starCount'),
        coinCount = $('coinCount');

    //  PERSISTENCE
    function saveScores() {
        try {
            localStorage.setItem('gn_setu_stars', String(state.stars));
            localStorage.setItem('gn_setu_coins', String(state.coins));
        } catch (e) {}
    }

    function loadScores() {
        try {
            const stars = localStorage.getItem('gn_setu_stars');
            const coins = localStorage.getItem('gn_setu_coins');
            if (stars !== null) state.stars = parseInt(stars, 10) || 0;
            if (coins !== null) state.coins = parseInt(coins, 10) || 0;
        } catch (e) {}
    }

    //  SCREEN MANAGEMENT
    function showHome() {
        homeScreen.style.display = 'block';
        gameScreen.classList.remove('active');
        flashcardScreen.style.display = 'none';
        flashcardScreen.classList.remove('active');
        resultScreen.classList.remove('active');
    }

    //  SOUND SYSTEM
    let audioCtx = null;

    function getAudioContext() {
        if (!audioCtx) {
            audioCtx = new(window.AudioContext || window.webkitAudioContext)();
        }
        if (audioCtx.state === 'suspended') {
            audioCtx.resume();
        }
        return audioCtx;
    }

    function playCorrectSound() {
        if (!state.soundEnabled) return;
        try {
            const ctx = getAudioContext();
            const now = ctx.currentTime;
            const notes = [523.25, 659.25, 783.99, 1046.50];
            notes.forEach((freq, i) => {
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();
                osc.type = 'square';
                osc.frequency.setValueAtTime(freq, now + i * 0.08);
                gain.gain.setValueAtTime(0.1, now + i * 0.08);
                gain.gain.exponentialRampToValueAtTime(0.001, now + i * 0.08 + 0.15);
                osc.connect(gain);
                gain.connect(ctx.destination);
                osc.start(now + i * 0.08);
                osc.stop(now + i * 0.08 + 0.15);
            });
            const sparkle = [1046.50, 1318.51, 1567.98, 2093.00];
            sparkle.forEach((freq, i) => {
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();
                osc.type = 'sine';
                osc.frequency.setValueAtTime(freq, now + i * 0.08);
                gain.gain.setValueAtTime(0.05, now + i * 0.08);
                gain.gain.exponentialRampToValueAtTime(0.001, now + i * 0.08 + 0.1);
                osc.connect(gain);
                gain.connect(ctx.destination);
                osc.start(now + i * 0.08);
                osc.stop(now + i * 0.08 + 0.1);
            });
        } catch (e) {}
    }

    function playWrongSound() {
        if (!state.soundEnabled) return;
        try {
            const ctx = getAudioContext();
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.type = 'sawtooth';
            osc.frequency.setValueAtTime(300, ctx.currentTime);
            osc.frequency.exponentialRampToValueAtTime(100, ctx.currentTime + 0.4);
            gain.gain.setValueAtTime(0.12, ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.4);
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start(ctx.currentTime);
            osc.stop(ctx.currentTime + 0.4);
        } catch (e) {}
    }

    function playFlipSound() {
        if (!state.soundEnabled) return;
        try {
            const ctx = getAudioContext();
            const now = ctx.currentTime;
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.type = 'triangle';
            osc.frequency.setValueAtTime(400, now);
            osc.frequency.linearRampToValueAtTime(900, now + 0.08);
            gain.gain.setValueAtTime(0.2, now);
            gain.gain.exponentialRampToValueAtTime(0.001, now + 0.15);
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start(now);
            osc.stop(now + 0.15);
            const osc2 = ctx.createOscillator();
            const gain2 = ctx.createGain();
            osc2.type = 'sine';
            osc2.frequency.setValueAtTime(1500, now + 0.08);
            gain2.gain.setValueAtTime(0.1, now + 0.08);
            gain2.gain.exponentialRampToValueAtTime(0.001, now + 0.3);
            osc2.connect(gain2);
            gain2.connect(ctx.destination);
            osc2.start(now + 0.08);
            osc2.stop(now + 0.3);
        } catch (e) {}
    }

    function playSparkleSound() {
        if (!state.soundEnabled) return;
        try {
            const ctx = getAudioContext();
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.type = 'triangle';
            osc.frequency.setValueAtTime(1600, ctx.currentTime);
            gain.gain.setValueAtTime(0.1, ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.06);
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start(ctx.currentTime);
            osc.stop(ctx.currentTime + 0.06);
        } catch (e) {}
    }

    function playCelebrationSound() {
        if (!state.soundEnabled) return;
        try {
            const ctx = getAudioContext();
            const now = ctx.currentTime;
            const notes = [523, 523, 659, 659, 784, 784, 1047];
            notes.forEach((freq, i) => {
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();
                osc.type = 'square';
                osc.frequency.setValueAtTime(freq, now + i * 0.1);
                gain.gain.setValueAtTime(0.1, now + i * 0.1);
                gain.gain.exponentialRampToValueAtTime(0.001, now + i * 0.1 + 0.2);
                osc.connect(gain);
                gain.connect(ctx.destination);
                osc.start(now + i * 0.1);
                osc.stop(now + i * 0.1 + 0.2);
            });
        } catch (e) {}
    }

    function playClickSound() {
        if (!state.soundEnabled) return;
        try {
            const ctx = getAudioContext();
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(600, ctx.currentTime);
            gain.gain.setValueAtTime(0.05, ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.04);
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.start(ctx.currentTime);
            osc.stop(ctx.currentTime + 0.04);
        } catch (e) {}
    }

    //  FEEDBACK TOAST
    let toastTimeout = null;

    function showToast(message, isCorrect) {
        const toast = $('feedbackToast');
        if (toastTimeout) clearTimeout(toastTimeout);
        toast.textContent = message;
        toast.className = 'feedback-toast show';
        toast.classList.add(isCorrect ? 'toast-correct' : 'toast-wrong');
        toastTimeout = setTimeout(() => {
            toast.className = 'feedback-toast hide';
            toastTimeout = null;
        }, 2500);
    }

    // Helper to update the score display in the UI
    function updateScoreUI() {
        starCount.textContent = state.stars;
        coinCount.textContent = state.coins;
        const resultStar = document.getElementById('resultStarCount');
        const resultCoin = document.getElementById('resultCoinCount');
        if (resultStar) resultStar.textContent = state.stars;
        if (resultCoin) resultCoin.textContent = state.coins;
        saveScores();
    }

    function updateLevelBadge() {
        const badge = $('levelBadge');
        const badgeResult = $('levelBadgeResult');
        if (state.level) {
            const lvl = state.level.charAt(0).toUpperCase() + state.level.slice(1);
            const text = '  ' + lvl;
            if (badge) badge.textContent = text;
            if (badgeResult) badgeResult.textContent = text;
        } else {
            const menuText = state.lang === 'en' ? '🎮 Menu' : '🎮 मेनु';
            if (badge) badge.textContent = menuText;
            if (badgeResult) badgeResult.textContent = menuText;
        }
    }

    //  confetti popup for flashcard completion
    function showFlashcardPopup(emoji, text, statsText, onPlayAgain, onHome) {
        popupEmoji.textContent = emoji || '🎉';
        popupText.textContent = text || (state.lang === 'en' ? '🎉 You completed all flashcards!' :
            '🎉 तपाईंले सबै फ्ल्यास कार्ड पूरा गर्नुभयो!');
        popupStats.textContent = statsText || '⭐ 0  |  💰 0';
        popupBtnContainer.innerHTML = '';

        const playAgainBtn = document.createElement('button');
        playAgainBtn.className = 'popup-btn';
        const ui = UI_STRINGS[state.lang];
        playAgainBtn.textContent = ui.popupPlayAgain;
        playAgainBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            popupModal.classList.remove('active');
            if (onPlayAgain) onPlayAgain();
        });
        popupBtnContainer.appendChild(playAgainBtn);

        const homeBtn = document.createElement('button');
        homeBtn.className = 'popup-btn';
        homeBtn.textContent = ui.popupHome;
        homeBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            popupModal.classList.remove('active');
            if (onHome) onHome();
        });
        popupBtnContainer.appendChild(homeBtn);

        popupModal.classList.add('active');
    }

    //  CONFETTI POPPER
    const popperCanvas = $('confettiPopperCanvas');
    const ctxP = popperCanvas.getContext('2d');
    let popperParticles = [];
    let popperAnimId = null;
    let popperRunning = false;

    function resizePopperCanvas() {
        popperCanvas.width = window.innerWidth;
        popperCanvas.height = window.innerHeight;
    }
    window.addEventListener('resize', resizePopperCanvas);
    resizePopperCanvas();

    class PopperParticle {
        constructor(x, y) {
            this.x = x;
            this.y = y;
            const angle = Math.random() * 2 * Math.PI;
            const speed = 3 + Math.random() * 8;
            this.vx = Math.cos(angle) * speed;
            this.vy = Math.sin(angle) * speed - 2;
            this.size = 6 + Math.random() * 10;
            this.color = `hsl(${Math.random() * 360}, 80%, 60%)`;
            this.life = 1;
            this.decay = 0.008 + Math.random() * 0.015;
            this.gravity = 0.15 + Math.random() * 0.10;
            this.rotation = Math.random() * 360;
            this.rotSpeed = (Math.random() - 0.5) * 10;
            this.shape = Math.random() > 0.5 ? 'circle' : 'rect';
            this.squish = 0.8 + Math.random() * 0.4;
        }
        update() {
            this.vx *= 0.99;
            this.vy += this.gravity;
            this.x += this.vx;
            this.y += this.vy;
            this.life -= this.decay;
            this.rotation += this.rotSpeed;
            this.size *= 0.998;
        }
        draw(ctx) {
            ctx.save();
            ctx.translate(this.x, this.y);
            ctx.rotate((this.rotation * Math.PI) / 180);
            ctx.globalAlpha = Math.max(0, this.life);
            ctx.fillStyle = this.color;
            if (this.shape === 'circle') {
                ctx.beginPath();
                ctx.arc(0, 0, Math.max(1, this.size * this.squish * 0.6), 0, Math.PI * 2);
                ctx.fill();
            } else {
                const w = Math.max(2, this.size * this.squish * 0.8);
                const h = Math.max(2, this.size * 0.6);
                ctx.fillRect(-w / 2, -h / 2, w, h);
            }
            ctx.restore();
        }
        get alive() { return this.life > 0 && this.size > 1; }
    }

    function triggerPopper(burstCount = 120) {
        if (popperRunning) {} else {
            popperCanvas.classList.add('active');
            popperRunning = true;
        }
        const cx = window.innerWidth / 2;
        const cy = window.innerHeight / 2;
        for (let i = 0; i < burstCount; i++) {
            const x = cx + (Math.random() - 0.5) * 40;
            const y = cy + (Math.random() - 0.5) * 40;
            popperParticles.push(new PopperParticle(x, y));
        }
        if (!popperAnimId) {
            animatePopper();
        }
    }

    function animatePopper() {
        ctxP.clearRect(0, 0, popperCanvas.width, popperCanvas.height);
        for (let i = popperParticles.length - 1; i >= 0; i--) {
            const p = popperParticles[i];
            p.update();
            p.draw(ctxP);
            if (!p.alive) {
                popperParticles.splice(i, 1);
            }
        }
        if (popperParticles.length > 0) {
            popperAnimId = requestAnimationFrame(animatePopper);
        } else {
            popperAnimId = null;
            popperRunning = false;
            popperCanvas.classList.remove('active');
            ctxP.clearRect(0, 0, popperCanvas.width, popperCanvas.height);
        }
    }

    //  LANGUAGE MANAGEMENT
    function updateAllLanguage() {
        const lang = state.lang;
        const ui = UI_STRINGS[lang];

        document.querySelectorAll('#langLabel, #langLabelResult').forEach(el => {
            el.textContent = lang === 'en' ? 'EN' : 'नेपाली';
        });

        document.querySelectorAll('[data-en][data-ne]').forEach(el => {
            const val = lang === 'en' ? el.dataset.en : el.dataset.ne;
            if (val !== undefined) el.textContent = val;
        });

        const g = $('homeGreeting');
        if (g) g.textContent = ui.greeting;
        const sg = $('homeSubGreeting');
        if (sg) sg.textContent = ui.subGreeting;
        const st = $('subjectTitle');
        if (st) {
            const sub = $('subjectSub');
            st.innerHTML = ui.subjectTitle + ' <span style="font-size:0.9rem;font-weight:400;color:#7a5f4a;" id="subjectSub">' +
                ui.subjectSub + '</span>';
        }
        const lt = $('levelTitle');
        if (lt) lt.textContent = ui.levelTitle;

        if (startBtn) {
            if (state.subject === 'flashcards') {
                startBtn.textContent = ui.startFlashcards;
            } else {
                startBtn.textContent = ui.startBtn;
            }
        }

        updateLevelBadge();

        const progLabel = $('progressLabel');
        if (progLabel) {
            const pct = $('progressFill') ? $('progressFill').style.width || '0%' : '0%';
            progLabel.textContent = pct + ui.progressLabel;
        }
        const qCounter = $('qCounter');
        if (qCounter && state.questions.length > 0) {
            const idx = state.currentIndex + 1;
            const total = state.questions.length;
            qCounter.textContent = 'Q' + idx + ' / ' + total;
        }
        const puzzleInd = $('puzzleIndicator');
        if (puzzleInd) {
            const isPuzzle = state.questions.length > 0 && state.questions[state.currentIndex] &&
                state.questions[state.currentIndex].type === 'puzzle';
            puzzleInd.textContent = isPuzzle ? ui.puzzleLabel : ui.questionLabel;
        }

        const backLabel = $('backLabel');
        if (backLabel) backLabel.textContent = ui.back;
        const nextLabel = $('nextLabel');
        if (nextLabel) {
            const total = state.questions.length;
            if (state.currentIndex === total - 1 && total > 0) {
                nextLabel.textContent = ui.finish;
            } else {
                nextLabel.textContent = ui.next;
            }
        }
        const checkBtn = $('checkPuzzleBtn');
        if (checkBtn) checkBtn.textContent = ui.checkOrder;

        const fbMsg = $('feedbackMsg');
        if (fbMsg && !state.answered && !state.puzzleSolved) {
            fbMsg.textContent = ui.feedbackThink;
        }

        const rTitle = $('resultTitle');
        if (rTitle) rTitle.textContent = ui.resultTitle;
        const rMsg = $('resultMessage');
        if (rMsg) {
            const total = state.questions.length || 1;
            const stars = state.gameStars || 0;
            let msg = ui.resultMsgMid;
            if (stars < total * 0.5) msg = ui.resultMsgMid;
            else if (stars < total * 0.8) msg = ui.resultMsgHigh;
            else msg = ui.resultMsgTop;
            if (stars === total && total > 0) msg = ui.resultMsgStar;
            rMsg.textContent = msg;
        }
        const playAgain = $('playAgainBtn');
        if (playAgain) playAgain.textContent = ui.playAgain;

        const fcScreen = $('flashcardScreen');
        if (fcScreen && fcScreen.style.display !== 'none' && state.fcDeck.length > 0) {
            renderFlashcard();
        }

        if (popupModal.classList.contains('active')) {
            const popupTextEl = $('popupText');
            if (popupTextEl) popupTextEl.textContent = ui.popupCongrats;
            const btns = popupBtnContainer.querySelectorAll('.popup-btn');
            if (btns.length >= 2) {
                btns[0].textContent = ui.popupPlayAgain;
                btns[1].textContent = ui.popupHome;
            }
        }

        if (document.getElementById('tutorialModal').classList.contains('active')) {
            renderTutorial(state.lang);
        }
    }

    function setupLangToggle() {
        const toggle1 = $('langToggle');
        const toggle2 = $('langToggleResult');
        const toggles = [toggle1, toggle2].filter(Boolean);
        toggles.forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                state.lang = state.lang === 'en' ? 'ne' : 'en';
                updateAllLanguage();
                playClickSound();
            });
        });
    }

    //  render the home screen with subjects and levels
    async function renderHome() {
        const subjects = await loadSubjects();
        const grid = document.getElementById('subjectGrid');
        grid.innerHTML = '';
        subjects.forEach(sub => {
            const card = document.createElement('div');
            card.className = 'subject-card';
            card.dataset.subjectId = sub.subject_id;
            card.innerHTML = `
                <div class="subject-icon">${sub.icon}</div>
                <div class="subject-name" data-en="${sub.name_en}" data-ne="${sub.name_ne}">${sub.name_en}</div>
                <div class="subject-desc" data-en="${sub.description_en}" data-ne="${sub.description_ne}">${sub.description_en}</div>
                <div class="tap-hint" data-en="Tap to select" data-ne="छान्नको लागि ट्याप गर्नुहोस्">Tap to select</div>
            `;
            card.addEventListener('click', () => selectSubject(sub.subject_id, sub));
            grid.appendChild(card);
        });
        document.getElementById('levelGrid').innerHTML = '';
        window.selectedSubject = null;
        window.selectedLevelId = null;
        startBtn.disabled = true;
        updateAllLanguage();
    }

    function selectSubject(subjectId, subjectData) {
        document.querySelectorAll('.subject-card').forEach(s => s.classList.remove('selected'));
        const card = document.querySelector(`.subject-card[data-subject-id="${subjectId}"]`);
        if (card) card.classList.add('selected');
        window.selectedSubject = subjectData;
        window.selectedLevelId = null;

        loadLevels(subjectId).then(levels => {
            const levelGrid = document.getElementById('levelGrid');
            levelGrid.innerHTML = '';
            levels.forEach(level => {
                const item = document.createElement('div');
                item.className = 'level-item';
                item.dataset.levelId = level.level_id;
                item.innerHTML = `
                    <div class="level-label" data-en="${level.level_name_en}" data-ne="${level.level_name_ne}">${level.icon} ${level.level_name_en}</div>
                    <div class="level-desc" style="font-size:0.85rem;color:#7a5f4a;" data-en="${level.description_en}" data-ne="${level.description_ne}">${level.description_en}</div>
                    <div class="level-check" data-en="Tap to select" data-ne="छान्नको लागि ट्याप गर्नुहोस्">Tap to select</div>
                `;
                item.addEventListener('click', () => selectLevel(level.level_id, level));
                levelGrid.appendChild(item);
            });
            updateAllLanguage();
        });

        const ui = UI_STRINGS[state.lang];
        startBtn.disabled = true;
        startBtn.textContent = ui.startBtn;
        playClickSound();
    }

    function selectLevel(levelId, levelData) {
        document.querySelectorAll('.level-item').forEach(l => l.classList.remove('selected'));
        const item = document.querySelector(`.level-item[data-level-id="${levelId}"]`);
        if (item) item.classList.add('selected');
        window.selectedLevelId = levelId;
        window.selectedLevelData = levelData;
        startBtn.disabled = false;
        const ui = UI_STRINGS[state.lang];
        if (window.selectedSubject && window.selectedSubject.subject_id === 4) {
            startBtn.textContent = ui.startFlashcards;
        } else {
            startBtn.textContent = ui.startBtn;
        }
        playClickSound();
    }

        //  START BUTTON
    startBtn.addEventListener('click', async function() {
        if (!window.selectedLevelId) return;
        playClickSound();
        const subjectId = window.selectedSubject ? window.selectedSubject.subject_id : null;
        const levelId = window.selectedLevelId;

        if (subjectId === 4) {
            const cards = await loadFlashcards(levelId);
            if (cards.length) {
                state.fcLevelData = {
                    icon: window.selectedLevelData.icon || '🃏',
                    label: window.selectedLevelData.level_name_en || 'Flashcards'
                };
                startFlashcards(cards);
            } else {
                showToast('No flashcards found.', false);
            }
        } else {
            const questions = await loadQuestions(levelId);
            if (questions.length) {
                startQuiz(questions, levelId);
            } else {
                showToast('No questions found.', false);
            }
        }
    });

    //  QUIZ FUNCTIONS
    function startQuiz(questions, levelId) {
        state.questions = questions;
        state.level = levelId;
        state.currentIndex = 0;
        state.gameStars = 0;
        state.gameCoins = 0;
        state.correctCount = 0;
        state.answeredCount = 0;
        state.questionRewarded = false;
        state.questions.forEach(q => {
            if (q.type === 'mcq') {
                const opts = q.options;
                const correctLabel = opts[q.correct].label;
                const shuffled = shuffleArray([...opts]);
                const newCorrect = shuffled.findIndex(o => o.label === correctLabel);
                q.options = shuffled;
                q.correct = newCorrect;
            }
        });
        homeScreen.style.display = 'none';
        flashcardScreen.style.display = 'none';
        flashcardScreen.classList.remove('active');
        gameScreen.classList.add('active');
        resultScreen.classList.remove('active');
        updateLevelBadge();
        updateScoreUI();
        renderQuestion();
    }

    function shuffleArray(arr) {
        for (let i = arr.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [arr[i], arr[j]] = [arr[j], arr[i]];
        }
        return arr;
    }

    function renderQuestion() {
        const qs = state.questions;
        if (!qs || state.currentIndex >= qs.length) {
            showFinish();
            return;
        }
        const q = qs[state.currentIndex];
        const idx = state.currentIndex;
        const total = qs.length;
        const progress = state.questions.length > 0 ? Math.round((state.answeredCount / state.questions
        .length) * 100) : 0;
        const ui = UI_STRINGS[state.lang];
        $('progressFill').style.width = progress + '%';
        $('progressLabel').textContent = progress + '% ' + ui.progressLabel;
        $('qCounter').textContent = 'Q' + (idx + 1) + ' / ' + total;
        $('qText').textContent = getQuestionText(q, 'question');
        state.answered = false;
        state.selectedOption = null;
        state.questionRewarded = false;
        state.puzzleSolved = false;
        state.isTransitioning = false;
        $('feedbackMsg').textContent = ui.feedbackThink;
        $('funFact').classList.remove('show');
        $('funFact').textContent = '';
        if (q.type === 'puzzle') {
            $('optionsContainer').style.display = 'none';
            $('puzzleContainer').style.display = 'block';
            $('puzzleIndicator').textContent = ui.puzzleLabel;
            renderPuzzle(q);
            $('nextBtn').style.display = 'none';
            $('finishBtn').style.display = 'none';
            $('checkPuzzleBtn').style.display = 'inline-block';
            $('backBtn').disabled = (idx === 0);
        } else {
            $('optionsContainer').style.display = 'grid';
            $('puzzleContainer').style.display = 'none';
            $('puzzleIndicator').textContent = ui.questionLabel;
            renderMCQ(q);
            $('nextBtn').style.display = 'inline-flex';
            $('finishBtn').style.display = 'none';
            $('checkPuzzleBtn').style.display = 'none';
            $('backBtn').disabled = (idx === 0);
            $('nextBtn').disabled = true;
        }
        const nextLabel = $('nextLabel');
        if (nextLabel) {
            nextLabel.textContent = (idx === total - 1) ? ui.finish : ui.next;
        }
        $('backBtn').disabled = (idx === 0);
        document.querySelector('.game-container').scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
    }

    function getQuestionText(q, field) {
        const lang = state.lang;
        if (lang === 'en') return q[field] || '';
        return q[field + '_ne'] || q[field] || '';
    }

    function getOptionLabel(opt) {
        const lang = state.lang;
        if (lang === 'en') return opt.label;
        return opt.label_ne || opt.label;
    }

    function getItemLabel(item) {
        const lang = state.lang;
        if (lang === 'en') return item.label;
        return item.label_ne || item.label;
    }

    function renderMCQ(q) {
        $('optionsContainer').innerHTML = '';
        const optLabels = ['A', 'B', 'C', 'D'];
        q.options.forEach((opt, i) => {
            const card = document.createElement('div');
            card.className = 'option-card';
            card.dataset.index = i;
            const cartoon = document.createElement('div');
            cartoon.className = 'cartoon-box';
            cartoon.textContent = opt.emoji || '🔹';
            const label = document.createElement('span');
            label.className = 'opt-label';
            label.textContent = optLabels[i] + '. ' + getOptionLabel(opt);
            card.appendChild(cartoon);
            card.appendChild(label);
            card.addEventListener('click', () => handleMCQClick(i, q));
            $('optionsContainer').appendChild(card);
        });
        state.selectedOption = null;
        state.answered = false;
        $('nextBtn').disabled = true;
    }

    function handleMCQClick(index, q) {
        if (state.answered || state.isTransitioning) return;
        const cards = $('optionsContainer').querySelectorAll('.option-card');
        cards.forEach(c => c.classList.remove('selected', 'correct-reveal', 'wrong-reveal'));
        cards[index].classList.add('selected');
        state.selectedOption = index;
        const correct = q.correct;
        cards.forEach((c, i) => {
            if (i === correct) c.classList.add('correct-reveal');
            else if (i === index && i !== correct) c.classList.add('wrong-reveal');
            c.classList.add('disabled');
        });
        state.answered = true;
        $('nextBtn').disabled = false;
        state.answeredCount++;
        const ui = UI_STRINGS[state.lang];

        const isCorrect = (index === correct);
        if (isCorrect) {
            state.correctCount++;
            if (!state.questionRewarded) {
                state.gameStars += 1;
                state.gameCoins += 2;
                state.stars += 1;
                state.coins += 2;
                state.questionRewarded = true;
                updateScoreUI();
                saveQuestionProgress(q.question_id, true, 1, 2);
            }
            $('feedbackMsg').innerHTML = ui.feedbackCorrect;
            if (q.funFact) {
                $('funFact').textContent = '💡 ' + (state.lang === 'en' ? 'Fun fact: ' : 'रोचक तथ्य: ') +
                    getQuestionText(q, 'funFact');
                $('funFact').classList.add('show');
            } else {
                $('funFact').classList.remove('show');
            }
            playCorrectSound();
            showToast('✅ Correct! Keep up the great work!', true);
        } else {
            $('feedbackMsg').innerHTML = ui.feedbackWrong + getOptionLabel(q.options[correct]);
            $('funFact').classList.remove('show');
            playWrongSound();
            showToast('❌ Try again next time!', false);
            saveQuestionProgress(q.question_id, false, 0, 0);
        }
        const progress = state.questions.length > 0 ? Math.round((state.answeredCount / state.questions
        .length) * 100) : 0;
        $('progressFill').style.width = progress + '%';
        $('progressLabel').textContent = progress + '% ' + ui.progressLabel;
        if (state.currentIndex === state.questions.length - 1) {
            const nextLabel = $('nextLabel');
            if (nextLabel) nextLabel.textContent = ui.finish;
        }
    }

    function renderPuzzle(q) {
        const hintText = getQuestionText(q, 'hint');
        $('puzzleHint').textContent = hintText || (state.lang === 'en' ?
            '✨ Drag the items into the correct order!' :
            '✨ वस्तुहरूलाई सही क्रममा मिलाउनुहोस्!');
        const shuffled = shuffleArray([...q.items]);
        state.puzzleOrder = shuffled.map(item => item.id);
        renderPuzzleItems(q);
        $('checkPuzzleBtn').style.display = 'inline-block';
        $('checkPuzzleBtn').disabled = false;
        state.puzzleSolved = false;
        const ui = UI_STRINGS[state.lang];
        $('feedbackMsg').textContent = ui.feedbackPuzzleHint;
        $('funFact').classList.remove('show');
        $('checkPuzzleBtn').textContent = ui.checkOrder;
    }

    function renderPuzzleItems(q) {
        $('puzzleItems').innerHTML = '';
        const order = state.puzzleOrder;
        const itemsMap = {};
        q.items.forEach(item => { itemsMap[item.id] = item; });
        order.forEach(id => {
            const item = itemsMap[id];
            const div = document.createElement('div');
            div.className = 'puzzle-item';
            div.dataset.id = id;
            div.draggable = true;
            const emojiSpan = document.createElement('span');
            emojiSpan.className = 'puzzle-emoji';
            emojiSpan.textContent = item.emoji || '📦';
            const labelSpan = document.createElement('span');
            labelSpan.textContent = getItemLabel(item);
            div.appendChild(emojiSpan);
            div.appendChild(labelSpan);
            div.addEventListener('dragstart', handleDragStart);
            div.addEventListener('dragend', handleDragEnd);
            div.addEventListener('dragover', handleDragOver);
            div.addEventListener('dragenter', handleDragEnter);
            div.addEventListener('dragleave', handleDragLeave);
            div.addEventListener('drop', handleDrop);
            $('puzzleItems').appendChild(div);
        });
    }

    let dragSrcId = null;

    function handleDragStart(e) {
        const el = e.target.closest('.puzzle-item');
        if (!el) return;
        dragSrcId = el.dataset.id;
        el.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/plain', dragSrcId);
    }

    function handleDragEnd(e) {
        const el = e.target.closest('.puzzle-item');
        if (el) el.classList.remove('dragging');
        document.querySelectorAll('.puzzle-item.droppable').forEach(el => el.classList.remove('droppable'));
    }

    function handleDragOver(e) {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
    }

    function handleDragEnter(e) {
        e.preventDefault();
        const el = e.target.closest('.puzzle-item');
        if (el && el.dataset.id !== dragSrcId) {
            el.classList.add('droppable');
        }
    }

    function handleDragLeave(e) {
        const el = e.target.closest('.puzzle-item');
        if (el) el.classList.remove('droppable');
    }

    function handleDrop(e) {
        e.preventDefault();
        const target = e.target.closest('.puzzle-item');
        if (!target) return;
        const targetId = target.dataset.id;
        if (targetId === dragSrcId) return;
        const q = state.questions[state.currentIndex];
        if (!q || q.type !== 'puzzle') return;
        const order = state.puzzleOrder;
        const srcIdx = order.indexOf(dragSrcId);
        const tgtIdx = order.indexOf(targetId);
        if (srcIdx === -1 || tgtIdx === -1) return;
        [order[srcIdx], order[tgtIdx]] = [order[tgtIdx], order[srcIdx]];
        state.puzzleOrder = order;
        renderPuzzleItems(q);
        state.puzzleSolved = false;
        $('checkPuzzleBtn').disabled = false;
        document.querySelectorAll('.puzzle-item.droppable').forEach(el => el.classList.remove('droppable'));
        const ui = UI_STRINGS[state.lang];
        $('feedbackMsg').textContent = ui.feedbackPuzzleHint;
        $('funFact').classList.remove('show');
    }

    $('checkPuzzleBtn').addEventListener('click', function() {
        if (state.isTransitioning) return;
        const q = state.questions[state.currentIndex];
        if (!q || q.type !== 'puzzle') return;
        const order = state.puzzleOrder;
        const correct = q.correctOrder;
        const isCorrect = order.length === correct.length && order.every((id, i) => id === correct[i]);
        const ui = UI_STRINGS[state.lang];
        if (isCorrect) {
            if (!state.questionRewarded) {
                state.gameStars += 1;
                state.gameCoins += 3;
                state.stars += 1;
                state.coins += 3;
                state.questionRewarded = true;
                updateScoreUI();
                saveQuestionProgress(q.question_id, true, 1, 3);
            }
            state.puzzleSolved = true;
            $('checkPuzzleBtn').disabled = true;
            document.querySelectorAll('.puzzle-item').forEach(el => el.classList.add('placed'));
            $('nextBtn').disabled = false;
            $('nextBtn').style.display = 'inline-flex';
            state.answeredCount++;
            const progress = state.questions.length > 0 ? Math.round((state.answeredCount / state.questions
                .length) * 100) : 0;
            $('progressFill').style.width = progress + '%';
            $('progressLabel').textContent = progress + '% ' + ui.progressLabel;
            $('feedbackMsg').innerHTML = ui.feedbackPuzzleSolved;
            if (q.funFact) {
                $('funFact').textContent = '💡 ' + (state.lang === 'en' ? 'Fun fact: ' : 'रोचक तथ्य: ') +
                    getQuestionText(q, 'funFact');
                $('funFact').classList.add('show');
            }
            const nextLabel = $('nextLabel');
            if (nextLabel) {
                nextLabel.textContent = (state.currentIndex === state.questions.length - 1) ? ui.finish : ui
                .next;
            }
            playCorrectSound();
            showToast('✅ Puzzle solved! Great job!', true);
        } else {
            $('feedbackMsg').textContent = ui.feedbackPuzzleWrong;
            $('funFact').classList.remove('show');
            playWrongSound();
            showToast('❌ Not quite right! Try again.', false);
            saveQuestionProgress(q.question_id, false, 0, 0);
        }
    });

    $('backBtn').addEventListener('click', function() {
        if (state.currentIndex > 0) {
            state.currentIndex--;
            renderQuestion();
        }
        playClickSound();
    });

    $('nextBtn').addEventListener('click', function() {
        if (state.isTransitioning) return;
        const q = state.questions[state.currentIndex];
        if (q && q.type === 'puzzle' && !state.puzzleSolved) {
            return;
        }
        if (q && q.type === 'mcq' && !state.answered) {
            return;
        }
        if (state.currentIndex < state.questions.length - 1) {
            state.currentIndex++;
            renderQuestion();
        } else {
            showFinish();
        }
        playClickSound();
    });

    function showFinish() {
        gameScreen.classList.remove('active');
        resultScreen.classList.add('active');
        $('resultStars').textContent = state.gameStars;
        $('resultCoins').textContent = state.gameCoins;
        const total = state.questions.length;
        const ui = UI_STRINGS[state.lang];
        let msg;
        if (state.gameStars < total * 0.5) msg = ui.resultMsgMid;
        else if (state.gameStars < total * 0.8) msg = ui.resultMsgHigh;
        else msg = ui.resultMsgTop;
        if (state.gameStars === total && total > 0) msg = ui.resultMsgStar;
        $('resultMessage').textContent = msg;
        $('resultTitle').textContent = ui.resultTitle;
        playCelebrationSound();
        triggerPopper(280);
        setTimeout(() => {
            triggerPopper(150);
        }, 500);
        const rStar = $('resultStarCount');
        if (rStar) rStar.textContent = state.stars;
        const rCoin = $('resultCoinCount');
        if (rCoin) rCoin.textContent = state.coins;
        updateLevelBadge();
        const rLangLabel = $('langLabelResult');
        if (rLangLabel) rLangLabel.textContent = state.lang === 'en' ? 'EN' : 'नेपाली';
    }

    $('playAgainBtn').addEventListener('click', function() {
        resultScreen.classList.remove('active');
        state.subject = null;
        state.level = null;
        document.querySelectorAll('.subject-card').forEach(s => s.classList.remove('selected'));
        document.querySelectorAll('.level-item').forEach(l => l.classList.remove('selected'));
        startBtn.disabled = true;
        updateLevelBadge();
        updateScoreUI();
        showHome();
        playClickSound();
        updateAllLanguage();
    });

    $('homeTitle').addEventListener('click', function() {
        resultScreen.classList.remove('active');
        state.subject = null;
        state.level = null;
        document.querySelectorAll('.subject-card').forEach(s => s.classList.remove('selected'));
        document.querySelectorAll('.level-item').forEach(l => l.classList.remove('selected'));
        startBtn.disabled = true;
        updateLevelBadge();
        updateScoreUI();
        showHome();
        playClickSound();
        updateAllLanguage();
    });

    //  FLASHCARdS FUNCTIONS
    function startFlashcards(cards) {
        state.fcDeck = cards;
        state.fcCurrentIndex = 0;
        state.fcFlipped = false;
        state.fcStarsEarned = 0;
        state.fcCoinsEarned = 0;
        state.gameStars = 0;
        state.gameCoins = 0;
        homeScreen.style.display = 'none';
        gameScreen.classList.remove('active');
        flashcardScreen.classList.add('active');
        flashcardScreen.style.display = 'block';
        resultScreen.classList.remove('active');
        updateLevelBadge();
        renderFlashcard();
    }

    function renderFlashcard() {
        const level = state.fcLevelData || { icon: '🃏', label: 'Flashcards' };
        const card = state.fcDeck[state.fcCurrentIndex];
        const total = state.fcDeck.length;
        const current = state.fcCurrentIndex + 1;
        const ui = UI_STRINGS[state.lang];

        const facts = state.lang === 'en' ? card.facts : card.facts_ne;
        const tag = state.lang === 'en' ? card.tag : card.tag_ne;

        flashcardScreen.innerHTML = `
            <div class="text-center" style="margin-bottom:20px;">
                <h2 style="font-size:2rem;color:#5a3e2b;">${level.icon} ${level.label} ${ui.flashcardTitle}</h2>
                <p style="color:#7a5f4a;">${ui.flashcardCard} ${current} ${ui.flashcardOf} ${total}</p>
            </div>
            <div class="flashcard-deck" id="fcCardContainer">
                <div class="flashcard ${state.fcFlipped ? 'flipped' : ''}" id="fcCard">
                    <div class="flashcard-face flashcard-front">
                        <div class="fc-icon">${card.icon}</div>
                        <div class="fc-title">${card.name}</div>
                        <div class="fc-subtitle">${card.subtitle}</div>
                        <div class="fc-tag">${tag}</div>
                    </div>
                    <div class="flashcard-face flashcard-back">
                        <div class="fc-title">${card.name}</div>
                        <ul class="fc-facts">${facts.map(f => `<li>${f}</li>`).join('')}</ul>
                        <div class="fc-tag">${tag}</div>
                    </div>
                </div>
            </div>
            <div class="flashcard-controls">
                <button id="prevFcBtn">${ui.flashcardPrev}</button>
                <button id="flipFcBtn">${ui.flashcardFlip}</button>
                <button id="shuffleFcBtn">${ui.flashcardShuffle}</button>
                <button id="nextFcBtn">${ui.flashcardNext}</button>
            </div>
            <div class="flashcard-progress">${current} / ${total}</div>
            <div class="text-center" style="margin-top:20px;">
                <button class="flashcard-back-btn" id="backToHomeBtn">${ui.flashcardBack}</button>
            </div>
        `;

        $('fcCard').addEventListener('click', toggleFlashcardFlip);
        $('prevFcBtn').addEventListener('click', prevFlashcard);
        $('nextFcBtn').addEventListener('click', nextFlashcard);
        $('flipFcBtn').addEventListener('click', toggleFlashcardFlip);
        $('shuffleFcBtn').addEventListener('click', shuffleFlashcards);
        $('backToHomeBtn').addEventListener('click', backToHomeFromFlashcards);
    }

    function toggleFlashcardFlip() {
        state.fcFlipped = !state.fcFlipped;
        const cardEl = $('fcCard');
        if (cardEl) {
            if (state.fcFlipped) {
                cardEl.classList.add('flipped');
                playFlipSound();
            } else {
                cardEl.classList.remove('flipped');
            }
        }
    }

    function prevFlashcard() {
        if (state.fcCurrentIndex > 0) {
            state.fcCurrentIndex--;
            state.fcFlipped = false;
            renderFlashcard();
        }
        playClickSound();
    }

    function shuffleFlashcards() {
        for (let i = state.fcDeck.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [state.fcDeck[i], state.fcDeck[j]] = [state.fcDeck[j], state.fcDeck[i]];
        }
        state.fcCurrentIndex = 0;
        state.fcFlipped = false;
        renderFlashcard();
        playClickSound();
    }

    function nextFlashcard() {
        const ui = UI_STRINGS[state.lang];
        const card = state.fcDeck[state.fcCurrentIndex];
        if (state.fcFlipped) {
            state.gameStars += 1;
            state.fcStarsEarned += 1;
            state.stars += 1;
            updateScoreUI();
            saveFlashcardProgress(card.id, 1);
            playSparkleSound();
            triggerPopper(80);
        }
        if (state.fcCurrentIndex === state.fcDeck.length - 1) {
            state.gameCoins += 3;
            state.fcCoinsEarned = 3;
            state.coins += 3;
            updateScoreUI();
            playCelebrationSound();
            triggerPopper(200);

            showFlashcardPopup(
                '🎉',
                ui.popupCongrats,
                '⭐ ' + state.fcStarsEarned + '  |  💰 ' + state.fcCoinsEarned,
                function() {
                    state.fcCurrentIndex = 0;
                    state.fcFlipped = false;
                    state.fcStarsEarned = 0;
                    state.fcCoinsEarned = 0;
                    state.gameStars = 0;
                    state.gameCoins = 0;
                    renderFlashcard();
                },
                function() {
                    flashcardScreen.innerHTML = '';
                    flashcardScreen.style.display = 'none';
                    flashcardScreen.classList.remove('active');
                    showHome();
                    document.querySelectorAll('.subject-card').forEach(s => s.classList.remove('selected'));
                    document.querySelectorAll('.level-item').forEach(l => l.classList.remove('selected'));
                    startBtn.disabled = true;
                    state.subject = null;
                    state.level = null;
                    state.fcStarsEarned = 0;
                    state.fcCoinsEarned = 0;
                    updateLevelBadge();
                    updateScoreUI();
                    playClickSound();
                    updateAllLanguage();
                }
            );
        } else {
            state.fcCurrentIndex++;
            state.fcFlipped = false;
            renderFlashcard();
        }
        playClickSound();
    }

    function backToHomeFromFlashcards() {
        flashcardScreen.style.display = 'none';
        flashcardScreen.classList.remove('active');
        showHome();
        document.querySelectorAll('.subject-card').forEach(s => s.classList.remove('selected'));
        document.querySelectorAll('.level-item').forEach(l => l.classList.remove('selected'));
        startBtn.disabled = true;
        const ui = UI_STRINGS[state.lang];
        startBtn.textContent = ui.startBtn;
        state.subject = null;
        state.level = null;
        state.fcStarsEarned = 0;
        state.fcCoinsEarned = 0;
        updateLevelBadge();
        updateScoreUI();
        playClickSound();
        updateAllLanguage();
    }

    //  SOUND TOGGLE
    function setupSoundToggle() {
        const toggle1 = $('soundToggle');
        const toggle2 = $('soundToggleResult');
        const toggles = [toggle1, toggle2].filter(Boolean);
        toggles.forEach(btn => {
            btn.addEventListener('click', function() {
                state.soundEnabled = !state.soundEnabled;
                const label = this.querySelector('.label');
                if (label) label.textContent = state.soundEnabled ? 'ON' : 'OFF';
                playClickSound();
            });
        });
    }

    //  RESET SCORES
   function resetScores() {
        state.stars = 0;
        state.coins = 0;
        state.gameStars = 0;
        state.gameCoins = 0;
        state.fcStarsEarned = 0;
        state.fcCoinsEarned = 0;
        updateScoreUI();
        saveScores();
        const rStar = $('resultStarCount');
        if (rStar) rStar.textContent = '0';
        const rCoin = $('resultCoinCount');
        if (rCoin) rCoin.textContent = '0';
        const resultStars = $('resultStars');
        if (resultStars) resultStars.textContent = '0';
        const resultCoins = $('resultCoins');
        if (resultCoins) resultCoins.textContent = '0';
        document.querySelectorAll('.score-item span:last-child').forEach(el => {
            if (el.id && (el.id === 'starCount' || el.id === 'coinCount' ||
                    el.id === 'resultStarCount' || el.id === 'resultCoinCount')) {
                el.textContent = '0';
            }
        });
        const ui = UI_STRINGS[state.lang];
        showToast(ui.resetToast, true);
        playClickSound();
    }

    function setupResetButton() {
        const resetBtn = $('resetBtn');
        const resetBtnResult = $('resetBtnResult');
        const resetModal = $('resetConfirmModal');
        const resetCancel = $('resetCancelBtn');
        const resetConfirm = $('resetConfirmBtn');

        function openResetModal() {
            resetModal.classList.add('active');
            playClickSound();
        }

        function closeResetModal() {
            resetModal.classList.remove('active');
        }

        if (resetBtn) {
            resetBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                openResetModal();
            });
        }
        if (resetBtnResult) {
            resetBtnResult.addEventListener('click', function(e) {
                e.stopPropagation();
                openResetModal();
            });
        }
        if (resetCancel) {
            resetCancel.addEventListener('click', function() {
                closeResetModal();
                playClickSound();
            });
        }
        if (resetConfirm) {
            resetConfirm.addEventListener('click', function() {
                closeResetModal();
                resetScores();
            });
        }
        if (resetModal) {
            resetModal.addEventListener('click', function(e) {
                if (e.target === resetModal) {
                    closeResetModal();
                }
            });
        }
    }

    //  TUTORIAL STEPS
    const TUTORIAL_STEPS = [
        {
            emoji: '👋',
            title_en: 'Welcome to ज्ञान_Setu!',
            title_ne: 'ज्ञान_Setu मा स्वागत छ!',
            desc_en: `<p>🌟 This is your <strong>learning adventure</strong>! You'll explore <strong>Science</strong>, <strong>Nature</strong>, and <strong>Space</strong>.</p>
                      <p>🎯 You'll answer questions, solve puzzles, and flip flashcards – and earn ⭐ stars and 💰 coins along the way!</p>`,
            desc_ne: `<strong>🇳🇵 नेपाली:</strong> यो तपाईंको <strong>सिकाइ यात्रा</strong> हो! तपाईं <strong>विज्ञान</strong>, <strong>प्रकृति</strong> र <strong>अन्तरिक्ष</strong> अन्वेषण गर्नुहुनेछ। तपाईं प्रश्नहरूको जवाफ दिनुहुनेछ, पजलहरू समाधान गर्नुहुनेछ, र फ्ल्यास कार्ड पल्टाउनुहुनेछ – र बाटोमा ⭐ तारा र 💰 सिक्का कमाउनुहुनेछ!`
        },
        {
            emoji: '📚',
            title_en: 'Pick a Subject',
            title_ne: 'विषय छान्नुहोस्',
            desc_en: `<p>👉 On the home screen, tap one of these <strong>four subjects</strong>:</p>
                      <div style="display:flex;flex-wrap:wrap;gap:8px;justify-content:center;margin:6px 0;">
                        <span style="background:#fce5d4;padding:6px 16px;border-radius:40px;">🔬 Science</span>
                        <span style="background:#fce5d4;padding:6px 16px;border-radius:40px;">🌱 Nature</span>
                        <span style="background:#fce5d4;padding:6px 16px;border-radius:40px;">🪐 Solar System</span>
                        <span style="background:#fce5d4;padding:6px 16px;border-radius:40px;">🃏 Flashcards</span>
                      </div>
                      <p>✔️ The one you tap will <strong>glow orange</strong> – that means it's selected!</p>`,
            desc_ne: `<strong>🇳🇵 नेपाली:</strong> होम स्क्रिनमा, यी <strong>चार विषय</strong> मध्ये एउटा छान्नुहोस्। तपाईंले छान्नुभएको विषय <strong>सुन्तला रङ्गमा</strong> चम्किन्छ – त्यसको मतलब यो चयन भयो!`
        },
        {
            emoji: '🎯',
            title_en: 'Choose Your Level',
            title_ne: 'स्तर छान्नुहोस्',
            desc_en: `<p>🌟 Then pick a <strong>level</strong> – Basic, Intermediate, or Advanced.</p>
                      <div style="display:flex;flex-wrap:wrap;gap:8px;justify-content:center;margin:6px 0;">
                        <span style="background:#fce5d4;padding:6px 16px;border-radius:40px;">🌱 Basic</span>
                        <span style="background:#fce5d4;padding:6px 16px;border-radius:40px;">🌟 Intermediate</span>
                        <span style="background:#fce5d4;padding:6px 16px;border-radius:40px;">🚀 Advanced</span>
                      </div>
                      <p>💡 <strong>Harder levels</strong> have trickier questions – but more rewards!</p>`,
            desc_ne: `<strong>🇳🇵 नेपाली:</strong> त्यसपछि <strong>स्तर</strong> छान्नुहोस् – आधारभूत, मध्यवर्ती, वा उन्नत। <strong>गाह्रो स्तर</strong> मा अलि जटिल प्रश्नहरू हुन्छन् – तर धेरै पुरस्कार!`
        },
        {
            emoji: '🚀',
            title_en: 'Start Your Adventure!',
            title_ne: 'यात्रा सुरु गर्नुहोस्!',
            desc_en: `<p>✅ Once you've chosen a <strong>subject</strong> and a <strong>level</strong>, the big orange button lights up.</p>
                      <p style="text-align:center;font-size:1.8rem;margin:4px 0;">🟠 <strong>Start Adventure</strong></p>
                      <p>👉 Tap it to begin the quiz or flashcards!</p>`,
            desc_ne: `<strong>🇳🇵 नेपाली:</strong> तपाईंले <strong>विषय</strong> र <strong>स्तर</strong> छानेपछि, ठूलो सुन्तला बटन उज्यालो हुन्छ। यसमा ट्याप गर्नुहोस् र क्विज वा फ्ल्यास कार्ड सुरु गर्नुहोस्!`
        },
        {
            emoji: '🤔',
            title_en: 'Answering Questions',
            title_ne: 'प्रश्नको जवाफ दिँदै',
            desc_en: `<p>📝 For <strong>multiple-choice</strong>, tap the answer you think is right.</p>
                      <ul style="list-style:none;padding-left:0;">
                        <li>✅ <strong>Correct</strong> → you get <strong>+1 ⭐</strong> and <strong>+2 💰</strong>!</li>
                        <li>❌ <strong>Wrong</strong> → don't worry, you'll see the correct answer and learn.</li>
                      </ul>
                      <p>💡 A <strong>fun fact</strong> pops up after each answer – read it to learn more!</p>`,
            desc_ne: `<strong>🇳🇵 नेपाली:</strong> <strong>बहुविकल्पीय</strong> प्रश्नको लागि, तपाईंलाई सही लाग्ने उत्तर छान्नुहोस्। <strong>सही</strong> → +1 ⭐ र +2 💰 पाउनुहुन्छ। <strong>गलत</strong> → चिन्ता नगर्नुहोस्, सही उत्तर देखाइन्छ र तपाईं सिक्नुहुन्छ। प्रत्येक उत्तरपछि <strong>रोचक तथ्य</strong> देखिन्छ – पढ्नुहोस् र थप सिक्नुहोस्!`
        },
        {
            emoji: '🧩',
            title_en: 'Solving Puzzles',
            title_ne: 'पजल समाधान',
            desc_en: `<p>🧩 Some questions are <strong>puzzles</strong> – you drag items to put them in the right order.</p>
                      <ul style="list-style:none;padding-left:0;">
                        <li>👆 <strong>Drag</strong> an item onto another to swap them.</li>
                        <li>✅ Tap <strong>"Check Order"</strong> to see if you got it right!</li>
                        <li>🎉 Solve a puzzle to earn <strong>+1 ⭐</strong> and <strong>+3 💰</strong> – extra reward!</li>
                      </ul>`,
            desc_ne: `<strong>🇳🇵 नेपाली:</strong> केही प्रश्न <strong>पजल</strong> हुन्छन् – तपाईंले वस्तुहरूलाई सही क्रममा राख्नका लागि तान्नुहुन्छ। एउटा वस्तुलाई अर्कोमा <strong>तान्नुहोस्</strong> र साट्नुहोस्। <strong>"क्रम जाँच गर्नुहोस्"</strong> थिच्नुहोस् र सही छ कि हेर्नुहोस्! पजल समाधान गर्दा +1 ⭐ र +3 💰 कमाउनुहुन्छ।`
        },
        {
            emoji: '🃏',
            title_en: 'Flashcard Mode',
            title_ne: 'फ्ल्यास कार्ड मोड',
            desc_en: `<p>🃏 In <strong>Flashcard mode</strong>, you flip cards with fun facts about Science, Nature, and Space.</p>
                      <ul style="list-style:none;padding-left:0;">
                        <li>👆 <strong>Tap</strong> a card to flip it and read the facts!</li>
                        <li>🔀 Use <strong>"Shuffle"</strong> to mix up the deck.</li>
                        <li>⭐ Flip a card to earn <strong>+1 ⭐</strong> – collect them all!</li>
                        <li>🎉 Finish the whole deck to get a <strong>bonus of 3 💰</strong>!</li>
                      </ul>`,
            desc_ne: `<strong>🇳🇵 नेपाली:</strong> <strong>फ्ल्यास कार्ड मोड</strong> मा, तपाईंले विज्ञान, प्रकृति र अन्तरिक्षका बारेमा रोचक तथ्यहरू भएका कार्डहरू पल्टाउनुहुन्छ। कार्डमा <strong>ट्याप</strong> गर्नुहोस् र तथ्यहरू पढ्नुहोस्! <strong>"मिसाउनुहोस्"</strong> प्रयोग गर्नुहोस् र डेक मिलाउनुहोस्। कार्ड पल्टाउँदा +1 ⭐ कमाउनुहोस् – सबै सङ्कलन गर्नुहोस्! सम्पूर्ण डेक सकाउँदा 3 💰 बोनस पाउनुहुन्छ।`
        },
        {
            emoji: '🏆',
            title_en: 'Scores & Controls',
            title_ne: 'स्कोर र नियन्त्रण',
            desc_en: `<p>⭐ Your <strong>stars</strong> and <strong>coins</strong> are shown at the top of every screen.</p>
                      <ul style="list-style:none;padding-left:0;">
                        <li>🔄 Tap the <strong>Reset</strong> button to clear all scores and start fresh.</li>
                        <li>🌐 Tap the <strong>globe</strong> to switch between English and नेपाली.</li>
                        <li>🔊 Tap the <strong>speaker</strong> to turn sound on/off.</li>
                      </ul>
                      <p>💾 Everything is saved automatically – close and reopen anytime!</p>`,
            desc_ne: `<strong>🇳🇵 नेपाली:</strong> तपाईंको <strong>तारा</strong> र <strong>सिक्का</strong> हरेक स्क्रिनको माथि देखिन्छ। <strong>रिसेट</strong> बटनले सबै स्कोर मेटाउँछ र नयाँ सुरु गर्छ। <strong>ग्लोब</strong> आइकनले अंग्रेजी र नेपालीबीच स्विच गर्छ। <strong>स्पिकर</strong> आइकनले आवाज अन/अफ गर्छ। सबै कुरा आफैं सेभ हुन्छ – जुनसुकै बेला बन्द र फेरि खोल्नुहोस्!`
        }
    ];

    //  Tutorial logic
    let tutorialCurrentStep = 0;
    const tutorialTotalSteps = TUTORIAL_STEPS.length;

    function renderTutorial(lang) {
        const container = document.getElementById('tutorialSlidesContainer');
        if (!container) return;
        container.innerHTML = '';
        TUTORIAL_STEPS.forEach((step, index) => {
            const slide = document.createElement('div');
            slide.className = 'tutorial-slide' + (index === tutorialCurrentStep ? ' active' : '');
            slide.dataset.index = index;
            const title = lang === 'en' ? step.title_en : step.title_ne;
            const desc = lang === 'en' ? step.desc_en : step.desc_ne;
            slide.innerHTML = `
                <div class="tutorial-slide-content">
                    <div class="slide-big-icon">${step.emoji}</div>
                    <div class="slide-title">${title}</div>
                    <div class="slide-desc">${desc}</div>
                </div>
            `;
            container.appendChild(slide);
        });
        updateTutorialDotsAndCounter();
        updateTutorialNavButtons();
    }

    function updateTutorialDotsAndCounter() {
        const dotsContainer = document.getElementById('tutorialStepDots');
        const counter = document.getElementById('tutorialStepCounter');
        if (!dotsContainer) return;
        dotsContainer.innerHTML = '';
        for (let i = 0; i < tutorialTotalSteps; i++) {
            const dot = document.createElement('div');
            dot.className = 'step-dot';
            if (i === tutorialCurrentStep) dot.classList.add('active');
            else if (i < tutorialCurrentStep) dot.classList.add('done');
            dot.textContent = i + 1;
            dot.dataset.index = i;
            dot.addEventListener('click', () => goToTutorialStep(i));
            dotsContainer.appendChild(dot);
        }
        if (counter) {
            counter.textContent = (tutorialCurrentStep + 1) + ' / ' + tutorialTotalSteps;
        }
    }

    function updateTutorialNavButtons() {
        const prevBtn = document.getElementById('tutorialPrevBtn');
        const nextBtn = document.getElementById('tutorialNextBtn');
        const finishBtn = document.getElementById('tutorialFinishBtn');
        if (prevBtn) prevBtn.disabled = tutorialCurrentStep === 0;
        if (nextBtn) {
            if (tutorialCurrentStep === tutorialTotalSteps - 1) {
                nextBtn.style.display = 'none';
                if (finishBtn) finishBtn.style.display = 'inline-flex';
            } else {
                nextBtn.style.display = 'inline-flex';
                if (finishBtn) finishBtn.style.display = 'none';
            }
        }
    }

    function goToTutorialStep(index) {
        if (index < 0 || index >= tutorialTotalSteps) return;
        tutorialCurrentStep = index;
        const slides = document.querySelectorAll('.tutorial-slide');
        slides.forEach((s, i) => {
            s.classList.toggle('active', i === index);
        });
        updateTutorialDotsAndCounter();
        updateTutorialNavButtons();
    }

    function nextTutorialStep() {
        if (tutorialCurrentStep < tutorialTotalSteps - 1) {
            goToTutorialStep(tutorialCurrentStep + 1);
        } else {
            closeTutorial();
        }
    }

    function prevTutorialStep() {
        if (tutorialCurrentStep > 0) {
            goToTutorialStep(tutorialCurrentStep - 1);
        }
    }

    function openTutorial() {
        const modal = document.getElementById('tutorialModal');
        if (!modal) return;
        modal.classList.add('active');
        tutorialCurrentStep = 0;
        renderTutorial(state.lang);

        document.getElementById('tutorialPrevBtn').onclick = prevTutorialStep;
        document.getElementById('tutorialNextBtn').onclick = nextTutorialStep;
        document.getElementById('tutorialFinishBtn').onclick = closeTutorial;
        document.getElementById('tutorialCloseBtn').onclick = closeTutorial;

        modal.onclick = function(e) {
            if (e.target === modal) closeTutorial();
        };

        document.addEventListener('keydown', tutorialKeyHandler);
        playClickSound();
    }

    function closeTutorial() {
        const modal = document.getElementById('tutorialModal');
        if (modal) modal.classList.remove('active');
        document.removeEventListener('keydown', tutorialKeyHandler);
        document.getElementById('tutorialPrevBtn').onclick = null;
        document.getElementById('tutorialNextBtn').onclick = null;
        document.getElementById('tutorialFinishBtn').onclick = null;
        document.getElementById('tutorialCloseBtn').onclick = null;
        modal.onclick = null;
        playClickSound();
    }

    function tutorialKeyHandler(e) {
        if (e.key === 'ArrowRight' || e.key === ' ') {
            e.preventDefault();
            if (tutorialCurrentStep === tutorialTotalSteps - 1) {
                closeTutorial();
            } else {
                nextTutorialStep();
            }
        } else if (e.key === 'ArrowLeft') {
            e.preventDefault();
            prevTutorialStep();
        } else if (e.key === 'Escape') {
            closeTutorial();
        }
    }

    //  initialize the app
    async function init() {
        loadScores();
        showHome();
        flashcardScreen.innerHTML = '';
        updateScoreUI();
        updateLevelBadge();
        setupLangToggle();
        setupSoundToggle();
        setupResetButton();
        await renderHome();
        updateAllLanguage();
        startBtn.disabled = true;

        const tutBtn = document.getElementById('tutorialBtn');
        const tutBtnResult = document.getElementById('tutorialBtnResult');
        if (tutBtn) tutBtn.addEventListener('click', openTutorial);
        if (tutBtnResult) tutBtnResult.addEventListener('click', openTutorial);

        console.log('✅ ज्ञान_Setu ready!');
    }

    //  ffor starting the app after DOM is ready
    if (document.readyState === 'complete') {
        init();
    } else {
        window.addEventListener('load', init);
    }

})();