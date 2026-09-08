-- Table structure for table `child_game_intro`
-- Tracks whether a child has watched/completed the introductory storyline video for a game

CREATE TABLE IF NOT EXISTS `child_game_intro` (
  `child_id` INT(11) NOT NULL,
  `game_id` INT(11) NOT NULL,
  `seen_at` DATETIME DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`child_id`, `game_id`),
  CONSTRAINT `fk_child_game_intro_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;