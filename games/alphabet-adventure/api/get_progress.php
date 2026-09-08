<?php
/**
 * get_progress.php
 * Alphabet Adventure - Load child progress, coin balance, and completed levels from database.
 */
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

session_start();

// Database connection
$dbPath = __DIR__ . '/../../../database/includes/db_connect.php';
if (!file_exists($dbPath)) {
    echo json_encode(['success' => false, 'error' => 'Database connection file not found']);
    exit;
}
require_once $dbPath;

// Determine child ID
$child_id = 0;
if (isset($_GET['child_id']) && (int)$_GET['child_id'] > 0) {
    $child_id = (int)$_GET['child_id'];
} elseif (isset($_SESSION['user_id']) && isset($_SESSION['role'])) {
    if ($_SESSION['role'] === 'child') {
        $child_id = (int)$_SESSION['user_id'];
    } elseif ($_SESSION['role'] === 'parent') {
        $parentId = (int)$_SESSION['user_id'];
        $cStmt = $conn->prepare("SELECT child_id FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
        if ($cStmt) {
            $cStmt->bind_param("i", $parentId);
            $cStmt->execute();
            $cRes = $cStmt->get_result()->fetch_assoc();
            if ($cRes) {
                $child_id = (int)$cRes['child_id'];
            }
            $cStmt->close();
        }
    }
}

if ($child_id <= 0) {
    echo json_encode([
        'success'          => true,
        'guest'            => true,
        'child_id'         => 0,
        'username'         => 'Player',
        'total_coins'      => 0,
        'completed_count'  => 0,
        'completed_levels' => [],
        'word_stars'       => new stdClass(),
        'sound_enabled'    => true,
        'accuracy'         => 100
    ]);
    exit;
}

try {
    // 1. Fetch child profile data
    $childStmt = $conn->prepare("SELECT username, total_coins, current_level FROM children WHERE child_id = ?");
    $childStmt->bind_param("i", $child_id);
    $childStmt->execute();
    $childData = $childStmt->get_result()->fetch_assoc();
    $childStmt->close();

    $username = $childData ? $childData['username'] : 'Player';
    $total_coins = $childData ? (int)$childData['total_coins'] : 0;

    // 2. Fetch completed words / stages
    $progStmt = $conn->prepare("SELECT level_letter, word_index, stars, mistakes FROM alphabet_adventure_progress WHERE child_id = ? AND completed = 1");
    $progStmt->bind_param("i", $child_id);
    $progStmt->execute();
    $progRes = $progStmt->get_result();

    $word_stars = [];
    $completed_count = 0;
    while ($row = $progRes->fetch_assoc()) {
        $key = $row['level_letter'] . '-' . $row['word_index'];
        $word_stars[$key] = (int)$row['stars'];
        $completed_count++;
    }
    $progStmt->close();

    // 3. Fetch completed full levels (A-Z)
    $lvlStmt = $conn->prepare("SELECT level_index FROM alphabet_adventure_levels WHERE child_id = ? AND is_completed = 1");
    $lvlStmt->bind_param("i", $child_id);
    $lvlStmt->execute();
    $lvlRes = $lvlStmt->get_result();

    $completed_levels = [];
    while ($row = $lvlRes->fetch_assoc()) {
        $completed_levels[] = (int)$row['level_index'];
    }
    $lvlStmt->close();

    // 4. Fetch sound preference
    $sound_enabled = true;
    $setStmt = $conn->prepare("SELECT sound_enabled FROM alphabet_adventure_settings WHERE child_id = ?");
    if ($setStmt) {
        $setStmt->bind_param("i", $child_id);
        $setStmt->execute();
        $setRes = $setStmt->get_result()->fetch_assoc();
        if ($setRes) {
            $sound_enabled = (bool)$setRes['sound_enabled'];
        }
        $setStmt->close();
    }

    // 5. Calculate Accuracy from scores or progress
    $accuracy = 100;
    $accStmt = $conn->prepare("SELECT AVG(accuracy_percentage) AS avg_acc FROM scores WHERE child_id = ? AND game_id = 3");
    if ($accStmt) {
        $accStmt->bind_param("i", $child_id);
        $accStmt->execute();
        $accRes = $accStmt->get_result()->fetch_assoc();
        if ($accRes && $accRes['avg_acc'] !== null) {
            $accuracy = (int)round($accRes['avg_acc']);
        }
        $accStmt->close();
    }

    echo json_encode([
        'success'          => true,
        'guest'            => false,
        'child_id'         => $child_id,
        'username'         => $username,
        'total_coins'      => $total_coins,
        'completed_count'  => $completed_count,
        'completed_levels' => $completed_levels,
        'word_stars'       => empty($word_stars) ? new stdClass() : $word_stars,
        'sound_enabled'    => $sound_enabled,
        'accuracy'         => $accuracy
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'error'   => $e->getMessage()
    ]);
}
