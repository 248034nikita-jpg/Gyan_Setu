-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 06, 2026 at 08:00 AM
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
-- Table structure for table `child_badges`
--

CREATE TABLE `child_badges` (
  `child_badge_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `badge_id` int(11) NOT NULL,
  `date_earned` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `child_badges`
--

INSERT INTO `child_badges` (`child_badge_id`, `child_id`, `badge_id`, `date_earned`) VALUES
(1, 9, 1, '2026-09-02 18:03:48'),
(2, 9, 3, '2026-09-02 18:03:48'),
(3, 9, 2, '2026-09-03 14:41:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `child_badges`
--
ALTER TABLE `child_badges`
  ADD PRIMARY KEY (`child_badge_id`),
  ADD UNIQUE KEY `uk_child_badge` (`child_id`,`badge_id`),
  ADD KEY `fk_childbadges_badge` (`badge_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `child_badges`
--
ALTER TABLE `child_badges`
  MODIFY `child_badge_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `child_badges`
--
ALTER TABLE `child_badges`
  ADD CONSTRAINT `fk_childbadges_badge` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`badge_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_childbadges_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
