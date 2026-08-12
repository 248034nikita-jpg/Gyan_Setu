-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 09, 2026 at 09:42 AM
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
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `admin_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('super_admin','content_manager','support') DEFAULT 'content_manager',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

-- --------------------------------------------------------

--
-- Table structure for table `children`
--

CREATE TABLE `children` (
  `child_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `age` int(11) NOT NULL DEFAULT 5,
  `mascot_id` int(11) DEFAULT 1,
  `total_coins` int(11) NOT NULL DEFAULT 0,
  `current_level` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

-- --------------------------------------------------------

--
-- Table structure for table `child_game_difficulty`
--

CREATE TABLE `child_game_difficulty` (
  `child_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `current_difficulty_tier` int(11) NOT NULL DEFAULT 1,
  `streak_count` int(11) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `child_progress`
--

CREATE TABLE `child_progress` (
  `progress_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `status` enum('not_started','in_progress','completed') DEFAULT 'not_started',
  `course_score` int(11) DEFAULT NULL,
  `last_accessed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `difficulty_level` varchar(20) DEFAULT 'Beginner',
  `min_age` int(11) DEFAULT 3,
  `max_age` int(11) DEFAULT 12
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `title`, `description`, `difficulty_level`, `min_age`, `max_age`) VALUES
(1, 'english', NULL, 'Beginner', 8, 9);

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

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `game_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `game_type` enum('hangman','whack_a_mole','capybara_quiz','science_nature','drag_drop_shapes') NOT NULL,
  `description` text DEFAULT NULL,
  `min_age` int(11) NOT NULL DEFAULT 3,
  `max_age` int(11) NOT NULL DEFAULT 12,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`game_id`, `title`, `slug`, `game_type`, `description`, `min_age`, `max_age`, `is_active`) VALUES
(1, 'Word Whack', 'word-whack', 'whack_a_mole', 'Whack the mole holding the correct answer.', 8, 9, 1);

-- --------------------------------------------------------

--
-- Table structure for table `game_access`
--

CREATE TABLE `game_access` (
  `game_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hangman_words`
--

CREATE TABLE `hangman_words` (
  `word_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `word` varchar(50) NOT NULL,
  `hint` varchar(255) NOT NULL,
  `category` varchar(50) DEFAULT 'General',
  `difficulty_tier` int(11) NOT NULL DEFAULT 1,
  `target_age_min` int(11) DEFAULT 5,
  `target_age_max` int(11) DEFAULT 12
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mascots`
--

CREATE TABLE `mascots` (
  `mascot_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `emoji_or_icon` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `unlock_level` int(11) DEFAULT 1,
  `point_cost` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parents`
--

CREATE TABLE `parents` (
  `parent_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `registered_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parent_orders`
--

CREATE TABLE `parent_orders` (
  `order_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `parent_item_id` int(11) NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `payment_method` enum('eSewa','Khalti','Card') NOT NULL,
  `order_status` enum('Pending','Completed','Failed') DEFAULT 'Completed',
  `transaction_reference` varchar(100) DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parent_shop_items`
--

CREATE TABLE `parent_shop_items` (
  `parent_item_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `item_type` enum('pdf_worksheet','workbook','learning_kit','digital_guide') NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `file_download_url` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('eSewa','Khalti','Card') NOT NULL,
  `payment_status` enum('Pending','Completed','Failed') DEFAULT 'Pending',
  `transaction_reference` varchar(100) DEFAULT NULL,
  `paid_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `progress_dashboard`
-- (See below for the actual view)
--
CREATE TABLE `progress_dashboard` (
);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `purchase_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `coins_spent` int(11) NOT NULL,
  `purchase_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quiz_options`
--

CREATE TABLE `quiz_options` (
  `option_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `option_text` text NOT NULL,
  `is_correct` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_options`
--

INSERT INTO `quiz_options` (`option_id`, `question_id`, `option_text`, `is_correct`) VALUES
(1441, 361, 'be', 0),
(1442, 361, 'am', 0),
(1443, 361, 'is', 1),
(1444, 361, 'are', 0),
(1445, 362, 'is', 0),
(1446, 362, 'are', 0),
(1447, 362, 'be', 0),
(1448, 362, 'am', 1),
(1449, 363, 'am', 0),
(1450, 363, 'is', 0),
(1451, 363, 'be', 0),
(1452, 363, 'are', 1),
(1453, 364, 'be', 0),
(1454, 364, 'are', 1),
(1455, 364, 'am', 0),
(1456, 364, 'is', 0),
(1457, 365, 'are', 0),
(1458, 365, 'is', 1),
(1459, 365, 'am', 0),
(1460, 365, 'be', 0),
(1461, 366, 'are', 1),
(1462, 366, 'be', 0),
(1463, 366, 'is', 0),
(1464, 366, 'am', 0),
(1465, 367, 'am', 0),
(1466, 367, 'be', 0),
(1467, 367, 'are', 0),
(1468, 367, 'is', 1),
(1469, 368, 'be', 0),
(1470, 368, 'is', 0),
(1471, 368, 'are', 1),
(1472, 368, 'am', 0),
(1473, 369, 'is', 0),
(1474, 369, 'are', 0),
(1475, 369, 'am', 1),
(1476, 369, 'be', 0),
(1477, 370, 'am', 0),
(1478, 370, 'be', 0),
(1479, 370, 'are', 0),
(1480, 370, 'is', 1),
(1481, 371, 'be', 0),
(1482, 371, 'is', 0),
(1483, 371, 'am', 0),
(1484, 371, 'are', 1),
(1485, 372, 'be', 0),
(1486, 372, 'am', 0),
(1487, 372, 'are', 0),
(1488, 372, 'is', 1),
(1489, 373, 'be', 0),
(1490, 373, 'are', 1),
(1491, 373, 'is', 0),
(1492, 373, 'am', 0),
(1493, 374, 'is', 0),
(1494, 374, 'be', 0),
(1495, 374, 'am', 1),
(1496, 374, 'are', 0),
(1497, 375, 'am', 0),
(1498, 375, 'be', 0),
(1499, 375, 'are', 0),
(1500, 375, 'is', 1),
(1501, 376, 'is', 0),
(1502, 376, 'am', 0),
(1503, 376, 'are', 1),
(1504, 376, 'be', 0),
(1505, 377, 'is', 0),
(1506, 377, 'be', 0),
(1507, 377, 'am', 0),
(1508, 377, 'are', 1),
(1509, 378, 'be', 0),
(1510, 378, 'is', 1),
(1511, 378, 'am', 0),
(1512, 378, 'are', 0),
(1513, 379, 'be', 0),
(1514, 379, 'is', 0),
(1515, 379, 'are', 1),
(1516, 379, 'am', 0),
(1517, 380, 'be', 0),
(1518, 380, 'am', 0),
(1519, 380, 'are', 0),
(1520, 380, 'is', 1),
(1521, 381, 'go', 0),
(1522, 381, 'gone', 0),
(1523, 381, 'went', 1),
(1524, 381, 'going', 0),
(1525, 382, 'ate', 1),
(1526, 382, 'eat', 0),
(1527, 382, 'eating', 0),
(1528, 382, 'eaten', 0),
(1529, 383, 'seeing', 0),
(1530, 383, 'saw', 1),
(1531, 383, 'seen', 0),
(1532, 383, 'see', 0),
(1533, 384, 'watches', 0),
(1534, 384, 'watch', 0),
(1535, 384, 'watching', 0),
(1536, 384, 'watched', 1),
(1537, 385, 'finishes', 0),
(1538, 385, 'finish', 0),
(1539, 385, 'finished', 1),
(1540, 385, 'finishing', 0),
(1541, 386, 'traveling', 0),
(1542, 386, 'traveled', 1),
(1543, 386, 'travels', 0),
(1544, 386, 'travel', 0),
(1545, 387, 'write', 0),
(1546, 387, 'wrote', 1),
(1547, 387, 'writing', 0),
(1548, 387, 'written', 0),
(1549, 388, 'close', 0),
(1550, 388, 'closed', 1),
(1551, 388, 'closes', 0),
(1552, 388, 'closing', 0),
(1553, 389, 'plays', 0),
(1554, 389, 'played', 1),
(1555, 389, 'playing', 0),
(1556, 389, 'play', 0),
(1557, 390, 'lost', 1),
(1558, 390, 'lose', 0),
(1559, 390, 'loses', 0),
(1560, 390, 'losing', 0),
(1561, 391, 'were', 0),
(1562, 391, 'was', 1),
(1563, 391, 'is', 0),
(1564, 391, 'am', 0),
(1565, 392, 'is', 0),
(1566, 392, 'were', 1),
(1567, 392, 'was', 0),
(1568, 392, 'are', 0),
(1569, 393, 'drawing', 0),
(1570, 393, 'drew', 1),
(1571, 393, 'draw', 0),
(1572, 393, 'drawn', 0),
(1573, 394, 'gave', 1),
(1574, 394, 'giving', 0),
(1575, 394, 'give', 0),
(1576, 394, 'given', 0),
(1577, 395, 'came', 1),
(1578, 395, 'comes', 0),
(1579, 395, 'come', 0),
(1580, 395, 'coming', 0),
(1581, 396, 'removed', 1),
(1582, 396, 'removing', 0),
(1583, 396, 'remove', 0),
(1584, 396, 'removes', 0),
(1585, 397, 'know', 0),
(1586, 397, 'known', 0),
(1587, 397, 'knew', 1),
(1588, 397, 'knowing', 0),
(1589, 398, 'keeps', 0),
(1590, 398, 'kept', 1),
(1591, 398, 'keeping', 0),
(1592, 398, 'keep', 0),
(1593, 399, 'buy', 0),
(1594, 399, 'bought', 1),
(1595, 399, 'buys', 0),
(1596, 399, 'buying', 0),
(1597, 400, 'visit', 0),
(1598, 400, 'visits', 0),
(1599, 400, 'visiting', 0),
(1600, 400, 'visited', 1),
(1601, 401, 'will', 1),
(1602, 401, 'was', 0),
(1603, 401, 'would', 0),
(1604, 401, 'did', 0),
(1605, 402, 'has', 0),
(1606, 402, 'did', 0),
(1607, 402, 'will', 1),
(1608, 402, 'was', 0),
(1609, 403, 'was', 0),
(1610, 403, 'are', 0),
(1611, 403, 'will', 1),
(1612, 403, 'would', 0),
(1613, 404, 'did', 0),
(1614, 404, 'is', 0),
(1615, 404, 'will', 1),
(1616, 404, 'was', 0),
(1617, 405, 'will', 1),
(1618, 405, 'did', 0),
(1619, 405, 'is', 0),
(1620, 405, 'was', 0),
(1621, 406, 'did', 0),
(1622, 406, 'was', 0),
(1623, 406, 'is', 0),
(1624, 406, 'will', 1),
(1625, 407, 'will', 1),
(1626, 407, 'was', 0),
(1627, 407, 'is', 0),
(1628, 407, 'did', 0),
(1629, 408, 'is', 0),
(1630, 408, 'will', 1),
(1631, 408, 'did', 0),
(1632, 408, 'was', 0),
(1633, 409, 'will', 1),
(1634, 409, 'was', 0),
(1635, 409, 'did', 0),
(1636, 409, 'is', 0),
(1637, 410, 'will', 1),
(1638, 410, 'did', 0),
(1639, 410, 'was', 0),
(1640, 410, 'is', 0),
(1641, 411, 'is', 0),
(1642, 411, 'did', 0),
(1643, 411, 'was', 0),
(1644, 411, 'will', 1),
(1645, 412, 'was', 0),
(1646, 412, 'did', 0),
(1647, 412, 'is', 0),
(1648, 412, 'will', 1),
(1649, 413, 'did', 0),
(1650, 413, 'will', 1),
(1651, 413, 'is', 0),
(1652, 413, 'was', 0),
(1653, 414, 'did', 0),
(1654, 414, 'is', 0),
(1655, 414, 'was', 0),
(1656, 414, 'will', 1),
(1657, 415, 'was', 0),
(1658, 415, 'did', 0),
(1659, 415, 'is', 0),
(1660, 415, 'will', 1),
(1661, 416, 'did', 0),
(1662, 416, 'is', 0),
(1663, 416, 'was', 0),
(1664, 416, 'will', 1),
(1665, 417, 'did', 0),
(1666, 417, 'was', 0),
(1667, 417, 'is', 0),
(1668, 417, 'will', 1),
(1669, 418, 'will', 1),
(1670, 418, 'is', 0),
(1671, 418, 'did', 0),
(1672, 418, 'was', 0),
(1673, 419, 'will', 1),
(1674, 419, 'was', 0),
(1675, 419, 'is', 0),
(1676, 419, 'did', 0),
(1677, 420, 'was', 0),
(1678, 420, 'did', 0),
(1679, 420, 'will', 1),
(1680, 420, 'is', 0),
(1681, 421, 'small', 1),
(1682, 421, 'wide', 0),
(1683, 421, 'tall', 0),
(1684, 421, 'long', 0),
(1685, 422, 'joyful', 0),
(1686, 422, 'sad', 1),
(1687, 422, 'glad', 0),
(1688, 422, 'cheerful', 0),
(1689, 423, 'dry', 0),
(1690, 423, 'wet', 0),
(1691, 423, 'cold', 1),
(1692, 423, 'warm', 0),
(1693, 424, 'swift', 0),
(1694, 424, 'slow', 1),
(1695, 424, 'quick', 0),
(1696, 424, 'rapid', 0),
(1697, 425, 'small', 0),
(1698, 425, 'wide', 0),
(1699, 425, 'big', 0),
(1700, 425, 'close', 1),
(1701, 426, 'star', 0),
(1702, 426, 'night', 1),
(1703, 426, 'moon', 0),
(1704, 426, 'sun', 0),
(1705, 427, 'top', 0),
(1706, 427, 'down', 1),
(1707, 427, 'over', 0),
(1708, 427, 'side', 0),
(1709, 428, 'new', 1),
(1710, 428, 'big', 0),
(1711, 428, 'heavy', 0),
(1712, 428, 'small', 0),
(1713, 429, 'light', 0),
(1714, 429, 'empty', 1),
(1715, 429, 'big', 0),
(1716, 429, 'heavy', 0),
(1717, 430, 'bright', 0),
(1718, 430, 'dirty', 1),
(1719, 430, 'neat', 0),
(1720, 430, 'shiny', 0),
(1721, 431, 'big', 0),
(1722, 431, 'long', 0),
(1723, 431, 'short', 1),
(1724, 431, 'wide', 0),
(1725, 432, 'small', 0),
(1726, 432, 'wide', 0),
(1727, 432, 'light', 1),
(1728, 432, 'big', 0),
(1729, 433, 'tall', 0),
(1730, 433, 'weak', 1),
(1731, 433, 'fast', 0),
(1732, 433, 'short', 0),
(1733, 434, 'soft', 0),
(1734, 434, 'hot', 0),
(1735, 434, 'cold', 0),
(1736, 434, 'dry', 1),
(1737, 435, 'quick', 0),
(1738, 435, 'fast', 0),
(1739, 435, 'late', 1),
(1740, 435, 'slow', 0),
(1741, 436, 'far', 1),
(1742, 436, 'close', 0),
(1743, 436, 'small', 0),
(1744, 436, 'big', 0),
(1745, 437, 'heavy', 0),
(1746, 437, 'big', 0),
(1747, 437, 'soft', 1),
(1748, 437, 'light', 0),
(1749, 438, 'high', 0),
(1750, 438, 'sharp', 0),
(1751, 438, 'low', 0),
(1752, 438, 'quiet', 1),
(1753, 439, 'long', 0),
(1754, 439, 'thin', 1),
(1755, 439, 'short', 0),
(1756, 439, 'wide', 0),
(1757, 440, 'kind', 0),
(1758, 440, 'poor', 1),
(1759, 440, 'strong', 0),
(1760, 440, 'happy', 0),
(1761, 441, 'joyful', 1),
(1762, 441, 'angry', 0),
(1763, 441, 'sad', 0),
(1764, 441, 'tired', 0),
(1765, 442, 'tiny', 0),
(1766, 442, 'short', 0),
(1767, 442, 'small', 0),
(1768, 442, 'huge', 1),
(1769, 443, 'slow', 0),
(1770, 443, 'fast', 1),
(1771, 443, 'lazy', 0),
(1772, 443, 'calm', 0),
(1773, 444, 'plain', 0),
(1774, 444, 'ugly', 0),
(1775, 444, 'pretty', 1),
(1776, 444, 'dull', 0),
(1777, 445, 'shy', 0),
(1778, 445, 'foolish', 0),
(1779, 445, 'clever', 1),
(1780, 445, 'weak', 0),
(1781, 446, 'calm', 0),
(1782, 446, 'unhappy', 1),
(1783, 446, 'joyful', 0),
(1784, 446, 'proud', 0),
(1785, 447, 'tall', 0),
(1786, 447, 'wide', 0),
(1787, 447, 'tiny', 1),
(1788, 447, 'huge', 0),
(1789, 448, 'soft', 0),
(1790, 448, 'weak', 0),
(1791, 448, 'gentle', 0),
(1792, 448, 'powerful', 1),
(1793, 449, 'amusing', 1),
(1794, 449, 'serious', 0),
(1795, 449, 'sad', 0),
(1796, 449, 'boring', 0),
(1797, 450, 'fearful', 0),
(1798, 450, 'weak', 0),
(1799, 450, 'courageous', 1),
(1800, 450, 'shy', 0),
(1801, 451, 'rude', 0),
(1802, 451, 'cruel', 0),
(1803, 451, 'harsh', 0),
(1804, 451, 'gentle', 1),
(1805, 452, 'happy', 0),
(1806, 452, 'furious', 1),
(1807, 452, 'gentle', 0),
(1808, 452, 'calm', 0),
(1809, 453, 'fresh', 0),
(1810, 453, 'energetic', 0),
(1811, 453, 'exhausted', 1),
(1812, 453, 'active', 0),
(1813, 454, 'noisy', 0),
(1814, 454, 'silent', 1),
(1815, 454, 'busy', 0),
(1816, 454, 'loud', 0),
(1817, 455, 'simple', 1),
(1818, 455, 'difficult', 0),
(1819, 455, 'hard', 0),
(1820, 455, 'complex', 0),
(1821, 456, 'simple', 0),
(1822, 456, 'plain', 0),
(1823, 456, 'hard', 1),
(1824, 456, 'easy', 0),
(1825, 457, 'tidy', 1),
(1826, 457, 'dirty', 0),
(1827, 457, 'messy', 0),
(1828, 457, 'dusty', 0),
(1829, 458, 'sunny', 0),
(1830, 458, 'chilly', 1),
(1831, 458, 'warm', 0),
(1832, 458, 'hot', 0),
(1833, 459, 'satisfied', 0),
(1834, 459, 'sleepy', 0),
(1835, 459, 'full', 0),
(1836, 459, 'starving', 1),
(1837, 460, 'brave', 0),
(1838, 460, 'calm', 0),
(1839, 460, 'bold', 0),
(1840, 460, 'frightened', 1),
(1841, 461, 'bored', 0),
(1842, 461, 'delighted', 1),
(1843, 461, 'tired', 0),
(1844, 461, 'upset', 0),
(1845, 462, 'clear', 0),
(1846, 462, 'calm', 0),
(1847, 462, 'sunny', 0),
(1848, 462, 'stormy', 1),
(1849, 463, 'selfish', 0),
(1850, 463, 'rude', 0),
(1851, 463, 'lazy', 0),
(1852, 463, 'generous', 1),
(1853, 464, 'new', 0),
(1854, 464, 'wide', 0),
(1855, 464, 'fragile', 1),
(1856, 464, 'strong', 0),
(1857, 465, 'quickly', 0),
(1858, 465, 'loudly', 0),
(1859, 465, 'slowly', 0),
(1860, 465, 'quietly', 1),
(1861, 466, 'curious', 0),
(1862, 466, 'excited', 0),
(1863, 466, 'calm', 0),
(1864, 466, 'exhausted', 1),
(1865, 467, 'confuse', 0),
(1866, 467, 'clarify', 1),
(1867, 467, 'ignore', 0),
(1868, 467, 'hide', 0),
(1869, 468, 'protect', 1),
(1870, 468, 'ignore', 0),
(1871, 468, 'damage', 0),
(1872, 468, 'waste', 0),
(1873, 469, 'active', 1),
(1874, 469, 'dull', 0),
(1875, 469, 'tired', 0),
(1876, 469, 'lazy', 0),
(1877, 470, 'priceless', 0),
(1878, 470, 'affordable', 1),
(1879, 470, 'rare', 0),
(1880, 470, 'costly', 0),
(1881, 471, 'anger', 0),
(1882, 471, 'boredom', 0),
(1883, 471, 'curiosity', 1),
(1884, 471, 'fear', 0),
(1885, 472, 'argue', 0),
(1886, 472, 'cooperate', 1),
(1887, 472, 'compete', 0),
(1888, 472, 'ignore', 0),
(1889, 473, 'cruel', 0),
(1890, 473, 'truthful', 1),
(1891, 473, 'careless', 0),
(1892, 473, 'dishonest', 0),
(1893, 474, 'grieve', 1),
(1894, 474, 'relax', 0),
(1895, 474, 'laugh', 0),
(1896, 474, 'celebrate', 0),
(1897, 475, 'habit', 0),
(1898, 475, 'plan', 0),
(1899, 475, 'routine', 0),
(1900, 475, 'accident', 1),
(1901, 476, 'forest', 0),
(1902, 476, 'zoo', 1),
(1903, 476, 'market', 0),
(1904, 476, 'farm', 0),
(1905, 477, 'shrink', 0),
(1906, 477, 'stop', 0),
(1907, 477, 'expand', 1),
(1908, 477, 'pause', 0),
(1909, 478, 'nervous', 0),
(1910, 478, 'brave', 1),
(1911, 478, 'scared', 0),
(1912, 478, 'shy', 0),
(1913, 479, 'boring', 0),
(1914, 479, 'short', 0),
(1915, 479, 'tricky', 1),
(1916, 479, 'simple', 0),
(1917, 480, 'astonished', 1),
(1918, 480, 'sleepy', 0),
(1919, 480, 'annoyed', 0),
(1920, 480, 'hungry', 0);

-- --------------------------------------------------------

--
-- Table structure for table `quiz_questions`
--

CREATE TABLE `quiz_questions` (
  `question_id` int(11) NOT NULL,
  `game_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `question_text` text NOT NULL,
  `topic` varchar(20) DEFAULT NULL,
  `concept` varchar(50) DEFAULT NULL,
  `question_type` enum('multiple_choice','true_false','puzzle') DEFAULT 'multiple_choice',
  `difficulty_tier` int(11) NOT NULL DEFAULT 1,
  `target_age_min` int(11) DEFAULT 3,
  `target_age_max` int(11) DEFAULT 12
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_questions`
--

INSERT INTO `quiz_questions` (`question_id`, `game_id`, `course_id`, `question_text`, `topic`, `concept`, `question_type`, `difficulty_tier`, `target_age_min`, `target_age_max`) VALUES
(361, 1, 1, 'She ___ a doctor.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(362, 1, 1, 'I ___ nine years old.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(363, 1, 1, 'They ___ playing in the garden.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(364, 1, 1, 'We ___ students.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(365, 1, 1, 'He ___ my brother.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(366, 1, 1, 'You ___ very kind.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(367, 1, 1, 'It ___ a big elephant.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(368, 1, 1, 'My parents ___ farmers.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(369, 1, 1, 'I ___ happy today.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(370, 1, 1, 'The sky ___ blue.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(371, 1, 1, 'We ___ ready for school.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(372, 1, 1, 'She ___ my best friend.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(373, 1, 1, 'They ___ from Kathmandu.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(374, 1, 1, 'I ___ not tired.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(375, 1, 1, 'He ___ a good singer.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(376, 1, 1, 'The children ___ playing outside.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(377, 1, 1, 'You ___ my classmate.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(378, 1, 1, 'It ___ raining today.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(379, 1, 1, 'We ___ in the same class.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(380, 1, 1, 'She ___ very tall.', 'grammar', 'is / am / are', 'multiple_choice', 1, 8, 9),
(381, 1, 1, 'Yesterday, I ___ to the market.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(382, 1, 1, 'She ___ her lunch already.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(383, 1, 1, 'I ___ my brother yesterday.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(384, 1, 1, 'We ___ a movie last night.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(385, 1, 1, 'He ___ his homework before dinner.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(386, 1, 1, 'They ___ to Pokhara last month.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(387, 1, 1, 'I ___ a letter to my friend.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(388, 1, 1, 'She ___ the door quietly.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(389, 1, 1, 'We ___ football yesterday.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(390, 1, 1, 'He ___ his keys this morning.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(391, 1, 1, 'I ___ very happy yesterday.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(392, 1, 1, 'They ___ at the park last weekend.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(393, 1, 1, 'She ___ a beautiful picture.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(394, 1, 1, 'We ___ our teacher a gift.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(395, 1, 1, 'He ___ home late last night.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(396, 1, 1, 'I ___ my shoes before entering.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(397, 1, 1, 'She ___ the answer correctly.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(398, 1, 1, 'We ___ the classroom clean.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(399, 1, 1, 'He ___ a new bicycle last week.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(400, 1, 1, 'They ___ their grandmother yesterday.', 'grammar', 'simple past tense', 'multiple_choice', 2, 8, 9),
(401, 1, 1, 'Tomorrow, I ___ visit my grandmother.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(402, 1, 1, 'She ___ finish her project by tomorrow.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(403, 1, 1, 'If it rains, we ___ stay inside.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(404, 1, 1, 'Next year, he ___ join a new school.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(405, 1, 1, 'We ___ go to the market later.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(406, 1, 1, 'They ___ visit us next weekend.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(407, 1, 1, 'I ___ call you after school.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(408, 1, 1, 'She ___ not come to the party.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(409, 1, 1, 'He ___ travel to Pokhara next month.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(410, 1, 1, 'We ___ start the game soon.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(411, 1, 1, 'By tomorrow, everything ___ be ready.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(412, 1, 1, 'My father ___ arrive tomorrow morning.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(413, 1, 1, 'They ___ plant new trees next week.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(414, 1, 1, 'I think it ___ rain tomorrow.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(415, 1, 1, 'She ___ celebrate her birthday next Friday.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(416, 1, 1, 'We ___ meet again soon.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(417, 1, 1, 'He ___ not be late again.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(418, 1, 1, 'The train ___ leave at six o\'clock.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(419, 1, 1, 'I ___ finish my homework tonight.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(420, 1, 1, 'They ___ build a new house next year.', 'grammar', 'future tense (will)', 'multiple_choice', 3, 8, 9),
(421, 1, 1, 'Opposite of \"big\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(422, 1, 1, 'Opposite of \"happy\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(423, 1, 1, 'Opposite of \"hot\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(424, 1, 1, 'Opposite of \"fast\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(425, 1, 1, 'Opposite of \"open\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(426, 1, 1, 'Opposite of \"day\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(427, 1, 1, 'Opposite of \"up\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(428, 1, 1, 'Opposite of \"old\" (a thing)', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(429, 1, 1, 'Opposite of \"full\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(430, 1, 1, 'Opposite of \"clean\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(431, 1, 1, 'Opposite of \"tall\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(432, 1, 1, 'Opposite of \"heavy\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(433, 1, 1, 'Opposite of \"strong\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(434, 1, 1, 'Opposite of \"wet\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(435, 1, 1, 'Opposite of \"early\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(436, 1, 1, 'Opposite of \"near\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(437, 1, 1, 'Opposite of \"hard\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(438, 1, 1, 'Opposite of \"loud\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(439, 1, 1, 'Opposite of \"thick\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(440, 1, 1, 'Opposite of \"rich\"', 'vocabulary', 'opposites', 'multiple_choice', 1, 8, 9),
(441, 1, 1, 'Synonym of \"happy\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(442, 1, 1, 'Synonym of \"big\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(443, 1, 1, 'Synonym of \"quick\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(444, 1, 1, 'Synonym of \"beautiful\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(445, 1, 1, 'Synonym of \"smart\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(446, 1, 1, 'Synonym of \"sad\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(447, 1, 1, 'Synonym of \"small\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(448, 1, 1, 'Synonym of \"strong\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(449, 1, 1, 'Synonym of \"funny\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(450, 1, 1, 'Synonym of \"brave\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(451, 1, 1, 'Synonym of \"kind\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(452, 1, 1, 'Synonym of \"angry\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(453, 1, 1, 'Synonym of \"tired\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(454, 1, 1, 'Synonym of \"quiet\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(455, 1, 1, 'Synonym of \"easy\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(456, 1, 1, 'Synonym of \"difficult\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(457, 1, 1, 'Synonym of \"clean\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(458, 1, 1, 'Synonym of \"cold\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(459, 1, 1, 'Synonym of \"hungry\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(460, 1, 1, 'Synonym of \"scared\"', 'vocabulary', 'synonyms', 'multiple_choice', 2, 8, 9),
(461, 1, 1, 'She felt ___ after winning the race.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(462, 1, 1, 'The weather was ___, so we stayed indoors.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(463, 1, 1, 'He is very ___; he always helps others.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(464, 1, 1, 'The old bridge was ___ and dangerous to cross.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(465, 1, 1, 'She whispered ___ so no one could hear.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(466, 1, 1, 'After running for an hour, he felt completely ___.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(467, 1, 1, 'The teacher asked him to ___ his answer clearly.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(468, 1, 1, 'He works hard to ___ his family safe.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(469, 1, 1, 'The puppy was full of energy and very ___.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(470, 1, 1, 'The shoes were cheap and very ___.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(471, 1, 1, 'Her ___ about space made her read many books.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(472, 1, 1, 'The two teams decided to ___ instead of compete.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(473, 1, 1, 'He is known to be ___ and never lies.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(474, 1, 1, 'She was so sad that she began to ___.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(475, 1, 1, 'Losing his bag on the bus was a total ___.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(476, 1, 1, 'The children loved visiting the ___ to see the animals.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(477, 1, 1, 'Over the years, the small shop began to ___ into a big store.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(478, 1, 1, 'Even in danger, the soldier remained ___ and calm.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(479, 1, 1, 'The riddle was so ___ that no one could solve it.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9),
(480, 1, 1, 'She was ___ when she saw the surprise party.', 'vocabulary', 'context-based word choice', 'multiple_choice', 3, 8, 9);

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `score_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `game_id` int(11) DEFAULT NULL,
  `difficulty_tier_played` int(11) NOT NULL DEFAULT 1,
  `topic` varchar(50) NOT NULL DEFAULT '',
  `concept` varchar(100) NOT NULL DEFAULT '',
  `score_value` int(11) NOT NULL DEFAULT 0,
  `total_questions` int(11) NOT NULL DEFAULT 20,
  `accuracy_percentage` decimal(5,2) DEFAULT NULL,
  `streak_achieved` int(11) DEFAULT 0,
  `coins_earned` int(11) NOT NULL DEFAULT 0,
  `date_played` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shape_game_items`
--

CREATE TABLE `shape_game_items` (
  `shape_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `shape_name` varchar(50) NOT NULL,
  `target_zone_id` varchar(50) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `color_hex` varchar(10) DEFAULT NULL,
  `difficulty_tier` int(11) NOT NULL DEFAULT 1,
  `target_age_min` int(11) DEFAULT 3,
  `target_age_max` int(11) DEFAULT 7
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shop_items`
--

CREATE TABLE `shop_items` (
  `item_id` int(11) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price_coins` int(11) NOT NULL,
  `icon_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `subscription_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `plan_name` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','expired','cancelled') DEFAULT 'active',
  `payment_method` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subscription_plans`
--

CREATE TABLE `subscription_plans` (
  `plan_id` int(11) NOT NULL,
  `plan_name` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `duration_days` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_child_best_streak`
-- (See below for the actual view)
--
CREATE TABLE `view_child_best_streak` (
`child_id` int(11)
,`game_id` int(11)
,`best_streak` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_child_daily_activity`
-- (See below for the actual view)
--
CREATE TABLE `view_child_daily_activity` (
`child_id` int(11)
,`game_id` int(11)
,`activity_date` date
,`rounds_played` bigint(21)
,`coins_earned_today` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_child_game_progress`
-- (See below for the actual view)
--
CREATE TABLE `view_child_game_progress` (
`child_id` int(11)
,`game_id` int(11)
,`difficulty_tier` int(11)
,`topic` varchar(50)
,`concept` varchar(100)
,`attempts` bigint(21)
,`best_score` int(11)
,`best_accuracy` decimal(5,2)
);

-- --------------------------------------------------------

--
-- Structure for view `progress_dashboard`
--
DROP TABLE IF EXISTS `progress_dashboard`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `progress_dashboard`  AS SELECT `c`.`child_id` AS `child_id`, `c`.`username` AS `child_name`, `c`.`age` AS `child_age`, `p`.`parent_id` AS `parent_id`, `p`.`full_name` AS `parent_name`, `c`.`total_coins` AS `total_coins`, `c`.`current_level` AS `current_level`, count(distinct `cb`.`badge_id`) AS `badges_earned`, coalesce(avg(`cp`.`course_score`),0) AS `average_course_score`, count(distinct case when `cp`.`status` = 'completed' then `cp`.`course_id` end) AS `courses_completed`, coalesce((select sum(`ps`.`coins_spent`) from `purchases` `ps` where `ps`.`child_id` = `c`.`child_id`),0) AS `total_coins_spent` FROM (((`children` `c` join `parents` `p` on(`c`.`parent_id` = `p`.`parent_id`)) left join `child_badges` `cb` on(`c`.`child_id` = `cb`.`child_id`)) left join `child_progress` `cp` on(`c`.`child_id` = `cp`.`child_id`)) GROUP BY `c`.`child_id`, `p`.`parent_id` ;

-- --------------------------------------------------------

--
-- Structure for view `view_child_best_streak`
--
DROP TABLE IF EXISTS `view_child_best_streak`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_child_best_streak`  AS SELECT `scores`.`child_id` AS `child_id`, `scores`.`game_id` AS `game_id`, max(`scores`.`streak_achieved`) AS `best_streak` FROM `scores` GROUP BY `scores`.`child_id`, `scores`.`game_id` ;

-- --------------------------------------------------------

--
-- Structure for view `view_child_daily_activity`
--
DROP TABLE IF EXISTS `view_child_daily_activity`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_child_daily_activity`  AS SELECT `scores`.`child_id` AS `child_id`, `scores`.`game_id` AS `game_id`, cast(`scores`.`date_played` as date) AS `activity_date`, count(0) AS `rounds_played`, sum(`scores`.`coins_earned`) AS `coins_earned_today` FROM `scores` GROUP BY `scores`.`child_id`, `scores`.`game_id`, cast(`scores`.`date_played` as date) ;

-- --------------------------------------------------------

--
-- Structure for view `view_child_game_progress`
--
DROP TABLE IF EXISTS `view_child_game_progress`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_child_game_progress`  AS SELECT `scores`.`child_id` AS `child_id`, `scores`.`game_id` AS `game_id`, `scores`.`difficulty_tier_played` AS `difficulty_tier`, `scores`.`topic` AS `topic`, `scores`.`concept` AS `concept`, count(0) AS `attempts`, max(`scores`.`score_value`) AS `best_score`, max(`scores`.`accuracy_percentage`) AS `best_accuracy` FROM `scores` GROUP BY `scores`.`child_id`, `scores`.`game_id`, `scores`.`difficulty_tier_played`, `scores`.`topic`, `scores`.`concept` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `badges`
--
ALTER TABLE `badges`
  ADD PRIMARY KEY (`badge_id`),
  ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `badge_criteria`
--
ALTER TABLE `badge_criteria`
  ADD PRIMARY KEY (`criteria_id`),
  ADD KEY `fk_criteria_badge` (`badge_id`),
  ADD KEY `fk_criteria_game` (`game_id`),
  ADD KEY `fk_criteria_type` (`criteria_type_id`);

--
-- Indexes for table `children`
--
ALTER TABLE `children`
  ADD PRIMARY KEY (`child_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_children_mascot` (`mascot_id`),
  ADD KEY `idx_children_parent` (`parent_id`),
  ADD KEY `idx_children_age` (`age`);

--
-- Indexes for table `child_badges`
--
ALTER TABLE `child_badges`
  ADD PRIMARY KEY (`child_badge_id`),
  ADD UNIQUE KEY `uk_child_badge` (`child_id`,`badge_id`),
  ADD KEY `fk_childbadges_badge` (`badge_id`);

--
-- Indexes for table `child_game_difficulty`
--
ALTER TABLE `child_game_difficulty`
  ADD PRIMARY KEY (`child_id`,`game_id`),
  ADD KEY `fk_cgd_game` (`game_id`);

--
-- Indexes for table `child_progress`
--
ALTER TABLE `child_progress`
  ADD PRIMARY KEY (`progress_id`),
  ADD UNIQUE KEY `uk_child_course` (`child_id`,`course_id`),
  ADD KEY `fk_progress_course` (`course_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`);

--
-- Indexes for table `criteria_types`
--
ALTER TABLE `criteria_types`
  ADD PRIMARY KEY (`criteria_type_id`),
  ADD UNIQUE KEY `type_name` (`type_name`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`game_id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_games_age` (`min_age`,`max_age`);

--
-- Indexes for table `game_access`
--
ALTER TABLE `game_access`
  ADD PRIMARY KEY (`game_id`,`plan_id`),
  ADD KEY `idx_gameaccess_plan` (`plan_id`);

--
-- Indexes for table `hangman_words`
--
ALTER TABLE `hangman_words`
  ADD PRIMARY KEY (`word_id`),
  ADD KEY `idx_hangman_tier` (`game_id`,`difficulty_tier`);

--
-- Indexes for table `mascots`
--
ALTER TABLE `mascots`
  ADD PRIMARY KEY (`mascot_id`);

--
-- Indexes for table `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`parent_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_parents_email` (`email`);

--
-- Indexes for table `parent_orders`
--
ALTER TABLE `parent_orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_parentorders_item` (`parent_item_id`),
  ADD KEY `idx_parentorders_parent` (`parent_id`);

--
-- Indexes for table `parent_shop_items`
--
ALTER TABLE `parent_shop_items`
  ADD PRIMARY KEY (`parent_item_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `fk_payments_plan` (`plan_id`),
  ADD KEY `idx_payments_parent` (`parent_id`),
  ADD KEY `idx_payments_tx_ref` (`transaction_reference`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`purchase_id`),
  ADD KEY `fk_purchases_item` (`item_id`),
  ADD KEY `idx_purchases_child` (`child_id`);

--
-- Indexes for table `quiz_options`
--
ALTER TABLE `quiz_options`
  ADD PRIMARY KEY (`option_id`),
  ADD KEY `idx_options_question` (`question_id`);

--
-- Indexes for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `idx_questions_game_tier` (`game_id`,`difficulty_tier`),
  ADD KEY `idx_questions_course_tier` (`course_id`,`difficulty_tier`);

--
-- Indexes for table `scores`
--
ALTER TABLE `scores`
  ADD PRIMARY KEY (`score_id`),
  ADD KEY `idx_scores_child` (`child_id`),
  ADD KEY `idx_scores_game` (`game_id`);

--
-- Indexes for table `shape_game_items`
--
ALTER TABLE `shape_game_items`
  ADD PRIMARY KEY (`shape_id`),
  ADD KEY `idx_shape_tier` (`game_id`,`difficulty_tier`);

--
-- Indexes for table `shop_items`
--
ALTER TABLE `shop_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`subscription_id`),
  ADD KEY `fk_sub_parent` (`parent_id`);

--
-- Indexes for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  ADD PRIMARY KEY (`plan_id`),
  ADD UNIQUE KEY `plan_name` (`plan_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `badges`
--
ALTER TABLE `badges`
  MODIFY `badge_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `badge_criteria`
--
ALTER TABLE `badge_criteria`
  MODIFY `criteria_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `children`
--
ALTER TABLE `children`
  MODIFY `child_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `child_badges`
--
ALTER TABLE `child_badges`
  MODIFY `child_badge_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `child_progress`
--
ALTER TABLE `child_progress`
  MODIFY `progress_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `criteria_types`
--
ALTER TABLE `criteria_types`
  MODIFY `criteria_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `game_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `hangman_words`
--
ALTER TABLE `hangman_words`
  MODIFY `word_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mascots`
--
ALTER TABLE `mascots`
  MODIFY `mascot_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `parent_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parent_orders`
--
ALTER TABLE `parent_orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parent_shop_items`
--
ALTER TABLE `parent_shop_items`
  MODIFY `parent_item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `purchase_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quiz_options`
--
ALTER TABLE `quiz_options`
  MODIFY `option_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1921;

--
-- AUTO_INCREMENT for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=481;

--
-- AUTO_INCREMENT for table `scores`
--
ALTER TABLE `scores`
  MODIFY `score_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shape_game_items`
--
ALTER TABLE `shape_game_items`
  MODIFY `shape_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shop_items`
--
ALTER TABLE `shop_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `subscription_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `plan_id` int(11) NOT NULL AUTO_INCREMENT;

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

--
-- Constraints for table `children`
--
ALTER TABLE `children`
  ADD CONSTRAINT `fk_children_mascot` FOREIGN KEY (`mascot_id`) REFERENCES `mascots` (`mascot_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_children_parent` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`parent_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `child_badges`
--
ALTER TABLE `child_badges`
  ADD CONSTRAINT `fk_childbadges_badge` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`badge_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_childbadges_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `child_game_difficulty`
--
ALTER TABLE `child_game_difficulty`
  ADD CONSTRAINT `fk_cgd_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cgd_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `child_progress`
--
ALTER TABLE `child_progress`
  ADD CONSTRAINT `fk_progress_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_progress_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `game_access`
--
ALTER TABLE `game_access`
  ADD CONSTRAINT `fk_gameaccess_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gameaccess_plan` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`plan_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hangman_words`
--
ALTER TABLE `hangman_words`
  ADD CONSTRAINT `fk_hangman_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `parent_orders`
--
ALTER TABLE `parent_orders`
  ADD CONSTRAINT `fk_parentorders_item` FOREIGN KEY (`parent_item_id`) REFERENCES `parent_shop_items` (`parent_item_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_parentorders_parent` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`parent_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_parent` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`parent_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payments_plan` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`plan_id`) ON UPDATE CASCADE;

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `fk_purchases_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchases_item` FOREIGN KEY (`item_id`) REFERENCES `shop_items` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `quiz_options`
--
ALTER TABLE `quiz_options`
  ADD CONSTRAINT `fk_options_question` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD CONSTRAINT `fk_questions_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_questions_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `scores`
--
ALTER TABLE `scores`
  ADD CONSTRAINT `fk_scores_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_scores_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `shape_game_items`
--
ALTER TABLE `shape_game_items`
  ADD CONSTRAINT `fk_shape_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `fk_sub_parent` FOREIGN KEY (`parent_id`) REFERENCES `parents` (`parent_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
