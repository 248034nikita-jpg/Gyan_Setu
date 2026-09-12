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

    $accuracy = $totalQuestions > 0 ? round(($correctCount / $totalQuestions) * 100, 2) : 0;

    // --- Ensure scores table exists ---
    $conn->query("
        CREATE TABLE IF NOT EXISTS `scores` (
          `score_id` int(11) NOT NULL AUTO_INCREMENT,
          `child_id` int(11) NOT NULL,
          `game_id` int(11) DEFAULT NULL,
          `topic` varchar(20) NOT NULL,
          `concept` varchar(50) NOT NULL,
          `difficulty_tier_played` int(11) NOT NULL DEFAULT 1,
          `score_value` int(11) NOT NULL DEFAULT 0,
          `accuracy_percentage` decimal(5,2) DEFAULT NULL,
          `streak_achieved` int(11) DEFAULT 0,
          `coins_earned` int(11) NOT NULL DEFAULT 0,
          `date_played` timestamp NOT NULL DEFAULT current_timestamp(),
          PRIMARY KEY (`score_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ");

    // --- Has this child played this EXACT round (game+tier+topic+concept) before? ---
    $isFirstTime = true;
    $check = $conn->prepare("
        SELECT COUNT(*) AS attempts FROM scores
        WHERE child_id = ? AND game_id = ? AND difficulty_tier_played = ?
          AND topic = ? AND concept = ?
    ");
    if ($check) {
        $check->bind_param('iiiss', $childId, $gameId, $tier, $topic, $concept);
        $check->execute();
        $res = $check->get_result();
        if ($res && ($row = $res->fetch_assoc())) {
            $isFirstTime = ($row['attempts'] == 0);
        }
        $check->close();
    }

    // --- Calculate coins for this round ---
    $perCorrect = [1 => COINS_PER_CORRECT_TIER1, 2 => COINS_PER_CORRECT_TIER2, 3 => COINS_PER_CORRECT_TIER3][$tier] ?? 1;
    $coins = $correctCount * $perCorrect;

    if ($isFirstTime) {
        $coins += FIRST_TIME_COMPLETION_BONUS;
    } else {
        $coins = (int) round($coins * REPEAT_PLAY_COIN_MULTIPLIER); // heavily reduced on repeats
    }

    if ($accuracy >= ACCURACY_BONUS_THRESHOLD) {
        $coins += ACCURACY_BONUS_COINS;
    }

    // Ensure at least base coins awarded if correctCount > 0
    if ($coins <= 0 && $correctCount > 0) {
        $coins = $correctCount * $perCorrect;
    }

    // --- Save the round to `scores` (the single source of truth) ---
    $insert = $conn->prepare("
        INSERT INTO scores (child_id, game_id, difficulty_tier_played, topic, concept, score_value, accuracy_percentage, streak_achieved, coins_earned)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ");
    if ($insert) {
        $insert->bind_param('iiissidii', $childId, $gameId, $tier, $topic, $concept, $correctCount, $accuracy, $roundStreak, $coins);
        $insert->execute();
        $insert->close();
    }

    // --- Add coins to the child's spendable balance (GUARANTEED UPDATE) ---
    $update = $conn->prepare("UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?");
    if ($update) {
        $update->bind_param('ii', $coins, $childId);
        $update->execute();
        $update->close();
    }

    // --- Now check if any badges were just unlocked (safe try-catch) ---
    $newBadges = [];
    try {
        $newBadges = checkAndAwardBadges($conn, $childId, $gameId);
    } catch (Throwable $e) {
        $newBadges = [];
    }

    return ['coins_earned' => $coins, 'accuracy' => $accuracy, 'new_badges' => $newBadges];
}


// ============================================================================
// 2. GENERIC BADGE CHECKER — reads badge_criteria (the RULES) and checks each
//    one against scores. Awarding a NEW badge also pays its one-time coin reward.
// ============================================================================
function checkAndAwardBadges(mysqli $conn, int $childId, int $gameId): array {

    $newlyEarned = [];

    // Ensure criteria_types table exists and is populated
    $conn->query("
        CREATE TABLE IF NOT EXISTS `criteria_types` (
          `criteria_type_id` int(11) NOT NULL,
          `type_name` varchar(50) NOT NULL,
          `description` varchar(255) DEFAULT NULL,
          PRIMARY KEY (`criteria_type_id`),
          UNIQUE KEY `type_name` (`type_name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ");
    $conn->query("
        INSERT IGNORE INTO `criteria_types` (`criteria_type_id`, `type_name`, `description`) VALUES
        (1, 'rounds_completed', 'Total attempts across matching rounds meets threshold_value'),
        (2, 'perfect_score', 'A single round scored at or above threshold_value'),
        (3, 'streak', 'Best-ever correct-answer streak meets threshold_value'),
        (4, 'accuracy_threshold', 'A single round\'s accuracy meets threshold_value (%)'),
        (5, 'topic_all_tiers', 'All difficulty tiers within a topic have been attempted'),
        (6, 'game_all_rounds', 'All round-types within a game have been attempted'),
        (7, 'daily_streak', 'Played on threshold_value consecutive days'),
        (8, 'oranges_collected', 'Total oranges collected across all levels meets threshold_value'),
        (9, 'total_coins', 'Total coins balance meets threshold_value');
    ");

    // Ensure child_badges table exists
    $conn->query("
        CREATE TABLE IF NOT EXISTS `child_badges` (
          `child_id` INT NOT NULL,
          `badge_id` INT NOT NULL,
          `awarded_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
          PRIMARY KEY (`child_id`, `badge_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ");

    // Auto-fix threshold for Perfect Score badge if set to 20 in DB
    $conn->query("UPDATE badge_criteria SET threshold_value = 10 WHERE badge_id = 7 AND threshold_value = 20");

    $typeMap = [
        1 => 'rounds_completed',
        2 => 'perfect_score',
        3 => 'streak',
        4 => 'accuracy_threshold',
        5 => 'topic_all_tiers',
        6 => 'game_all_rounds',
        7 => 'daily_streak',
        8 => 'oranges_collected',
        9 => 'total_coins'
    ];

    $criteriaQuery = $conn->prepare("
        SELECT * FROM badge_criteria
        WHERE (game_id = ? OR game_id IS NULL)
          AND badge_id NOT IN (SELECT badge_id FROM child_badges WHERE child_id = ?)
    ");
    if (!$criteriaQuery) {
        return $newlyEarned;
    }
    $criteriaQuery->bind_param('ii', $gameId, $childId);
    $criteriaQuery->execute();
    $res = $criteriaQuery->get_result();
    $allCriteria = $res ? $res->fetch_all(MYSQLI_ASSOC) : [];
    $criteriaQuery->close();

    foreach ($allCriteria as $c) {
        $c['criteria_type'] = $typeMap[(int)($c['criteria_type_id'] ?? 0)] ?? '';
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
            $sql = "SELECT COUNT(*) AS total FROM scores WHERE child_id = ?";
            $params = [$childId]; $types = 'i';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            if ($c['topic'] !== '')   { $sql .= " AND topic = ?"; $params[] = $c['topic']; $types .= 's'; }
            if ($c['concept'] !== '') { $sql .= " AND concept = ?"; $params[] = $c['concept']; $types .= 's'; }
            if ($c['difficulty_tier'] !== null) { $sql .= " AND difficulty_tier_played = ?"; $params[] = $c['difficulty_tier']; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $res = $stmt->get_result();
            $total = (int)($res ? ($res->fetch_assoc()['total'] ?? 0) : 0);
            $stmt->close();
            return $total >= $threshold;

        case 'perfect_score':
            // Single round with 10 out of 10 or 100% accuracy
            $sql = "SELECT COUNT(*) AS cnt FROM scores WHERE child_id = ? AND (score_value >= 10 OR accuracy_percentage >= 100.0)";
            $params = [$childId]; $types = 'i';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $res = $stmt->get_result();
            $cnt = (int)($res ? ($res->fetch_assoc()['cnt'] ?? 0) : 0);
            $stmt->close();
            return $cnt > 0;

        case 'streak':
            // Best streak meets threshold (e.g. 5 in a row for Sharp Shooter)
            $sql = "SELECT COUNT(*) AS cnt FROM scores WHERE child_id = ? AND streak_achieved >= ?";
            $params = [$childId, $threshold]; $types = 'ii';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $res = $stmt->get_result();
            $cnt = (int)($res ? ($res->fetch_assoc()['cnt'] ?? 0) : 0);
            $stmt->close();
            return $cnt > 0;

        case 'accuracy_threshold':
            $sql = "SELECT COUNT(*) AS cnt FROM scores WHERE child_id = ? AND accuracy_percentage >= ?";
            $params = [$childId, $threshold]; $types = 'id';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            if ($c['difficulty_tier'] !== null) { $sql .= " AND difficulty_tier_played = ?"; $params[] = $c['difficulty_tier']; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $res = $stmt->get_result();
            $cnt = (int)($res ? ($res->fetch_assoc()['cnt'] ?? 0) : 0);
            $stmt->close();
            return $cnt > 0;

        case 'topic_all_tiers':
            $sql = "SELECT COUNT(DISTINCT difficulty_tier_played) AS tiers FROM scores
                    WHERE child_id = ? AND topic = ?";
            $params = [$childId, $c['topic']]; $types = 'is';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $res = $stmt->get_result();
            $tiers = (int)($res ? ($res->fetch_assoc()['tiers'] ?? 0) : 0);
            $stmt->close();
            return $tiers >= $threshold;

        case 'game_all_rounds':
            $sql = "SELECT COUNT(DISTINCT CONCAT(topic, ':', concept, ':', difficulty_tier_played)) AS combos FROM scores
                    WHERE child_id = ?";
            $params = [$childId]; $types = 'i';
            if ($gameFilter !== null) { $sql .= " AND game_id = ?"; $params[] = $gameFilter; $types .= 'i'; }
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param($types, ...$params);
            $stmt->execute();
            $res = $stmt->get_result();
            $combos = (int)($res ? ($res->fetch_assoc()['combos'] ?? 0) : 0);
            $stmt->close();
            return $combos >= $threshold;

        case 'daily_streak':
            $sql = "SELECT COUNT(DISTINCT DATE(date_played)) AS days FROM scores
                    WHERE child_id = ? AND date_played >= CURDATE() - INTERVAL ? DAY";
            $interval = max(0, $threshold - 1);
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param('ii', $childId, $interval);
            $stmt->execute();
            $res = $stmt->get_result();
            $days = (int)($res ? ($res->fetch_assoc()['days'] ?? 0) : 0);
            $stmt->close();
            return $days >= $threshold;

        case 'oranges_collected':
            $tableCheck = $conn->query("SHOW TABLES LIKE 'capybara_level_scores'");
            if (!$tableCheck || $tableCheck->num_rows === 0) return false;
            $sql = "SELECT COALESCE(SUM(oranges_collected),0) AS total FROM capybara_level_scores WHERE child_id = ?";
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param('i', $childId);
            $stmt->execute();
            $res = $stmt->get_result();
            $total = (int)($res ? ($res->fetch_assoc()['total'] ?? 0) : 0);
            $stmt->close();
            return $total >= $threshold;

        case 'total_coins':
            $sql = "SELECT total_coins FROM children WHERE child_id = ?";
            $stmt = $conn->prepare($sql);
            if (!$stmt) return false;
            $stmt->bind_param('i', $childId);
            $stmt->execute();
            $res = $stmt->get_result();
            $coins = (int)($res ? ($res->fetch_assoc()['total_coins'] ?? 0) : 0);
            $stmt->close();
            return $coins >= $threshold;

        default:
            return false;
    }
}


// ============================================================================
// 3. AWARD ONE BADGE — relies on child_badges' UNIQUE KEY to prevent
//    double-awarding; pays the one-time coin reward only on success.
// ============================================================================
function awardBadge(mysqli $conn, int $childId, int $badgeId): bool {
    // Ensure table exists
    $conn->query("
        CREATE TABLE IF NOT EXISTS `child_badges` (
          `child_id` INT NOT NULL,
          `badge_id` INT NOT NULL,
          `awarded_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
          PRIMARY KEY (`child_id`, `badge_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ");

    $insert = $conn->prepare("INSERT INTO child_badges (child_id, badge_id) VALUES (?, ?)");
    if (!$insert) return false;
    $insert->bind_param('ii', $childId, $badgeId);
    $success = @$insert->execute();
    $insert->close();

    if (!$success) {
        return false; // already owned (duplicate key), or some other error — either way, no coins
    }

    $reward = $conn->prepare("SELECT coins_reward FROM badges WHERE badge_id = ?");
    if ($reward) {
        $reward->bind_param('i', $badgeId);
        $reward->execute();
        $res = $reward->get_result();
        $coinsReward = (int) ($res ? ($res->fetch_assoc()['coins_reward'] ?? 0) : 0);
        $reward->close();

        if ($coinsReward > 0) {
            $update = $conn->prepare("UPDATE children SET total_coins = total_coins + ? WHERE child_id = ?");
            if ($update) {
                $update->bind_param('ii', $coinsReward, $childId);
                $update->execute();
                $update->close();
            }
        }
    }

    return true;
}
 