<?php
session_start();

// --- Resolve child ID from session (same logic as child_dashboard.php) ---
if (!isset($_SESSION['role']) || !in_array($_SESSION['role'], ['child', 'parent'])) {
    // Not logged in as child or parent – redirect to login
    header("Location: login.php");
    exit();
}

define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'gyan_setu');

// Database connection
$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
if ($mysqli->connect_error) {
    sendJson(['error' => 'Database connection failed: ' . $mysqli->connect_error], 500);
}
$mysqli->set_charset('utf8mb4');

// --- Determine child_id based on role ---
if ($_SESSION['role'] === 'child') {
    $child_id = $_SESSION['user_id'];
} else { // parent
    $parent_id = $_SESSION['user_id'];
    $stmt = $mysqli->prepare("SELECT child_id FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
    $stmt->bind_param("i", $parent_id);
    $stmt->execute();
    $res = $stmt->get_result();
    if ($row = $res->fetch_assoc()) {
        $child_id = $row['child_id'];
    } else {
        // Parent has no child yet – redirect to create one
        header("Location: child_profilesetuppage.php");
        exit();
    }
    $stmt->close();
}

// Now $child_id is available for all functions

/** Sending JSON response and exit */
function sendJson($data, $status = 200) {
    http_response_code($status);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

// --- All functions remain the same, using the updated table names ---
function getSubjects() {
    global $mysqli;
    $result = $mysqli->query("SELECT subject_id, name_en, name_ne, icon, description_en, description_ne FROM flashcard_subjects WHERE is_active=1");
    $subjects = [];
    while ($row = $result->fetch_assoc()) {
        $subjects[] = $row;
    }
    return $subjects;
}

function getLevels($subject_id) {
    global $mysqli;
    $stmt = $mysqli->prepare("SELECT level_id, level_name_en, level_name_ne, icon, difficulty_tier, description_en, description_ne FROM flashcard_levels WHERE subject_id=? AND is_active=1 ORDER BY difficulty_tier");
    $stmt->bind_param('i', $subject_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $levels = [];
    while ($row = $result->fetch_assoc()) {
        $levels[] = $row;
    }
    return $levels;
}

function getQuestions($level_id) {
    global $mysqli;
    $stmt = $mysqli->prepare("SELECT question_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order FROM flashcard_questions WHERE level_id=?");
    $stmt->bind_param('i', $level_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $questions = [];
    while ($row = $result->fetch_assoc()) {
        $q = [
            'question_id' => $row['question_id'],
            'type' => $row['type'],
            'question' => $row['question_en'],
            'question_ne' => $row['question_ne'],
            'hint' => $row['hint_en'],
            'hint_ne' => $row['hint_ne'],
            'fun_fact' => $row['fun_fact_en'],
            'fun_fact_ne' => $row['fun_fact_ne'],
        ];
        if ($row['type'] === 'mcq') {
            $optStmt = $mysqli->prepare("SELECT option_id, option_text_en, option_text_ne, emoji, is_correct FROM flashcard_options WHERE question_id=?");
            $optStmt->bind_param('i', $row['question_id']);
            $optStmt->execute();
            $optRes = $optStmt->get_result();
            $options = [];
            while ($opt = $optRes->fetch_assoc()) {
                $options[] = [
                    'label' => $opt['option_text_en'],
                    'label_ne' => $opt['option_text_ne'],
                    'emoji' => $opt['emoji'],
                    'is_correct' => (bool)$opt['is_correct']
                ];
            }
            shuffle($options);
            $correctIndex = null;
            foreach ($options as $i => $opt) {
                if ($opt['is_correct']) {
                    $correctIndex = $i;
                    break;
                }
            }
            foreach ($options as &$opt) unset($opt['is_correct']);
            $q['options'] = $options;
            $q['correct'] = $correctIndex;
        } elseif ($row['type'] === 'puzzle') {
            $itemStmt = $mysqli->prepare("SELECT item_id_code, item_label_en, item_label_ne, emoji FROM flashcard_puzzle_items WHERE question_id=? ORDER BY item_id_code");
            $itemStmt->bind_param('i', $row['question_id']);
            $itemStmt->execute();
            $itemRes = $itemStmt->get_result();
            $items = [];
            while ($item = $itemRes->fetch_assoc()) {
                $items[] = [
                    'id' => $item['item_id_code'],
                    'label' => $item['item_label_en'],
                    'label_ne' => $item['item_label_ne'],
                    'emoji' => $item['emoji']
                ];
            }
            $q['items'] = $items;
            $q['correctOrder'] = json_decode($row['correct_order'], true);
        }
        $questions[] = $q;
    }
    return $questions;
}

function getFlashcards($level_id) {
    global $mysqli;
    $deckStmt = $mysqli->prepare("SELECT deck_id FROM flashcard_decks WHERE level_id=?");
    $deckStmt->bind_param('i', $level_id);
    $deckStmt->execute();
    $deckRes = $deckStmt->get_result();
    if ($deckRes->num_rows === 0) return [];
    $deck = $deckRes->fetch_assoc();
    $deck_id = $deck['deck_id'];

    $cardStmt = $mysqli->prepare("SELECT card_id, card_icon, name_en, name_ne, subtitle_en, subtitle_ne, tag_en, tag_ne, facts_en, facts_ne FROM flashcard_cards WHERE deck_id=?");
    $cardStmt->bind_param('i', $deck_id);
    $cardStmt->execute();
    $cardRes = $cardStmt->get_result();
    $cards = [];
    while ($card = $cardRes->fetch_assoc()) {
        $cards[] = [
            'id' => $card['card_id'],
            'icon' => $card['card_icon'],
            'name' => $card['name_en'],
            'name_ne' => $card['name_ne'],
            'subtitle' => $card['subtitle_en'],
            'subtitle_ne' => $card['subtitle_ne'],
            'tag' => $card['tag_en'],
            'tag_ne' => $card['tag_ne'],
            'facts' => json_decode($card['facts_en'], true),
            'facts_ne' => json_decode($card['facts_ne'], true)
        ];
    }
    return $cards;
}

function saveQuestionAttempt($child_id, $question_id, $is_correct, $stars, $coins) {
    global $mysqli;
    $correct_attempts = $is_correct ? 1 : 0;
    $stmt = $mysqli->prepare("INSERT INTO child_flashcard_question_progress (child_id, question_id, attempts, correct_attempts, stars_earned, coins_earned) 
                              VALUES (?, ?, 1, ?, ?, ?) 
                              ON DUPLICATE KEY UPDATE 
                              attempts = attempts + 1, 
                              correct_attempts = correct_attempts + VALUES(correct_attempts),
                              stars_earned = stars_earned + VALUES(stars_earned),
                              coins_earned = coins_earned + VALUES(coins_earned)");
    $stmt->bind_param('iiiii', $child_id, $question_id, $correct_attempts, $stars, $coins);
    $stmt->execute();
    return $stmt->affected_rows !== -1;
}

function saveFlashcardFlip($child_id, $card_id, $stars) {
    global $mysqli;
    $stmt = $mysqli->prepare("INSERT INTO child_flashcard_card_progress (child_id, card_id, flipped_count, stars_earned) 
                              VALUES (?, ?, 1, ?) 
                              ON DUPLICATE KEY UPDATE 
                              flipped_count = flipped_count + 1, 
                              stars_earned = stars_earned + VALUES(stars_earned)");
    $stmt->bind_param('iii', $child_id, $card_id, $stars);
    $stmt->execute();
    return $stmt->affected_rows !== -1;
}

function updateChildTotals($child_id, $stars, $coins) {
    global $mysqli;
    $stmt = $mysqli->prepare("UPDATE children SET total_stars = total_stars + ?, total_coins = total_coins + ? WHERE child_id = ?");
    $stmt->bind_param('iii', $stars, $coins, $child_id);
    $stmt->execute();
    return $stmt->affected_rows > 0;
}

function getChildStats($child_id) {
    global $mysqli;
    $stmt = $mysqli->prepare("SELECT total_stars, total_coins FROM children WHERE child_id = ?");
    $stmt->bind_param('i', $child_id);
    $stmt->execute();
    $result = $stmt->get_result();
    return $result->fetch_assoc();
}

// --- API Routing ---
$action = $_GET['action'] ?? '';

switch ($action) {
    case 'subjects':
        sendJson(['subjects' => getSubjects()]);
        break;

    case 'levels':
        $subject_id = intval($_GET['subject_id'] ?? 0);
        if ($subject_id <= 0) sendJson(['error' => 'Missing or invalid subject_id'], 400);
        sendJson(['levels' => getLevels($subject_id)]);
        break;

    case 'questions':
        $level_id = intval($_GET['level_id'] ?? 0);
        if ($level_id <= 0) sendJson(['error' => 'Missing or invalid level_id'], 400);
        sendJson(['questions' => getQuestions($level_id)]);
        break;

    case 'flashcards':
        $level_id = intval($_GET['level_id'] ?? 0);
        if ($level_id <= 0) sendJson(['error' => 'Missing or invalid level_id'], 400);
        sendJson(['flashcards' => getFlashcards($level_id)]);
        break;

    case 'stats':
        $stats = getChildStats($child_id);
        if ($stats) sendJson(['stats' => $stats]);
        sendJson(['error' => 'Child not found'], 404);
        break;

    case 'save_question':
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data) sendJson(['error' => 'Invalid JSON'], 400);
        $question_id = intval($data['question_id'] ?? 0);
        $is_correct = isset($data['is_correct']) ? (bool)$data['is_correct'] : false;
        $stars = intval($data['stars'] ?? 0);
        $coins = intval($data['coins'] ?? 0);
        if ($question_id <= 0) sendJson(['error' => 'Missing question_id'], 400);

        if (!saveQuestionAttempt($child_id, $question_id, $is_correct, $stars, $coins))
            sendJson(['error' => 'Failed to save progress'], 500);
        updateChildTotals($child_id, $stars, $coins);
        sendJson(['success' => true, 'stats' => getChildStats($child_id)]);
        break;

    case 'save_flashcard':
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data) sendJson(['error' => 'Invalid JSON'], 400);
        $card_id = intval($data['card_id'] ?? 0);
        $stars = intval($data['stars'] ?? 0);
        if ($card_id <= 0) sendJson(['error' => 'Missing card_id'], 400);

        if (!saveFlashcardFlip($child_id, $card_id, $stars))
            sendJson(['error' => 'Failed to save flashcard progress'], 500);
        updateChildTotals($child_id, $stars, 0);
        sendJson(['success' => true, 'stats' => getChildStats($child_id)]);
        break;

    default:
        sendJson(['error' => 'Invalid action'], 400);
}
?>