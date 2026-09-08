<?php
/**
 * mark_intro_seen.php
 * Records that a child has seen/skipped the game introductory storyline video.
 *
 * POST params:
 *   child_id, game_id
 */
header('Content-Type: application/json');

$root = realpath(__DIR__ . '/../../');
$dbPath = $root . '/database/includes/db_connect.php';

if (!file_exists($dbPath)) {
    echo json_encode(['error' => 'Backend files not found', 'dbPath' => $dbPath]);
    exit;
}

include $dbPath;

$childId = intval($_POST['child_id'] ?? 0);
$gameId  = intval($_POST['game_id']  ?? 1);

if ($childId > 0 && $gameId > 0) {
    // Ensure table exists
    $conn->query("
        CREATE TABLE IF NOT EXISTS `child_game_intro` (
          `child_id` INT(11) NOT NULL,
          `game_id` INT(11) NOT NULL,
          `seen_at` DATETIME DEFAULT CURRENT_TIMESTAMP(),
          PRIMARY KEY (`child_id`, `game_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ");

    $stmt = $conn->prepare("
        INSERT INTO child_game_intro (child_id, game_id, seen_at)
        VALUES (?, ?, NOW())
        ON DUPLICATE KEY UPDATE seen_at = NOW()
    ");
    if ($stmt) {
        $stmt->bind_param('ii', $childId, $gameId);
        $stmt->execute();
        $stmt->close();
    }
}

echo json_encode(['success' => true]);
?>
