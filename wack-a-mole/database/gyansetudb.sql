-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 07, 2026 at 01:15 PM
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
  `full_name` varchar(100) NOT NULL,
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
`child_id` int(11)
,`child_name` varchar(50)
,`child_age` int(11)
,`parent_id` int(11)
,`parent_name` varchar(100)
,`total_coins` int(11)
,`current_level` int(11)
,`badges_earned` bigint(21)
,`average_course_score` decimal(14,4)
,`courses_completed` bigint(21)
,`total_coins_spent` decimal(32,0)
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
(721, 181, 'are', 0),
(722, 181, 'am', 0),
(723, 181, 'be', 0),
(724, 181, 'is', 1),
(725, 182, 'been', 0),
(726, 182, 'are', 0),
(727, 182, 'am', 1),
(728, 182, 'is', 0),
(729, 183, 'am', 0),
(730, 183, 'be', 0),
(731, 183, 'are', 1),
(732, 183, 'is', 0),
(733, 184, 'is', 0),
(734, 184, 'are', 1),
(735, 184, 'am', 0),
(736, 184, 'be', 0),
(737, 185, 'books', 1),
(738, 185, 'bookes', 0),
(739, 185, 'bookies', 0),
(740, 185, 'book', 0),
(741, 186, 'boxs', 0),
(742, 186, 'boxies', 0),
(743, 186, 'boxes', 1),
(744, 186, 'box', 0),
(745, 187, 'from', 0),
(746, 187, 'at', 0),
(747, 187, 'in', 1),
(748, 187, 'with', 0),
(749, 188, 'from', 0),
(750, 188, 'of', 0),
(751, 188, 'on', 1),
(752, 188, 'at', 0),
(753, 189, 'go', 0),
(754, 189, 'going', 0),
(755, 189, 'goes', 1),
(756, 189, 'gone', 0),
(757, 190, 'done', 0),
(758, 190, 'doing', 0),
(759, 190, 'do', 0),
(760, 190, 'did', 1),
(761, 191, 'the', 0),
(762, 191, 'an', 1),
(763, 191, 'some', 0),
(764, 191, 'a', 0),
(765, 192, 'some', 0),
(766, 192, 'the', 0),
(767, 192, 'an', 0),
(768, 192, 'a', 1),
(769, 193, 'Are', 0),
(770, 193, 'Does', 0),
(771, 193, 'Do', 1),
(772, 193, 'Is', 0),
(773, 194, 'isn\'t', 0),
(774, 194, 'aren\'t', 0),
(775, 194, 'doesn\'t', 1),
(776, 194, 'don\'t', 0),
(777, 195, 'see', 0),
(778, 195, 'saw', 1),
(779, 195, 'seeing', 0),
(780, 195, 'seen', 0),
(781, 196, 'was', 0),
(782, 196, 'is', 0),
(783, 196, 'are', 1),
(784, 196, 'am', 0),
(785, 197, 'am', 0),
(786, 197, 'was', 0),
(787, 197, 'are', 1),
(788, 197, 'is', 0),
(789, 198, 'an', 1),
(790, 198, 'some', 0),
(791, 198, 'a', 0),
(792, 198, 'the', 0),
(793, 199, 'aren\'t', 0),
(794, 199, 'isn\'t', 0),
(795, 199, 'doesn\'t', 0),
(796, 199, 'don\'t', 1),
(797, 200, 'am', 0),
(798, 200, 'is', 1),
(799, 200, 'are', 0),
(800, 200, 'be', 0),
(801, 201, 'go', 0),
(802, 201, 'gone', 0),
(803, 201, 'going', 0),
(804, 201, 'went', 1),
(805, 202, 'eat', 0),
(806, 202, 'eating', 0),
(807, 202, 'eaten', 0),
(808, 202, 'ate', 1),
(809, 203, 'taller', 1),
(810, 203, 'more tall', 0),
(811, 203, 'tallest', 0),
(812, 203, 'tall', 0),
(813, 204, 'highest', 1),
(814, 204, 'more high', 0),
(815, 204, 'high', 0),
(816, 204, 'higher', 0),
(817, 205, 'because', 0),
(818, 205, 'but', 1),
(819, 205, 'and', 0),
(820, 205, 'so', 0),
(821, 206, 'or', 0),
(822, 206, 'so', 0),
(823, 206, 'but', 0),
(824, 206, 'because', 1),
(825, 207, 'When', 0),
(826, 207, 'Where', 0),
(827, 207, 'Who', 0),
(828, 207, 'What', 1),
(829, 208, 'Who', 0),
(830, 208, 'When', 0),
(831, 208, 'What', 0),
(832, 208, 'Where', 1),
(833, 209, 'fastly', 0),
(834, 209, 'faster', 1),
(835, 209, 'fast', 0),
(836, 209, 'fastest', 0),
(837, 210, 'is', 0),
(838, 210, 'was', 0),
(839, 210, 'were', 1),
(840, 210, 'are', 0),
(841, 211, 'are', 0),
(842, 211, 'is', 1),
(843, 211, 'were', 0),
(844, 211, 'was', 0),
(845, 212, 'run', 1),
(846, 212, 'running', 0),
(847, 212, 'ran', 0),
(848, 212, 'runs', 0),
(849, 213, 'is', 0),
(850, 213, 'has', 1),
(851, 213, 'have', 0),
(852, 213, 'was', 0),
(853, 214, 'was', 0),
(854, 214, 'were', 0),
(855, 214, 'is', 0),
(856, 214, 'are', 1),
(857, 215, 'and', 1),
(858, 215, 'or', 0),
(859, 215, 'but', 0),
(860, 215, 'because', 0),
(861, 216, 'heavier', 1),
(862, 216, 'heaviest', 0),
(863, 216, 'more heavy', 0),
(864, 216, 'heavy', 0),
(865, 217, 'Who', 0),
(866, 217, 'What', 0),
(867, 217, 'Where', 1),
(868, 217, 'Why', 0),
(869, 218, 'well', 0),
(870, 218, 'best', 0),
(871, 218, 'better', 1),
(872, 218, 'good', 0),
(873, 219, 'finished', 1),
(874, 219, 'finish', 0),
(875, 219, 'finishing', 0),
(876, 219, 'finishes', 0),
(877, 220, 'were', 0),
(878, 220, 'was', 0),
(879, 220, 'are', 0),
(880, 220, 'is', 1),
(881, 221, 'did', 0),
(882, 221, 'would', 0),
(883, 221, 'will', 1),
(884, 221, 'was', 0),
(885, 222, 'did', 0),
(886, 222, 'was', 0),
(887, 222, 'will', 1),
(888, 222, 'has', 0),
(889, 223, 'was', 0),
(890, 223, 'would', 0),
(891, 223, 'are', 0),
(892, 223, 'will', 1),
(893, 224, 'quickest', 0),
(894, 224, 'quick', 0),
(895, 224, 'quicker', 0),
(896, 224, 'quickly', 1),
(897, 225, 'was', 1),
(898, 225, 'is', 0),
(899, 225, 'has', 0),
(900, 225, 'were', 0),
(901, 226, 'continues', 0),
(902, 226, 'continue', 0),
(903, 226, 'continuing', 0),
(904, 226, 'continued', 1),
(905, 227, 'So', 0),
(906, 227, 'Because', 0),
(907, 227, 'But', 0),
(908, 227, 'If', 1),
(909, 228, 'still', 0),
(910, 228, 'yet', 0),
(911, 228, 'already', 1),
(912, 228, 'never', 0),
(913, 229, 'fluentest', 0),
(914, 229, 'fluent', 0),
(915, 229, 'fluently', 0),
(916, 229, 'more fluently', 1),
(917, 230, 'was', 1),
(918, 230, 'were', 0),
(919, 230, 'has been', 0),
(920, 230, 'is', 0),
(921, 231, 'carefulness', 0),
(922, 231, 'carefully', 1),
(923, 231, 'more careful', 0),
(924, 231, 'careful', 0),
(925, 232, 'will not', 1),
(926, 232, 'did', 0),
(927, 232, 'was', 0),
(928, 232, 'will', 0),
(929, 233, 'will', 1),
(930, 233, 'was', 0),
(931, 233, 'has', 0),
(932, 233, 'would', 0),
(933, 234, 'is', 0),
(934, 234, 'has been', 1),
(935, 234, 'were', 0),
(936, 234, 'was', 0),
(937, 235, 'politest', 0),
(938, 235, 'polite', 0),
(939, 235, 'more politely', 1),
(940, 235, 'politely', 0),
(941, 236, 'is', 0),
(942, 236, 'has', 0),
(943, 236, 'was', 1),
(944, 236, 'were', 0),
(945, 237, 'will', 1),
(946, 237, 'would', 0),
(947, 237, 'was', 0),
(948, 237, 'did', 0),
(949, 238, 'was', 1),
(950, 238, 'were', 0),
(951, 238, 'has', 0),
(952, 238, 'is', 0),
(953, 239, 'harder', 0),
(954, 239, 'hardest', 0),
(955, 239, 'hardly', 0),
(956, 239, 'hard', 1),
(957, 240, 'well', 0),
(958, 240, 'good', 0),
(959, 240, 'best', 1),
(960, 240, 'better', 0),
(961, 241, 'tall', 0),
(962, 241, 'wide', 0),
(963, 241, 'long', 0),
(964, 241, 'small', 1),
(965, 242, 'cheerful', 0),
(966, 242, 'joyful', 0),
(967, 242, 'sad', 1),
(968, 242, 'glad', 0),
(969, 243, 'warm', 0),
(970, 243, 'wet', 0),
(971, 243, 'cold', 1),
(972, 243, 'dry', 0),
(973, 244, 'slow', 1),
(974, 244, 'quick', 0),
(975, 244, 'swift', 0),
(976, 244, 'rapid', 0),
(977, 245, 'calf', 0),
(978, 245, 'puppy', 1),
(979, 245, 'cub', 0),
(980, 245, 'kitten', 0),
(981, 246, 'cub', 0),
(982, 246, 'puppy', 0),
(983, 246, 'kitten', 1),
(984, 246, 'foal', 0),
(985, 247, 'school', 0),
(986, 247, 'hospital', 0),
(987, 247, 'market', 1),
(988, 247, 'temple', 0),
(989, 248, 'driver', 0),
(990, 248, 'doctor', 0),
(991, 248, 'farmer', 0),
(992, 248, 'teacher', 1),
(993, 249, 'doctor', 1),
(994, 249, 'driver', 0),
(995, 249, 'teacher', 0),
(996, 249, 'farmer', 0),
(997, 250, 'wide', 0),
(998, 250, 'close', 1),
(999, 250, 'small', 0),
(1000, 250, 'big', 0),
(1001, 251, 'moon', 0),
(1002, 251, 'sun', 0),
(1003, 251, 'star', 0),
(1004, 251, 'night', 1),
(1005, 252, 'desert', 0),
(1006, 252, 'ocean', 0),
(1007, 252, 'forest', 1),
(1008, 252, 'river', 0),
(1009, 253, 'side', 0),
(1010, 253, 'over', 0),
(1011, 253, 'down', 1),
(1012, 253, 'top', 0),
(1013, 254, 'farm', 0),
(1014, 254, 'school', 1),
(1015, 254, 'hospital', 0),
(1016, 254, 'market', 0),
(1017, 255, 'small', 0),
(1018, 255, 'new', 1),
(1019, 255, 'young', 0),
(1020, 255, 'big', 0),
(1021, 256, 'cub', 0),
(1022, 256, 'puppy', 0),
(1023, 256, 'foal', 0),
(1024, 256, 'calf', 1),
(1025, 257, 'spoon', 0),
(1026, 257, 'comb', 0),
(1027, 257, 'plate', 0),
(1028, 257, 'pencil', 1),
(1029, 258, 'heavy', 0),
(1030, 258, 'light', 0),
(1031, 258, 'big', 0),
(1032, 258, 'empty', 1),
(1033, 259, 'bedroom', 1),
(1034, 259, 'garage', 0),
(1035, 259, 'kitchen', 0),
(1036, 259, 'garden', 0),
(1037, 260, 'shiny', 0),
(1038, 260, 'dirty', 1),
(1039, 260, 'neat', 0),
(1040, 260, 'bright', 0),
(1041, 261, 'sad', 0),
(1042, 261, 'joyful', 1),
(1043, 261, 'tired', 0),
(1044, 261, 'angry', 0),
(1045, 262, 'huge', 1),
(1046, 262, 'small', 0),
(1047, 262, 'tiny', 0),
(1048, 262, 'short', 0),
(1049, 263, 'fast', 1),
(1050, 263, 'calm', 0),
(1051, 263, 'slow', 0),
(1052, 263, 'lazy', 0),
(1053, 264, 'plain', 0),
(1054, 264, 'dull', 0),
(1055, 264, 'pretty', 1),
(1056, 264, 'ugly', 0),
(1057, 265, 'shy', 0),
(1058, 265, 'weak', 0),
(1059, 265, 'clever', 1),
(1060, 265, 'foolish', 0),
(1061, 266, 'bold', 0),
(1062, 266, 'tough', 0),
(1063, 266, 'fearful', 1),
(1064, 266, 'strong', 0),
(1065, 267, 'hard', 0),
(1066, 267, 'easy', 1),
(1067, 267, 'tough', 0),
(1068, 267, 'complex', 0),
(1069, 268, 'noisy', 0),
(1070, 268, 'high', 0),
(1071, 268, 'sharp', 0),
(1072, 268, 'quiet', 1),
(1073, 269, 'bored', 0),
(1074, 269, 'tired', 0),
(1075, 269, 'delighted', 1),
(1076, 269, 'annoyed', 0),
(1077, 270, 'bright', 0),
(1078, 270, 'dirty', 1),
(1079, 270, 'neat', 0),
(1080, 270, 'shiny', 0),
(1081, 271, 'farmer', 0),
(1082, 271, 'pilot', 1),
(1083, 271, 'driver', 0),
(1084, 271, 'sailor', 0),
(1085, 272, 'guard', 0),
(1086, 272, 'cleaner', 0),
(1087, 272, 'waiter', 0),
(1088, 272, 'chef', 1),
(1089, 273, 'lose', 0),
(1090, 273, 'find', 0),
(1091, 273, 'search', 1),
(1092, 273, 'keep', 0),
(1093, 274, 'library', 1),
(1094, 274, 'garden', 0),
(1095, 274, 'garage', 0),
(1096, 274, 'kitchen', 0),
(1097, 275, 'child', 1),
(1098, 275, 'parent', 0),
(1099, 275, 'elder', 0),
(1100, 275, 'adult', 0),
(1101, 276, 'calm', 0),
(1102, 276, 'scared', 1),
(1103, 276, 'brave', 0),
(1104, 276, 'proud', 0),
(1105, 277, 'pond', 0),
(1106, 277, 'lake', 0),
(1107, 277, 'river', 0),
(1108, 277, 'ocean', 1),
(1109, 278, 'family', 0),
(1110, 278, 'market', 0),
(1111, 278, 'forest', 0),
(1112, 278, 'community', 1),
(1113, 279, 'hide', 0),
(1114, 279, 'break', 0),
(1115, 279, 'wash', 1),
(1116, 279, 'throw', 0),
(1117, 280, 'news', 0),
(1118, 280, 'fact', 0),
(1119, 280, 'diary', 0),
(1120, 280, 'fiction', 1),
(1121, 281, 'tired', 0),
(1122, 281, 'upset', 0),
(1123, 281, 'delighted', 1),
(1124, 281, 'bored', 0),
(1125, 282, 'sunny', 0),
(1126, 282, 'stormy', 1),
(1127, 282, 'clear', 0),
(1128, 282, 'calm', 0),
(1129, 283, 'selfish', 0),
(1130, 283, 'generous', 1),
(1131, 283, 'rude', 0),
(1132, 283, 'lazy', 0),
(1133, 284, 'new', 0),
(1134, 284, 'fragile', 1),
(1135, 284, 'wide', 0),
(1136, 284, 'strong', 0),
(1137, 285, 'loudly', 0),
(1138, 285, 'slowly', 0),
(1139, 285, 'quickly', 0),
(1140, 285, 'quietly', 1),
(1141, 286, 'calm', 0),
(1142, 286, 'exhausted', 1),
(1143, 286, 'excited', 0),
(1144, 286, 'curious', 0),
(1145, 287, 'ignore', 0),
(1146, 287, 'confuse', 0),
(1147, 287, 'clarify', 1),
(1148, 287, 'hide', 0),
(1149, 288, 'biologist', 0),
(1150, 288, 'astronomer', 1),
(1151, 288, 'historian', 0),
(1152, 288, 'artist', 0),
(1153, 289, 'ignore', 0),
(1154, 289, 'damage', 0),
(1155, 289, 'waste', 0),
(1156, 289, 'protect', 1),
(1157, 290, 'lazy', 0),
(1158, 290, 'dull', 0),
(1159, 290, 'active', 1),
(1160, 290, 'tired', 0),
(1161, 291, 'rare', 0),
(1162, 291, 'costly', 0),
(1163, 291, 'affordable', 1),
(1164, 291, 'priceless', 0),
(1165, 292, 'curiosity', 1),
(1166, 292, 'fear', 0),
(1167, 292, 'anger', 0),
(1168, 292, 'boredom', 0),
(1169, 293, 'compete', 0),
(1170, 293, 'cooperate', 1),
(1171, 293, 'argue', 0),
(1172, 293, 'ignore', 0),
(1173, 294, 'dishonest', 0),
(1174, 294, 'cruel', 0),
(1175, 294, 'careless', 0),
(1176, 294, 'truthful', 1),
(1177, 295, 'swarm', 0),
(1178, 295, 'pack', 0),
(1179, 295, 'flock', 0),
(1180, 295, 'herd', 1),
(1181, 296, 'herd', 0),
(1182, 296, 'swarm', 0),
(1183, 296, 'flock', 1),
(1184, 296, 'pack', 0),
(1185, 297, 'relax', 0),
(1186, 297, 'grieve', 1),
(1187, 297, 'celebrate', 0),
(1188, 297, 'laugh', 0),
(1189, 298, 'plan', 0),
(1190, 298, 'routine', 0),
(1191, 298, 'accident', 1),
(1192, 298, 'habit', 0),
(1193, 299, 'market', 0),
(1194, 299, 'forest', 0),
(1195, 299, 'farm', 0),
(1196, 299, 'zoo', 1),
(1197, 300, 'pause', 0),
(1198, 300, 'stop', 0),
(1199, 300, 'expand', 1),
(1200, 300, 'shrink', 0),
(1201, 301, 'green', 0),
(1202, 301, 'red', 1),
(1203, 301, 'yellow', 0),
(1204, 301, 'blue', 0),
(1205, 302, 'Tommy', 1),
(1206, 302, 'Rex', 0),
(1207, 302, 'Sita', 0),
(1208, 302, 'Ram', 0),
(1209, 303, 'It is sunny', 0),
(1210, 303, 'It is raining', 1),
(1211, 303, 'It is cold', 0),
(1212, 303, 'It is hot', 0),
(1213, 304, 'Eats breakfast', 0),
(1214, 304, 'Plays outside', 0),
(1215, 304, 'Brushes her teeth', 1),
(1216, 304, 'Goes to school', 0),
(1217, 305, 'Night', 0),
(1218, 305, 'Morning', 0),
(1219, 305, 'Evening', 1),
(1220, 305, 'Noon', 0),
(1221, 306, 'At night', 0),
(1222, 306, 'In the morning', 0),
(1223, 306, 'After lunch', 1),
(1224, 306, 'Before lunch', 0),
(1225, 307, 'In the kitchen', 0),
(1226, 307, 'On his desk', 1),
(1227, 307, 'In his bag', 0),
(1228, 307, 'Under his bed', 0),
(1229, 308, 'Wool', 0),
(1230, 308, 'Meat', 0),
(1231, 308, 'Milk', 1),
(1232, 308, 'Eggs', 0),
(1233, 309, 'Ten o\'clock', 1),
(1234, 309, 'Eight o\'clock', 0),
(1235, 309, 'Nine thirty', 0),
(1236, 309, 'Eleven o\'clock', 0),
(1237, 310, 'In caves', 0),
(1238, 310, 'In water', 0),
(1239, 310, 'On the ground', 0),
(1240, 310, 'In trees', 1),
(1241, 311, 'Blue', 1),
(1242, 311, 'Red', 0),
(1243, 311, 'Green', 0),
(1244, 311, 'Yellow', 0),
(1245, 312, 'Crowded', 0),
(1246, 312, 'Noisy', 0),
(1247, 312, 'Dark', 0),
(1248, 312, 'Quiet', 1),
(1249, 313, 'Helps his mother', 1),
(1250, 313, 'Sleeps', 0),
(1251, 313, 'Watches TV', 0),
(1252, 313, 'Plays football', 0),
(1253, 314, 'In trees', 0),
(1254, 314, 'On land', 0),
(1255, 314, 'In the sky', 0),
(1256, 314, 'In water', 1),
(1257, 315, 'April', 1),
(1258, 315, 'March', 0),
(1259, 315, 'June', 0),
(1260, 315, 'May', 0),
(1261, 316, 'Wheat', 0),
(1262, 316, 'Rice', 1),
(1263, 316, 'Corn', 0),
(1264, 316, 'Tea', 0),
(1265, 317, 'It has toys', 0),
(1266, 317, 'It has many books', 1),
(1267, 317, 'It has food', 0),
(1268, 317, 'It has clothes', 0),
(1269, 318, 'Sandals', 0),
(1270, 318, 'Light clothes', 0),
(1271, 318, 'Warm clothes', 1),
(1272, 318, 'Swimsuits', 0),
(1273, 319, 'Lion', 0),
(1274, 319, 'Horse', 0),
(1275, 319, 'Tiger', 0),
(1276, 319, 'Elephant', 1),
(1277, 320, 'Reads a book', 0),
(1278, 320, 'Plants a tree', 1),
(1279, 320, 'Buys a gift', 0),
(1280, 320, 'Bakes a cake', 0),
(1281, 321, 'Vegetables, fruits, and rice', 1),
(1282, 321, 'Only vegetables', 0),
(1283, 321, 'Toys and books', 0),
(1284, 321, 'Only fruits', 0),
(1285, 322, 'They met a friend', 0),
(1286, 322, 'It became sunny', 0),
(1287, 322, 'They got lost', 0),
(1288, 322, 'It started to rain', 1),
(1289, 323, 'One chapter of a storybook', 1),
(1290, 323, 'A newspaper', 0),
(1291, 323, 'A map', 0),
(1292, 323, 'A letter', 0),
(1293, 324, 'A brave lion', 1),
(1294, 324, 'A fast car', 0),
(1295, 324, 'A small mouse', 0),
(1296, 324, 'A tall tree', 0),
(1297, 325, 'A river', 0),
(1298, 325, 'A lake', 0),
(1299, 325, 'The tallest mountain', 1),
(1300, 325, 'A small hill', 0),
(1301, 326, 'Swim across it', 0),
(1302, 326, 'Reach its top', 1),
(1303, 326, 'Build a house on it', 0),
(1304, 326, 'Plant trees on it', 0),
(1305, 327, 'Hari lent him a pencil', 0),
(1306, 327, 'Hari shared his food', 1),
(1307, 327, 'Hari gave him money', 0),
(1308, 327, 'Hari helped with homework', 0),
(1309, 328, 'School bags', 0),
(1310, 328, 'Tika and dakshina', 1),
(1311, 328, 'Only sweets', 0),
(1312, 328, 'New shoes', 0),
(1313, 329, 'The tortoise', 1),
(1314, 329, 'The rabbit', 0),
(1315, 329, 'Both of them', 0),
(1316, 329, 'Neither of them', 0),
(1317, 330, 'It never stopped walking', 1),
(1318, 330, 'It took a shortcut', 0),
(1319, 330, 'It ran faster', 0),
(1320, 330, 'The rabbit helped it', 0),
(1321, 331, 'Waters the plants', 1),
(1322, 331, 'Feeds the birds', 0),
(1323, 331, 'Paints the fence', 0),
(1324, 331, 'Cuts the grass', 0),
(1325, 332, 'The cities', 0),
(1326, 332, 'The mountains', 1),
(1327, 332, 'The desert', 0),
(1328, 332, 'The ocean', 0),
(1329, 333, 'A volcano model', 1),
(1330, 333, 'A robot', 0),
(1331, 333, 'A painting', 0),
(1332, 333, 'A poem', 0),
(1333, 334, 'Plant trees', 0),
(1334, 334, 'Fly kites', 0),
(1335, 334, 'Cook rice', 0),
(1336, 334, 'Put tika on their brothers', 1),
(1337, 335, 'A pilot', 0),
(1338, 335, 'A singer', 0),
(1339, 335, 'A good football player', 1),
(1340, 335, 'A teacher', 0),
(1341, 336, 'To eat fruit', 0),
(1342, 336, 'To sleep', 0),
(1343, 336, 'To play', 0),
(1344, 336, 'To escape the dog', 1),
(1345, 337, 'Books', 0),
(1346, 337, 'Fruits', 1),
(1347, 337, 'Pencils', 0),
(1348, 337, 'Toys', 0),
(1349, 338, 'The sun shines all day', 0),
(1350, 338, 'The fields get enough water', 1),
(1351, 338, 'It is very cold', 0),
(1352, 338, 'There is no wind', 0),
(1353, 339, 'Under the big tree', 1),
(1354, 339, 'At the market', 0),
(1355, 339, 'In the school', 0),
(1356, 339, 'In his house', 0),
(1357, 340, 'Nothing', 0),
(1358, 340, 'Toys', 0),
(1359, 340, 'Milk and a warm blanket', 1),
(1360, 340, 'Only water', 0),
(1361, 341, 'Bright city lights', 0),
(1362, 341, 'Crowded markets', 0),
(1363, 341, 'Loud traffic noise', 0),
(1364, 341, 'The sound of birds and fresh air', 1),
(1365, 342, 'Peaceful', 1),
(1366, 342, 'Busy', 0),
(1367, 342, 'Dangerous', 0),
(1368, 342, 'Noisy', 0),
(1369, 343, 'By turning on more lights', 0),
(1370, 343, 'By scolding him', 0),
(1371, 343, 'By leaving the room', 0),
(1372, 343, 'By telling him a story', 1),
(1373, 344, 'Sticks are useful', 0),
(1374, 344, 'Sons should listen', 0),
(1375, 344, 'Farming is hard work', 0),
(1376, 344, 'Unity is strength', 1),
(1377, 345, 'Because the sticks were tied together', 1),
(1378, 345, 'Because the sticks were too thick', 0),
(1379, 345, 'Because they were tired', 0),
(1380, 345, 'Because it was dark', 0),
(1381, 346, 'They helped and supported each other', 1),
(1382, 346, 'They left the town', 0),
(1383, 346, 'They argued with each other', 0),
(1384, 346, 'They ignored the damage', 0),
(1385, 347, 'Money', 0),
(1386, 347, 'Luck', 0),
(1387, 347, 'Patience and persistence', 1),
(1388, 347, 'Fear', 0),
(1389, 348, 'The crops were growing too fast', 0),
(1390, 348, 'The river was drying up', 1),
(1391, 348, 'It was raining too much', 0),
(1392, 348, 'The river was flooding', 0),
(1393, 349, 'He is thoughtful and caring', 1),
(1394, 349, 'He is careless', 0),
(1395, 349, 'He is lazy', 0),
(1396, 349, 'He dislikes his mother', 0),
(1397, 350, 'To check on the student', 1),
(1398, 350, 'To give homework', 0),
(1399, 350, 'To clean the classroom', 0),
(1400, 350, 'To punish the student', 0),
(1401, 351, 'The heavy bags', 0),
(1402, 351, 'The cold weather', 0),
(1403, 351, 'The long walk', 0),
(1404, 351, 'The breathtaking view', 1),
(1405, 352, 'The new librarian\'s efforts', 1),
(1406, 352, 'More money', 0),
(1407, 352, 'Fewer books', 0),
(1408, 352, 'A new building', 0),
(1409, 353, 'They actually won', 0),
(1410, 353, 'They played their best and learned lessons', 1),
(1411, 353, 'It was a joke', 0),
(1412, 353, 'The other team gave up', 0),
(1413, 354, 'Sunlight', 0),
(1414, 354, 'Fishermen', 0),
(1415, 354, 'Factories dumping waste', 1),
(1416, 354, 'Heavy rain', 0),
(1417, 355, 'Cooking', 0),
(1418, 355, 'Mathematics', 1),
(1419, 355, 'Painting', 0),
(1420, 355, 'Singing', 0),
(1421, 356, 'Took the bags away', 0),
(1422, 356, 'Called the police', 0),
(1423, 356, 'Helped the old man cross the street', 1),
(1424, 356, 'Ignored the old man', 0),
(1425, 357, 'They enjoyed her singing', 1),
(1426, 357, 'They laughed at her', 0),
(1427, 357, 'They were bored', 0),
(1428, 357, 'They left the room', 0),
(1429, 358, 'To make the fields look nice', 0),
(1430, 358, 'To grow taller crops', 0),
(1431, 358, 'To prevent soil from washing away', 1),
(1432, 358, 'To attract tourists', 0),
(1433, 359, 'Seeing tall buildings', 0),
(1434, 359, 'Hearing her native language', 1),
(1435, 359, 'Eating familiar food', 0),
(1436, 359, 'Meeting new people', 0),
(1437, 360, 'Rocks are strong', 0),
(1438, 360, 'Difficult beginnings can lead to great strength', 1),
(1439, 360, 'Seeds need water', 0),
(1440, 360, 'Trees grow fast', 0);

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
  `question_type` enum('multiple_choice','true_false','puzzle') DEFAULT 'multiple_choice',
  `difficulty_tier` int(11) NOT NULL DEFAULT 1,
  `target_age_min` int(11) DEFAULT 3,
  `target_age_max` int(11) DEFAULT 12
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_questions`
--

INSERT INTO `quiz_questions` (`question_id`, `game_id`, `course_id`, `question_text`, `topic`, `question_type`, `difficulty_tier`, `target_age_min`, `target_age_max`) VALUES
(181, 1, 1, 'She ___ a doctor.', 'grammar', 'multiple_choice', 1, 8, 9),
(182, 1, 1, 'I ___ nine years old.', 'grammar', 'multiple_choice', 1, 8, 9),
(183, 1, 1, 'They ___ playing in the garden.', 'grammar', 'multiple_choice', 1, 8, 9),
(184, 1, 1, 'We ___ students.', 'grammar', 'multiple_choice', 1, 8, 9),
(185, 1, 1, 'One book, two ___.', 'grammar', 'multiple_choice', 1, 8, 9),
(186, 1, 1, 'One box, two ___.', 'grammar', 'multiple_choice', 1, 8, 9),
(187, 1, 1, 'The cat is ___ the box.', 'grammar', 'multiple_choice', 1, 8, 9),
(188, 1, 1, 'My pencil is ___ the table.', 'grammar', 'multiple_choice', 1, 8, 9),
(189, 1, 1, 'He ___ to school every day.', 'grammar', 'multiple_choice', 1, 8, 9),
(190, 1, 1, 'I ___ my homework yesterday.', 'grammar', 'multiple_choice', 1, 8, 9),
(191, 1, 1, 'This is ___ apple.', 'grammar', 'multiple_choice', 1, 8, 9),
(192, 1, 1, 'That is ___ dog.', 'grammar', 'multiple_choice', 1, 8, 9),
(193, 1, 1, '___ you like tea?', 'grammar', 'multiple_choice', 1, 8, 9),
(194, 1, 1, 'My sister ___ like milk.', 'grammar', 'multiple_choice', 1, 8, 9),
(195, 1, 1, 'I ___ my brother yesterday.', 'grammar', 'multiple_choice', 1, 8, 9),
(196, 1, 1, 'Look! The birds ___ flying.', 'grammar', 'multiple_choice', 1, 8, 9),
(197, 1, 1, 'There ___ five mangoes in the basket.', 'grammar', 'multiple_choice', 1, 8, 9),
(198, 1, 1, 'She has ___ umbrella.', 'grammar', 'multiple_choice', 1, 8, 9),
(199, 1, 1, 'We ___ go to school on Saturday.', 'grammar', 'multiple_choice', 1, 8, 9),
(200, 1, 1, 'My father ___ a farmer.', 'grammar', 'multiple_choice', 1, 8, 9),
(201, 1, 1, 'Yesterday, I ___ to the market.', 'grammar', 'multiple_choice', 2, 8, 9),
(202, 1, 1, 'She ___ her lunch already.', 'grammar', 'multiple_choice', 2, 8, 9),
(203, 1, 1, 'This mountain is ___ than that hill.', 'grammar', 'multiple_choice', 2, 8, 9),
(204, 1, 1, 'Everest is the ___ mountain in the world.', 'grammar', 'multiple_choice', 2, 8, 9),
(205, 1, 1, 'I like tea ___ my brother likes coffee.', 'grammar', 'multiple_choice', 2, 8, 9),
(206, 1, 1, 'I stayed home ___ it was raining.', 'grammar', 'multiple_choice', 2, 8, 9),
(207, 1, 1, '___ is your name?', 'grammar', 'multiple_choice', 2, 8, 9),
(208, 1, 1, '___ do you live?', 'grammar', 'multiple_choice', 2, 8, 9),
(209, 1, 1, 'He was ___ than his friend in the race.', 'grammar', 'multiple_choice', 2, 8, 9),
(210, 1, 1, 'We ___ watching TV when the light went off.', 'grammar', 'multiple_choice', 2, 8, 9),
(211, 1, 1, 'My mother ___ cooking dinner right now.', 'grammar', 'multiple_choice', 2, 8, 9),
(212, 1, 1, 'He can ___ very fast.', 'grammar', 'multiple_choice', 2, 8, 9),
(213, 1, 1, 'She ___ not finished her work yet.', 'grammar', 'multiple_choice', 2, 8, 9),
(214, 1, 1, 'They ___ going to Pokhara next week.', 'grammar', 'multiple_choice', 2, 8, 9),
(215, 1, 1, 'I have two brothers ___ one sister.', 'grammar', 'multiple_choice', 2, 8, 9),
(216, 1, 1, 'This bag is ___ than that one.', 'grammar', 'multiple_choice', 2, 8, 9),
(217, 1, 1, '___ did you go yesterday?', 'grammar', 'multiple_choice', 2, 8, 9),
(218, 1, 1, 'She sings ___ than her friend.', 'grammar', 'multiple_choice', 2, 8, 9),
(219, 1, 1, 'We ___ our homework before dinner.', 'grammar', 'multiple_choice', 2, 8, 9),
(220, 1, 1, 'He ___ never late for school.', 'grammar', 'multiple_choice', 2, 8, 9),
(221, 1, 1, 'Tomorrow, I ___ visit my grandmother.', 'grammar', 'multiple_choice', 3, 8, 9),
(222, 1, 1, 'She ___ finish her project by tomorrow.', 'grammar', 'multiple_choice', 3, 8, 9),
(223, 1, 1, 'If it rains, we ___ stay inside.', 'grammar', 'multiple_choice', 3, 8, 9),
(224, 1, 1, 'He walked ___ so he wouldn\'t be late.', 'grammar', 'multiple_choice', 3, 8, 9),
(225, 1, 1, 'The letter ___ written by my sister.', 'grammar', 'multiple_choice', 3, 8, 9),
(226, 1, 1, 'Although it was late, she ___ studying.', 'grammar', 'multiple_choice', 3, 8, 9),
(227, 1, 1, '___ you finish your homework, you can play.', 'grammar', 'multiple_choice', 3, 8, 9),
(228, 1, 1, 'My father has ___ finished his work.', 'grammar', 'multiple_choice', 3, 8, 9),
(229, 1, 1, 'She speaks English ___ than her brother.', 'grammar', 'multiple_choice', 3, 8, 9),
(230, 1, 1, 'The cake ___ eaten by the children.', 'grammar', 'multiple_choice', 3, 8, 9),
(231, 1, 1, 'He runs ___ every morning.', 'grammar', 'multiple_choice', 3, 8, 9),
(232, 1, 1, 'Unless you study, you ___ pass the test.', 'grammar', 'multiple_choice', 3, 8, 9),
(233, 1, 1, 'By next year, she ___ learn to swim.', 'grammar', 'multiple_choice', 3, 8, 9),
(234, 1, 1, 'The book ___ on the table since morning.', 'grammar', 'multiple_choice', 3, 8, 9),
(235, 1, 1, 'He behaves ___ than his younger brother.', 'grammar', 'multiple_choice', 3, 8, 9),
(236, 1, 1, 'While she ___ cooking, the phone rang.', 'grammar', 'multiple_choice', 3, 8, 9),
(237, 1, 1, 'As soon as he arrives, we ___ start.', 'grammar', 'multiple_choice', 3, 8, 9),
(238, 1, 1, 'The window ___ broken by the storm.', 'grammar', 'multiple_choice', 3, 8, 9),
(239, 1, 1, 'She works ___ to achieve her goals.', 'grammar', 'multiple_choice', 3, 8, 9),
(240, 1, 1, 'He is the ___ student in the class.', 'grammar', 'multiple_choice', 3, 8, 9),
(241, 1, 1, 'Opposite of \"big\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(242, 1, 1, 'Opposite of \"happy\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(243, 1, 1, 'Opposite of \"hot\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(244, 1, 1, 'Opposite of \"fast\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(245, 1, 1, 'A baby dog is called a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(246, 1, 1, 'A baby cat is called a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(247, 1, 1, 'A place where we buy vegetables is a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(248, 1, 1, 'A person who teaches students is a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(249, 1, 1, 'A person who treats sick people is a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(250, 1, 1, 'Opposite of \"open\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(251, 1, 1, 'Opposite of \"day\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(252, 1, 1, 'A group of many trees is a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(253, 1, 1, 'Opposite of \"up\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(254, 1, 1, 'A place where children study is a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(255, 1, 1, 'Opposite of \"old\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(256, 1, 1, 'A baby cow is called a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(257, 1, 1, 'Something we use to write is a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(258, 1, 1, 'Opposite of \"full\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(259, 1, 1, 'A place where we sleep is a ___.', 'vocabulary', 'multiple_choice', 1, 8, 9),
(260, 1, 1, 'Opposite of \"clean\"', 'vocabulary', 'multiple_choice', 1, 8, 9),
(261, 1, 1, 'Synonym of \"happy\"', 'vocabulary', 'multiple_choice', 2, 8, 9),
(262, 1, 1, 'Synonym of \"big\"', 'vocabulary', 'multiple_choice', 2, 8, 9),
(263, 1, 1, 'Synonym of \"quick\"', 'vocabulary', 'multiple_choice', 2, 8, 9),
(264, 1, 1, 'Synonym of \"beautiful\"', 'vocabulary', 'multiple_choice', 2, 8, 9),
(265, 1, 1, 'Synonym of \"smart\"', 'vocabulary', 'multiple_choice', 2, 8, 9),
(266, 1, 1, 'Antonym of \"brave\"', 'vocabulary', 'multiple_choice', 2, 8, 9),
(267, 1, 1, 'Antonym of \"difficult\"', 'vocabulary', 'multiple_choice', 2, 8, 9),
(268, 1, 1, 'Antonym of \"loud\"', 'vocabulary', 'multiple_choice', 2, 8, 9),
(269, 1, 1, 'Which word means \"very happy\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(270, 1, 1, 'Which word means \"not clean\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(271, 1, 1, 'A person who flies airplanes is a ___.', 'vocabulary', 'multiple_choice', 2, 8, 9),
(272, 1, 1, 'A person who cooks food in a restaurant is a ___.', 'vocabulary', 'multiple_choice', 2, 8, 9),
(273, 1, 1, 'Which word means \"to look for\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(274, 1, 1, 'Which word means \"a place to keep books\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(275, 1, 1, 'Which word means \"a young human\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(276, 1, 1, 'Which word means \"afraid\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(277, 1, 1, 'Which word means \"a large body of salt water\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(278, 1, 1, 'Which word means \"many people living together in a place\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(279, 1, 1, 'Which word means \"to make something clean\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(280, 1, 1, 'Which word means \"a story that is not true\"?', 'vocabulary', 'multiple_choice', 2, 8, 9),
(281, 1, 1, 'She felt ___ after winning the race.', 'vocabulary', 'multiple_choice', 3, 8, 9),
(282, 1, 1, 'The weather was ___, so we stayed indoors.', 'vocabulary', 'multiple_choice', 3, 8, 9),
(283, 1, 1, 'He is very ___; he always helps others.', 'vocabulary', 'multiple_choice', 3, 8, 9),
(284, 1, 1, 'The old bridge was ___ and dangerous to cross.', 'vocabulary', 'multiple_choice', 3, 8, 9),
(285, 1, 1, 'She whispered ___ so no one could hear.', 'vocabulary', 'multiple_choice', 3, 8, 9),
(286, 1, 1, 'Which word means \"extremely tired\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(287, 1, 1, 'Which word means \"to explain something clearly\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(288, 1, 1, 'Which word means \"a person who studies stars\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(289, 1, 1, 'Which word means \"to keep something safe\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(290, 1, 1, 'Which word means \"full of energy\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(291, 1, 1, 'Which word means \"not expensive\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(292, 1, 1, 'Which word means \"a strong wish to know something\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(293, 1, 1, 'Which word means \"to work together\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(294, 1, 1, 'Which word means \"honest and fair\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(295, 1, 1, 'A large group of cows is called a ___.', 'vocabulary', 'multiple_choice', 3, 8, 9),
(296, 1, 1, 'A large group of birds is called a ___.', 'vocabulary', 'multiple_choice', 3, 8, 9),
(297, 1, 1, 'Which word means \"to feel very sad\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(298, 1, 1, 'Which word means \"something that happens by chance\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(299, 1, 1, 'Which word means \"a place where animals are kept for people to see\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(300, 1, 1, 'Which word means \"to grow bigger over time\"?', 'vocabulary', 'multiple_choice', 3, 8, 9),
(301, 1, 1, 'Ram has a red ball. He plays with it every day. What color is Ram\'s ball?', 'reading', 'multiple_choice', 1, 8, 9),
(302, 1, 1, 'Sita has a pet dog named Tommy. Tommy likes to run in the garden. What is the name of Sita\'s dog?', 'reading', 'multiple_choice', 1, 8, 9),
(303, 1, 1, 'It is raining outside. Hari takes his umbrella to school. Why does Hari take an umbrella?', 'reading', 'multiple_choice', 1, 8, 9),
(304, 1, 1, 'Maya wakes up at six in the morning. She brushes her teeth first. What does Maya do first after waking up?', 'reading', 'multiple_choice', 1, 8, 9),
(305, 1, 1, 'The sun rises in the morning and sets in the evening. When does the sun set?', 'reading', 'multiple_choice', 1, 8, 9),
(306, 1, 1, 'Gita likes apples. She eats one every day after lunch. When does Gita eat an apple?', 'reading', 'multiple_choice', 1, 8, 9),
(307, 1, 1, 'Raju has three books. He keeps them on his desk. Where does Raju keep his books?', 'reading', 'multiple_choice', 1, 8, 9),
(308, 1, 1, 'The cow gives us milk. We drink milk every morning. What does the cow give us?', 'reading', 'multiple_choice', 1, 8, 9),
(309, 1, 1, 'Anita\'s school starts at ten o\'clock. She leaves home at nine thirty. What time does Anita\'s school start?', 'reading', 'multiple_choice', 1, 8, 9),
(310, 1, 1, 'Birds build nests in trees. They lay eggs in their nests. Where do birds build nests?', 'reading', 'multiple_choice', 1, 8, 9),
(311, 1, 1, 'Suman likes to draw pictures. His favorite color is blue. What is Suman\'s favorite color?', 'reading', 'multiple_choice', 1, 8, 9),
(312, 1, 1, 'The library is a quiet place. People read books there. What kind of place is the library?', 'reading', 'multiple_choice', 1, 8, 9),
(313, 1, 1, 'Krishna helps his mother in the kitchen every evening. What does Krishna do every evening?', 'reading', 'multiple_choice', 1, 8, 9),
(314, 1, 1, 'Fish live in water. They cannot live on land. Where do fish live?', 'reading', 'multiple_choice', 1, 8, 9),
(315, 1, 1, 'Priya\'s birthday is in April. She will turn nine years old. In which month is Priya\'s birthday?', 'reading', 'multiple_choice', 1, 8, 9),
(316, 1, 1, 'The farmer grows rice in his field. He works hard every day. What does the farmer grow?', 'reading', 'multiple_choice', 1, 8, 9),
(317, 1, 1, 'Deepak\'s school bag is heavy because he carries many books. Why is Deepak\'s bag heavy?', 'reading', 'multiple_choice', 1, 8, 9),
(318, 1, 1, 'It is cold in winter. People wear warm clothes. What do people wear in winter?', 'reading', 'multiple_choice', 1, 8, 9),
(319, 1, 1, 'The elephant is the largest land animal. It has a long trunk. What is the largest land animal?', 'reading', 'multiple_choice', 1, 8, 9),
(320, 1, 1, 'Nabin plants a tree every year on his birthday. What does Nabin do every year?', 'reading', 'multiple_choice', 1, 8, 9),
(321, 1, 1, 'Ravi went to the market with his mother. They bought vegetables, fruits, and rice. On their way home, it started to rain. What did Ravi and his mother buy?', 'reading', 'multiple_choice', 2, 8, 9),
(322, 1, 1, 'Ravi went to the market with his mother. They bought vegetables, fruits, and rice. On their way home, it started to rain. What happened on their way home?', 'reading', 'multiple_choice', 2, 8, 9),
(323, 1, 1, 'Sunita loves reading storybooks. Every night before bed, she reads one chapter. Last night, she read about a brave lion. What does Sunita read every night?', 'reading', 'multiple_choice', 2, 8, 9),
(324, 1, 1, 'Sunita loves reading storybooks. Every night before bed, she reads one chapter. Last night, she read about a brave lion. What was last night\'s story about?', 'reading', 'multiple_choice', 2, 8, 9),
(325, 1, 1, 'The Himalayas are very tall mountains. Mount Everest is the tallest of them all. Many climbers try to reach its top every year. What is Mount Everest?', 'reading', 'multiple_choice', 2, 8, 9),
(326, 1, 1, 'The Himalayas are very tall mountains. Mount Everest is the tallest of them all. Many climbers try to reach its top every year. What do many climbers try to do?', 'reading', 'multiple_choice', 2, 8, 9),
(327, 1, 1, 'Bishnu forgot his lunch box at home. His friend Hari shared his food with him. Bishnu thanked Hari for his kindness. Why did Bishnu thank Hari?', 'reading', 'multiple_choice', 2, 8, 9),
(328, 1, 1, 'During Dashain, families gather together and receive tika and blessings from elders. Children also get money called dakshina. What do children receive during Dashain?', 'reading', 'multiple_choice', 2, 8, 9),
(329, 1, 1, 'The rabbit and the tortoise had a race. The rabbit ran fast but stopped to rest. The tortoise walked slowly but never stopped and won the race. Who won the race?', 'reading', 'multiple_choice', 2, 8, 9),
(330, 1, 1, 'The rabbit and the tortoise had a race. The rabbit ran fast but stopped to rest. The tortoise walked slowly but never stopped and won the race. Why did the tortoise win?', 'reading', 'multiple_choice', 2, 8, 9),
(331, 1, 1, 'Asha waters the plants in her garden every morning. She also removes the weeds. Her garden is full of colorful flowers. What does Asha do every morning?', 'reading', 'multiple_choice', 2, 8, 9),
(332, 1, 1, 'Nepal has many rivers, including the Koshi, Gandaki, and Karnali. These rivers flow from the mountains to the plains. Where do Nepal\'s rivers flow from?', 'reading', 'multiple_choice', 2, 8, 9),
(333, 1, 1, 'Sarita\'s favorite subject is science. She likes doing experiments in class. Yesterday, she made a small volcano model. What did Sarita make yesterday?', 'reading', 'multiple_choice', 2, 8, 9),
(334, 1, 1, 'The Tihar festival includes worshipping crows, dogs, and cows on different days. Sisters also put tika on their brothers. What do sisters do during Tihar?', 'reading', 'multiple_choice', 2, 8, 9),
(335, 1, 1, 'Rohan practices football every evening after school. He wants to become a good player one day. What does Rohan want to become?', 'reading', 'multiple_choice', 2, 8, 9),
(336, 1, 1, 'The monkey climbed the tree quickly to escape the dog. It sat on a branch and watched from above. Why did the monkey climb the tree?', 'reading', 'multiple_choice', 2, 8, 9),
(337, 1, 1, 'Manisha\'s mother packs her a healthy lunch every day, including fruits and vegetables. Manisha shares her fruits with her friends. What does Manisha share with her friends?', 'reading', 'multiple_choice', 2, 8, 9),
(338, 1, 1, 'During the monsoon season, it rains heavily in Nepal. Farmers plant rice during this season because the fields get enough water. Why do farmers plant rice during monsoon?', 'reading', 'multiple_choice', 2, 8, 9),
(339, 1, 1, 'The old man in the village tells stories to children every evening under the big tree. The children love listening to his tales. Where does the old man tell stories?', 'reading', 'multiple_choice', 2, 8, 9),
(340, 1, 1, 'Sujata found a lost kitten near her house. She fed it milk and gave it a warm blanket. The kitten\'s owner found it the next day. What did Sujata give the kitten?', 'reading', 'multiple_choice', 2, 8, 9),
(341, 1, 1, 'The little village was surrounded by tall green hills. Every morning, the villagers woke up to the sound of birds chirping and the smell of fresh air. Life there was peaceful and simple. What made the mornings special in the village?', 'reading', 'multiple_choice', 3, 8, 9),
(342, 1, 1, 'The little village was surrounded by tall green hills. Every morning, the villagers woke up to the sound of birds chirping and the smell of fresh air. Life there was peaceful and simple. What word best describes life in the village?', 'reading', 'multiple_choice', 3, 8, 9),
(343, 1, 1, 'Anil had always been afraid of the dark, but one night the electricity went out during a storm. His father lit a candle and told him a story until the lights came back. How did Anil\'s father help him?', 'reading', 'multiple_choice', 3, 8, 9),
(344, 1, 1, 'Long ago, a wise farmer taught his sons that unity was strength. He gave each son a single stick to break, which they did easily. Then he gave them a bundle of sticks tied together, which none of them could break. What lesson did the farmer teach?', 'reading', 'multiple_choice', 3, 8, 9),
(345, 1, 1, 'Long ago, a wise farmer taught his sons that unity was strength. He gave each son a single stick to break, which they did easily. Then he gave them a bundle of sticks tied together, which none of them could break. Why couldn\'t the sons break the bundle of sticks?', 'reading', 'multiple_choice', 3, 8, 9),
(346, 1, 1, 'During the earthquake, many buildings in the town were damaged, but the community came together to rebuild homes and support each other. What does this passage show about the community?', 'reading', 'multiple_choice', 3, 8, 9),
(347, 1, 1, 'The scientist worked for years trying to find a cure. Even after many failed experiments, she never gave up, believing that success comes to those who are patient and persistent. What quality helped the scientist keep going?', 'reading', 'multiple_choice', 3, 8, 9),
(348, 1, 1, 'As the drought continued, the river slowly dried up, and the farmers worried about their crops. They prayed for rain every day. Why were the farmers worried?', 'reading', 'multiple_choice', 3, 8, 9),
(349, 1, 1, 'The young boy saved his pocket money for months to buy a gift for his mother\'s birthday. When he finally gave it to her, she was moved to tears with joy. What can we infer about the boy?', 'reading', 'multiple_choice', 3, 8, 9),
(350, 1, 1, 'The teacher noticed that one student was quieter than usual and stayed back after class to talk to her. The student explained that she was worried about her sick grandmother. Why did the teacher stay back?', 'reading', 'multiple_choice', 3, 8, 9),
(351, 1, 1, 'Even though the trekkers were exhausted after climbing for hours, the breathtaking view from the top made all their effort worthwhile. What made the effort worthwhile for the trekkers?', 'reading', 'multiple_choice', 3, 8, 9),
(352, 1, 1, 'The old library was full of dusty books that no one had read in years, until a new librarian organized everything and invited children to visit. Soon, the library became a lively place full of readers. What changed the library?', 'reading', 'multiple_choice', 3, 8, 9),
(353, 1, 1, 'Despite losing the match, the team celebrated because they had played their best and learned valuable lessons for the future. Why did the team celebrate even after losing?', 'reading', 'multiple_choice', 3, 8, 9),
(354, 1, 1, 'The river that once flowed clean and clear became polluted after factories began dumping waste into it, harming the fish and plants nearby. What caused the river to become polluted?', 'reading', 'multiple_choice', 3, 8, 9),
(355, 1, 1, 'Even though Meena was the youngest in her family, she often helped her elder siblings with their studies because she was very good at mathematics. What is Meena good at?', 'reading', 'multiple_choice', 3, 8, 9),
(356, 1, 1, 'The kind stranger noticed the old man struggling to carry his heavy bags and offered to help him cross the busy street safely. What did the stranger do?', 'reading', 'multiple_choice', 3, 8, 9),
(357, 1, 1, 'After weeks of practice, the shy student finally gathered the courage to sing in front of the whole school, and everyone clapped loudly for her. What can we infer about the audience\'s reaction?', 'reading', 'multiple_choice', 3, 8, 9),
(358, 1, 1, 'The farmers in the hilly region terraced their fields to prevent soil from washing away during heavy rains. Why did farmers terrace their fields?', 'reading', 'multiple_choice', 3, 8, 9),
(359, 1, 1, 'Even in a foreign country, the traveler felt at home whenever she heard someone speaking her native language. What made the traveler feel at home?', 'reading', 'multiple_choice', 3, 8, 9),
(360, 1, 1, 'The little seed that fell between the rocks grew into a strong tree over many years, showing that even difficult beginnings can lead to great strength. What does the story of the seed teach us?', 'reading', 'multiple_choice', 3, 8, 9);

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `score_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `game_id` int(11) DEFAULT NULL,
  `difficulty_tier_played` int(11) NOT NULL DEFAULT 1,
  `score_value` int(11) NOT NULL DEFAULT 0,
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
-- Structure for view `progress_dashboard`
--
DROP TABLE IF EXISTS `progress_dashboard`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `progress_dashboard`  AS SELECT `c`.`child_id` AS `child_id`, `c`.`username` AS `child_name`, `c`.`age` AS `child_age`, `p`.`parent_id` AS `parent_id`, `p`.`full_name` AS `parent_name`, `c`.`total_coins` AS `total_coins`, `c`.`current_level` AS `current_level`, count(distinct `cb`.`badge_id`) AS `badges_earned`, coalesce(avg(`cp`.`course_score`),0) AS `average_course_score`, count(distinct case when `cp`.`status` = 'completed' then `cp`.`course_id` end) AS `courses_completed`, coalesce((select sum(`ps`.`coins_spent`) from `purchases` `ps` where `ps`.`child_id` = `c`.`child_id`),0) AS `total_coins_spent` FROM (((`children` `c` join `parents` `p` on(`c`.`parent_id` = `p`.`parent_id`)) left join `child_badges` `cb` on(`c`.`child_id` = `cb`.`child_id`)) left join `child_progress` `cp` on(`c`.`child_id` = `cp`.`child_id`)) GROUP BY `c`.`child_id`, `p`.`parent_id` ;

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
  MODIFY `badge_id` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `option_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1441;

--
-- AUTO_INCREMENT for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=361;

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
