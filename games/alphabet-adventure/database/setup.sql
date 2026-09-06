-- =====================================================
-- 🐾 ALPHABET ADVENTURE DATABASE SETUP
-- Target Age: 4-6
-- Database: gyan_setu
-- =====================================================

-- 1. Extend game_type enum in games table to include 'spelling_adventure' if not present
ALTER TABLE `games` MODIFY `game_type` ENUM(
  'hangman',
  'whack_a_mole',
  'capybara_quiz',
  'science_nature',
  'drag_drop_shapes',
  'spelling_adventure'
) NOT NULL;

-- 2. Register Alphabet Adventure in games table
INSERT INTO `games` (`game_id`, `title`, `slug`, `game_type`, `description`, `min_age`, `max_age`, `is_active`)
VALUES (
  3,
  'Alphabet Adventure',
  'alphabet-adventure',
  'spelling_adventure',
  'Learn, Play & Spell! Journey through A-Z with 390 fun words for ages 4-6.',
  4,
  6,
  1
)
ON DUPLICATE KEY UPDATE 
  `title` = VALUES(`title`),
  `slug` = VALUES(`slug`),
  `game_type` = VALUES(`game_type`),
  `description` = VALUES(`description`),
  `min_age` = VALUES(`min_age`),
  `max_age` = VALUES(`max_age`),
  `is_active` = VALUES(`is_active`);

-- 3. Create table for word/stage progress
CREATE TABLE IF NOT EXISTS `alphabet_adventure_progress` (
  `progress_id` INT(11) NOT NULL AUTO_INCREMENT,
  `child_id` INT(11) NOT NULL,
  `level_letter` VARCHAR(2) NOT NULL,
  `word_index` INT(11) NOT NULL,
  `word` VARCHAR(50) NOT NULL,
  `stars` INT(11) NOT NULL DEFAULT 3,
  `mistakes` INT(11) NOT NULL DEFAULT 0,
  `completed` TINYINT(1) NOT NULL DEFAULT 1,
  `completed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`progress_id`),
  UNIQUE KEY `unique_child_word` (`child_id`, `level_letter`, `word_index`),
  INDEX `idx_child_id` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. Create table for level (A-Z) completion
CREATE TABLE IF NOT EXISTS `alphabet_adventure_levels` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `child_id` INT(11) NOT NULL,
  `level_index` INT(11) NOT NULL,
  `level_letter` VARCHAR(2) NOT NULL,
  `is_completed` TINYINT(1) NOT NULL DEFAULT 1,
  `bonus_coins_awarded` INT(11) NOT NULL DEFAULT 50,
  `completed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_child_level` (`child_id`, `level_index`),
  INDEX `idx_child_id` (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 5. Create table for child game settings (sound, last level, etc.)
CREATE TABLE IF NOT EXISTS `alphabet_adventure_settings` (
  `child_id` INT(11) NOT NULL,
  `sound_enabled` TINYINT(1) NOT NULL DEFAULT 1,
  `last_played_level` INT(11) NOT NULL DEFAULT 0,
  `last_played_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`child_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
