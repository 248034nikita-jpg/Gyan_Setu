-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 12, 2026 at 10:59 AM
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

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`admin_id`, `username`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'admin', 'admin@gmail.com', '$2y$10$QX45fyhO7qRk/Nqrc4qyiuNc2ZWT9MdD5BFZD/aCX3LBvvdw57sv6', 'super_admin', '2026-08-01 08:02:05');

-- --------------------------------------------------------

--
-- Table structure for table `alphabet_adventure_levels`
--

CREATE TABLE `alphabet_adventure_levels` (
  `id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `level_index` int(11) NOT NULL,
  `level_letter` varchar(2) NOT NULL,
  `is_completed` tinyint(1) NOT NULL DEFAULT 1,
  `bonus_coins_awarded` int(11) NOT NULL DEFAULT 50,
  `completed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `alphabet_adventure_progress`
--

CREATE TABLE `alphabet_adventure_progress` (
  `progress_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `level_letter` varchar(2) NOT NULL,
  `word_index` int(11) NOT NULL,
  `word` varchar(50) NOT NULL,
  `stars` int(11) NOT NULL DEFAULT 3,
  `mistakes` int(11) NOT NULL DEFAULT 0,
  `completed` tinyint(1) NOT NULL DEFAULT 1,
  `completed_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alphabet_adventure_progress`
--

INSERT INTO `alphabet_adventure_progress` (`progress_id`, `child_id`, `level_letter`, `word_index`, `word`, `stars`, `mistakes`, `completed`, `completed_at`) VALUES
(1, 9, 'A', 0, 'APPLE', 3, 0, 1, '2026-09-10 07:44:57'),
(2, 9, 'A', 1, 'ANT', 3, 0, 1, '2026-09-10 07:45:09'),
(3, 9, 'A', 2, 'AIRPLANE', 3, 0, 1, '2026-09-12 08:18:24'),
(4, 27, 'A', 0, 'APPLE', 3, 0, 1, '2026-09-12 08:48:12');

-- --------------------------------------------------------

--
-- Table structure for table `alphabet_adventure_settings`
--

CREATE TABLE `alphabet_adventure_settings` (
  `child_id` int(11) NOT NULL,
  `sound_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `last_played_level` int(11) NOT NULL DEFAULT 0,
  `last_played_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
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
  `coins_reward` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `badges`
--

INSERT INTO `badges` (`badge_id`, `title`, `description`, `icon_url`, `coins_reward`, `is_active`, `created_at`) VALUES
(1, 'First Steps', 'Complete your first round of any topic.', NULL, 5, 1, '2026-09-09 09:35:01'),
(2, 'Grammar Starter', 'Finish the is / am / are round.', NULL, 5, 1, '2026-09-09 09:35:01'),
(3, 'Word Explorer', 'Finish the opposites round.', NULL, 5, 1, '2026-09-09 09:35:01'),
(4, 'Grammar Master', 'Complete all 3 grammar tiers.', NULL, 15, 1, '2026-09-09 09:35:01'),
(5, 'Vocabulary Master', 'Complete all 3 vocabulary tiers.', NULL, 15, 1, '2026-09-09 09:35:01'),
(6, 'English Champion', 'Complete all 6 rounds across both grammar and vocabulary.', NULL, 25, 1, '2026-09-09 09:35:01'),
(7, 'Perfect Score', 'Get 10 out of 10 correct in any single round.', NULL, 10, 1, '2026-09-09 09:35:01'),
(8, 'Sharp Shooter', 'Answer 5 questions correctly in a row without a miss.', NULL, 10, 1, '2026-09-09 09:35:01'),
(9, 'Hard Mode Hero', 'Score 90% or higher on any Hard-tier round.', NULL, 15, 1, '2026-09-09 09:35:01'),
(10, 'Weekly Whacker', 'Play at least once every day for 7 days in a row.', NULL, 20, 1, '2026-09-09 09:35:01'),
(11, 'First Steps', 'Collect your first orange!', '🦶', 10, 1, '2026-08-09 07:04:11'),
(12, 'Thinker', 'Get your first THINK question correct!', '🤔', 15, 1, '2026-08-09 07:04:11'),
(13, 'Solver', 'Get your first APPLY question correct!', '✅', 15, 1, '2026-08-09 07:04:11'),
(14, 'Level Explorer', 'Complete your first level!', '🗺️', 25, 1, '2026-08-09 07:04:11'),
(15, 'Knowledge Seeker', 'Get 10 questions correct!', '📚', 40, 1, '2026-08-09 07:04:11'),
(16, 'Mountain Climber', 'Complete 3 levels!', '⛰️', 50, 1, '2026-08-09 07:04:11'),
(17, 'Perfect Score', 'Get 100% correct in a single level!', '⭐', 50, 1, '2026-08-09 07:04:11'),
(18, 'Streak Master', 'Get 5 correct answers in a row!', '🔥', 30, 1, '2026-08-09 07:04:11'),
(19, 'Coin Collector', 'Earn 100 total coins!', '🪙', 30, 1, '2026-08-09 07:04:11'),
(20, 'Nepal Explorer', 'Complete all 9 levels!', '🇳🇵', 100, 1, '2026-08-09 07:04:11');

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
(7, 7, 2, NULL, '', '', NULL, 10),
(8, 8, 3, NULL, '', '', NULL, 5),
(9, 9, 4, NULL, '', '', 3, 90),
(10, 10, 7, NULL, '', '', NULL, 7),
(11, 11, 8, 2, '', '', NULL, 1),
(12, 12, 4, 2, '', '', NULL, 1),
(13, 13, 4, 2, '', '', NULL, 1),
(14, 14, 1, 2, '', '', NULL, 1),
(15, 15, 4, 2, '', '', NULL, 10),
(16, 16, 1, 2, '', '', NULL, 3),
(17, 17, 2, 2, '', '', NULL, 1),
(18, 18, 3, 2, '', '', NULL, 5),
(19, 19, 9, NULL, '', '', NULL, 100),
(20, 20, 1, 2, '', '', NULL, 9);

-- --------------------------------------------------------

--
-- Table structure for table `badge_criteria_types`
--

CREATE TABLE `badge_criteria_types` (
  `type_id` int(11) NOT NULL,
  `type_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `badge_criteria_types`
--

INSERT INTO `badge_criteria_types` (`type_id`, `type_name`, `description`, `created_at`) VALUES
(1, 'rounds_completed', 'Number of rounds/levels completed', '2026-08-09 07:01:12'),
(2, 'perfect_score', 'Achieved 100% correct in a round', '2026-08-09 07:01:12'),
(3, 'streak', 'Consecutive correct answers', '2026-08-09 07:01:12'),
(4, 'accuracy_threshold', 'Number of correct answers', '2026-08-09 07:01:12'),
(5, 'topic_all_tiers', 'Mastered all facts in a topic', '2026-08-09 07:01:12'),
(6, 'game_all_rounds', 'Completed all rounds in a game', '2026-08-09 07:01:12'),
(7, 'daily_streak', 'Consecutive days played', '2026-08-09 07:01:12'),
(8, 'oranges_collected', 'Number of oranges collected', '2026-08-09 07:01:12'),
(9, 'total_coins', 'Total coins earned', '2026-08-09 07:01:12');

-- --------------------------------------------------------

--
-- Table structure for table `capybara_child_progress`
--

CREATE TABLE `capybara_child_progress` (
  `child_id` int(11) NOT NULL,
  `content_id` int(11) NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `correct_attempts` int(11) NOT NULL DEFAULT 0,
  `last_seen_level` int(11) DEFAULT NULL,
  `next_review_level` int(11) DEFAULT NULL,
  `last_attempt_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `capybara_child_progress`
--

INSERT INTO `capybara_child_progress` (`child_id`, `content_id`, `attempts`, `correct_attempts`, `last_seen_level`, `next_review_level`, `last_attempt_at`, `updated_at`) VALUES
(1, 1, 63, 58, 1, 5, '2026-09-12 08:44:18', '2026-09-12 08:44:18'),
(1, 2, 18, 9, 1, 3, '2026-09-12 08:44:33', '2026-09-12 08:44:33'),
(1, 3, 16, 9, 1, 3, '2026-09-12 08:44:42', '2026-09-12 08:44:42'),
(1, 4, 2, 1, 2, 4, '2026-09-09 15:05:50', '2026-09-09 15:05:50'),
(1, 5, 2, 2, 2, 6, '2026-09-09 15:06:11', '2026-09-09 15:06:11'),
(1, 6, 2, 2, 2, 6, '2026-09-09 15:06:23', '2026-09-09 15:06:23'),
(1, 19, 2, 0, 7, 9, '2026-08-12 07:24:21', '2026-08-12 07:24:21'),
(1, 20, 2, 0, 7, 9, '2026-08-12 07:24:33', '2026-08-12 07:24:33'),
(1, 22, 2, 1, 8, 12, '2026-08-12 07:25:19', '2026-08-12 07:25:19'),
(1, 23, 2, 1, 8, 12, '2026-08-12 07:25:46', '2026-08-12 07:25:46'),
(1, 24, 2, 0, 8, 10, '2026-08-12 07:26:03', '2026-08-12 07:26:03');

-- --------------------------------------------------------

--
-- Table structure for table `capybara_learning_content`
--

CREATE TABLE `capybara_learning_content` (
  `content_id` int(11) NOT NULL,
  `level_number` int(11) NOT NULL,
  `game_id` int(11) DEFAULT 21,
  `fact_en` text NOT NULL,
  `think_question_en` text NOT NULL,
  `think_options_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`think_options_en`)),
  `think_correct_index` int(11) NOT NULL,
  `apply_question_en` text NOT NULL,
  `apply_options_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`apply_options_en`)),
  `apply_correct_index` int(11) NOT NULL,
  `explanation_en` text NOT NULL,
  `fact_np` text DEFAULT NULL,
  `think_question_np` text DEFAULT NULL,
  `think_options_np` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`think_options_np`)),
  `apply_question_np` text DEFAULT NULL,
  `apply_options_np` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`apply_options_np`)),
  `explanation_np` text DEFAULT NULL,
  `why_it_matters` text DEFAULT NULL,
  `fact_image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `capybara_learning_content`
--

INSERT INTO `capybara_learning_content` (`content_id`, `level_number`, `game_id`, `fact_en`, `think_question_en`, `think_options_en`, `think_correct_index`, `apply_question_en`, `apply_options_en`, `apply_correct_index`, `explanation_en`, `fact_np`, `think_question_np`, `think_options_np`, `apply_question_np`, `apply_options_np`, `explanation_np`, `why_it_matters`, `fact_image`, `created_at`) VALUES
(1, 1, 2, 'Did you know? Kathmandu is called the \"City of Temples\" because it has over 600 ancient temples! The oldest one, Changu Narayan, is more than 1,600 years old – that\'s even older than your great-great-great-grandparents!', 'Why do you think Kathmandu is called the \"City of Temples\"?', '[\"Because it has many modern buildings\", \"Because it has over 600 ancient temples\", \"Because it has many parks\", \"Because it is very big\"]', 1, 'How many ancient temples does Kathmandu have?', '[\"Over 100\", \"Over 600\", \"Over 1000\", \"Over 2000\"]', 1, 'Kathmandu is called the \"City of Temples\" because it has over 600 ancient temples! The oldest one is more than 1,600 years old – that\'s older than anything you\'ve ever seen!', 'के तपाईंलाई थाहा छ? काठमाडौंलाई \"मन्दिरको सहर\" भनिन्छ किनभने यहाँ ६०० भन्दा बढी पुराना मन्दिरहरू छन्! सबैभन्दा पुरानो मन्दिर चाँगुनारायण हो, जो १,६०० वर्षभन्दा पुरानो छ – यो तपाईंका हजुरबा-हजुरआमाभन्दा पनि पुरानो हो!', 'काठमाडौंलाई \"मन्दिरको सहर\" किन भनिन्छ?', '[\"किनभने यहाँ धेरै आधुनिक भवनहरू छन्\", \"किनभने यहाँ ६०० भन्दा बढी पुराना मन्दिरहरू छन्\", \"किनभने यहाँ धेरै पार्कहरू छन्\", \"किनभने यो धेरै ठूलो छ\"]', 'काठमाडौंमा कति पुराना मन्दिरहरू छन्?', '[\"१०० भन्दा बढी\", \"६०० भन्दा बढी\", \"१००० भन्दा बढी\", \"२००० भन्दा बढी\"]', 'काठमाडौंलाई \"मन्दिरको सहर\" भनिन्छ किनभने यहाँ ६०० भन्दा बढी पुराना मन्दिरहरू छन्! सबैभन्दा पुरानो मन्दिर १,६०० वर्षभन्दा पुरानो छ – यो तपाईंले देख्नुभएको कुनै पनि वस्तुभन्दा पुरानो हो!', NULL, NULL, '2026-08-09 07:04:12'),
(2, 1, 2, 'Imagine walking through a square where kings once ruled! Durbar Square in Kathmandu is filled with palaces and temples covered in beautiful carvings. The most famous one has a wooden window with 55 intricately carved frames – one for each king!', 'Why do you think Durbar Square is important to Nepal\'s history?', '[\"It was a marketplace\", \"It was where kings ruled and lived\", \"It was a farming area\", \"It was a playground\"]', 1, 'How many carved frames does the famous wooden window at Durbar Square have?', '[\"55\", \"25\", \"100\", \"75\"]', 0, 'Durbar Square was where the Malla kings ruled and lived. The famous window with 55 frames represents 55 kings who ruled from there – it\'s like a history book carved in wood!', 'कल्पना गर्नुहोस् कि तपाईं त्यो चोकमा हिँड्दै हुनुहुन्छ जहाँ राजाहरूले शासन गर्थे! काठमाडौंको दरबार स्क्वायर दरबार र मन्दिरहरूले भरिएको छ जसमा सुन्दर कलाकृतिहरू छन्। सबैभन्दा प्रसिद्ध एउटा काठको झ्याल हो जसमा ५५ वटा नक्काशी गरिएका फ्रेमहरू छन् – प्रत्येक राजाको लागि एउटा!', 'दरबार स्क्वायर नेपालको इतिहासको लागि किन महत्वपूर्ण छ?', '[\"यो बजार थियो\", \"यो राजाहरूले शासन गर्ने र बस्ने ठाउँ थियो\", \"यो खेती क्षेत्र थियो\", \"यो खेल मैदान थियो\"]', 'दरबार स्क्वायरको प्रसिद्ध काठको झ्यालमा कति वटा नक्काशी गरिएका फ्रेमहरू छन्?', '[\"५५\", \"२५\", \"१००\", \"७५\"]', 'दरबार स्क्वायर मल्ल राजाहरूले शासन गर्ने र बस्ने ठाउँ थियो। ५५ फ्रेम भएको प्रसिद्ध झ्यालले ५५ जना राजाहरूको प्रतिनिधित्व गर्छ – यो काठमा कुँदिएको इतिहासको किताब जस्तै हो!', NULL, NULL, '2026-08-09 07:04:12'),
(3, 1, 2, 'The Pashupatinath Temple sits right next to the Bagmati River. People believe the river is holy – they perform special ceremonies on its banks. The temple has a golden roof that shines so brightly, you can see it from far away!', 'Why do you think temples are often built near rivers?', '[\"For easy water access\", \"For spiritual ceremonies and purification\", \"For scenic views\", \"For fishing\"]', 1, 'What is the name of the river that flows beside Pashupatinath Temple?', '[\"Bagmati\", \"Gandaki\", \"Koshi\", \"Karnali\"]', 0, 'Hindu people believe rivers are holy. Pashupatinath Temple is built on the Bagmati River so people can perform special ceremonies and purify themselves in the sacred water.', 'पशुपतिनाथ मन्दिर बागमती नदीको छेउमा अवस्थित छ। मानिसहरू विश्वास गर्छन् कि नदी पवित्र छ – तिनीहरू यसको किनारमा विशेष अनुष्ठानहरू गर्छन्। मन्दिरको सुनको छाना यति चम्किलो छ कि तपाईं यसलाई टाढाबाट देख्न सक्नुहुन्छ!', 'मन्दिरहरू प्रायः नदीको किनारमा किन बनाइन्छ?', '[\"सजिलो पानी पहुँचको लागि\", \"आध्यात्मिक अनुष्ठान र शुद्धिकरणको लागि\", \"सुन्दर दृश्यको लागि\", \"माछा मार्नको लागि\"]', 'पशुपतिनाथ मन्दिरको छेउमा बग्ने नदीको नाम के हो?', '[\"बागमती\", \"गण्डकी\", \"कोशी\", \"कर्णाली\"]', 'हिन्दुहरू विश्वास गर्छन् कि नदीहरू पवित्र हुन्छन्। पशुपतिनाथ मन्दिर बागमती नदीको किनारमा बनाइएको हो ताकि मानिसहरूले विशेष अनुष्ठान गर्न र पवित्र पानीमा शुद्ध हुन सकून्।', NULL, NULL, '2026-08-09 07:04:12'),
(4, 2, 2, 'In Nepal, the cow is so special that it\'s against the law to hurt one! It\'s the national animal and is treated with great respect. People even celebrate a festival called Gai Puja where they honour cows with garlands and special treats!', 'Why do you think the cow is treated with such great respect in Nepal?', '[\"Because it gives milk\", \"Because it is sacred and a symbol of kindness\", \"Because it is strong\", \"Because it is big\"]', 1, 'What is the national animal of Nepal?', '[\"Elephant\", \"Cow\", \"Tiger\", \"Lion\"]', 1, 'The cow is considered sacred in Nepal. It\'s protected by law and honoured during the festival of Gai Puja. People show their respect by giving cows garlands and special treats.', 'नेपालमा, गाई यति विशेष छ कि यसलाई चोट पुर्याउनु कानूनविरुद्ध हो! यो राष्ट्रिय पशु हो र यसलाई धेरै सम्मान गरिन्छ। मानिसहरू गाई पूजा भन्ने चाड पनि मनाउँछन् जहाँ तिनीहरू गाईलाई माला र विशेष खाना दिएर सम्मान गर्छन्!', 'गाईलाई नेपालमा यति धेरै सम्मान किन गरिन्छ?', '[\"किनभने यसले दूध दिन्छ\", \"किनभने यो पवित्र र दयालुताको प्रतीक हो\", \"किनभने यो बलियो छ\", \"किनभने यो ठूलो छ\"]', 'नेपालको राष्ट्रिय पशु के हो?', '[\"हात्ती\", \"गाई\", \"बाघ\", \"सिंह\"]', 'गाईलाई नेपालमा पवित्र मानिन्छ। यो कानूनद्वारा संरक्षित छ र गाई पूजा चाडमा सम्मान गरिन्छ। मानिसहरू गाईलाई माला र विशेष खाना दिएर सम्मान देखाउँछन्।', NULL, NULL, '2026-08-09 07:13:18'),
(5, 2, 2, 'The rhododendron, or Lali Gurans, is Nepal\'s national flower – and it\'s absolutely gorgeous! It blooms in bright red and covers the Himalayan hillsides like a giant red carpet. The flower is so beautiful that it inspired a famous Nepali song!', 'Why do you think the rhododendron was chosen as Nepal\'s national flower?', '[\"Because it grows everywhere\", \"Because it blooms in bright red and represents the Himalayas\", \"Because it has a nice smell\", \"Because it is very tall\"]', 1, 'What is Nepal\'s national flower called in Nepali?', '[\"Lali Gurans\", \"Sunakhari\", \"Gulaf\", \"Chameli\"]', 0, 'The rhododendron, or Lali Gurans, was chosen as Nepal\'s national flower because it blooms in bright red and covers the Himalayan hillsides – representing the beauty and spirit of Nepal.', 'लाली गुराँस नेपालको राष्ट्रिय फूल हो – र यो अत्यन्तै सुन्दर छ! यो चम्किलो रातो रंगमा फुल्छ र हिमालयका पहाडहरूलाई विशाल रातो कार्पेट जस्तै ढाक्छ। यो फूल यति सुन्दर छ कि यसले एउटा प्रसिद्ध नेपाली गीतलाई प्रेरित गरेको छ!', 'लाली गुराँसलाई नेपालको राष्ट्रिय फूलको रूपमा किन छानियो होला?', '[\"किनभने यो जताततै उम्रन्छ\", \"किनभने यो चम्किलो रातो रंगमा फुल्छ र हिमालयको प्रतिनिधित्व गर्छ\", \"किनभने यसको गन्ध राम्रो छ\", \"किनभने यो धेरै अग्लो छ\"]', 'नेपालको राष्ट्रिय फूललाई नेपालीमा के भनिन्छ?', '[\"लाली गुराँस\", \"सुनाखरी\", \"गुलाफ\", \"चमेली\"]', 'लाली गुराँसलाई नेपालको राष्ट्रिय फूलको रूपमा छानियो किनभने यो चम्किलो रातो रंगमा फुल्छ र हिमालयका पहाडहरूलाई ढाक्छ – जसले नेपालको सौन्दर्य र भावनाको प्रतिनिधित्व गर्छ।', NULL, NULL, '2026-08-09 07:13:18'),
(6, 2, 2, 'Nepal\'s flag is the ONLY flag in the world that isn\'t a rectangle! The two triangles represent the Himalayan mountains. The flag also has symbols of the sun and moon – some say it means Nepal will exist as long as the sun and moon shine!', 'What is unique about Nepal\'s flag compared to other countries?', '[\"It has no colour\", \"It is the only non-rectangular flag in the world\", \"It has a picture of an animal\", \"It is very small\"]', 1, 'How many triangles does Nepal\'s flag have?', '[\"1\", \"2\", \"3\", \"4\"]', 1, 'Nepal\'s flag is the only non-rectangular flag in the world. The two triangles represent the Himalayan mountains, and the sun and moon symbols represent Nepal\'s hope for eternity.', 'नेपालको झण्डा विश्वको एक मात्र गैर-आयताकार राष्ट्रिय झण्डा हो! दुईवटा त्रिकोणले हिमालय पर्वतलाई प्रतिनिधित्व गर्छन्। झण्डामा सूर्य र चन्द्रमाका प्रतीकहरू पनि छन् – कोही भन्छन् यसको अर्थ सूर्य र चन्द्रमा चम्किरहेसम्म नेपाल रहिरहनेछ!', 'अन्य देशहरूको तुलनामा नेपालको झण्डाको विशेषता के हो?', '[\"यसमा रंग छैन\", \"यो विश्वको एक मात्र गैर-आयताकार झण्डा हो\", \"यसमा जनावरको चित्र छ\", \"यो धेरै सानो छ\"]', 'नेपालको झण्डामा कति ओटा त्रिकोणहरू छन्?', '[\"१\", \"२\", \"३\", \"४\"]', 'नेपालको झण्डा विश्वको एक मात्र गैर-आयताकार झण्डा हो। दुई त्रिकोणले हिमालय पर्वतको प्रतिनिधित्व गर्छन्, र सूर्य र चन्द्रमाका प्रतीकहरूले नेपालको अनन्तताको आशाको प्रतिनिधित्व गर्छन्।', NULL, NULL, '2026-08-09 07:13:18'),
(7, 3, 2, 'Mount Everest is so high that at its peak, you\'re closer to space than to the ground! It\'s 8,848 metres tall – that\'s like stacking 20 Burj Khalifas (the world\'s tallest building) on top of each other! Climbing it takes months and climbers need special oxygen to breathe!', 'Why do you think Mount Everest attracts climbers from all over the world?', '[\"Because it\'s the tallest mountain in the world\", \"Because it\'s easy to climb\", \"Because it has the best views\", \"Because it\'s close to home\"]', 0, 'How tall is Mount Everest?', '[\"8,848 metres\", \"6,000 metres\", \"12,000 metres\", \"10,000 metres\"]', 0, 'Mount Everest is the tallest mountain in the world at 8,848 metres. It\'s so high that planes fly below its summit! Climbers need months of training and special oxygen to reach the top.', 'सगरमाथा यति अग्लो छ कि यसको शिखरमा पुग्दा, तपाईं जमिनभन्दा अन्तरिक्षको नजिक हुनुहुन्छ! यो ८,८४८ मिटर अग्लो छ – यो २० वटा बुर्ज खलिफा (विश्वको अग्लो भवन) एकअर्कामाथि राखेजस्तै हो! यसमा चढ्न महिनौं लाग्छ र आरोहीहरूलाई सास फेर्न विशेष अक्सिजन चाहिन्छ!', 'सगरमाथाले विश्वभरका आरोहीहरूलाई किन आकर्षित गर्छ?', '[\"किनभने यो विश्वको सबैभन्दा अग्लो हिमाल हो\", \"किनभने यो चढ्न सजिलो छ\", \"किनभने यसको दृश्य सबैभन्दा राम्रो छ\", \"किनभने यो घरको नजिक छ\"]', 'सगरमाथा कति अग्लो छ?', '[\"८,८४८ मिटर\", \"६,००० मिटर\", \"१२,००० मिटर\", \"१०,००० मिटर\"]', 'सगरमाथा विश्वको सबैभन्दा अग्लो हिमाल हो, ८,८४८ मिटर। यो यति अग्लो छ कि विमानहरू यसको शिखरभन्दा तल उड्छन्! आरोहीहरूलाई शिखरमा पुग्न महिनौंको तालिम र विशेष अक्सिजन चाहिन्छ।', NULL, NULL, '2026-08-09 07:13:18'),
(8, 3, 2, 'Nepal is home to 8 of the world\'s 14 highest mountains! The Himalayan range runs right through the country like a giant backbone. The mountains are so tall that they create their own weather – they block rain clouds and make the Terai region one of the most fertile areas on Earth!', 'Why does Nepal have so many of the world\'s highest mountains?', '[\"Because the Himalayan range runs through Nepal\", \"Because of volcanoes\", \"Because of earthquakes\", \"Because of the ocean\"]', 0, 'How many of the world\'s highest mountains are in Nepal?', '[\"5\", \"8\", \"10\", \"12\"]', 1, 'Nepal has 8 of the 14 highest mountains because the Himalayan range runs through the country. These tall mountains even create their own weather patterns!', 'नेपाल विश्वका १४ अग्ला हिमालमध्ये ८ ओटाको घर हो! हिमालय श्रृंखला देशभर विशाल ढाडजस्तै फैलिएको छ। हिमालहरू यति अग्ला छन् कि तिनीहरूले आफ्नै मौसम बनाउँछन् – तिनीहरूले वर्षाका बादलहरूलाई रोक्छन् र तराई क्षेत्रलाई विश्वको सबैभन्दा उर्वर क्षेत्रहरूमध्ये एक बनाउँछन्!', 'नेपालमा विश्वका सबैभन्दा अग्ला हिमालहरू किन धेरै छन्?', '[\"किनभने हिमालय श्रृंखला नेपालबाट गुज्रिन्छ\", \"ज्वालामुखीको कारणले\", \"भूकम्पको कारणले\", \"समुद्रको कारणले\"]', 'विश्वका कति ओटा अग्ला हिमालहरू नेपालमा छन्?', '[\"५\", \"८\", \"१०\", \"१२\"]', 'नेपालमा १४ अग्ला हिमालमध्ये ८ ओटा छन् किनभने हिमालय श्रृंखला देशबाट गुज्रिन्छ। यी अग्ला हिमालहरूले आफ्नै मौसम प्रणाली बनाउँछन्!', NULL, NULL, '2026-08-09 07:13:18'),
(9, 3, 2, 'Sagarmatha National Park isn\'t just about Mount Everest – it\'s home to some amazing animals too! The snow leopard, the red panda, and even the Himalayan black bear live there. The park is so special that UNESCO called it a World Heritage Site!', 'Why do you think Sagarmatha National Park is protected as a World Heritage Site?', '[\"It has unique animals and the highest mountain\", \"It has the best views\", \"It has many hotels\", \"It has the most tourists\"]', 0, 'Which rare animal is found in Sagarmatha National Park?', '[\"Snow leopard\", \"Elephant\", \"Tiger\", \"Lion\"]', 0, 'Sagarmatha National Park is protected because it has Mount Everest AND rare animals like the snow leopard and red panda – making it one of the most special places on Earth!', 'सगरमाथा राष्ट्रिय निकुञ्ज सगरमाथाको बारेमा मात्र होइन – यो केही अद्भुत जनावरहरूको घर पनि हो! हिउँ चितुवा, रातो पाण्डा, र हिमालय कालो भालु पनि त्यहाँ बस्छन्। यो निकुञ्ज यति विशेष छ कि युनेस्कोले यसलाई विश्व सम्पदा स्थल घोषणा गरेको छ!', 'सगरमाथा राष्ट्रिय निकुञ्जलाई विश्व सम्पदा स्थलको रूपमा किन संरक्षित गरिएको होला?', '[\"यसमा अद्वितीय जनावर र सबैभन्दा अग्लो हिमाल छ\", \"यसको दृश्य सबैभन्दा राम्रो छ\", \"यहाँ धेरै होटलहरू छन्\", \"यहाँ सबैभन्दा धेरै पर्यटकहरू छन्\"]', 'सगरमाथा राष्ट्रिय निकुञ्जमा कुन दुर्लभ जनावर पाइन्छ?', '[\"हिउँ चितुवा\", \"हात्ती\", \"बाघ\", \"सिंह\"]', 'सगरमाथा राष्ट्रिय निकुञ्ज संरक्षित छ किनभने यसमा सगरमाथा र हिउँ चितुवा र रातो पाण्डा जस्ता दुर्लभ जनावरहरू छन् – जसले यसलाई विश्वको सबैभन्दा विशेष स्थानहरूमध्ये एक बनाउँछ!', NULL, NULL, '2026-08-09 07:13:18'),
(10, 4, 2, 'The Terai region is called the \"granary\" of Nepal – it produces so much rice that it feeds the whole country! The soil is so rich because rivers from the Himalayas bring down nutrient-packed mud. Without the Terai, there\'d be no dal bhat for anyone!', 'Why is the Terai region called the \"granary\" of Nepal?', '[\"It has many factories\", \"It produces lots of rice and crops\", \"It has the most people\", \"It has the most schools\"]', 1, 'Which region of Nepal is known as the \"granary\" of the country?', '[\"Terai\", \"Himalayas\", \"Hills\", \"Kathmandu Valley\"]', 0, 'The Terai region is called Nepal\'s granary because it produces so much rice and other crops – thanks to its rich soil and warm climate.', 'तराई क्षेत्रलाई नेपालको \"अन्न भण्डार\" भनिन्छ – यसले यति धेरै धान उत्पादन गर्छ कि यसले सम्पूर्ण देशलाई खुवाउँछ! माटो यति उर्वर छ किनभने हिमालयका नदीहरूले पोषक तत्वले भरिएको माटो ल्याउँछन्। तराई नभए कसैलाई पनि दाल भात खान पाइने थिएन!', 'तराई क्षेत्रलाई नेपालको \"अन्न भण्डार\" किन भनिन्छ?', '[\"यहाँ धेरै कारखानाहरू छन्\", \"यसले धेरै धान र बाली उत्पादन गर्छ\", \"यहाँ सबैभन्दा धेरै मानिसहरू छन्\", \"यहाँ सबैभन्दा धेरै विद्यालयहरू छन्\"]', 'नेपालको कुन क्षेत्रलाई \"अन्न भण्डार\" भनिन्छ?', '[\"तराई\", \"हिमालय\", \"पहाड\", \"काठमाडौं उपत्यका\"]', 'तराई क्षेत्रलाई नेपालको अन्न भण्डार भनिन्छ किनभने यसले धेरै धान र अन्य बालीहरू उत्पादन गर्छ – यसको उर्वर माटो र न्यानो मौसमको कारणले।', NULL, NULL, '2026-08-09 07:13:18'),
(11, 4, 2, 'Chitwan National Park is like a real-life \"Jungle Book\"! It\'s home to the rare one-horned rhinoceros – you can\'t find them anywhere else on Earth. The park also has crocodiles, leopards, and even royal Bengal tigers! You can ride elephants to spot them!', 'Why is Chitwan National Park so special?', '[\"It has rare animals like the one-horned rhino\", \"It has the most trees\", \"It has the best weather\", \"It has the biggest lake\"]', 0, 'Which national park is famous for the one-horned rhinoceros?', '[\"Sagarmatha\", \"Chitwan\", \"Bardiya\", \"Langtang\"]', 1, 'Chitwan National Park is special because it protects the rare one-horned rhinoceros – a species found only in Nepal and India. It\'s a real-life adventure park!', 'चितवन राष्ट्रिय निकुञ्ज एउटा वास्तविक \"जंगल बुक\" जस्तै हो! यो दुर्लभ एकसिङ्गे गैंडाको घर हो – तपाईं तिनीहरूलाई पृथ्वीमा कतै पनि फेला पार्न सक्नुहुन्न। निकुञ्जमा गोही, चितुवा, र शाही बंगाल बाघ पनि छन्! तपाईं तिनीहरूलाई हेर्न हात्ती चढ्न सक्नुहुन्छ!', 'चितवन राष्ट्रिय निकुञ्ज किन यति विशेष छ?', '[\"यसमा एकसिङ्गे गैंडा जस्ता दुर्लभ जनावरहरू छन्\", \"यसमा सबैभन्दा धेरै रूखहरू छन्\", \"यहाँको मौसम सबैभन्दा राम्रो छ\", \"यहाँ सबैभन्दा ठूलो ताल छ\"]', 'एकसिङ्गे गैंडाको लागि कुन राष्ट्रिय निकुञ्ज प्रसिद्ध छ?', '[\"सगरमाथा\", \"चितवन\", \"बर्दिया\", \"लाङटाङ\"]', 'चितवन राष्ट्रिय निकुञ्ज विशेष छ किनभने यसले दुर्लभ एकसिङ्गे गैंडाको संरक्षण गर्छ – एक प्रजाति जो नेपाल र भारतमा मात्र पाइन्छ। यो एउटा वास्तविक साहसिक पार्क हो!', NULL, NULL, '2026-08-09 07:13:18'),
(12, 4, 2, 'Did you know Nepal has doubled its tiger population? The royal Bengal tiger is one of the most powerful animals on Earth – a single tiger can weigh as much as a small car! Nepal\'s conservation efforts are so successful that scientists from all over the world come to study them!', 'Why are tigers important to the ecosystem?', '[\"They are at the top of the food chain\", \"They are beautiful\", \"They are friendly\", \"They are fast\"]', 0, 'Where do Bengal tigers live in Nepal?', '[\"In the mountains\", \"In the Terai forests\", \"In the cities\", \"In the ocean\"]', 1, 'Tigers are top predators – they keep the balance of nature in check. Nepal\'s successful conservation has doubled the tiger population, making it a global success story!', 'के तपाईंलाई थाहा छ नेपालले आफ्नो बाघको जनसंख्या दोब्बर बनाएको छ? शाही बंगाल बाघ पृथ्वीको सबैभन्दा शक्तिशाली जनावरहरूमध्ये एक हो – एउटा बाघको तौल एउटा सानो कार जत्तिकै हुन्छ! नेपालको संरक्षण प्रयास यति सफल छ कि विश्वभरका वैज्ञानिकहरू तिनीहरूको अध्ययन गर्न आउँछन्!', 'बाघहरू पारिस्थितिकी प्रणालीको लागि किन महत्वपूर्ण छन्?', '[\"तिनीहरू खाद्य श्रृंखलाको शीर्षमा छन्\", \"तिनीहरू सुन्दर छन्\", \"तिनीहरू मित्रवत छन्\", \"तिनीहरू छिटो छन्\"]', 'बंगाल बाघहरू नेपालमा कहाँ बस्छन्?', '[\"पहाडमा\", \"तराईका जंगलहरूमा\", \"सहरहरूमा\", \"समुद्रमा\"]', 'बाघहरू शीर्ष शिकारी हुन् – तिनीहरूले प्रकृतिको सन्तुलन कायम राख्छन्। नेपालको सफल संरक्षणले बाघको जनसंख्या दोब्बर बनाएको छ, जसले यसलाई विश्वव्यापी सफलताको कथा बनाएको छ!', NULL, NULL, '2026-08-09 07:13:18'),
(13, 5, 2, 'Dashain is Nepal\'s biggest party – it lasts 15 days! People fly kites, play on giant bamboo swings, and even build ferris wheels! The sky is filled with colorful kites, and children shout \"Changa cheit\" whenever they cut someone\'s kite string!', 'Why do you think Dashain is celebrated with so much fun and excitement?', '[\"It\'s a public holiday\", \"It\'s a time for family, celebration, and fun activities\", \"People get gifts\", \"It\'s the only holiday\"]', 1, 'How many days does Dashain last?', '[\"10 days\", \"15 days\", \"20 days\", \"25 days\"]', 1, 'Dashain is Nepal\'s biggest festival – it\'s 15 days of family reunions, delicious food, and fun activities like kite flying and swings. It\'s a time to celebrate with loved ones!', 'दशैं नेपालको सबैभन्दा ठूलो पार्टी हो – यो १५ दिनसम्म चल्छ! मानिसहरू चङ्गा उडाउँछन्, विशाल बाँसको पिङ खेल्छन्, र फेरिस ह्वील पनि बनाउँछन्! आकाश रंगीविरंगी चङ्गाहरूले भरिन्छ, र बच्चाहरूले कसैको चङ्गाको डोरी काट्दा \"चङ्गा चैत\" भनेर कराउँछन्!', 'दशैं यति धेरै मजा र उत्साहका साथ किन मनाइन्छ?', '[\"यो सार्वजनिक बिदा हो\", \"यो परिवार, उत्सव, र रमाइला गतिविधिहरूको समय हो\", \"मानिसहरूलाई उपहार मिल्छ\", \"यो मात्र चाड हो\"]', 'दशैं कति दिनसम्म चल्छ?', '[\"१० दिन\", \"१५ दिन\", \"२० दिन\", \"२५ दिन\"]', 'दशैं नेपालको सबैभन्दा ठूलो चाड हो – यो १५ दिनको परिवार पुनर्मिलन, स्वादिष्ट खाना, र चङ्गा उडाउने र पिङ खेल्ने जस्ता रमाइला गतिविधिहरूको समय हो। यो आफन्तहरूसँग उत्सव मनाउने समय हो!', NULL, NULL, '2026-08-09 07:13:18'),
(14, 5, 2, 'During Dashain, elders put tika (red powder mixed with rice) on younger people\'s foreheads. It\'s like getting a special blessing! They also give jamara – barley sprouts that look like tiny green crowns. Getting tika means you\'ve been blessed for the whole year!', 'Why is receiving tika and jamara during Dashain so special?', '[\"It\'s a sign of respect and blessings from elders\", \"It\'s a fashion trend\", \"It\'s a gift\", \"It\'s a game\"]', 0, 'What do elders give to younger people during Dashain?', '[\"Money\", \"Tika and jamara\", \"New clothes\", \"Toys\"]', 1, 'Tika and jamara are blessings from elders. When you receive them, it means you\'ve been blessed with good luck, health, and happiness for the whole year!', 'दशैंको समयमा, ठूलाबडाले कान्छाहरूको निधारमा टीका (रातो पाउडर र चामल) लगाइदिन्छन्। यो विशेष आशीर्वाद पाउनु जस्तै हो! तिनीहरूले जमरा पनि दिन्छन् – जौको बिरुवा जो साना हरियो मुकुट जस्तै देखिन्छ। टीका पाउनुको अर्थ तपाईंले पूरै वर्षको लागि आशीर्वाद पाउनु हो!', 'दशैंमा टीका र जमरा प्राप्त गर्नु किन यति विशेष छ?', '[\"यो ठूलाबडाको सम्मान र आशीर्वादको चिन्ह हो\", \"यो फेसन ट्रेन्ड हो\", \"यो उपहार हो\", \"यो खेल हो\"]', 'दशैंमा ठूलाबडाले कान्छाहरूलाई के दिन्छन्?', '[\"पैसा\", \"टीका र जमरा\", \"नयाँ लुगा\", \"खेलौना\"]', 'टीका र जमरा ठूलाबडाको आशीर्वाद हो। जब तपाईंले तिनीहरू प्राप्त गर्नुहुन्छ, यसको अर्थ तपाईंले पूरै वर्षको लागि शुभकामना, स्वास्थ्य, र खुशीको आशीर्वाद पाउनुभएको छ!', NULL, NULL, '2026-08-09 07:13:18'),
(15, 5, 2, 'The most important day of Dashain is called Bijaya Dashami – the Day of Victory! It\'s believed that the goddess Durga defeated a powerful demon on this day. People celebrate by flying kites, eating delicious food, and spending time with family. It\'s like Nepal\'s own New Year\'s Day!', 'Why is Bijaya Dashami called the \"Day of Victory\"?', '[\"It marks the end of the festival\", \"It\'s the day Durga defeated the demon\", \"It\'s a public holiday\", \"It\'s the day people get gifts\"]', 1, 'What is the most important day of Dashain called?', '[\"Bijaya Dashami\", \"Ghatasthapana\", \"Fulpati\", \"Maha Ashtami\"]', 0, 'Bijaya Dashami means \"Day of Victory\" – it\'s when Durga defeated the demon. It\'s the most important day of Dashain, celebrated with family, feasts, and blessings.', 'दशैंको सबैभन्दा महत्वपूर्ण दिनलाई विजया दशमी भनिन्छ – विजयको दिन! यो विश्वास गरिन्छ कि देवी दुर्गाले यस दिन एउटा शक्तिशाली राक्षसलाई पराजित गरेकी थिइन्। मानिसहरू चङ्गा उडाएर, स्वादिष्ट खाना खाएर, र परिवारसँग समय बिताएर उत्सव मनाउँछन्। यो नेपालको आफ्नै नयाँ वर्षको दिन जस्तै हो!', 'विजया दशमीलाई \"विजयको दिन\" किन भनिन्छ?', '[\"यसले चाडको अन्त्य गर्छ\", \"यो दुर्गाले राक्षसलाई पराजित गरेको दिन हो\", \"यो सार्वजनिक बिदा हो\", \"यो मानिसहरूले उपहार पाउने दिन हो\"]', 'दशैंको सबैभन्दा महत्वपूर्ण दिनलाई के भनिन्छ?', '[\"विजया दशमी\", \"घटस्थापना\", \"फूलपाती\", \"महा अष्टमी\"]', 'विजया दशमीको अर्थ \"विजयको दिन\" हो – यो दुर्गाले राक्षसलाई पराजित गरेको दिन हो। यो दशैंको सबैभन्दा महत्वपूर्ण दिन हो, जुन परिवार, भोज, र आशीर्वादको साथ मनाइन्छ।', NULL, NULL, '2026-08-09 07:13:18'),
(16, 6, 2, 'Tihar is called the Festival of Lights – and it\'s beautiful! People light thousands of oil lamps (called diyas) and place them around their homes. The whole country glows like a sky full of stars! It\'s believed that the goddess Lakshmi visits homes that are lit up and brings good fortune!', 'Why is Tihar called the \"Festival of Lights\"?', '[\"Because people light oil lamps all around their homes\", \"Because it\'s a fire festival\", \"Because of fireworks\", \"Because it\'s very bright\"]', 0, 'Which goddess is worshipped during Tihar?', '[\"Durga\", \"Lakshmi\", \"Saraswati\", \"Kali\"]', 1, 'Tihar is the Festival of Lights because people light diyas (oil lamps) to welcome the goddess Lakshmi. They believe she visits lit homes and brings good fortune!', 'तिहारलाई बत्तीको चाड भनिन्छ – र यो अत्यन्तै सुन्दर छ! मानिसहरू हजारौं दियो बाल्छन् र तिनीहरूलाई आफ्नो घरको वरिपरि राख्छन्। सम्पूर्ण देश ताराले भरिएको आकाश जस्तै चम्किन्छ! यो विश्वास गरिन्छ कि देवी लक्ष्मी उज्यालो भएका घरहरूमा जानुहुन्छ र शुभ भाग्य ल्याउनुहुन्छ!', 'तिहारलाई \"बत्तीको चाड\" किन भनिन्छ?', '[\"किनभने मानिसहरू घरको वरिपरि दियो बाल्छन्\", \"किनभने यो आगोको चाड हो\", \"आतिशबाजीको कारणले\", \"किनभने यो धेरै उज्यालो छ\"]', 'तिहारमा कुन देवीको पूजा गरिन्छ?', '[\"दुर्गा\", \"लक्ष्मी\", \"सरस्वती\", \"काली\"]', 'तिहारलाई बत्तीको चाड भनिन्छ किनभने मानिसहरूले देवी लक्ष्मीलाई स्वागत गर्न दियो बाल्छन्। तिनीहरू विश्वास गर्छन् कि उहाँ उज्यालो भएका घरहरूमा आउनुहुन्छ र शुभ भाग्य ल्याउनुहुन्छ!', NULL, NULL, '2026-08-09 07:13:18'),
(17, 6, 2, 'Tihar is the only festival where animals are honoured! Each day celebrates a different animal: crows (as messengers), dogs (as guardians), cows (as mothers), and oxen (as helpers). On Dog Day, even street dogs get tika and garlands – they\'re treated like kings!', 'Why do you think Tihar includes honouring animals?', '[\"Because animals are useful to humans\", \"Because they are considered messengers and guardians\", \"Because they are pets\", \"Because they are strong\"]', 1, 'Which animal is honoured on the third day of Tihar (Lakshmi Puja)?', '[\"Cow\", \"Dog\", \"Ox\", \"Crow\"]', 0, 'Tihar honours different animals on different days – crows as messengers, dogs as guardians, cows as mothers, and oxen as helpers. Even street dogs are treated like kings on Dog Day!', 'तिहार मात्र त्यस्तो चाड हो जहाँ जनावरहरूको सम्मान गरिन्छ! प्रत्येक दिन फरक जनावरको उत्सव मनाइन्छ: काग (दूतको रूपमा), कुकुर (संरक्षकको रूपमा), गाई (आमाको रूपमा), र गोरु (सहायकको रूपमा)। कुकुर दिवसमा, सडकका कुकुरहरूलाई पनि टीका र माला लगाइन्छ – तिनीहरूलाई राजा जस्तै व्यवहार गरिन्छ!', 'तिहारमा जनावरहरूको सम्मान किन गरिन्छ होला?', '[\"किनभने जनावरहरू मानिसको लागि उपयोगी छन्\", \"किनभने तिनीहरूलाई दूत र संरक्षक मानिन्छ\", \"किनभने तिनीहरू घरपालुवा हुन्\", \"किनभने तिनीहरू बलिया छन्\"]', 'तिहारको तेस्रो दिन (लक्ष्मी पूजा) कुन जनावरको सम्मान गरिन्छ?', '[\"गाई\", \"कुकुर\", \"गोरु\", \"काग\"]', 'तिहारले विभिन्न दिनहरूमा विभिन्न जनावरहरूको सम्मान गर्छ – कागलाई दूतको रूपमा, कुकुरलाई संरक्षकको रूपमा, गाईलाई आमाको रूपमा, र गोरुलाई सहायकको रूपमा। कुकुर दिवसमा सडकका कुकुरहरूलाई पनि राजा जस्तै व्यवहार गरिन्छ!', NULL, NULL, '2026-08-09 07:13:18'),
(18, 6, 2, 'Bhai Tika is the last and most touching day of Tihar. Sisters put tika on their brothers\' foreheads and pray for their long life. Brothers give gifts to their sisters in return. It\'s a beautiful celebration of the special bond between brothers and sisters!', 'Why is Bhai Tika an important celebration?', '[\"It celebrates the bond between brothers and sisters\", \"It\'s a public holiday\", \"It involves giving gifts\", \"It\'s the only day for family\"]', 0, 'What is the final day of Tihar called?', '[\"Lakshmi Puja\", \"Bhai Tika\", \"Kukur Puja\", \"Gai Puja\"]', 1, 'Bhai Tika celebrates the love between brothers and sisters. Sisters pray for their brothers\' long lives, and brothers give gifts in return – it\'s a beautiful family tradition!', 'भाइ टीका तिहारको अन्तिम र सबैभन्दा मार्मिक दिन हो। दिदीबहिनीले दाजुभाइको निधारमा टीका लगाइदिन्छन् र उनीहरूको दीर्घायुको कामना गर्छन्। दाजुभाइले बदलामा दिदीबहिनीलाई उपहार दिन्छन्। यो दाजुभाइ-दिदीबहिनीको विशेष बन्धनको सुन्दर उत्सव हो!', 'भाइ टीका किन महत्वपूर्ण उत्सव हो?', '[\"यसले दाजुभाइ-दिदीबहिनीको बन्धनको उत्सव मनाउँछ\", \"यो सार्वजनिक बिदा हो\", \"यसमा उपहार दिने समावेश छ\", \"यो परिवारको लागि मात्र दिन हो\"]', 'तिहारको अन्तिम दिनलाई के भनिन्छ?', '[\"लक्ष्मी पूजा\", \"भाइ टीका\", \"कुकुर पूजा\", \"गाई पूजा\"]', 'भाइ टीकाले दाजुभाइ-दिदीबहिनीको मायाको उत्सव मनाउँछ। दिदीबहिनीले दाजुभाइको दीर्घायुको कामना गर्छन्, र दाजुभाइले बदलामा उपहार दिन्छन् – यो एउटा सुन्दर पारिवारिक परम्परा हो!', NULL, NULL, '2026-08-09 07:13:18'),
(19, 7, 2, 'Dal Bhat is the meal that keeps Nepal running! It\'s eaten twice a day – for lunch and dinner – and it\'s so important that people say \"Dal Bhat – 24 hours power!\" The best part? You can eat it with your hands – it\'s more fun!', 'Why do you think Dal Bhat is eaten so often in Nepal?', '[\"It\'s cheap and filling\", \"It\'s the only food available\", \"It\'s a national dish for special occasions\", \"It\'s the tastiest food\"]', 0, 'What is the staple food of Nepal?', '[\"Dal Bhat\", \"Momo\", \"Chowmein\", \"Noodles\"]', 0, 'Dal Bhat is Nepal\'s staple food – it\'s eaten twice a day because it\'s filling, nutritious, and delicious. People say \"Dal Bhat – 24 hours power\" because it gives you energy for the whole day!', 'दाल भात नेपाललाई चलाउने खाना हो! यो दिनको दुई पटक – खाजा र बेलुकी – खाइन्छ, र यो यति महत्वपूर्ण छ कि मानिसहरू भन्छन् \"दाल भात – २४ घण्टा पावर!\" सबैभन्दा राम्रो भाग? तपाईं यसलाई हातले खान सक्नुहुन्छ – यो झन् मजाको छ!', 'दाल भात नेपालमा किन यति धेरै खाइन्छ?', '[\"यो सस्तो र पेट भरिने छ\", \"यो मात्र उपलब्ध खाना हो\", \"यो विशेष अवसरहरूको लागि राष्ट्रिय परिकार हो\", \"यो सबैभन्दा स्वादिलो खाना हो\"]', 'नेपालको मुख्य खाना के हो?', '[\"दाल भात\", \"मःमः\", \"चाउमिन\", \"नुडल्स\"]', 'दाल भात नेपालको मुख्य खाना हो – यो दिनको दुई पटक खाइन्छ किनभने यो पेट भरिने, पौष्टिक, र स्वादिलो छ। मानिसहरू भन्छन् \"दाल भात – २४ घण्टा पावर\" किनभने यसले तपाईंलाई पूरै दिनको ऊर्जा दिन्छ!', NULL, NULL, '2026-08-09 07:13:18'),
(20, 7, 2, 'Momo is Nepal\'s favourite snack – and it\'s delicious! These little dumplings are filled with meat or vegetables and served with a spicy tomato sauce called achar. Achar is so spicy that it can make your tongue tingle! Momos are eaten everywhere – from street stalls to fancy restaurants!', 'Why is Momo so popular in Nepal?', '[\"It\'s delicious and comes in many flavours\", \"It\'s easy to cook\", \"It\'s only for festivals\", \"It\'s very cheap\"]', 0, 'What is the spicy dipping sauce for Momo called?', '[\"Achar\", \"Chutney\", \"Salsa\", \"Ketchup\"]', 0, 'Momo is Nepal\'s favourite snack because it\'s delicious, versatile, and comes in many flavours. The spicy achar makes it even more exciting – it can make your tongue tingle!', 'मःमः नेपालको मनपर्ने खाजा हो – र यो स्वादिलो छ! यी साना मोतीहरूमा मासु वा तरकारी भरिएको हुन्छ र अचार भनिने मसलादार टमाटरको चटनीसँग खाइन्छ। अचार यति मसलादार छ कि यसले तपाईंको जिब्रोलाई झमझमाउन सक्छ! मःमः जताततै खाइन्छ – सडकका पसलदेखि राम्रो रेस्टुरेन्टसम्म!', 'मःमः नेपालमा किन यति लोकप्रिय छ?', '[\"यो स्वादिलो छ र धेरै स्वादहरूमा आउँछ\", \"यो पकाउन सजिलो छ\", \"यो केवल चाडपर्वको लागि हो\", \"यो धेरै सस्तो छ\"]', 'मःमको मसलादार चटनीलाई के भनिन्छ?', '[\"अचार\", \"चटनी\", \"साल्सा\", \"केचप\"]', 'मःमः नेपालको मनपर्ने खाजा हो किनभने यो स्वादिलो, बहुमुखी, र धेरै स्वादहरूमा आउँछ। मसलादार अचारले यसलाई झन् रोमाञ्चक बनाउँछ – यसले तपाईंको जिब्रोलाई झमझमाउन सक्छ!', NULL, NULL, '2026-08-09 07:13:18'),
(21, 7, 2, 'Sel Roti is like Nepal\'s own sweet doughnut! It\'s crispy on the outside and soft on the inside. People make it during festivals like Dashain and Tihar – the whole house smells amazing! Sel Roti is so popular that there are even competitions to see who can make the best one!', 'Why is Sel Roti prepared during festivals?', '[\"It\'s a special sweet treat that can be shared\", \"It\'s easy to make\", \"It\'s the only sweet available\", \"It\'s very cheap\"]', 0, 'Which festivals is Sel Roti commonly made for?', '[\"Dashain\", \"Tihar\", \"Both\", \"None\"]', 2, 'Sel Roti is a special sweet treat prepared during Dashain and Tihar. It\'s crispy on the outside, soft inside, and shared with family and neighbours – it\'s a delicious festival tradition!', 'सेल रोटी नेपालको आफ्नै मीठो डोनट जस्तै हो! यो बाहिरी भाग कुरकुरे र भित्री भाग नरम हुन्छ। मानिसहरू दशैं र तिहार जस्ता चाडपर्वहरूमा यो बनाउँछन् – पूरा घरमा अद्भुत गन्ध आउँछ! सेल रोटी यति लोकप्रिय छ कि यसको उत्कृष्ट बनाउने को हो भनेर प्रतियोगिताहरू पनि हुन्छन्!', 'सेल रोटी चाडपर्वमा किन बनाइन्छ?', '[\"यो बाँड्न मिल्ने विशेष मिठाई हो\", \"यो बनाउन सजिलो छ\", \"यो मात्र उपलब्ध मिठाई हो\", \"यो धेरै सस्तो छ\"]', 'सेल रोटी कुन चाडपर्वहरूमा बनाइन्छ?', '[\"दशैं\", \"तिहार\", \"दुवै\", \"कुनै पनि होइन\"]', 'सेल रोटी दशैं र तिहारमा बनाइने विशेष मीठो परिकार हो। यो बाहिरबाट कुरकुरे, भित्रबाट नरम, र परिवार र छिमेकीहरूसँग बाँडिन्छ – यो एउटा स्वादिष्ट चाडपर्व परम्परा हो!', NULL, NULL, '2026-08-09 07:13:18'),
(22, 8, 2, 'The one-horned rhinoceros is one of the rarest animals on Earth – you can only find it in Nepal and India! It has one horn that can grow up to 60 cm long. In Chitwan National Park, you can see them grazing in the grasslands like giant prehistoric creatures!', 'Why is the one-horned rhinoceros so rare and special?', '[\"It only lives in Nepal and India\", \"It has a long horn\", \"It is very big\", \"It is very fast\"]', 0, 'Which national park is famous for the one-horned rhinoceros?', '[\"Sagarmatha\", \"Chitwan\", \"Bardiya\", \"Langtang\"]', 1, 'The one-horned rhino is found only in Nepal and India, making it incredibly rare. Chitwan National Park is the best place to see these magnificent creatures in the wild!', 'एकसिङ्गे गैंडा पृथ्वीको सबैभन्दा दुर्लभ जनावरहरूमध्ये एक हो – तपाईं यसलाई नेपाल र भारतमा मात्र फेला पार्न सक्नुहुन्छ! यसको एउटा सिङ हुन्छ जो ६० सेन्टिमिटरसम्म लामो हुन सक्छ। चितवन राष्ट्रिय निकुञ्जमा, तपाईं तिनीहरूलाई विशाल प्रागैतिहासिक प्राणीहरू जस्तै घाँसे मैदानमा चर्दै देख्न सक्नुहुन्छ!', 'एकसिङ्गे गैंडा किन यति दुर्लभ र विशेष छ?', '[\"यो नेपाल र भारतमा मात्र बस्छ\", \"यसको लामो सिङ छ\", \"यो धेरै ठूलो छ\", \"यो धेरै छिटो छ\"]', 'एकसिङ्गे गैंडाको लागि कुन राष्ट्रिय निकुञ्ज प्रसिद्ध छ?', '[\"सगरमाथा\", \"चितवन\", \"बर्दिया\", \"लाङटाङ\"]', 'एकसिङ्गे गैंडा नेपाल र भारतमा मात्र पाइन्छ, जसले यसलाई अत्यन्तै दुर्लभ बनाउँछ। चितवन राष्ट्रिय निकुञ्ज यी भव्य प्राणीहरूलाई जंगलमा हेर्नको लागि उत्तम स्थान हो!', NULL, NULL, '2026-08-09 07:13:18'),
(23, 8, 2, 'The Bengal tiger is one of the most powerful animals on Earth – a single tiger can weigh as much as 300 kg! Nepal has doubled its tiger population in recent years, making it one of the most successful conservation stories in the world!', 'Why is Nepal\'s tiger conservation success so important?', '[\"Tigers are important for the ecosystem\", \"Tigers are beautiful\", \"Tigers are friendly\", \"Tigers are fast\"]', 0, 'Where do Bengal tigers live in Nepal?', '[\"In the mountains\", \"In the Terai forests\", \"In the cities\", \"In the ocean\"]', 1, 'Nepal\'s tiger conservation is a global success story – the tiger population has doubled thanks to protection efforts. Tigers are top predators and keep the ecosystem balanced.', 'बंगाल बाघ पृथ्वीको सबैभन्दा शक्तिशाली जनावरहरूमध्ये एक हो – एउटा बाघको तौल ३०० किलोग्रामसम्म हुन सक्छ! नेपालले हालका वर्षहरूमा आफ्नो बाघको जनसंख्या दोब्बर बनाएको छ, जसले यसलाई विश्वको सबैभन्दा सफल संरक्षण कथाहरूमध्ये एक बनाएको छ!', 'नेपालको बाघ संरक्षण सफलता किन यति महत्वपूर्ण छ?', '[\"बाघहरू पारिस्थितिकी प्रणालीको लागि महत्वपूर्ण छन्\", \"बाघहरू सुन्दर छन्\", \"बाघहरू मित्रवत छन्\", \"बाघहरू छिटो छन्\"]', 'बंगाल बाघहरू नेपालमा कहाँ बस्छन्?', '[\"पहाडमा\", \"तराईका जंगलहरूमा\", \"सहरहरूमा\", \"समुद्रमा\"]', 'नेपालको बाघ संरक्षण विश्वव्यापी सफलताको कथा हो – संरक्षण प्रयासहरूको कारण बाघको जनसंख्या दोब्बर भएको छ। बाघहरू शीर्ष शिकारी हुन् र पारिस्थितिकी प्रणाली सन्तुलित राख्छन्।', NULL, NULL, '2026-08-09 07:13:18'),
(24, 8, 2, 'The Koshi River is like a giant water snake! It flows all the way from the Himalayas to India, where it forms a huge delta. The river provides water for millions of people and is home to hundreds of fish species. The river is so important that people call it the \"lifeline of the Terai\"!', 'Why is the Koshi River called the \"lifeline of the Terai\"?', '[\"It provides water for farming and daily life\", \"It has many fish\", \"It is a tourist attraction\", \"It is very long\"]', 0, 'Which river is known as the \"lifeline of the Terai\"?', '[\"Koshi\", \"Gandaki\", \"Karnali\", \"Bagmati\"]', 0, 'The Koshi River is called the lifeline of the Terai because it provides water for farming, drinking, and daily life for millions of people in the region.', 'कोशी नदी विशाल पानीको सर्प जस्तै हो! यो हिमालयदेखि भारतसम्म बग्छ, जहाँ यसले विशाल डेल्टा बनाउँछ। नदीले लाखौं मानिसहरूलाई पानी प्रदान गर्छ र सयौं माछा प्रजातिहरूको घर हो। नदी यति महत्वपूर्ण छ कि मानिसहरू यसलाई \"तराईको जीवन रेखा\" भन्छन्!', 'कोशी नदीलाई \"तराईको जीवन रेखा\" किन भनिन्छ?', '[\"यसले खेती र दैनिक जीवनको लागि पानी प्रदान गर्छ\", \"यसमा धेरै माछाहरू छन्\", \"यो पर्यटक आकर्षण हो\", \"यो धेरै लामो छ\"]', 'कुन नदीलाई \"तराईको जीवन रेखा\" भनिन्छ?', '[\"कोशी\", \"गण्डकी\", \"कर्णाली\", \"बागमती\"]', 'कोशी नदीलाई तराईको जीवन रेखा भनिन्छ किनभने यसले क्षेत्रका लाखौं मानिसहरूको खेती, पिउने, र दैनिक जीवनको लागि पानी प्रदान गर्छ।', NULL, NULL, '2026-08-09 07:13:18'),
(25, 9, 2, 'Lumbini is the birthplace of Lord Buddha – the founder of Buddhism! It\'s a sacred place where people from all over the world come to meditate. The site has a beautiful garden with a pond where Buddha is said to have bathed after his birth. It\'s one of the most peaceful places on Earth!', 'Why is Lumbini so special to Buddhists worldwide?', '[\"It\'s where Buddha was born\", \"It\'s where he died\", \"It\'s a tourist attraction\", \"It\'s a city\"]', 0, 'Which city is known as the birthplace of Lord Buddha?', '[\"Kathmandu\", \"Lumbini\", \"Pokhara\", \"Biratnagar\"]', 1, 'Lumbini is where Lord Buddha was born over 2,500 years ago. It\'s one of the most sacred places for Buddhists and a UNESCO World Heritage Site.', 'लुम्बिनी भगवान बुद्धको जन्मस्थल हो – बुद्ध धर्मका संस्थापक! यो पवित्र स्थान हो जहाँ विश्वभरका मानिसहरू ध्यान गर्न आउँछन्। यस स्थानमा एउटा सुन्दर बगैंचा र पोखरी छ जहाँ बुद्धले जन्मपछि स्नान गरेको भनिन्छ। यो पृथ्वीको सबैभन्दा शान्त स्थानहरूमध्ये एक हो!', 'लुम्बिनी विश्वभरका बौद्धहरूको लागि किन यति विशेष छ?', '[\"यो बुद्ध जन्मेको ठाउँ हो\", \"यो उनी मरेको ठाउँ हो\", \"यो पर्यटक आकर्षण हो\", \"यो सहर हो\"]', 'भगवान बुद्धको जन्मस्थलको रूपमा कुन सहर चिनिन्छ?', '[\"काठमाडौं\", \"लुम्बिनी\", \"पोखरा\", \"विराटनगर\"]', 'लुम्बिनी २,५०० वर्षभन्दा पहिले भगवान बुद्ध जन्मेको ठाउँ हो। यो बौद्धहरूको लागि सबैभन्दा पवित्र स्थानहरूमध्ये एक हो र युनेस्को विश्व सम्पदा स्थल हो।', NULL, NULL, '2026-08-09 07:13:18'),
(26, 9, 2, 'Nepal is like a giant museum of culture! Over 120 languages are spoken in the country – that\'s almost one language for every 250,000 people! Each ethnic group has its own unique traditions, clothing, and food. It\'s like visiting 100 different countries all in one place!', 'Why is Nepal called a \"melting pot\" of cultures?', '[\"It has many ethnic groups and languages\", \"It has many tourists\", \"It has many temples\", \"It has many cities\"]', 0, 'Approximately how many languages are spoken in Nepal?', '[\"30\", \"120\", \"200\", \"300\"]', 1, 'Nepal is incredibly diverse – over 120 languages and many ethnic groups live together, each with their own unique traditions, clothing, and food.', 'नेपाल संस्कृतिको विशाल संग्रहालय जस्तै हो! देशमा १२० भन्दा बढी भाषाहरू बोलिन्छन् – यो प्रत्येक २,५०,००० मानिसको लागि लगभग एउटा भाषा हो! प्रत्येक जातीय समूहको आफ्नै अद्वितीय परम्परा, लुगा, र खाना छ। यो एउटै ठाउँमा १०० विभिन्न देशहरू भ्रमण गर्नु जस्तै हो!', 'नेपाललाई संस्कृतिको \"पग्लने भाँडो\" किन भनिन्छ?', '[\"यहाँ धेरै जातीय समूह र भाषाहरू छन्\", \"यहाँ धेरै पर्यटकहरू छन्\", \"यहाँ धेरै मन्दिरहरू छन्\", \"यहाँ धेरै सहरहरू छन्\"]', 'नेपालमा लगभग कति भाषाहरू बोलिन्छन्?', '[\"३०\", \"१२०\", \"२००\", \"३००\"]', 'नेपाल अत्यन्तै विविधतापूर्ण छ – १२० भन्दा बढी भाषाहरू र धेरै जातीय समूहहरू एकसाथ बस्छन्, प्रत्येकको आफ्नै अद्वितीय परम्परा, लुगा, र खाना छ।', NULL, NULL, '2026-08-09 07:13:18'),
(27, 9, 2, 'Nepal\'s temples and palaces are so special that UNESCO protects them! The temples are decorated with intricate carvings of gods, goddesses, and mythical creatures. Some temples even have statues with multiple arms and heads – they look like they\'re from a fantasy movie! They\'re more than 1,000 years old!', 'Why are Nepal\'s temples and palaces protected by UNESCO?', '[\"They are very beautiful\", \"They have cultural and historical significance\", \"They are tourist attractions\", \"They are very tall\"]', 1, 'How old are some of Nepal\'s temples?', '[\"100 years\", \"500 years\", \"More than 1,000 years\", \"More than 2,000 years\"]', 2, 'Nepal\'s temples and palaces are protected by UNESCO because they are incredibly old, beautiful, and culturally significant. Some are more than 1,000 years old!', 'नेपालका मन्दिर र दरबारहरू यति विशेष छन् कि युनेस्कोले तिनीहरूको संरक्षण गर्छ! मन्दिरहरू देवी-देवता र पौराणिक प्राणीहरूका जटिल नक्काशीहरूले सजिएका छन्। केही मन्दिरहरूमा धेरै हात र टाउका भएका मूर्तिहरू पनि छन् – तिनीहरू काल्पनिक चलचित्रबाट आएको जस्तो देखिन्छन्! तिनीहरू १,००० वर्षभन्दा पुराना छन्!', 'नेपालका मन्दिर र दरबारहरू युनेस्कोद्वारा किन संरक्षित गरिएका छन्?', '[\"तिनीहरू धेरै सुन्दर छन्\", \"तिनीहरूको सांस्कृतिक र ऐतिहासिक महत्व छ\", \"तिनीहरू पर्यटक आकर्षण हुन्\", \"तिनीहरू धेरै अग्ला छन्\"]', 'नेपालका केही मन्दिरहरू कति पुराना छन्?', '[\"१०० वर्ष\", \"५०० वर्ष\", \"१,००० वर्षभन्दा बढी\", \"२,००० वर्षभन्दा बढी\"]', 'नेपालका मन्दिर र दरबारहरू युनेस्कोद्वारा संरक्षित छन् किनभने तिनीहरू अत्यन्तै पुराना, सुन्दर, र सांस्कृतिक रूपमा महत्वपूर्ण छन्। केही १,००० वर्षभन्दा पुराना छन्!', NULL, NULL, '2026-08-09 07:13:18');

-- --------------------------------------------------------

--
-- Table structure for table `capybara_level_scores`
--

CREATE TABLE `capybara_level_scores` (
  `child_id` int(11) NOT NULL,
  `level_number` int(11) NOT NULL,
  `coins_earned` int(11) NOT NULL DEFAULT 0,
  `oranges_collected` int(11) NOT NULL DEFAULT 0,
  `knowledge_mastered` int(11) NOT NULL DEFAULT 0,
  `completed` tinyint(1) NOT NULL DEFAULT 0,
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `last_played` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `capybara_level_scores`
--

INSERT INTO `capybara_level_scores` (`child_id`, `level_number`, `coins_earned`, `oranges_collected`, `knowledge_mastered`, `completed`, `started_at`, `completed_at`, `last_played`) VALUES
(1, 1, 204, 6, 3, 0, '2026-09-12 08:45:00', NULL, '2026-09-12 08:45:00'),
(1, 2, 204, 6, 3, 1, '2026-09-09 15:06:35', NULL, '2026-09-09 15:06:35');

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
  `total_stars` int(11) NOT NULL DEFAULT 0,
  `current_level` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `children`
--

INSERT INTO `children` (`child_id`, `parent_id`, `username`, `age`, `mascot_id`, `total_coins`, `total_stars`, `current_level`, `created_at`) VALUES
(1, 1, 'testkid', 5, 1, 608, 0, 1, '2026-08-11 14:16:34'),
(9, 22, 'jeli_22', 9, 8, 190, 0, 2, '2026-09-09 09:39:36'),
(21, 21, 'arch_21', 8, 7, 0, 0, 1, '2026-08-21 08:35:01'),
(23, 23, 'jelshi_23', 4, 6, 0, 0, 1, '2026-09-09 09:47:54'),
(24, 24, 'anup_24', 7, 7, 19, 0, 1, '2026-09-09 09:51:00'),
(25, 25, 'nikhil_25', 6, 1, 0, 0, 1, '2026-09-09 09:59:46'),
(26, 26, 'sunny_26', 10, 2, 0, 0, 1, '2026-09-09 16:47:11'),
(27, 27, 'jejyurai_27', 5, 6, 32, 0, 1, '2026-09-12 08:40:54');

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
(3, 9, 2, '2026-09-03 14:41:42'),
(21, 9, 5, '2026-09-12 05:32:08'),
(22, 9, 7, '2026-09-12 05:32:08'),
(23, 9, 8, '2026-09-12 05:32:08'),
(24, 9, 4, '2026-09-12 05:32:12'),
(25, 9, 9, '2026-09-12 05:32:12'),
(26, 9, 19, '2026-09-12 05:39:49'),
(27, 1, 1, '2026-09-12 08:45:00'),
(28, 1, 7, '2026-09-12 08:45:00'),
(29, 1, 11, '2026-09-12 08:45:00'),
(30, 1, 12, '2026-09-12 08:45:01'),
(31, 1, 13, '2026-09-12 08:45:01'),
(32, 1, 14, '2026-09-12 08:45:01'),
(33, 1, 15, '2026-09-12 08:45:01'),
(34, 1, 17, '2026-09-12 08:45:01'),
(35, 1, 19, '2026-09-12 08:45:01'),
(36, 27, 1, '2026-09-12 08:46:02'),
(37, 27, 2, '2026-09-12 08:46:02'),
(38, 27, 7, '2026-09-12 08:48:12');

-- --------------------------------------------------------

--
-- Table structure for table `child_flashcard_card_progress`
--

CREATE TABLE `child_flashcard_card_progress` (
  `child_id` int(11) NOT NULL,
  `card_id` int(11) NOT NULL,
  `flipped_count` int(11) NOT NULL DEFAULT 0,
  `stars_earned` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `child_flashcard_question_progress`
--

CREATE TABLE `child_flashcard_question_progress` (
  `child_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `correct_attempts` int(11) NOT NULL DEFAULT 0,
  `stars_earned` int(11) NOT NULL DEFAULT 0,
  `coins_earned` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
-- Table structure for table `child_game_intro`
--

CREATE TABLE `child_game_intro` (
  `child_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `seen_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `child_game_intro`
--

INSERT INTO `child_game_intro` (`child_id`, `game_id`, `seen_at`) VALUES
(9, 1, '2026-09-12 14:02:29'),
(27, 1, '2026-09-12 14:30:33');

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
-- Table structure for table `coin_transactions`
--

CREATE TABLE `coin_transactions` (
  `transaction_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `source` enum('game','badge','purchase','daily_bonus','capybara_fruit','capybara_think','capybara_apply','capybara_level_complete','other') NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coin_transactions`
--

INSERT INTO `coin_transactions` (`transaction_id`, `child_id`, `amount`, `source`, `reference_id`, `description`, `created_at`) VALUES
(3, 1, 204, 'capybara_level_complete', NULL, 'Level 2 completed with 204 coins, 3/3 facts mastered', '2026-09-09 15:06:35'),
(4, 9, 5, 'game', NULL, 'Spelled \'APPLE\' in Level A', '2026-09-10 07:44:57'),
(5, 9, 5, 'game', NULL, 'Spelled \'ANT\' in Level A', '2026-09-10 07:45:09'),
(6, 9, 5, 'game', NULL, 'Spelled \'AIRPLANE\' in Level A', '2026-09-12 08:18:24'),
(7, 27, 5, 'game', NULL, 'Spelled \'APPLE\' in Level A', '2026-09-12 08:48:12');

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
(7, 'daily_streak', 'Played on threshold_value consecutive days'),
(8, 'oranges_collected', 'Total oranges collected across all levels meets threshold_value'),
(9, 'total_coins', 'Total coins balance meets threshold_value');

-- --------------------------------------------------------

--
-- Table structure for table `flashcard_cards`
--

CREATE TABLE `flashcard_cards` (
  `card_id` int(11) NOT NULL,
  `deck_id` int(11) NOT NULL,
  `card_icon` varchar(10) NOT NULL,
  `name_en` varchar(100) NOT NULL,
  `name_ne` varchar(100) NOT NULL,
  `subtitle_en` varchar(100) DEFAULT NULL,
  `subtitle_ne` varchar(100) DEFAULT NULL,
  `tag_en` varchar(50) DEFAULT NULL,
  `tag_ne` varchar(50) DEFAULT NULL,
  `facts_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`facts_en`)),
  `facts_ne` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`facts_ne`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flashcard_cards`
--

INSERT INTO `flashcard_cards` (`card_id`, `deck_id`, `card_icon`, `name_en`, `name_ne`, `subtitle_en`, `subtitle_ne`, `tag_en`, `tag_ne`, `facts_en`, `facts_ne`) VALUES
(4001, 1, '☀️', 'The Sun', 'सूर्य', 'Our Star', 'हाम्रो तारा', 'Star', 'तारा', '[\"The Sun gives us light and heat – it\'s a big, bright star!\",\"It\'s so huge that 1 million Earths could fit inside!\",\"The Sun is about 5,500°C on the surface – that\'s super hot!\"]', '[\"सूर्यले हामीलाई उज्यालो र गर्मी दिन्छ – यो एउटा ठूलो, चम्किलो तारा हो!\",\"यति ठूलो छ कि १० लाख पृथ्वीहरू यसको भित्र अटाउन सक्छन्!\",\"सूर्यको सतहको तापक्रम करिब ५,५००°C छ – त्यो धेरै तातो हो!\"]'),
(4002, 1, '☿', 'Mercury', 'बुध', 'The Swift Planet', 'छिटो ग्रह', 'Terrestrial', 'स्थलीय', '[\"Mercury is the tiniest planet and the closest to the Sun!\",\"It has almost no air, so days are boiling hot and nights are freezing cold!\",\"A year on Mercury is just 88 Earth days – super short!\"]', '[\"बुध सबैभन्दा सानो ग्रह हो र सूर्यको सबैभन्दा नजिक छ!\",\"यहाँ लगभग हावा छैन, त्यसैले दिनमा धेरै तातो र रातमा धेरै चिसो हुन्छ!\",\"बुधको एक वर्ष जम्मा ८८ पृथ्वी दिन हो – धेरै छोटो!\"]'),
(4003, 1, '♀', 'Venus', 'शुक्र', 'The Evening Star', 'साँझको तारा', 'Terrestrial', 'स्थलीय', '[\"Venus is the hottest planet – even hotter than Mercury!\",\"It spins backwards – the Sun rises in the west and sets in the east!\",\"Its thick clouds are made of acid – yikes!\"]', '[\"शुक्र सबैभन्दा तातो ग्रह हो – बुधभन्दा पनि तातो!\",\"यो उल्टो घुम्छ – सूर्य पश्चिममा उदाउँछ र पूर्वमा अस्ताउँछ!\",\"यसको बाक्लो बादलहरू एसिडले बनेका छन् – ओहो!\"]'),
(4004, 1, '🌍', 'Earth', 'पृथ्वी', 'The Blue Marble', 'निलो संगमरमर', 'Terrestrial', 'स्थलीय', '[\"Earth is the only planet we know that has life!\",\"About 71% of Earth is covered with water – that\'s why it looks blue!\",\"We have one moon that lights up our night sky.\"]', '[\"पृथ्वी मात्र त्यो ग्रह हो जहाँ जीवन छ!\",\"पृथ्वीको करिब ७१% पानीले ढाकिएको छ – त्यसैले यो निलो देखिन्छ!\",\"हामीसँग एउटा चन्द्रमा छ जसले रातको आकाश उज्यालो बनाउँछ।\"]'),
(4005, 1, '♂', 'Mars', 'मंगल', 'The Red Planet', 'रातो ग्रह', 'Terrestrial', 'स्थलीय', '[\"Mars is called the Red Planet because of rusty iron on its surface!\",\"It has the tallest volcano in the solar system – Olympus Mons!\",\"Mars has two tiny moons: Phobos and Deimos.\"]', '[\"मंगललाई रातो ग्रह भनिन्छ किनभने यसको सतहमा खिया लागेको फलाम छ!\",\"यसमा सौर्यमण्डलको सबैभन्दा अग्लो ज्वालामुखी छ – ओलम्पस मोन्स!\",\"मंगलका दुई साना चन्द्रमा छन्: फोबोस र डेमोस।\"]'),
(4006, 1, '🌙', 'The Moon', 'चन्द्रमा', 'Earth\'s Companion', 'पृथ्वीको साथी', 'Moon', 'चन्द्रमा', '[\"The Moon is Earth\'s only natural satellite – it orbits around us!\",\"It\'s about 384,400 km away – that\'s far but we can see it every night!\",\"There\'s no air on the Moon, so footprints stay forever!\"]', '[\"चन्द्रमा पृथ्वीको एकमात्र प्राकृतिक उपग्रह हो – यो हाम्रो वरिपरि घुम्छ!\",\"यो करिब ३,८४,४०० किमी टाढा छ – त्यो धेरै टाढा तर हामी यसलाई हरेक रात देख्न सक्छौं!\",\"चन्द्रमामा हावा छैन, त्यसैले पाइलाका छाप सधैं रहन्छन्!\"]'),
(4007, 1, '🧊', 'States of Matter', 'पदार्थका अवस्थाहरू', 'Solid, Liquid, Gas', 'ठोस, तरल, ग्यास', 'Science', 'विज्ञान', '[\"Solids keep their shape – like ice cubes and rocks!\",\"Liquids flow and take the shape of their container – like water and milk!\",\"Gases fill up any space – like the air we breathe!\",\"Heating or cooling can change matter from one state to another – cool, right?\"]', '[\"ठोस पदार्थहरू आफ्नो आकार राख्छन् – जस्तै बरफका टुक्रा र ढुङ्गा!\",\"तरल पदार्थ बग्छन् र भाँडाको आकार लिन्छन् – जस्तै पानी र दूध!\",\"ग्यासहरू कुनै पनि ठाउँ भर्छन् – जस्तै हामीले सास फेर्ने हावा!\",\"तातो वा चिसोले पदार्थको अवस्था परिवर्तन गर्न सक्छ – रमाइलो, हैन?\"]'),
(4008, 1, '💧', 'The Water Cycle', 'पानीको चक्र', 'Water on the Move', 'पानीको गतिशीलता', 'Nature', 'प्रकृति', '[\"Evaporation: the Sun heats water and turns it into vapor!\",\"Condensation: vapor cools and makes clouds!\",\"Precipitation: water falls back as rain or snow!\",\"Collection: water gathers in rivers, lakes, and oceans – and the cycle starts again!\"]', '[\"वाष्पीकरण: सूर्यले पानीलाई तताउँछ र वाष्प बनाउँछ!\",\"संघनन: वाष्प चिसो हुन्छ र बादल बनाउँछ!\",\"वर्षा: पानी फेरि वर्षा वा हिउँको रूपमा खस्छ!\",\"सङ्कलन: पानी नदी, ताल र महासागरमा जम्मा हुन्छ – र चक्र फेरि सुरु हुन्छ!\"]'),
(4009, 1, '🌱', 'Plant Parts', 'बोटका भागहरू', 'Roots, Stem, Leaves, Flowers', 'जरा, डाँठ, पात, फूल', 'Nature', 'प्रकृति', '[\"Roots hold the plant in the ground and drink water and minerals!\",\"Stems stand tall and carry food and water around the plant!\",\"Leaves are like little kitchens – they make food using sunlight!\",\"Flowers are the pretty part – they make seeds for new plants!\"]', '[\"जराले बोटलाई जमिनमा टाँस्छ र पानी र खनिज पिउँछ!\",\"डाँठले बोटलाई उभ्याउँछ र खाना र पानी बोटभरि पुर्याउँछ!\",\"पातहरू सानो भान्सा जस्तै हुन् – तिनीहरूले सूर्यको प्रकाश प्रयोग गरेर खाना बनाउँछन्!\",\"फूलहरू सुन्दर भाग हुन् – तिनीहरूले नयाँ बोटका लागि बीउ बनाउँछन्!\"]'),
(4010, 1, '👁️', 'The Five Senses', 'पाँच इन्द्रियहरू', 'See, Hear, Smell, Taste, Touch', 'देख्नु, सुन्नु, सुँघ्नु, स्वाद लिनु, छुनु', 'Science', 'विज्ञान', '[\"Sight – our eyes help us see colors, shapes, and faces!\",\"Hearing – our ears catch sounds and music!\",\"Smell – our nose picks up yummy and yucky smells!\",\"Taste – our tongue tastes sweet, sour, salty, bitter, and umami!\",\"Touch – our skin feels things like soft, rough, hot, and cold!\"]', '[\"दृष्टि – हाम्रा आँखाले रंग, आकार र अनुहार देख्न मद्दत गर्छ!\",\"श्रवण – हाम्रा कानले आवाज र संगीत सुन्छन्!\",\"घ्राण – हाम्रो नाकले मीठो र फोहोर गन्ध पत्ता लगाउँछ!\",\"स्वाद – हाम्रो जिब्रोले मीठो, अमिलो, नुनिलो, तीतो र उमामी स्वाद लिन्छ!\",\"स्पर्श – हाम्रो छालाले नरम, नराम्रो, तातो र चिसो महसुस गर्छ!\"]'),
(4011, 1, '☀️', 'Weather Types', 'मौसम प्रकार', 'Sunny, Rainy, Cloudy, Snowy', 'घाम, वर्षा, बादली, हिउँ', 'Nature', 'प्रकृति', '[\"Sunny – bright and warm, great for playing outside!\",\"Rainy – water drops fall from clouds, don\'t forget your umbrella!\",\"Cloudy – the sky is covered with clouds, sometimes it rains!\",\"Snowy – ice crystals fall as snowflakes, perfect for snowmen!\",\"Weather changes how we dress and what we do every day!\"]', '[\"घाम – उज्यालो र न्यानो, बाहिर खेल्नको लागि उत्तम!\",\"वर्षा – बादलबाट पानीका थोपा खस्छन्, आफ्नो छाता नबिर्सनुहोस्!\",\"बादली – आकाश बादलले ढाकिएको छ, कहिलेकाहीँ वर्षा हुन्छ!\",\"हिउँ – बरफका क्रिस्टल हिउँका फोका जस्तै खस्छन्, हिउँमानिस बनाउन उत्तम!\",\"मौसमले हाम्रो पहिरन र हामीले दैनिक के गर्छौं भनेर परिवर्तन गर्छ!\"]'),
(4012, 1, '🌿', 'Living vs Non-Living', 'जीवित र निर्जीव', 'What is alive?', 'के जीवित छ?', 'Science', 'विज्ञान', '[\"Living things grow, need food, and can have babies – like plants and animals!\",\"People, dogs, and trees are living things.\",\"Non-living things don\'t grow or need food – like rocks, chairs, and toys!\",\"Living things react to changes around them – like a plant bending toward the sun!\"]', '[\"जीवित चीजहरू बढ्छन्, खाना चाहिन्छ र बच्चा जन्माउँछन् – जस्तै बोट र जनावर!\",\"मानिस, कुकुर र रूखहरू जीवित चीजहरू हुन्।\",\"निर्जीव चीजहरू बढ्दैनन् र खाना चाहिँदैन – जस्तै ढुङ्गा, कुर्सी र खेलौना!\",\"जीवित चीजहरू आफ्नो वरपरको परिवर्तनमा प्रतिक्रिया दिन्छन् – जस्तै सूर्यतिर झुकेको बोट!\"]'),
(4013, 2, '♃', 'Jupiter', 'बृहस्पति', 'The Giant', 'विशाल', 'Gas Giant', 'ग्यासको विशाल', '[\"Jupiter is the biggest planet – you could fit 1,300 Earths inside!\",\"It has a giant storm called the Great Red Spot – it\'s bigger than Earth!\",\"Jupiter has 79 known moons – that\'s a lot of friends!\"]', '[\"बृहस्पति सबैभन्दा ठूलो ग्रह हो – यसको भित्र १३०० पृथ्वीहरू अटाउन सक्छन्!\",\"यसमा ठूलो आँधी छ जसलाई ठूलो रातो धब्बा भनिन्छ – यो पृथ्वीभन्दा ठूलो छ!\",\"बृहस्पतिसँग ७९ ज्ञात चन्द्रमा छन् – त्यो धेरै साथीहरू!\"]'),
(4014, 2, '♄', 'Saturn', 'शनि', 'The Ringed World', 'वलय भएको संसार', 'Gas Giant', 'ग्यासको विशाल', '[\"Saturn has beautiful rings made of ice and rock – they sparkle!\",\"Saturn is so light that it would float in a giant bathtub – weird, right?\",\"It has 82 known moons – the most in the solar system!\"]', '[\"शनिसँग बरफ र ढुङ्गाले बनेका सुन्दर वलय छन् – तिनीहरू चम्किन्छन्!\",\"शनि यति हलुका छ कि यो एउटा विशाल नुहाउने टबमा पौडिन सक्छ – अनौठो, हैन?\",\"यससँग ८२ ज्ञात चन्द्रमा छन् – सौर्यमण्डलमा सबैभन्दा धेरै!\"]'),
(4015, 2, '⛢', 'Uranus', 'युरेनस', 'The Sideways Planet', 'छेउको ग्रह', 'Ice Giant', 'बरफको विशाल', '[\"Uranus spins on its side – almost like a rolling ball!\",\"It\'s the coldest planet – -224°C, brrr!\",\"It has 27 known moons, all named after Shakespeare characters!\"]', '[\"युरेनस आफ्नो छेउमा घुम्छ – लगभग एउटा बल जस्तै!\",\"यो सबैभन्दा चिसो ग्रह हो – -२२४°C, हिउँ!\",\"यससँग २७ ज्ञात चन्द्रमा छन्, सबै शेक्सपियरका पात्रहरूको नाममा!\"]'),
(4016, 2, '♆', 'Neptune', 'नेप्च्युन', 'The Windy World', 'हावायुक्त संसार', 'Ice Giant', 'बरफको विशाल', '[\"Neptune is the windiest planet – winds blow at 2,100 km/h!\",\"It\'s the farthest planet from the Sun – very cold and dark!\",\"It has 14 known moons, with the largest named Triton.\"]', '[\"नेप्च्युन सबैभन्दा हावायुक्त ग्रह हो – हावा २,१०० किमी/घण्टाको गतिले बहन्छ!\",\"यो सूर्यबाट सबैभन्दा टाढाको ग्रह हो – धेरै चिसो र अँधेरो!\",\"यससँग १४ ज्ञात चन्द्रमा छन्, सबैभन्दा ठूलोको नाम ट्राइटन हो।\"]'),
(4017, 2, '☄️', 'Asteroid Belt', 'क्षुद्रग्रह घेरा', 'Between Mars & Jupiter', 'मंगल र बृहस्पतिबीच', 'Belt', 'घेरा', '[\"The asteroid belt is a huge ring of rocks between Mars and Jupiter!\",\"There are millions of asteroids – some are tiny, some are huge!\",\"The biggest one is Ceres – it\'s a dwarf planet!\"]', '[\"क्षुद्रग्रह घेरा मंगल र बृहस्पतिबीच ढुङ्गाहरूको विशाल घेरा हो!\",\"त्यहाँ लाखौं क्षुद्रग्रहहरू छन् – कोही साना, कोही ठूला!\",\"सबैभन्दा ठूलो सेरेस हो – यो एउटा बौना ग्रह हो!\"]'),
(4018, 2, '🪐', 'Pluto', 'प्लुटो', 'Dwarf Planet', 'बौना ग्रह', 'Dwarf Planet', 'बौना ग्रह', '[\"Pluto is a dwarf planet – it\'s smaller than our Moon!\",\"It has 5 moons – the biggest one is Charon, almost as big as Pluto!\",\"Pluto was reclassified as a dwarf planet in 2006 – poor Pluto!\"]', '[\"प्लुटो एउटा बौना ग्रह हो – यो हाम्रो चन्द्रमाभन्दा सानो छ!\",\"यससँग ५ चन्द्रमा छन् – सबैभन्दा ठूलो चारोन हो, लगभग प्लुटो जति ठूलो!\",\"प्लुटोलाई २००६ मा बौना ग्रहको रूपमा पुन: वर्गीकृत गरियो – गरिब प्लुटो!\"]'),
(4019, 2, '🌱', 'Photosynthesis', 'प्रकाश संश्लेषण', 'How Plants Make Food', 'बोटबिरुवाले कसरी खाना बनाउँछन्', 'Science', 'विज्ञान', '[\"Plants use sunlight, water, and CO₂ to make their own food!\",\"The green stuff in leaves – chlorophyll – catches sunlight!\",\"Plants release oxygen – that\'s the air we breathe!\",\"Without plants, we wouldn\'t have any oxygen – thank you, plants!\"]', '[\"बोटबिरुवाले आफ्नो खाना बनाउन सूर्यको प्रकाश, पानी र CO₂ प्रयोग गर्छन्!\",\"पातको हरियो भाग – क्लोरोफिल – सूर्यको प्रकाश समात्छ!\",\"बोटबिरुवाले अक्सिजन छोड्छन् – त्यो हामीले सास फेर्ने हावा हो!\",\"बोटबिरुवा नभएको भए हामीसँग अक्सिजन हुँदैन – धन्यवाद, बोटबिरुवा!\"]'),
(4020, 2, '🐾', 'Food Chains', 'खाद्य शृंखला', 'Who Eats Whom?', 'कसले कसलाई खान्छ?', 'Nature', 'प्रकृति', '[\"Producers – like plants – make their own food from sunlight!\",\"Consumers – like rabbits and foxes – eat other living things!\",\"Decomposers – like fungi and bacteria – break down dead things!\",\"A food chain shows how energy flows in nature – it\'s all connected!\"]', '[\"उत्पादकहरू – जस्तै बोट – सूर्यको प्रकाशबाट आफ्नो खाना बनाउँछन्!\",\"उपभोक्ताहरू – जस्तै खरायो र फ्याक्स – अरू जीवित चीजहरू खान्छन्!\",\"विघटनकर्ताहरू – जस्तै फङ्गस र ब्याक्टेरिया – मरेका चीजहरू विघटन गर्छन्!\",\"खाद्य शृंखलाले प्रकृतिमा ऊर्जा कसरी प्रवाह हुन्छ देखाउँछ – यो सबै जोडिएको छ!\"]'),
(4021, 2, '🧠', 'Human Body Systems', 'मानव शरीर प्रणाली', 'How We Work', 'हामी कसरी काम गर्छौं', 'Science', 'विज्ञान', '[\"Skeletal system – bones support us and protect our insides!\",\"Muscular system – muscles let us run, jump, and play!\",\"Digestive system – it breaks down food so we get energy!\",\"Respiratory system – our lungs take in oxygen and let out CO₂!\",\"All systems work together – teamwork makes the body work!\"]', '[\"कंकाल प्रणाली – हड्डीहरूले हामीलाई सहारा दिन्छन् र भित्री अंगहरूको सुरक्षा गर्छन्!\",\"मांसपेशी प्रणाली – मांसपेशीले हामीलाई दौडन, हामफाल्न र खेल्न दिन्छ!\",\"पाचन प्रणाली – यसले खानालाई पचाउँछ ताकि हामीलाई ऊर्जा मिलोस्!\",\"श्वसन प्रणाली – हाम्रो फोक्सोले अक्सिजन लिन्छ र CO₂ बाहिर निकाल्छ!\",\"सबै प्रणालीहरू मिलेर काम गर्छन् – टोली कार्यले शरीर काम गर्छ!\"]'),
(4022, 2, '🌍', 'Ecosystems', 'पारिस्थितिकी तंत्र', 'Nature\'s Communities', 'प्रकृतिका समुदायहरू', 'Nature', 'प्रकृति', '[\"An ecosystem is a community of living and non-living things!\",\"Forests, deserts, oceans, and grasslands are all ecosystems!\",\"Each ecosystem has its own plants, animals, and weather!\",\"Living things depend on each other – it\'s like a big family!\"]', '[\"पारिस्थितिकी तंत्र भनेको जीवित र निर्जीव चीजहरूको समुदाय हो!\",\"वन, मरुभूमि, महासागर र घाँसे मैदानहरू सबै पारिस्थितिकी तंत्र हुन्!\",\"प्रत्येक पारिस्थितिकी तंत्रको आफ्नै बोटबिरुवा, जनावर र मौसम हुन्छ!\",\"जीवित चीजहरू एकअर्कामा निर्भर हुन्छन् – यो ठूलो परिवार जस्तै हो!\"]'),
(4023, 2, '🐾', 'Animal Classification', 'जनावर वर्गीकरण', 'Mammals, Birds, Fish & More', 'स्तनधारी, चरा, माछा र अरू', 'Nature', 'प्रकृति', '[\"Mammals have fur or hair and feed milk to their babies – like lions and dogs!\",\"Birds have feathers, lay eggs, and many can fly – like eagles and penguins!\",\"Reptiles have scales and are cold-blooded – like snakes and turtles!\",\"Amphibians live on land and water – like frogs and salamanders!\",\"Fish live in water, have gills and fins – like sharks and salmon!\"]', '[\"स्तनधारीहरूको रौं वा कपाल हुन्छ र बच्चाहरूलाई दूध खुवाउँछन् – जस्तै सिंह र कुकुर!\",\"चराहरूमा प्वाँख हुन्छ, अण्डा पार्छन्, र धेरै उड्न सक्छन् – जस्तै चील र पेंगुइन!\",\"सरीसृपहरूमा स्केल हुन्छ र चिसो रगतका हुन्छन् – जस्तै सर्प र कछुवा!\",\"उभयचरहरू जमिन र पानीमा बस्छन् – जस्तै भ्यागुता र सलामन्डर!\",\"माछाहरू पानीमा बस्छन्, गिल र पखेटा हुन्छ – जस्तै शार्क र सामन!\"]'),
(4024, 2, '🌱', 'Plant Life Cycle', 'बोटको जीवन चक्र', 'From Seed to Flower', 'बीउदेखि फूलसम्म', 'Nature', 'प्रकृति', '[\"Seed – it\'s the start of a new plant, waiting to grow!\",\"Germination – the seed sprouts and sends roots down!\",\"Growth – the plant grows leaves and stems to catch sunlight!\",\"Reproduction – the plant makes flowers and new seeds!\",\"The cycle goes on as seeds spread to make new plants – nature\'s magic!\"]', '[\"बीउ – यो नयाँ बोटको सुरुवात हो, बढ्नको लागि पर्खिरहेको!\",\"अंकुरण – बीउ अंकुरिन्छ र जरा तल पठाउँछ!\",\"वृद्धि – बोटले सूर्यको प्रकाश समात्न पात र डाँठ उमार्छ!\",\"प्रजनन – बोटले फूल र नयाँ बीउ बनाउँछ!\",\"चक्र जारी रहन्छ किनभने बीउहरू फैलिएर नयाँ बोट बनाउँछन् – प्रकृतिको जादू!\"]'),
(4025, 3, '☀️', 'Solar Mass', 'सौर्य द्रव्यमान', '1.989 × 10³⁰ kg', '१.९८९ × १०³⁰ किग्रा', 'Star', 'तारा', '[\"The Sun is so heavy that it holds 99.86% of all the mass in our solar system!\",\"It would take 333,000 Earths to match the Sun\'s weight – wow!\",\"Every second, the Sun loses 4 million tons of mass as it shines – that\'s crazy!\"]', '[\"सूर्य यति भारी छ कि यसले हाम्रो सौर्यमण्डलको ९९.८६% द्रव्यमान समाउँछ!\",\"सूर्यको तौल बराबर गर्न ३,३३,००० पृथ्वीहरू चाहिन्छ – वाह!\",\"प्रत्येक सेकेन्ड, सूर्यले चम्किरहेको बेला ४ लाख टन द्रव्यमान गुमाउँछ – त्यो अचम्मको हो!\"]'),
(4026, 3, '☿', 'Mercury\'s Orbit', 'बुधको कक्षा', '88 Days, Eccentric', '८८ दिन, अण्डाकार', 'Terrestrial', 'स्थलीय', '[\"Mercury has the most oval-shaped orbit of all planets – it\'s not a perfect circle!\",\"Its distance from the Sun changes a lot – from 46 to 70 million km!\",\"Mercury zips around the Sun at 47.87 km/s – faster than any other planet!\"]', '[\"बुधको कक्षा सबैभन्दा अण्डाकार छ – यो पूरा वृत्त होइन!\",\"सूर्यबाट यसको दूरी धेरै परिवर्तन हुन्छ – ४६ देखि ७० मिलियन किमी!\",\"बुध सूर्यको वरिपरि ४७.८७ किमी/सेकेन्डको गतिमा घुम्छ – अरू कुनै ग्रहभन्दा छिटो!\"]'),
(4027, 3, '♀', 'Venus\' Rotation', 'शुक्रको घुमाव', '243 Days — Longer than Year', '२४३ दिन — वर्षभन्दा लामो', 'Terrestrial', 'स्थलीय', '[\"Venus takes 243 Earth days to spin once – that\'s longer than its year (225 days)!\",\"So a day on Venus is longer than a year – weird!\",\"It spins backwards, so the Sun rises in the west – that\'s topsy-turvy!\"]', '[\"शुक्रलाई एक पटक घुम्न २४३ पृथ्वी दिन लाग्छ – त्यो यसको वर्ष (२२५ दिन) भन्दा लामो छ!\",\"त्यसैले शुक्रमा एउटा दिन वर्षभन्दा लामो हुन्छ – अनौठो!\",\"यो उल्टो घुम्छ, त्यसैले सूर्य पश्चिममा उदाउँछ – त्यो उल्टो हुन्छ!\"]'),
(4028, 3, '🌍', 'Earth\'s Axial Tilt', 'पृथ्वीको अक्षीय झुकाव', '23.5° — Causes Seasons', '२३.५° — ऋतुहरूको कारण', 'Terrestrial', 'स्थलीय', '[\"Earth is tilted at 23.5° – that\'s why we have four seasons!\",\"The tilt changes slightly over 41,000 years – a slow wobble!\",\"The tilt also makes days longer in summer and shorter in winter!\"]', '[\"पृथ्वी २३.५° मा झुकेको छ – त्यसैले हामीलाई चार ऋतुहरू हुन्छन्!\",\"झुकाव ४१,००० वर्षमा अलि परिवर्तन हुन्छ – एक ढिलो हल्लाउने!\",\"झुकावले गर्मीमा दिन लामो र जाडोमा छोटो बनाउँछ!\"]'),
(4029, 3, '♂', 'Mars\' Atmosphere', 'मंगलको वायुमण्डल', '95% CO₂, Very Thin', '९५% CO₂, धेरै पातलो', 'Terrestrial', 'स्थलीय', '[\"Mars\' atmosphere is very thin – only 1% as thick as Earth\'s!\",\"It\'s mostly carbon dioxide (95%) – not good for breathing!\",\"Dust storms on Mars can cover the whole planet – like a big blanket!\"]', '[\"मंगलको वायुमण्डल धेरै पातलो छ – पृथ्वीको भन्दा १% मात्र बाक्लो!\",\"यो प्रायः कार्बन डाइअक्साइड (९५%) हो – सास फेर्नको लागि राम्रो छैन!\",\"मंगलमा धुलोको आँधीले पूरै ग्रह ढाक्न सक्छ – ठूलो कम्बल जस्तै!\"]'),
(4030, 3, '♃', 'Jupiter\'s Composition', 'बृहस्पतिको संरचना', '90% H, 10% He', '९०% H, १०% He', 'Gas Giant', 'ग्यासको विशाल', '[\"Jupiter is mostly hydrogen (90%) and helium (10%) – just like the Sun!\",\"It has no solid surface – it\'s a giant ball of gas!\",\"Jupiter\'s gravity is 2.5 times stronger than Earth\'s – you\'d be heavier there!\"]', '[\"बृहस्पति प्रायः हाइड्रोजन (९०%) र हेलियम (१०%) हो – सूर्य जस्तै!\",\"यसको कुनै ठोस सतह छैन – यो ग्यासको विशाल बल हो!\",\"बृहस्पतिको गुरुत्वाकर्षण पृथ्वीको भन्दा २.५ गुणा बलियो छ – त्यहाँ तपाईं भारी हुनुहुन्छ!\"]'),
(4031, 3, '🧬', 'DNA & Genetics', 'DNA र आनुवंशिकता', 'The Blueprint of Life', 'जीवनको नक्सा', 'Science', 'विज्ञान', '[\"DNA is like a recipe book that tells living things how to grow and function!\",\"Genes are small bits of DNA that decide traits like eye color and height!\",\"We get our DNA from our parents – that\'s why we look like them!\",\"Changes in DNA – mutations – can create new traits and help evolution!\"]', '[\"DNA एउटा रेसिपी किताब जस्तै हो जसले जीवित चीजहरूलाई कसरी बढ्न र काम गर्ने भन्ने बताउँछ!\",\"जीनहरू DNA का साना टुक्रा हुन् जसले आँखाको रङ र उचाइ जस्ता विशेषताहरू निर्धारण गर्छन्!\",\"हामी आफ्नो DNA आमाबाबुबाट पाउँछौं – त्यसैले हामी उनीहरू जस्तै देखिन्छौं!\",\"DNA मा परिवर्तन – उत्परिवर्तन – नयाँ विशेषताहरू सिर्जना गर्न र विकासमा मद्दत गर्न सक्छ!\"]'),
(4032, 3, '🧬', 'Evolution', 'विकास', 'Change Over Time', 'समयसँगै परिवर्तन', 'Science', 'विज्ञान', '[\"Natural selection means creatures with useful traits survive and have babies!\",\"Adaptations help animals live better in their homes – like polar bears\' white fur!\",\"Fossils are like time capsules – they show us ancient life!\",\"All life on Earth is related – we all share a common ancestor, way back!\"]', '[\"प्राकृतिक चयन भनेको उपयोगी विशेषताहरू भएका प्राणीहरू बाँच्छन् र बच्चा जन्माउँछन्!\",\"अनुकूलनले जनावरहरूलाई आफ्नो घरमा राम्रोसँग बाँच्न मद्दत गर्छ – जस्तै ध्रुवीय भालुको सेतो फर!\",\"जीवाश्महरू समय क्याप्सूल जस्तै हुन् – तिनीहरूले हामीलाई प्राचीन जीवन देखाउँछन्!\",\"पृथ्वीमा सबै जीवन सम्बन्धित छ – हामी सबैको एउटै साझा पूर्वज छ, धेरै पहिले!\"]'),
(4033, 3, '🌍', 'Biodiversity', 'जैविक विविधता', 'Variety of Life', 'जीवनको विविधता', 'Nature', 'प्रकृति', '[\"Biodiversity means all the different kinds of life on Earth – from tiny bugs to giant whales!\",\"There are millions of species – each one is unique!\",\"Biodiversity keeps ecosystems healthy – like a team with different players!\",\"When we lose species, biodiversity drops – and that\'s bad for nature.\",\"We can help by protecting forests, oceans, and all animals!\"]', '[\"जैविक विविधता भनेको पृथ्वीमा जीवनका सबै विभिन्न प्रकारहरू हुन् – साना किरादेखि विशाल ह्वेलसम्म!\",\"त्यहाँ लाखौं प्रजातिहरू छन् – प्रत्येक अद्वितीय छ!\",\"जैविक विविधताले पारिस्थितिकी तंत्रलाई स्वस्थ राख्छ – विभिन्न खेलाडीहरू भएको टोली जस्तै!\",\"जब हामीले प्रजातिहरू गुमाउँछौं, जैविक विविधता घट्छ – र त्यो प्रकृतिको लागि खराब हो।\",\"हामी वन, महासागर र सबै जनावरहरूको संरक्षण गरेर मद्दत गर्न सक्छौं!\"]'),
(4034, 3, '🌡️', 'Climate Change', 'जलवायु परिवर्तन', 'Our Warming Planet', 'हाम्रो तातो हुँदै गएको ग्रह', 'Nature', 'प्रकृति', '[\"Climate change means Earth is getting warmer over time.\",\"It\'s caused by gases like CO₂ from cars, factories, and cutting down trees.\",\"Effects include melting ice, rising seas, and wilder weather.\",\"We can help by using clean energy, planting trees, and recycling!\"]', '[\"जलवायु परिवर्तन भनेको पृथ्वी समयसँगै तातो हुँदै गइरहेको छ।\",\"यो कार, कारखाना र रूख कटानबाट CO₂ जस्ता ग्यासहरूका कारण हुन्छ।\",\"प्रभावहरूमा बरफ पग्लनु, समुद्रको सतह बढ्नु र मौसम अझ खराब हुनु समावेश छ।\",\"हामी स्वच्छ ऊर्जा प्रयोग गरेर, रूख रोपेर र रिसाइकल गरेर मद्दत गर्न सक्छौं!\"]'),
(4035, 3, '🔬', 'Cell Biology', 'कोशिका जीवविज्ञान', 'The Building Blocks of Life', 'जीवनका निर्माण ईंटहरू', 'Science', 'विज्ञान', '[\"Cells are the smallest unit of life – every living thing is made of cells!\",\"Some cells have a nucleus (eukaryotic) and some don\'t (prokaryotic).\",\"Cells have parts called organelles – like a nucleus, mitochondria, and ribosomes!\",\"Cells divide to make new cells – that\'s how we grow and heal!\"]', '[\"कोशिकाहरू जीवनको सबैभन्दा सानो एकाइ हुन् – प्रत्येक जीवित चीज कोशिकाहरूले बनेको हुन्छ!\",\"कतिपय कोशिकाहरूमा न्यूक्लियस (युकेरियोटिक) हुन्छ र कतिपयमा हुँदैन (प्रोकेरियोटिक)।\",\"कोशिकाहरूमा अंगहरू हुन्छन् – जस्तै न्यूक्लियस, माइटोकोन्ड्रिया र राइबोसोम!\",\"कोशिकाहरू विभाजित भएर नयाँ कोशिकाहरू बनाउँछन् – त्यसरी हामी बढ्छौं र निको हुन्छौं!\"]'),
(4036, 3, '🌿', 'Ecological Succession', 'पारिस्थितिक उत्तराधिकार', 'Nature\'s Rebuilding', 'प्रकृतिको पुन: निर्माण', 'Nature', 'प्रकृति', '[\"Primary succession – new land forms like islands from volcanoes!\",\"Secondary succession – land recovers after a fire or flood.\",\"First come pioneer species – like lichens and mosses – they prepare the soil.\",\"Over time, a stable ecosystem called a climax community develops.\",\"Nature always finds a way to rebuild!\"]', '[\"प्राथमिक उत्तराधिकार – ज्वालामुखीबाट टापुहरू जस्तै नयाँ जमिन बन्छ!\",\"द्वितीयक उत्तराधिकार – आगो वा बाढीपछि जमिन पुन: प्राप्त हुन्छ।\",\"पहिले अग्रणी प्रजातिहरू आउँछन् – जस्तै लाइकेन र मस – तिनीहरूले माटो तयार गर्छन्।\",\"समयसँगै, क्लाइम्याक्स समुदाय भनिने स्थिर पारिस्थितिकी तंत्र विकास हुन्छ।\",\"प्रकृतिले सधैं पुन: निर्माण गर्ने तरिका खोज्छ!\"]');

-- --------------------------------------------------------

--
-- Table structure for table `flashcard_decks`
--

CREATE TABLE `flashcard_decks` (
  `deck_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `deck_name_en` varchar(100) DEFAULT NULL,
  `deck_name_ne` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flashcard_decks`
--

INSERT INTO `flashcard_decks` (`deck_id`, `level_id`, `deck_name_en`, `deck_name_ne`) VALUES
(1, 10, 'Basic Flashcards', 'आधारभूत फ्ल्यास कार्ड'),
(2, 11, 'Intermediate Flashcards', 'मध्यवर्ती फ्ल्यास कार्ड'),
(3, 12, 'Advanced Flashcards', 'उन्नत फ्ल्यास कार्ड');

-- --------------------------------------------------------

--
-- Table structure for table `flashcard_levels`
--

CREATE TABLE `flashcard_levels` (
  `level_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `level_name_en` varchar(50) NOT NULL,
  `level_name_ne` varchar(50) NOT NULL,
  `icon` varchar(10) DEFAULT NULL,
  `difficulty_tier` int(11) NOT NULL,
  `description_en` text DEFAULT NULL,
  `description_ne` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flashcard_levels`
--

INSERT INTO `flashcard_levels` (`level_id`, `subject_id`, `level_name_en`, `level_name_ne`, `icon`, `difficulty_tier`, `description_en`, `description_ne`, `is_active`) VALUES
(1, 1, 'Basic', 'आधारभूत', '🌱', 1, 'Simple fun questions!', 'सरल रमाइला प्रश्नहरू!', 1),
(2, 1, 'Intermediate', 'मध्यवर्ती', '🌟', 2, 'A bit more tricky!', 'अलि गाह्रो!', 1),
(3, 1, 'Advanced', 'उन्नत', '🚀', 3, 'Super brain challenge!', 'सुपर मस्तिष्क चुनौती!', 1),
(4, 2, 'Basic', 'आधारभूत', '🌱', 1, 'Simple fun questions!', 'सरल रमाइला प्रश्नहरू!', 1),
(5, 2, 'Intermediate', 'मध्यवर्ती', '🌟', 2, 'A bit more tricky!', 'अलि गाह्रो!', 1),
(6, 2, 'Advanced', 'उन्नत', '🚀', 3, 'Super brain challenge!', 'सुपर मस्तिष्क चुनौती!', 1),
(7, 3, 'Basic', 'आधारभूत', '🌱', 1, 'Simple fun questions!', 'सरल रमाइला प्रश्नहरू!', 1),
(8, 3, 'Intermediate', 'मध्यवर्ती', '🌟', 2, 'A bit more tricky!', 'अलि गाह्रो!', 1),
(9, 3, 'Advanced', 'उन्नत', '🚀', 3, 'Super brain challenge!', 'सुपर मस्तिष्क चुनौती!', 1),
(10, 4, 'Basic', 'आधारभूत', '🌱', 1, 'Simple flashcard deck', 'सरल फ्ल्यास कार्ड डेक', 1),
(11, 4, 'Intermediate', 'मध्यवर्ती', '🌟', 2, 'Intermediate flashcard deck', 'मध्यवर्ती फ्ल्यास कार्ड डेक', 1),
(12, 4, 'Advanced', 'उन्नत', '🚀', 3, 'Advanced flashcard deck', 'उन्नत फ्ल्यास कार्ड डेक', 1);

-- --------------------------------------------------------

--
-- Table structure for table `flashcard_options`
--

CREATE TABLE `flashcard_options` (
  `option_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `option_text_en` text NOT NULL,
  `option_text_ne` text NOT NULL,
  `emoji` varchar(10) NOT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flashcard_options`
--

INSERT INTO `flashcard_options` (`option_id`, `question_id`, `option_text_en`, `option_text_ne`, `emoji`, `is_correct`) VALUES
(2001, 1001, 'Yellow', 'पहेंलो', '☀️', 1),
(2002, 1001, 'Red', 'रातो', '🔴', 0),
(2003, 1001, 'Blue', 'निलो', '🔵', 0),
(2004, 1001, 'Green', 'हरियो', '🟢', 0),
(2005, 1002, 'Oxygen', 'अक्सिजन', '💨', 0),
(2006, 1002, 'Carbon Dioxide', 'कार्बन डाइअक्साइड', '🫧', 1),
(2007, 1002, 'Nitrogen', 'नाइट्रोजन', '🧪', 0),
(2008, 1002, 'Hydrogen', 'हाइड्रोजन', '💧', 0),
(2009, 1003, 'Water', 'पानी', '💧', 1),
(2010, 1003, 'Ice', 'बरफ', '🧊', 0),
(2011, 1003, 'Steam', 'भाप', '♨️', 0),
(2012, 1003, 'Rock', 'ढुङ्गा', '🪨', 0),
(2013, 1004, 'Gravity', 'गुरुत्वाकर्षण', '⬇️', 1),
(2014, 1004, 'Magnetism', 'चुम्बकत्व', '🧲', 0),
(2015, 1004, 'Friction', 'घर्षण', '✋', 0),
(2016, 1004, 'Buoyancy', 'उत्प्लावन', '🛟', 0),
(2017, 1005, 'Ears', 'कान', '👂', 1),
(2018, 1005, 'Eyes', 'आँखा', '👀', 0),
(2019, 1005, 'Nose', 'नाक', '👃', 0),
(2020, 1005, 'Mouth', 'मुख', '👄', 0),
(2021, 1007, 'H₂O', 'H₂O', '💧', 1),
(2022, 1007, 'CO₂', 'CO₂', '🫧', 0),
(2023, 1007, 'NaCl', 'NaCl', '🧂', 0),
(2024, 1007, 'O₂', 'O₂', '💨', 0),
(2025, 1008, 'Leaves', 'पात', '🍃', 1),
(2026, 1008, 'Roots', 'जरा', '🌱', 0),
(2027, 1008, 'Stem', 'डाँठ', '🌿', 0),
(2028, 1008, 'Flowers', 'फूल', '🌸', 0),
(2029, 1009, 'Cheetah', 'चितुवा', '🐆', 1),
(2030, 1009, 'Lion', 'सिंह', '🦁', 0),
(2031, 1009, 'Horse', 'घोडा', '🐴', 0),
(2032, 1009, 'Dog', 'कुकुर', '🐕', 0),
(2033, 1010, 'Skin', 'छाला', '🧴', 1),
(2034, 1010, 'Liver', 'कलेजो', '🧫', 0),
(2035, 1010, 'Brain', 'मस्तिष्क', '🧠', 0),
(2036, 1010, 'Heart', 'मुटु', '❤️', 0),
(2037, 1011, 'Mars', 'मंगल', '🔴', 1),
(2038, 1011, 'Venus', 'शुक्र', '🟡', 0),
(2039, 1011, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2040, 1011, 'Saturn', 'शनि', '🪐', 0),
(2041, 1013, '7', '७', '⚖️', 1),
(2042, 1013, '1', '१', '🧪', 0),
(2043, 1013, '14', '१४', '🧪', 0),
(2044, 1013, '5', '५', '🧪', 0),
(2045, 1014, 'Einstein', 'आइन्स्टाइन', '🧑‍🔬', 1),
(2046, 1014, 'Newton', 'न्यूटन', '🍎', 0),
(2047, 1014, 'Darwin', 'डार्विन', '🐒', 0),
(2048, 1014, 'Galileo', 'ग्यालिलियो', '🔭', 0),
(2049, 1015, 'Nitrogen', 'नाइट्रोजन', '🧪', 1),
(2050, 1015, 'Oxygen', 'अक्सिजन', '💨', 0),
(2051, 1015, 'Carbon Dioxide', 'कार्बन डाइअक्साइड', '🫧', 0),
(2052, 1015, 'Argon', 'आर्गन', '🧪', 0),
(2053, 1016, 'Starfish', 'तारा माछा', '⭐', 1),
(2054, 1016, 'Dog', 'कुकुर', '🐕', 0),
(2055, 1016, 'Cat', 'बिरालो', '🐱', 0),
(2056, 1016, 'Bird', 'चरा', '🐦', 0),
(2057, 1017, 'Force', 'बल', '⚡', 1),
(2058, 1017, 'Energy', 'ऊर्जा', '🔋', 0),
(2059, 1017, 'Power', 'शक्ति', '💡', 0),
(2060, 1017, 'Pressure', 'दबाव', '📏', 0),
(2061, 1019, 'Lion', 'सिंह', '🦁', 1),
(2062, 1019, 'Tiger', 'बाघ', '🐯', 0),
(2063, 1019, 'Bear', 'भालु', '🐻', 0),
(2064, 1019, 'Elephant', 'हात्ती', '🐘', 0),
(2065, 1020, 'Nectar', 'मकरन्द', '🍯', 1),
(2066, 1020, 'Pollen', 'पराग', '🌸', 0),
(2067, 1020, 'Water', 'पानी', '💧', 0),
(2068, 1020, 'Leaves', 'पात', '🍃', 0),
(2069, 1021, 'Spring', 'वसन्त', '🌷', 1),
(2070, 1021, 'Summer', 'ग्रीष्म', '☀️', 0),
(2071, 1021, 'Autumn', 'शरद', '🍂', 0),
(2072, 1021, 'Monsoon', 'वर्षा', '🌧️', 0),
(2073, 1022, 'Tadpole', 'ट्याडपोल', '🐸', 1),
(2074, 1022, 'Caterpillar', 'क्याटरपिलर', '🐛', 0),
(2075, 1022, 'Chick', 'चल्लो', '🐣', 0),
(2076, 1022, 'Puppy', 'कुकुरको बच्चा', '🐶', 0),
(2077, 1023, 'Banana tree', 'केराको रूख', '🍌', 1),
(2078, 1023, 'Pine tree', 'पाइन रूख', '🌲', 0),
(2079, 1023, 'Oak tree', 'ओक रूख', '🌳', 0),
(2080, 1023, 'Bamboo', 'बाँस', '🎋', 0),
(2081, 1025, 'Blue Whale', 'नीलो ह्वेल', '🐋', 1),
(2082, 1025, 'Elephant', 'हात्ती', '🐘', 0),
(2083, 1025, 'Giraffe', 'जिराफ', '🦒', 0),
(2084, 1025, 'Hippo', 'हिप्पो', '🦛', 0),
(2085, 1026, 'Oxygen', 'अक्सिजन', '💨', 1),
(2086, 1026, 'Carbon Dioxide', 'कार्बन डाइअक्साइड', '🫧', 0),
(2087, 1026, 'Nitrogen', 'नाइट्रोजन', '🧪', 0),
(2088, 1026, 'Hydrogen', 'हाइड्रोजन', '💧', 0),
(2089, 1027, 'Parrot', 'सुगा', '🦜', 1),
(2090, 1027, 'Sparrow', 'भँगेरा', '🐦', 0),
(2091, 1027, 'Eagle', 'चील', '🦅', 0),
(2092, 1027, 'Owl', 'लाटोकोसेरो', '🦉', 0),
(2093, 1028, 'Photosynthesis', 'प्रकाश संश्लेषण', '🌱', 1),
(2094, 1028, 'Respiration', 'श्वसन', '🫁', 0),
(2095, 1028, 'Digestion', 'पाचन', '🍽️', 0),
(2096, 1028, 'Circulation', 'संचार', '❤️', 0),
(2097, 1029, 'Zebra', 'जेब्रा', '🦓', 1),
(2098, 1029, 'Tiger', 'बाघ', '🐯', 0),
(2099, 1029, 'Panda', 'पाण्डा', '🐼', 0),
(2100, 1029, 'Skunk', 'स्कंक', '🦨', 0),
(2101, 1031, 'Liver', 'कलेजो', '🧫', 1),
(2102, 1031, 'Brain', 'मस्तिष्क', '🧠', 0),
(2103, 1031, 'Heart', 'मुटु', '❤️', 0),
(2104, 1031, 'Lungs', 'फोक्सो', '🫁', 0),
(2105, 1032, 'Kangaroo', 'कंगारू', '🦘', 1),
(2106, 1032, 'Bear', 'भालु', '🐻', 0),
(2107, 1032, 'Elephant', 'हात्ती', '🐘', 0),
(2108, 1032, 'Giraffe', 'जिराफ', '🦒', 0),
(2109, 1033, 'Oxygen', 'अक्सिजन', '💨', 1),
(2110, 1033, 'Silicon', 'सिलिकन', '🔮', 0),
(2111, 1033, 'Aluminium', 'एल्युमिनियम', '🔩', 0),
(2112, 1033, 'Iron', 'फलाम', '⚙️', 0),
(2113, 1034, 'Botany', 'वनस्पतिशास्त्र', '🌿', 1),
(2114, 1034, 'Zoology', 'प्राणीशास्त्र', '🐾', 0),
(2115, 1034, 'Ecology', 'पारिस्थितिकी', '🌍', 0),
(2116, 1034, 'Geology', 'भूविज्ञान', '⛰️', 0),
(2117, 1035, 'Kidneys', 'मृगौला', '🧫', 1),
(2118, 1035, 'Liver', 'कलेजो', '🧫', 0),
(2119, 1035, 'Heart', 'मुटु', '❤️', 0),
(2120, 1035, 'Lungs', 'फोक्सो', '🫁', 0),
(2121, 1037, 'Mercury', 'बुध', '☿️', 1),
(2122, 1037, 'Venus', 'शुक्र', '♀️', 0),
(2123, 1037, 'Earth', 'पृथ्वी', '🌍', 0),
(2124, 1037, 'Mars', 'मंगल', '🔴', 0),
(2125, 1038, 'Mars', 'मंगल', '🔴', 1),
(2126, 1038, 'Venus', 'शुक्र', '🟡', 0),
(2127, 1038, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2128, 1038, 'Saturn', 'शनि', '🪐', 0),
(2129, 1039, 'Saturn', 'शनि', '🪐', 1),
(2130, 1039, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2131, 1039, 'Neptune', 'नेप्च्युन', '🔵', 0),
(2132, 1039, 'Uranus', 'युरेनस', '🟢', 0),
(2133, 1040, 'Jupiter', 'बृहस्पति', '🟠', 1),
(2134, 1040, 'Saturn', 'शनि', '🪐', 0),
(2135, 1040, 'Neptune', 'नेप्च्युन', '🔵', 0),
(2136, 1040, 'Uranus', 'युरेनस', '🟢', 0),
(2137, 1041, 'Milky Way', 'दुधको बाटो', '🌌', 1),
(2138, 1041, 'Andromeda', 'एन्ड्रोमेडा', '🌠', 0),
(2139, 1041, 'Triangulum', 'त्रिभुज', '🔺', 0),
(2140, 1041, 'Sombrero', 'सोम्ब्रेरो', '🎩', 0),
(2141, 1043, 'Titan', 'टाइटान', '🌕', 1),
(2142, 1043, 'Europa', 'युरोपा', '🌕', 0),
(2143, 1043, 'Ganymede', 'ग्यानिमेड', '🌕', 0),
(2144, 1043, 'Callisto', 'क्यालिस्टो', '🌕', 0),
(2145, 1044, 'Venus', 'शुक्र', '♀️', 1),
(2146, 1044, 'Mercury', 'बुध', '☿️', 0),
(2147, 1044, 'Mars', 'मंगल', '🔴', 0),
(2148, 1044, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2149, 1045, 'Great Red Spot', 'ठूलो रातो धब्बा', '🌀', 1),
(2150, 1045, 'Great Dark Spot', 'ठूलो कालो धब्बा', '🌑', 0),
(2151, 1045, 'Eye of Jupiter', 'बृहस्पतिको आँखा', '👁️', 0),
(2152, 1045, 'Jupiter\'s Hurricane', 'बृहस्पतिको आँधी', '💨', 0),
(2153, 1046, 'Venus', 'शुक्र', '♀️', 1),
(2154, 1046, 'Mars', 'मंगल', '🔴', 0),
(2155, 1046, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2156, 1046, 'Saturn', 'शनि', '🪐', 0),
(2157, 1047, 'Mercury', 'बुध', '☿️', 1),
(2158, 1047, 'Mars', 'मंगल', '🔴', 0),
(2159, 1047, 'Venus', 'शुक्र', '♀️', 0),
(2160, 1047, 'Neptune', 'नेप्च्युन', '🔵', 0),
(2161, 1049, 'Pluto', 'प्लुटो', '♇', 1),
(2162, 1049, 'Ceres', 'सेरेस', '🌑', 0),
(2163, 1049, 'Eris', 'एरिस', '🌑', 0),
(2164, 1049, 'Makemake', 'मेकमेक', '🌑', 0),
(2165, 1050, 'Saturn', 'शनि', '🪐', 1),
(2166, 1050, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2167, 1050, 'Uranus', 'युरेनस', '🟢', 0),
(2168, 1050, 'Neptune', 'नेप्च्युन', '🔵', 0),
(2169, 1051, 'A ring of icy stuff past Neptune', 'नेप्च्युनभन्दा पर बरफीय क्षेत्र', '🧊', 1),
(2170, 1051, 'A belt of asteroids between Mars and Jupiter', 'मंगल र बृहस्पतिबीचको क्षुद्रग्रह घेरा', '🪨', 0),
(2171, 1051, 'A big gas cloud around the Sun', 'सूर्यको वरिपरि ठूलो ग्यास बादल', '☁️', 0),
(2172, 1051, 'A layer of the Sun\'s atmosphere', 'सूर्यको वायुमण्डलको तह', '☀️', 0),
(2173, 1052, 'Hydrogen and Helium', 'हाइड्रोजन र हेलियम', '💨', 1),
(2174, 1052, 'Oxygen and Carbon', 'अक्सिजन र कार्बन', '🌿', 0),
(2175, 1052, 'Iron and Nickel', 'फलाम र निकेल', '⚙️', 0),
(2176, 1052, 'Silicon and Aluminium', 'सिलिकन र एल्युमिनियम', '🔮', 0),
(2177, 1053, '11.2 km/s', '११.२ किमी/से', '🚀', 1),
(2178, 1053, '7.9 km/s', '७.९ किमी/से', '🛰️', 0),
(2179, 1053, '3.5 km/s', '३.५ किमी/से', '✈️', 0),
(2180, 1053, '15 km/s', '१५ किमी/से', '🚀', 0);

-- --------------------------------------------------------

--
-- Table structure for table `flashcard_puzzle_items`
--

CREATE TABLE `flashcard_puzzle_items` (
  `item_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `item_id_code` varchar(10) NOT NULL,
  `item_label_en` varchar(255) NOT NULL,
  `item_label_ne` varchar(255) NOT NULL,
  `emoji` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flashcard_puzzle_items`
--

INSERT INTO `flashcard_puzzle_items` (`item_id`, `question_id`, `item_id_code`, `item_label_en`, `item_label_ne`, `emoji`) VALUES
(3001, 1006, 'a', 'Solid', 'ठोस', '🧊'),
(3002, 1006, 'b', 'Liquid', 'तरल', '💧'),
(3003, 1006, 'c', 'Gas', 'ग्यास', '♨️'),
(3004, 1012, 'a', 'Earth', 'पृथ्वी', '🌍'),
(3005, 1012, 'b', 'Mars', 'मंगल', '🔴'),
(3006, 1012, 'c', 'Venus', 'शुक्र', '🟡'),
(3007, 1012, 'd', 'Mercury', 'बुध', '☿️'),
(3008, 1018, 'a', 'Mars', 'मंगल', '🔴'),
(3009, 1018, 'b', 'Venus', 'शुक्र', '♀️'),
(3010, 1018, 'c', 'Mercury', 'बुध', '☿️'),
(3011, 1018, 'd', 'Earth', 'पृथ्वी', '🌍'),
(3012, 1024, 'a', 'Egg', 'अण्डा', '🥚'),
(3013, 1024, 'b', 'Caterpillar', 'क्याटरपिलर', '🐛'),
(3014, 1024, 'c', 'Chrysalis', 'कोष', '🦋'),
(3015, 1024, 'd', 'Butterfly', 'पुतली', '🦋'),
(3016, 1030, 'a', 'Grass', 'घाँस', '🌾'),
(3017, 1030, 'b', 'Rabbit', 'खरायो', '🐇'),
(3018, 1030, 'c', 'Fox', 'फ्याक्स', '🦊'),
(3019, 1030, 'd', 'Lion', 'सिंह', '🦁'),
(3020, 1036, 'a', 'Child', 'बालक', '🧒'),
(3021, 1036, 'b', 'Baby', 'बच्चा', '👶'),
(3022, 1036, 'c', 'Adult', 'वयस्क', '🧑'),
(3023, 1036, 'd', 'Teenager', 'किशोर', '🧑‍🎓'),
(3024, 1042, 'a', 'Earth', 'पृथ्वी', '🌍'),
(3025, 1042, 'b', 'Mercury', 'बुध', '☿️'),
(3026, 1042, 'c', 'Venus', 'शुक्र', '♀️'),
(3027, 1042, 'd', 'Mars', 'मंगल', '🔴'),
(3028, 1048, 'a', 'Earth', 'पृथ्वी', '🌍'),
(3029, 1048, 'b', 'Mars', 'मंगल', '🔴'),
(3030, 1048, 'c', 'Venus', 'शुक्र', '♀️'),
(3031, 1048, 'd', 'Mercury', 'बुध', '☿️'),
(3032, 1054, 'a', 'Mars', 'मंगल', '🔴'),
(3033, 1054, 'b', 'Venus', 'शुक्र', '♀️'),
(3034, 1054, 'c', 'Mercury', 'बुध', '☿️'),
(3035, 1054, 'd', 'Earth', 'पृथ्वी', '🌍');

-- --------------------------------------------------------

--
-- Table structure for table `flashcard_questions`
--

CREATE TABLE `flashcard_questions` (
  `question_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `type` enum('mcq','puzzle') NOT NULL,
  `question_en` text NOT NULL,
  `question_ne` text NOT NULL,
  `hint_en` text DEFAULT NULL,
  `hint_ne` text DEFAULT NULL,
  `fun_fact_en` text DEFAULT NULL,
  `fun_fact_ne` text DEFAULT NULL,
  `correct_order` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`correct_order`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flashcard_questions`
--

INSERT INTO `flashcard_questions` (`question_id`, `level_id`, `type`, `question_en`, `question_ne`, `hint_en`, `hint_ne`, `fun_fact_en`, `fun_fact_ne`, `correct_order`) VALUES
(1001, 1, 'mcq', 'What color do we see the Sun as? 🌞', 'सूर्य हामीलाई कस्तो रंगको देखिन्छ? 🌞', NULL, NULL, 'The Sun is actually white, but our sky makes it look yellow!', 'सूर्य वास्तवमा सेतो हो, तर हाम्रो आकाशले यसलाई पहेंलो देखाउँछ!', NULL),
(1002, 1, 'mcq', 'What gas do we blow out when we breathe? 💨', 'सास फेर्दा हामी बाहिर कुन ग्यास निकाल्छौं? 💨', NULL, NULL, 'We breathe in oxygen and breathe out carbon dioxide – plants love it!', 'हामी अक्सिजन सास लिन्छौं र कार्बन डाइअक्साइड बाहिर निकाल्छौं – बोटबिरुवालाई यो मन पर्छ!', NULL),
(1003, 1, 'mcq', 'Which of these can flow and take the shape of a glass? 🥤', 'यी मध्ये कुन गिलासको आकार लिन सक्छ? 🥤', NULL, NULL, 'Water is a liquid – it can be solid as ice or gas as steam too!', 'पानी तरल हो – यो बरफजस्तै ठोस वा भापजस्तै ग्यास पनि हुन सक्छ!', NULL),
(1004, 1, 'mcq', 'What force keeps our feet on the ground? 🦶', 'हामीलाई जमिनमा टाँसिराख्ने बल के हो? 🦶', NULL, NULL, 'Gravity is like a giant magnet that pulls everything down to Earth!', 'गुरुत्वाकर्षण एउटा विशाल चुम्बक जस्तै हो जसले सबैलाई पृथ्वीतिर तान्छ!', NULL),
(1005, 1, 'mcq', 'Which body part do we use to hear music? 🎵', 'संगीत सुन्न हामी कुन अंग प्रयोग गर्छौं? 🎵', NULL, NULL, 'Your ears catch sound waves and send them straight to your brain!', 'तपाईंको कानले ध्वनि तरंगहरू समात्छ र मस्तिष्कमा पठाउँछ!', NULL),
(1006, 1, 'puzzle', 'Put the states of matter in order from coldest to hottest:', 'पदार्थका अवस्थाहरूलाई चिसोदेखि तातोसम्म मिलाउनुहोस्:', 'Solid → Liquid → Gas', 'ठोस → तरल → ग्यास', 'When you heat or cool things, they can change from one state to another!', 'तातो वा चिसो पार्दा पदार्थको अवस्था परिवर्तन हुन्छ!', '[\"a\",\"b\",\"c\"]'),
(1007, 2, 'mcq', 'What is the fancy name for water? 💧', 'पानीको विशेष नाम के हो? 💧', NULL, NULL, 'Every water drop is made of two hydrogen atoms and one oxygen atom!', 'हरेक पानीको थोपा दुई हाइड्रोजन परमाणु र एक अक्सिजन परमाणुले बनेको हुन्छ!', NULL),
(1008, 2, 'mcq', 'Which part of a plant is like its kitchen? 🍳', 'बोटको कुन भाग भान्सा जस्तै हो? 🍳', NULL, NULL, 'Leaves use sunshine to cook food – it\'s called photosynthesis!', 'पातहरूले खाना पकाउन घामको प्रयोग गर्छन् – यसलाई प्रकाश संश्लेषण भनिन्छ!', NULL),
(1009, 2, 'mcq', 'Who is the fastest runner on land? 🏃‍♂️', 'जमिनमा सबैभन्दा छिटो दौडने कुन हो? 🏃‍♂️', NULL, NULL, 'Cheetahs can zoom at 70 mph – that\'s like a car on the highway!', 'चितुवा ७० माइल प्रति घण्टाको गतिमा दौडन सक्छ – त्यो राजमार्गको कार जस्तै हो!', NULL),
(1010, 2, 'mcq', 'What is the biggest organ in your body? 🫀', 'तपाईंको शरीरको सबैभन्दा ठूलो अंग कुन हो? 🫀', NULL, NULL, 'Your skin is like a superhero cape – it protects you from germs!', 'तपाईंको छाला सुपरहीरोको पोशाक जस्तै हो – यसले कीटाणुबाट जोगाउँछ!', NULL),
(1011, 2, 'mcq', 'Which planet is called the Red Planet? 🔴', 'कुन ग्रहलाई रातो ग्रह भनिन्छ? 🔴', NULL, NULL, 'Mars is red because it\'s covered in rusty iron – like an old bike!', 'मंगल रातो छ किनभने यो खिया लागेको फलामले ढाकिएको छ – पुरानो साइकल जस्तै!', NULL),
(1012, 2, 'puzzle', 'Arrange these planets from smallest to largest:', 'यी ग्रहहरूलाई सानोदेखि ठूलोसम्म मिलाउनुहोस्:', 'Mercury → Mars → Venus → Earth', 'बुध → मंगल → शुक्र → पृथ्वी', 'Jupiter is the biggest – it could swallow all the other planets!', 'बृहस्पति सबैभन्दा ठूलो हो – यसले अरू सबै ग्रहहरू निल्न सक्छ!', '[\"d\",\"b\",\"c\",\"a\"]'),
(1013, 3, 'mcq', 'What number tells us if water is neutral? ⚖️', 'पानी सन्तुलित छ कि भन्ने संख्या कति हो? ⚖️', NULL, NULL, 'Pure water has a neutral pH of 7 – it\'s not sour or bitter!', 'शुद्ध पानीको पीएच ७ हुन्छ – यो न त अमिलो न त तीतो!', NULL),
(1014, 3, 'mcq', 'Who came up with the idea that everything is relative? 🧠', 'सबै कुरा सापेक्षिक हो भन्ने विचार कसले दियो? 🧠', NULL, NULL, 'Albert Einstein was super smart – he changed how we think about time!', 'अल्बर्ट आइन्स्टाइन धेरै बुद्धिमान थिए – उनले समयको बारेमा हाम्रो सोच परिवर्तन गरे!', NULL),
(1015, 3, 'mcq', 'Which gas fills most of our air? 🌬️', 'हाम्रो हावामा सबैभन्दा धेरै कुन ग्यास छ? 🌬️', NULL, NULL, 'About 78% of the air we breathe is nitrogen – it\'s everywhere!', 'हामीले सास फेर्ने हावाको करिब ७८% नाइट्रोजन हो – यो जताततै छ!', NULL),
(1016, 3, 'mcq', 'Which sea creature can grow back its arms? 🌊', 'कुन समुद्री प्राणीले आफ्ना हातहरू फेरि उमार्न सक्छ? 🌊', NULL, NULL, 'Starfish are like superheroes – they can regrow lost arms!', 'तारा माछा सुपरहीरो जस्तै हुन् – तिनीहरूले हराएको पाखुरा फेरि उमार्न सक्छन्!', NULL),
(1017, 3, 'mcq', 'What do we call the push or pull that moves things? 💪', 'वस्तुहरूलाई धकेल्ने वा तान्ने कसरी भनिन्छ? 💪', NULL, NULL, 'Force is measured in Newtons – named after Sir Isaac Newton!', 'बललाई न्यूटनमा मापन गरिन्छ – सर आइज्याक न्यूटनको नाममा!', NULL),
(1018, 3, 'puzzle', 'Put these planets in order from closest to farthest from the Sun:', 'यी ग्रहहरूलाई सूर्यबाट नजिकदेखि टाढासम्म मिलाउनुहोस्:', 'Mercury → Venus → Earth → Mars', 'बुध → शुक्र → पृथ्वी → मंगल', 'The Sun\'s light takes 8 minutes to reach us – that\'s a long trip!', 'सूर्यको प्रकाश हामीसम्म आउन ८ मिनेट लाग्छ – त्यो लामो यात्रा हो!', '[\"c\",\"b\",\"d\",\"a\"]'),
(1019, 4, 'mcq', 'Which animal is the king of the jungle? 👑', 'कुन जनावर जंगलको राजा हो? 👑', NULL, NULL, 'Lions live in big families called prides – they love company!', 'सिंह ठूला परिवारमा बस्छन् जसलाई प्राइड भनिन्छ – उनीहरूलाई साथी मन पर्छ!', NULL),
(1020, 4, 'mcq', 'What do bees collect from flowers to make honey? 🍯', 'मौरीले मह बनाउन फूलबाट के सङ्कलन गर्छ? 🍯', NULL, NULL, 'Bees are busy little workers – they turn nectar into sweet honey!', 'मौरीहरू व्यस्त साना कामदार हुन् – तिनीहरू मकरन्दलाई मीठो मह बनाउँछन्!', NULL),
(1021, 4, 'mcq', 'Which season comes right after winter? 🌷', 'जाडो पछि कुन ऋतु आउँछ? 🌷', NULL, NULL, 'Spring is when flowers pop up and animals wake from their long naps!', 'वसन्तमा फूल फुल्छन् र जनावरहरू आफ्नो लामो निद्राबाट जाग्छन्!', NULL),
(1022, 4, 'mcq', 'What is a baby frog called? 🐸', 'बच्चा भ्यागुतालाई के भनिन्छ? 🐸', NULL, NULL, 'Tadpoles swim in water and grow legs to become frogs – amazing!', 'ट्याडपोल पानीमा पौडिन्छ र खुट्टा उमारेर भ्यागुता बन्छ – अचम्म!', NULL),
(1023, 4, 'mcq', 'Which plant has a really long trunk and huge leaves? 🌴', 'कुन बोटको लामो हाँगा र ठूला पात हुन्छ? 🌴', NULL, NULL, 'Banana trees are actually giant herbs – not trees at all!', 'केराको रूख वास्तवमा विशाल जडीबुटी हो – रूख होइन!', NULL),
(1024, 4, 'puzzle', 'Put the butterfly life cycle in order:', 'पुतलीको जीवन चक्र मिलाउनुहोस्:', 'Egg → Caterpillar → Chrysalis → Butterfly', 'अण्डा → क्याटरपिलर → कोष → पुतली', 'A butterfly goes through a magical change called metamorphosis!', 'पुतलीले कायापलट भनिने जादुई परिवर्तनबाट गुज्रन्छ!', '[\"a\",\"b\",\"c\",\"d\"]'),
(1025, 5, 'mcq', 'What is the largest animal on Earth? 🐋', 'पृथ्वीमा सबैभन्दा ठूलो जनावर कुन हो? 🐋', NULL, NULL, 'A blue whale weighs as much as 33 elephants – that\'s huge!', 'नीलो ह्वेलको तौल ३३ हात्तीको बराबर हुन्छ – त्यो विशाल हो!', NULL),
(1026, 5, 'mcq', 'What do trees give us that helps us breathe? 🌳', 'रूखहरूले हामीलाई सास फेर्न के दिन्छ? 🌳', NULL, NULL, 'Trees are like nature\'s oxygen factories – they keep our air fresh!', 'रूखहरू प्रकृतिको अक्सिजन कारखाना जस्तै हुन् – तिनीहरूले हावा ताजा राख्छन्!', NULL),
(1027, 5, 'mcq', 'Which bird can talk like a human? 🗣️', 'कुन चराले मानिसजस्तै बोल्न सक्छ? 🗣️', NULL, NULL, 'Parrots are clever copycats – they can learn to say words!', 'सुगा चलाख नक्कल गर्ने हुन् – तिनीहरूले शब्दहरू भन्न सिक्न सक्छन्!', NULL),
(1028, 5, 'mcq', 'What is the process called when plants make food? 🌿', 'बोटबिरुवाले खाना बनाउने प्रक्रियालाई के भनिन्छ? 🌿', NULL, NULL, 'Photosynthesis is like a recipe – sunlight + water + air = plant food!', 'प्रकाश संश्लेषण एउटा रेसिपी जस्तै हो – घाम + पानी + हावा = बोटको खाना!', NULL),
(1029, 5, 'mcq', 'Which animal has black and white stripes? 🦓', 'कुन जनावरको कालो र सेतो धर्का हुन्छ? 🦓', NULL, NULL, 'Zebra stripes are like fingerprints – each one is unique!', 'जेब्राका धर्काहरू औंठाछाप जस्तै हुन् – प्रत्येक फरक हुन्छ!', NULL),
(1030, 5, 'puzzle', 'Order the food chain from plant to top hunter:', 'खाद्य शृंखलालाई बोटबाट शीर्ष शिकारीसम्म मिलाउनुहोस्:', 'Grass → Rabbit → Fox → Lion', 'घाँस → खरायो → फ्याक्स → सिंह', 'Everything in nature is connected – like a big chain of friends!', 'प्रकृतिमा सबै कुरा जोडिएको छ – साथीहरूको ठूलो शृंखला जस्तै!', '[\"a\",\"b\",\"c\",\"d\"]'),
(1031, 6, 'mcq', 'What is the biggest internal organ we have? 🧬', 'हाम्रो भित्रको सबैभन्दा ठूलो अंग कुन हो? 🧬', NULL, NULL, 'Your liver is like a filter – it cleans your blood every day!', 'तपाईंको कलेजो फिल्टर जस्तै हो – यसले दैनिक रगत सफा गर्छ!', NULL),
(1032, 6, 'mcq', 'Which animal carries its babies in a pouch? 🦘', 'कुन जनावरले आफ्ना बच्चाहरूलाई झोलामा बोक्छ? 🦘', NULL, NULL, 'Kangaroos are marsupials – their babies grow in a cozy pouch!', 'कंगारूहरू मार्सुपियल हुन् – तिनीहरूका बच्चाहरू आरामदायी झोलामा बढ्छन्!', NULL),
(1033, 6, 'mcq', 'Which element is most common in the Earth\'s crust? 🪨', 'पृथ्वीको क्रस्टमा सबैभन्दा धेरै कुन तत्व पाइन्छ? 🪨', NULL, NULL, 'Oxygen makes up nearly half of the Earth\'s crust – it\'s everywhere!', 'अक्सिजनले पृथ्वीको क्रस्टको लगभग आधा भाग ओगट्छ – यो जताततै छ!', NULL),
(1034, 6, 'mcq', 'What is the study of plants called? 🌿', 'बोटबिरुवाको अध्ययनलाई के भनिन्छ? 🌿', NULL, NULL, 'Botany is all about plants – from tiny mosses to giant trees!', 'वनस्पतिशास्त्र बोटबिरुवाको बारेमा हो – साना मसदेखि विशाल रूखसम्म!', NULL),
(1035, 6, 'mcq', 'Which organ cleans our blood and makes pee? 🧼', 'कुन अंगले रगत सफा गर्छ र पिसाब बनाउँछ? 🧼', NULL, NULL, 'Kidneys work like a washing machine – they filter waste from blood!', 'मृगौला वासिङ मेसिन जस्तै काम गर्छ – यसले रगतबाट फोहोर फिल्टर गर्छ!', NULL),
(1036, 6, 'puzzle', 'Order the human life stages from baby to adult:', 'मानव जीवनका चरणहरूलाई बच्चादेखि वयस्कसम्म मिलाउनुहोस्:', 'Baby → Child → Teenager → Adult', 'बच्चा → बालक → किशोर → वयस्क', 'We all start as babies and grow up – everyone does!', 'हामी सबै बच्चाबाट सुरु हुन्छौं र ठूला हुन्छौं – सबैले यस्तै गर्छन्!', '[\"b\",\"a\",\"d\",\"c\"]'),
(1037, 7, 'mcq', 'Which planet is closest to the Sun? 🌞', 'कुन ग्रह सूर्यको सबैभन्दा नजिक छ? 🌞', NULL, NULL, 'Mercury is tiny and fast – it orbits the Sun in just 88 days!', 'बुध सानो र छिटो छ – यसले सूर्यको परिक्रमा जम्मा ८८ दिनमा गर्छ!', NULL),
(1038, 7, 'mcq', 'Which planet looks red like rust? 🔴', 'कुन ग्रह खिया जस्तै रातो देखिन्छ? 🔴', NULL, NULL, 'Mars is red because of iron rust – like an old bicycle!', 'मंगल रातो छ किनभने फलामको खिया – पुरानो साइकल जस्तै!', NULL),
(1039, 7, 'mcq', 'Which planet has beautiful rings around it? 💍', 'कुन ग्रहको वरिपरि सुन्दर वलय छ? 💍', NULL, NULL, 'Saturn\'s rings are made of ice and rock – they sparkle like jewels!', 'शनिका वलय बरफ र ढुङ्गाले बनेका छन् – तिनीहरू रत्नजस्तै चम्किन्छन्!', NULL),
(1040, 7, 'mcq', 'Which planet is the biggest of them all? 🐘', 'सबैभन्दा ठूलो ग्रह कुन हो? 🐘', NULL, NULL, 'Jupiter is so huge that all the other planets could fit inside!', 'बृहस्पति यति ठूलो छ कि अरू सबै ग्रहहरू यसको भित्र अटाउन सक्छन्!', NULL),
(1041, 7, 'mcq', 'What is the name of our galaxy? 🌌', 'हाम्रो आकाशगंगाको नाम के हो? 🌌', NULL, NULL, 'Our galaxy looks like a milky swirl in the night sky – that\'s why it\'s called the Milky Way!', 'हाम्रो आकाशगंगा रातको आकाशमा दुधको जस्तै देखिन्छ – त्यसैले यसलाई दुधको बाटो भनिन्छ!', NULL),
(1042, 7, 'puzzle', 'Order these planets from closest to farthest from the Sun:', 'यी ग्रहहरूलाई सूर्यबाट नजिकदेखि टाढासम्म मिलाउनुहोस्:', 'Mercury → Venus → Earth → Mars', 'बुध → शुक्र → पृथ्वी → मंगल', 'The inner planets are small and rocky – the outer ones are big gas balls!', 'भित्री ग्रहहरू साना र चट्टानी हुन् – बाहिरी ग्रहहरू ठूला ग्यासका बल हुन्!', '[\"b\",\"c\",\"a\",\"d\"]'),
(1043, 8, 'mcq', 'What is Saturn\'s biggest moon called? 🌕', 'शनिको सबैभन्दा ठूलो चन्द्रमाको नाम के हो? 🌕', NULL, NULL, 'Titan is even bigger than Mercury – it has its own thick air!', 'टाइटान बुधभन्दा पनि ठूलो छ – यसको आफ्नै बाक्लो हावा छ!', NULL),
(1044, 8, 'mcq', 'Which planet has a day that\'s longer than its year? ⏳', 'कुन ग्रहको दिन वर्षभन्दा लामो छ? ⏳', NULL, NULL, 'Venus spins so slowly that a day there lasts longer than a year – crazy!', 'शुक्र यति ढिलो घुम्छ कि त्यहाँको दिन वर्षभन्दा लामो हुन्छ – पागल!', NULL),
(1045, 8, 'mcq', 'What is the famous big storm on Jupiter called? 🌪️', 'बृहस्पतिमा रहेको प्रसिद्ध ठूलो आँधीलाई के भनिन्छ? 🌪️', NULL, NULL, 'The Great Red Spot is a giant storm – it\'s been raging for hundreds of years!', 'ठूलो रातो धब्बा एक विशाल आँधी हो – यो सयौं वर्षदेखि चलिरहेको छ!', NULL),
(1046, 8, 'mcq', 'Which planet is often called the \"Morning Star\"? ⭐', 'कुन ग्रहलाई प्रायः \"बिहानी तारा\" भनिन्छ? ⭐', NULL, NULL, 'Venus shines bright in the morning and evening – it\'s a dazzling star!', 'शुक्र बिहान र साँझ उज्यालो हुन्छ – यो चम्किलो तारा हो!', NULL),
(1047, 8, 'mcq', 'What is the tiniest planet in our solar system? 🪐', 'हाम्रो सौर्यमण्डलको सबैभन्दा सानो ग्रह कुन हो? 🪐', NULL, NULL, 'Mercury is the smallest – it\'s only a little bigger than our Moon!', 'बुध सबैभन्दा सानो हो – यो हाम्रो चन्द्रमाभन्दा अलि मात्र ठूलो छ!', NULL),
(1048, 8, 'puzzle', 'Put these planets in order from smallest to largest:', 'यी ग्रहहरूलाई सानोदेखि ठूलोसम्म मिलाउनुहोस्:', 'Mercury → Mars → Venus → Earth', 'बुध → मंगल → शुक्र → पृथ्वी', 'Earth is the biggest rocky planet, but Jupiter is the real giant!', 'पृथ्वी सबैभन्दा ठूलो चट्टानी ग्रह हो, तर बृहस्पति साँचो विशाल हो!', '[\"d\",\"b\",\"c\",\"a\"]'),
(1049, 9, 'mcq', 'Which body was demoted to a dwarf planet? 😢', 'कुन पिण्डलाई बौना ग्रहको रूपमा पुन: वर्गीकृत गरियो? 😢', NULL, NULL, 'Pluto got kicked out of the planet club in 2006 – but it\'s still cool!', 'प्लुटोलाई २००६ मा ग्रह क्लबबाट निकालियो – तर यो अझै राम्रो छ!', NULL),
(1050, 9, 'mcq', 'Which planet has the most moons? 🌙', 'कुन ग्रहमा सबैभन्दा धेरै चन्द्रमा छन्? 🌙', NULL, NULL, 'Saturn has over 80 moons – that\'s a whole solar system of friends!', 'शनिसँग ८० भन्दा बढी चन्द्रमा छन् – त्यो साथीहरूको सम्पूर्ण सौर्यमण्डल हो!', NULL),
(1051, 9, 'mcq', 'What is the Kuiper Belt? 🧊', 'काइपर बेल्ट के हो? 🧊', NULL, NULL, 'The Kuiper Belt is like a giant freezer full of icy rocks and dwarf planets!', 'काइपर बेल्ट बरफीय ढुङ्गा र बौना ग्रहहरूले भरिएको विशाल फ्रिजर जस्तै हो!', NULL),
(1052, 9, 'mcq', 'What is the Sun mostly made of? ☀️', 'सूर्य प्रायः केले बनेको छ? ☀️', NULL, NULL, 'The Sun is a giant ball of gas – mostly hydrogen and helium, like a star!', 'सूर्य ग्यासको विशाल बल हो – प्रायः हाइड्रोजन र हेलियम, तारा जस्तै!', NULL),
(1053, 9, 'mcq', 'How fast do you need to go to escape Earth\'s gravity? 🚀', 'पृथ्वीको गुरुत्वाकर्षणबाट मुक्त हुन कति छिटो जानुपर्छ? 🚀', NULL, NULL, 'That\'s called escape velocity – it\'s like a rocket\'s need for speed!', 'यसलाई पलायन वेग भनिन्छ – यो रकेटको गतिको आवश्यकता जस्तै हो!', NULL),
(1054, 9, 'puzzle', 'Order these planets by distance from the Sun (closest to farthest):', 'यी ग्रहहरूलाई सूर्यबाट दूरी (नजिकदेखि टाढा) अनुसार मिलाउनुहोस्:', 'Mercury → Venus → Earth → Mars', 'बुध → शुक्र → पृथ्वी → मंगल', 'It takes 8 minutes for sunlight to reach us – that\'s a long journey!', 'सूर्यको प्रकाश हामीसम्म आउन ८ मिनेट लाग्छ – त्यो लामो यात्रा हो!', '[\"c\",\"b\",\"d\",\"a\"]');

-- --------------------------------------------------------

--
-- Table structure for table `flashcard_subjects`
--

CREATE TABLE `flashcard_subjects` (
  `subject_id` int(11) NOT NULL,
  `name_en` varchar(100) NOT NULL,
  `name_ne` varchar(100) NOT NULL,
  `icon` varchar(10) NOT NULL,
  `description_en` text DEFAULT NULL,
  `description_ne` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flashcard_subjects`
--

INSERT INTO `flashcard_subjects` (`subject_id`, `name_en`, `name_ne`, `icon`, `description_en`, `description_ne`, `is_active`) VALUES
(1, 'Science', 'विज्ञान', '🔬', 'Physics & Chemistry', 'भौतिकशास्त्र र रसायनशास्त्र', 1),
(2, 'Nature', 'प्रकृति', '🌱', 'Plants & Animals', 'बिरुवा र जनावरहरू', 1),
(3, 'Solar System', 'सौर्य प्रणाली', '🪐', 'Space & Planets', 'अन्तरिक्ष र ग्रहहरू', 1),
(4, 'Flashcards', 'फ्ल्यास कार्ड', '🃏', 'Science, Nature & Space', 'विज्ञान, प्रकृति र अन्तरिक्ष', 1);

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `game_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `slug` varchar(100) NOT NULL,
  `game_type` enum('hangman','whack_a_mole','capybara_quiz','science_nature','drag_drop_shapes','spelling_adventure') NOT NULL,
  `description` text DEFAULT NULL,
  `min_age` int(11) NOT NULL DEFAULT 3,
  `max_age` int(11) NOT NULL DEFAULT 12,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`game_id`, `title`, `subject`, `slug`, `game_type`, `description`, `min_age`, `max_age`, `is_active`) VALUES
(1, 'Word Whack', 'English', 'word-whack', 'whack_a_mole', 'Whack the mole holding the correct answer', 8, 9, 1),
(2, 'Capybara Nepal Adventure', NULL, 'capybara-nepal-adventure', 'capybara_quiz', 'Learn about Nepal with Capybara!', 6, 12, 1),
(3, 'Alphabet Adventure', NULL, 'alphabet-adventure', 'spelling_adventure', 'Learn, Play & Spell! Journey through A-Z with 390 fun words for ages 4-6.', 4, 6, 1),
(4, 'Quiz & Flashcards', NULL, 'quiz-flashcards', '', 'Science, Nature, Space quiz and flashcards with fun facts and puzzles. Learn about Nepal, animals, planets, and more!', 4, 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `game_access`
--

CREATE TABLE `game_access` (
  `game_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `game_access`
--

INSERT INTO `game_access` (`game_id`, `plan_id`, `created_at`) VALUES
(2, 1, '2026-08-09 17:12:57'),
(2, 2, '2026-08-09 17:12:57'),
(2, 3, '2026-08-09 17:12:57'),
(2, 4, '2026-08-09 17:12:57'),
(2, 5, '2026-08-09 17:12:57');

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

--
-- Dumping data for table `hangman_words`
--

INSERT INTO `hangman_words` (`word_id`, `game_id`, `word`, `hint`, `category`, `difficulty_tier`, `target_age_min`, `target_age_max`) VALUES
(1, 22, 'CAT', 'A small furry pet', 'mammals', 1, 4, 6),
(2, 22, 'DOG', 'A friendly barker', 'mammals', 1, 4, 6),
(3, 22, 'COW', 'A farm animal that gives milk', 'mammals', 1, 4, 6),
(4, 22, 'PIG', 'A pink farm animal', 'mammals', 1, 4, 6),
(5, 22, 'BAT', 'The only flying mammal', 'mammals', 1, 4, 6),
(6, 22, 'FOX', 'A clever orange animal', 'mammals', 1, 4, 6),
(7, 22, 'BEAR', 'A big furry animal', 'mammals', 1, 4, 6),
(8, 22, 'DEER', 'A graceful animal with antlers', 'mammals', 1, 4, 6),
(9, 22, 'ZEBRA', 'A striped horse-like animal', 'mammals', 1, 4, 6),
(10, 22, 'TIGER', 'A large striped cat', 'mammals', 2, 7, 8),
(11, 22, 'RABBIT', 'A hopping animal with long ears', 'mammals', 2, 7, 8),
(12, 22, 'HORSE', 'A large animal used for riding', 'mammals', 2, 7, 8),
(13, 22, 'MONKEY', 'A playful tree-dweller', 'mammals', 2, 7, 8),
(14, 22, 'LION', 'The king of the jungle', 'mammals', 2, 7, 8),
(15, 22, 'ELEPHANT', 'The largest land animal', 'mammals', 3, 9, 10),
(16, 22, 'GIRAFFE', 'The tallest land animal', 'mammals', 3, 9, 10),
(17, 22, 'DOLPHIN', 'A smart sea animal', 'mammals', 3, 9, 10),
(18, 22, 'KANGAROO', 'An animal with a pouch', 'mammals', 3, 9, 10),
(19, 22, 'DUCK', 'A bird that says quack', 'birds', 1, 4, 6),
(20, 22, 'HEN', 'A bird that lays eggs', 'birds', 1, 4, 6),
(21, 22, 'OWL', 'A night bird', 'birds', 1, 4, 6),
(22, 22, 'EAGLE', 'A large bird with sharp eyes', 'birds', 1, 4, 6),
(23, 22, 'PENGUIN', 'A bird that swims', 'birds', 1, 4, 6),
(24, 22, 'PARROT', 'A colorful talking bird', 'birds', 2, 7, 8),
(25, 22, 'SPARROW', 'A small brown bird', 'birds', 2, 7, 8),
(26, 22, 'FLAMINGO', 'A pink bird on one leg', 'birds', 3, 9, 10),
(27, 22, 'PELICAN', 'A bird with a big beak pouch', 'birds', 3, 9, 10),
(28, 22, 'SNAKE', 'A long animal with no legs', 'reptiles', 1, 4, 6),
(29, 22, 'LIZARD', 'A small animal that can lose its tail', 'reptiles', 1, 4, 6),
(30, 22, 'TURTLE', 'A slow animal with a shell', 'reptiles', 1, 4, 6),
(31, 22, 'CROCODILE', 'A large reptile with many teeth', 'reptiles', 2, 7, 8),
(32, 22, 'IGUANA', 'A green sun-loving reptile', 'reptiles', 2, 7, 8),
(33, 22, 'CHAMELEON', 'A reptile that changes color', 'reptiles', 3, 9, 10),
(34, 22, 'ALLIGATOR', 'A large reptile with a broad snout', 'reptiles', 3, 9, 10),
(35, 22, 'FROG', 'A small animal that says ribbit', 'amphibians', 1, 4, 6),
(36, 22, 'TOAD', 'A bumpy animal like a frog', 'amphibians', 1, 4, 6),
(37, 22, 'SALAMANDER', 'A long animal that looks like a lizard', 'amphibians', 2, 7, 8),
(38, 22, 'AXOLOTL', 'A unique animal that stays young', 'amphibians', 3, 9, 10);

-- --------------------------------------------------------

--
-- Table structure for table `mascots`
--

CREATE TABLE `mascots` (
  `mascot_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `emoji_or_icon` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `point_cost` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mascots`
--

INSERT INTO `mascots` (`mascot_id`, `name`, `emoji_or_icon`, `description`, `point_cost`, `is_active`, `created_at`) VALUES
(1, 'Wise Owl', '🦉', 'Curious & clever!', 0, 1, '2026-08-01 08:02:05'),
(2, 'Clever Fox', '🦊', 'Quick & sly!', 0, 1, '2026-08-01 08:02:05'),
(3, 'Playful Dolphin', '🐬', 'Smart & friendly!', 0, 1, '2026-08-01 08:02:05'),
(4, 'Brave Lion', '🦁', 'Bold & fearless!', 0, 1, '2026-08-01 08:02:05'),
(5, 'Steady Turtle', '🐢', 'Patient & wise!', 0, 1, '2026-08-01 08:02:05'),
(6, 'Free Butterfly', '🦋', 'Creative & free!', 0, 1, '2026-08-01 08:02:05'),
(7, 'Hopping Frog', '🐸', 'Leaps to learn!', 0, 1, '2026-08-01 08:02:05'),
(8, 'Magic Unicorn', '🦄', 'Rare & wonderful!', 50, 1, '2026-08-01 08:02:05');

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

--
-- Dumping data for table `parents`
--

INSERT INTO `parents` (`parent_id`, `first_name`, `last_name`, `email`, `password_hash`, `phone`, `registered_date`) VALUES
(1, 'Test', 'Parent', 'test@email.com', '$2y$10$dummyhash1234567890', '9841000001', '2026-08-11 14:16:34'),
(21, 'Archie', 'Shrestha', 'archiepookie@gmail.com', '$2y$10$orrmGUTBc1DjscKylNvdx.np220I6LnAg0s/elP5Vt9ENZi7uGwAK', NULL, '2026-08-21 08:23:44'),
(22, 'Jelshi', 'Rai', 'raijeli2063@gmail.com', '$2y$10$z2rPquLTu7ewVJiU7tWwE.4Ddi1U/MfTP7RSEH1Dx4UxCJlrFTieq', NULL, '2026-09-09 09:39:18'),
(23, 'Dhan Kumar', 'Rai', 'dkthulung@gmail.com', '$2y$10$WTMCUyFGVRvrOMndok5YWOPsE9JUlYCGlz.Vf21rO0eXX5MPJsNAi', NULL, '2026-09-09 09:47:41'),
(24, 'Anupa', 'Pudasaini', 'anupapookie@gmail.com', '$2y$10$39ZmV7cRoLsdcpU56MqtD.RvGAr4RzdPIJTZXzRzgP1678JUSzEgG', NULL, '2026-09-09 09:50:48'),
(25, 'Nikita', 'Shrestha', 'nikitapookie@gmail.com', '$2y$10$dBp8kKDfKleT4aTMfiVUJu5SYbn0IPy7jmwQudPMEF1syNhvlPA12', NULL, '2026-09-09 09:59:20'),
(26, 'Surye', 'Dahal', 'surye12@gmail.com', '$2y$10$3hZzu9d3PJMGMYFzE5z/c.HCb6G2buaw8jv/lxwGF60qdV7bEK6XS', NULL, '2026-09-09 16:46:58'),
(27, 'Santu', 'Rai', 'raisantu123@gmail.com', '$2y$10$hdGkeRKRo2e8Pe/AKj3neun1IhmZpnzsSMKELrREObq01ICcyQSrK', NULL, '2026-09-12 08:40:31');

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
,`parent_name` varchar(101)
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
  `topic` varchar(20) NOT NULL,
  `concept` varchar(50) NOT NULL,
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
  `topic` varchar(20) NOT NULL,
  `concept` varchar(50) NOT NULL,
  `difficulty_tier_played` int(11) NOT NULL DEFAULT 1,
  `score_value` int(11) NOT NULL DEFAULT 0,
  `accuracy_percentage` decimal(5,2) DEFAULT NULL,
  `streak_achieved` int(11) DEFAULT 0,
  `coins_earned` int(11) NOT NULL DEFAULT 0,
  `date_played` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `scores`
--

INSERT INTO `scores` (`score_id`, `child_id`, `game_id`, `topic`, `concept`, `difficulty_tier_played`, `score_value`, `accuracy_percentage`, `streak_achieved`, `coins_earned`, `date_played`) VALUES
(21, 1, 2, 'nepal_adventure', 'Level 2', 1, 6, 100.00, 3, 204, '2026-09-09 15:06:35'),
(22, 24, 1, 'vocabulary', 'opposites', 1, 9, 90.00, 4, 19, '2026-09-09 16:09:06'),
(23, 9, 3, 'spelling', 'Level A', 1, 3, 100.00, 1, 5, '2026-09-10 07:44:57'),
(24, 9, 3, 'spelling', 'Level A', 1, 3, 100.00, 1, 5, '2026-09-10 07:45:09'),
(25, 9, 1, '', '', 1, 20, 100.00, 1, 20, '2026-09-12 05:32:08'),
(26, 9, 1, '', '', 1, 20, 100.00, 1, 20, '2026-09-12 05:32:10'),
(27, 9, 1, '', '', 1, 20, 100.00, 1, 20, '2026-09-12 05:32:12'),
(28, 9, 1, 'vocabulary', 'opposites', 1, 8, 80.00, 4, 18, '2026-09-12 05:39:49'),
(29, 9, 1, 'vocabulary', 'opposites', 1, 3, 30.00, 2, 1, '2026-09-12 05:41:04'),
(30, 9, 1, 'vocabulary', 'opposites', 1, 3, 30.00, 1, 1, '2026-09-12 08:17:53'),
(31, 9, 3, 'spelling', 'Level A', 1, 3, 100.00, 1, 5, '2026-09-12 08:18:24'),
(32, 1, 2, 'nepal_adventure', 'Level 1', 1, 6, 100.00, 3, 204, '2026-09-12 08:45:00'),
(33, 27, 1, 'grammar', 'is / am / are', 1, 2, 20.00, 1, 7, '2026-09-12 08:46:02'),
(34, 27, 3, 'spelling', 'Level A', 1, 3, 100.00, 1, 5, '2026-09-12 08:48:12');

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

--
-- Dumping data for table `shop_items`
--

INSERT INTO `shop_items` (`item_id`, `item_name`, `description`, `price_coins`, `icon_url`) VALUES
(1, 'Rocket Avatar Skin', 'Fly high with a shiny rocket space avatar!', 50, '🚀'),
(2, 'Golden Crown Badge', 'Wear the royal gold crown in your profile!', 150, '👑'),
(3, 'Capybara Mascot Costume', 'Dress your avatar in a cute capybara suit.', 100, '🦫'),
(4, 'Cosmic Theme Skin', 'Transform your dashboard into a dark galaxy.', 120, '🌌'),
(5, 'Wizard Hat Avatar', 'A magical hat for super smart learners.', 80, '🧙‍♂️'),
(6, 'Dinosaur Avatar', 'Roar into learning with a T-Rex profile avatar.', 90, '🦖'),
(7, 'Unicorn Avatar', 'Rainbow colored unicorn skin.', 90, '🦄'),
(8, 'Superhero Cape', 'Red cape badge for top scorers.', 110, '🦸‍♂️'),
(9, 'Ninja Mask Avatar', 'Sneaky ninja avatar skin.', 85, '🥷'),
(10, 'Pirate Hat Skin', 'Ahoy! Ahoy! Pirate hat for adventurous kids.', 75, '🏴‍☠️'),
(11, 'Golden Trophy Badge', 'Display a shiny gold trophy on your profile.', 200, '🏆'),
(12, 'Jungle Theme Skin', 'Green leafy theme for nature lovers.', 100, '🌴'),
(13, 'Ocean Waves Theme', 'Cool blue sea theme for your dashboard.', 100, '🌊'),
(14, 'Robot Avatar', 'Cool futuristic android avatar skin.', 110, '🤖'),
(15, 'Alien Spaceship Skin', 'UFO avatar skin from outer space.', 130, '🛸'),
(16, 'Detective Glasses', 'Magnifying glass badge for puzzle solvers.', 65, '🔍'),
(17, 'Artist Palette Badge', 'Colorful art badge for creative kids.', 70, '🎨'),
(18, 'Music Note Skin', 'Floating musical notes on your profile.', 80, '🎵'),
(19, 'Champion Belt', 'Wrestling belt badge for level masters.', 250, '🥊'),
(20, 'Rainbow Trail FX', 'Special visual trail when clicking games.', 300, '🌈');

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
  `duration_days` int(11) NOT NULL DEFAULT 30,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subscription_plans`
--

INSERT INTO `subscription_plans` (`plan_id`, `plan_name`, `price`, `duration_days`, `is_active`) VALUES
(1, 'Free Starter Tier', 0.00, 0, 1),
(2, 'Premium Monthly Basic', 499.00, 30, 1),
(3, 'Family Quarterly Pass', 1499.00, 90, 1),
(4, 'Premium Annual Saver', 4999.00, 365, 1),
(5, 'Trial 7 Day Pass', 0.00, 7, 1);

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
,`topic` varchar(20)
,`concept` varchar(50)
,`attempts` bigint(21)
,`best_score` int(11)
,`best_accuracy` decimal(5,2)
);

-- --------------------------------------------------------

--
-- Structure for view `progress_dashboard`
--
DROP TABLE IF EXISTS `progress_dashboard`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `progress_dashboard`  AS SELECT `c`.`child_id` AS `child_id`, `c`.`username` AS `child_name`, `c`.`age` AS `child_age`, `p`.`parent_id` AS `parent_id`, concat(`p`.`first_name`,' ',`p`.`last_name`) AS `parent_name`, `c`.`total_coins` AS `total_coins`, `c`.`current_level` AS `current_level`, count(distinct `cb`.`badge_id`) AS `badges_earned`, coalesce(avg(`cp`.`course_score`),0) AS `average_course_score`, count(distinct case when `cp`.`status` = 'completed' then `cp`.`course_id` end) AS `courses_completed`, coalesce((select sum(`ps`.`coins_spent`) from `purchases` `ps` where `ps`.`child_id` = `c`.`child_id`),0) AS `total_coins_spent` FROM (((`children` `c` join `parents` `p` on(`c`.`parent_id` = `p`.`parent_id`)) left join `child_badges` `cb` on(`c`.`child_id` = `cb`.`child_id`)) left join `child_progress` `cp` on(`c`.`child_id` = `cp`.`child_id`)) GROUP BY `c`.`child_id`, `p`.`parent_id` ;

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
-- Indexes for table `alphabet_adventure_levels`
--
ALTER TABLE `alphabet_adventure_levels`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_child_level` (`child_id`,`level_index`),
  ADD KEY `idx_child_id` (`child_id`);

--
-- Indexes for table `alphabet_adventure_progress`
--
ALTER TABLE `alphabet_adventure_progress`
  ADD PRIMARY KEY (`progress_id`),
  ADD UNIQUE KEY `unique_child_word` (`child_id`,`level_letter`,`word_index`),
  ADD KEY `idx_child_id` (`child_id`);

--
-- Indexes for table `alphabet_adventure_settings`
--
ALTER TABLE `alphabet_adventure_settings`
  ADD PRIMARY KEY (`child_id`);

--
-- Indexes for table `badges`
--
ALTER TABLE `badges`
  ADD PRIMARY KEY (`badge_id`);

--
-- Indexes for table `badge_criteria`
--
ALTER TABLE `badge_criteria`
  ADD PRIMARY KEY (`criteria_id`),
  ADD KEY `fk_criteria_badge` (`badge_id`),
  ADD KEY `fk_criteria_type` (`criteria_type_id`),
  ADD KEY `fk_criteria_game` (`game_id`);

--
-- Indexes for table `badge_criteria_types`
--
ALTER TABLE `badge_criteria_types`
  ADD PRIMARY KEY (`type_id`),
  ADD UNIQUE KEY `type_name` (`type_name`);

--
-- Indexes for table `capybara_child_progress`
--
ALTER TABLE `capybara_child_progress`
  ADD PRIMARY KEY (`child_id`,`content_id`),
  ADD KEY `fk_capybara_progress_child` (`child_id`),
  ADD KEY `fk_capybara_progress_content` (`content_id`);

--
-- Indexes for table `capybara_learning_content`
--
ALTER TABLE `capybara_learning_content`
  ADD PRIMARY KEY (`content_id`),
  ADD KEY `idx_level` (`level_number`),
  ADD KEY `idx_game` (`game_id`);

--
-- Indexes for table `capybara_level_scores`
--
ALTER TABLE `capybara_level_scores`
  ADD PRIMARY KEY (`child_id`,`level_number`),
  ADD KEY `fk_capybara_level_child` (`child_id`);

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
-- Indexes for table `child_flashcard_card_progress`
--
ALTER TABLE `child_flashcard_card_progress`
  ADD PRIMARY KEY (`child_id`,`card_id`),
  ADD KEY `card_id` (`card_id`);

--
-- Indexes for table `child_flashcard_question_progress`
--
ALTER TABLE `child_flashcard_question_progress`
  ADD PRIMARY KEY (`child_id`,`question_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `child_game_difficulty`
--
ALTER TABLE `child_game_difficulty`
  ADD PRIMARY KEY (`child_id`,`game_id`),
  ADD KEY `fk_cgd_game` (`game_id`);

--
-- Indexes for table `child_game_intro`
--
ALTER TABLE `child_game_intro`
  ADD PRIMARY KEY (`child_id`,`game_id`);

--
-- Indexes for table `child_progress`
--
ALTER TABLE `child_progress`
  ADD PRIMARY KEY (`progress_id`),
  ADD UNIQUE KEY `uk_child_course` (`child_id`,`course_id`),
  ADD KEY `fk_progress_course` (`course_id`);

--
-- Indexes for table `coin_transactions`
--
ALTER TABLE `coin_transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `fk_txn_child` (`child_id`),
  ADD KEY `idx_txn_source` (`source`);

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
-- Indexes for table `flashcard_cards`
--
ALTER TABLE `flashcard_cards`
  ADD PRIMARY KEY (`card_id`),
  ADD KEY `idx_flashcard_cards_deck` (`deck_id`);

--
-- Indexes for table `flashcard_decks`
--
ALTER TABLE `flashcard_decks`
  ADD PRIMARY KEY (`deck_id`),
  ADD KEY `idx_flashcard_decks_level` (`level_id`);

--
-- Indexes for table `flashcard_levels`
--
ALTER TABLE `flashcard_levels`
  ADD PRIMARY KEY (`level_id`),
  ADD KEY `idx_flashcard_levels_subject` (`subject_id`);

--
-- Indexes for table `flashcard_options`
--
ALTER TABLE `flashcard_options`
  ADD PRIMARY KEY (`option_id`),
  ADD KEY `idx_flashcard_options_question` (`question_id`);

--
-- Indexes for table `flashcard_puzzle_items`
--
ALTER TABLE `flashcard_puzzle_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `idx_flashcard_puzzle_items_question` (`question_id`);

--
-- Indexes for table `flashcard_questions`
--
ALTER TABLE `flashcard_questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `idx_flashcard_questions_level` (`level_id`);

--
-- Indexes for table `flashcard_subjects`
--
ALTER TABLE `flashcard_subjects`
  ADD PRIMARY KEY (`subject_id`);

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
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `alphabet_adventure_levels`
--
ALTER TABLE `alphabet_adventure_levels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `alphabet_adventure_progress`
--
ALTER TABLE `alphabet_adventure_progress`
  MODIFY `progress_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `badges`
--
ALTER TABLE `badges`
  MODIFY `badge_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `badge_criteria`
--
ALTER TABLE `badge_criteria`
  MODIFY `criteria_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `badge_criteria_types`
--
ALTER TABLE `badge_criteria_types`
  MODIFY `type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `capybara_learning_content`
--
ALTER TABLE `capybara_learning_content`
  MODIFY `content_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `children`
--
ALTER TABLE `children`
  MODIFY `child_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `child_badges`
--
ALTER TABLE `child_badges`
  MODIFY `child_badge_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `child_progress`
--
ALTER TABLE `child_progress`
  MODIFY `progress_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `coin_transactions`
--
ALTER TABLE `coin_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `flashcard_cards`
--
ALTER TABLE `flashcard_cards`
  MODIFY `card_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4037;

--
-- AUTO_INCREMENT for table `flashcard_decks`
--
ALTER TABLE `flashcard_decks`
  MODIFY `deck_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `flashcard_levels`
--
ALTER TABLE `flashcard_levels`
  MODIFY `level_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `flashcard_options`
--
ALTER TABLE `flashcard_options`
  MODIFY `option_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2181;

--
-- AUTO_INCREMENT for table `flashcard_puzzle_items`
--
ALTER TABLE `flashcard_puzzle_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3036;

--
-- AUTO_INCREMENT for table `flashcard_questions`
--
ALTER TABLE `flashcard_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1055;

--
-- AUTO_INCREMENT for table `flashcard_subjects`
--
ALTER TABLE `flashcard_subjects`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `game_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `hangman_words`
--
ALTER TABLE `hangman_words`
  MODIFY `word_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `mascots`
--
ALTER TABLE `mascots`
  MODIFY `mascot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `parent_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `parent_orders`
--
ALTER TABLE `parent_orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `parent_shop_items`
--
ALTER TABLE `parent_shop_items`
  MODIFY `parent_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `purchase_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

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
  MODIFY `score_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `shape_game_items`
--
ALTER TABLE `shape_game_items`
  MODIFY `shape_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `shop_items`
--
ALTER TABLE `shop_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `subscription_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subscription_plans`
--
ALTER TABLE `subscription_plans`
  MODIFY `plan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `badge_criteria`
--
ALTER TABLE `badge_criteria`
  ADD CONSTRAINT `fk_criteria_badge` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`badge_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_type` FOREIGN KEY (`criteria_type_id`) REFERENCES `badge_criteria_types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `capybara_child_progress`
--
ALTER TABLE `capybara_child_progress`
  ADD CONSTRAINT `fk_capybara_progress_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_capybara_progress_content` FOREIGN KEY (`content_id`) REFERENCES `capybara_learning_content` (`content_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `capybara_learning_content`
--
ALTER TABLE `capybara_learning_content`
  ADD CONSTRAINT `fk_capybara_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `capybara_level_scores`
--
ALTER TABLE `capybara_level_scores`
  ADD CONSTRAINT `fk_capybara_level_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Constraints for table `child_flashcard_card_progress`
--
ALTER TABLE `child_flashcard_card_progress`
  ADD CONSTRAINT `child_flashcard_card_progress_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `child_flashcard_card_progress_ibfk_2` FOREIGN KEY (`card_id`) REFERENCES `flashcard_cards` (`card_id`) ON DELETE CASCADE;

--
-- Constraints for table `child_flashcard_question_progress`
--
ALTER TABLE `child_flashcard_question_progress`
  ADD CONSTRAINT `child_flashcard_question_progress_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `child_flashcard_question_progress_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `flashcard_questions` (`question_id`) ON DELETE CASCADE;

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
-- Constraints for table `coin_transactions`
--
ALTER TABLE `coin_transactions`
  ADD CONSTRAINT `fk_txn_child` FOREIGN KEY (`child_id`) REFERENCES `children` (`child_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `flashcard_cards`
--
ALTER TABLE `flashcard_cards`
  ADD CONSTRAINT `flashcard_cards_ibfk_1` FOREIGN KEY (`deck_id`) REFERENCES `flashcard_decks` (`deck_id`) ON DELETE CASCADE;

--
-- Constraints for table `flashcard_decks`
--
ALTER TABLE `flashcard_decks`
  ADD CONSTRAINT `flashcard_decks_ibfk_1` FOREIGN KEY (`level_id`) REFERENCES `flashcard_levels` (`level_id`) ON DELETE CASCADE;

--
-- Constraints for table `flashcard_levels`
--
ALTER TABLE `flashcard_levels`
  ADD CONSTRAINT `flashcard_levels_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `flashcard_subjects` (`subject_id`) ON DELETE CASCADE;

--
-- Constraints for table `flashcard_options`
--
ALTER TABLE `flashcard_options`
  ADD CONSTRAINT `flashcard_options_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `flashcard_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `flashcard_puzzle_items`
--
ALTER TABLE `flashcard_puzzle_items`
  ADD CONSTRAINT `flashcard_puzzle_items_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `flashcard_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `flashcard_questions`
--
ALTER TABLE `flashcard_questions`
  ADD CONSTRAINT `flashcard_questions_ibfk_1` FOREIGN KEY (`level_id`) REFERENCES `flashcard_levels` (`level_id`) ON DELETE CASCADE;

--
-- Constraints for table `game_access`
--
ALTER TABLE `game_access`
  ADD CONSTRAINT `fk_gameaccess_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gameaccess_plan` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`plan_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
