-- Admin Setup and Questions Table Enhancements for Gyan Setu

USE gyan_setu;

-- 1. Create Admin Table
CREATE TABLE IF NOT EXISTS `admin` (
  `admin_id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(255) UNIQUE NOT NULL,
  `email` VARCHAR(255) UNIQUE NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default Admin account (Username: admin, Password: adminpassword)
-- Hash generated using BCRYPT for security
INSERT INTO `admin` (`admin_id`, `username`, `email`, `password`) 
VALUES (1, 'admin', 'admin@gmail.com', '$2y$10$QX45fyhO7qRk/Nqrc4qyiuNc2ZWT9MdD5BFZD/aCX3LBvvdw57sv6') 
ON DUPLICATE KEY UPDATE `password`='$2y$10$QX45fyhO7qRk/Nqrc4qyiuNc2ZWT9MdD5BFZD/aCX3LBvvdw57sv6';

--INSERT INTO `admin` (`admin_id`, `admin_name`, `admin_email`, `admin_pass`) VALUES (NULL, 'admin', 'admin@gmail.com', 'admin');

-- 2. Ensure Quizzes Table Exists
CREATE TABLE IF NOT EXISTS `quizzes` (
  `quiz_id` INT AUTO_INCREMENT PRIMARY KEY,
  `lesson_id` INT NULL,
  `title` VARCHAR(150) NOT NULL,
  `passing_score` INT DEFAULT 70
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default general quiz if missing
INSERT INTO `quizzes` (`quiz_id`, `title`) VALUES (1, 'General Challenge Quiz') ON DUPLICATE KEY UPDATE `title`=`title`;

-- 3. Update Questions Table Structure to support rich question features
CREATE TABLE IF NOT EXISTS `questions` (
  `question_id` INT AUTO_INCREMENT PRIMARY KEY,
  `quiz_id` INT NOT NULL DEFAULT 1,
  `subject` VARCHAR(50) NOT NULL DEFAULT 'MATHS',
  `category` VARCHAR(100) NOT NULL DEFAULT 'General',
  `question_text` TEXT NOT NULL,
  `question_type` ENUM('multiple_choice', 'true_false', 'puzzle', 'typing') DEFAULT 'multiple_choice',
  `correct_answer_text` TEXT DEFAULT NULL,
  `difficulty` ENUM('Easy', 'Medium', 'Hard') DEFAULT 'Easy',
  `coins_reward` INT DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Procedure to safely add missing columns if updating an existing database table
DROP PROCEDURE IF EXISTS AddAdminColumnsToQuestions;
DELIMITER //
CREATE PROCEDURE AddAdminColumnsToQuestions()
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='gyan_setu' AND TABLE_NAME='questions' AND COLUMN_NAME='subject') THEN
        ALTER TABLE `questions` ADD COLUMN `subject` VARCHAR(50) NOT NULL DEFAULT 'MATHS';
    END IF;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='gyan_setu' AND TABLE_NAME='questions' AND COLUMN_NAME='category') THEN
        ALTER TABLE `questions` ADD COLUMN `category` VARCHAR(100) NOT NULL DEFAULT 'General';
    END IF;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='gyan_setu' AND TABLE_NAME='questions' AND COLUMN_NAME='difficulty') THEN
        ALTER TABLE `questions` ADD COLUMN `difficulty` ENUM('Easy', 'Medium', 'Hard') DEFAULT 'Easy';
    END IF;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='gyan_setu' AND TABLE_NAME='questions' AND COLUMN_NAME='coins_reward') THEN
        ALTER TABLE `questions` ADD COLUMN `coins_reward` INT DEFAULT 10;
    END IF;
END //
DELIMITER ;

CALL AddAdminColumnsToQuestions();
DROP PROCEDURE AddAdminColumnsToQuestions;

-- 4. Ensure Options Table Exists
CREATE TABLE IF NOT EXISTS `options` (
  `option_id` INT AUTO_INCREMENT PRIMARY KEY,
  `question_id` INT NOT NULL,
  `option_text` TEXT NOT NULL,
  `is_correct` TINYINT(1) DEFAULT 0,
  FOREIGN KEY (`question_id`) REFERENCES `questions`(`question_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Sample Demo Questions matching screenshot if table is empty
INSERT INTO `questions` (`question_id`, `quiz_id`, `subject`, `category`, `question_text`, `question_type`, `difficulty`, `coins_reward`, `correct_answer_text`) 
SELECT 1, 1, 'MATHS', 'Simple Addition', '4 + ? = 10', 'multiple_choice', 'Easy', 10, '6'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `question_id` = 1);

INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 1, '2', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 1 AND `option_text` = '2');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 1, '4', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 1 AND `option_text` = '4');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 1, '6', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 1 AND `option_text` = '6');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 1, '8', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 1 AND `option_text` = '8');

INSERT INTO `questions` (`question_id`, `quiz_id`, `subject`, `category`, `question_text`, `question_type`, `difficulty`, `coins_reward`, `correct_answer_text`) 
SELECT 2, 1, 'MATHS', 'Multiplication', '4 x 3 = ?', 'multiple_choice', 'Medium', 15, '12'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `question_id` = 2);

INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 2, '10', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 2 AND `option_text` = '10');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 2, '12', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 2 AND `option_text` = '12');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 2, '14', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 2 AND `option_text` = '14');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 2, '16', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 2 AND `option_text` = '16');

INSERT INTO `questions` (`question_id`, `quiz_id`, `subject`, `category`, `question_text`, `question_type`, `difficulty`, `coins_reward`, `correct_answer_text`) 
SELECT 3, 1, 'MATHS', 'Fractions', '1/2 + 1/4 = ?', 'multiple_choice', 'Hard', 20, '3/4'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `question_id` = 3);

INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 3, '1/2', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 3 AND `option_text` = '1/2');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 3, '2/3', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 3 AND `option_text` = '2/3');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 3, '3/4', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 3 AND `option_text` = '3/4');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 3, '5/8', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 3 AND `option_text` = '5/8');

INSERT INTO `questions` (`question_id`, `quiz_id`, `subject`, `category`, `question_text`, `question_type`, `difficulty`, `coins_reward`, `correct_answer_text`) 
SELECT 4, 1, 'ENGLISH', 'Vocabulary Matcher', 'Which is a spelling of correct animal?', 'multiple_choice', 'Easy', 10, 'Lion'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `question_id` = 4);

INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 4, 'Lioan', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 4 AND `option_text` = 'Lioan');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 4, 'Lion', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 4 AND `option_text` = 'Lion');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 4, 'Leen', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 4 AND `option_text` = 'Leen');

INSERT INTO `questions` (`question_id`, `quiz_id`, `subject`, `category`, `question_text`, `question_type`, `difficulty`, `coins_reward`, `correct_answer_text`) 
SELECT 5, 1, 'STORY', 'Mystery Stories', 'How many days was Vance missing for?', 'multiple_choice', 'Medium', 15, '2 days'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `question_id` = 5);

INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 5, '1 day', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 5 AND `option_text` = '1 day');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 5, '2 days', 1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 5 AND `option_text` = '2 days');
INSERT INTO `options` (`question_id`, `option_text`, `is_correct`)
SELECT 5, '3 days', 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `options` WHERE `question_id` = 5 AND `option_text` = '3 days');
