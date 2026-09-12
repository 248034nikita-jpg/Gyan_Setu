// ============================================================
// Whack-A-Mole Learning Adventure — Phaser 3 (650×700)
// Features: Topic select, DB questions, hints, sounds, results
// ============================================================

// ──── Global question pool (filled by AJAX) ────
let QUESTIONS = [];

// ──── Shared state across scenes ────
let GAME_STATE = {
    tier: 1,
    topic: 'grammar',
    childId: 0,        // set from PHP session if available
};

// ──── Built-in fallback questions (used when API/DB is unavailable) ────
const FALLBACK_QUESTIONS = {
    grammar: {
        1: [
            { id:1, q:'She ___ a doctor.',        options:['is','am','are','be'],   correct:0, concept:'is / am / are' },
            { id:2, q:'I ___ nine years old.',     options:['am','is','are','be'],   correct:0, concept:'is / am / are' },
            { id:3, q:'They ___ playing outside.', options:['are','is','am','be'],   correct:0, concept:'is / am / are' },
            { id:4, q:'We ___ students.',          options:['are','is','am','was'],  correct:0, concept:'is / am / are' },
            { id:5, q:'He ___ my brother.',        options:['is','am','are','be'],   correct:0, concept:'is / am / are' },
            { id:6, q:'You ___ very kind.',        options:['are','is','am','be'],   correct:0, concept:'is / am / are' },
            { id:7, q:'It ___ a big elephant.',    options:['is','am','are','be'],   correct:0, concept:'is / am / are' },
            { id:8, q:'My parents ___ farmers.',   options:['are','is','am','be'],   correct:0, concept:'is / am / are' },
            { id:9, q:'I ___ happy today.',        options:['am','is','are','be'],   correct:0, concept:'is / am / are' },
            { id:10,q:'The sky ___ blue.',         options:['is','am','are','be'],   correct:0, concept:'is / am / are' },
        ],
        2: [
            { id:1, q:'Yesterday, I ___ to the market.',    options:['went','go','goes','going'],       correct:0, concept:'simple past tense' },
            { id:2, q:'She ___ her lunch already.',         options:['ate','eat','eats','eating'],      correct:0, concept:'simple past tense' },
            { id:3, q:'We ___ a movie last night.',         options:['watched','watch','watches','watching'], correct:0, concept:'simple past tense' },
            { id:4, q:'He ___ his homework before dinner.', options:['did','do','does','doing'],        correct:0, concept:'simple past tense' },
            { id:5, q:'They ___ to Pokhara last month.',   options:['travelled','travel','travels','travelling'], correct:0, concept:'simple past tense' },
            { id:6, q:'I ___ a letter to my friend.',      options:['wrote','write','writes','writing'],correct:0, concept:'simple past tense' },
            { id:7, q:'She ___ the door quietly.',         options:['closed','close','closes','closing'],correct:0, concept:'simple past tense' },
            { id:8, q:'We ___ football yesterday.',        options:['played','play','plays','playing'], correct:0, concept:'simple past tense' },
            { id:9, q:'He ___ his keys this morning.',     options:['lost','lose','loses','losing'],    correct:0, concept:'simple past tense' },
            { id:10,q:'I ___ very happy yesterday.',       options:['was','am','is','are'],             correct:0, concept:'simple past tense' },
        ],
        3: [
            { id:1, q:'Tomorrow, I ___ visit my grandmother.',  options:['will','am','shall go','going'], correct:0, concept:'future tense (will)' },
            { id:2, q:'She ___ finish her project by tomorrow.',options:['will','is','was','are'],        correct:0, concept:'future tense (will)' },
            { id:3, q:'If it rains, we ___ stay inside.',       options:['will','would','shall','are'],   correct:0, concept:'future tense (will)' },
            { id:4, q:'Next year, he ___ join a new school.',   options:['will','is','was','has'],        correct:0, concept:'future tense (will)' },
            { id:5, q:'We ___ go to the market later.',         options:['will','are','were','had'],      correct:0, concept:'future tense (will)' },
            { id:6, q:'They ___ visit us next weekend.',        options:['will','are','were','had'],      correct:0, concept:'future tense (will)' },
            { id:7, q:'I ___ call you after school.',           options:['will','am','was','have'],       correct:0, concept:'future tense (will)' },
            { id:8, q:'She ___ not come to the party.',         options:['will','is','was','can'],        correct:0, concept:'future tense (will)' },
            { id:9, q:'He ___ travel to Pokhara next month.',   options:['will','is','was','has'],        correct:0, concept:'future tense (will)' },
            { id:10,q:'We ___ start the game soon.',            options:['will','are','were','have'],     correct:0, concept:'future tense (will)' },
        ],
    },
    vocabulary: {
        1: [
            { id:1, q:'Opposite of "big"',   options:['small','large','huge','tall'],   correct:0, concept:'opposites' },
            { id:2, q:'Opposite of "happy"', options:['sad','glad','angry','joyful'],   correct:0, concept:'opposites' },
            { id:3, q:'Opposite of "hot"',   options:['cold','warm','cool','frozen'],   correct:0, concept:'opposites' },
            { id:4, q:'Opposite of "fast"',  options:['slow','quick','swift','speedy'], correct:0, concept:'opposites' },
            { id:5, q:'Opposite of "open"',  options:['closed','wide','shut','near'],   correct:0, concept:'opposites' },
            { id:6, q:'Opposite of "day"',   options:['night','morning','noon','dusk'], correct:0, concept:'opposites' },
            { id:7, q:'Opposite of "up"',    options:['down','above','high','over'],    correct:0, concept:'opposites' },
            { id:8, q:'Opposite of "full"',  options:['empty','heavy','large','wide'],  correct:0, concept:'opposites' },
            { id:9, q:'Opposite of "tall"',  options:['short','long','fat','wide'],     correct:0, concept:'opposites' },
            { id:10,q:'Opposite of "clean"', options:['dirty','bright','fresh','neat'], correct:0, concept:'opposites' },
        ],
        2: [
            { id:1, q:'Synonym of "happy"',    options:['joyful','sad','angry','tired'],     correct:0, concept:'synonyms' },
            { id:2, q:'Synonym of "big"',       options:['large','small','thin','short'],    correct:0, concept:'synonyms' },
            { id:3, q:'Synonym of "quick"',     options:['fast','slow','lazy','careful'],    correct:0, concept:'synonyms' },
            { id:4, q:'Synonym of "beautiful"', options:['lovely','ugly','plain','dull'],    correct:0, concept:'synonyms' },
            { id:5, q:'Synonym of "smart"',     options:['clever','foolish','dull','slow'],  correct:0, concept:'synonyms' },
            { id:6, q:'Synonym of "sad"',       options:['unhappy','glad','joyful','merry'], correct:0, concept:'synonyms' },
            { id:7, q:'Synonym of "small"',     options:['tiny','huge','tall','wide'],       correct:0, concept:'synonyms' },
            { id:8, q:'Synonym of "brave"',     options:['courageous','scared','shy','weak'],correct:0, concept:'synonyms' },
            { id:9, q:'Synonym of "kind"',      options:['caring','mean','rude','harsh'],    correct:0, concept:'synonyms' },
            { id:10,q:'Synonym of "angry"',     options:['furious','happy','calm','joyful'], correct:0, concept:'synonyms' },
        ],
        3: [
            { id:1, q:'She felt ___ after winning the race.',        options:['proud','sad','bored','tired'],       correct:0, concept:'context-based word choice' },
            { id:2, q:'The weather was ___, so we stayed indoors.',  options:['stormy','sunny','mild','warm'],      correct:0, concept:'context-based word choice' },
            { id:3, q:'He is very ___; he always helps others.',     options:['generous','selfish','rude','lazy'],  correct:0, concept:'context-based word choice' },
            { id:4, q:'After running an hour, he felt completely ___.', options:['exhausted','fresh','happy','strong'], correct:0, concept:'context-based word choice' },
            { id:5, q:'The teacher asked him to ___ his answer.',    options:['explain','hide','ignore','copy'],    correct:0, concept:'context-based word choice' },
            { id:6, q:'She whispered ___ so no one could hear.',     options:['softly','loudly','clearly','quickly'],correct:0, concept:'context-based word choice' },
            { id:7, q:'The puppy was full of energy and very ___.',  options:['playful','tired','quiet','lazy'],    correct:0, concept:'context-based word choice' },
            { id:8, q:'He works hard to ___ his family safe.',       options:['keep','make','let','bring'],         correct:0, concept:'context-based word choice' },
            { id:9, q:'Her ___ about space made her read many books.',options:['curiosity','fear','anger','sadness'],correct:0, concept:'context-based word choice' },
            { id:10,q:'He is known to be ___ and never lies.',       options:['honest','sneaky','rude','greedy'],   correct:0, concept:'context-based word choice' },
        ],
    },
};

/** Returns shuffled fallback questions for the given topic and tier. */
function getFallbackQuestions(topic, tier) {
    const pool = (FALLBACK_QUESTIONS[topic] && FALLBACK_QUESTIONS[topic][tier])
        ? FALLBACK_QUESTIONS[topic][tier]
        : FALLBACK_QUESTIONS['grammar'][1];
    // Deep clone & shuffle options so correct index stays valid
    return pool.map(q => {
        const opts = [...q.options];
        const correctText = opts[q.correct];
        // Fisher-Yates shuffle
        for (let i = opts.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [opts[i], opts[j]] = [opts[j], opts[i]];
        }
        return { ...q, options: opts, correct: opts.indexOf(correctText) };
    });
}


// ──── Helper: Smooth Scene Transition ────
function transitionToScene(scene, targetScene, data = null) {
    if (scene.isTransitioning) return;
    scene.isTransitioning = true;
    scene.cameras.main.fadeOut(300, 0, 0, 0);
    scene.cameras.main.once('camerafadeoutcomplete', () => {
        scene.isTransitioning = false; // Reset for when we return to this scene
        scene.scene.start(targetScene, data);
    });
}

// ──── Helper: Volume + Fullscreen Controls ────
function createHeaderControls(scene) {
    // Add fade-in effect when scene starts
    scene.cameras.main.fadeIn(300, 0, 0, 0);

    // Volume (Now on the left side)
    const volBtn = scene.add.image(550, 45, scene.sound.mute ? 'mute' : 'volume')
        .setDisplaySize(36, 36).setInteractive({ useHandCursor: true }).setDepth(2000);
    volBtn.on('pointerdown', () => {
        scene.sound.mute = !scene.sound.mute;
        volBtn.setTexture(scene.sound.mute ? 'mute' : 'volume');
        volBtn.setDisplaySize(36, 36);
    });

    // Fullscreen (Now on the right side)
    const fsBtn = scene.add.image(605, 45, 'fullscreen')
        .setDisplaySize(36, 36).setInteractive({ useHandCursor: true }).setDepth(2000);
    fsBtn.on('pointerdown', () => {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen().catch(err => {
                console.error(`Fullscreen failed: ${err.message}`);
            });
        } else {
            if (document.exitFullscreen) {
                document.exitFullscreen();
            }
        }
    });
}

// ──────────────────────────────────────────────
// BOOT SCENE — preload all assets
// ──────────────────────────────────────────────
class BootScene extends Phaser.Scene {
    constructor() { super('BootScene'); }

    preload() {
        const W = this.cameras.main.width;
        const H = this.cameras.main.height;

        let progressBox = this.add.graphics();
        let progressBar = this.add.graphics();
        progressBox.fillStyle(0x222222, 0.8);
        progressBox.fillRoundedRect(W / 2 - 160, H / 2 - 25, 320, 50, 10);

        let loadingText = this.make.text({
            x: W / 2, y: H / 2 - 50,
            text: 'Loading Gyan Setu Adventure...',
            style: { font: '20px Arial', fill: '#ffffff' }
        }).setOrigin(0.5);

        this.load.on('progress', (v) => {
            progressBar.clear();
            progressBar.fillStyle(0x4e54c8, 1);
            progressBar.fillRoundedRect(W / 2 - 150, H / 2 - 15, 300 * v, 30, 5);
        });
        this.load.on('complete', () => {
            progressBar.destroy();
            progressBox.destroy();
            loadingText.destroy();
        });

        // Images
        this.load.image('background', 'assets/background.png');
        this.load.image('hammer', 'assets/hammer.png');
        this.load.image('heart', 'assets/icon_health.png');
        this.load.image('volume', 'assets/volume.png');
        this.load.image('mute', 'assets/mute.png');
        this.load.image('coin', 'assets/Coin.png');
        this.load.image('coin2', 'assets/coin2.png');
        this.load.image('proud', 'assets/proud.png');
        this.load.image('scoreboard', 'assets/scoreboard.png');
        this.load.image('home', 'assets/home.png');
        this.load.image('replay', 'assets/replay.png');
        this.load.image('menu', 'assets/menu.png');
        this.load.image('hint_icon', 'assets/hint.svg');
        this.load.image('fullscreen', 'assets/full screen.png');
        this.load.image('child_back', '../assets/images/website/child back button.png');
        this.load.image('mode_bg', 'assets/mode_bg.jpg');
        this.load.image('topic_bg', 'assets/topic_bg.jpg');
        this.load.image('vocab_card', 'assets/vocab card.png');
        this.load.image('grammar_card', 'assets/grammar card.png');
        this.load.image('tut_hint', 'assets/tutorial/tut_hint.png');

        // Spritesheet: 1140×1152 → 6×8 = 190×144 per frame
        this.load.spritesheet('spritesheet', 'assets/sprites.png', {
            frameWidth: 190,
            frameHeight: 144
        });

        // Mascot spritesheet: 1774×887 → 4 columns × 2 rows = 443×443 per frame
        this.load.spritesheet('mascot', 'assets/mascot_flyingg.png', {
            frameWidth: 443,
            frameHeight: 443
        });

        // Audio
        this.load.audio('bgm',           'audio/Track 3 (Soothing Backyard) (1).wav');
        this.load.audio('hammer_sfx',    'audio/hammer.mp3');
        this.load.audio('level_complete','audio/level_complete.wav');
        this.load.audio('correct_sfx',   'audio/correct_3.wav');
    }

    create() {
        // Start BGM
        try {
            if (this.cache.audio.exists('bgm')) {
                const music = this.sound.add('bgm', { loop: true, volume: 0.35 });
                music.play();
            }
        } catch (e) {
            console.log('Audio autoplay blocked.');
        }

        // Whack animation (frames 34-38)
        this.anims.create({
            key: 'whack',
            frames: this.anims.generateFrameNumbers('spritesheet', { start: 34, end: 38 }),
            frameRate: 18,
            repeat: 0
        });

        // Mascot flying animation (8 frames across 1774×887 spritesheet)
        this.anims.create({
            key: 'mascot_fly',
            frames: this.anims.generateFrameNumbers('mascot', { start: 0, end: 7 }),
            frameRate: 8,
            repeat: -1
        });

        this.scene.start('LevelSelectScene');
    }
}

// ──────────────────────────────────────────────
// LEVEL SELECT SCENE
// ──────────────────────────────────────────────
class LevelSelectScene extends Phaser.Scene {
    constructor() { super('LevelSelectScene'); }

    create() {
        this.add.image(325, 350, 'mode_bg').setDisplaySize(650, 700);

        // Back button to Dashboard
        const backBtn = this.add.image(35, 45, 'child_back')
            .setDisplaySize(42, 42).setInteractive({ useHandCursor: true }).setDepth(2000);
        backBtn.on('pointerdown', () => {
            window.location.href = '../child-dashboard.php';
        });

        // Marsh Melody Style Title
        const titleY = 75;
        // Outer dark red/orange stroke with shadow
        this.add.text(325, titleY, 'WHACK A MOLE', {
            fontFamily: "'Chewy', cursive, sans-serif",
            fontSize: '65px',
            fill: 'transparent',
            stroke: '#c62828',
            strokeThickness: 20,
            shadow: { offsetX: 0, offsetY: 6, color: '#7f0000', blur: 0, stroke: true, fill: true }
        }).setOrigin(0.5);

        // Inner white stroke
        this.add.text(325, titleY, 'WHACK A MOLE', {
            fontFamily: "'Chewy', cursive, sans-serif",
            fontSize: '65px',
            fill: 'transparent',
            stroke: '#ffffff',
            strokeThickness: 10
        }).setOrigin(0.5);

        // Gradient Fill (simulated with a bright orange/yellow fill)
        this.add.text(325, titleY, 'WHACK A MOLE', {
            fontFamily: "'Chewy', cursive, sans-serif",
            fontSize: '65px',
            fill: '#ffb300'
        }).setOrigin(0.5);

        // UI styling for buttons inspired by the reference image
        // 1: Meadow Mode (Green Leaf style)
        this._mkLevelBtn(325, 220, 'MEADOW MODE', '4 HOLES  •  SLEEPY MOLES', 0x93c437, 0x3d7018, '#3d7018', () => {
            GAME_STATE.tier = 1;
            transitionToScene(this, 'TopicSelectScene');
        });
        
        // 2: Race & Chase (Wood Track style)
        this._mkLevelBtn(325, 360, 'RACE & CHASE', '9 HOLES  •  FAST MOLES', 0xe28743, 0x874015, '#874015', () => {
            GAME_STATE.tier = 2;
            transitionToScene(this, 'TopicSelectScene');
        });
        
        // 3: Bomb Blitz (Red Dynamite style)
        this._mkLevelBtn(325, 500, 'BOMB BLITZ', '9 HOLES  •  BOMBS & TIMERS', 0xdb3b42, 0x6e1b21, '#6e1b21', () => {
            GAME_STATE.tier = 3;
            transitionToScene(this, 'TopicSelectScene');
        });

        // 🎬 Story replay button
        const storyBtnBg = this.add.graphics();
        storyBtnBg.fillStyle(0x4e54c8, 0.9).fillRoundedRect(325 - 90, 605, 180, 42, 12);
        storyBtnBg.lineStyle(3, 0xffffff, 0.8).strokeRoundedRect(325 - 90, 605, 180, 42, 12);
        
        const storyText = this.add.text(325, 626, '🎬 Watch Story', {
            fontFamily: "'Chewy', cursive, sans-serif",
            fontSize: '22px',
            fill: '#ffffff'
        }).setOrigin(0.5);

        const storyZone = this.add.zone(325, 626, 180, 42).setInteractive({ useHandCursor: true });
        storyZone.on('pointerdown', () => {
            if (typeof window.playIntroVideo === 'function') {
                const childMeta = document.querySelector('meta[name="child_id"]');
                const childId = childMeta ? parseInt(childMeta.content) : 0;
                window.playIntroVideo(childId, true);
            }
        });
        storyZone.on('pointerover', () => storyText.setStyle({ fill: '#ffd700' }));
        storyZone.on('pointerout', () => storyText.setStyle({ fill: '#ffffff' }));

        createHeaderControls(this);

        this.input.setDefaultCursor('none');
        this.customCursor = this.add.image(0, 0, 'hammer')
            .setOrigin(0.2, 0.2).setDepth(2000).setScale(1.3);
    }

    update() {
        if (this.customCursor) {
            this.customCursor.setPosition(this.input.x, this.input.y);
            this.customCursor.setRotation(this.input.activePointer.isDown ? -0.5 : 0);
        }
    }

    _mkLevelBtn(x, y, levelName, desc, fillColor, strokeColor, strokeHex, cb) {
        const w = 460;
        const h = 110;
        const g = this.add.graphics();
        
        const drawBtn = (isHover) => {
            g.clear();
            // Drop shadow
            g.fillStyle(0x000000, 0.35).fillRoundedRect(x - w/2 + 6, y - h/2 + 8, w, h, 30);
            // Base button
            g.fillStyle(fillColor, isHover ? 0.9 : 1).fillRoundedRect(x - w/2, y - h/2, w, h, 30);
            // Inner highlight / stroke
            g.lineStyle(8, strokeColor, 1).strokeRoundedRect(x - w/2, y - h/2, w, h, 30);
            g.lineStyle(3, 0xffffff, isHover ? 0.7 : 0.4).strokeRoundedRect(x - w/2 + 6, y - h/2 + 6, w - 12, h - 12, 24);
        };
        drawBtn(false);

        const nameT = this.add.text(x, y - 18, levelName, {
            fontFamily: '"Impact","Arial Black",sans-serif', fontSize: '42px',
            fill: '#ffffff', stroke: strokeHex, strokeThickness: 8,
            shadow: { offsetX: 0, offsetY: 4, color: '#000000', blur: 0, stroke: true, fill: true }
        }).setOrigin(0.5);

        const descT = this.add.text(x, y + 28, desc, {
            fontFamily: '"Impact","Arial Black",sans-serif', fontSize: '22px', 
            fill: '#ffffff', stroke: '#000000', strokeThickness: 5
        }).setOrigin(0.5);

        const zone = this.add.zone(x, y, w, h).setInteractive({ useHandCursor: true });
        zone.on('pointerover', () => { 
            nameT.setScale(1.05); descT.setScale(1.05); 
            drawBtn(true);
        });
        zone.on('pointerout',  () => { 
            nameT.setScale(1); descT.setScale(1); 
            drawBtn(false);
        });
        zone.on('pointerdown', cb);
    }
}

// ──────────────────────────────────────────────
// TOPIC SELECT SCENE  (Vocabulary vs Grammar)
// ──────────────────────────────────────────────
class TopicSelectScene extends Phaser.Scene {
    constructor() { super('TopicSelectScene'); }

    create() {
        this.add.image(325, 350, 'mode_bg').setDisplaySize(650, 700);
        
        // Semi-transparent overlay to make the busy cards pop
        this.add.graphics().fillStyle(0x000000, 0.45).fillRect(0, 0, 650, 700);

        const tierNames = ['', 'EASY', 'MEDIUM', 'HARD'];

        // Title Wooden Board (covers top sky/sun)
        const titleBg = this.add.graphics();
        titleBg.fillStyle(0x8b5a2b, 1);
        titleBg.fillRoundedRect(125, 15, 400, 80, 20);
        titleBg.lineStyle(8, 0x5c3a21, 1);
        titleBg.strokeRoundedRect(125, 15, 400, 80, 20);
        
        // Nails for the wooden board
        titleBg.fillStyle(0x333333, 1);
        titleBg.fillCircle(150, 35, 6);
        titleBg.fillCircle(500, 35, 6);
        titleBg.fillCircle(150, 75, 6);
        titleBg.fillCircle(500, 75, 6);

        this.add.text(325, 55, `${tierNames[GAME_STATE.tier]} TOPICS`, {
            fontFamily: '"Impact","Arial Black",sans-serif',
            fontSize: '44px', fill: '#ffdfa3',
            align: 'center', stroke: '#3e2723', strokeThickness: 8,
            shadow: { offsetX: 0, offsetY: 4, color: '#000000', blur: 0, stroke: true, fill: true }
        }).setOrigin(0.5);

        // Vocabulary Card Image (shifted up and scaled down)
        this._mkTopicCard(325, 230, 'vocab_card', () => {
            GAME_STATE.topic = 'vocabulary';
            this._loadAndStart();
        });

        // Interactive tutorial hint button (tut_hint.png) by the right side of Vocabulary card in Meadow Mode (Tier 1)
        if (GAME_STATE.tier === 1) {
            const tutHintBtn = this.add.image(525, 230, 'tut_hint')
                .setDisplaySize(55, 55).setInteractive({ useHandCursor: true }).setDepth(1500);

            tutHintBtn.on('pointerover', () => tutHintBtn.setDisplaySize(60, 60));
            tutHintBtn.on('pointerout',  () => tutHintBtn.setDisplaySize(55, 55));

            tutHintBtn.on('pointerdown', () => {
                if (typeof window.showTutorialLesson === 'function') {
                    window.showTutorialLesson();
                }
            });
        }

        // Grammar Card Image (shifted down to add spacing)
        this._mkTopicCard(325, 430, 'grammar_card', () => {
            GAME_STATE.topic = 'grammar';
            this._loadAndStart();
        });

        // Large Wooden Back Button (Arrow shape)
        this._mkWoodenBackBtn(325, 570, () => {
            transitionToScene(this, 'LevelSelectScene');
        });

        createHeaderControls(this);

        this.input.setDefaultCursor('none');
        this.customCursor = this.add.image(0, 0, 'hammer')
            .setOrigin(0.2, 0.2).setDepth(2000).setScale(1.3);

        // Loading text
        this.loadingMsg = this.add.text(325, 650, '', {
            fontFamily: '"Impact","Arial Black",sans-serif', fontSize: '22px', 
            fill: '#ffd700', align: 'center', stroke: '#000000', strokeThickness: 5
        }).setOrigin(0.5).setDepth(100);
    }

    update() {
        if (this.customCursor) {
            this.customCursor.setPosition(this.input.x, this.input.y);
            this.customCursor.setRotation(this.input.activePointer.isDown ? -0.5 : 0);
        }
    }

    _loadAndStart() {
        this.loadingMsg.setText('Loading questions...');
        const url = `database/get_questions.php?topic=${GAME_STATE.topic}&tier=${GAME_STATE.tier}`;
        const scenes = { 1: 'EasyLevelScene', 2: 'MediumLevelScene', 3: 'HardLevelScene' };
        const targetScene = scenes[GAME_STATE.tier] || 'EasyLevelScene';

        const useFallback = (reason) => {
            console.warn('Using built-in fallback questions:', reason);
            QUESTIONS = getFallbackQuestions(GAME_STATE.topic, GAME_STATE.tier);
            transitionToScene(this, targetScene);
        };

        fetch(url)
            .then(r => {
                if (!r.ok) throw new Error(`HTTP ${r.status}`);
                return r.json();
            })
            .then(data => {
                if (data.error || !data.questions || data.questions.length === 0) {
                    useFallback(data.error || 'empty question list from server');
                    return;
                }
                QUESTIONS = data.questions;
                transitionToScene(this, targetScene);
            })
            .catch(err => {
                console.error('Question load error:', err);
                useFallback(err.message);
            });
    }


    _mkTopicCard(x, y, textureKey, cb) {
        const img = this.add.image(x, y, textureKey).setInteractive({ useHandCursor: true });
        
        // Force the image width to 380px and scale the height proportionally
        img.displayWidth = 380;
        img.scaleY = img.scaleX;
        
        const baseScale = img.scaleX;
        const hoverScale = baseScale * 1.05;

        img.on('pointerover', () => { 
            img.setScale(hoverScale); 
        });
        
        img.on('pointerout',  () => { 
            img.setScale(baseScale); 
        });
        
        img.on('pointerdown', cb);
    }

    _mkWoodenBackBtn(x, y, cb) {
        const w = 320;
        const h = 70;
        const g = this.add.graphics();
        
        const drawBtn = (isHover) => {
            g.clear();
            g.fillStyle(0x000000, 0.4).fillRoundedRect(x - w/2 + 6, y - h/2 + 6, w, h, 15);
            g.fillStyle(0xa0522d, isHover ? 0.9 : 1).fillRoundedRect(x - w/2, y - h/2, w, h, 15);
            g.lineStyle(6, 0x5c3a21, 1).strokeRoundedRect(x - w/2, y - h/2, w, h, 15);
            g.lineStyle(2, 0xd2691e, isHover ? 0.8 : 0.5).strokeRoundedRect(x - w/2 + 4, y - h/2 + 4, w - 8, h - 8, 12);
            
            // Draw a neat wooden arrow tip on the left side
            g.fillStyle(0x000000, 0.4).fillTriangle(x - w/2 - 25, y + 6, x - w/2 + 5, y - 30 + 6, x - w/2 + 5, y + 30 + 6);
            g.fillStyle(0xa0522d, isHover ? 0.9 : 1).fillTriangle(x - w/2 - 25, y, x - w/2 + 5, y - 30, x - w/2 + 5, y + 30);
            g.lineStyle(6, 0x5c3a21, 1).strokeTriangle(x - w/2 - 25, y, x - w/2 + 5, y - 30, x - w/2 + 5, y + 30);
        };
        drawBtn(false);

        const txt = this.add.text(x + 10, y, "⬅ Back to Levels", {
            fontFamily: '"Impact","Arial Black",sans-serif', fontSize: '28px',
            fill: '#ffdfa3', stroke: '#3e2723', strokeThickness: 6
        }).setOrigin(0.5);

        const zone = this.add.zone(x, y, w + 60, h).setInteractive({ useHandCursor: true });
        zone.on('pointerover', () => { txt.setScale(1.05); drawBtn(true); });
        zone.on('pointerout',  () => { txt.setScale(1); drawBtn(false); });
        zone.on('pointerdown', cb);
    }
}

// ──────────────────────────────────────────────
// BASE GAME SCENE — shared logic for all levels
// ──────────────────────────────────────────────
class BaseGameScene extends Phaser.Scene {
    constructor(key) { super(key); }

    init() {
        this.currentQuestionIndex = 0;
        this.score = 0;          // correct answers
        this.health = 6;
        this.moles = [];
        this.labels = [];
        this.hearts = [];
        this.hintPopup = null;
        this.hintBg = null;
        this.streak = 0;
        this.maxStreak = 0;
    }

    // ── cursor ──
    createCustomCursor() {
        this.input.setDefaultCursor('none');
        this.customCursor = this.add.image(0, 0, 'hammer')
            .setOrigin(0.2, 0.2).setDepth(2000).setScale(1.3);
    }
    updateCursor() {
        if (!this.customCursor) return;
        this.customCursor.setPosition(this.input.x, this.input.y);
        this.customCursor.setRotation(this.input.activePointer.isDown ? -0.5 : 0);
    }

    // ── volume button ──
    createVolumeButton() {
        createHeaderControls(this);
    }

    // ── score display box ──
    drawScoreBox(x, y) {
        const bg = this.add.graphics();
        bg.fillStyle(0xffd700, 1);
        bg.fillRoundedRect(x - 65, y - 20, 130, 40, 8);
        bg.lineStyle(2, 0xffffff, 1);
        bg.strokeRoundedRect(x - 65, y - 20, 130, 40, 8);

        this.scoreText = this.add.text(x, y, 'Score: 0', {
            fontFamily: 'Arial', fontSize: '20px', fontWeight: 'bold', fill: '#000000'
        }).setOrigin(0.5);
    }

    // ── exit button ──
    createExitButton() {
        const backBtn = this.add.image(35, 45, 'child_back')
            .setDisplaySize(42, 42).setInteractive({ useHandCursor: true }).setDepth(2000);
        backBtn.on('pointerdown', () => {
            this.showExitPrompt();
        });
    }

    showExitPrompt() {
        // Pause gameplay
        this.physics.pause();
        this.tweens.pauseAll();
        if (this.moleTimer) this.moleTimer.paused = true;
        if (this.gameTimerEvent) this.gameTimerEvent.paused = true;

        const overlayGroup = this.add.group();

        // Invisible zone to block clicks beneath the modal
        const blockZone = this.add.zone(325, 350, 650, 700).setInteractive().setDepth(2999);
        overlayGroup.add(blockZone);

        const overlay = this.add.graphics().setDepth(3000);
        overlay.fillStyle(0x000000, 0.75);
        overlay.fillRect(0, 0, 650, 700);
        overlayGroup.add(overlay);

        const box = this.add.graphics().setDepth(3000);
        box.fillStyle(0xffffff, 1);
        box.fillRoundedRect(100, 250, 450, 200, 15);
        box.lineStyle(4, 0x4e54c8, 1);
        box.strokeRoundedRect(100, 250, 450, 200, 15);
        overlayGroup.add(box);

        const text = this.add.text(325, 305, "Do you want to quit this level?\nYour progress will not be saved.", {
            fontFamily: 'Arial', fontSize: '22px', fill: '#000000', align: 'center', fontWeight: 'bold', lineSpacing: 10
        }).setOrigin(0.5).setDepth(3000);
        overlayGroup.add(text);

        // YES Button
        const yesBtn = this.add.graphics().setDepth(3000);
        yesBtn.fillStyle(0xe74c3c, 1).fillRoundedRect(165, 370, 140, 50, 10);
        overlayGroup.add(yesBtn);
        
        const yesTxt = this.add.text(235, 395, "YES, QUIT", {
            fontFamily: 'Arial', fontSize: '18px', fill: '#ffffff', fontWeight: 'bold'
        }).setOrigin(0.5).setDepth(3000);
        overlayGroup.add(yesTxt);
        
        const yesZone = this.add.zone(235, 395, 140, 50).setInteractive({ useHandCursor: true }).setDepth(3001);
        overlayGroup.add(yesZone);
        
        yesZone.on('pointerover', () => yesTxt.setScale(1.1));
        yesZone.on('pointerout', () => yesTxt.setScale(1));
        yesZone.on('pointerdown', () => {
            this.cleanUpScene();
            transitionToScene(this, 'LevelSelectScene');
        });

        // NO Button
        const noBtn = this.add.graphics().setDepth(3000);
        noBtn.fillStyle(0x2ecc71, 1).fillRoundedRect(345, 370, 140, 50, 10);
        overlayGroup.add(noBtn);
        
        const noTxt = this.add.text(415, 395, "NO, STAY", {
            fontFamily: 'Arial', fontSize: '18px', fill: '#ffffff', fontWeight: 'bold'
        }).setOrigin(0.5).setDepth(3000);
        overlayGroup.add(noTxt);
        
        const noZone = this.add.zone(415, 395, 140, 50).setInteractive({ useHandCursor: true }).setDepth(3001);
        overlayGroup.add(noZone);

        noZone.on('pointerover', () => noTxt.setScale(1.1));
        noZone.on('pointerout', () => noTxt.setScale(1));
        noZone.on('pointerdown', () => {
            overlayGroup.destroy(true); // destroy all UI elements
            this.physics.resume();
            this.tweens.resumeAll();
            if (this.moleTimer) this.moleTimer.paused = false;
            if (this.gameTimerEvent) this.gameTimerEvent.paused = false;
        });
    }

    // ── health hearts ──
    drawHealthUI() {
        this.hearts.forEach(h => h.destroy());
        this.hearts = [];
        for (let i = 0; i < 6; i++) {
            const heart = this.add.image(350 + i * 32, 29, 'heart').setScale(0.65);
            if (i >= this.health) heart.setTint(0x333333);
            this.hearts.push(heart);
        }
    }
    decreaseHealth() {
        if (this.health > 0) {
            this.health--;
            this.streak = 0;
            this.drawHealthUI();
            this.cameras.main.shake(200, 0.02);
            if (this.health <= 0) {
                this.cleanUpScene();
                this.scene.start('ResultScene', {
                    success: false,
                    level: this.scene.key,
                    tier: GAME_STATE.tier,
                    topic: GAME_STATE.topic,
                    score: this.score,
                    total: QUESTIONS.length,
                    streak: this.maxStreak
                });
            }
        }
    }

    // ── question + options box ──
    drawQuestionBox() {
        // Box background
        const g = this.add.graphics();
        g.fillStyle(0x1a1a2e, 0.95).fillRoundedRect(20, 527, 610, 162, 15);
        g.lineStyle(4, 0x4e54c8, 1).strokeRoundedRect(20, 527, 610, 162, 15);

        // Question number + text
        this.questionText = this.add.text(325, 558, '', {
            fontFamily: 'Arial', fontSize: '21px', fontWeight: 'bold',
            fill: '#ffffff', align: 'center', wordWrap: { width: 550 }
        }).setOrigin(0.5, 0.5);

        // Options legend (A B / C D layout - centered to their halves)
        this.optionA = this.add.text(175, 608, '', { fontFamily: 'Arial', fontSize: '18px', fill: '#ffd700', wordWrap: { width: 250 } }).setOrigin(0.5, 0);
        this.optionB = this.add.text(475, 608, '', { fontFamily: 'Arial', fontSize: '18px', fill: '#ffd700', wordWrap: { width: 250 } }).setOrigin(0.5, 0);
        this.optionC = this.add.text(175, 642, '', { fontFamily: 'Arial', fontSize: '18px', fill: '#7ec8e3', wordWrap: { width: 250 } }).setOrigin(0.5, 0);
        this.optionD = this.add.text(475, 642, '', { fontFamily: 'Arial', fontSize: '18px', fill: '#7ec8e3', wordWrap: { width: 250 } }).setOrigin(0.5, 0);

        // Hint button
        this._mkHintButton();
    }

    _mkHintButton() {
        const hintBtn = this.add.image(590, 642, 'hint_icon')
            .setDisplaySize(36, 36)
            .setInteractive({ useHandCursor: true });
        hintBtn.on('pointerdown', () => this.showHint());
    }

    showHint() {
        if (this.hintPopup) {
            this.hintPopup.destroy();
            this.hintBg.destroy();
            this.hintPopup = null;
            this.hintBg = null;
            return;
        }
        const qData = QUESTIONS[this.currentQuestionIndex];
        const hintMsg = qData ? `💡 Concept: ${qData.concept}` : '💡 Think carefully!';

        this.hintBg = this.add.graphics().setDepth(1800);
        this.hintBg.fillStyle(0x000000, 0.85).fillRoundedRect(50, 420, 550, 90, 12);
        this.hintBg.lineStyle(2, 0xf39c12, 1).strokeRoundedRect(50, 420, 550, 90, 12);

        this.hintPopup = this.add.text(325, 465, hintMsg, {
            fontFamily: 'Arial', fontSize: '20px', fill: '#ffd700',
            align: 'center', wordWrap: { width: 510 }
        }).setOrigin(0.5).setDepth(1801);

        this.time.delayedCall(3500, () => {
            if (this.hintPopup) { this.hintPopup.destroy(); this.hintPopup = null; }
            if (this.hintBg)    { this.hintBg.destroy();    this.hintBg = null; }
        });
    }

    showQuestion() {
        if (this.currentQuestionIndex >= QUESTIONS.length) {
            this.levelCompleted();
            return;
        }
        const qData = QUESTIONS[this.currentQuestionIndex];
        this.questionText.setText(`${this.currentQuestionIndex + 1}. ${qData.q}`);
        this.optionA.setText(`A: ${qData.options[0]}`);
        this.optionB.setText(`B: ${qData.options[1]}`);
        this.optionC.setText(`C: ${qData.options[2] || ''}`);
        this.optionD.setText(`D: ${qData.options[3] || ''}`);
        this.setupMolesForQuestion();
    }

    playWhackEffect(x, y) {
        const flash = this.add.graphics();
        flash.fillStyle(0xffffff, 0.35).fillCircle(x, y, 45);
        this.time.delayedCall(110, () => flash.destroy());
        // Play hammer SFX
        try { this.sound.play('hammer_sfx', { volume: 0.7 }); } catch(e) {}
    }

    playCorrectEffect(x, y) {
        const star = this.add.text(x, y - 30, '✓ Correct!', {
            fontFamily: 'Arial', fontSize: '22px', fontWeight: 'bold',
            fill: '#2ecc71', stroke: '#000000', strokeThickness: 4
        }).setOrigin(0.5).setDepth(500);
        this.tweens.add({ targets: star, y: y - 80, alpha: 0, duration: 800,
            onComplete: () => star.destroy() });
        try { this.sound.play('correct_sfx', { volume: 0.6 }); } catch(e) {}
    }

    playWrongEffect(x, y) {
        const txt = this.add.text(x, y - 30, '✗ Wrong!', {
            fontFamily: 'Arial', fontSize: '20px', fontWeight: 'bold',
            fill: '#e74c3c', stroke: '#000000', strokeThickness: 4
        }).setOrigin(0.5).setDepth(500);
        this.tweens.add({ targets: txt, y: y - 75, alpha: 0, duration: 750,
            onComplete: () => txt.destroy() });
    }

    levelCompleted() {
        this.cleanUpScene();
        // Play level complete sound
        try { this.sound.play('level_complete', { volume: 0.8 }); } catch(e) {}
        this.scene.start('ResultScene', {
            success: true,
            level: this.scene.key,
            tier: GAME_STATE.tier,
            topic: GAME_STATE.topic,
            score: this.score,
            total: QUESTIONS.length,
            streak: this.maxStreak
        });
    }

    cleanUpScene() { /* overridden in subclasses */ }
}

// ──────────────────────────────────────────────
// EASY LEVEL SCENE  (2×2 layout, 4 static moles)
// ──────────────────────────────────────────────
class EasyLevelScene extends BaseGameScene {
    constructor() { super('EasyLevelScene'); }

    create() {
        this.add.image(325, 350, 'background').setDisplaySize(650, 700);

        this.createExitButton();
        this.createVolumeButton();
        this.drawHealthUI();

        this.drawScoreBox(160, 31);

        // Hole positions (2×2)
        this.holeCoords = [
            { x: 190, y: 215 }, { x: 460, y: 215 },
            { x: 190, y: 390 }, { x: 460, y: 390 }
        ];
        this.holeCoords.forEach(c => {
            this.add.image(c.x, c.y, 'spritesheet', 0).setScale(0.82);
        });

        this.drawQuestionBox();
        this.createCustomCursor();
        this.showQuestion();
    }

    update() { this.updateCursor(); }

    setupMolesForQuestion() {
        this.moles.forEach(m => m.destroy());
        this.labels.forEach(l => l.destroy());
        this.moles = [];
        this.labels = [];

        const qData = QUESTIONS[this.currentQuestionIndex];
        const optLabels = ['A', 'B', 'C', 'D'];

        this.holeCoords.forEach((coord, index) => {
            const moleFrame = (index % 2 === 0) ? 5 : 6;
            const mole = this.add.sprite(coord.x, coord.y - 14, 'spritesheet', moleFrame).setScale(0.82);

            // Option label above mole head
            const label = this.add.text(coord.x, coord.y - 78, optLabels[index], {
                fontFamily: 'Arial', fontSize: '30px', fontWeight: 'bold',
                fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
                backgroundColor: '#00000066', padding: { x: 8, y: 3 }
            }).setOrigin(0.5);

            mole.setInteractive();
            mole.on('pointerdown', () => {
                this.playWhackEffect(coord.x, coord.y);
                mole.play('whack');
                this.moles.forEach(m => m.disableInteractive());

                mole.once('animationcomplete', () => {
                    if (index === qData.correct) {
                        this.score++;
                        this.streak++;
                        this.maxStreak = Math.max(this.maxStreak, this.streak);
                        this.scoreText.setText(`Score: ${this.score}`);
                        this.playCorrectEffect(coord.x, coord.y);
                        this.time.delayedCall(500, () => {
                            this.currentQuestionIndex++;
                            this.showQuestion();
                        });
                    } else {
                        this.playWrongEffect(coord.x, coord.y);
                        this.decreaseHealth();
                        if (this.health > 0) {
                            this.moles.forEach(m => m.setInteractive());
                        }
                    }
                });
            });

            this.moles.push(mole);
            this.labels.push(label);
        });
    }
}

// ──────────────────────────────────────────────
// MEDIUM LEVEL SCENE  (3×3 layout, moving correct mole)
// ──────────────────────────────────────────────
class MediumLevelScene extends BaseGameScene {
    constructor() { super('MediumLevelScene'); }

    init() {
        super.init();
        this.movingTimer = null;
    }

    create() {
        this.add.image(325, 350, 'background').setDisplaySize(650, 700);
        this.createExitButton();
        this.createVolumeButton();
        this.drawHealthUI();

        this.drawScoreBox(160, 31);

        // 3×3 holes
        this.holeCoords = [
            { x: 145, y: 178 }, { x: 325, y: 178 }, { x: 505, y: 178 },
            { x: 145, y: 310 }, { x: 325, y: 310 }, { x: 505, y: 310 },
            { x: 145, y: 442 }, { x: 325, y: 442 }, { x: 505, y: 442 }
        ];
        this.holeCoords.forEach(c => {
            this.add.image(c.x, c.y, 'spritesheet', 0).setScale(0.68);
        });

        this.drawQuestionBox();
        this.createCustomCursor();
        this.showQuestion();
    }

    update() { this.updateCursor(); }

    setupMolesForQuestion() {
        this.clearAllTimers();
        this.clearActiveMoles();

        const qData = QUESTIONS[this.currentQuestionIndex];
        const optLabels = ['A', 'B', 'C', 'D'];

        // Pick 4 random holes for 4 options
        const initialHoles = Phaser.Utils.Array.Shuffle([...Array(9).keys()]).slice(0, 4);

        initialHoles.forEach((holeIdx, optionIdx) => {
            const coord = this.holeCoords[holeIdx];
            const moleFrame = (optionIdx % 2 === 0) ? 5 : 6;
            const mole = this.add.sprite(coord.x, coord.y - 14, 'spritesheet', moleFrame).setScale(0.68);

            const label = this.add.text(coord.x, coord.y - 72, optLabels[optionIdx], {
                fontFamily: 'Arial', fontSize: '26px', fontWeight: 'bold',
                fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
                backgroundColor: '#00000066', padding: { x: 6, y: 2 }
            }).setOrigin(0.5);

            mole.setInteractive();
            mole.on('pointerdown', () => {
                this.playWhackEffect(coord.x, coord.y);
                mole.play('whack');
                this.disableAllMoles();

                mole.once('animationcomplete', () => {
                    if (optionIdx === qData.correct) {
                        this.score++;
                        this.streak++;
                        this.maxStreak = Math.max(this.maxStreak, this.streak);
                        this.scoreText.setText(`Score: ${this.score}`);
                        this.playCorrectEffect(coord.x, coord.y);
                        this.time.delayedCall(400, () => this.startMovingPhase());
                    } else {
                        this.playWrongEffect(coord.x, coord.y);
                        this.decreaseHealth();
                        if (this.health > 0) this.enableAllMoles();
                    }
                });
            });

            this.moles.push({ sprite: mole, label });
        });
    }

    startMovingPhase() {
        this.clearActiveMoles();
        const moveDelay = (this.currentQuestionIndex >= 5) ? 550 : 900;
        this.moveMolesAround();
        this.movingTimer = this.time.addEvent({
            delay: moveDelay, callback: this.moveMolesAround,
            callbackScope: this, loop: true
        });
    }

    moveMolesAround() {
        this.clearActiveMoles();
        const qData = QUESTIONS[this.currentQuestionIndex];
        const optLabels = ['A', 'B', 'C', 'D'];
        const holes = Phaser.Utils.Array.Shuffle([...Array(9).keys()]);

        // Correct mole
        const cc = this.holeCoords[holes[0]];
        const cMole = this.add.sprite(cc.x, cc.y - 14, 'spritesheet', 5).setScale(0.68);
        const cLabel = this.add.text(cc.x, cc.y - 72, optLabels[qData.correct], {
            fontFamily: 'Arial', fontSize: '26px', fontWeight: 'bold',
            fill: '#39ff14', stroke: '#000000', strokeThickness: 4,
            backgroundColor: '#00000066', padding: { x: 6, y: 2 }
        }).setOrigin(0.5);

        cMole.setInteractive();
        cMole.on('pointerdown', () => {
            this.playWhackEffect(cc.x, cc.y);
            cMole.play('whack');
            cMole.disableInteractive();
            this.clearAllTimers();
            cMole.once('animationcomplete', () => {
                this.currentQuestionIndex++;
                this.showQuestion();
            });
        });
        this.moles.push({ sprite: cMole, label: cLabel });

        // 1-2 decoy moles
        const numDecoys = Phaser.Math.Between(1, 2);
        for (let i = 0; i < numDecoys; i++) {
            const dc = this.holeCoords[holes[1 + i]];
            let decoyOpt = Phaser.Math.Between(0, 3);
            while (decoyOpt === qData.correct) decoyOpt = Phaser.Math.Between(0, 3);

            const dMole = this.add.sprite(dc.x, dc.y - 14, 'spritesheet', 6).setScale(0.68);
            const dLabel = this.add.text(dc.x, dc.y - 72, optLabels[decoyOpt], {
                fontFamily: 'Arial', fontSize: '26px', fontWeight: 'bold',
                fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
                backgroundColor: '#00000066', padding: { x: 6, y: 2 }
            }).setOrigin(0.5);

            dMole.setInteractive();
            dMole.on('pointerdown', () => {
                this.playWhackEffect(dc.x, dc.y);
                dMole.play('whack');
                dMole.disableInteractive();
                this.playWrongEffect(dc.x, dc.y);
                this.decreaseHealth();
            });
            this.moles.push({ sprite: dMole, label: dLabel });
        }
    }

    clearActiveMoles() {
        this.moles.forEach(m => { m.sprite?.destroy(); m.label?.destroy(); });
        this.moles = [];
    }
    disableAllMoles() { this.moles.forEach(m => m.sprite?.disableInteractive()); }
    enableAllMoles()  { this.moles.forEach(m => m.sprite?.setInteractive()); }
    clearAllTimers()  {
        if (this.movingTimer) { this.movingTimer.remove(); this.movingTimer = null; }
    }
    cleanUpScene() { this.clearAllTimers(); }
}

// ──────────────────────────────────────────────
// HARD LEVEL SCENE  (3×3, bombs, 40s timer)
// ──────────────────────────────────────────────
class HardLevelScene extends BaseGameScene {
    constructor() { super('HardLevelScene'); }

    init() {
        super.init();
        this.staticPhaseTimer = null;
        this.movingTimer = null;
    }

    create() {
        this.add.image(325, 350, 'background').setDisplaySize(650, 700);
        this.createExitButton();
        this.createVolumeButton();
        this.drawHealthUI();

        this.drawScoreBox(160, 31);

        this.holeCoords = [
            { x: 145, y: 178 }, { x: 325, y: 178 }, { x: 505, y: 178 },
            { x: 145, y: 310 }, { x: 325, y: 310 }, { x: 505, y: 310 },
            { x: 145, y: 442 }, { x: 325, y: 442 }, { x: 505, y: 442 }
        ];
        this.holeCoords.forEach(c => {
            this.add.image(c.x, c.y, 'spritesheet', 0).setScale(0.68);
        });

        this.warningText = this.add.text(325, 122, '', {
            fontFamily: 'Arial', fontSize: '22px', fontWeight: 'bold',
            fill: '#ff4757', align: 'center'
        }).setOrigin(0.5);

        this.drawQuestionBox();
        this.createCustomCursor();
        this.showQuestion();
    }

    update() { this.updateCursor(); }

    setupMolesForQuestion() {
        this.clearAllTimers();
        this.clearActiveMoles();
        this.warningText.setText('');

        const qData = QUESTIONS[this.currentQuestionIndex];
        const optLabels = ['A', 'B', 'C', 'D'];
        const initialHoles = Phaser.Utils.Array.Shuffle([...Array(9).keys()]).slice(0, 4);

        initialHoles.forEach((newHoleIdx, optionIdx) => {
            const coord = this.holeCoords[newHoleIdx];
            const moleFrame = (optionIdx % 2 === 0) ? 5 : 6;
            const mole = this.add.sprite(coord.x, coord.y - 14, 'spritesheet', moleFrame).setScale(0.68);

            const label = this.add.text(coord.x, coord.y - 72, optLabels[optionIdx], {
                fontFamily: 'Arial', fontSize: '26px', fontWeight: 'bold',
                fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
                backgroundColor: '#00000066', padding: { x: 6, y: 2 }
            }).setOrigin(0.5);

            mole.setInteractive();
            mole.on('pointerdown', () => {
                this.playWhackEffect(coord.x, coord.y);
                mole.play('whack');
                this.disableAllMoles();

                mole.once('animationcomplete', () => {
                    if (optionIdx === qData.correct) {
                        this.score++;
                        this.streak++;
                        this.maxStreak = Math.max(this.maxStreak, this.streak);
                        this.scoreText.setText(`Score: ${this.score}`);
                        this.playCorrectEffect(coord.x, coord.y);
                        this.time.delayedCall(400, () => this.startMovingPhase());
                    } else {
                        this.playWrongEffect(coord.x, coord.y);
                        this.decreaseHealth();
                        if (this.health > 0) this.enableAllMoles();
                    }
                });
            });

            this.moles.push({ sprite: mole, label });
        });

        // 40s countdown timer
        let timeLeft = 40;
        this.staticPhaseTimer = this.time.addEvent({
            delay: 1000,
            callback: () => {
                timeLeft--;
                if (timeLeft <= 10 && timeLeft > 0) {
                    this.warningText.setText(`⏱ ${timeLeft}s left!`);
                }
                if (timeLeft <= 0) {
                    this.decreaseHealth();
                    timeLeft = 40;
                    this.warningText.setText('');
                }
            },
            loop: true
        });
    }

    startMovingPhase() {
        this.clearAllTimers();
        this.clearActiveMoles();
        this.warningText.setText('');
        const moveDelay = (this.currentQuestionIndex >= 5) ? 480 : 760;
        this.moveMoleAndBombsAround();
        this.movingTimer = this.time.addEvent({
            delay: moveDelay, callback: this.moveMoleAndBombsAround,
            callbackScope: this, loop: true
        });
    }

    moveMoleAndBombsAround() {
        this.clearActiveMoles();
        const qData = QUESTIONS[this.currentQuestionIndex];
        const optLabels = ['A', 'B', 'C', 'D'];
        const holes = Phaser.Utils.Array.Shuffle([...Array(9).keys()]);

        // Correct mole (green label)
        const cc = this.holeCoords[holes[0]];
        const mFrame = Phaser.Math.Between(5, 6);
        const cMole = this.add.sprite(cc.x, cc.y - 14, 'spritesheet', mFrame).setScale(0.68);
        const cLabel = this.add.text(cc.x, cc.y - 72, optLabels[qData.correct], {
            fontFamily: 'Arial', fontSize: '26px', fontWeight: 'bold',
            fill: '#39ff14', stroke: '#000000', strokeThickness: 4,
            backgroundColor: '#00000066', padding: { x: 6, y: 2 }
        }).setOrigin(0.5);

        cMole.setInteractive();
        cMole.on('pointerdown', () => {
            this.playWhackEffect(cc.x, cc.y);
            cMole.play('whack');
            cMole.disableInteractive();
            this.clearAllTimers();
            cMole.once('animationcomplete', () => {
                this.currentQuestionIndex++;
                this.showQuestion();
            });
        });
        this.moles.push({ sprite: cMole, label: cLabel });

        // 1 decoy mole
        const dc = this.holeCoords[holes[1]];
        let decoyOpt = Phaser.Math.Between(0, 3);
        while (decoyOpt === qData.correct) decoyOpt = Phaser.Math.Between(0, 3);
        const dMole = this.add.sprite(dc.x, dc.y - 14, 'spritesheet', 6).setScale(0.68);
        const dLabel = this.add.text(dc.x, dc.y - 72, optLabels[decoyOpt], {
            fontFamily: 'Arial', fontSize: '26px', fontWeight: 'bold',
            fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
            backgroundColor: '#00000066', padding: { x: 6, y: 2 }
        }).setOrigin(0.5);
        dMole.setInteractive();
        dMole.on('pointerdown', () => {
            this.playWhackEffect(dc.x, dc.y);
            dMole.play('whack');
            dMole.disableInteractive();
            this.playWrongEffect(dc.x, dc.y);
            this.decreaseHealth();
        });
        this.moles.push({ sprite: dMole, label: dLabel });

        // 1-2 bombs (frames 21, 22)
        const numBombs = Phaser.Math.Between(1, 2);
        for (let i = 0; i < numBombs; i++) {
            const bc = this.holeCoords[holes[2 + i]];
            const bombFrame = Phaser.Math.Between(21, 22);
            const bomb = this.add.sprite(bc.x, bc.y - 14, 'spritesheet', bombFrame).setScale(0.75);
            const bombLbl = this.add.text(bc.x, bc.y - 65, '💣', {
                fontFamily: 'Arial', fontSize: '18px'
            }).setOrigin(0.5);

            bomb.setInteractive();
            bomb.on('pointerdown', () => {
                this.playWhackEffect(bc.x, bc.y);
                const boom = this.add.text(bc.x, bc.y - 30, 'BOOM! 💥', {
                    fontFamily: 'Arial', fontSize: '26px', fontWeight: 'bold',
                    fill: '#ff4757', stroke: '#000000', strokeThickness: 5
                }).setOrigin(0.5);
                this.time.delayedCall(400, () => boom.destroy());
                bomb.destroy();
                bombLbl.destroy();
                this.decreaseHealth();
            });
            this.moles.push({ sprite: bomb, label: bombLbl });
        }
    }

    clearActiveMoles() {
        this.moles.forEach(m => { m.sprite?.destroy(); m.label?.destroy(); });
        this.moles = [];
    }
    disableAllMoles() { this.moles.forEach(m => m.sprite?.disableInteractive()); }
    enableAllMoles()  { this.moles.forEach(m => m.sprite?.setInteractive()); }
    clearAllTimers() {
        if (this.staticPhaseTimer) { this.staticPhaseTimer.remove(); this.staticPhaseTimer = null; }
        if (this.movingTimer)      { this.movingTimer.remove();      this.movingTimer = null; }
    }
    cleanUpScene() { this.clearAllTimers(); }
}

// ──────────────────────────────────────────────
// RESULT SCENE  (Full child-friendly results screen)
// ──────────────────────────────────────────────
class ResultScene extends Phaser.Scene {
    constructor() { super('ResultScene'); }

    init(data) {
        this.success  = data.success ?? false;
        this.level    = data.level   ?? 'EasyLevelScene';
        this.tier     = data.tier    ?? 1;
        this.topic    = data.topic   ?? 'grammar';
        this.score    = data.score   ?? 0;
        this.total    = data.total   ?? 10;
        this.streak   = data.streak  ?? 0;
        this.coinsEarned = 0;
        this.badgesEarned = [];
        this.submitted = false;
    }

    create() {
        this.add.image(325, 350, 'background').setDisplaySize(650, 700);

        // Keep the game visible behind the results, while making the board easy to read.
        this.add.graphics().fillStyle(0x000000, 0.58).fillRect(0, 0, 650, 700);

        // Wooden result board (the supplied asset includes the decorative characters).
        this.add.image(325, 310, 'scoreboard').setDisplaySize(600, 328);

        this.add.text(325, 195, 'SCORE', {
            fontFamily: '"Arial Black",Arial,sans-serif', fontSize: '28px',
            fontStyle: 'bold', fill: '#17100a'
        }).setOrigin(0.5);

        this.add.text(325, 232, `${this.score} / ${this.total}`, {
            fontFamily: '"Arial Black",Arial,sans-serif', fontSize: '36px',
            fontStyle: 'bold', fill: '#17100a'
        }).setOrigin(0.5);

        // Coins display with the supplied coin artwork.
        this.coinImg = this.add.image(274, 272, 'coin2').setDisplaySize(38, 38);
        this.coinsText = this.add.text(304, 272, '+0 Coins', {
            fontFamily: '"Arial Black",Arial,sans-serif', fontSize: '20px',
            fontStyle: 'bold', fill: '#17100a'
        }).setOrigin(0, 0.5);

        // Badges notification area (positioned cleanly between coins and stats)
        this.badgeArea = this.add.text(325, 312, '', {
            fontFamily: 'Arial,sans-serif', fontSize: '13px', fill: '#4a2c00',
            fontStyle: 'bold', align: 'center', wordWrap: { width: 340 }
        }).setOrigin(0.5);

        const accuracy = this.total > 0 ? Math.round((this.score / this.total) * 100) : 0;

        this._statRow(210, 368, 'Accuracy', `${accuracy}%`);
        this._statRow(440, 368, 'Best Streak', `${this.streak} in a row`);

        // The icon buttons retain the existing destinations and game flow.
        this._mkIconBtn(205, 500, 'home', () => {
            window.location.href = '../child-dashboard.php';
        });
        this._mkIconBtn(325, 492, 'replay', () => {
            transitionToScene(this, 'TopicSelectScene');
        });
        this._mkIconBtn(445, 500, 'menu', () => {
            transitionToScene(this, 'LevelSelectScene');
        });

        // Custom cursor
        this.input.setDefaultCursor('none');
        this.customCursor = this.add.image(0, 0, 'hammer')
            .setOrigin(0.2, 0.2).setDepth(2000).setScale(1.3);

        // Submit score to server
        this._submitScore();
    }

    update() {
        if (this.customCursor) {
            this.customCursor.setPosition(this.input.x, this.input.y);
            this.customCursor.setRotation(this.input.activePointer.isDown ? -0.5 : 0);
        }
    }

    _statRow(x, y, label, value) {
        this.add.text(x, y, label, {
            fontFamily: 'Arial,sans-serif', fontSize: '19px', fontStyle: 'bold',
            fill: '#17100a'
        }).setOrigin(0.5);
        this.add.text(x, y + 25, value, {
            fontFamily: 'Arial,sans-serif', fontSize: '18px', fontStyle: 'bold',
            fill: '#7d3f13'
        }).setOrigin(0.5);
    }

    _mkIconBtn(x, y, texture, cb) {
        const shadow = this.add.ellipse(x, y + 42, 64, 13, 0x000000, 0.3);
        const icon = this.add.image(x, y, texture).setDisplaySize(90, 90)
            .setInteractive({ useHandCursor: true });
        const baseScale = icon.scaleX;
        icon.on('pointerover', () => {
            icon.setScale(baseScale * 1.08);
            shadow.setScale(0.9);
        });
        icon.on('pointerout', () => {
            icon.setScale(baseScale);
            shadow.setScale(1);
        });
        icon.on('pointerdown', cb);
    }

    _submitScore() {
        if (this.submitted) return;
        this.submitted = true;

        // Get child_id from meta tag if available (set by index.php)
        const childMeta = document.querySelector('meta[name="child_id"]');
        const childId = childMeta ? parseInt(childMeta.content) : 0;

        const concept = (QUESTIONS.length > 0 && QUESTIONS[0].concept) ? QUESTIONS[0].concept : '';
        const perCorrect = [0, 1, 2, 3][this.tier] || 1;

        const form = new FormData();
        form.append('child_id',       childId);
        form.append('game_id',        1);
        form.append('tier',           this.tier);
        form.append('topic',          this.topic);
        form.append('concept',        concept);
        form.append('correct_count',  this.score);
        form.append('total_questions',this.total);
        form.append('streak',         this.streak);

        // Show coins immediately (will be updated if server responds)
        this.coinsText.setText(`+${this.score * perCorrect} Coins`);

        fetch('database/submit_score.php', { method: 'POST', body: form })
            .then(r => {
                if (!r.ok) throw new Error(`HTTP ${r.status}`);
                return r.text();
            })
            .then(text => {
                // Try to parse JSON — server may have output warnings before the JSON
                let data;
                try {
                    // Find the JSON object in case there's stray output before it
                    const jsonStart = text.indexOf('{');
                    if (jsonStart >= 0) {
                        data = JSON.parse(text.substring(jsonStart));
                    } else {
                        throw new Error('No JSON in response');
                    }
                } catch (e) {
                    console.warn('Could not parse score response:', e, text);
                    return; // keep the coins text we already set
                }

                if (data.coins_earned !== undefined) {
                    this.coinsText.setText(`+${data.coins_earned} Coins`);
                }
                if (data.new_badges && data.new_badges.length > 0) {
                    if (data.new_badges.length === 1) {
                        const b = data.new_badges[0];
                        this.badgeArea.setText(`🏅 Unlocked: ${b.title} (+${b.coins_reward || 0} coins)`);
                    } else {
                        const names = data.new_badges.slice(0, 2).map(b => b.title).join(', ');
                        const extra = data.new_badges.length > 2 ? ` +${data.new_badges.length - 2} more` : '';
                        const totalBonus = data.new_badges.reduce((sum, b) => sum + (parseInt(b.coins_reward) || 0), 0);
                        this.badgeArea.setText(`🏅 Unlocked: ${names}${extra} (+${totalBonus} coins)`);
                    }
                }
            })
            .catch(err => {
                // Network error — coins text is already set above, nothing else to do
                console.warn('Score submission failed:', err);
            });
    }
}

// ──────────────────────────────────────────────
// PHASER CONFIG
// ──────────────────────────────────────────────
const config = {
    type: Phaser.AUTO,
    width: 650,
    height: 700,
    parent: 'game-container',
    scale: {
        mode: Phaser.Scale.FIT,
        autoCenter: Phaser.Scale.CENTER_BOTH
    },
    physics: {
        default: 'arcade',
        arcade: { debug: false }
    },
    scene: [BootScene, LevelSelectScene, TopicSelectScene,
            EasyLevelScene, MediumLevelScene, HardLevelScene, ResultScene]
};

const game = new Phaser.Game(config);

// Recalculate pointer/hit zones on fullscreen toggle or window resize
document.addEventListener('fullscreenchange', () => {
    setTimeout(() => {
        if (game && game.scale) {
            game.scale.refresh();
        }
    }, 100);
});

window.addEventListener('resize', () => {
    setTimeout(() => {
        if (game && game.scale) {
            game.scale.refresh();
        }
    }, 100);
});
