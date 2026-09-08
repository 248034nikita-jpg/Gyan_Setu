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
-- Table structure for table `criteria_types`
--

CREATE TABLE `criteria_types` (
  `criteria_type_id` int(11) NOT NULL,
  `type_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `criteria_types`
--

INSERT INTO `criteria_types` (`criteria_type_id`, `type_name`, `description`) VALUES
(1, 'rounds_completed', 'Total attempts across matching rounds meets threshold_value'),
(2, 'perfect_score', 'A single round scored at or above threshold_value'),
(3, 'streak', 'Best-ever correct-answer streak meets threshold_value'),
(4, 'accuracy_threshold', 'A single round\'s accuracy meets threshold_value (%)'),
(5, 'topic_all_tiers', 'All difficulty tiers within a topic have been attempted'),
(6, 'game_all_rounds', 'All round-types within a game have been attempted'),
(7, 'daily_streak', 'Played on threshold_value consecutive days');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `criteria_types`
--
ALTER TABLE `criteria_types`
  ADD PRIMARY KEY (`criteria_type_id`),
  ADD UNIQUE KEY `type_name` (`type_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `criteria_types`
--
ALTER TABLE `criteria_types`
  MODIFY `criteria_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
