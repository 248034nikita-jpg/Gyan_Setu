<?php
/**
 * get_questions.php
 * Returns 10 random questions for a given topic + difficulty tier (game_id=1 for Whack-a-Mole)
 * GET params: topic=grammar|vocabulary, tier=1|2|3
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
// Allow relative include from wack-a-mole subfolder
$db_path = __DIR__ . '/database/includes/db_connect.php';
if (!file_exists($db_path)) {
    // Fallback to parent directory if needed
    $db_path = realpath(__DIR__ . '/..') . '/database/includes/db_connect.php';
}
if (!file_exists($db_path)) {
    echo json_encode(['error' => 'DB config not found at: ' . $db_path]);
    exit;
}
include $db_path;
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
$stmt = $conn->prepare(
        "SELECT q.question_id, q.question_text, q.concept,
               GROUP_CONCAT(o.option_id ORDER BY o.option_id SEPARATOR '|||') AS option_ids,
               GROUP_CONCAT(o.option_text ORDER BY o.option_id SEPARATOR '|||') AS option_texts,
               GROUP_CONCAT(o.is_correct ORDER BY o.option_id SEPARATOR '|||') AS is_corrects
        FROM quiz_questions q
        JOIN quiz_options o ON o.question_id = q.question_id
        WHERE q.game_id = ? AND q.topic = ? AND q.difficulty_tier = ?
        GROUP BY q.question_id
        ORDER BY RAND()
        LIMIT 10"
    );
    // Bind parameters: gameId (int), topic (string), tier (int)
    $stmt->bind_param('isi', $gameId, $topic, $tier);
    $stmt->execute();
    $result = $stmt->get_result();
    $questions = [];
    while ($row = $result->fetch_assoc()) {
        $options = explode('|||', $row['option_texts']);
        $isCorrects = explode('|||', $row['is_corrects']);
        $correctIdx = 0;
        foreach ($isCorrects as $idx => $val) {
            if ($val == '1') { $correctIdx = $idx; break; }
        }
        $questions[] = [
            'question_id' => $row['question_id'],
            'q' => $row['question_text'],
            'concept' => $row['concept'],
            'options' => $options,
            'correct' => $correctIdx
        ];
    }
    $stmt->close();
    echo json_encode(['questions' => $questions]);