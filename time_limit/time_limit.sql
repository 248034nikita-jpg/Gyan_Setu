-- Table structure for Safe Screentime Mode
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
