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
        this.load.image('hint_icon', 'assets/hint.svg');

        // Spritesheet: 1140×1152 → 6×8 = 190×144 per frame
        this.load.spritesheet('spritesheet', 'assets/sprites.png', {
            frameWidth: 190,
            frameHeight: 144
        });

        // Mascot spritesheet: 1774×887 → assume 5 frames wide × 2 rows = 354×443
        this.load.spritesheet('mascot', 'assets/mascot_flyingg.png', {
            frameWidth: 355,
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

        // Mascot flying animation (10 frames across 1774×887 spritesheet)
        this.anims.create({
            key: 'mascot_fly',
            frames: this.anims.generateFrameNumbers('mascot', { start: 0, end: 9 }),
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
        this.add.image(325, 350, 'background').setDisplaySize(650, 700);

        // Dark overlay
        this.add.graphics()
            .fillStyle(0x000000, 0.45)
            .fillRect(0, 0, 650, 700);

        // Title box
        const titleBg = this.add.graphics();
        titleBg.fillStyle(0x4e54c8, 0.88);
        titleBg.fillRoundedRect(50, 40, 550, 100, 15);
        titleBg.lineStyle(4, 0xffd700, 1);
        titleBg.strokeRoundedRect(50, 40, 550, 100, 15);

        this.add.text(325, 90, 'WORD WHACK\nLEARNING ZONE', {
            fontFamily: '"Impact","Arial Black",sans-serif',
            fontSize: '32px', fill: '#ffffff',
            align: 'center', stroke: '#000000', strokeThickness: 5
        }).setOrigin(0.5);

        // Level buttons
        this._mkLevelBtn(325, 230, 'EASY', '4 Holes · Static Moles · Tier 1',    0x2ecc71, () => {
            GAME_STATE.tier = 1;
            this.scene.start('TopicSelectScene');
        });
        this._mkLevelBtn(325, 370, 'MEDIUM', '9 Holes · Moving Moles · Tier 2',  0xe67e22, () => {
            GAME_STATE.tier = 2;
            this.scene.start('TopicSelectScene');
        });
        this._mkLevelBtn(325, 510, 'HARD', '9 Holes · Bombs & Timers · Tier 3',  0xe74c3c, () => {
            GAME_STATE.tier = 3;
            this.scene.start('TopicSelectScene');
        });

        this._mkVolumeBtn();

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

    _mkVolumeBtn() {
        const volBtn = this.add.image(615, 35, this.sound.mute ? 'mute' : 'volume')
            .setDisplaySize(38, 38).setInteractive({ useHandCursor: true }).setDepth(2000);
        volBtn.on('pointerdown', () => {
            this.sound.mute = !this.sound.mute;
            volBtn.setTexture(this.sound.mute ? 'mute' : 'volume');
        });
    }

    _mkLevelBtn(x, y, levelName, desc, color, cb) {
        const g = this.add.graphics();
        g.fillStyle(color, 0.9).fillRoundedRect(x - 200, y - 45, 400, 90, 15);
        g.lineStyle(3, 0xffffff, 1).strokeRoundedRect(x - 200, y - 45, 400, 90, 15);

        const nameT = this.add.text(x, y - 14, levelName, {
            fontFamily: 'Arial', fontSize: '28px', fontWeight: 'bold',
            fill: '#ffffff', stroke: '#000000', strokeThickness: 4
        }).setOrigin(0.5);

        const descT = this.add.text(x, y + 20, desc, {
            fontFamily: 'Arial', fontSize: '13px', fill: '#ffffff', fontWeight: '600'
        }).setOrigin(0.5);

        const zone = this.add.zone(x, y, 400, 90).setInteractive({ useHandCursor: true });
        zone.on('pointerover', () => { nameT.setScale(1.07); descT.setScale(1.03); });
        zone.on('pointerout',  () => { nameT.setScale(1);    descT.setScale(1); });
        zone.on('pointerdown', cb);
    }
}

// ──────────────────────────────────────────────
// TOPIC SELECT SCENE  (Vocabulary vs Grammar)
// ──────────────────────────────────────────────
class TopicSelectScene extends Phaser.Scene {
    constructor() { super('TopicSelectScene'); }

    create() {
        this.add.image(325, 350, 'background').setDisplaySize(650, 700);
        this.add.graphics().fillStyle(0x000000, 0.5).fillRect(0, 0, 650, 700);

        const tierNames = ['', 'EASY', 'MEDIUM', 'HARD'];
        const tierColors = [0, 0x2ecc71, 0xe67e22, 0xe74c3c];

        // Header
        const hg = this.add.graphics();
        hg.fillStyle(tierColors[GAME_STATE.tier], 0.88);
        hg.fillRoundedRect(50, 50, 550, 90, 15);
        hg.lineStyle(4, 0xffd700, 1);
        hg.strokeRoundedRect(50, 50, 550, 90, 15);

        this.add.text(325, 95, `${tierNames[GAME_STATE.tier]} — Choose Your Topic`, {
            fontFamily: '"Impact","Arial Black",sans-serif',
            fontSize: '26px', fill: '#ffffff',
            align: 'center', stroke: '#000000', strokeThickness: 4
        }).setOrigin(0.5);

        // Vocabulary button
        this._mkTopicBtn(325, 270, '📖 Vocabulary',
            'Words, meanings & spelling', 0x9b59b6, () => {
            GAME_STATE.topic = 'vocabulary';
            this._loadAndStart();
        });

        // Grammar button
        this._mkTopicBtn(325, 420, '✏️ Grammar',
            'Sentences, tenses & rules', 0x2980b9, () => {
            GAME_STATE.topic = 'grammar';
            this._loadAndStart();
        });

        // Back button
        this._mkSmallBtn(325, 570, '← Back to Levels', () => {
            this.scene.start('LevelSelectScene');
        });

        this._mkVolumeBtn();

        this.input.setDefaultCursor('none');
        this.customCursor = this.add.image(0, 0, 'hammer')
            .setOrigin(0.2, 0.2).setDepth(2000).setScale(1.3);

        // Loading text (hidden until needed)
        this.loadingMsg = this.add.text(325, 635, '', {
            fontFamily: 'Arial', fontSize: '15px', fill: '#ffd700', align: 'center'
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
        fetch(url)
            .then(r => r.json())
            .then(data => {
                if (data.error || !data.questions || data.questions.length === 0) {
                    this.loadingMsg.setText('❌ No questions found. Try another topic.');
                    return;
                }
                QUESTIONS = data.questions;
                const scenes = { 1: 'EasyLevelScene', 2: 'MediumLevelScene', 3: 'HardLevelScene' };
                this.scene.start(scenes[GAME_STATE.tier] || 'EasyLevelScene');
            })
            .catch(err => {
                console.error('Question load error:', err);
                this.loadingMsg.setText('⚠️ Could not load questions. Check connection.');
            });
    }

    _mkTopicBtn(x, y, title, subtitle, color, cb) {
        const g = this.add.graphics();
        g.fillStyle(color, 0.88).fillRoundedRect(x - 210, y - 55, 420, 110, 18);
        g.lineStyle(3, 0xffffff, 0.9).strokeRoundedRect(x - 210, y - 55, 420, 110, 18);

        const tT = this.add.text(x, y - 15, title, {
            fontFamily: 'Arial', fontSize: '26px', fontWeight: 'bold',
            fill: '#ffffff', stroke: '#000000', strokeThickness: 4
        }).setOrigin(0.5);

        const sT = this.add.text(x, y + 22, subtitle, {
            fontFamily: 'Arial', fontSize: '14px', fill: '#f0f0f0'
        }).setOrigin(0.5);

        const zone = this.add.zone(x, y, 420, 110).setInteractive({ useHandCursor: true });
        zone.on('pointerover', () => { tT.setScale(1.06); sT.setScale(1.03); });
        zone.on('pointerout',  () => { tT.setScale(1);    sT.setScale(1); });
        zone.on('pointerdown', cb);
    }

    _mkSmallBtn(x, y, label, cb) {
        const g = this.add.graphics();
        g.fillStyle(0x555555, 0.8).fillRoundedRect(x - 130, y - 22, 260, 44, 10);
        g.lineStyle(2, 0xcccccc, 1).strokeRoundedRect(x - 130, y - 22, 260, 44, 10);
        const t = this.add.text(x, y, label, {
            fontFamily: 'Arial', fontSize: '16px', fontWeight: 'bold', fill: '#ffffff'
        }).setOrigin(0.5);
        const z = this.add.zone(x, y, 260, 44).setInteractive({ useHandCursor: true });
        z.on('pointerover', () => t.setStyle({ fill: '#ffd700' }));
        z.on('pointerout',  () => t.setStyle({ fill: '#ffffff' }));
        z.on('pointerdown', cb);
    }

    _mkVolumeBtn() {
        const v = this.add.image(615, 35, this.sound.mute ? 'mute' : 'volume')
            .setDisplaySize(38, 38).setInteractive({ useHandCursor: true }).setDepth(2000);
        v.on('pointerdown', () => {
            this.sound.mute = !this.sound.mute;
            v.setTexture(this.sound.mute ? 'mute' : 'volume');
        });
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
        const v = this.add.image(615, 35, this.sound.mute ? 'mute' : 'volume')
            .setDisplaySize(38, 38).setInteractive({ useHandCursor: true }).setDepth(2000);
        v.on('pointerdown', () => {
            this.sound.mute = !this.sound.mute;
            v.setTexture(this.sound.mute ? 'mute' : 'volume');
        });
    }

    // ── exit button ──
    createExitButton() {
        const g = this.add.graphics();
        g.fillStyle(0xe74c3c, 0.9).fillRoundedRect(10, 10, 75, 32, 8);
        const t = this.add.text(47, 26, 'Exit', {
            fontFamily: 'Arial', fontSize: '15px', fontWeight: 'bold', fill: '#ffffff'
        }).setOrigin(0.5);
        const z = this.add.zone(47, 26, 75, 32).setInteractive({ useHandCursor: true });
        z.on('pointerdown', () => {
            this.cleanUpScene();
            this.scene.start('LevelSelectScene');
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
            fontFamily: 'Arial', fontSize: '17px', fontWeight: 'bold',
            fill: '#ffffff', align: 'center', wordWrap: { width: 570 }
        }).setOrigin(0.5, 0.5);

        // Options legend (A B / C D layout)
        this.optionA = this.add.text(115, 605, '', { fontFamily: 'Arial', fontSize: '15px', fill: '#ffd700', wordWrap: { width: 190 } }).setOrigin(0.5, 0);
        this.optionB = this.add.text(325, 605, '', { fontFamily: 'Arial', fontSize: '15px', fill: '#ffd700', wordWrap: { width: 190 } }).setOrigin(0.5, 0);
        this.optionC = this.add.text(115, 635, '', { fontFamily: 'Arial', fontSize: '15px', fill: '#7ec8e3', wordWrap: { width: 190 } }).setOrigin(0.5, 0);
        this.optionD = this.add.text(325, 635, '', { fontFamily: 'Arial', fontSize: '15px', fill: '#7ec8e3', wordWrap: { width: 190 } }).setOrigin(0.5, 0);

        // Hint button
        this._mkHintButton();
    }

    _mkHintButton() {
        const hintBg = this.add.graphics();
        hintBg.fillStyle(0xf39c12, 0.9).fillRoundedRect(540, 658, 90, 28, 8);
        hintBg.lineStyle(2, 0xffd700, 1).strokeRoundedRect(540, 658, 90, 28, 8);
        const hintText = this.add.text(585, 672, '💡 Hint', {
            fontFamily: 'Arial', fontSize: '14px', fontWeight: 'bold', fill: '#ffffff'
        }).setOrigin(0.5);
        const hintZone = this.add.zone(585, 672, 90, 28).setInteractive({ useHandCursor: true });
        hintZone.on('pointerdown', () => this.showHint());
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
        this.hintBg.fillStyle(0x000000, 0.75).fillRoundedRect(75, 440, 500, 70, 12);
        this.hintBg.lineStyle(2, 0xf39c12, 1).strokeRoundedRect(75, 440, 500, 70, 12);

        this.hintPopup = this.add.text(325, 475, hintMsg, {
            fontFamily: 'Arial', fontSize: '16px', fill: '#ffd700',
            align: 'center', wordWrap: { width: 470 }
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

        // Score display
        this.scoreText = this.add.text(100, 29, 'Score: 0', {
            fontFamily: 'Arial', fontSize: '16px', fontWeight: 'bold', fill: '#ffd700'
        }).setOrigin(0.5);

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
            const label = this.add.text(coord.x, coord.y - 72, optLabels[index], {
                fontFamily: 'Arial', fontSize: '22px', fontWeight: 'bold',
                fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
                backgroundColor: '#00000066', padding: { x: 6, y: 2 }
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

        this.scoreText = this.add.text(200, 29, 'Score: 0', {
            fontFamily: 'Arial', fontSize: '16px', fontWeight: 'bold', fill: '#ffd700'
        }).setOrigin(0.5);

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

            const label = this.add.text(coord.x, coord.y - 65, optLabels[optionIdx], {
                fontFamily: 'Arial', fontSize: '20px', fontWeight: 'bold',
                fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
                backgroundColor: '#00000066', padding: { x: 5, y: 2 }
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
        const cLabel = this.add.text(cc.x, cc.y - 65, optLabels[qData.correct], {
            fontFamily: 'Arial', fontSize: '20px', fontWeight: 'bold',
            fill: '#39ff14', stroke: '#000000', strokeThickness: 4,
            backgroundColor: '#00000066', padding: { x: 5, y: 2 }
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
            const dLabel = this.add.text(dc.x, dc.y - 65, optLabels[decoyOpt], {
                fontFamily: 'Arial', fontSize: '20px', fontWeight: 'bold',
                fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
                backgroundColor: '#00000066', padding: { x: 5, y: 2 }
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

        this.scoreText = this.add.text(200, 29, 'Score: 0', {
            fontFamily: 'Arial', fontSize: '16px', fontWeight: 'bold', fill: '#ffd700'
        }).setOrigin(0.5);

        this.holeCoords = [
            { x: 145, y: 178 }, { x: 325, y: 178 }, { x: 505, y: 178 },
            { x: 145, y: 310 }, { x: 325, y: 310 }, { x: 505, y: 310 },
            { x: 145, y: 442 }, { x: 325, y: 442 }, { x: 505, y: 442 }
        ];
        this.holeCoords.forEach(c => {
            this.add.image(c.x, c.y, 'spritesheet', 0).setScale(0.68);
        });

        this.warningText = this.add.text(325, 122, '', {
            fontFamily: 'Arial', fontSize: '16px', fontWeight: 'bold',
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

        initialHoles.forEach((holeIdx, optionIdx) => {
            const coord = this.holeCoords[holeIdx];
            const moleFrame = (optionIdx % 2 === 0) ? 5 : 6;
            const mole = this.add.sprite(coord.x, coord.y - 14, 'spritesheet', moleFrame).setScale(0.68);

            const label = this.add.text(coord.x, coord.y - 65, optLabels[optionIdx], {
                fontFamily: 'Arial', fontSize: '20px', fontWeight: 'bold',
                fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
                backgroundColor: '#00000066', padding: { x: 5, y: 2 }
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
        const cLabel = this.add.text(cc.x, cc.y - 65, optLabels[qData.correct], {
            fontFamily: 'Arial', fontSize: '20px', fontWeight: 'bold',
            fill: '#39ff14', stroke: '#000000', strokeThickness: 4,
            backgroundColor: '#00000066', padding: { x: 5, y: 2 }
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
        const dLabel = this.add.text(dc.x, dc.y - 65, optLabels[decoyOpt], {
            fontFamily: 'Arial', fontSize: '20px', fontWeight: 'bold',
            fill: '#ffd700', stroke: '#000000', strokeThickness: 4,
            backgroundColor: '#00000066', padding: { x: 5, y: 2 }
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

        // Dark overlay
        this.add.graphics().fillStyle(0x000000, 0.7).fillRect(0, 0, 650, 700);

        // Result card
        const cardColor = this.success ? 0x1a3d2b : 0x3d1a1a;
        const borderColor = this.success ? 0x2ecc71 : 0xe74c3c;
        const card = this.add.graphics();
        card.fillStyle(cardColor, 0.95).fillRoundedRect(35, 50, 580, 600, 22);
        card.lineStyle(4, borderColor, 1).strokeRoundedRect(35, 50, 580, 600, 22);

        // Mascot flying
        try {
            const mascot = this.add.sprite(550, 320, 'mascot').setScale(0.35);
            mascot.play('mascot_fly');
        } catch(e) {}

        // Title
        const titleColor = this.success ? '#2ecc71' : '#e74c3c';
        const titleText  = this.success ? '🎉 LEVEL COMPLETE!' : '💔 GAME OVER';
        this.add.text(260, 95, titleText, {
            fontFamily: '"Impact","Arial Black",sans-serif',
            fontSize: '32px', fill: titleColor,
            stroke: '#000000', strokeThickness: 5
        }).setOrigin(0.5);

        // Topic + tier info
        const tierNames = ['', 'Easy', 'Medium', 'Hard'];
        this.add.text(260, 140, `${tierNames[this.tier]} · ${this.topic.charAt(0).toUpperCase() + this.topic.slice(1)}`, {
            fontFamily: 'Arial', fontSize: '17px', fill: '#cccccc'
        }).setOrigin(0.5);

        // Stats
        const accuracy = this.total > 0 ? Math.round((this.score / this.total) * 100) : 0;

        this._statRow(115, 185, '📝 Questions',   `${this.score} / ${this.total}`);
        this._statRow(115, 225, '🎯 Accuracy',    `${accuracy}%`);
        this._statRow(115, 265, '🔥 Best Streak', `${this.streak} in a row`);

        // Coins placeholder (updated after server response)
        this.coinsText = this.add.text(115, 305, '💰 Coins Earned:  —', {
            fontFamily: 'Arial', fontSize: '17px', fill: '#ffd700', fontWeight: 'bold'
        });

        // Badges area
        this.badgeArea = this.add.text(115, 345, '', {
            fontFamily: 'Arial', fontSize: '15px', fill: '#f39c12',
            wordWrap: { width: 360 }
        });

        // Volume button
        this._mkVolumeBtn();

        // Buttons
        const levelSelectScene = { 1: 'EasyLevelScene', 2: 'MediumLevelScene', 3: 'HardLevelScene' };
        this._mkBtn(175, 505, 240, '🔄 Play Again', 0x2980b9, () => {
            this.scene.start('TopicSelectScene');
        });
        this._mkBtn(430, 505, 200, '🏠 Menu', 0x7f8c8d, () => {
            this.scene.start('LevelSelectScene');
        });

        // Dashboard link
        this._mkBtn(305, 570, 280, '📊 Go to Dashboard', 0x8e44ad, () => {
            window.location.href = '../child-dashboard.php';
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
            fontFamily: 'Arial', fontSize: '17px', fill: '#aaaaaa'
        });
        this.add.text(x + 230, y, value, {
            fontFamily: 'Arial', fontSize: '17px', fontWeight: 'bold', fill: '#ffffff'
        });
    }

    _mkBtn(x, y, w, label, color, cb) {
        const g = this.add.graphics();
        g.fillStyle(color, 0.9).fillRoundedRect(x - w / 2, y - 22, w, 44, 10);
        g.lineStyle(2, 0xffffff, 0.6).strokeRoundedRect(x - w / 2, y - 22, w, 44, 10);
        const t = this.add.text(x, y, label, {
            fontFamily: 'Arial', fontSize: '16px', fontWeight: 'bold', fill: '#ffffff'
        }).setOrigin(0.5);
        const z = this.add.zone(x, y, w, 44).setInteractive({ useHandCursor: true });
        z.on('pointerover', () => t.setStyle({ fill: '#ffd700' }));
        z.on('pointerout',  () => t.setStyle({ fill: '#ffffff' }));
        z.on('pointerdown', cb);
    }

    _mkVolumeBtn() {
        const v = this.add.image(615, 35, this.sound.mute ? 'mute' : 'volume')
            .setDisplaySize(38, 38).setInteractive({ useHandCursor: true }).setDepth(2000);
        v.on('pointerdown', () => {
            this.sound.mute = !this.sound.mute;
            v.setTexture(this.sound.mute ? 'mute' : 'volume');
        });
    }

    _submitScore() {
        if (this.submitted) return;
        this.submitted = true;

        // Get child_id from meta tag if available (set by child-dashboard.php template)
        const childMeta = document.querySelector('meta[name="child_id"]');
        const childId = childMeta ? parseInt(childMeta.content) : 0;

        const concept = (QUESTIONS.length > 0 && QUESTIONS[0].concept) ? QUESTIONS[0].concept : '';

        const form = new FormData();
        form.append('child_id',       childId);
        form.append('game_id',        1);
        form.append('tier',           this.tier);
        form.append('topic',          this.topic);
        form.append('concept',        concept);
        form.append('correct_count',  this.score);
        form.append('total_questions',this.total);
        form.append('streak',         this.streak);

        fetch('database/submit_score.php', { method: 'POST', body: form })
            .then(r => r.json())
            .then(data => {
                if (data.coins_earned !== undefined) {
                    this.coinsText.setText(`💰 Coins Earned:  +${data.coins_earned}`);
                }
                if (data.new_badges && data.new_badges.length > 0) {
                    const titles = data.new_badges.map(b => `🏅 ${b.title}`).join('\n');
                    this.badgeArea.setText('New badges:\n' + titles);
                }
            })
            .catch(err => {
                console.warn('Score submission failed (offline mode):', err);
                // Estimate locally
                const perCorrect = [0, 1, 2, 3][this.tier] || 1;
                this.coinsText.setText(`💰 Coins Earned:  ~${this.score * perCorrect} (offline)`);
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
