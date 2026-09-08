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
-- Table structure for table `badge_criteria`
--

CREATE TABLE `badge_criteria` (
  `criteria_id` int(11) NOT NULL,
  `badge_id` int(11) NOT NULL,
  `criteria_type_id` int(11) NOT NULL,
  `game_id` int(11) DEFAULT NULL,
  `topic` varchar(50) NOT NULL DEFAULT '',
  `concept` varchar(100) NOT NULL DEFAULT '',
  `difficulty_tier` int(11) DEFAULT NULL,
  `threshold_value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `badge_criteria`
--

INSERT INTO `badge_criteria` (`criteria_id`, `badge_id`, `criteria_type_id`, `game_id`, `topic`, `concept`, `difficulty_tier`, `threshold_value`) VALUES
(1, 1, 1, NULL, '', '', NULL, 1),
(2, 2, 1, 1, 'grammar', 'is / am / are', 1, 1),
(3, 3, 1, 1, 'vocabulary', 'opposites', 1, 1),
(4, 4, 5, 1, 'grammar', '', NULL, 3),
(5, 5, 5, 1, 'vocabulary', '', NULL, 3),
(6, 6, 6, 1, '', '', NULL, 6),
(7, 7, 2, NULL, '', '', NULL, 20),
(8, 8, 3, NULL, '', '', NULL, 5),
(9, 9, 4, NULL, '', '', 3, 90),
(10, 10, 7, NULL, '', '', NULL, 7);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `badge_criteria`
--
ALTER TABLE `badge_criteria`
  ADD PRIMARY KEY (`criteria_id`),
  ADD KEY `fk_criteria_badge` (`badge_id`),
  ADD KEY `fk_criteria_game` (`game_id`),
  ADD KEY `fk_criteria_type` (`criteria_type_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `badge_criteria`
--
ALTER TABLE `badge_criteria`
  MODIFY `criteria_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `badge_criteria`
--
ALTER TABLE `badge_criteria`
  ADD CONSTRAINT `fk_criteria_badge` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`badge_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_type` FOREIGN KEY (`criteria_type_id`) REFERENCES `criteria_types` (`criteria_type_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
