<?php
/**
 * check_intro.php
 * Checks whether a child has already seen the intro video for a given game.
 *
 * GET/POST params:
 *   child_id, game_id
 */
header('Content-Type: application/json');

$root   = dirname(__DIR__); // → <root>/wack-a-mole
$root   = dirname($root);   // → <root>  (project root, e.g. Gyan_Setu)
$dbPath = $root . '/database/includes/db_connect.php';

if (!file_exists($dbPath)) {
    echo json_encode(['error' => 'Backend files not found']);
    exit;
}

include $dbPath;

$childId = intval($_REQUEST['child_id'] ?? 0);
$gameId  = intval($_REQUEST['game_id']  ?? 1);
$seen    = false;

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

    $stmt = $conn->prepare("SELECT 1 FROM child_game_intro WHERE child_id = ? AND game_id = ?");
    if ($stmt) {
        $stmt->bind_param('ii', $childId, $gameId);
        $stmt->execute();
        $res = $stmt->get_result();
        if ($res && $res->num_rows > 0) {
            $seen = true;
        }
        $stmt->close();
    }
}

echo json_encode(['seen' => $seen]);
?>
