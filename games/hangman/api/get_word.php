<?php
/**
 * get_word.php
 * Hangman - Get a random word by category and difficulty tier.
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$dbPath = __DIR__ . '/../../../database/includes/db_connect.php';
if (!file_exists($dbPath)) {
    echo json_encode(['success' => false, 'error' => 'Database connection not found']);
    exit;
}
require_once $dbPath;

$tier = isset($_GET['tier']) ? (int)$_GET['tier'] : 1;
if (!in_array($tier, [1, 2, 3])) $tier = 1;

$category = isset($_GET['category']) ? trim($_GET['category']) : 'mammals';
$allowedCategories = ['mammals', 'birds', 'reptiles', 'amphibians'];
if (!in_array($category, $allowedCategories)) $category = 'mammals';

// Optional: exclude words the child already played
$exclude = isset($_GET['exclude']) ? $_GET['exclude'] : '';
$excludeIds = [];
if ($exclude) {
    $excludeIds = array_filter(array_map('intval', explode(',', $exclude)));
}

// Build query
if (count($excludeIds) > 0) {
    $placeholders = implode(',', array_fill(0, count($excludeIds), '?'));
    $sql = "SELECT word_id, word, hint, category, difficulty_tier 
            FROM hangman_words 
            WHERE difficulty_tier = ? AND category = ? AND word_id NOT IN ($placeholders)
            ORDER BY RAND() 
            LIMIT 1";
    $types = 'is' . str_repeat('i', count($excludeIds));
    $params = array_merge([$tier, $category], $excludeIds);
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);
} else {
    $sql = "SELECT word_id, word, hint, category, difficulty_tier 
            FROM hangman_words 
            WHERE difficulty_tier = ? AND category = ?
            ORDER BY RAND() 
            LIMIT 1";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('is', $tier, $category);
}

$stmt->execute();
$word = $stmt->get_result()->fetch_assoc();
$stmt->close();

// If no word found (all played), just pick any from that category
if (!$word) {
    $stmt = $conn->prepare("SELECT word_id, word, hint, category, difficulty_tier 
                            FROM hangman_words 
                            WHERE difficulty_tier = ? AND category = ?
                            ORDER BY RAND() 
                            LIMIT 1");
    $stmt->bind_param('is', $tier, $category);
    $stmt->execute();
    $word = $stmt->get_result()->fetch_assoc();
    $stmt->close();
}

if (!$word) {
    echo json_encode(['success' => false, 'error' => 'No words found for ' . $category . ' tier ' . $tier]);
    exit;
}

echo json_encode([
    'success' => true,
    'word_id' => (int)$word['word_id'],
    'word' => $word['word'],
    'hint' => $word['hint'],
    'category' => $word['category'],
    'difficulty_tier' => (int)$word['difficulty_tier']
]);