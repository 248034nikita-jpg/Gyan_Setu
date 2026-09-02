<?php
header('Content-Type: application/json');
session_start();

// Protection: Check if logged in as Admin
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit();
}

include '../../database/includes/db_connect.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method Not Allowed']);
    exit();
}

// Retrieve input fields
$topic           = trim($_POST['topic'] ?? $_POST['target_group'] ?? 'general');
$concept         = trim($_POST['concept'] ?? $_POST['subcategory'] ?? 'General');
$question_text   = trim($_POST['question_text'] ?? $_POST['prompt'] ?? '');
$question_type   = trim($_POST['question_type'] ?? 'multiple_choice');
$difficulty_raw  = strtolower(trim($_POST['difficulty_tier'] ?? $_POST['difficulty'] ?? 'medium'));
$correct_answer  = trim($_POST['correct_answer'] ?? $_POST['answer'] ?? '');

// Map difficulty to tier (1: Easy, 2: Medium, 3: Hard)
$difficulty_tier = 2;
if ($difficulty_raw === 'easy' || $difficulty_raw === '1') {
    $difficulty_tier = 1;
} elseif ($difficulty_raw === 'hard' || $difficulty_raw === '3') {
    $difficulty_tier = 3;
}

if (empty($question_text) || empty($correct_answer)) {
    http_response_code(400);
    echo json_encode(['error' => 'Question prompt and correct answer are required.']);
    exit();
}

// Determine game_id and course_id (game_id = 1 is Whack-a-Mole)
$game_id = isset($_POST['game_id']) && is_numeric($_POST['game_id']) ? (int)$_POST['game_id'] : (($topic === 'grammar' || $topic === 'vocabulary' || $topic === 'english') ? 1 : null);
$course_id = isset($_POST['course_id']) && is_numeric($_POST['course_id']) ? (int)$_POST['course_id'] : (($topic === 'grammar' || $topic === 'vocabulary' || $topic === 'english') ? 1 : null);
$target_age_min = 3;
$target_age_max = 12;

$stmt = $conn->prepare("
    INSERT INTO quiz_questions (game_id, course_id, question_text, topic, concept, question_type, difficulty_tier, target_age_min, target_age_max)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
");

if (!$stmt) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $conn->error]);
    exit();
}

$stmt->bind_param("iissssiii", $game_id, $course_id, $question_text, $topic, $concept, $question_type, $difficulty_tier, $target_age_min, $target_age_max);

if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to save question: ' . $stmt->error]);
    $stmt->close();
    exit();
}

$question_id = $conn->insert_id;
$stmt->close();

// Save correct answer in quiz_options
$opt_stmt = $conn->prepare("INSERT INTO quiz_options (question_id, option_text, is_correct) VALUES (?, ?, 1)");
if ($opt_stmt) {
    $opt_stmt->bind_param("is", $question_id, $correct_answer);
    $opt_stmt->execute();
    $opt_stmt->close();
}

// Save any distractors (wrong options)
$distractors = [];
if (isset($_POST['distractors']) && is_array($_POST['distractors'])) {
    $distractors = $_POST['distractors'];
} else {
    foreach (['distractor_1', 'distractor_2', 'distractor_3'] as $d_key) {
        if (!empty($_POST[$d_key])) {
            $distractors[] = trim($_POST[$d_key]);
        }
    }
}

if (!empty($distractors)) {
    $dis_stmt = $conn->prepare("INSERT INTO quiz_options (question_id, option_text, is_correct) VALUES (?, ?, 0)");
    if ($dis_stmt) {
        foreach ($distractors as $dis_text) {
            $dis_text = trim($dis_text);
            if ($dis_text !== '') {
                $dis_stmt->bind_param("is", $question_id, $dis_text);
                $dis_stmt->execute();
            }
        }
        $dis_stmt->close();
    }
}

echo json_encode([
    'success' => true,
    'message' => 'Question successfully saved to vault.',
    'question_id' => $question_id
]);
?>
