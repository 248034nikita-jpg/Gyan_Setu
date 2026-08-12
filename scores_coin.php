<?php
// ============================================================================
// COIN VALUES — hardcoded as constants, not stored in the database.
// This is normal and fine: these are GAME DESIGN RULES ("how many coins for
// a correct answer"), not DATA about a specific child. Data about children
// (their coins, their scores) lives in the database. The RULES for how that
// data is calculated can live in code. If you ever want a non-programmer
// (like a teacher/admin) to change these without touching code, THAT's the
// point where you'd move them into a small `game_config` table instead —
// but for now, constants are simpler and totally standard practice.
// ============================================================================
 
define('COINS_PER_CORRECT_TIER1', 1); // Easy
define('COINS_PER_CORRECT_TIER2', 2); // Medium
define('COINS_PER_CORRECT_TIER3', 3); // Hard
define('FIRST_TIME_COMPLETION_BONUS', 5);   // bonus for finishing a round type for the FIRST time ever
define('ACCURACY_BONUS_THRESHOLD', 80);     // % accuracy needed for a bonus
define('ACCURACY_BONUS_COINS', 5);          // bonus coins if accuracy hits the threshold above
define('REPEAT_PLAY_COIN_MULTIPLIER', 0.2); // repeat plays of the same round only earn 20% of normal coins
 
 
// ============================================================================
// 1. SAVE A FINISHED ROUND — this is the ONLY place data gets written for a
//    round. Everything else (daily activity, best streak, progress) is
//    calculated AFTER THE FACT by the 3 views reading this same data.
// ============================================================================
function saveRoundAndAwardCoins(mysqli $conn, int $childId, int $gameId, int $tier, string $topic, string $concept, int $correctCount, int $totalQuestions, int $roundStreak) {
 
    $accuracy = round(($correctCount / $totalQuestions) * 100, 2);
 
    // --- Has this child played this EXACT round (game+tier+topic+concept) before? ---
    $check = $conn->prepare("
        SELECT COUNT(*) AS attempts FROM scores
        WHERE child_id = ? AND game_id = ? AND difficulty_tier_played = ?
          AND topic = ? AND concept = ?
    ");
    $check->bind_param('iiiss', $childId, $gameId, $tier, $topic, $concept);
    $check->execute();
    $isFirstTime = ($check->get_result()->fetch_assoc()['attempts'] == 0);
    $check->close();
 
    // --- Calculate coins for this round ---
    $perCorrect = [1 => COINS_PER_CORRECT_TIER1, 2 => COINS_PER_CORRECT_TIER2, 3 => COINS_PER_CORRECT_TIER3][$tier];
    $coins = $correctCount * $perCorrect;
 
    if ($isFirstTime) {
        $coins += FIRST_TIME_COMPLETION_BONUS;
    } else {
        $coins = (int) round($coins * REPEAT_PLAY_COIN_MULTIPLIER); // heavily reduced on repeats
    }
 
    if ($accuracy >= ACCURACY_BONUS_THRESHOLD) {
        $coins += ACCURACY_BONUS_COINS;
    }
 
    // --- Save the round to `scores` (the single source of truth) ---
    $insert = $conn->prepare("
        INSERT INTO scores (child_id, game_id, difficulty_tier_played, topic, concept, score_value, total_questions, accuracy_percentage, streak_achieved, coins_earned)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");
    $insert->bind_param('iiissiidii', $childId, $gameId, $tier, $topic, $concept, $correctCount, $totalQuestions, $accuracy, $roundStreak, $coins);
    $insert->execute();
    $insert->close();
 
    // --- Add coins to the child's spendable balance ---
    $update = $conn->prepare("UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?");
    $update->bind_param('ii', $coins, $childId);
    $update->execute();
    $update->close();
 
    // --- Now check if any badges were just unlocked ---
    $newBadges = checkAndAwardBadges($conn, $childId, $gameId);
 
    return ['coins_earned' => $coins, 'accuracy' => $accuracy, 'new_badges' => $newBadges];
}
 
 
// ============================================================================
// 2. GENERIC BADGE CHECKER — reads badge_criteria (the RULES) and checks each
//    one against the views (the CALCULATED DATA). Awarding a NEW badge also
//    pays its one-time coin reward. Adding badge #11 later needs NO new code
//    here — just a new row in badge_criteria.
// ============================================================================
function checkAndAwardBadges(mysqli $conn, int $childId, int $gameId): array {
 
    $newlyEarned = [];
 
    // Only check badges this child doesn't already have.
    // Joins to criteria_types to get the readable type_name, since
    // badge_criteria now stores criteria_type_id (a lookup table FK)
    // instead of a plain ENUM string.
    $criteriaQuery = $conn->prepare("
        SELECT bc.*, ct.type_name AS criteria_type
        FROM badge_criteria bc
        JOIN criteria_types ct ON ct.criteria_type_id = bc.criteria_type_id
        WHERE bc.badge_id NOT IN (SELECT badge_id FROM child_badges WHERE child_id = ?)
    ");
    $criteriaQuery->bind_param('i', $childId);
    $criteriaQuery->execute();
    $allCriteria = $criteriaQuery->get_result()->fetch_all(MYSQLI_ASSOC);
    $criteriaQuery->close();
 
    foreach ($allCriteria as $c) {
        $earned = evaluateCriteria($conn, $childId, $c);
        if ($earned) {
            if (awardBadge($conn, $childId, (int) $c['badge_id'])) {
                $newlyEarned[] = (int) $c['badge_id'];
            }
        }
    }
 
    return $newlyEarned;
}
 
function evaluateCriteria(mysqli $conn, int $childId, array $c): bool {
    $type = $c['criteria_type'];
    $threshold = (int) $c['threshold_value'];
    $gameFilter = $c['game_id']; // may be null = any game
 
    switch ($type) {
 
        case 'rounds_completed':
            $sql = "SELECT COALESCE(SUM(attempts),0) AS total FROM view_child_game_progress WHERE child_id = ?";
            $params = [$childId]; $types = 'i';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            if ($c['topic'] !== '')   { $sql .= " AND topic = ?"; $params[] = $c['topic']; $types .= 's'; }
            if ($c['concept'] !== '') { $sql .= " AND concept = ?"; $params[] = $c['concept']; $types .= 's'; }
            if ($c['difficulty_tier'] !== null) { $sql .= " AND difficulty_tier = ?"; $params[] = $c['difficulty_tier']; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $total = $stmt->get_result()->fetch_assoc()['total'];
            $stmt->close();
            return $total >= $threshold;
 
        case 'perfect_score':
            $sql = "SELECT COUNT(*) AS cnt FROM scores WHERE child_id = ? AND score_value >= ?";
            $params = [$childId, $threshold]; $types = 'ii';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $cnt = $stmt->get_result()->fetch_assoc()['cnt'];
            $stmt->close();
            return $cnt > 0;
 
        case 'streak':
            $sql = "SELECT MAX(best_streak) AS best FROM view_child_best_streak WHERE child_id = ?";
            $params = [$childId]; $types = 'i';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $best = $stmt->get_result()->fetch_assoc()['best'] ?? 0;
            $stmt->close();
            return $best >= $threshold;
 
        case 'accuracy_threshold':
            $sql = "SELECT COUNT(*) AS cnt FROM scores WHERE child_id = ? AND accuracy_percentage >= ?";
            $params = [$childId, $threshold]; $types = 'id';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            if ($c['difficulty_tier'] !== null) { $sql .= " AND difficulty_tier_played = ?"; $params[] = $c['difficulty_tier']; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $cnt = $stmt->get_result()->fetch_assoc()['cnt'];
            $stmt->close();
            return $cnt > 0;
 
        case 'topic_all_tiers':
            $sql = "SELECT COUNT(DISTINCT difficulty_tier) AS tiers FROM view_child_game_progress
                    WHERE child_id = ? AND game_id = ? AND topic = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('iis', $childId, $gameFilter, $c['topic']);
            $stmt->execute();
            $tiers = $stmt->get_result()->fetch_assoc()['tiers'];
            $stmt->close();
            return $tiers >= $threshold;
 
        case 'game_all_rounds':
            $sql = "SELECT COUNT(*) AS combos FROM view_child_game_progress
                    WHERE child_id = ? AND game_id = ?";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('ii', $childId, $gameFilter);
            $stmt->execute();
            $combos = $stmt->get_result()->fetch_assoc()['combos'];
            $stmt->close();
            return $combos >= $threshold;
 
        case 'daily_streak':
            $sql = "SELECT COUNT(DISTINCT activity_date) AS days FROM view_child_daily_activity
                    WHERE child_id = ? AND activity_date >= CURDATE() - INTERVAL ? DAY";
            $interval = $threshold - 1;
            $stmt = $conn->prepare($sql);
            $stmt->bind_param('ii', $childId, $interval);
            $stmt->execute();
            $days = $stmt->get_result()->fetch_assoc()['days'];
            $stmt->close();
            return $days >= $threshold;
 
        default:
            return false;
    }
}
 
 
// ============================================================================
// 3. AWARD ONE BADGE — relies on child_badges' UNIQUE KEY to prevent
//    double-awarding; pays the one-time coin reward only on success.
// ============================================================================
function awardBadge(mysqli $conn, int $childId, int $badgeId): bool {
    $insert = $conn->prepare("INSERT INTO child_badges (child_id, badge_id) VALUES (?, ?)");
    $insert->bind_param('ii', $childId, $badgeId);
    $success = $insert->execute();
    $insert->close();
 
    if (!$success) {
        return false; // already owned (duplicate key), or some other error — either way, no coins
    }
 
    $reward = $conn->prepare("SELECT coins_reward FROM badges WHERE badge_id = ?");
    $reward->bind_param('i', $badgeId);
    $reward->execute();
    $coinsReward = (int) $reward->get_result()->fetch_assoc()['coins_reward'];
    $reward->close();
 
    $update = $conn->prepare("UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?");
    $update->bind_param('ii', $coinsReward, $childId);
    $update->execute();
    $update->close();
 
    return true;
}
 