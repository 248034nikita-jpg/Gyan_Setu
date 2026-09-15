<?php
ob_start();
error_reporting(0);
ini_set('display_errors', '0');

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Load database connection
$root = dirname(dirname(dirname(__DIR__)));
require_once $root . '/database/includes/db_connect.php';

// Get parameters
$child_id = isset($_GET['child_id']) ? (int)$_GET['child_id'] : 0;
$level    = isset($_GET['level']) ? (int)$_GET['level'] : 1;

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

global $conn;

if (!$conn) {
    echo json_encode(['success' => false, 'error' => 'Database connection failed']);
    exit;
}

try {
    // Level 1 is always unlocked
    if ($level == 1) {
        echo json_encode([
            'success' => true,
            'unlocked' => true,
            'level' => $level,
            'message' => 'Level 1 is always unlocked'
        ]);
        exit;
    }
    
    // Check if previous level is completed
    $prevLevel = $level - 1;
    $sql = "SELECT completed FROM capybara_level_scores 
            WHERE child_id = ? AND level_number = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $child_id, $prevLevel);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    
    $unlocked = ($row && $row['completed'] == 1);
    
    echo json_encode([
        'success' => true,
        'unlocked' => $unlocked,
        'level' => $level,
        'previous_level' => $prevLevel,
        'previous_level_completed' => $unlocked ? true : false,
        'message' => $unlocked ? 'Level unlocked!' : 'Complete previous level first'
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error' => 'Error: ' . $e->getMessage()
    ]);
}
?>