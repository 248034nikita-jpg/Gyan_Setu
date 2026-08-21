(() => {

    const WIDTH = 960,
        HEIGHT = 540;

    const GRAVITY = 0.7;
    const MOVE_SPEED = 4.5;
    const JUMP_SPEED = 16.0;

    const PLAYER_W = 42,
        PLAYER_H = 52;
    const COIN_SIZE = 34;
    const PORTAL_W = 42,
        PORTAL_H = 70;

    const BG_COLOR = "#f5f7fa";
    const PLATFORM_COLOR = "#282d37";
    const PLAYER_COLOR = "#1e90ff";
    const COIN_COLOR = "#ffbe28";
    const PORTAL_COLOR = "#963cdc";
    const TEXT_COLOR = "#141923";

    const MSG_MS = 1200;
    const FEEDBACK_MS = 1500;
    const COIN_POP_MS = 350;

    const COYOTE_MS = 120;
    const JUMP_BUFFER_MS = 140;
    const JUMP_CUT_MULT = 0.55;

    const CONFETTI_COUNT = 140;
    const MAX_LIVES = 5;
    const QUESTIONS_PER_LEVEL = 3;
    const TOTAL_LEVELS = 9;
    const FALL_OFFSET = 200;

    const FRAME_COUNTS = {
        idle_left: 9,
        idle_right: 9,
        walk_left: 25,
        walk_right: 25,
        jump_left: 25,
        jump_right: 25,
        happy: 9,
        sad: 9
    };


    // ============================================
        // 🎵 AUDIO SYSTEM 
        // ============================================

        let audioCtx = null;

        function ensureAudio() {
            if (!audioCtx) audioCtx = new(window.AudioContext || window.webkitAudioContext)();
            if (audioCtx.state === "suspended") audioCtx.resume().catch(() => {});
        }

        // ✅ LOAD YOUR REAL AUDIO FILES
        const sfx = {
            correct: new Audio('assets/audio/feedback/correct.wav'),
            wrong: new Audio('assets/audio/feedback/wrong.wav'),
            levelComplete: new Audio('assets/audio/level_progression/level_complete.wav'),
            jump: new Audio('assets/audio/gameplay/jump.wav'),
            coin: new Audio('assets/audio/gameplay/coin.wav'),
            button: new Audio('assets/audio/gameplay/button.mp3'),
        };

        // Set volumes (adjust as needed)
        sfx.correct.volume = 0.6;
        sfx.wrong.volume = 0.5;
        sfx.levelComplete.volume = 0.7;
        sfx.jump.volume = 0.4;
        sfx.coin.volume = 0.5;
        sfx.button.volume = 0.3;

        // Safe play function - won't crash if file is missing
        function playSFX(audioElement) {
            try {
                if (audioElement && typeof audioElement.play === 'function') {
                    audioElement.currentTime = 0;
                    audioElement.play().catch(() => {
                        // Silently ignore autoplay blocks or missing files
                    });
                }
            } catch (e) {
                // Ignore errors (silent fallback)
            }
        }

        // Your sound functions
        const soundCorrect = () => { ensureAudio(); playSFX(sfx.correct); };
        const soundWrong = () => { ensureAudio(); playSFX(sfx.wrong); };
        const playLevelComplete = () => { ensureAudio(); playSFX(sfx.levelComplete); };
        const playJump = () => { ensureAudio(); playSFX(sfx.jump); };
        const playCoin = () => { ensureAudio(); playSFX(sfx.coin); };
        const playButton = () => { ensureAudio(); playSFX(sfx.button); };

    // ============================================

    document.addEventListener('DOMContentLoaded', () => {

        const canvas = document.getElementById("game");
        if (!canvas) {
            console.error("Canvas not found! Check your HTML.");
            return;
        }
        const ctx = canvas.getContext("2d");

        function resizeCanvas() {
            const pad = 12;
            const topUI = 60;
            const maxW = Math.max(320, window.innerWidth - pad);
            const maxH = Math.max(260, window.innerHeight - topUI - pad);
            const scale = Math.min(maxW / WIDTH, maxH / HEIGHT);

            canvas.style.width = Math.floor(WIDTH * scale) + "px";
            canvas.style.height = Math.floor(HEIGHT * scale) + "px";

            const dpr = window.devicePixelRatio || 1;
            canvas.width = Math.floor(WIDTH * dpr);
            canvas.height = Math.floor(HEIGHT * dpr);
            ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        }
        window.addEventListener("resize", resizeCanvas, { passive: true });
        resizeCanvas();

        const capySprites = {
            idle_left: new Image(),
            idle_right: new Image(),
            jump_left: new Image(),
            jump_right: new Image(),
            walk_left: new Image(),
            walk_right: new Image(),
            happy: new Image(),
            sad: new Image()
        };

        capySprites.idle_left.src = 'assets/sprites/idle_left.png';
        capySprites.idle_right.src = 'assets/sprites/idle_right.png';
        capySprites.jump_left.src = 'assets/sprites/jump_left.png';
        capySprites.jump_right.src = 'assets/sprites/jump_right.png';
        capySprites.walk_left.src = 'assets/sprites/walk_left.png';
        capySprites.walk_right.src = 'assets/sprites/walk_right.png';
        capySprites.happy.src = 'assets/sprites/happy.png';
        capySprites.sad.src = 'assets/sprites/sad.png';

        let spritesLoaded = false;
        const totalSprites = Object.keys(capySprites).length;
        let loadedSprites = 0;

        for (const [key, img] of Object.entries(capySprites)) {
            img.onload = () => {
                loadedSprites++;
                if (loadedSprites >= totalSprites) {
                    spritesLoaded = true;
                    console.log('All Capybara sprites loaded!');
                }
            };
            img.onerror = () => {
                console.warn('Failed to load: ' + key + '.png');
                loadedSprites++;
                if (loadedSprites >= totalSprites) {
                    spritesLoaded = true;
                }
            };
        }

        const fruitSprite = new Image();
        fruitSprite.src = 'assets/fruits/orange.png';

        const goldenFruitSprite = new Image();
        goldenFruitSprite.src = 'assets/fruits/orange_gold.png';

        const grassTile = new Image();
        grassTile.src = 'assets/Tiles/terrain_grass_block.png';

        const dirtTile = new Image();
        dirtTile.src = 'assets/Tiles/terrain_grass_block_bottom.png';

        const clamp = (v, lo, hi) => Math.max(lo, Math.min(hi, v));
        const rect = (x, y, w, h) => ({ x, y, w, h });

        function intersects(a, b) {
            return a.x < b.x + b.w && a.x + a.w > b.x && a.y < b.y + b.h && a.y + a.h > b.y;
        }

        function wrapLines(ctx, text, maxWidth) {
            const words = text.split(" ");
            const lines = [];
            let cur = "";
            for (const w of words) {
                const test = (cur ? cur + " " : "") + w;
                if (ctx.measureText(test).width <= maxWidth) cur = test;
                else { if (cur) lines.push(cur);
                    cur = w; }
            }
            if (cur) lines.push(cur);
            return lines;
        }

        function roundRect(ctx, x, y, w, h, r) {
            const rr = Math.min(r, w / 2, h / 2);
            ctx.beginPath();
            ctx.moveTo(x + rr, y);
            ctx.arcTo(x + w, y, x + w, y + h, rr);
            ctx.arcTo(x + w, y + h, x, y + h, rr);
            ctx.arcTo(x, y + h, x, y, rr);
            ctx.arcTo(x, y, x + w, y, rr);
            ctx.closePath();
        }

        function coinOnPlatform(p) {
            return rect(
                p.x + Math.floor(p.w / 2) - Math.floor(COIN_SIZE / 2),
                p.y - COIN_SIZE - 2,
                COIN_SIZE, COIN_SIZE
            );
        }

        function goldenFruitOnPlatform(p) {
            const size = COIN_SIZE;
            return rect(
                p.x + Math.floor(p.w / 2) - Math.floor(size / 2),
                p.y - size - 2,
                size, size
            );
        }

        // ============================================
        // ✅ FALLBACK DATA ONLY - NO API CALL
        // ============================================

        function getFallbackData(level) {
            const fallbackFacts = {
                1: [{
                    content_id: 1,
                    fact: "Kathmandu is the capital of Nepal. It is the largest city and the cultural centre.",
                    think_question: "What makes a city a 'capital'?",
                    think_options: ["It is the biggest city", "The government works there", "It has the most temples", "It is the oldest city"],
                    think_correct_index: 1,
                    apply_question: "What is the capital of Nepal?",
                    apply_options: ["Pokhara", "Kathmandu", "Lalitpur", "Biratnagar"],
                    apply_correct_index: 1,
                    explanation: "Kathmandu is the capital because the government offices and royal palace are there."
                }, {
                    content_id: 2,
                    fact: "Durbar Square in Kathmandu is a famous UNESCO World Heritage Site with ancient palaces.",
                    think_question: "Why is Durbar Square important?",
                    think_options: ["It was a market", "It was the royal palace", "It was a farm", "It was a school"],
                    think_correct_index: 1,
                    apply_question: "Which city has Durbar Square?",
                    apply_options: ["Pokhara", "Kathmandu", "Lalitpur", "Biratnagar"],
                    apply_correct_index: 1,
                    explanation: "Durbar Square was the royal palace complex of the Malla kings."
                }, {
                    content_id: 3,
                    fact: "The Pashupatinath Temple is a sacred Hindu temple on the Bagmati River.",
                    think_question: "Why are temples built near rivers?",
                    think_options: ["For easy water", "For spiritual rituals", "For farming", "For fishing"],
                    think_correct_index: 1,
                    apply_question: "Which river flows beside Pashupatinath?",
                    apply_options: ["Bagmati", "Gandaki", "Koshi", "Karnali"],
                    apply_correct_index: 0,
                    explanation: "Rivers are considered sacred and used for purification rituals."
                }],
                2: [{
                    content_id: 4,
                    fact: "The national animal of Nepal is the cow. It is sacred in Hinduism.",
                    think_question: "Why is the cow sacred in Nepal?",
                    think_options: ["It gives milk", "It is a symbol of non-violence", "It is strong", "It is big"],
                    think_correct_index: 1,
                    apply_question: "What is the national animal of Nepal?",
                    apply_options: ["Elephant", "Cow", "Tiger", "Lion"],
                    apply_correct_index: 1,
                    explanation: "The cow is sacred to Hindus and symbolizes life and non-violence."
                }, {
                    content_id: 5,
                    fact: "The national flower of Nepal is the rhododendron (Lali Gurans).",
                    think_question: "Why was rhododendron chosen as the national flower?",
                    think_options: ["It grows everywhere", "It represents the Himalayas", "It smells nice", "It is tall"],
                    think_correct_index: 1,
                    apply_question: "What is Nepal's national flower called in Nepali?",
                    apply_options: ["Lali Gurans", "Sunakhari", "Gulaf", "Chameli"],
                    apply_correct_index: 0,
                    explanation: "The rhododendron blooms in bright red and represents the Himalayan landscape."
                }, {
                    content_id: 6,
                    fact: "Nepal's flag is the only non-rectangular flag in the world.",
                    think_question: "What is unique about Nepal's flag?",
                    think_options: ["It has no colour", "It is non-rectangular", "It has an animal", "It is very small"],
                    think_correct_index: 1,
                    apply_question: "How many triangles does Nepal's flag have?",
                    apply_options: ["1", "2", "3", "4"],
                    apply_correct_index: 1,
                    explanation: "The two triangles represent the Himalayan mountains."
                }],
                3: [{
                    content_id: 7,
                    fact: "Mount Everest is the highest mountain in the world at 8,848 metres.",
                    think_question: "Why is Mount Everest so famous?",
                    think_options: ["It is the tallest mountain", "It is easy to climb", "It has the best views", "It is in Nepal"],
                    think_correct_index: 0,
                    apply_question: "How tall is Mount Everest?",
                    apply_options: ["8,848 metres", "6,000 metres", "12,000 metres", "10,000 metres"],
                    apply_correct_index: 0,
                    explanation: "Mount Everest is the highest peak in the world at 8,848 metres."
                }, {
                    content_id: 8,
                    fact: "Nepal has 8 of the world's 14 highest mountains.",
                    think_question: "Why does Nepal have so many high mountains?",
                    think_options: ["The Himalayan range runs through Nepal", "Because of volcanoes", "Because of earthquakes", "Because of the ocean"],
                    think_correct_index: 0,
                    apply_question: "How many of the world's highest mountains are in Nepal?",
                    apply_options: ["5", "8", "10", "12"],
                    apply_correct_index: 1,
                    explanation: "Nepal is home to 8 of the 14 highest mountains in the world."
                }, {
                    content_id: 9,
                    fact: "Sagarmatha National Park protects Mount Everest and its ecosystem.",
                    think_question: "Why is Sagarmatha National Park protected?",
                    think_options: ["It has unique animals and the highest mountain", "It has the best views", "It has many hotels", "It has the most tourists"],
                    think_correct_index: 0,
                    apply_question: "Which rare animal is found in Sagarmatha National Park?",
                    apply_options: ["Snow leopard", "Elephant", "Tiger", "Lion"],
                    apply_correct_index: 0,
                    explanation: "Sagarmatha National Park protects rare animals like the snow leopard."
                }],
                4: [{
                    content_id: 10,
                    fact: "The Terai region is called the 'granary' of Nepal.",
                    think_question: "Why is the Terai called the granary of Nepal?",
                    think_options: ["It produces lots of rice and crops", "It has many factories", "It has the most people", "It has the most schools"],
                    think_correct_index: 0,
                    apply_question: "Which region is known as the granary of Nepal?",
                    apply_options: ["Terai", "Himalayas", "Hills", "Kathmandu Valley"],
                    apply_correct_index: 0,
                    explanation: "The Terai produces so much rice that it feeds the whole country."
                }, {
                    content_id: 11,
                    fact: "Chitwan National Park protects the one-horned rhinoceros.",
                    think_question: "Why is Chitwan National Park special?",
                    think_options: ["It has rare animals like the one-horned rhino", "It has the most trees", "It has the best weather", "It has the biggest lake"],
                    think_correct_index: 0,
                    apply_question: "Which national park is famous for the one-horned rhinoceros?",
                    apply_options: ["Sagarmatha", "Chitwan", "Bardiya", "Langtang"],
                    apply_correct_index: 1,
                    explanation: "Chitwan National Park protects the rare one-horned rhinoceros."
                }, {
                    content_id: 12,
                    fact: "Nepal has successfully doubled its tiger population.",
                    think_question: "Why are tigers important to the ecosystem?",
                    think_options: ["They are at the top of the food chain", "They are beautiful", "They are friendly", "They are fast"],
                    think_correct_index: 0,
                    apply_question: "Where do Bengal tigers live in Nepal?",
                    apply_options: ["In the Terai forests", "In the mountains", "In the cities", "In the ocean"],
                    apply_correct_index: 0,
                    explanation: "Tigers are top predators and keep the ecosystem balanced."
                }],
                5: [{
                    content_id: 13,
                    fact: "Dashain is Nepal's biggest festival and lasts 15 days.",
                    think_question: "Why is Dashain celebrated with so much fun?",
                    think_options: ["It's a time for family, celebration, and fun activities", "It's a public holiday", "People get gifts", "It's the only holiday"],
                    think_correct_index: 0,
                    apply_question: "How many days does Dashain last?",
                    apply_options: ["10 days", "15 days", "20 days", "25 days"],
                    apply_correct_index: 1,
                    explanation: "Dashain is 15 days of family reunions, delicious food, and fun activities."
                }, {
                    content_id: 14,
                    fact: "During Dashain, elders put tika on younger people's foreheads.",
                    think_question: "Why is receiving tika during Dashain special?",
                    think_options: ["It's a sign of respect and blessings from elders", "It's a fashion trend", "It's a gift", "It's a game"],
                    think_correct_index: 0,
                    apply_question: "What do elders give to younger people during Dashain?",
                    apply_options: ["Tika and jamara", "Money", "New clothes", "Toys"],
                    apply_correct_index: 0,
                    explanation: "Tika is a blessing from elders for good luck and health."
                }, {
                    content_id: 15,
                    fact: "Bijaya Dashami is the most important day of Dashain.",
                    think_question: "Why is Bijaya Dashami called the Day of Victory?",
                    think_options: ["It's the day Durga defeated the demon", "It marks the end of the festival", "It's a public holiday", "It's the day people get gifts"],
                    think_correct_index: 0,
                    apply_question: "What is the most important day of Dashain called?",
                    apply_options: ["Bijaya Dashami", "Ghatasthapana", "Fulpati", "Maha Ashtami"],
                    apply_correct_index: 0,
                    explanation: "Bijaya Dashami is the day Durga defeated the demon."
                }],
                6: [{
                    content_id: 16,
                    fact: "Tihar is the Festival of Lights.",
                    think_question: "Why is Tihar called the Festival of Lights?",
                    think_options: ["People light oil lamps all around their homes", "Because it's a fire festival", "Because of fireworks", "Because it's very bright"],
                    think_correct_index: 0,
                    apply_question: "Which goddess is worshipped during Tihar?",
                    apply_options: ["Lakshmi", "Durga", "Saraswati", "Kali"],
                    apply_correct_index: 0,
                    explanation: "People light oil lamps to welcome the goddess Lakshmi."
                }, {
                    content_id: 17,
                    fact: "Tihar honours animals like crows, dogs, cows, and oxen.",
                    think_question: "Why does Tihar include honouring animals?",
                    think_options: ["They are considered messengers and guardians", "Because animals are useful to humans", "Because they are pets", "Because they are strong"],
                    think_correct_index: 0,
                    apply_question: "Which animal is honoured on the third day of Tihar?",
                    apply_options: ["Cow", "Dog", "Ox", "Crow"],
                    apply_correct_index: 0,
                    explanation: "Animals are honoured for their roles in Hindu mythology."
                }, {
                    content_id: 18,
                    fact: "Bhai Tika is the last day of Tihar, celebrating siblings.",
                    think_question: "Why is Bhai Tika an important celebration?",
                    think_options: ["It celebrates the bond between brothers and sisters", "It's a public holiday", "It involves giving gifts", "It's the only day for family"],
                    think_correct_index: 0,
                    apply_question: "What is the final day of Tihar called?",
                    apply_options: ["Bhai Tika", "Lakshmi Puja", "Kukur Puja", "Gai Puja"],
                    apply_correct_index: 0,
                    explanation: "Bhai Tika celebrates the love between brothers and sisters."
                }],
                7: [{
                    content_id: 19,
                    fact: "Dal Bhat is the staple food of Nepal, eaten twice a day.",
                    think_question: "Why is Dal Bhat eaten so often in Nepal?",
                    think_options: ["It's cheap and filling", "It's the only food available", "It's a national dish for special occasions", "It's the tastiest food"],
                    think_correct_index: 0,
                    apply_question: "What is the staple food of Nepal?",
                    apply_options: ["Dal Bhat", "Momo", "Chowmein", "Noodles"],
                    apply_correct_index: 0,
                    explanation: "Dal Bhat is filling, nutritious, and gives energy for the whole day."
                }, {
                    content_id: 20,
                    fact: "Momo is Nepal's favourite snack, served with spicy achar.",
                    think_question: "Why is Momo so popular in Nepal?",
                    think_options: ["It's delicious and comes in many flavours", "It's easy to cook", "It's only for festivals", "It's very cheap"],
                    think_correct_index: 0,
                    apply_question: "What is the spicy dipping sauce for Momo called?",
                    apply_options: ["Achar", "Chutney", "Salsa", "Ketchup"],
                    apply_correct_index: 0,
                    explanation: "Momo is delicious, versatile, and comes in many flavours."
                }, {
                    content_id: 21,
                    fact: "Sel Roti is a traditional Nepali sweet fried bread.",
                    think_question: "Why is Sel Roti prepared during festivals?",
                    think_options: ["It's a special sweet treat that can be shared", "It's easy to make", "It's the only sweet available", "It's very cheap"],
                    think_correct_index: 0,
                    apply_question: "Which festivals is Sel Roti commonly made for?",
                    apply_options: ["Both Dashain and Tihar", "Dashain only", "Tihar only", "None"],
                    apply_correct_index: 0,
                    explanation: "Sel Roti is a sweet treat shared with family during festivals."
                }],
                8: [{
                    content_id: 22,
                    fact: "The one-horned rhinoceros is found only in Nepal and India.",
                    think_question: "Why is the one-horned rhinoceros so rare?",
                    think_options: ["It only lives in Nepal and India", "It has a long horn", "It is very big", "It is very fast"],
                    think_correct_index: 0,
                    apply_question: "Which national park is famous for the one-horned rhinoceros?",
                    apply_options: ["Chitwan", "Sagarmatha", "Bardiya", "Langtang"],
                    apply_correct_index: 0,
                    explanation: "The one-horned rhino is found only in Nepal and India."
                }, {
                    content_id: 23,
                    fact: "The Bengal tiger is one of the most powerful animals on Earth.",
                    think_question: "Why is Nepal's tiger conservation success important?",
                    think_options: ["Tigers are important for the ecosystem", "Tigers are beautiful", "Tigers are friendly", "Tigers are fast"],
                    think_correct_index: 0,
                    apply_question: "Where do Bengal tigers live in Nepal?",
                    apply_options: ["In the Terai forests", "In the mountains", "In the cities", "In the ocean"],
                    apply_correct_index: 0,
                    explanation: "Tigers are top predators and keep the ecosystem balanced."
                }, {
                    content_id: 24,
                    fact: "The Koshi River is called the lifeline of the Terai.",
                    think_question: "Why is the Koshi River called the lifeline of the Terai?",
                    think_options: ["It provides water for farming and daily life", "It has many fish", "It is a tourist attraction", "It is very long"],
                    think_correct_index: 0,
                    apply_question: "Which river is known as the lifeline of the Terai?",
                    apply_options: ["Koshi", "Gandaki", "Karnali", "Bagmati"],
                    apply_correct_index: 0,
                    explanation: "The Koshi River provides water for millions of people in the Terai."
                }],
                9: [{
                    content_id: 25,
                    fact: "Lumbini is the birthplace of Lord Buddha.",
                    think_question: "Why is Lumbini special to Buddhists worldwide?",
                    think_options: ["It's where Buddha was born", "It's where he died", "It's a tourist attraction", "It's a city"],
                    think_correct_index: 0,
                    apply_question: "Which city is known as the birthplace of Lord Buddha?",
                    apply_options: ["Lumbini", "Kathmandu", "Pokhara", "Biratnagar"],
                    apply_correct_index: 0,
                    explanation: "Lumbini is where Lord Buddha was born over 2,500 years ago."
                }, {
                    content_id: 26,
                    fact: "Nepal has over 120 languages spoken in the country.",
                    think_question: "Why is Nepal called a melting pot of cultures?",
                    think_options: ["It has many ethnic groups and languages", "It has many tourists", "It has many temples", "It has many cities"],
                    think_correct_index: 0,
                    apply_question: "Approximately how many languages are spoken in Nepal?",
                    apply_options: ["120", "30", "200", "300"],
                    apply_correct_index: 0,
                    explanation: "Nepal is incredibly diverse with over 120 languages."
                }, {
                    content_id: 27,
                    fact: "Nepal's temples and palaces are UNESCO World Heritage Sites.",
                    think_question: "Why are Nepal's temples and palaces protected by UNESCO?",
                    think_options: ["They have cultural and historical significance", "They are very beautiful", "They are tourist attractions", "They are very tall"],
                    think_correct_index: 0,
                    apply_question: "How old are some of Nepal's temples?",
                    apply_options: ["More than 1,000 years", "100 years", "500 years", "More than 2,000 years"],
                    apply_correct_index: 0,
                    explanation: "Nepal's temples are incredibly old and culturally significant."
                }]
            };

            return {
                success: true,
                level: level,
                contents: fallbackFacts[level] || fallbackFacts[1],
                score: { coins_earned: 0, oranges_collected: 0, knowledge_mastered: 0, completed: 0 }
            };
        }

        // ============================================
        // ✅ FETCH LEVEL DATA (API WITH LOCAL FALLBACK)
        // ============================================

        async function fetchLevelData(childId, levelNumber) {
            const lang = localStorage.getItem('capybara_lang') || 'en';
            try {
                const response = await fetch(`api/get_capybara_level.php?child_id=${childId}&level=${levelNumber}&lang=${lang}`);
                const data = await response.json();

                if (data && data.success && data.contents && data.contents.length > 0) {
                    console.log('✅ Level data loaded from API:', data);
                    return data;
                } else {
                    console.warn('⚠️ API returned no data or error, using local fallback:', data);
                    return getFallbackData(levelNumber);
                }
            } catch (error) {
                console.warn('⚠️ Network or API unavailable, using local fallback data:', error);
                return getFallbackData(levelNumber);
            }
        }

        const confettiColors = ["#ff5050", "#ffbe28", "#32c878", "#50a0ff", "#be8cff", "#ff78dc"];
        const randChoice = arr => arr[(Math.random() * arr.length) | 0];

        class ConfettiParticle {
            constructor(x, y) {
                this.x = x;
                this.y = y;
                const angle = (Math.random() * Math.PI * 2) - Math.PI;
                const speed = 2.5 + Math.random() * 5.5;
                this.vx = Math.cos(angle) * speed;
                this.vy = Math.sin(angle) * speed - (2.0 + Math.random() * 4.0);
                this.size = 3 + ((Math.random() * 5) | 0);
                this.color = randChoice(confettiColors);
                this.life = 40 + ((Math.random() * 45) | 0);
            }
            update() { this.vy += 0.25;
                this.x += this.vx;
                this.y += this.vy;
                this.life -= 1; }
            draw(ctx) { ctx.fillStyle = this.color;
                ctx.fillRect(this.x | 0, this.y | 0, this.size, this.size); }
        }

        function makeLevel1() {
            const platforms = [
                rect(-200, 500, 1800, 60),
                rect(120, 420, 220, 20),
                rect(420, 360, 240, 20),
                rect(740, 300, 220, 20),
                rect(560, 240, 180, 20),
                rect(300, 190, 200, 20),
                rect(80, 140, 180, 20),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[1]),
                goldenFruitOnPlatform(platforms[3]),
                goldenFruitOnPlatform(platforms[5])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 1, 3, 5].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(40, 60, PORTAL_W, PORTAL_H), spawn: [40, 440], name: "Level 1", required_coins: coins.length + goldenFruits.length };
        }

        function makeLevel2() {
            const platforms = [
                rect(-200, 520, 2000, 60),
                rect(140, 460, 200, 20),
                rect(420, 410, 220, 20),
                rect(700, 360, 240, 20),
                rect(420, 310, 220, 20),
                rect(140, 260, 200, 20),
                rect(420, 210, 220, 20),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[1]),
                goldenFruitOnPlatform(platforms[3]),
                goldenFruitOnPlatform(platforms[5])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 1, 3, 5].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(720, 160, PORTAL_W, PORTAL_H), spawn: [40, 460], name: "Level 2", required_coins: coins.length + goldenFruits.length };
        }

        function makeLevel3() {
            const platforms = [
                rect(-400, 560, 2400, 70),
                rect(80, 500, 420, 22),
                rect(560, 450, 420, 22),
                rect(140, 400, 420, 22),
                rect(620, 350, 420, 22),
                rect(200, 300, 420, 22),
                rect(680, 250, 420, 22),
                rect(260, 200, 420, 22),
                rect(740, 150, 420, 22),
                rect(320, 100, 420, 22),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[2]),
                goldenFruitOnPlatform(platforms[4]),
                goldenFruitOnPlatform(platforms[6])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 2, 4, 6].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(780, 40, PORTAL_W, PORTAL_H), spawn: [40, 500], name: "Level 3", required_coins: coins.length + goldenFruits.length };
        }

        function makeLevel4() {
            const platforms = [
                rect(-300, 560, 2200, 70),
                rect(80, 500, 260, 20),
                rect(400, 420, 260, 20),
                rect(800, 340, 260, 20),
                rect(260, 260, 260, 20),
                rect(600, 180, 260, 20),
                rect(420, 100, 260, 20),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[1]),
                goldenFruitOnPlatform(platforms[3]),
                goldenFruitOnPlatform(platforms[5])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 1, 3, 5].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(480, 40, PORTAL_W, PORTAL_H), spawn: [40, 500], name: "Level 4", required_coins: coins.length + goldenFruits.length };
        }

        function makeLevel5() {
            const platforms = [
                rect(-300, 560, 2200, 70),
                rect(80, 480, 220, 20),
                rect(380, 410, 260, 20),
                rect(740, 340, 220, 20),
                rect(260, 280, 260, 20),
                rect(580, 220, 260, 20),
                rect(400, 150, 260, 20),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[1]),
                goldenFruitOnPlatform(platforms[3]),
                goldenFruitOnPlatform(platforms[5])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 1, 3, 5].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(400, 60, PORTAL_W, PORTAL_H), spawn: [40, 500], name: "Level 5", required_coins: coins.length + goldenFruits.length };
        }

        function makeLevel6() {
            const platforms = [
                rect(-300, 560, 2200, 70),
                rect(100, 490, 200, 20),
                rect(400, 420, 240, 20),
                rect(740, 350, 220, 20),
                rect(280, 280, 240, 20),
                rect(600, 200, 220, 20),
                rect(420, 120, 220, 20),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[1]),
                goldenFruitOnPlatform(platforms[3]),
                goldenFruitOnPlatform(platforms[5])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 1, 3, 5].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(400, 30, PORTAL_W, PORTAL_H), spawn: [40, 500], name: "Level 6", required_coins: coins.length + goldenFruits.length };
        }

        function makeLevel7() {
            const platforms = [
                rect(-400, 560, 2400, 70),
                rect(60, 480, 200, 20),
                rect(360, 400, 240, 20),
                rect(700, 320, 220, 20),
                rect(240, 250, 240, 20),
                rect(560, 170, 220, 20),
                rect(380, 90, 220, 20),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[1]),
                goldenFruitOnPlatform(platforms[3]),
                goldenFruitOnPlatform(platforms[5])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 1, 3, 5].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(360, 10, PORTAL_W, PORTAL_H), spawn: [40, 500], name: "Level 7", required_coins: coins.length + goldenFruits.length };
        }

        function makeLevel8() {
            const platforms = [
                rect(-400, 560, 2400, 70),
                rect(80, 490, 180, 20),
                rect(360, 420, 200, 20),
                rect(680, 350, 200, 20),
                rect(240, 280, 200, 20),
                rect(560, 210, 200, 20),
                rect(380, 140, 200, 20),
                rect(700, 70, 200, 20),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[1]),
                goldenFruitOnPlatform(platforms[3]),
                goldenFruitOnPlatform(platforms[5])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 1, 3, 5].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(700, 10, PORTAL_W, PORTAL_H), spawn: [40, 500], name: "Level 8", required_coins: coins.length + goldenFruits.length };
        }

        function makeLevel9() {
            const platforms = [
                rect(-400, 560, 2400, 70),
                rect(60, 480, 180, 20),
                rect(340, 400, 200, 20),
                rect(660, 320, 200, 20),
                rect(220, 250, 200, 20),
                rect(540, 170, 200, 20),
                rect(360, 90, 200, 20),
                rect(680, 30, 200, 20),
            ];
            const goldenFruits = [
                goldenFruitOnPlatform(platforms[1]),
                goldenFruitOnPlatform(platforms[3]),
                goldenFruitOnPlatform(platforms[5])
            ];
            const regularPlatforms = platforms.filter((_, idx) => ![0, 1, 3, 5].includes(idx));
            const coins = regularPlatforms.map(coinOnPlatform);
            return { platforms, coins, goldenFruits, portal: rect(680, 0, PORTAL_W, PORTAL_H), spawn: [40, 500], name: "Level 9", required_coins: coins.length + goldenFruits.length };
        }

        const LEVELS = [makeLevel1(), makeLevel2(), makeLevel3(), makeLevel4(), makeLevel5(), makeLevel6(), makeLevel7(), makeLevel8(), makeLevel9()];

        const keys = new Set();
        window.addEventListener("keydown", (e) => {
            keys.add(e.key.toLowerCase());
            if (["arrowup", "arrowdown", "arrowleft", "arrowright", " "].includes(e.key.toLowerCase())) e.preventDefault();
        }, { passive: false });
        window.addEventListener("keyup", (e) => keys.delete(e.key.toLowerCase()));

        const touchState = { left: false, right: false, jump: false };

        function canvasPosFromEvent(ev) {
            const r = canvas.getBoundingClientRect();
            const x = (ev.clientX - r.left) * (WIDTH / r.width);
            const y = (ev.clientY - r.top) * (HEIGHT / r.height);
            return { x, y };
        }

        function applyTouchZones(points) {
            touchState.left = false;
            touchState.right = false;
            touchState.jump = false;

            for (const p of points) {
                if (p.x < WIDTH * 0.33) touchState.left = true;
                if (p.x > WIDTH * 0.67) touchState.right = true;
                if (p.x > WIDTH * 0.55 && p.y > HEIGHT * 0.70) touchState.jump = true;
            }
        }

        const activePointers = new Map();

        canvas.addEventListener("pointerdown", (e) => {
            canvas.setPointerCapture(e.pointerId);
            const p = canvasPosFromEvent(e);
            activePointers.set(e.pointerId, p);
            applyTouchZones(activePointers.values());
            e.preventDefault();
        }, { passive: false });

        canvas.addEventListener("pointermove", (e) => {
            if (!activePointers.has(e.pointerId)) return;
            activePointers.set(e.pointerId, canvasPosFromEvent(e));
            applyTouchZones(activePointers.values());
            e.preventDefault();
        }, { passive: false });

        function clearPointer(e) {
            activePointers.delete(e.pointerId);
            applyTouchZones(activePointers.values());
            e.preventDefault();
        }

        canvas.addEventListener("pointerup", clearPointer, { passive: false });
        canvas.addEventListener("pointercancel", clearPointer, { passive: false });

        class Player {
            constructor(x, y) {
                this.rect = rect(x, y, PLAYER_W, PLAYER_H);
                this.vx = 0;
                this.vy = 0;
                this.onGround = false;
                this.lastOnGroundMs = 0;
                this.jumpBufferUntil = 0;
                this.jumpHeld = false;
                this.facingLeft = false;
            }

            requestJump(nowMs) {
                this.jumpBufferUntil = nowMs + JUMP_BUFFER_MS;
                this.jumpHeld = true;
            }
            releaseJump() { this.jumpHeld = false; }

            update(platforms, nowMs, input) {
                const left = input.left;
                const right = input.right;
                const jumpPressed = input.jump;

                this.vx = 0;
                if (left) this.vx = -MOVE_SPEED;
                if (right) this.vx = MOVE_SPEED;

                if (jumpPressed && !this.jumpHeld) this.requestJump(nowMs);
                if (!jumpPressed && this.jumpHeld) this.releaseJump();

                this.vy += GRAVITY;
                this.vy = clamp(this.vy, -50, 25);

                this.rect.x += this.vx;
                for (const p of platforms) {
                    if (intersects(this.rect, p)) {
                        if (this.vx > 0) this.rect.x = p.x - this.rect.w;
                        else if (this.vx < 0) this.rect.x = p.x + p.w;
                    }
                }

                this.rect.y += this.vy;
                this.onGround = false;
                for (const p of platforms) {
                    if (intersects(this.rect, p)) {
                        if (this.vy > 0) {
                            this.rect.y = p.y - this.rect.h;
                            this.vy = 0;
                            this.onGround = true;
                            this.lastOnGroundMs = nowMs;
                        } else if (this.vy < 0) {
                            this.rect.y = p.y + p.h;
                            this.vy = 0;
                        }
                    }
                }

                const canCoyote = (nowMs - this.lastOnGroundMs) <= COYOTE_MS;
                const hasBuffered = nowMs <= this.jumpBufferUntil;

                if (hasBuffered && (this.onGround || canCoyote)) {
                    this.vy = -JUMP_SPEED;
                    this.onGround = false;
                    this.jumpBufferUntil = 0;
                    this.lastOnGroundMs = 0;
                }

                if (!this.jumpHeld && this.vy < 0) this.vy *= JUMP_CUT_MULT;

                if (this.vx < 0) this.facingLeft = true;
                else if (this.vx > 0) this.facingLeft = false;
            }
        }

        class Game {
            constructor() {
                this.lives = MAX_LIVES;
                this.mode = "start";
                this.levelIndex = 0;
                this.totalCoins = 0;
                this.levelCoins = 0;
                this.requiredCoins = 0;
                this.portalCooldownUntil = 0;
                this.msg = "";
                this.msgUntil = 0;
                this.coinPopUntil = 0;
                this.levelContents = [];
                this.qIndex = 0;
                this.currentQuestion = null;
                this.feedbackTitle = "";
                this.feedbackText = "";
                this.feedbackGood = false;
                this.feedbackUntil = 0;
                this.feedbackNext = null;
                this.confetti = [];
                this.camX = 0;
                this.camY = 0;
                this.minX = 0;
                this.maxX = 0;
                this.minY = 0;
                this.maxY = 0;
                this.optionRects = [];
                this.learningActive = false;
                this.learningPhase = 0;
                this.portalQuestions = [];
                this.portalQIndex = 0;
                this.waitingForContinue = false;
                this.showNextButton = false;
                this.levelCompleteData = null;

                this.animTime = 0;
                this.lastTime = 0;
                this.frameIndex = 0;

                // Load saved progress
                this.loadProgressFromLocalStorage();

                this.loadLevel(true);

                window.addEventListener("keydown", (e) => {
                    const k = e.key.toLowerCase();

                    if (k === "escape") {
                        if (this.mode === "play") { this.mode = "quit"; this.updateAlpine(); return; }
                        if (this.mode === "quit") { this.mode = "play"; this.updateAlpine(); return; }
                        this.mode = "start";
                        this.updateAlpine();
                        return;
                    }

                    if (this.mode === "start" && k === "enter") {
                        ensureAudio();
                        this.mode = "play";
                        this.updateAlpine();
                    }

                    if (this.mode === "quit") {
                        if (k === "enter") { this.mode = "play"; this.updateAlpine(); }
                        if (k === "q") { this.mode = "start"; this.updateAlpine(); }
                        return;
                    }

                    if (this.mode === "question") {
                        if (k === "1") this.answerQuestion(0);
                        if (k === "2") this.answerQuestion(1);
                        if (k === "3") this.answerQuestion(2);
                        if (k === "4") this.answerQuestion(3);
                    }

                    if (this.mode === "game_over" && k === "r") {
                        this.resetWholeGame();
                    }
                });

                canvas.addEventListener("pointerdown", (e) => {
                    const p = canvasPosFromEvent(e);

                    if (this.mode === "start") {
                        ensureAudio();
                        this.mode = "play";
                        this.updateAlpine();
                        return;
                    }

                    if (this.mode === "question") {
                        for (let i = 0; i < this.optionRects.length; i++) {
                            const r = this.optionRects[i];
                            if (p.x >= r.x && p.x <= r.x + r.w && p.y >= r.y && p.y <= r.y + r.h) {
                                this.answerQuestion(i);
                                return;
                            }
                        }
                    }

                    if (this.mode === "quit") {
                        if (p.y < HEIGHT * 0.55) { this.mode = "play"; this.updateAlpine(); }
                        else { this.mode = "start"; this.updateAlpine(); }
                        return;
                    }
                }, { passive: true });
            }

            // ---------- PROGRESS LOADING ----------
            loadProgressFromLocalStorage() {
                const saved = localStorage.getItem('capybara_game_progress');
                if (saved) {
                    try {
                        const data = JSON.parse(saved);
                        this.totalCoins = data.totalCoins || 0;
                    } catch (e) {
                        console.warn('Failed to load progress');
                    }
                }
            }

            // ---------- LEVEL COMPLETE ----------
            showLevelComplete() {
                // Clear any pending state
                this.mode = 'level_complete';
                this.currentQuestion = null;
                this.feedbackNext = null;
                this.waitingForContinue = false;

                // Spawn celebratory confetti
                this.spawnConfetti();

                // Mark this level as completed & determine if it's the first completion
                let completedLevels = JSON.parse(localStorage.getItem('capybara_completed_levels') || '[]');
                const isFirstCompletion = !completedLevels.includes(this.levelIndex);

                let bonusCoins = 0;
                if (isFirstCompletion) {
                    completedLevels.push(this.levelIndex);
                    localStorage.setItem('capybara_completed_levels', JSON.stringify(completedLevels));
                    bonusCoins = this.levelCoins * 2;
                    this.totalCoins += bonusCoins;
                }

                // Save oranges earned
                let orangesData = JSON.parse(localStorage.getItem('capybara_level_oranges') || '{}');
                const currentOranges = this.levelCoins;
                if (!orangesData[this.levelIndex + 1] || orangesData[this.levelIndex + 1] < currentOranges) {
                    orangesData[this.levelIndex + 1] = currentOranges;
                    localStorage.setItem('capybara_level_oranges', JSON.stringify(orangesData));
                }

                // Save total coins
                const progress = {
                    totalCoins: this.totalCoins,
                    completedLevels: completedLevels
                };
                localStorage.setItem('capybara_game_progress', JSON.stringify(progress));

                // Save to MySQL database via API
                this.saveCoinsToDB(isFirstCompletion ? 1 : 0);

                // Play level complete sound
                playLevelComplete();

                // Set the data for Alpine
                this.levelCompleteData = {
                    levelName: this.level ? this.level.name : `Level ${this.levelIndex + 1}`,
                    levelNumber: this.levelIndex + 1,
                    coinsEarned: this.levelCoins,
                    bonusCoins: bonusCoins,
                    totalCoins: this.totalCoins,
                    isFirstCompletion: isFirstCompletion,
                    isLastLevel: (this.levelIndex >= TOTAL_LEVELS - 1)
                };

                this.updateAlpine();
            }

            resetWholeGame() {
                this.lives = MAX_LIVES;
                this.levelIndex = 0;
                this.totalCoins = 0;
                this.levelCompleteData = null;
                this.mode = "start";
                this.loadLevel(true);
                this.updateAlpine();
            }

            respawnPlayer() {
                if (!this.player || !this.level) return;
                this.player.rect.x = this.level.spawn[0];
                this.player.rect.y = this.level.spawn[1];
                this.player.vx = 0;
                this.player.vy = 0;
                this.player.onGround = false;
                this.player.lastOnGroundMs = 0;
                this.updateCamera(true);
            }

            async loadLevel(forceCamera) {
                const childId = 1;
                const levelNum = this.levelIndex + 1;

                const levelData = await fetchLevelData(childId, levelNum);

                if (!levelData) {
                    alert('Oops! Could not load level. Please try again.');
                    return;
                }

                if (Array.isArray(levelData)) {
                    this.levelContents = levelData;
                } else if (levelData && levelData.contents) {
                    this.levelContents = levelData.contents;
                    if (levelData.score && typeof levelData.score.coins_earned === 'number' && levelData.score.coins_earned > this.totalCoins) {
                        this.totalCoins = levelData.score.coins_earned;
                    }
                } else {
                    this.levelContents = getFallbackData(levelNum);
                }

                const base = LEVELS[this.levelIndex];
                this.level = {
                    platforms: base.platforms.map(p => ({ ...p })),
                    coins: base.coins.map(c => ({ ...c })),
                    goldenFruits: base.goldenFruits ? base.goldenFruits.map(g => ({ ...g })) : [],
                    portal: { ...base.portal },
                    spawn: [...base.spawn],
                    name: base.name,
                    required_coins: base.required_coins
                };

                this.player = new Player(this.level.spawn[0], this.level.spawn[1]);
                this.levelCoins = 0;
                this.requiredCoins = this.level.required_coins;
                this.computeLevelBounds();
                this.updateCamera(forceCamera);

                this.qIndex = 0;
                this.currentQuestion = null;
                this.confetti.length = 0;
                this.optionRects = [];
                this.learningActive = false;
                this.learningPhase = 0;
                this.portalQuestions = [];
                this.portalQIndex = 0;
                this.waitingForContinue = false;
                this.showNextButton = false;
                this.levelCompleteData = null;

                this.animTime = 0;
                this.frameIndex = 0;

                this.updateAlpine();
            }

            computeLevelBounds() {
                const all = [...this.level.platforms, this.level.portal, ...this.level.coins];
                if (this.level.goldenFruits) {
                    all.push(...this.level.goldenFruits);
                }
                this.minX = Math.min(...all.map(r => r.x)) - 200;
                this.maxX = Math.max(...all.map(r => r.x + r.w)) + 200;
                this.minY = Math.min(...all.map(r => r.y)) - 200;
                this.maxY = Math.max(...all.map(r => r.y + r.h)) + 200;
            }

            updateCamera(force) {
                const targetX = (this.player.rect.x + this.player.rect.w / 2) - WIDTH / 2;
                const targetY = (this.player.rect.y + this.player.rect.h / 2) - HEIGHT / 2;

                if (force) {
                    this.camX = targetX;
                    this.camY = targetY;
                } else {
                    this.camX = (this.camX + (targetX - this.camX) * 0.12) | 0;
                    this.camY = (this.camY + (targetY - this.camY) * 0.12) | 0;
                }

                this.camX = clamp(this.camX, this.minX, this.maxX - WIDTH);
                this.camY = clamp(this.camY, this.minY, this.maxY - HEIGHT);
            }

            worldToScreen(r) { return rect(r.x - this.camX, r.y - this.camY, r.w, r.h); }

            showMessage(text) {
                this.msg = text;
                this.msgUntil = performance.now() + MSG_MS;
                this.updateAlpine();
            }

            collectCoins() {
                const now = performance.now();
                const remaining = [];
                let gotAny = false;

                const completedLevels = JSON.parse(localStorage.getItem('capybara_completed_levels') || '[]');
                const isReplay = completedLevels.includes(this.levelIndex);

                for (const c of this.level.coins) {
                    if (intersects(this.player.rect, c)) {
                        this.levelCoins += 1;
                        if (!isReplay) {
                            this.totalCoins += 1;
                        }
                        playCoin();
                        gotAny = true;
                    } else remaining.push(c);
                }
                this.level.coins = remaining;

                // Golden fruits: facts & quizzes playable on every attempt!
                if (this.level.goldenFruits) {
                    const remainingGolden = [];
                    for (const g of this.level.goldenFruits) {
                        if (intersects(this.player.rect, g)) {
                            this.levelCoins += 1;
                            if (!isReplay) {
                                this.totalCoins += 1;
                            }
                            playCoin();
                            gotAny = true;

                            // Always trigger Think & Learn popup on every attempt!
                            this.triggerLearning();
                        } else {
                            remainingGolden.push(g);
                        }
                    }
                    this.level.goldenFruits = remainingGolden;
                }

                if (gotAny) {
                    this.coinPopUntil = now + COIN_POP_MS;
                    this.updateAlpine();
                }
            }

            triggerLearning() {
                if (this.learningActive) return;
                if (!this.levelContents || this.levelContents.length === 0) return;

                if (this.learningPhase >= this.levelContents.length) {
                    this.learningPhase = 0;
                }

                this.learningActive = true;
                this.showSeePhase();
            }

            showSeePhase() {
                const content = this.levelContents[this.learningPhase];
                if (!content) return;

                this.currentQuestion = {
                    question: content.fact,
                    options: [],
                    correctIndex: 0,
                    content_id: content.content_id,
                    phase: 'see',
                    explanation: content.explanation,
                    isLearning: true,
                    learningPhase: 'see',
                    phaseLabel: '💡 KNOW THIS'
                };

                this.mode = 'question';
                this.optionRects = [];
                this.showNextButton = false;
                this.updateAlpine();

                setTimeout(() => {
                    if (this.mode === 'question' && this.currentQuestion && this.currentQuestion.learningPhase === 'see') {
                        this.showNextButton = true;
                        this.updateAlpine();
                    }
                }, 4000);
            }

            goToThinkPhase() {
                if (this.mode === 'question' && this.currentQuestion && this.currentQuestion.learningPhase === 'see') {
                    this.showNextButton = false;
                    this.showThinkPhase();
                }
            }

            showThinkPhase() {
                const content = this.levelContents[this.learningPhase];
                if (!content) return;

                this.currentQuestion = {
                    question: content.think_question,
                    options: content.think_options,
                    correctIndex: content.think_correct_index,
                    content_id: content.content_id,
                    phase: 'think',
                    explanation: content.explanation,
                    isLearning: true,
                    learningPhase: 'think',
                    phaseLabel: '🧠 THINK ABOUT IT '
                };

                this.mode = 'question';
                this.optionRects = [];
                this.showNextButton = false;
                this.updateAlpine();
            }

            showApplyPhase() {
                const content = this.levelContents[this.learningPhase];
                if (!content) return;

                this.currentQuestion = {
                    question: content.apply_question,
                    options: content.apply_options,
                    correctIndex: content.apply_correct_index,
                    content_id: content.content_id,
                    phase: 'apply',
                    explanation: content.explanation,
                    isLearning: true,
                    learningPhase: 'apply',
                    phaseLabel: '💡 APPLY YOUR KNOWLEDGE'
                };

                this.mode = 'question';
                this.optionRects = [];
                this.updateAlpine();
            }

            showReviewPhase(wasCorrect) {
                const content = this.levelContents[this.learningPhase];
                if (!content) return;

                const title = wasCorrect ? 'Meadow-velous!' : 'Keep Learning!';
                const text = wasCorrect ?
                    content.explanation :
                    'The correct answer was: ' + this.currentQuestion.options[this.currentQuestion.correctIndex] + '\n\n' + content.explanation;

                this.beginFeedback(wasCorrect, title, text, 'end_learning');
            }

            // ---------- PORTAL QUIZ ----------
            startPortalQuiz() {
                if (!this.levelContents || this.levelContents.length === 0) {
                    this.advanceLevel();
                    return;
                }

                this.portalQuestions = this.levelContents.map(content => ({
                    question: content.apply_question,
                    options: content.apply_options,
                    correctIndex: content.apply_correct_index,
                    explanation: content.explanation,
                    content_id: content.content_id
                }));

                this.portalQIndex = 0;
                this.levelCompleteData = null;
                this.showPortalQuestion();
            }

            showPortalQuestion() {
                // Reset levelCompleteData to prevent stuck screen
                this.levelCompleteData = null;

                // If all portal questions are done, show Level Complete
                if (this.portalQIndex >= this.portalQuestions.length) {
                    this.showLevelComplete();
                    return;
                }

                const q = this.portalQuestions[this.portalQIndex];
                this.currentQuestion = {
                    question: q.question,
                    options: q.options,
                    correctIndex: q.correctIndex,
                    content_id: q.content_id,
                    phase: 'portal',
                    explanation: q.explanation,
                    isPortal: true,
                    portalIndex: this.portalQIndex
                };

                this.mode = 'question';
                this.optionRects = [];
                this.updateAlpine();
            }

            answerPortalQuestion(choiceIndex) {
                const q = this.currentQuestion;
                const isCorrect = (choiceIndex === q.correctIndex);

                // Reset levelCompleteData to prevent stuck screen
                this.levelCompleteData = null;

                const completedLevels = JSON.parse(localStorage.getItem('capybara_completed_levels') || '[]');
                const isReplay = completedLevels.includes(this.levelIndex);

                if (isCorrect) {
                    if (!isReplay) {
                        this.totalCoins += 3;
                        this.showMessage('+3 Coins!');
                    } else {
                        this.showMessage('Correct!');
                    }
                    this.beginFeedback(true, 'Correct!', q.explanation, 'next_portal_q');
                } else {
                    this.beginFeedback(false, 'Keep Learning!', 
                        `Correct answer was: ${q.options[q.correctIndex]}\n\n${q.explanation}`, 
                        'next_portal_q'
                    );
                }
            }

            spawnConfetti() {
                for (let i = 0; i < CONFETTI_COUNT; i++) this.confetti.push(new ConfettiParticle(WIDTH / 2, 130));
            }

            beginFeedback(good, title, text, nextAction) {
                const now = performance.now();
                this.feedbackGood = good;
                this.feedbackTitle = title;
                this.feedbackText = text;
                this.feedbackUntil = now + FEEDBACK_MS;
                this.feedbackNext = nextAction;
                
                // Force mode to feedback and clear any stuck state
                this.mode = "feedback";
                this.waitingForContinue = true;
                this.levelCompleteData = null;
                
                this.updateAlpine();

                if (good) { 
                    this.spawnConfetti();
                    soundCorrect(); 
                } else { 
                    soundWrong(); 
                }
            }

            advanceFromFeedback() {
                if (!this.feedbackNext) return;
                
                const action = this.feedbackNext;
                this.feedbackNext = null;
                this.waitingForContinue = false;

                // Reset Alpine to clear any stuck UI
                this.updateAlpine();

                if (action === "next_portal_q") {
                    this.portalQIndex++;
                    // Force a clean state before showing next question
                    this.levelCompleteData = null;
                    setTimeout(() => {
                        this.showPortalQuestion();
                    }, 100);
                } else if (action === "end_learning") {
                    this.learningActive = false;
                    this.learningPhase++;
                    this.mode = "play";
                    this.updateAlpine();
                } else if (action === "next_q") {
                    if (this.lives <= 0) { 
                        this.mode = "game_over"; 
                        this.updateAlpine();
                    } else { 
                        this.qIndex += 1;
                        this.startNextQuestion(); 
                    }
                } else if (action === "game_over") {
                    this.mode = "game_over";
                    this.updateAlpine();
                }
            }

            startNextQuestion() {
                if (this.qIndex >= this.levelQuestions.length) { this.advanceLevel(); return; }
                this.currentQuestion = this.levelQuestions[this.qIndex];
                this.mode = "question";
                this.optionRects = [];
                this.updateAlpine();
            }

            answerQuestion(choiceIndex) {
                if (this.learningActive) {
                    this.answerLearningQuestion(choiceIndex);
                    return;
                }

                if (this.currentQuestion && this.currentQuestion.isPortal) {
                    this.answerPortalQuestion(choiceIndex);
                    return;
                }

                const q = this.currentQuestion;
                if (!q) return;
                const chosen = q.options[choiceIndex];

                if (chosen === q.answer) {
                    this.beginFeedback(true, "Correct!", q.fact, "next_q");
                } else {
                    const nextLives = this.lives - 1;
                    if (nextLives <= 0) {
                        this.beginFeedback(false, "Wrong!", `Correct answer: ${q.answer}`, "game_over");
                    } else {
                        this.beginFeedback(false, "Wrong!", `Correct answer: ${q.answer}\nLives left: ${nextLives}`, "next_q");
                    }
                }
            }

            answerLearningQuestion(choiceIndex) {
                const q = this.currentQuestion;
                const isCorrect = (choiceIndex === q.correctIndex);

                const completedLevels = JSON.parse(localStorage.getItem('capybara_completed_levels') || '[]');
                const isReplay = completedLevels.includes(this.levelIndex);

                if (q.learningPhase === 'think') {
                    if (isCorrect) {
                        if (!isReplay) {
                            this.totalCoins += 1;
                            this.showMessage('+1 Coin for thinking!');
                        } else {
                            this.showMessage('Great Thinker!');
                        }
                    }
                    this.saveProgressToDB(q.content_id, isCorrect);
                    this.showApplyPhase();
                } else if (q.learningPhase === 'apply') {
                    if (isCorrect) {
                        if (!isReplay) {
                            this.totalCoins += 2;
                            this.showMessage('+2 Coins for applying!');
                        } else {
                            this.showMessage('Great Job!');
                        }
                    }
                    this.saveProgressToDB(q.content_id, isCorrect);
                    this.showReviewPhase(isCorrect);
                }
                this.updateAlpine();
            }

            async saveProgressToDB(contentId, wasCorrect) {
                try {
                    await fetch('api/save_capybara_progress.php', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            child_id: 1,
                            content_id: contentId,
                            was_correct: wasCorrect,
                            current_level: this.levelIndex + 1
                        })
                    });
                    console.log('✅ Progress saved to DB:', contentId, wasCorrect);
                } catch (e) {
                    console.warn('⚠️ Progress saved locally (API offline):', e);
                }
            }

            async saveCoinsToDB(isCompleted) {
                try {
                    await fetch('api/save_capybara_coins.php', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            child_id: 1,
                            total_coins: this.totalCoins,
                            level_number: this.levelIndex + 1,
                            oranges_collected: this.levelCoins,
                            knowledge_mastered: 3,
                            level_completed: isCompleted
                        })
                    });
                    console.log('✅ Coins saved to DB successfully');
                } catch (e) {
                    console.warn('⚠️ Coins saved locally (API offline):', e);
                }
            }

            tryPortal() {
                if (this.levelCoins < this.requiredCoins) {
                    const need = this.requiredCoins - this.levelCoins;
                    this.showMessage(`Portal locked: collect ${need} more fruit(s)!`);
                    return;
                }

                this.startPortalQuiz();
            }

            async advanceLevel() {
                try {
                    this.levelIndex += 1;
                    this.levelCompleteData = null;
                    this.mode = "play";
                    this.updateAlpine();
                    if (this.levelIndex >= TOTAL_LEVELS) { 
                        this.mode = "win"; 
                        this.updateAlpine(); 
                        return; 
                    }
                    await this.loadLevel(true);
                    this.mode = "play";
                    this.updateAlpine();
                } catch (e) {
                    console.error("Error advancing level:", e);
                    this.mode = "play";
                    this.updateAlpine();
                }
            }

            async selectLevelByIndex(index) {
                try {
                    if (index < 0 || index >= LEVELS.length) return;
                    this.levelIndex = index;
                    this.levelCompleteData = null;
                    this.mode = 'play';
                    this.updateAlpine();
                    await this.loadLevel(true);
                    this.mode = "play";
                    this.updateAlpine();
                } catch (e) {
                    console.error("Error selecting level:", e);
                    this.mode = "play";
                    this.updateAlpine();
                }
            }

            // ---------- DRAWING ----------
            drawMeadowBackground(nowMs) {
                const skyGrad = ctx.createLinearGradient(0, 0, 0, HEIGHT);
                skyGrad.addColorStop(0, '#87CEEB');
                skyGrad.addColorStop(1, '#FFF8E7');
                ctx.fillStyle = skyGrad;
                ctx.fillRect(0, 0, WIDTH, HEIGHT);
            }

            drawPortalGlow(nowMs) {
                const pr = this.worldToScreen(this.level.portal);
                const cx = pr.x + pr.w / 2;
                const cy = pr.y + pr.h / 2;

                const pulse = 0.5 + 0.5 * Math.sin(nowMs * 0.004);
                const glowPad = 16 + pulse * 10;

                const grad = ctx.createRadialGradient(cx, cy, 8, cx, cy, Math.max(pr.w, pr.h) + glowPad);
                grad.addColorStop(0, `rgba(190,140,255,${0.22 + pulse * 0.20})`);
                grad.addColorStop(0.6, `rgba(150,60,220,${0.10 + pulse * 0.10})`);
                grad.addColorStop(1, "rgba(150,60,220,0)");

                ctx.fillStyle = grad;
                ctx.beginPath();
                ctx.ellipse(cx, cy, pr.w / 2 + glowPad, pr.h / 2 + glowPad, 0, 0, Math.PI * 2);
                ctx.fill();

                ctx.fillStyle = PORTAL_COLOR;
                roundRect(ctx, pr.x, pr.y, pr.w, pr.h, 10);
                ctx.fill();

                ctx.strokeStyle = `rgba(190,140,255,${0.35 + pulse * 0.35})`;
                ctx.lineWidth = 3;
                roundRect(ctx, pr.x - 5, pr.y - 5, pr.w + 10, pr.h + 10, 12);
                ctx.stroke();
            }

            drawHUD(nowMs) {
                const barX = 14,
                    barY = 12,
                    barW = WIDTH - 28,
                    barH = 66;
                ctx.globalAlpha = 0.95;
                ctx.fillStyle = "#ffffff";
                roundRect(ctx, barX, barY, barW, barH, 14);
                ctx.fill();
                ctx.globalAlpha = 1;

                ctx.strokeStyle = "#e2e6ee";
                ctx.lineWidth = 1;
                roundRect(ctx, barX, barY, barW, barH, 14);
                ctx.stroke();

                ctx.fillStyle = TEXT_COLOR;
                ctx.font = (nowMs < this.coinPopUntil) ? "bold 22px Arial" : "bold 20px Arial";
                ctx.fillText(
                    `${this.level.name}  •  Fruits: ${this.levelCoins}/${this.requiredCoins}  •  Coins: ${this.totalCoins}  •  Lives: ${this.lives}`,
                    barX + 18, barY + 30
                );

                ctx.fillStyle = "#3c4652";
                ctx.font = "14px Arial";
                ctx.fillText(
                    `Move: A/D or ←/→   Jump: Space/W/↑   Touch portal for quiz   Esc: Quit`,
                    barX + 18, barY + 54
                );

                if (nowMs < this.msgUntil && this.msg) {
                    ctx.fillStyle = "#b42828";
                    ctx.font = "bold 22px Arial";
                    const w = ctx.measureText(this.msg).width;
                    ctx.fillText(this.msg, (WIDTH - w) / 2, barY + barH + 30);
                }
            }

            drawWorld(nowMs) {
                this.drawMeadowBackground(nowMs);

                if (this.mode === 'start') {
                    return;
                }

                const hudTop = 12;
                const hudHeight = 66;
                const hudBottom = hudTop + hudHeight + 10;

                ctx.save();
                ctx.beginPath();
                ctx.rect(0, hudBottom, WIDTH, HEIGHT - hudBottom);
                ctx.clip();

                const tileSize = 32;
                for (const p of this.level.platforms) {
                    const r = this.worldToScreen(p);
                    for (let x = r.x; x < r.x + r.w; x += tileSize) {
                        ctx.drawImage(grassTile, x, r.y, tileSize, tileSize);
                    }
                    for (let y = r.y + tileSize; y < r.y + r.h; y += tileSize) {
                        for (let x = r.x; x < r.x + r.w; x += tileSize) {
                            ctx.drawImage(dirtTile, x, y, tileSize, tileSize);
                        }
                    }
                }

                for (const c of this.level.coins) {
                    const r = this.worldToScreen(c);
                    const floatY = Math.sin(nowMs * 0.003 + c.x) * 3;
                    const drawW = r.w * 1.45;
                    const drawH = r.h * 1.45;
                    const drawX = r.x - (drawW - r.w) / 2;
                    const drawY = r.y - (drawH - r.h) / 2 + floatY;

                    if (fruitSprite && fruitSprite.complete && fruitSprite.naturalWidth > 0) {
                        ctx.drawImage(fruitSprite, drawX, drawY, drawW, drawH);
                    } else {
                        ctx.fillStyle = COIN_COLOR;
                        ctx.beginPath();
                        ctx.ellipse(r.x + r.w / 2, r.y + r.h / 2 + floatY, r.w / 2, r.h / 2, 0, 0, Math.PI * 2);
                        ctx.fill();
                    }
                }

                if (this.level.goldenFruits) {
                    for (const g of this.level.goldenFruits) {
                        const r = this.worldToScreen(g);
                        const floatY = Math.sin(nowMs * 0.004 + g.x) * 4;
                        const drawW = r.w * 1.45;
                        const drawH = r.h * 1.45;
                        const drawX = r.x - (drawW - r.w) / 2;
                        const drawY = r.y - (drawH - r.h) / 2 + floatY;

                        if (goldenFruitSprite && goldenFruitSprite.complete && goldenFruitSprite.naturalWidth > 0) {
                            const cx = r.x + r.w / 2;
                            const cy = r.y + r.h / 2 + floatY;
                            const pulse = 0.5 + 0.5 * Math.sin(nowMs * 0.005 + g.x);
                            const grad = ctx.createRadialGradient(cx, cy, 4, cx, cy, r.w * 1.4);
                            grad.addColorStop(0, `rgba(255, 215, 0, ${0.45 + pulse * 0.3})`);
                            grad.addColorStop(1, 'rgba(255, 215, 0, 0)');
                            ctx.fillStyle = grad;
                            ctx.beginPath();
                            ctx.arc(cx, cy, r.w * 1.4, 0, Math.PI * 2);
                            ctx.fill();
                            ctx.drawImage(goldenFruitSprite, drawX, drawY, drawW, drawH);
                        } else {
                            ctx.fillStyle = "#FFD700";
                            ctx.beginPath();
                            ctx.ellipse(r.x + r.w / 2, r.y + r.h / 2 + floatY, r.w / 2, r.h / 2, 0, 0, Math.PI * 2);
                            ctx.fill();
                        }
                    }
                }

                this.drawPortalGlow(nowMs);

                const pl = this.worldToScreen(this.player.rect);

                let spriteDrawn = false;
                if (spritesLoaded) {
                    let spriteKey;
                    if (!this.player.onGround) {
                        spriteKey = this.player.facingLeft ? 'jump_left' : 'jump_right';
                    } else if (Math.abs(this.player.vx) > 0) {
                        spriteKey = this.player.facingLeft ? 'walk_left' : 'walk_right';
                    } else {
                        spriteKey = this.player.facingLeft ? 'idle_left' : 'idle_right';
                    }

                    let sprite = capySprites[spriteKey];
                    if ((!sprite || !sprite.complete || sprite.naturalWidth === 0) && (spriteKey === 'run_left' || spriteKey === 'run_right')) {
                        spriteKey = this.player.facingLeft ? 'walk_left' : 'walk_right';
                        sprite = capySprites[spriteKey];
                    }

                    if (sprite && sprite.complete && sprite.naturalWidth > 0 && sprite.naturalHeight > 0) {
                        const frameCount = FRAME_COUNTS[spriteKey] || 1;
                        let sx = 0, sy = 0, sw = sprite.naturalWidth, sh = sprite.naturalHeight;

                        if (frameCount > 1) {
                            const cols = Math.ceil(Math.sqrt(frameCount));
                            const rows = Math.ceil(frameCount / cols);
                            const frameW = sprite.naturalWidth / cols;
                            const frameH = sprite.naturalHeight / rows;
                            const frame = this.frameIndex % frameCount;
                            const col = frame % cols;
                            const row = Math.floor(frame / cols);
                            sx = Math.floor(col * frameW);
                            sy = Math.floor(row * frameH);
                            sw = Math.floor(frameW);
                            sh = Math.floor(frameH);
                        }

                        const scale = Math.min(pl.w / sw, pl.h / sh);
                        const drawW = sw * scale;
                        const drawH = sh * scale;
                        const offsetX = (pl.w - drawW) / 2;
                        const offsetY = pl.h - drawH;

                        ctx.drawImage(sprite, sx, sy, sw, sh, pl.x + offsetX, pl.y + offsetY, drawW, drawH);
                        spriteDrawn = true;
                    }
                }

                if (!spriteDrawn) {
                    ctx.fillStyle = PLAYER_COLOR;
                    roundRect(ctx, pl.x, pl.y, pl.w, pl.h, 8);
                    ctx.fill();
                    ctx.fillStyle = "#fff";
                    ctx.font = "12px Arial";
                    ctx.textAlign = "center";
                    ctx.fillText(spritesLoaded ? "SPRITE?" : "Loading...", pl.x + pl.w / 2, pl.y + pl.h / 2 + 4);
                }

                ctx.restore();

                if (this.mode === "play") {
                    this.drawHUD(nowMs);
                }
            }

            drawStart() {
                this.drawMeadowBackground(performance.now());
            }

            drawQuestion(nowMs) {
                this.drawWorld(nowMs);
            }

            drawFeedback() {
                this.drawWorld(performance.now());
            }

            drawWin() {
                this.drawWorld(performance.now());
            }

            drawGameOver() {
                this.drawWorld(performance.now());
            }

            drawQuitModal() {
                ctx.save();
                ctx.globalAlpha = 0.35;
                ctx.fillStyle = "#000";
                ctx.fillRect(0, 0, WIDTH, HEIGHT);
                ctx.restore();

                const cardW = 520,
                    cardH = 240;
                const x = (WIDTH - cardW) / 2;
                const y = (HEIGHT - cardH) / 2;

                ctx.fillStyle = "#fff";
                roundRect(ctx, x, y, cardW, cardH, 18);
                ctx.fill();

                ctx.strokeStyle = "#d2d2d2";
                ctx.lineWidth = 2;
                roundRect(ctx, x, y, cardW, cardH, 18);
                ctx.stroke();

                ctx.fillStyle = TEXT_COLOR;
                ctx.font = "bold 34px Arial";
                const title = "Quit Game?";
                ctx.fillText(title, x + (cardW - ctx.measureText(title).width) / 2, y + 70);

                ctx.font = "18px Arial";
                ctx.fillStyle = "#3c4652";
                const a = "Tap upper area to Resume";
                const b = "Tap lower area to Quit to Start screen";
                ctx.fillText(a, x + (cardW - ctx.measureText(a).width) / 2, y + 125);
                ctx.fillText(b, x + (cardW - ctx.measureText(b).width) / 2, y + 155);
            }

            // ---------- UPDATE ----------
            update(nowMs) {
                if (this.lastTime === 0) this.lastTime = nowMs;
                const delta = nowMs - this.lastTime;
                this.lastTime = nowMs;

                if (this.player && this.mode === "play") {
                    this.animTime += delta;

                    let maxFrame = 25;
                    if (this.player.onGround) {
                        if (Math.abs(this.player.vx) > 0) {
                            maxFrame = 25;
                        } else {
                            maxFrame = 9;
                        }
                    } else {
                        maxFrame = 25;
                    }

                    let speed = (maxFrame === 9) ? 140 : 100;
                    this.frameIndex = Math.floor(this.animTime / speed) % maxFrame;
                }

                const input = {
                    left: (keys.has("a") || keys.has("arrowleft") || touchState.left),
                    right: (keys.has("d") || keys.has("arrowright") || touchState.right),
                    jump: (keys.has(" ") || keys.has("w") || keys.has("arrowup") || touchState.jump),
                };

                if (this.mode === "play" && this.player) {
                    this.player.update(this.level.platforms, nowMs, input);
                    this.collectCoins();
                    this.updateCamera(false);

                    if (this.player.rect.y > HEIGHT + FALL_OFFSET) {
                        this.lives -= 1;
                        if (this.lives <= 0) {
                            this.mode = "game_over";
                            this.updateAlpine();
                        } else {
                            this.respawnPlayer();
                            this.showMessage(`💔 Lost a life! ${this.lives} left`);
                        }
                    }

                    if (nowMs >= this.portalCooldownUntil && intersects(this.player.rect, this.level.portal)) {
                        this.portalCooldownUntil = nowMs + 400;
                        this.tryPortal();
                    }
                }

                if (this.mode === "feedback" && this.waitingForContinue && nowMs >= this.feedbackUntil) {
                    this.advanceFromFeedback();
                }

                // Update confetti
                if (this.confetti.length > 0) {
                    for (let i = this.confetti.length - 1; i >= 0; i--) {
                        this.confetti[i].update();
                        if (this.confetti[i].life <= 0) this.confetti.splice(i, 1);
                    }
                }
            }

            // ---------- RENDER ----------
            render(nowMs) {
                this.drawMeadowBackground(nowMs);

                if (this.mode !== "start") {
                    this.drawWorld(nowMs);
                }

                if (this.mode === "quit") {
                    this.drawQuitModal();
                }

                if (this.confetti.length > 0) {
                    for (const p of this.confetti) p.draw(ctx);
                }
            }

            // ---------- ALPINE SYNC ----------
            updateAlpine() {
                if (window.alpineGame) {
                    const a = window.alpineGame;
                    a.mode = this.mode;
                    a.level = this.levelIndex + 1;
                    a.levelCoins = this.levelCoins;
                    a.requiredCoins = this.requiredCoins;
                    a.totalCoins = this.totalCoins;
                    a.lives = this.lives;
                    a.msg = this.msg;
                    a.currentQuestion = this.currentQuestion;
                    a.feedbackGood = this.feedbackGood;
                    a.feedbackText = this.feedbackText;
                    a.feedbackTitle = this.feedbackTitle;
                    a.showNextButton = this.showNextButton;
                    a.levelCompleteData = this.levelCompleteData;
                    if (this.level) a.levelName = this.level.name || 'Level ' + (this.levelIndex + 1);
                }
            }
        }

        const game = new Game();
        window.gameInstance = game;

        game.render(performance.now());

        function loop(now) {
            game.update(now);
            game.render(now);
            requestAnimationFrame(loop);
        }
        requestAnimationFrame(loop);

    });

})();