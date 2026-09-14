<?php
ob_start();
error_reporting(0);
ini_set('display_errors', '0');

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Load your database connection
$root = dirname(dirname(dirname(__DIR__)));
require_once $root . '/database/includes/db_connect.php';

// Get parameters from URL
$child_id = isset($_GET['child_id']) ? (int)$_GET['child_id'] : 0;
$level    = isset($_GET['level']) ? (int)$_GET['level'] : 1;
$language = isset($_GET['lang']) ? $_GET['lang'] : 'en'; // Default: English

if ($child_id <= 0) {
    if (isset($_SESSION['role'], $_SESSION['user_id'])) {
        if ($_SESSION['role'] === 'child') {
            $child_id = (int) $_SESSION['user_id'];
        } elseif ($_SESSION['role'] === 'parent' && isset($conn) && $conn && !$conn->connect_errno) {
            $parentId = (int) $_SESSION['user_id'];
            $pStmt = $conn->prepare("SELECT child_id FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
            if ($pStmt) {
                $pStmt->bind_param("i", $parentId);
                $pStmt->execute();
                $pRes = $pStmt->get_result();
                if ($pRes && ($pRow = $pRes->fetch_assoc())) {
                    $child_id = (int) $pRow['child_id'];
                }
                $pStmt->close();
            }
        }
    }
}

if ($child_id <= 0 && isset($_SESSION['child_id']) && (int)$_SESSION['child_id'] > 0) {
    $child_id = (int)$_SESSION['child_id'];
}

if ($child_id <= 0 && isset($conn) && $conn && !$conn->connect_errno) {
    $cQuery = $conn->query("SELECT child_id FROM children ORDER BY created_at ASC LIMIT 1");
    if ($cQuery && ($cRow = $cQuery->fetch_assoc())) {
        $child_id = (int)$cRow['child_id'];
    }
}

if ($child_id <= 0) {
    $child_id = 1;
}

// Check if database connection works
if (!$conn) {
    echo json_encode(['success' => false, 'error' => 'Database connection failed']);
    exit;
}

// 1. FETCH 3 FACTS FOR THIS LEVEL (Bilingual!)

// Choose which language columns to use
if ($language === 'np') {
    $factCol = 'fact_np AS fact';
    $thinkQuestionCol = 'think_question_np AS think_question';
    $thinkOptionsCol = 'think_options_np AS think_options';
    $applyQuestionCol = 'apply_question_np AS apply_question';
    $applyOptionsCol = 'apply_options_np AS apply_options';
    $explanationCol = 'explanation_np AS explanation';
} else {
    // Default: English
    $factCol = 'fact_en AS fact';
    $thinkQuestionCol = 'think_question_en AS think_question';
    $thinkOptionsCol = 'think_options_en AS think_options';
    $applyQuestionCol = 'apply_question_en AS apply_question';
    $applyOptionsCol = 'apply_options_en AS apply_options';
    $explanationCol = 'explanation_en AS explanation';
}

$sql = "SELECT 
            content_id,
            level_number,
            {$factCol},
            {$thinkQuestionCol},
            {$thinkOptionsCol},
            think_correct_index,
            {$applyQuestionCol},
            {$applyOptionsCol},
            apply_correct_index,
            {$explanationCol}
        FROM capybara_learning_content
        WHERE level_number = ?
        ORDER BY content_id";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $level);
$stmt->execute();
$result = $stmt->get_result();

$contents = [];

while ($row = $result->fetch_assoc()) {
    // Convert JSON strings to PHP arrays
    $row['think_options'] = json_decode($row['think_options'], true);
    $row['apply_options'] = json_decode($row['apply_options'], true);
    $contents[] = $row;
}

// 2. FETCH CHILD'S PROGRESS (Same for both languages)

$progressMap = [];

if (!empty($contents)) {
    $contentIds = [];
    foreach ($contents as $c) {
        $contentIds[] = $c['content_id'];
    }
    
    $placeholders = implode(',', array_fill(0, count($contentIds), '?'));
    $types = str_repeat('i', count($contentIds) + 1);
    $params = array_merge([$child_id], $contentIds);
    
    $progSql = "SELECT 
                    content_id,
                    attempts,
                    correct_attempts,
                    next_review_level
                FROM capybara_child_progress
                WHERE child_id = ? AND content_id IN ({$placeholders})";
    
    $progStmt = $conn->prepare($progSql);
    $progStmt->bind_param($types, ...$params);
    $progStmt->execute();
    $progResult = $progStmt->get_result();
    
    while ($row = $progResult->fetch_assoc()) {
        $progressMap[$row['content_id']] = $row;
    }
}

// Attach progress to each content
foreach ($contents as &$content) {
    $content['progress'] = isset($progressMap[$content['content_id']]) 
        ? $progressMap[$content['content_id']] 
        : null;
}

// 3. FETCH LEVEL SCORE (Same for both languages)

$scoreSql = "SELECT 
                coins_earned,
                oranges_collected,
                knowledge_mastered,
                completed
            FROM capybara_level_scores
            WHERE child_id = ? AND level_number = ?";

$scoreStmt = $conn->prepare($scoreSql);
$scoreStmt->bind_param("ii", $child_id, $level);
$scoreStmt->execute();
$scoreResult = $scoreStmt->get_result();
$score = $scoreResult->fetch_assoc();

if (!$score) {
    $score = [
        'coins_earned' => 0,
        'oranges_collected' => 0,
        'knowledge_mastered' => 0,
        'completed' => 0
    ];
}

// 4. GET CHILD'S WALLET TOTAL COINS
$totalChildCoins = 0;
$cStmt = $conn->prepare("SELECT total_coins FROM children WHERE child_id = ?");
if ($cStmt) {
    $cStmt->bind_param("i", $child_id);
    $cStmt->execute();
    $cRes = $cStmt->get_result()->fetch_assoc();
    if ($cRes) {
        $totalChildCoins = (int)$cRes['total_coins'];
    }
    $cStmt->close();
}

// 5. SEND RESPONSE (Includes language used & wallet total coins)
ob_clean();
echo json_encode([
    'success'     => true,
    'child_id'    => $child_id,
    'level'       => $level,
    'language'    => $language,
    'total_coins' => $totalChildCoins,
    'contents'    => $contents,
    'score'       => $score
]);
exit;