<?php
/**
 * get_questions.php
 * Returns 10 random questions for a given topic + difficulty tier (game_id=1 for Whack-a-Mole)
 * GET params: topic=grammar|vocabulary, tier=1|2|3
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Allow relative include from wack-a-mole subfolder
$root = realpath(__DIR__ . '/../../');
$db_path = $root . '/database/includes/db_connect.php';

if (!$db_path || !file_exists($db_path)) {
    echo json_encode(['error' => 'DB config not found.']);
    exit;
}

require $db_path;

if (!isset($conn) || !($conn instanceof mysqli)) {
    echo json_encode(['error' => 'Database connection is unavailable.']);
    exit;
}

$topic = strtolower(trim($_GET['topic'] ?? 'grammar'));
$tier  = intval($_GET['tier'] ?? 1);
$gameId = 1; // Whack-a-Mole game_id

// Validate topic
if (!in_array($topic, ['grammar', 'vocabulary'])) {
    $topic = 'grammar';
}
// Validate tier
if (!in_array($tier, [1, 2, 3])) {
    $tier = 1;
}

// Get 10 random questions for this topic + tier
$stmt = $conn->prepare("
    SELECT q.question_id, q.question_text, q.concept,
           GROUP_CONCAT(o.option_id ORDER BY o.option_id SEPARATOR '|||') AS option_ids,
           GROUP_CONCAT(o.option_text ORDER BY o.option_id SEPARATOR '|||') AS option_texts,
           GROUP_CONCAT(o.is_correct ORDER BY o.option_id SEPARATOR '|||') AS is_corrects
    FROM quiz_questions q
    JOIN quiz_options o ON o.question_id = q.question_id
    WHERE q.game_id = ? AND q.topic = ? AND q.difficulty_tier = ?
    GROUP BY q.question_id
    ORDER BY RAND()
    LIMIT 10
");
$stmt->bind_param('isi', $gameId, $topic, $tier);
$stmt->execute();
$result = $stmt->get_result();

$questions = [];
while ($row = $result->fetch_assoc()) {
    $optionTexts   = explode('|||', $row['option_texts']);
    $isCorrects    = explode('|||', $row['is_corrects']);

    // Build options array and find correct index
    $options = [];
    $correctIndex = 0;
    for ($i = 0; $i < count($optionTexts); $i++) {
        $options[] = $optionTexts[$i];
        if ($isCorrects[$i] == '1') {
            $correctIndex = $i;
        }
    }

    // Shuffle options (keep track of correct index)
    $combined = array_map(null, $options, $isCorrects);
    shuffle($combined);
    $shuffledOptions = array_column($combined, 0);
    $shuffledCorrects = array_column($combined, 1);
    $newCorrectIndex = array_search('1', $shuffledCorrects);

    $questions[] = [
        'id'      => (int)$row['question_id'],
        'q'       => $row['question_text'],
        'concept' => $row['concept'],
        'options' => $shuffledOptions,
        'correct' => (int)$newCorrectIndex
    ];
}

$stmt->close();

if (empty($questions)) {
    // Fallback: return from any tier if exact tier has no questions
    $stmt2 = $conn->prepare("
        SELECT q.question_id, q.question_text, q.concept,
               GROUP_CONCAT(o.option_text ORDER BY o.option_id SEPARATOR '|||') AS option_texts,
               GROUP_CONCAT(o.is_correct ORDER BY o.option_id SEPARATOR '|||') AS is_corrects
        FROM quiz_questions q
        JOIN quiz_options o ON o.question_id = q.question_id
        WHERE q.game_id = ? AND q.topic = ?
        GROUP BY q.question_id
        ORDER BY RAND()
        LIMIT 10
    ");
    $stmt2->bind_param('is', $gameId, $topic);
    $stmt2->execute();
    $result2 = $stmt2->get_result();
    while ($row = $result2->fetch_assoc()) {
        $optionTexts = explode('|||', $row['option_texts']);
        $isCorrects  = explode('|||', $row['is_corrects']);
        $combined = array_map(null, $optionTexts, $isCorrects);
        shuffle($combined);
        $shuffledOptions  = array_column($combined, 0);
        $shuffledCorrects = array_column($combined, 1);
        $newCorrectIndex  = (int)array_search('1', $shuffledCorrects);
        $questions[] = [
            'id'      => (int)$row['question_id'],
            'q'       => $row['question_text'],
            'concept' => $row['concept'],
            'options' => $shuffledOptions,
            'correct' => $newCorrectIndex
        ];
    }
    $stmt2->close();
}

echo json_encode(['questions' => $questions, 'topic' => $topic, 'tier' => $tier]);
?>