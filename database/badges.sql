-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 21, 2026 at 08:52 AM
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
-- Database: `gyansetudb`
--

-- --------------------------------------------------------

--
-- Table structure for table `badges`
--

CREATE TABLE `badges` (
  `badge_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `icon_url` varchar(255) DEFAULT NULL,
  `coins_reward` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `badges`
--

INSERT INTO `badges` (`badge_id`, `title`, `description`, `icon_url`, `coins_reward`) VALUES
(1, 'First Steps', 'Complete your first round of any topic.', NULL, 5),
(2, 'Grammar Starter', 'Finish the is / am / are round.', NULL, 5),
(3, 'Word Explorer', 'Finish the opposites round.', NULL, 5),
(4, 'Grammar Master', 'Complete all 3 grammar tiers.', NULL, 15),
(5, 'Vocabulary Master', 'Complete all 3 vocabulary tiers.', NULL, 15),
(6, 'English Champion', 'Complete all 6 rounds across both grammar and vocabulary.', NULL, 25),
(7, 'Perfect Score', 'Get 10 out of 10 correct in any single round.', NULL, 10),
(8, 'Sharp Shooter', 'Answer 5 questions correctly in a row without a miss.', NULL, 10),
(9, 'Hard Mode Hero', 'Score 90% or higher on any Hard-tier round.', NULL, 15),
(10, 'Weekly Whacker', 'Play at least once every day for 7 days in a row.', NULL, 20);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `badges`
--
ALTER TABLE `badges`
  ADD PRIMARY KEY (`badge_id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `badges`
--
ALTER TABLE `badges`
  MODIFY `badge_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
