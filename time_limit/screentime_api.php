<?php
session_start();
header('Content-Type: application/json');

$root = realpath(__DIR__ . '/../');
$dbPath = $root . '/database/includes/db_connect.php';

if (!file_exists($dbPath)) {
    echo json_encode(['success' => false, 'error' => 'Database connection file not found']);
    exit();
}

require_once $dbPath;

// Auto-create time_limit table if not existing
$conn->query("
    CREATE TABLE IF NOT EXISTS `time_limit` (
      `limit_id` INT(11) NOT NULL AUTO_INCREMENT,
      `child_id` INT(11) NOT NULL,
      `daily_limit_minutes` INT(11) NOT NULL DEFAULT 0,
      `used_seconds` INT(11) NOT NULL DEFAULT 0,
      `last_reset_date` DATE NOT NULL,
      `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (`limit_id`),
      UNIQUE KEY `unique_child_screentime` (`child_id`),
      CONSTRAINT `fk_time_limit_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
");

$action = $_REQUEST['action'] ?? 'get_status';
$today = date('Y-m-d');

// Helper to resolve active child ID from request or session
function resolve_child_id($conn) {
    if (isset($_REQUEST['child_id']) && (int)$_REQUEST['child_id'] > 0) {
        return (int)$_REQUEST['child_id'];
    }
    if (isset($_SESSION['role'])) {
        if ($_SESSION['role'] === 'child') {
            return (int)$_SESSION['user_id'];
        }
        if ($_SESSION['role'] === 'parent') {
            $parent_id = (int)$_SESSION['user_id'];
            $stmt = $conn->prepare("SELECT child_id FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
            if ($stmt) {
                $stmt->bind_param("i", $parent_id);
                $stmt->execute();
                $r = $stmt->get_result()->fetch_assoc();
                $stmt->close();
                if ($r) return (int)$r['child_id'];
            }
        }
    }
    return 0;
}

// Helper to get or create screentime record for a child
function get_child_screentime($conn, $child_id, $today) {
    $stmt = $conn->prepare("SELECT limit_id, daily_limit_minutes, used_seconds, last_reset_date FROM time_limit WHERE child_id = ?");
    $stmt->bind_param("i", $child_id);
    $stmt->execute();
    $row = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$row) {
        $default_limit = 0; // Default: Unlimited Mode (no restriction)
        $default_used = 0;
        $stmt = $conn->prepare("INSERT INTO time_limit (child_id, daily_limit_minutes, used_seconds, last_reset_date) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("iiis", $child_id, $default_limit, $default_used, $today);
        $stmt->execute();
        $stmt->close();

        return [
            'child_id' => $child_id,
            'daily_limit_minutes' => $default_limit,
            'used_seconds' => $default_used,
            'last_reset_date' => $today
        ];
    }

    // Check if reset is needed for a new day
    if ($row['last_reset_date'] < $today) {
        $stmt = $conn->prepare("UPDATE time_limit SET used_seconds = 0, last_reset_date = ? WHERE child_id = ?");
        $stmt->bind_param("si", $today, $child_id);
        $stmt->execute();
        $stmt->close();

        $row['used_seconds'] = 0;
        $row['last_reset_date'] = $today;
    }

    return $row;
}

if ($action === 'get_status') {
    $child_id = resolve_child_id($conn);
    if ($child_id <= 0) {
        echo json_encode([
            'success' => true,
            'is_child' => false,
            'active' => false,
            'role' => $_SESSION['role'] ?? 'guest',
            'message' => 'No child profile found'
        ]);
        exit();
    }

    $data = get_child_screentime($conn, $child_id, $today);

    $limit_minutes = (int)$data['daily_limit_minutes'];
    $used_seconds  = (int)$data['used_seconds'];
    $unlimited     = ($limit_minutes === 0);

    $remaining_seconds = $unlimited ? null : max(0, ($limit_minutes * 60) - $used_seconds);

    echo json_encode([
        'success'           => true,
        'is_child'          => true,
        'active'            => true,
        'child_id'          => $child_id,
        'daily_limit_minutes' => $limit_minutes,
        'used_seconds'      => $used_seconds,
        'remaining_seconds' => $remaining_seconds,
        'unlimited'         => $unlimited,
        'is_expired'        => (!$unlimited && $remaining_seconds <= 0)
    ]);
    exit();
}

if ($action === 'tick') {
    $child_id = resolve_child_id($conn);
    if ($child_id <= 0) {
        echo json_encode(['success' => false, 'error' => 'No active child profile found']);
        exit();
    }

    $elapsed = isset($_POST['elapsed']) ? (int)$_POST['elapsed'] : 10;
    $elapsed = max(1, min(60, $elapsed)); // sanitize

    $data = get_child_screentime($conn, $child_id, $today);
    $limit_minutes = (int)$data['daily_limit_minutes'];
    $used_seconds  = (int)$data['used_seconds'];
    $unlimited     = ($limit_minutes === 0);

    if (!$unlimited) {
        $max_seconds = $limit_minutes * 60;
        $new_used = min($max_seconds, $used_seconds + $elapsed);

        $stmt = $conn->prepare("UPDATE time_limit SET used_seconds = ? WHERE child_id = ?");
        $stmt->bind_param("ii", $new_used, $child_id);
        $stmt->execute();
        $stmt->close();

        $used_seconds = $new_used;
    }

    $remaining_seconds = $unlimited ? null : max(0, ($limit_minutes * 60) - $used_seconds);

    echo json_encode([
        'success'           => true,
        'daily_limit_minutes' => $limit_minutes,
        'used_seconds'      => $used_seconds,
        'remaining_seconds' => $remaining_seconds,
        'unlimited'         => $unlimited,
        'is_expired'        => (!$unlimited && $remaining_seconds <= 0)
    ]);
    exit();
}

if ($action === 'set_limit') {
    if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
        echo json_encode(['success' => false, 'error' => 'Parent authorization required']);
        exit();
    }

    $parent_id = (int)$_SESSION['user_id'];
    $limit_minutes = isset($_REQUEST['limit_minutes']) ? (int)$_REQUEST['limit_minutes'] : 0;
    $limit_minutes = max(0, min(1440, $limit_minutes)); // sanitize between 0 and 1440 mins

    // Allow parent session OR direct child_id param (for quick testing via URL)
    $isParent = isset($_SESSION['role']) && $_SESSION['role'] === 'parent';
    $directChildId = isset($_REQUEST['child_id']) ? (int)$_REQUEST['child_id'] : 0;

    if (!$isParent && $directChildId <= 0) {
        echo json_encode(['success' => false, 'error' => 'Parent authorization or child_id required']);
        exit();
    }

    // Build child list: parent session → all their children; direct child_id → just that one
    $children = [];
    if ($isParent) {
        $parent_id = (int)$_SESSION['user_id'];
        $stmt = $conn->prepare("SELECT child_id FROM children WHERE parent_id = ?");
        $stmt->bind_param("i", $parent_id);
        $stmt->execute();
        $res = $stmt->get_result();
        while ($r = $res->fetch_assoc()) {
            $children[] = (int)$r['child_id'];
        }
        $stmt->close();
    } else {
        $children = [$directChildId];
    }

    if (empty($children)) {
        echo json_encode(['success' => false, 'error' => 'No children accounts found']);
        exit();
    }

    foreach ($children as $cid) {
        // Upsert: update limit AND reset used_seconds so new limit starts fresh
        $stmt = $conn->prepare("
            INSERT INTO time_limit (child_id, daily_limit_minutes, used_seconds, last_reset_date) 
            VALUES (?, ?, 0, ?)
            ON DUPLICATE KEY UPDATE 
                daily_limit_minutes = VALUES(daily_limit_minutes),
                used_seconds = 0,
                last_reset_date = VALUES(last_reset_date)
        ");
        $stmt->bind_param("iis", $cid, $limit_minutes, $today);
        $stmt->execute();
        $stmt->close();
    }

    echo json_encode([
        'success' => true,
        'limit_minutes' => $limit_minutes,
        'message' => 'Safe Screentime Mode limit updated successfully!'
    ]);
    exit();
}

if ($action === 'get_parent_limit') {
    if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
        echo json_encode(['success' => false, 'error' => 'Parent authorization required']);
        exit();
    }

    $parent_id = (int)$_SESSION['user_id'];
    $stmt = $conn->prepare("
        SELECT tl.daily_limit_minutes 
        FROM children c 
        JOIN time_limit tl ON c.child_id = tl.child_id 
        WHERE c.parent_id = ? 
        ORDER BY c.created_at ASC LIMIT 1
    ");
    $stmt->bind_param("i", $parent_id);
    $stmt->execute();
    $res = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    $limit = $res ? (int)$res['daily_limit_minutes'] : 0;

    echo json_encode([
        'success' => true,
        'limit_minutes' => $limit
    ]);
    exit();
}

echo json_encode(['success' => false, 'error' => 'Invalid action']);
?>
