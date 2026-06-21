-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 20, 2026 at 06:40 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gyan_setu`
--

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `question_id` int(11) NOT NULL,
  `quiz_id` int(11) NOT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('multiple_choice','true_false','puzzle','typing') DEFAULT 'multiple_choice',
  `correct_answer_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`question_id`, `quiz_id`, `question_text`, `question_type`, `correct_answer_text`) VALUES
(1, 1, 'Count: ⭐ ⭐ ⭐. How many stars?', '', '3'),
(2, 1, 'What is 1 + 1?', '', '2'),
(3, 1, 'Circle the bigger number: 2 or 5?', 'multiple_choice', NULL),
(4, 1, 'If you have 4 toys and give away 1, how many left?', '', '3'),
(5, 1, 'What is 3 + 2?', '', '5'),
(6, 1, 'You have 6 pencils. You get 2 more. How many now?', '', '8'),
(7, 1, 'What is 5 - 2?', '', '3'),
(8, 1, 'Which is more: 4 apples or 4 oranges? (Same / Different)', 'multiple_choice', NULL),
(9, 1, 'What is 2 × 3? (Hint: 2+2+2)', '', '6'),
(10, 1, 'Share 8 candies equally between 2 friends. How many each?', '', '4'),
(11, 1, 'Half of 10 is ___?', '', '5'),
(12, 1, 'You have 10¢. A candy costs 7¢. How much change?', '', '3'),
(13, 2, 'What letter does \"cat\" start with?', '', 'c'),
(14, 2, 'Does \"ball\" rhyme with \"tall\"? (Yes / No)', 'true_false', NULL),
(15, 2, 'Read: \"The dog is big.\" What is big?', '', 'dog'),
(16, 2, 'What is the opposite of \"hot\"?', '', 'cold'),
(17, 2, 'Read: \"Tom ran fast because he was late.\" Why did Tom run?', '', 'late'),
(18, 2, 'Put in order: He ate. He cooked. He washed hands. (1st, 2nd, 3rd)', '', 'wash, cook, eat'),
(19, 2, 'What does \"tiny\" mean in \"a tiny ant\"? (very small / very big)', 'multiple_choice', NULL),
(20, 2, 'Read: \"Sam likes juice. Ann likes milk.\" What does Sam like?', '', 'juice'),
(21, 2, 'Read: \"You should brush your teeth every day.\" Is this telling you to do something? (Yes / No)', 'true_false', NULL),
(22, 2, 'What does \"as fast as a cheetah\" mean? (very fast / very slow)', 'multiple_choice', NULL),
(23, 2, 'Read: \"The rain poured down, so she opened her umbrella.\" Why did she open her umbrella?', '', 'rain'),
(24, 2, 'Find the happy feeling word: \"The children laughed and jumped.\"', '', 'laughed'),
(25, 3, 'Is a rock living or non-living?', 'multiple_choice', NULL),
(26, 3, 'What do you use to see? (eyes / ears)', 'multiple_choice', NULL),
(27, 3, 'Does a fish live in water or on land?', 'multiple_choice', NULL),
(28, 3, 'Does the sun shine during the day or night?', 'multiple_choice', NULL),
(29, 3, 'Name one thing that is a liquid. (water / rock)', 'multiple_choice', NULL),
(30, 3, 'What is a baby cat called? (kitten / puppy)', 'multiple_choice', NULL),
(31, 3, 'Why do we wear a jacket in winter? (to stay warm / to stay cool)', 'multiple_choice', NULL),
(32, 3, 'What does a seed grow into? (a plant / a rock)', 'multiple_choice', NULL),
(33, 3, 'What do plants need from the sun? (light / music)', 'multiple_choice', NULL),
(34, 3, 'What happens to ice when it gets warm? (melts / turns to stone)', 'multiple_choice', NULL),
(35, 3, 'Which planet do we live on? (Earth / Mars)', 'multiple_choice', NULL),
(36, 3, 'You mix baking soda and vinegar. Bubbles appear. Is this a new thing? (Yes / No)', 'true_false', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `quiz_id` (`quiz_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`quiz_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
