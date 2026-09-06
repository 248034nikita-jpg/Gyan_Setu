/* =====================================================
   🐾 ALPHABET ADVENTURE
   A-Z WORD SPELLING WEB APP FOR KIDS (AGES 4-6)
   Backend & Database Connected
===================================================== */

/* =====================================================
   📚 26 LEVELS — 15 WORDS EACH (390 WORDS TOTAL)
===================================================== */
const wordDatabase = {
    A: [
        { word: "APPLE", emoji: "🍎" }, { word: "ANT", emoji: "🐜" }, { word: "AIRPLANE", emoji: "✈️" },
        { word: "ALLIGATOR", emoji: "🐊" }, { word: "AXE", emoji: "🪓" }, { word: "ANGEL", emoji: "👼" },
        { word: "ARM", emoji: "💪" }, { word: "ANIMAL", emoji: "🦁" }, { word: "ARROW", emoji: "🏹" },
        { word: "ASTRONAUT", emoji: "🧑‍🚀" }, { word: "AMBULANCE", emoji: "🚑" }, { word: "APRON", emoji: "🎽" },
        { word: "AVOCADO", emoji: "🥑" }, { word: "ACORN", emoji: "🌰" }, { word: "ATOM", emoji: "⚛️" }
    ],
    B: [
        { word: "BALL", emoji: "⚽" }, { word: "BANANA", emoji: "🍌" }, { word: "BAT", emoji: "🦇" },
        { word: "BEAR", emoji: "🐻" }, { word: "BEE", emoji: "🐝" }, { word: "BIRD", emoji: "🐦" },
        { word: "BOOK", emoji: "📖" }, { word: "BOAT", emoji: "⛵" }, { word: "BUS", emoji: "🚌" },
        { word: "BUTTERFLY", emoji: "🦋" }, { word: "BREAD", emoji: "🍞" }, { word: "BABY", emoji: "👶" },
        { word: "BAG", emoji: "🎒" }, { word: "BELL", emoji: "🔔" }, { word: "BALLOON", emoji: "🎈" }
    ],
    C: [
        { word: "CAT", emoji: "🐱" }, { word: "CAR", emoji: "🚗" }, { word: "CAKE", emoji: "🍰" },
        { word: "COW", emoji: "🐄" }, { word: "CUP", emoji: "🥤" }, { word: "CAMEL", emoji: "🐪" },
        { word: "CANDY", emoji: "🍬" }, { word: "CHAIR", emoji: "🪑" }, { word: "CLOCK", emoji: "⏰" },
        { word: "CLOUD", emoji: "☁️" }, { word: "COOKIE", emoji: "🍪" }, { word: "CRAB", emoji: "🦀" },
        { word: "CROWN", emoji: "👑" }, { word: "CARROT", emoji: "🥕" }, { word: "CASTLE", emoji: "🏰" }
    ],
    D: [
        { word: "DOG", emoji: "🐶" }, { word: "DUCK", emoji: "🦆" }, { word: "DOLL", emoji: "🪆" },
        { word: "DOOR", emoji: "🚪" }, { word: "DRUM", emoji: "🥁" }, { word: "DINOSAUR", emoji: "🦕" },
        { word: "DOLPHIN", emoji: "🐬" }, { word: "DONUT", emoji: "🍩" }, { word: "DRAGON", emoji: "🐉" },
        { word: "DESK", emoji: "🗄️" }, { word: "DICE", emoji: "🎲" }, { word: "DEER", emoji: "🦌" },
        { word: "DIAMOND", emoji: "💎" }, { word: "DRESS", emoji: "👗" }, { word: "DOCTOR", emoji: "🧑‍⚕️" }
    ],
    E: [
        { word: "ELEPHANT", emoji: "🐘" }, { word: "EGG", emoji: "🥚" }, { word: "EAGLE", emoji: "🦅" },
        { word: "EARTH", emoji: "🌍" }, { word: "ELK", emoji: "🦌" }, { word: "ELMO", emoji: "👹" },
        { word: "EEL", emoji: "🐍" }, { word: "ELF", emoji: "🧝" }, { word: "EGGPLANT", emoji: "🍆" },
        { word: "ERASER", emoji: "🧽" }, { word: "ESKIMO", emoji: "🛖" }, { word: "EYE", emoji: "👁️" },
        { word: "EAR", emoji: "👂" }, { word: "ENGINE", emoji: "🚂" }, { word: "ENVELOPE", emoji: "✉️" }
    ],
    F: [
        { word: "FISH", emoji: "🐟" }, { word: "FROG", emoji: "🐸" }, { word: "FOX", emoji: "🦊" },
        { word: "FLOWER", emoji: "🌸" }, { word: "FRUIT", emoji: "🍎" }, { word: "FAN", emoji: "🪭" },
        { word: "FIRE", emoji: "🔥" }, { word: "FORK", emoji: "🍴" }, { word: "FEATHER", emoji: "🪶" },
        { word: "FOREST", emoji: "🌲" }, { word: "FLAG", emoji: "🚩" }, { word: "FAIRY", emoji: "🧚" },
        { word: "FLUTE", emoji: "🪈" }, { word: "FENCE", emoji: "🚧" }, { word: "FARMER", emoji: "🧑‍🌾" }
    ],
    G: [
        { word: "GOAT", emoji: "🐐" }, { word: "GIRAFFE", emoji: "🦒" }, { word: "GRAPES", emoji: "🍇" },
        { word: "GORILLA", emoji: "🦍" }, { word: "GLOVE", emoji: "🧤" }, { word: "GOLD", emoji: "🪙" },
        { word: "GUITAR", emoji: "🎸" }, { word: "GIFT", emoji: "🎁" }, { word: "GOOSE", emoji: "🪿" },
        { word: "GATE", emoji: "🚧" }, { word: "GHOST", emoji: "👻" }, { word: "GLASS", emoji: "🥛" },
        { word: "GARDEN", emoji: "🏡" }, { word: "GECKO", emoji: "🦎" }, { word: "GARLIC", emoji: "🧄" }
    ],
    H: [
        { word: "HORSE", emoji: "🐴" }, { word: "HOUSE", emoji: "🏠" }, { word: "HIPPO", emoji: "🦛" },
        { word: "HAT", emoji: "🎩" }, { word: "HAND", emoji: "✋" }, { word: "HEART", emoji: "❤️" },
        { word: "HELICOPTER", emoji: "🚁" }, { word: "HAMMER", emoji: "🔨" }, { word: "HEN", emoji: "🐔" },
        { word: "HONEY", emoji: "🍯" }, { word: "HARP", emoji: "🪕" }, { word: "HORN", emoji: "📯" },
        { word: "HILL", emoji: "⛰️" }, { word: "HAMSTER", emoji: "🐹" }, { word: "HUNTER", emoji: "🏹" }
    ],
    I: [
        { word: "IGUANA", emoji: "🦎" }, { word: "ICE", emoji: "🧊" }, { word: "IGLOO", emoji: "🛖" },
        { word: "INSECT", emoji: "🐞" }, { word: "ISLAND", emoji: "🏝️" }, { word: "INK", emoji: "✒️" },
        { word: "IRON", emoji: "🔌" }, { word: "INFANT", emoji: "👶" }, { word: "IVY", emoji: "🌿" },
        { word: "IVORY", emoji: "🐘" }, { word: "IRIS", emoji: "👁️" }, { word: "IMPALA", emoji: "🦌" },
        { word: "IBEX", emoji: "🐐" }, { word: "INDRI", emoji: "🐒" }, { word: "ICECREAM", emoji: "🍦" }
    ],
    J: [
        { word: "JELLY", emoji: "🍮" }, { word: "JEEP", emoji: "🚙" }, { word: "JAGUAR", emoji: "🐆" },
        { word: "JAR", emoji: "🫙" }, { word: "JET", emoji: "✈️" }, { word: "JUICE", emoji: "🧃" },
        { word: "JELLYFISH", emoji: "🪼" }, { word: "JACKAL", emoji: "🐺" }, { word: "JACKET", emoji: "🧥" },
        { word: "JIGSAW", emoji: "🧩" }, { word: "JESTER", emoji: "🃏" }, { word: "JEWEL", emoji: "💎" },
        { word: "JOKER", emoji: "🃏" }, { word: "JUMP", emoji: "🦘" }, { word: "JUNGLE", emoji: "🌳" }
    ],
    K: [
        { word: "KANGAROO", emoji: "🦘" }, { word: "KOALA", emoji: "🐨" }, { word: "KEY", emoji: "🔑" },
        { word: "KING", emoji: "👑" }, { word: "KIWI", emoji: "🥝" }, { word: "KITE", emoji: "🪁" },
        { word: "KITTEN", emoji: "🐱" }, { word: "KETTLE", emoji: "🫖" }, { word: "KRILL", emoji: "🦐" },
        { word: "KUDU", emoji: "🦌" }, { word: "KOMODO", emoji: "🦎" }, { word: "KETCHUP", emoji: "🥫" },
        { word: "KEYBOARD", emoji: "⌨️" }, { word: "KINGFISHER", emoji: "🐦" }, { word: "KAYAK", emoji: "🛶" }
    ],
    L: [
        { word: "LION", emoji: "🦁" }, { word: "LEAF", emoji: "🍃" }, { word: "LEMON", emoji: "🍋" },
        { word: "LLAMA", emoji: "🦙" }, { word: "LIZARD", emoji: "🦎" }, { word: "LADYBUG", emoji: "🐞" },
        { word: "LAMP", emoji: "💡" }, { word: "LAKE", emoji: "🌅" }, { word: "LOCK", emoji: "🔒" },
        { word: "LETTER", emoji: "✉️" }, { word: "LOBSTER", emoji: "🦞" }, { word: "LILY", emoji: "🪻" },
        { word: "LOG", emoji: "🪵" }, { word: "LADDER", emoji: "🪜" }, { word: "LEOPARD", emoji: "🐆" }
    ],
    M: [
        { word: "MONKEY", emoji: "🐵" }, { word: "MOON", emoji: "🌙" }, { word: "MOUSE", emoji: "🐭" },
        { word: "MILK", emoji: "🥛" }, { word: "MELON", emoji: "🍈" }, { word: "MAP", emoji: "🗺️" },
        { word: "MUG", emoji: "☕" }, { word: "MASK", emoji: "🎭" }, { word: "MAGNET", emoji: "🧲" },
        { word: "MIRROR", emoji: "🪞" }, { word: "MUSHROOM", emoji: "🍄" }, { word: "MACAW", emoji: "🦜" },
        { word: "MERMAID", emoji: "🧜‍♀️" }, { word: "MONSTER", emoji: "👾" }, { word: "MOTOR", emoji: "🏍️" }
    ],
    N: [
        { word: "NEST", emoji: "🪺" }, { word: "NUT", emoji: "🥜" }, { word: "NET", emoji: "🕸️" },
        { word: "NURSE", emoji: "🧑‍⚕️" }, { word: "NEWT", emoji: "🦎" }, { word: "NECK", emoji: "🧣" },
        { word: "NOSE", emoji: "👃" }, { word: "NEEDLE", emoji: "🪡" }, { word: "NAIL", emoji: "💅" },
        { word: "NAPKIN", emoji: "🧻" }, { word: "NARWHAL", emoji: "🐋" }, { word: "NAUTILUS", emoji: "🐚" },
        { word: "NIGHT", emoji: "🌃" }, { word: "NEWSPAPER", emoji: "📰" }, { word: "NOODLE", emoji: "🍜" }
    ],
    O: [
        { word: "OWL", emoji: "🦉" }, { word: "ORANGE", emoji: "🍊" }, { word: "OTTER", emoji: "🦦" },
        { word: "OCTOPUS", emoji: "🐙" }, { word: "OSTRICH", emoji: "🐦" }, { word: "ONION", emoji: "🧅" },
        { word: "OYSTER", emoji: "🦪" }, { word: "ORCA", emoji: "🐋" }, { word: "OVEN", emoji: "🍳" },
        { word: "OLIVE", emoji: "🫒" }, { word: "OKRA", emoji: "🥬" }, { word: "ORCHID", emoji: "🌸" },
        { word: "OCELOT", emoji: "🐆" }, { word: "OX", emoji: "🐂" }, { word: "OASIS", emoji: "🌴" }
    ],
    P: [
        { word: "PANDA", emoji: "🐼" }, { word: "PENGUIN", emoji: "🐧" }, { word: "PARROT", emoji: "🦜" },
        { word: "PEAR", emoji: "🍐" }, { word: "PIG", emoji: "🐷" }, { word: "PENCIL", emoji: "✏️" },
        { word: "PIZZA", emoji: "🍕" }, { word: "PUMPKIN", emoji: "🎃" }, { word: "PEACH", emoji: "🍑" },
        { word: "PLANT", emoji: "🌱" }, { word: "PURSE", emoji: "👛" }, { word: "PIANO", emoji: "🎹" },
        { word: "PILLOW", emoji: "🛏️" }, { word: "POLICE", emoji: "🚓" }, { word: "POCKET", emoji: "👜" }
    ],
    Q: [
        { word: "QUEEN", emoji: "👸" }, { word: "QUAIL", emoji: "🐦" }, { word: "QUILL", emoji: "🪶" },
        { word: "QUILT", emoji: "🪡" }, { word: "QUOKKA", emoji: "🐹" }, { word: "QUARTZ", emoji: "💎" },
        { word: "QUESTION", emoji: "❓" }, { word: "QUICHE", emoji: "🥧" }, { word: "QUICK", emoji: "⚡" },
        { word: "QUIET", emoji: "🤫" }, { word: "QUIZ", emoji: "📝" }, { word: "QUIVER", emoji: "🏹" },
        { word: "QUOLL", emoji: "🐱" }, { word: "QUAD", emoji: "🚜" }, { word: "QUARTER", emoji: "🪙" }
    ],
    R: [
        { word: "RABBIT", emoji: "🐰" }, { word: "RING", emoji: "💍" }, { word: "ROSE", emoji: "🌹" },
        { word: "RHINO", emoji: "🦏" }, { word: "ROBOT", emoji: "🤖" }, { word: "RAINBOW", emoji: "🌈" },
        { word: "RAIN", emoji: "🌧️" }, { word: "ROCKET", emoji: "🚀" }, { word: "RACCOON", emoji: "🦝" },
        { word: "ROPE", emoji: "🪢" }, { word: "RULER", emoji: "📏" }, { word: "RADIO", emoji: "📻" },
        { word: "RIVER", emoji: "🏞️" }, { word: "ROAD", emoji: "🛣️" }, { word: "ROOSTER", emoji: "🐓" }
    ],
    S: [
        { word: "SUN", emoji: "☀️" }, { word: "STAR", emoji: "⭐️" }, { word: "SNAKE", emoji: "🐍" },
        { word: "SHEEP", emoji: "🐑" }, { word: "SHARK", emoji: "🦈" }, { word: "SLOTH", emoji: "🦥" },
        { word: "SQUIRREL", emoji: "🐿️" }, { word: "SWAN", emoji: "🦢" }, { word: "SPIDER", emoji: "🕷️" },
        { word: "SHIP", emoji: "🚢" }, { word: "SHOE", emoji: "👟" }, { word: "SOAP", emoji: "🧼" },
        { word: "SOCKS", emoji: "🧦" }, { word: "SPOON", emoji: "🥄" }, { word: "SNAIL", emoji: "🐌" }
    ],
    T: [
        { word: "TIGER", emoji: "🐯" }, { word: "TURTLE", emoji: "🐢" }, { word: "TREE", emoji: "🌳" },
        { word: "TRAIN", emoji: "🚂" }, { word: "TOY", emoji: "🧸" }, { word: "TELEPHONE", emoji: "☎️" },
        { word: "TOMATO", emoji: "🍅" }, { word: "TENT", emoji: "⛺" }, { word: "TOOTH", emoji: "🦷" },
        { word: "TABLE", emoji: "🪑" }, { word: "TULIP", emoji: "🌷" }, { word: "TOAST", emoji: "🍞" },
        { word: "TONGUE", emoji: "👅" }, { word: "TAIL", emoji: "🐕" }, { word: "TOUCH", emoji: "👆" }
    ],
    U: [
        { word: "UMBRELLA", emoji: "☂️" }, { word: "UNICORN", emoji: "🦄" }, { word: "URCHIN", emoji: "🦔" },
        { word: "UNCLE", emoji: "🧔" }, { word: "UNIFORM", emoji: "🥋" }, { word: "UNIT", emoji: "📦" },
        { word: "URN", emoji: "🏺" }, { word: "UP", emoji: "⬆️" }, { word: "UNDER", emoji: "👇" },
        { word: "UTILITY", emoji: "🛠️" }, { word: "UKULELE", emoji: "🪕" }, { word: "URIAL", emoji: "🐏" },
        { word: "UAKARI", emoji: "🐒" }, { word: "URUBU", emoji: "🦅" }, { word: "URO", emoji: "🦎" }
    ],
    V: [
        { word: "VIOLIN", emoji: "🎻" }, { word: "VASE", emoji: "🏺" }, { word: "VULTURE", emoji: "🦅" },
        { word: "VEGETABLE", emoji: "🥦" }, { word: "VAMPIRE", emoji: "🧛" }, { word: "VEST", emoji: "🎽" },
        { word: "VALLEY", emoji: "⛰️" }, { word: "VINE", emoji: "🌿" }, { word: "VIPER", emoji: "🐍" },
        { word: "VOLCANO", emoji: "🌋" }, { word: "VANILLA", emoji: "🍦" }, { word: "VELVET", emoji: "🎀" },
        { word: "VELVETFISH", emoji: "🐟" }, { word: "VERVET", emoji: "🐒" }, { word: "VOICE", emoji: "🗣️" }
    ],
    W: [
        { word: "WOLF", emoji: "🐺" }, { word: "WHALE", emoji: "🐋" }, { word: "WINDOW", emoji: "🪟" },
        { word: "WATCH", emoji: "⌚" }, { word: "WORM", emoji: "🪱" }, { word: "WAGON", emoji: "🛒" },
        { word: "WATER", emoji: "💧" }, { word: "WOOD", emoji: "🪵" }, { word: "WHEEL", emoji: "🛞" },
        { word: "WING", emoji: "🪶" }, { word: "WELL", emoji: "🕳️" }, { word: "WEB", emoji: "🕸️" },
        { word: "WASP", emoji: "🐝" }, { word: "WINDMILL", emoji: "💨" }, { word: "WALNUT", emoji: "🌰" }
    ],
    X: [
        { word: "XYLOPHONE", emoji: "🪘" }, { word: "XRAY", emoji: "🩻" }, { word: "XENOPS", emoji: "🐦" },
        { word: "XERUS", emoji: "🐿️" }, { word: "XIPHIAS", emoji: "🐟" }, { word: "XEBEC", emoji: "⛵" },
        { word: "XEROX", emoji: "📄" }, { word: "XMAS", emoji: "🎄" }, { word: "XYLOSE", emoji: "🍬" },
        { word: "XANTUS", emoji: "🐦" }, { word: "XENON", emoji: "💡" }, { word: "XYLITOL", emoji: "🍬" },
        { word: "XYST", emoji: "🏛️" }, { word: "XYSTER", emoji: "🪚" }, { word: "XYLOCOPA", emoji: "🐝" }
    ],
    Y: [
        { word: "YAK", emoji: "🐂" }, { word: "YACHT", emoji: "⛵" }, { word: "YO-YO", emoji: "🪀" },
        { word: "YOLK", emoji: "🍳" }, { word: "YARN", emoji: "🧶" }, { word: "YELLOW", emoji: "💛" },
        { word: "YAM", emoji: "🍠" }, { word: "YETI", emoji: "🧌" }, { word: "YOGA", emoji: "🧘" },
        { word: "YOGURT", emoji: "🥛" }, { word: "YOUTH", emoji: "🧑" }, { word: "YARD", emoji: "🏡" },
        { word: "YAWN", emoji: "🥱" }, { word: "YELLOWJACKET", emoji: "🐝" }, { word: "YUCCA", emoji: "🌴" }
    ],
    Z: [
        { word: "ZEBRA", emoji: "🦓" }, { word: "ZERO", emoji: "0️⃣" }, { word: "ZOO", emoji: "🦁" },
        { word: "ZUCCHINI", emoji: "🥒" }, { word: "ZIP", emoji: "🤐" }, { word: "ZIGZAG", emoji: "📈" },
        { word: "ZITHER", emoji: "🪕" }, { word: "ZEUS", emoji: "⚡" }, { word: "ZINC", emoji: "🪙" },
        { word: "ZINNIA", emoji: "🌸" }, { word: "ZOMBIE", emoji: "🧟" }, { word: "ZEALOT", emoji: "🧑‍🚒" },
        { word: "ZORILLA", emoji: "🦨" }, { word: "ZOKOR", emoji: "🐹" }, { word: "ZANDER", emoji: "🐟" }
    ]
};

/* =====================================================
   🎮 GAME PROGRESS STATE & BACKEND INTEGRATION
===================================================== */
const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
let currentLevelIndex = 0; // 0-25 representing A-Z
let currentWordIndex = 0;  // 0-14 representing stages

// Child ID resolution: window global > URL query > meta tag > localStorage > 0 (guest)
function getActiveChildId() {
    if (typeof window.CHILD_ID !== "undefined" && Number(window.CHILD_ID) > 0) {
        return Number(window.CHILD_ID);
    }
    const urlParams = new URLSearchParams(window.location.search);
    const paramId = urlParams.get('child_id');
    if (paramId && Number(paramId) > 0) return Number(paramId);

    const metaTag = document.querySelector('meta[name="child_id"]');
    if (metaTag && Number(metaTag.content) > 0) return Number(metaTag.content);

    const storedId = localStorage.getItem('active_child_id') || localStorage.getItem('child_id');
    return storedId ? Number(storedId) : 0;
}

const activeChildId = getActiveChildId();

// Dynamic stats (hydrated from backend, with localStorage fallback)
let coins = Number(localStorage.getItem("adventureCoins")) || 0;
let totalStars = Number(localStorage.getItem("adventureStars")) || 0;
let totalCompletedWords = Number(localStorage.getItem("adventureCompletedCount")) || 0;
let soundEnabled = JSON.parse(localStorage.getItem("adventureSound") !== null ? localStorage.getItem("adventureSound") : "true");

// Progression databases
let completedLevels = JSON.parse(localStorage.getItem("adventureCompletedLevels") || "[]");
let wordStars = JSON.parse(localStorage.getItem("adventureWordStars") || "{}"); // Key: 'A-0' value: stars count (1-3)

// Level theme mappings
const levelTheme = (index) => {
    if (index >= 0 && index <= 5) return "theme-forest";   // A-F
    if (index >= 6 && index <= 11) return "theme-ocean";  // G-L
    if (index >= 12 && index <= 17) return "theme-space"; // M-R
    return "theme-magic";                                 // S-Z
};

// Current spelling states
let activeWordObj = null;
let currentWordString = "";
let draggedLetterNode = null;
let mistakeCount = 0;
let hintLimit = 3;
let musicStarted = false;
let musicTimer = null;
let currentAccuracy = 100;

/* =====================================================
   🌐 BACKEND SYNC (GET & SAVE)
===================================================== */
async function loadProgressFromBackend() {
    try {
        const response = await fetch(`api/get_progress.php?child_id=${activeChildId}`);
        const data = await response.json();
        if (data && data.success) {
            if (typeof data.accuracy !== "undefined") {
                currentAccuracy = Number(data.accuracy) || 100;
            }
            if (!data.guest) {
                coins = Number(data.total_coins) || 0;
                totalCompletedWords = Number(data.completed_count) || 0;
                completedLevels = Array.isArray(data.completed_levels) ? data.completed_levels : [];
                wordStars = (data.word_stars && typeof data.word_stars === 'object') ? data.word_stars : {};
                
                // Keep local storage in sync
                localStorage.setItem("adventureCoins", coins);
                localStorage.setItem("adventureCompletedCount", totalCompletedWords);
                localStorage.setItem("adventureCompletedLevels", JSON.stringify(completedLevels));
                localStorage.setItem("adventureWordStars", JSON.stringify(wordStars));
            }
            updateProgressDisplay();
            renderLevelsGrid();
        }
    } catch (e) {
        console.warn("Could not load progress from backend, using local state:", e);
    }
}

async function saveWordProgressToBackend(letter, levelIdx, wordIdx, wordStr, starsEarned, mistakes) {
    if (activeChildId <= 0) return;
    try {
        const response = await fetch('api/save_word_progress.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                child_id: activeChildId,
                level_letter: letter,
                level_index: levelIdx,
                word_index: wordIdx,
                word: wordStr,
                stars: starsEarned,
                mistakes: mistakes,
                coins_earned: 5
            })
        });
        const data = await response.json();
        if (data && data.success) {
            if (typeof data.total_coins !== "undefined") {
                coins = data.total_coins;
                localStorage.setItem("adventureCoins", coins);
                updateCoinDisplays();
            }
            if (data.new_badges && data.new_badges.length > 0) {
                showToast(`🏆 Badge Unlocked: ${data.new_badges[0].title}!`);
            }
        }
    } catch (e) {
        console.warn("Backend word save error:", e);
    }
}

async function saveLevelCompleteToBackend(letter, levelIdx) {
    if (activeChildId <= 0) return;
    try {
        const response = await fetch('api/save_level_complete.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                child_id: activeChildId,
                level_letter: letter,
                level_index: levelIdx,
                bonus_coins: 50
            })
        });
        const data = await response.json();
        if (data && data.success) {
            if (typeof data.total_coins !== "undefined") {
                coins = data.total_coins;
                localStorage.setItem("adventureCoins", coins);
                updateCoinDisplays();
            }
            if (data.new_badges && data.new_badges.length > 0) {
                showToast(`🎉 Badge Earned: ${data.new_badges[0].title}!`);
            }
        }
    } catch (e) {
        console.warn("Backend level save error:", e);
    }
}

/* =====================================================
   🔊 AUDIO SYNTHESIZER (WEB AUDIO API)
===================================================== */
let audioContext = null;

function getAudioContext() {
    if (!audioContext) {
        audioContext = new (window.AudioContext || window.webkitAudioContext)();
    }
    if (audioContext.state === "suspended") {
        audioContext.resume();
    }
    return audioContext;
}

function tone(frequency, duration, type = "sine", volume = 0.08) {
    if (!soundEnabled) return;
    try {
        const ctx = getAudioContext();
        const oscillator = ctx.createOscillator();
        const gain = ctx.createGain();

        oscillator.type = type;
        oscillator.frequency.setValueAtTime(frequency, ctx.currentTime);

        gain.gain.setValueAtTime(volume, ctx.currentTime);
        gain.gain.linearRampToValueAtTime(0, ctx.currentTime + duration);

        oscillator.connect(gain);
        gain.connect(ctx.destination);

        oscillator.start();
        oscillator.stop(ctx.currentTime + duration);
    } catch (e) {
        console.warn("Audio Context error:", e);
    }
}

/* Sound library */
function playBoing() {
    tone(260, 0.08, "square", 0.05);
    setTimeout(() => tone(360, 0.12, "square", 0.04), 70);
}

function playCorrectSnap() {
    tone(600, 0.06, "triangle", 0.08);
    setTimeout(() => tone(850, 0.09, "triangle", 0.07), 60);
}

function playWrongBonk() {
    tone(140, 0.15, "sawtooth", 0.08);
    setTimeout(() => tone(80, 0.20, "sawtooth", 0.07), 100);
}

function playChime() {
    tone(1000, 0.08, "sine", 0.035);
    setTimeout(() => tone(1350, 0.18, "sine", 0.035), 50);
}

function playCelebrationSound() {
    const notes = [523.25, 659.25, 783.99, 1046.50, 1318.51, 1567.98];
    notes.forEach((note, index) => {
        setTimeout(() => tone(note, 0.22, "triangle", 0.07), index * 90);
    });
}

function playVictorySound() {
    const notes = [523.25, 587.33, 659.25, 698.46, 783.99, 880.00, 987.77, 1046.50, 1174.66, 1318.51, 1567.98, 2093.00];
    notes.forEach((note, idx) => {
        setTimeout(() => tone(note, 0.25, "triangle", 0.07), idx * 80);
    });
}

/* Background beat loop */
function startAmbientMusic() {
    if (musicStarted || !soundEnabled) return;
    musicStarted = true;

    let musicNoteIndex = 0;
    const C5 = 523.25, D5 = 587.33, E5 = 659.25, F5 = 698.46, G5 = 783.99, A5 = 880.00;
    
    // The Alphabet Song / Twinkle Twinkle Little Star melody
    const melody = [
        C5, C5, G5, G5, A5, A5, G5, 0,
        F5, F5, E5, E5, D5, D5, C5, 0,
        G5, G5, F5, F5, E5, E5, D5, 0,
        G5, G5, F5, F5, E5, E5, D5, 0,
        C5, C5, G5, G5, A5, A5, G5, 0,
        F5, F5, E5, E5, D5, D5, C5, 0
    ];

    function playLoop() {
        if (!soundEnabled || !musicStarted) {
            musicStarted = false;
            return;
        }

        const note = melody[musicNoteIndex];
        if (note > 0) {
            tone(note, 0.28, "sine", 0.015);
            setTimeout(() => {
                if (soundEnabled && musicStarted) {
                    tone(note * 2, 0.15, "sine", 0.005);
                }
            }, 50);
        }

        musicNoteIndex = (musicNoteIndex + 1) % melody.length;
        musicTimer = setTimeout(playLoop, 380);
    }
    playLoop();
}

/* =====================================================
   🎙️ TEXT TO SPEECH PRONUNCIATION
===================================================== */
function say(text, rate = 0.72) {
    if (!window.speechSynthesis) return;
    try {
        window.speechSynthesis.cancel();
        
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.rate = rate;
        utterance.pitch = 1.35;
        
        const voices = window.speechSynthesis.getVoices();
        const englishVoice = voices.find(voice => voice.lang.includes("en-US") || voice.lang.includes("en-GB"));
        if (englishVoice) {
            utterance.voice = englishVoice;
        }

        window.speechSynthesis.speak(utterance);
    } catch (e) {
        console.warn("Speech Synthesis error:", e);
    }
}

// Pre-load voices (Chrome fix)
if (window.speechSynthesis) {
    window.speechSynthesis.getVoices();
    window.speechSynthesis.onvoiceschanged = () => window.speechSynthesis.getVoices();
}

/* =====================================================
   🏛️ VIEW MANAGER
===================================================== */
function showScreen(screenId) {
    document.querySelectorAll(".screen").forEach(screen => {
        screen.classList.add("hidden");
        screen.classList.remove("active");
    });

    const activeScreen = document.getElementById(screenId);
    activeScreen.classList.remove("hidden");
    activeScreen.classList.add("active");

    let activeTheme = "theme-forest";
    if (screenId === "level-screen" || screenId === "game-screen") {
        activeTheme = levelTheme(currentLevelIndex);
    }
    document.body.className = activeTheme;
}

function showStartScreen() {
    updateCoinDisplays();
    showScreen("start-screen");
}

function goToLetterSelection() {
    playBoing();
    startAmbientMusic();
    showHomeScreen();
}

function openProgressModal() {
    playChime();
    const coinsEl = document.getElementById("popup-coins");
    const wordsEl = document.getElementById("popup-words");
    const accEl = document.getElementById("popup-accuracy");
    if (coinsEl) coinsEl.textContent = coins;
    if (wordsEl) wordsEl.textContent = totalCompletedWords;
    if (accEl) accEl.textContent = `${currentAccuracy}%`;
    const overlay = document.getElementById("progress-modal-overlay");
    if (overlay) overlay.classList.remove("hidden");
}

function closeProgressModal() {
    playBoing();
    const overlay = document.getElementById("progress-modal-overlay");
    if (overlay) overlay.classList.add("hidden");
}

function handleModalBackdropClick(e) {
    if (e.target && e.target.id === "progress-modal-overlay") {
        closeProgressModal();
    }
}

function showHomeScreen() {
    updateProgressDisplay();
    renderLevelsGrid();
    showScreen("home-screen");
}

function showLevelScreen() {
    updateCoinDisplays();
    updateLevelHeader();
    renderWordsGrid();
    showScreen("level-screen");
}

function showGameScreen(wordIndex) {
    updateCoinDisplays();
    currentWordIndex = wordIndex;
    startChallengeWord();
    showScreen("game-screen");
}

/* =====================================================
   ⚙️ PROGRESS DISPLAY & STATS UPDATING
===================================================== */
function updateProgressDisplay() {
    const totalCount = 390;
    const progressPercent = Math.min(100, Math.floor((totalCompletedWords / totalCount) * 100));
    
    updateCoinDisplays();
    const globalStarsEl = document.getElementById("global-stars");
    if (globalStarsEl) {
        globalStarsEl.textContent = totalStars;
    }
    document.getElementById("progress-percent").textContent = `${progressPercent}%`;
    document.getElementById("global-progress").style.width = `${progressPercent}%`;
}

function updateCoinDisplays() {
    document.querySelectorAll(".global-coins-display").forEach(el => {
        el.textContent = coins;
    });
}

function updateLevelHeader() {
    const letter = alphabet[currentLevelIndex];
    document.getElementById("level-title-header").textContent = `LEVEL ${letter}`;
    
    let completedCount = 0;
    for (let i = 0; i < 15; i++) {
        const starKey = `${letter}-${i}`;
        if (wordStars[starKey]) {
            completedCount++;
        }
    }
    
    document.getElementById("level-progress-txt").textContent = `Completed: ${completedCount}/15`;
    const levelStarsTotalEl = document.getElementById("level-stars-total");
    if (levelStarsTotalEl) {
        levelStarsTotalEl.textContent = completedCount * 5;
    }
}

/* =====================================================
   🎨 RENDER MAP & STAGES GRIDS
===================================================== */
function renderLevelsGrid() {
    const grid = document.getElementById("levels-grid");
    grid.innerHTML = "";

    alphabet.forEach((letter, index) => {
        const tile = document.createElement("button");
        tile.classList.add("level");

        const isUnlocked = index === 0 || completedLevels.includes(index - 1);
        const isCompleted = completedLevels.includes(index);

        let levelStars = 0;
        for (let i = 0; i < 15; i++) {
            const key = `${letter}-${i}`;
            if (wordStars[key]) levelStars += wordStars[key];
        }

        if (!isUnlocked) {
            tile.classList.add("locked");
            tile.innerHTML = `${letter}<br><span>🔒 Locked</span>`;
            tile.onclick = () => {
                playWrongBonk();
                showToast(`😂 Spell Level ${alphabet[index - 1]} first!`);
                say(`Spell Level ${alphabet[index - 1]} first!`);
            };
        } else {
            tile.classList.add("unlocked");
            if (isCompleted) tile.classList.add("completed");
            
            let isCurrentTarget = false;
            if (index === 0 && !isCompleted) isCurrentTarget = true;
            else if (index > 0 && completedLevels.includes(index - 1) && !isCompleted) isCurrentTarget = true;

            if (isCurrentTarget) tile.classList.add("current");

            let completedWordsInLevel = 0;
            for (let i = 0; i < 15; i++) {
                const key = `${letter}-${i}`;
                if (wordStars[key]) completedWordsInLevel++;
            }
            const levelCoins = completedWordsInLevel * 5;

            tile.innerHTML = `${letter}<br><span><svg class="coin-svg-inline" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="#ffda43" stroke="#222" stroke-width="2"/><circle cx="12" cy="12" r="6" fill="#ffe97d" stroke="#222" stroke-width="1.5"/><path d="M12 9v6M10.5 10.5h3a1.5 1.5 0 0 0 0-3h-3M10.5 13.5h3a1.5 1.5 0 0 1 0 3h-3" fill="none" stroke="#222" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg> ${levelCoins}</span>`;
            tile.onclick = () => {
                playBoing();
                currentLevelIndex = index;
                showLevelScreen();
            };
        }
        grid.appendChild(tile);
    });
}

function renderWordsGrid() {
    const grid = document.getElementById("words-grid");
    grid.innerHTML = "";

    const letter = alphabet[currentLevelIndex];
    const wordList = wordDatabase[letter];

    wordList.forEach((wordObj, index) => {
        const card = document.createElement("div");
        card.classList.add("word-stage-card");

        const starKey = `${letter}-${index}`;
        const starsEarned = wordStars[starKey] || 0;
        const isCompleted = starsEarned > 0;

        const isUnlocked = index === 0 || wordStars[`${letter}-${index - 1}`] !== undefined;

        if (!isUnlocked) {
            card.classList.add("locked");
            card.innerHTML = `
                <span>Stage ${index + 1}</span>
                <span style="font-size: 24px;">🔒</span>
                <span class="stage-star-rating">Locked</span>
            `;
            card.onclick = () => {
                playWrongBonk();
                showToast(`Locked! Solve Stage ${index} first.`);
                say(`Solve Stage ${index} first.`);
            };
        } else {
            card.classList.add("playable");
            if (isCompleted) card.classList.add("completed");

            const coinIcon = `<svg class="coin-svg-inline" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" fill="#ffda43" stroke="#222" stroke-width="2"/><circle cx="12" cy="12" r="6" fill="#ffe97d" stroke="#222" stroke-width="1.5"/><path d="M12 9v6M10.5 10.5h3a1.5 1.5 0 0 0 0-3h-3M10.5 13.5h3a1.5 1.5 0 0 1 0 3h-3" fill="none" stroke="#222" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
            const coinText = isCompleted ? `${coinIcon} 5` : `${coinIcon} 0`;

            card.innerHTML = `
                <span>${index + 1}. ${wordObj.word}</span>
                <span style="font-size: 32px;">${wordObj.emoji}</span>
                <span class="stage-star-rating">${coinText}</span>
            `;
            card.onclick = () => {
                playBoing();
                showGameScreen(index);
            };
        }
        grid.appendChild(card);
    });
}

/* =====================================================
   🎮 WORD CHALLENGE SPELLING SCREEN LOGIC
===================================================== */
function startChallengeWord() {
    const letter = alphabet[currentLevelIndex];
    activeWordObj = wordDatabase[letter][currentWordIndex];
    currentWordString = activeWordObj.word.toUpperCase();
    
    mistakeCount = 0;
    hintLimit = 3;

    document.getElementById("hint-count").textContent = hintLimit;
    document.getElementById("game-word-num").textContent = `Word ${currentWordIndex + 1} of 15`;
    document.getElementById("game-level-txt").textContent = `LEVEL ${letter}`;
    
    document.getElementById("word-emoji").textContent = activeWordObj.emoji;
    document.getElementById("next-word-box").classList.add("hidden");

    createSlotsOutline();
    createLetterCardsDeck();

    setTimeout(() => {
        say(`Can you spell ${activeWordObj.word}?`);
        updateMascotSpeech(`Can you spell ${activeWordObj.word}? 🐾`);
    }, 400);
}

function updateMascotSpeech(text) {
    document.getElementById("speech").textContent = text;
}

function speakCurrentWord() {
    if (activeWordObj) {
        say(activeWordObj.word, 0.8);
    }
}

/* Outline slot creator */
function createSlotsOutline() {
    const wrapper = document.getElementById("word-slots");
    wrapper.innerHTML = "";

    [...currentWordString].forEach((char, index) => {
        const slot = document.createElement("div");
        slot.classList.add("slot");
        slot.dataset.index = index;
        slot.dataset.correctChar = char;

        if (char === " " || char === "-") {
            slot.style.border = "none";
            slot.style.background = "transparent";
            slot.style.width = "20px";
            slot.textContent = char;
            slot.classList.add("filled");
        } else {
            slot.textContent = char;
        }
        wrapper.appendChild(slot);
    });
}

// Pointer drag global variables
let activeDragCard = null;
let activePointerId = null;
let dragStartX = 0;
let dragStartY = 0;
let dragOffsetX = 0;
let dragOffsetY = 0;
let dragOriginalStyles = {};

function playDragSoundForLetter(letter) {
    if (!soundEnabled) return;
    
    say(letter, 0.58);

    const code = letter.toUpperCase().charCodeAt(0);
    const soundType = code % 4;

    try {
        if (soundType === 0) {
            for (let i = 0; i < 4; i++) {
                setTimeout(() => {
                    tone(250 + i * 50, 0.16, "sine", 0.07);
                }, i * 125);
            }
        } else if (soundType === 1) {
            tone(380, 0.22, "triangle", 0.08);
            setTimeout(() => tone(280, 0.20, "triangle", 0.08), 120);
            setTimeout(() => tone(450, 0.22, "triangle", 0.06), 240);
        } else if (soundType === 2) {
            tone(650, 0.18, "sine", 0.06);
            setTimeout(() => tone(850, 0.18, "sine", 0.05), 120);
        } else {
            tone(180, 0.20, "square", 0.05);
            setTimeout(() => tone(280, 0.20, "square", 0.04), 130);
        }
    } catch (e) {
        console.warn("Error playing funny drag sound:", e);
    }
}

function handleLetterPointerDown(e) {
    if (activeDragCard || e.currentTarget.classList.contains("used")) return;
    if (e.pointerType === "mouse" && e.button !== 0) return;

    activeDragCard = e.currentTarget;
    activePointerId = e.pointerId;

    activeDragCard.setPointerCapture(e.pointerId);

    dragStartX = e.clientX;
    dragStartY = e.clientY;

    playDragSoundForLetter(activeDragCard.dataset.char);
    startAmbientMusic();

    const rect = activeDragCard.getBoundingClientRect();
    dragOffsetX = e.clientX - rect.left;
    dragOffsetY = e.clientY - rect.top;

    dragOriginalStyles = {
        position: activeDragCard.style.position,
        left: activeDragCard.style.left,
        top: activeDragCard.style.top,
        width: activeDragCard.style.width,
        height: activeDragCard.style.height,
        margin: activeDragCard.style.margin,
        zIndex: activeDragCard.style.zIndex
    };

    activeDragCard.style.position = "fixed";
    activeDragCard.style.width = `${rect.width}px`;
    activeDragCard.style.height = `${rect.height}px`;
    activeDragCard.style.left = `${rect.left}px`;
    activeDragCard.style.top = `${rect.top}px`;
    activeDragCard.style.margin = "0";
    activeDragCard.style.zIndex = "100000";

    activeDragCard.classList.add("dragging");

    activeDragCard.addEventListener("pointermove", handleLetterPointerMove);
    activeDragCard.addEventListener("pointerup", handleLetterPointerUp);
    activeDragCard.addEventListener("pointercancel", handleLetterPointerCancel);
}

function handleLetterPointerMove(e) {
    if (!activeDragCard || e.pointerId !== activePointerId) return;
    activeDragCard.style.left = `${e.clientX - dragOffsetX}px`;
    activeDragCard.style.top = `${e.clientY - dragOffsetY}px`;
}

function handleLetterPointerUp(e) {
    if (!activeDragCard || e.pointerId !== activePointerId) return;

    const card = activeDragCard;
    const pointerId = activePointerId;

    card.releasePointerCapture(pointerId);
    card.removeEventListener("pointermove", handleLetterPointerMove);
    card.removeEventListener("pointerup", handleLetterPointerUp);
    card.removeEventListener("pointercancel", handleLetterPointerCancel);

    activeDragCard = null;
    activePointerId = null;

    card.classList.remove("dragging");

    const slots = document.querySelectorAll(".slot");
    let hitSlot = null;

    slots.forEach(slot => {
        const slotRect = slot.getBoundingClientRect();
        if (
            e.clientX >= slotRect.left &&
            e.clientX <= slotRect.right &&
            e.clientY >= slotRect.top &&
            e.clientY <= slotRect.bottom
        ) {
            hitSlot = slot;
        }
    });

    card.style.position = dragOriginalStyles.position;
    card.style.left = dragOriginalStyles.left;
    card.style.top = dragOriginalStyles.top;
    card.style.width = dragOriginalStyles.width;
    card.style.height = dragOriginalStyles.height;
    card.style.margin = dragOriginalStyles.margin;
    card.style.zIndex = dragOriginalStyles.zIndex;

    const distanceMoved = Math.hypot(e.clientX - dragStartX, e.clientY - dragStartY);
    if (distanceMoved < 6) {
        playBoing();
        autoPlaceLetter(card);
        return;
    }

    if (hitSlot) {
        evaluateLetterPlacement(card, hitSlot);
    }
}

function handleLetterPointerCancel(e) {
    if (!activeDragCard || e.pointerId !== activePointerId) return;

    const card = activeDragCard;
    const pointerId = activePointerId;

    card.releasePointerCapture(pointerId);
    card.removeEventListener("pointermove", handleLetterPointerMove);
    card.removeEventListener("pointerup", handleLetterPointerUp);
    card.removeEventListener("pointercancel", handleLetterPointerCancel);

    activeDragCard = null;
    activePointerId = null;

    card.classList.remove("dragging");

    card.style.position = dragOriginalStyles.position;
    card.style.left = dragOriginalStyles.left;
    card.style.top = dragOriginalStyles.top;
    card.style.width = dragOriginalStyles.width;
    card.style.height = dragOriginalStyles.height;
    card.style.margin = dragOriginalStyles.margin;
    card.style.zIndex = dragOriginalStyles.zIndex;
}

/* Letter deck shuffler */
function createLetterCardsDeck() {
    const deck = document.getElementById("letters-deck");
    deck.innerHTML = "";

    let chars = [...currentWordString].filter(c => c !== " " && c !== "-");
    chars = shuffleArray(chars);

    const colorClasses = ["letter-red", "letter-blue", "letter-green", "letter-orange", "letter-purple", "letter-pink", "letter-teal"];

    chars.forEach((char, index) => {
        const card = document.createElement("div");
        card.classList.add("letter");
        
        const randomColor = colorClasses[Math.floor(Math.random() * colorClasses.length)];
        card.classList.add(randomColor);

        const charSpan = document.createElement("span");
        charSpan.textContent = char;
        card.appendChild(charSpan);

        const eyesContainer = document.createElement("div");
        eyesContainer.className = "letter-eyes";
        eyesContainer.innerHTML = '<span class="eye"></span><span class="eye"></span>';
        card.appendChild(eyesContainer);

        card.draggable = false;
        card.dataset.char = char;
        card.dataset.id = `letter-${index}-${char}`;

        const randomRot = (Math.random() - 0.5) * 16;
        card.style.transform = `rotate(${randomRot}deg)`;

        card.addEventListener("pointerdown", handleLetterPointerDown);
        deck.appendChild(card);
    });
}

/* Easy tap click-to-place matching fallback */
function autoPlaceLetter(letterNode) {
    if (letterNode.classList.contains("used")) return;

    const emptySlots = [...document.querySelectorAll(".slot")].filter(
        slot => !slot.classList.contains("filled")
    );
    if (emptySlots.length === 0) return;

    const letterChar = letterNode.dataset.char;

    const correctSlot = emptySlots.find(
        slot => slot.dataset.correctChar === letterChar
    );

    if (correctSlot) {
        evaluateLetterPlacement(letterNode, correctSlot);
    } else {
        evaluateLetterPlacement(letterNode, emptySlots[0]);
    }
}

/* Evaluator core snapped placing */
function evaluateLetterPlacement(letterNode, slotNode) {
    if (letterNode.classList.contains("used") || slotNode.classList.contains("filled")) return;

    const placedChar = letterNode.dataset.char;
    const slotCorrectChar = slotNode.dataset.correctChar;

    if (placedChar === slotCorrectChar) {
        slotNode.innerHTML = "";
        slotNode.classList.add("filled");
        letterNode.classList.add("used");

        const clone = letterNode.cloneNode(true);
        clone.className = "letter placed " + [...letterNode.classList].find(c => c.startsWith("letter-"));
        clone.draggable = false;
        clone.style.position = "";
        clone.style.left = "";
        clone.style.top = "";
        clone.style.width = "";
        clone.style.height = "";
        clone.style.margin = "";
        clone.style.transform = "none";
        slotNode.appendChild(clone);

        playCorrectSnap();
        triggerSparkleAnimation(slotNode);
        reactMascot("correct");
        
        checkSpellingSuccess();
    } else {
        slotNode.classList.add("wrong");
        playWrongBonk();
        reactMascot("wrong");
        
        mistakeCount++;

        const prompts = ["Try again! 🐾", "Almost! Let's try once more!", "Whoops! Pick another one!", "Keep trying, buddy! 🌟"];
        updateMascotSpeech(prompts[Math.floor(Math.random() * prompts.length)]);

        setTimeout(() => {
            slotNode.classList.remove("wrong");
        }, 400);
    }
}

/* Check spelling victory */
function checkSpellingSuccess() {
    const slots = [...document.querySelectorAll(".slot")];
    const isCompleted = slots.every(slot => slot.classList.contains("filled"));

    if (!isCompleted) return;

    const letter = alphabet[currentLevelIndex];
    const starKey = `${letter}-${currentWordIndex}`;
    
    let earnedWordStars = 3;
    if (mistakeCount >= 1) earnedWordStars = 2;
    if (mistakeCount >= 3) earnedWordStars = 1;

    const wasAlreadyCompleted = wordStars[starKey] !== undefined;
    const oldStars = wordStars[starKey] || 0;

    if (!wasAlreadyCompleted) {
        totalCompletedWords++;
        localStorage.setItem("adventureCompletedCount", totalCompletedWords);
    }

    if (earnedWordStars > oldStars) {
        totalStars += (earnedWordStars - oldStars);
        localStorage.setItem("adventureStars", totalStars);
        wordStars[starKey] = earnedWordStars;
        localStorage.setItem("adventureWordStars", JSON.stringify(wordStars));
    }

    // Earn 5 coins
    triggerCoinExplosion();

    // Sound celebrations & confetti
    playCelebrationSound();
    triggerStarsConfetti();

    // Mascot congratulation Speech
    say(`Amazing! You spelled ${activeWordObj.word}!`);
    updateMascotSpeech(`Amazing! You spelled ${activeWordObj.word}! 🎉`);

    // Show inline next word screen overlay
    document.getElementById("encouragement-txt").textContent = `Amazing! You spelled ${activeWordObj.word}! 🎉`;
    document.getElementById("next-word-box").classList.remove("hidden");

    // Persist to Database via Backend API
    saveWordProgressToBackend(letter, currentLevelIndex, currentWordIndex, activeWordObj.word, earnedWordStars, mistakeCount);
}

function nextWordChallenge() {
    if (currentWordIndex < 14) {
        currentWordIndex++;
        startChallengeWord();
    } else {
        finishWholeLevel();
    }
}

/* Level details complete Modal */
function finishWholeLevel() {
    const letter = alphabet[currentLevelIndex];
    if (!completedLevels.includes(currentLevelIndex)) {
        completedLevels.push(currentLevelIndex);
        localStorage.setItem("adventureCompletedLevels", JSON.stringify(completedLevels));
    }

    coins += 50;
    totalStars += 10;
    localStorage.setItem("adventureCoins", coins);
    localStorage.setItem("adventureStars", totalStars);
    updateCoinDisplays();

    playVictorySound();
    triggerStarsConfetti();

    document.getElementById("celebration-header").textContent = `🎉 LEVEL ${letter} COMPLETE! 🎉`;
    document.getElementById("complete-total-score").textContent = `+100 XP`;
    document.getElementById("complete-total-coins").textContent = `+50`;

    const nextBtn = document.getElementById("next-level-btn-modal");
    if (currentLevelIndex < 25) {
        const nextLetter = alphabet[currentLevelIndex + 1];
        nextBtn.textContent = `🔓 LEVEL ${nextLetter} ➡️`;
        nextBtn.style.display = "block";
    } else {
        nextBtn.style.display = "none";
    }

    showScreen("complete-screen");

    // Persist level completion to Database via Backend API
    saveLevelCompleteToBackend(letter, currentLevelIndex);
}

function continueToNextLevel() {
    if (currentLevelIndex < 25) {
        currentLevelIndex++;
        showLevelScreen();
    }
}

/* Hint system options */
function useHint() {
    if (hintLimit <= 0 || !activeWordObj) return;

    const emptySlots = [...document.querySelectorAll(".slot")].filter(
        slot => !slot.classList.contains("filled")
    );
    if (emptySlots.length === 0) return;

    const targetSlot = emptySlots[0];
    const neededChar = targetSlot.dataset.correctChar;

    const deckLetters = [...document.querySelectorAll(".letters-deck .letter")];
    const correctLetterNode = deckLetters.find(
        node => node.dataset.char === neededChar && !node.classList.contains("used")
    );

    if (correctLetterNode) {
        hintLimit--;
        document.getElementById("hint-count").textContent = hintLimit;

        targetSlot.classList.add("glow-hint");
        setTimeout(() => targetSlot.classList.remove("glow-hint"), 1000);

        evaluateLetterPlacement(correctLetterNode, targetSlot);
        mistakeCount++;
    }
}

function restartWord() {
    startChallengeWord();
}

/* =====================================================
   💥 CONFETTI & COIN EXPLOSIONS
==================================================== */
function triggerCoinExplosion() {
    let coinsStat = document.querySelector(".screen.active .coins-badge");
    if (!coinsStat) {
        coinsStat = document.getElementById("coins-badge");
    }
    if (!coinsStat) return;
    const targetRect = coinsStat.getBoundingClientRect();

    const emojiBox = document.getElementById("word-emoji");
    if (!emojiBox) return;
    const sourceRect = emojiBox.getBoundingClientRect();

    const startX = sourceRect.left + sourceRect.width / 2;
    const startY = sourceRect.top + sourceRect.height / 2;
    const numCoins = 5;

    for (let i = 0; i < numCoins; i++) {
        setTimeout(() => {
            const coin = document.createElement("div");
            coin.innerHTML = `<svg class="coin-svg-inline" viewBox="0 0 24 24" style="width: 32px; height: 32px; filter: drop-shadow(0 2px 0 rgba(0,0,0,0.15));"><circle cx="12" cy="12" r="10" fill="#ffda43" stroke="#222" stroke-width="2"/><circle cx="12" cy="12" r="6" fill="#ffe97d" stroke="#222" stroke-width="1.5"/><path d="M12 9v6M10.5 10.5h3a1.5 1.5 0 0 0 0-3h-3M10.5 13.5h3a1.5 1.5 0 0 1 0 3h-3" fill="none" stroke="#222" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
            coin.style.position = "fixed";
            coin.style.left = `${startX}px`;
            coin.style.top = `${startY}px`;
            coin.style.fontSize = "32px";
            coin.style.zIndex = "999999";
            coin.style.pointerEvents = "none";
            coin.style.transition = "transform 0.75s cubic-bezier(0.25, 1, 0.5, 1), opacity 0.75s ease-in";
            document.body.appendChild(coin);

            const scatterX = (Math.random() - 0.5) * 120;
            const scatterY = (Math.random() - 0.5) * 120;

            coin.offsetHeight;

            coin.style.transform = `translate(${scatterX}px, ${scatterY}px) scale(1.3)`;

            setTimeout(() => {
                const currentRect = coin.getBoundingClientRect();
                const deltaX = (targetRect.left + targetRect.width / 2) - currentRect.left;
                const deltaY = (targetRect.top + targetRect.height / 2) - currentRect.top;

                coin.style.transform = `translate(${scatterX + deltaX}px, ${scatterY + deltaY}px) scale(0.6)`;
                coin.style.opacity = "0.4";

                setTimeout(() => {
                    coin.remove();

                    coins += 1;
                    localStorage.setItem("adventureCoins", coins);
                    updateCoinDisplays();

                    playChime();

                    if (i === numCoins - 1) {
                        coinsStat.classList.add("pop-animation");
                        setTimeout(() => coinsStat.classList.remove("pop-animation"), 300);
                    }
                }, 650);
            }, 180);
        }, i * 110);
    }
}

function triggerStarsConfetti() {
    const pieces = ["⭐", "🎉", "🐾", "✨", "🎊", "🪙"];
    for (let i = 0; i < 45; i++) {
        const piece = document.createElement("div");
        piece.textContent = pieces[Math.floor(Math.random() * pieces.length)];
        piece.style.position = "fixed";
        piece.style.left = `${Math.random() * 100}%`;
        piece.style.top = "-40px";
        piece.style.fontSize = `${18 + Math.random() * 25}px`;
        piece.style.zIndex = "9999";
        piece.style.pointerEvents = "none";

        document.body.appendChild(piece);

        const animation = piece.animate(
            [
                { transform: "translateY(0) rotate(0deg)", opacity: 1 },
                { transform: `translateY(${window.innerHeight + 150}px) rotate(${Math.random() * 1000}deg)`, opacity: 0 }
            ],
            {
                duration: 1600 + Math.random() * 1300,
                easing: "cubic-bezier(.2,.8,.3,1)"
            }
        );

        animation.onfinish = () => piece.remove();
    }
}

function triggerSparkleAnimation(element) {
    const rect = element.getBoundingClientRect();
    const startX = rect.left + rect.width / 2;
    const startY = rect.top + rect.height / 2;

    for (let i = 0; i < 8; i++) {
        const sparkle = document.createElement("div");
        sparkle.classList.add("sparkle");
        sparkle.textContent = "✨";
        sparkle.style.left = `${startX}px`;
        sparkle.style.top = `${startY}px`;

        const angle = Math.random() * Math.PI * 2;
        const speed = 40 + Math.random() * 50;
        const dx = `${Math.cos(angle) * speed}px`;
        const dy = `${Math.sin(angle) * speed}px`;
        const rot = `${(Math.random() - 0.5) * 720}deg`;

        sparkle.style.setProperty("--dx", dx);
        sparkle.style.setProperty("--dy", dy);
        sparkle.style.setProperty("--rot", rot);

        document.body.appendChild(sparkle);
        setTimeout(() => sparkle.remove(), 600);
    }
}

/* =====================================================
   🤩 MASCOT REACTIONS & ALERTS
===================================================== */
function reactMascot(type) {
    const mascot = document.getElementById("mascot");
    const mascotImg = document.getElementById("mascot-img");
    if (!mascot) return;

    if (mascotImg) {
        if (type === "correct") {
            mascotImg.style.transform = "scale(1.25) rotate(10deg)";
        } else {
            mascotImg.style.transform = "scale(0.9) rotate(-12deg)";
        }
        setTimeout(() => {
            mascotImg.style.transform = "";
        }, 850);
        return;
    }

    if (type === "correct") {
        mascot.textContent = "🤩";
        mascot.style.transform = "scale(1.35) rotate(8deg)";
    } else {
        mascot.textContent = "😭";
        mascot.style.transform = "rotate(-12deg)";
    }

    setTimeout(() => {
        mascot.textContent = "🐵";
        mascot.style.transform = "";
    }, 850);
}

function showToast(text) {
    const toast = document.getElementById("toast-message");
    if (!toast) return;

    toast.innerHTML = text;
    toast.classList.remove("show");

    void toast.offsetWidth;
    toast.classList.add("show");

    setTimeout(() => {
        toast.classList.remove("show");
    }, 1500);
}

/* =====================================================
   🔊 AUDIO TOGGLE SETTINGS
===================================================== */
function soundToggle() {
    soundEnabled = !soundEnabled;
    localStorage.setItem("adventureSound", soundEnabled);

    document.querySelectorAll(".sound-toggle-btn").forEach(btn => {
        btn.textContent = soundEnabled ? "🔊 Sound ON" : "🔇 Sound OFF";
    });

    if (!soundEnabled) {
        if (musicTimer) {
            clearTimeout(musicTimer);
            musicTimer = null;
        }
        musicStarted = false;
        showToast("🔇 Muted!");
        say("Sound Off!");
    } else {
        startAmbientMusic();
        tone(700, 0.12, "triangle", 0.08);
        showToast("🔊 Sound On!");
        say("Sound On!");
    }
}

/* =====================================================
   🔀 SHUFFLE ARRAY UTILITY
===================================================== */
function shuffleArray(array) {
    return array
        .map(value => ({ value, sort: Math.random() }))
        .sort((a, b) => a.sort - b.sort)
        .map(({ value }) => value);
}

/* =====================================================
   🚀 INIT ON APP STARTUP
===================================================== */
document.addEventListener("click", () => {
    startAmbientMusic();
}, { once: true });

document.querySelectorAll(".sound-toggle-btn").forEach(btn => {
    btn.textContent = soundEnabled ? "🔊 Sound ON" : "🔇 Sound OFF";
});

// Render initial view immediately (Start / Landing Screen from Image 1)
showStartScreen();

// Asynchronously load saved progress from MySQL database
loadProgressFromBackend();
