<?php
/**
 * get_questions.php  (project root)
 * Returns 10 random questions for a given topic + difficulty tier (game_id=1 for Whack-a-Mole)
 * GET params: topic=grammar|vocabulary, tier=1|2|3
 *
 * Works on any device: resolves db path robustly and falls back to
 * built-in questions when the database is not yet set up.
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// ── 1. Resolve path to db_connect.php ─────────────────────────────────────
$db_path = __DIR__ . '/database/includes/db_connect.php';
if (!file_exists($db_path)) {
    $db_path = realpath(__DIR__ . '/..') . '/database/includes/db_connect.php';
}
if (!file_exists($db_path)) {
    $db_path = null;
}

// ── 2. Validate query params ───────────────────────────────────────────────
$topic  = strtolower(trim($_GET['topic'] ?? 'grammar'));
$tier   = intval($_GET['tier'] ?? 1);
$gameId = 1; // Whack-a-Mole game_id

if (!in_array($topic, ['grammar', 'vocabulary'])) {
    $topic = 'grammar';
}
if (!in_array($tier, [1, 2, 3])) {
    $tier = 1;
}

// ── 3. Try database first ──────────────────────────────────────────────────
$questions = [];

if ($db_path) {
    @include_once $db_path;

    if (isset($conn) && ($conn instanceof mysqli) && !$conn->connect_errno) {
        $stmt = $conn->prepare(
            "SELECT q.question_id, q.question_text, q.concept,
                   GROUP_CONCAT(o.option_id   ORDER BY o.option_id SEPARATOR '|||') AS option_ids,
                   GROUP_CONCAT(o.option_text ORDER BY o.option_id SEPARATOR '|||') AS option_texts,
                   GROUP_CONCAT(o.is_correct  ORDER BY o.option_id SEPARATOR '|||') AS is_corrects
            FROM quiz_questions q
            JOIN quiz_options o ON o.question_id = q.question_id
            WHERE q.game_id = ? AND q.topic = ? AND q.difficulty_tier = ?
            GROUP BY q.question_id
            ORDER BY RAND()
            LIMIT 10"
        );

        if ($stmt) {
            $stmt->bind_param('isi', $gameId, $topic, $tier);
            $stmt->execute();
            $result = $stmt->get_result();

            while ($row = $result->fetch_assoc()) {
                $options    = explode('|||', $row['option_texts']);
                $isCorrects = explode('|||', $row['is_corrects']);
                $correctIdx = 0;
                foreach ($isCorrects as $idx => $val) {
                    if ($val == '1') { $correctIdx = $idx; break; }
                }
                $questions[] = [
                    'question_id' => $row['question_id'],
                    'q'           => $row['question_text'],
                    'concept'     => $row['concept'],
                    'options'     => $options,
                    'correct'     => $correctIdx,
                ];
            }
            $stmt->close();
        }
    }
}

// ── 4. Built-in fallback questions (no database needed) ─────────────────
if (empty($questions)) {
    $fallbackPool = [
        'grammar' => [
            1 => [
                ['q' => 'She ___ a doctor.',           'options' => ['is', 'am', 'are', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'I ___ nine years old.',        'options' => ['am', 'is', 'are', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'They ___ playing outside.',    'options' => ['are', 'is', 'am', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'We ___ students.',             'options' => ['are', 'is', 'am', 'was'], 'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'He ___ my brother.',           'options' => ['is', 'am', 'are', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'You ___ very kind.',           'options' => ['are', 'is', 'am', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'It ___ a big elephant.',       'options' => ['is', 'am', 'are', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'My parents ___ farmers.',      'options' => ['are', 'is', 'am', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'I ___ happy today.',           'options' => ['am', 'is', 'are', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
                ['q' => 'The sky ___ blue.',            'options' => ['is', 'am', 'are', 'be'],  'correct' => 0, 'concept' => 'is / am / are'],
            ],
            2 => [
                ['q' => 'Yesterday, I ___ to the market.',    'options' => ['went', 'go', 'goes', 'going'],        'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'She ___ her lunch already.',         'options' => ['ate', 'eat', 'eats', 'eating'],       'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'We ___ a movie last night.',         'options' => ['watched', 'watch', 'watches', 'watching'], 'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'He ___ his homework before dinner.', 'options' => ['did', 'do', 'does', 'doing'],         'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'They ___ to Pokhara last month.',    'options' => ['travelled', 'travel', 'travels', 'travelling'], 'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'I ___ a letter to my friend.',       'options' => ['wrote', 'write', 'writes', 'writing'],'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'She ___ the door quietly.',          'options' => ['closed', 'close', 'closes', 'closing'],'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'We ___ football yesterday.',         'options' => ['played', 'play', 'plays', 'playing'], 'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'He ___ his keys this morning.',      'options' => ['lost', 'lose', 'loses', 'losing'],    'correct' => 0, 'concept' => 'simple past tense'],
                ['q' => 'I ___ very happy yesterday.',        'options' => ['was', 'am', 'is', 'are'],             'correct' => 0, 'concept' => 'simple past tense'],
            ],
            3 => [
                ['q' => 'Tomorrow, I ___ visit my grandmother.', 'options' => ['will', 'am', 'shall go', 'going'], 'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'She ___ finish her project by tomorrow.','options' => ['will', 'is', 'was', 'are'],       'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'If it rains, we ___ stay inside.',      'options' => ['will', 'would', 'shall', 'are'],   'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'Next year, he ___ join a new school.',  'options' => ['will', 'is', 'was', 'has'],        'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'We ___ go to the market later.',        'options' => ['will', 'are', 'were', 'had'],      'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'They ___ visit us next weekend.',       'options' => ['will', 'are', 'were', 'had'],      'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'I ___ call you after school.',          'options' => ['will', 'am', 'was', 'have'],       'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'She ___ not come to the party.',        'options' => ['will', 'is', 'was', 'can'],        'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'He ___ travel to Pokhara next month.',  'options' => ['will', 'is', 'was', 'has'],        'correct' => 0, 'concept' => 'future tense (will)'],
                ['q' => 'We ___ start the game soon.',           'options' => ['will', 'are', 'were', 'have'],     'correct' => 0, 'concept' => 'future tense (will)'],
            ],
        ],
        'vocabulary' => [
            1 => [
                ['q' => 'Opposite of "big"',   'options' => ['small', 'large', 'huge', 'tall'],    'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "happy"', 'options' => ['sad', 'glad', 'angry', 'joyful'],    'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "hot"',   'options' => ['cold', 'warm', 'cool', 'frozen'],    'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "fast"',  'options' => ['slow', 'quick', 'swift', 'speedy'],  'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "open"',  'options' => ['closed', 'wide', 'shut', 'near'],    'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "day"',   'options' => ['night', 'morning', 'noon', 'dusk'],  'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "up"',    'options' => ['down', 'above', 'high', 'over'],     'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "full"',  'options' => ['empty', 'heavy', 'large', 'wide'],   'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "tall"',  'options' => ['short', 'long', 'fat', 'wide'],      'correct' => 0, 'concept' => 'opposites'],
                ['q' => 'Opposite of "clean"', 'options' => ['dirty', 'bright', 'fresh', 'neat'],  'correct' => 0, 'concept' => 'opposites'],
            ],
            2 => [
                ['q' => 'Synonym of "happy"',    'options' => ['joyful', 'sad', 'angry', 'tired'],     'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "big"',       'options' => ['large', 'small', 'thin', 'short'],    'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "quick"',     'options' => ['fast', 'slow', 'lazy', 'careful'],    'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "beautiful"', 'options' => ['lovely', 'ugly', 'plain', 'dull'],    'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "smart"',     'options' => ['clever', 'foolish', 'dull', 'slow'],  'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "sad"',       'options' => ['unhappy', 'glad', 'joyful', 'merry'], 'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "small"',     'options' => ['tiny', 'huge', 'tall', 'wide'],       'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "brave"',     'options' => ['courageous', 'scared', 'shy', 'weak'],'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "kind"',      'options' => ['caring', 'mean', 'rude', 'harsh'],    'correct' => 0, 'concept' => 'synonyms'],
                ['q' => 'Synonym of "angry"',     'options' => ['furious', 'happy', 'calm', 'joyful'], 'correct' => 0, 'concept' => 'synonyms'],
            ],
            3 => [
                ['q' => 'She felt ___ after winning the race.',       'options' => ['proud', 'sad', 'bored', 'tired'],      'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'The weather was ___, so we stayed indoors.', 'options' => ['stormy', 'sunny', 'mild', 'warm'],     'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'He is very ___; he always helps others.',    'options' => ['generous', 'selfish', 'rude', 'lazy'], 'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'After running an hour, he felt completely ___.', 'options' => ['exhausted', 'fresh', 'happy', 'strong'], 'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'The teacher asked him to ___ his answer clearly.', 'options' => ['explain', 'hide', 'ignore', 'copy'], 'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'She whispered ___ so no one could hear.',    'options' => ['softly', 'loudly', 'clearly', 'quickly'], 'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'The puppy was full of energy and very ___.',  'options' => ['playful', 'tired', 'quiet', 'lazy'],  'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'He works hard to ___ his family safe.',      'options' => ['keep', 'make', 'let', 'bring'],        'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'Her ___ about space made her read many books.', 'options' => ['curiosity', 'fear', 'anger', 'sadness'], 'correct' => 0, 'concept' => 'context-based word choice'],
                ['q' => 'He is known to be ___ and never lies.',      'options' => ['honest', 'sneaky', 'rude', 'greedy'],  'correct' => 0, 'concept' => 'context-based word choice'],
            ],
        ],
    ];

    $pool = $fallbackPool[$topic][$tier] ?? $fallbackPool[$topic][1];
    shuffle($pool);
    $pool = array_slice($pool, 0, 10);

    foreach ($pool as $i => $q) {
        $opts        = $q['options'];
        $correctText = $opts[$q['correct']];
        shuffle($opts);
        $newCorrectIndex = array_search($correctText, $opts);

        $questions[] = [
            'question_id' => $i + 1,
            'q'           => $q['q'],
            'concept'     => $q['concept'],
            'options'     => $opts,
            'correct'     => (int) $newCorrectIndex,
        ];
    }
}

echo json_encode(['questions' => $questions]);
?>