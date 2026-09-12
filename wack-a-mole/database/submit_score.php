<?php
/**
 * submit_score.php
 * Receives the game result from the Phaser Whack-a-Mole game,
 * saves score/coins via scores_coin.php, and returns JSON with results.
 *
 * POST params:
 *   child_id, game_id, tier, topic, concept, correct_count, total_questions, streak
 */

// ── Output buffer: catch any stray PHP warnings/notices so JSON stays clean ──
ob_start();
error_reporting(0);
ini_set('display_errors', '0');

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json');

// ── Resolve project-root paths ────────────────────────────────────────────
// This file: <root>/wack-a-mole/database/submit_score.php
$root   = dirname(dirname(__DIR__));
$dbPath = $root . '/database/includes/db_connect.php';
$scPath = $root . '/scores_coin.php';

if (file_exists($dbPath)) {
    @include_once $dbPath;
}
if (file_exists($scPath)) {
    @include_once $scPath;
}

// ── Helper: always emit clean JSON ────────────────────────────────────────
function sendJson(array $payload): void {
    ob_clean();
    echo json_encode($payload);
    exit;
}

// ── Collect POST inputs ────────────────────────────────────────────────────
$childId      = intval($_POST['child_id']        ?? 0);
$gameId       = intval($_POST['game_id']         ?? 1);
$tier         = intval($_POST['tier']            ?? 1);
$topic        = trim($_POST['topic']             ?? 'grammar');
$concept      = trim($_POST['concept']           ?? '');
$correctCount = intval($_POST['correct_count']   ?? 0);
$totalQs      = intval($_POST['total_questions'] ?? 10);
$streak       = intval($_POST['streak']          ?? 0);

if ($totalQs <= 0) {
    $totalQs = 10;
}

// ── Fallback: Resolve child_id if not posted or 0 ─────────────────────────
if ($childId <= 0) {
    if (isset($_SESSION['role'], $_SESSION['user_id'])) {
        if ($_SESSION['role'] === 'child') {
            $childId = (int) $_SESSION['user_id'];
        } elseif ($_SESSION['role'] === 'parent' && isset($conn) && $conn && !$conn->connect_errno) {
            $parentId = (int) $_SESSION['user_id'];
            $pStmt = $conn->prepare("SELECT child_id FROM children WHERE parent_id = ? ORDER BY created_at ASC LIMIT 1");
            if ($pStmt) {
                $pStmt->bind_param("i", $parentId);
                $pStmt->execute();
                $pRes = $pStmt->get_result();
                if ($pRes && ($pRow = $pRes->fetch_assoc())) {
                    $childId = (int) $pRow['child_id'];
                }
                $pStmt->close();
            }
        }
    }
}

if ($childId <= 0 && isset($_SESSION['child_id']) && (int)$_SESSION['child_id'] > 0) {
    $childId = (int)$_SESSION['child_id'];
}

// If still 0, check if there's any child in the database
if ($childId <= 0 && isset($conn) && $conn && !$conn->connect_errno) {
    $cQuery = $conn->query("SELECT child_id FROM children ORDER BY created_at ASC LIMIT 1");
    if ($cQuery && ($cRow = $cQuery->fetch_assoc())) {
        $childId = (int)$cRow['child_id'];
    }
}

// Calculate base coins according to game rules
$perCorrect = [1 => 1, 2 => 2, 3 => 3][$tier] ?? 1;
$calculatedCoins = $correctCount * $perCorrect;
$accuracy = $totalQs > 0 ? round(($correctCount / $totalQs) * 100, 1) : 0;
if ($accuracy >= 80) {
    $calculatedCoins += 5; // accuracy bonus
}

// ── If childId cannot be found and DB is completely offline ───────────────
if ($childId <= 0 || !isset($conn) || !($conn instanceof mysqli) || $conn->connect_errno) {
    sendJson([
        'coins_earned'    => $calculatedCoins,
        'accuracy'        => $accuracy,
        'new_badges'      => [],
        'correct_count'   => $correctCount,
        'total_questions' => $totalQs,
        'guest'           => true
    ]);
}

// ── Save round via scores_coin.php or direct database update ──────────────
$coinsEarned = $calculatedCoins;
$newBadges = [];

if (function_exists('saveRoundAndAwardCoins')) {
    try {
        $saveResult = saveRoundAndAwardCoins(
            $conn, $childId, $gameId, $tier, $topic, $concept,
            $correctCount, $totalQs, $streak
        );
        $coinsEarned = (int)($saveResult['coins_earned'] ?? $calculatedCoins);
        $accuracy    = $saveResult['accuracy'] ?? $accuracy;
        $newBadges   = $saveResult['new_badges'] ?? [];
    } catch (Throwable $e) {
        // Direct guaranteed fallback update to children table
        $updateStmt = $conn->prepare("UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?");
        if ($updateStmt) {
            $updateStmt->bind_param("ii", $calculatedCoins, $childId);
            $updateStmt->execute();
            $updateStmt->close();
        }
    }
} else {
    // Direct guaranteed update to children table
    $updateStmt = $conn->prepare("UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?");
    if ($updateStmt) {
        $updateStmt->bind_param("ii", $calculatedCoins, $childId);
        $updateStmt->execute();
        $updateStmt->close();
    }
}

// ── Fetch presentation details for newly earned badges ────────────────────
$badgeDetails = [];
if (!empty($newBadges)) {
    try {
        $ids = implode(',', array_map('intval', $newBadges));
        $bRes = $conn->query("SELECT title, icon_url, coins_reward FROM badges WHERE badge_id IN ($ids)");
        if ($bRes) {
            while ($b = $bRes->fetch_assoc()) {
                $badgeDetails[] = $b;
            }
        }
    } catch (Throwable $e) {
        // non-critical
    }
}

sendJson([
    'coins_earned'    => $coinsEarned,
    'accuracy'        => $accuracy,
    'new_badges'      => $badgeDetails,
    'correct_count'   => $correctCount,
    'total_questions' => $totalQs,
    'child_id'        => $childId,
    'success'         => true
]);
?>
