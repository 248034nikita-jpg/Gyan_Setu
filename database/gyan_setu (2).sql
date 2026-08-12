-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 12, 2026 at 09:55 AM
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
(1, 'First Steps', 'Collect your first orange!', '🦶', 10, 1, '2026-08-09 07:04:11'),
(2, 'Thinker', 'Get your first THINK question correct!', '🤔', 15, 1, '2026-08-09 07:04:11'),
(3, 'Solver', 'Get your first APPLY question correct!', '✅', 15, 1, '2026-08-09 07:04:11'),
(4, 'Level Explorer', 'Complete your first level!', '🗺️', 25, 1, '2026-08-09 07:04:11'),
(5, 'Knowledge Seeker', 'Get 10 questions correct!', '📚', 40, 1, '2026-08-09 07:04:11'),
(6, 'Mountain Climber', 'Complete 3 levels!', '⛰️', 50, 1, '2026-08-09 07:04:11'),
(7, 'Perfect Score', 'Get 100% correct in a single level!', '⭐', 50, 1, '2026-08-09 07:04:11'),
(8, 'Streak Master', 'Get 5 correct answers in a row!', '🔥', 30, 1, '2026-08-09 07:04:11'),
(9, 'Coin Collector', 'Earn 100 total coins!', '🪙', 30, 1, '2026-08-09 07:04:11'),
(10, 'Nepal Explorer', 'Complete all 9 levels!', '🇳🇵', 100, 1, '2026-08-09 07:04:11');

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
(1, 1, 8, 21, '', '', NULL, 1),
(2, 2, 4, 21, '', '', NULL, 1),
(3, 3, 4, 21, '', '', NULL, 1),
(4, 4, 1, 21, '', '', NULL, 1),
(5, 5, 4, 21, '', '', NULL, 10),
(6, 6, 1, 21, '', '', NULL, 3),
(7, 7, 2, 21, '', '', NULL, 1),
(8, 8, 3, 21, '', '', NULL, 5),
(9, 9, 9, NULL, '', '', NULL, 100),
(10, 10, 1, 21, '', '', NULL, 9);

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
(1, 1, 61, 56, 1, 5, '2026-08-12 07:23:12', '2026-08-12 07:23:12'),
(1, 2, 16, 9, 1, 3, '2026-08-12 07:23:26', '2026-08-12 07:23:26'),
(1, 3, 14, 9, 1, 3, '2026-08-12 07:23:35', '2026-08-12 07:23:35'),
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
(1, 1, 21, 'Did you know? Kathmandu is called the \"City of Temples\" because it has over 600 ancient temples! The oldest one, Changu Narayan, is more than 1,600 years old – that\'s even older than your great-great-great-grandparents!', 'Why do you think Kathmandu is called the \"City of Temples\"?', '[\"Because it has many modern buildings\", \"Because it has over 600 ancient temples\", \"Because it has many parks\", \"Because it is very big\"]', 1, 'How many ancient temples does Kathmandu have?', '[\"Over 100\", \"Over 600\", \"Over 1000\", \"Over 2000\"]', 1, 'Kathmandu is called the \"City of Temples\" because it has over 600 ancient temples! The oldest one is more than 1,600 years old – that\'s older than anything you\'ve ever seen!', 'के तपाईंलाई थाहा छ? काठमाडौंलाई \"मन्दिरको सहर\" भनिन्छ किनभने यहाँ ६०० भन्दा बढी पुराना मन्दिरहरू छन्! सबैभन्दा पुरानो मन्दिर चाँगुनारायण हो, जो १,६०० वर्षभन्दा पुरानो छ – यो तपाईंका हजुरबा-हजुरआमाभन्दा पनि पुरानो हो!', 'काठमाडौंलाई \"मन्दिरको सहर\" किन भनिन्छ?', '[\"किनभने यहाँ धेरै आधुनिक भवनहरू छन्\", \"किनभने यहाँ ६०० भन्दा बढी पुराना मन्दिरहरू छन्\", \"किनभने यहाँ धेरै पार्कहरू छन्\", \"किनभने यो धेरै ठूलो छ\"]', 'काठमाडौंमा कति पुराना मन्दिरहरू छन्?', '[\"१०० भन्दा बढी\", \"६०० भन्दा बढी\", \"१००० भन्दा बढी\", \"२००० भन्दा बढी\"]', 'काठमाडौंलाई \"मन्दिरको सहर\" भनिन्छ किनभने यहाँ ६०० भन्दा बढी पुराना मन्दिरहरू छन्! सबैभन्दा पुरानो मन्दिर १,६०० वर्षभन्दा पुरानो छ – यो तपाईंले देख्नुभएको कुनै पनि वस्तुभन्दा पुरानो हो!', NULL, NULL, '2026-08-09 07:04:12'),
(2, 1, 21, 'Imagine walking through a square where kings once ruled! Durbar Square in Kathmandu is filled with palaces and temples covered in beautiful carvings. The most famous one has a wooden window with 55 intricately carved frames – one for each king!', 'Why do you think Durbar Square is important to Nepal\'s history?', '[\"It was a marketplace\", \"It was where kings ruled and lived\", \"It was a farming area\", \"It was a playground\"]', 1, 'How many carved frames does the famous wooden window at Durbar Square have?', '[\"55\", \"25\", \"100\", \"75\"]', 0, 'Durbar Square was where the Malla kings ruled and lived. The famous window with 55 frames represents 55 kings who ruled from there – it\'s like a history book carved in wood!', 'कल्पना गर्नुहोस् कि तपाईं त्यो चोकमा हिँड्दै हुनुहुन्छ जहाँ राजाहरूले शासन गर्थे! काठमाडौंको दरबार स्क्वायर दरबार र मन्दिरहरूले भरिएको छ जसमा सुन्दर कलाकृतिहरू छन्। सबैभन्दा प्रसिद्ध एउटा काठको झ्याल हो जसमा ५५ वटा नक्काशी गरिएका फ्रेमहरू छन् – प्रत्येक राजाको लागि एउटा!', 'दरबार स्क्वायर नेपालको इतिहासको लागि किन महत्वपूर्ण छ?', '[\"यो बजार थियो\", \"यो राजाहरूले शासन गर्ने र बस्ने ठाउँ थियो\", \"यो खेती क्षेत्र थियो\", \"यो खेल मैदान थियो\"]', 'दरबार स्क्वायरको प्रसिद्ध काठको झ्यालमा कति वटा नक्काशी गरिएका फ्रेमहरू छन्?', '[\"५५\", \"२५\", \"१००\", \"७५\"]', 'दरबार स्क्वायर मल्ल राजाहरूले शासन गर्ने र बस्ने ठाउँ थियो। ५५ फ्रेम भएको प्रसिद्ध झ्यालले ५५ जना राजाहरूको प्रतिनिधित्व गर्छ – यो काठमा कुँदिएको इतिहासको किताब जस्तै हो!', NULL, NULL, '2026-08-09 07:04:12'),
(3, 1, 21, 'The Pashupatinath Temple sits right next to the Bagmati River. People believe the river is holy – they perform special ceremonies on its banks. The temple has a golden roof that shines so brightly, you can see it from far away!', 'Why do you think temples are often built near rivers?', '[\"For easy water access\", \"For spiritual ceremonies and purification\", \"For scenic views\", \"For fishing\"]', 1, 'What is the name of the river that flows beside Pashupatinath Temple?', '[\"Bagmati\", \"Gandaki\", \"Koshi\", \"Karnali\"]', 0, 'Hindu people believe rivers are holy. Pashupatinath Temple is built on the Bagmati River so people can perform special ceremonies and purify themselves in the sacred water.', 'पशुपतिनाथ मन्दिर बागमती नदीको छेउमा अवस्थित छ। मानिसहरू विश्वास गर्छन् कि नदी पवित्र छ – तिनीहरू यसको किनारमा विशेष अनुष्ठानहरू गर्छन्। मन्दिरको सुनको छाना यति चम्किलो छ कि तपाईं यसलाई टाढाबाट देख्न सक्नुहुन्छ!', 'मन्दिरहरू प्रायः नदीको किनारमा किन बनाइन्छ?', '[\"सजिलो पानी पहुँचको लागि\", \"आध्यात्मिक अनुष्ठान र शुद्धिकरणको लागि\", \"सुन्दर दृश्यको लागि\", \"माछा मार्नको लागि\"]', 'पशुपतिनाथ मन्दिरको छेउमा बग्ने नदीको नाम के हो?', '[\"बागमती\", \"गण्डकी\", \"कोशी\", \"कर्णाली\"]', 'हिन्दुहरू विश्वास गर्छन् कि नदीहरू पवित्र हुन्छन्। पशुपतिनाथ मन्दिर बागमती नदीको किनारमा बनाइएको हो ताकि मानिसहरूले विशेष अनुष्ठान गर्न र पवित्र पानीमा शुद्ध हुन सकून्।', NULL, NULL, '2026-08-09 07:04:12'),
(4, 2, 21, 'In Nepal, the cow is so special that it\'s against the law to hurt one! It\'s the national animal and is treated with great respect. People even celebrate a festival called Gai Puja where they honour cows with garlands and special treats!', 'Why do you think the cow is treated with such great respect in Nepal?', '[\"Because it gives milk\", \"Because it is sacred and a symbol of kindness\", \"Because it is strong\", \"Because it is big\"]', 1, 'What is the national animal of Nepal?', '[\"Elephant\", \"Cow\", \"Tiger\", \"Lion\"]', 1, 'The cow is considered sacred in Nepal. It\'s protected by law and honoured during the festival of Gai Puja. People show their respect by giving cows garlands and special treats.', 'नेपालमा, गाई यति विशेष छ कि यसलाई चोट पुर्याउनु कानूनविरुद्ध हो! यो राष्ट्रिय पशु हो र यसलाई धेरै सम्मान गरिन्छ। मानिसहरू गाई पूजा भन्ने चाड पनि मनाउँछन् जहाँ तिनीहरू गाईलाई माला र विशेष खाना दिएर सम्मान गर्छन्!', 'गाईलाई नेपालमा यति धेरै सम्मान किन गरिन्छ?', '[\"किनभने यसले दूध दिन्छ\", \"किनभने यो पवित्र र दयालुताको प्रतीक हो\", \"किनभने यो बलियो छ\", \"किनभने यो ठूलो छ\"]', 'नेपालको राष्ट्रिय पशु के हो?', '[\"हात्ती\", \"गाई\", \"बाघ\", \"सिंह\"]', 'गाईलाई नेपालमा पवित्र मानिन्छ। यो कानूनद्वारा संरक्षित छ र गाई पूजा चाडमा सम्मान गरिन्छ। मानिसहरू गाईलाई माला र विशेष खाना दिएर सम्मान देखाउँछन्।', NULL, NULL, '2026-08-09 07:13:18'),
(5, 2, 21, 'The rhododendron, or Lali Gurans, is Nepal\'s national flower – and it\'s absolutely gorgeous! It blooms in bright red and covers the Himalayan hillsides like a giant red carpet. The flower is so beautiful that it inspired a famous Nepali song!', 'Why do you think the rhododendron was chosen as Nepal\'s national flower?', '[\"Because it grows everywhere\", \"Because it blooms in bright red and represents the Himalayas\", \"Because it has a nice smell\", \"Because it is very tall\"]', 1, 'What is Nepal\'s national flower called in Nepali?', '[\"Lali Gurans\", \"Sunakhari\", \"Gulaf\", \"Chameli\"]', 0, 'The rhododendron, or Lali Gurans, was chosen as Nepal\'s national flower because it blooms in bright red and covers the Himalayan hillsides – representing the beauty and spirit of Nepal.', 'लाली गुराँस नेपालको राष्ट्रिय फूल हो – र यो अत्यन्तै सुन्दर छ! यो चम्किलो रातो रंगमा फुल्छ र हिमालयका पहाडहरूलाई विशाल रातो कार्पेट जस्तै ढाक्छ। यो फूल यति सुन्दर छ कि यसले एउटा प्रसिद्ध नेपाली गीतलाई प्रेरित गरेको छ!', 'लाली गुराँसलाई नेपालको राष्ट्रिय फूलको रूपमा किन छानियो होला?', '[\"किनभने यो जताततै उम्रन्छ\", \"किनभने यो चम्किलो रातो रंगमा फुल्छ र हिमालयको प्रतिनिधित्व गर्छ\", \"किनभने यसको गन्ध राम्रो छ\", \"किनभने यो धेरै अग्लो छ\"]', 'नेपालको राष्ट्रिय फूललाई नेपालीमा के भनिन्छ?', '[\"लाली गुराँस\", \"सुनाखरी\", \"गुलाफ\", \"चमेली\"]', 'लाली गुराँसलाई नेपालको राष्ट्रिय फूलको रूपमा छानियो किनभने यो चम्किलो रातो रंगमा फुल्छ र हिमालयका पहाडहरूलाई ढाक्छ – जसले नेपालको सौन्दर्य र भावनाको प्रतिनिधित्व गर्छ।', NULL, NULL, '2026-08-09 07:13:18'),
(6, 2, 21, 'Nepal\'s flag is the ONLY flag in the world that isn\'t a rectangle! The two triangles represent the Himalayan mountains. The flag also has symbols of the sun and moon – some say it means Nepal will exist as long as the sun and moon shine!', 'What is unique about Nepal\'s flag compared to other countries?', '[\"It has no colour\", \"It is the only non-rectangular flag in the world\", \"It has a picture of an animal\", \"It is very small\"]', 1, 'How many triangles does Nepal\'s flag have?', '[\"1\", \"2\", \"3\", \"4\"]', 1, 'Nepal\'s flag is the only non-rectangular flag in the world. The two triangles represent the Himalayan mountains, and the sun and moon symbols represent Nepal\'s hope for eternity.', 'नेपालको झण्डा विश्वको एक मात्र गैर-आयताकार राष्ट्रिय झण्डा हो! दुईवटा त्रिकोणले हिमालय पर्वतलाई प्रतिनिधित्व गर्छन्। झण्डामा सूर्य र चन्द्रमाका प्रतीकहरू पनि छन् – कोही भन्छन् यसको अर्थ सूर्य र चन्द्रमा चम्किरहेसम्म नेपाल रहिरहनेछ!', 'अन्य देशहरूको तुलनामा नेपालको झण्डाको विशेषता के हो?', '[\"यसमा रंग छैन\", \"यो विश्वको एक मात्र गैर-आयताकार झण्डा हो\", \"यसमा जनावरको चित्र छ\", \"यो धेरै सानो छ\"]', 'नेपालको झण्डामा कति ओटा त्रिकोणहरू छन्?', '[\"१\", \"२\", \"३\", \"४\"]', 'नेपालको झण्डा विश्वको एक मात्र गैर-आयताकार झण्डा हो। दुई त्रिकोणले हिमालय पर्वतको प्रतिनिधित्व गर्छन्, र सूर्य र चन्द्रमाका प्रतीकहरूले नेपालको अनन्तताको आशाको प्रतिनिधित्व गर्छन्।', NULL, NULL, '2026-08-09 07:13:18'),
(7, 3, 21, 'Mount Everest is so high that at its peak, you\'re closer to space than to the ground! It\'s 8,848 metres tall – that\'s like stacking 20 Burj Khalifas (the world\'s tallest building) on top of each other! Climbing it takes months and climbers need special oxygen to breathe!', 'Why do you think Mount Everest attracts climbers from all over the world?', '[\"Because it\'s the tallest mountain in the world\", \"Because it\'s easy to climb\", \"Because it has the best views\", \"Because it\'s close to home\"]', 0, 'How tall is Mount Everest?', '[\"8,848 metres\", \"6,000 metres\", \"12,000 metres\", \"10,000 metres\"]', 0, 'Mount Everest is the tallest mountain in the world at 8,848 metres. It\'s so high that planes fly below its summit! Climbers need months of training and special oxygen to reach the top.', 'सगरमाथा यति अग्लो छ कि यसको शिखरमा पुग्दा, तपाईं जमिनभन्दा अन्तरिक्षको नजिक हुनुहुन्छ! यो ८,८४८ मिटर अग्लो छ – यो २० वटा बुर्ज खलिफा (विश्वको अग्लो भवन) एकअर्कामाथि राखेजस्तै हो! यसमा चढ्न महिनौं लाग्छ र आरोहीहरूलाई सास फेर्न विशेष अक्सिजन चाहिन्छ!', 'सगरमाथाले विश्वभरका आरोहीहरूलाई किन आकर्षित गर्छ?', '[\"किनभने यो विश्वको सबैभन्दा अग्लो हिमाल हो\", \"किनभने यो चढ्न सजिलो छ\", \"किनभने यसको दृश्य सबैभन्दा राम्रो छ\", \"किनभने यो घरको नजिक छ\"]', 'सगरमाथा कति अग्लो छ?', '[\"८,८४८ मिटर\", \"६,००० मिटर\", \"१२,००० मिटर\", \"१०,००० मिटर\"]', 'सगरमाथा विश्वको सबैभन्दा अग्लो हिमाल हो, ८,८४८ मिटर। यो यति अग्लो छ कि विमानहरू यसको शिखरभन्दा तल उड्छन्! आरोहीहरूलाई शिखरमा पुग्न महिनौंको तालिम र विशेष अक्सिजन चाहिन्छ।', NULL, NULL, '2026-08-09 07:13:18'),
(8, 3, 21, 'Nepal is home to 8 of the world\'s 14 highest mountains! The Himalayan range runs right through the country like a giant backbone. The mountains are so tall that they create their own weather – they block rain clouds and make the Terai region one of the most fertile areas on Earth!', 'Why does Nepal have so many of the world\'s highest mountains?', '[\"Because the Himalayan range runs through Nepal\", \"Because of volcanoes\", \"Because of earthquakes\", \"Because of the ocean\"]', 0, 'How many of the world\'s highest mountains are in Nepal?', '[\"5\", \"8\", \"10\", \"12\"]', 1, 'Nepal has 8 of the 14 highest mountains because the Himalayan range runs through the country. These tall mountains even create their own weather patterns!', 'नेपाल विश्वका १४ अग्ला हिमालमध्ये ८ ओटाको घर हो! हिमालय श्रृंखला देशभर विशाल ढाडजस्तै फैलिएको छ। हिमालहरू यति अग्ला छन् कि तिनीहरूले आफ्नै मौसम बनाउँछन् – तिनीहरूले वर्षाका बादलहरूलाई रोक्छन् र तराई क्षेत्रलाई विश्वको सबैभन्दा उर्वर क्षेत्रहरूमध्ये एक बनाउँछन्!', 'नेपालमा विश्वका सबैभन्दा अग्ला हिमालहरू किन धेरै छन्?', '[\"किनभने हिमालय श्रृंखला नेपालबाट गुज्रिन्छ\", \"ज्वालामुखीको कारणले\", \"भूकम्पको कारणले\", \"समुद्रको कारणले\"]', 'विश्वका कति ओटा अग्ला हिमालहरू नेपालमा छन्?', '[\"५\", \"८\", \"१०\", \"१२\"]', 'नेपालमा १४ अग्ला हिमालमध्ये ८ ओटा छन् किनभने हिमालय श्रृंखला देशबाट गुज्रिन्छ। यी अग्ला हिमालहरूले आफ्नै मौसम प्रणाली बनाउँछन्!', NULL, NULL, '2026-08-09 07:13:18'),
(9, 3, 21, 'Sagarmatha National Park isn\'t just about Mount Everest – it\'s home to some amazing animals too! The snow leopard, the red panda, and even the Himalayan black bear live there. The park is so special that UNESCO called it a World Heritage Site!', 'Why do you think Sagarmatha National Park is protected as a World Heritage Site?', '[\"It has unique animals and the highest mountain\", \"It has the best views\", \"It has many hotels\", \"It has the most tourists\"]', 0, 'Which rare animal is found in Sagarmatha National Park?', '[\"Snow leopard\", \"Elephant\", \"Tiger\", \"Lion\"]', 0, 'Sagarmatha National Park is protected because it has Mount Everest AND rare animals like the snow leopard and red panda – making it one of the most special places on Earth!', 'सगरमाथा राष्ट्रिय निकुञ्ज सगरमाथाको बारेमा मात्र होइन – यो केही अद्भुत जनावरहरूको घर पनि हो! हिउँ चितुवा, रातो पाण्डा, र हिमालय कालो भालु पनि त्यहाँ बस्छन्। यो निकुञ्ज यति विशेष छ कि युनेस्कोले यसलाई विश्व सम्पदा स्थल घोषणा गरेको छ!', 'सगरमाथा राष्ट्रिय निकुञ्जलाई विश्व सम्पदा स्थलको रूपमा किन संरक्षित गरिएको होला?', '[\"यसमा अद्वितीय जनावर र सबैभन्दा अग्लो हिमाल छ\", \"यसको दृश्य सबैभन्दा राम्रो छ\", \"यहाँ धेरै होटलहरू छन्\", \"यहाँ सबैभन्दा धेरै पर्यटकहरू छन्\"]', 'सगरमाथा राष्ट्रिय निकुञ्जमा कुन दुर्लभ जनावर पाइन्छ?', '[\"हिउँ चितुवा\", \"हात्ती\", \"बाघ\", \"सिंह\"]', 'सगरमाथा राष्ट्रिय निकुञ्ज संरक्षित छ किनभने यसमा सगरमाथा र हिउँ चितुवा र रातो पाण्डा जस्ता दुर्लभ जनावरहरू छन् – जसले यसलाई विश्वको सबैभन्दा विशेष स्थानहरूमध्ये एक बनाउँछ!', NULL, NULL, '2026-08-09 07:13:18'),
(10, 4, 21, 'The Terai region is called the \"granary\" of Nepal – it produces so much rice that it feeds the whole country! The soil is so rich because rivers from the Himalayas bring down nutrient-packed mud. Without the Terai, there\'d be no dal bhat for anyone!', 'Why is the Terai region called the \"granary\" of Nepal?', '[\"It has many factories\", \"It produces lots of rice and crops\", \"It has the most people\", \"It has the most schools\"]', 1, 'Which region of Nepal is known as the \"granary\" of the country?', '[\"Terai\", \"Himalayas\", \"Hills\", \"Kathmandu Valley\"]', 0, 'The Terai region is called Nepal\'s granary because it produces so much rice and other crops – thanks to its rich soil and warm climate.', 'तराई क्षेत्रलाई नेपालको \"अन्न भण्डार\" भनिन्छ – यसले यति धेरै धान उत्पादन गर्छ कि यसले सम्पूर्ण देशलाई खुवाउँछ! माटो यति उर्वर छ किनभने हिमालयका नदीहरूले पोषक तत्वले भरिएको माटो ल्याउँछन्। तराई नभए कसैलाई पनि दाल भात खान पाइने थिएन!', 'तराई क्षेत्रलाई नेपालको \"अन्न भण्डार\" किन भनिन्छ?', '[\"यहाँ धेरै कारखानाहरू छन्\", \"यसले धेरै धान र बाली उत्पादन गर्छ\", \"यहाँ सबैभन्दा धेरै मानिसहरू छन्\", \"यहाँ सबैभन्दा धेरै विद्यालयहरू छन्\"]', 'नेपालको कुन क्षेत्रलाई \"अन्न भण्डार\" भनिन्छ?', '[\"तराई\", \"हिमालय\", \"पहाड\", \"काठमाडौं उपत्यका\"]', 'तराई क्षेत्रलाई नेपालको अन्न भण्डार भनिन्छ किनभने यसले धेरै धान र अन्य बालीहरू उत्पादन गर्छ – यसको उर्वर माटो र न्यानो मौसमको कारणले।', NULL, NULL, '2026-08-09 07:13:18'),
(11, 4, 21, 'Chitwan National Park is like a real-life \"Jungle Book\"! It\'s home to the rare one-horned rhinoceros – you can\'t find them anywhere else on Earth. The park also has crocodiles, leopards, and even royal Bengal tigers! You can ride elephants to spot them!', 'Why is Chitwan National Park so special?', '[\"It has rare animals like the one-horned rhino\", \"It has the most trees\", \"It has the best weather\", \"It has the biggest lake\"]', 0, 'Which national park is famous for the one-horned rhinoceros?', '[\"Sagarmatha\", \"Chitwan\", \"Bardiya\", \"Langtang\"]', 1, 'Chitwan National Park is special because it protects the rare one-horned rhinoceros – a species found only in Nepal and India. It\'s a real-life adventure park!', 'चितवन राष्ट्रिय निकुञ्ज एउटा वास्तविक \"जंगल बुक\" जस्तै हो! यो दुर्लभ एकसिङ्गे गैंडाको घर हो – तपाईं तिनीहरूलाई पृथ्वीमा कतै पनि फेला पार्न सक्नुहुन्न। निकुञ्जमा गोही, चितुवा, र शाही बंगाल बाघ पनि छन्! तपाईं तिनीहरूलाई हेर्न हात्ती चढ्न सक्नुहुन्छ!', 'चितवन राष्ट्रिय निकुञ्ज किन यति विशेष छ?', '[\"यसमा एकसिङ्गे गैंडा जस्ता दुर्लभ जनावरहरू छन्\", \"यसमा सबैभन्दा धेरै रूखहरू छन्\", \"यहाँको मौसम सबैभन्दा राम्रो छ\", \"यहाँ सबैभन्दा ठूलो ताल छ\"]', 'एकसिङ्गे गैंडाको लागि कुन राष्ट्रिय निकुञ्ज प्रसिद्ध छ?', '[\"सगरमाथा\", \"चितवन\", \"बर्दिया\", \"लाङटाङ\"]', 'चितवन राष्ट्रिय निकुञ्ज विशेष छ किनभने यसले दुर्लभ एकसिङ्गे गैंडाको संरक्षण गर्छ – एक प्रजाति जो नेपाल र भारतमा मात्र पाइन्छ। यो एउटा वास्तविक साहसिक पार्क हो!', NULL, NULL, '2026-08-09 07:13:18'),
(12, 4, 21, 'Did you know Nepal has doubled its tiger population? The royal Bengal tiger is one of the most powerful animals on Earth – a single tiger can weigh as much as a small car! Nepal\'s conservation efforts are so successful that scientists from all over the world come to study them!', 'Why are tigers important to the ecosystem?', '[\"They are at the top of the food chain\", \"They are beautiful\", \"They are friendly\", \"They are fast\"]', 0, 'Where do Bengal tigers live in Nepal?', '[\"In the mountains\", \"In the Terai forests\", \"In the cities\", \"In the ocean\"]', 1, 'Tigers are top predators – they keep the balance of nature in check. Nepal\'s successful conservation has doubled the tiger population, making it a global success story!', 'के तपाईंलाई थाहा छ नेपालले आफ्नो बाघको जनसंख्या दोब्बर बनाएको छ? शाही बंगाल बाघ पृथ्वीको सबैभन्दा शक्तिशाली जनावरहरूमध्ये एक हो – एउटा बाघको तौल एउटा सानो कार जत्तिकै हुन्छ! नेपालको संरक्षण प्रयास यति सफल छ कि विश्वभरका वैज्ञानिकहरू तिनीहरूको अध्ययन गर्न आउँछन्!', 'बाघहरू पारिस्थितिकी प्रणालीको लागि किन महत्वपूर्ण छन्?', '[\"तिनीहरू खाद्य श्रृंखलाको शीर्षमा छन्\", \"तिनीहरू सुन्दर छन्\", \"तिनीहरू मित्रवत छन्\", \"तिनीहरू छिटो छन्\"]', 'बंगाल बाघहरू नेपालमा कहाँ बस्छन्?', '[\"पहाडमा\", \"तराईका जंगलहरूमा\", \"सहरहरूमा\", \"समुद्रमा\"]', 'बाघहरू शीर्ष शिकारी हुन् – तिनीहरूले प्रकृतिको सन्तुलन कायम राख्छन्। नेपालको सफल संरक्षणले बाघको जनसंख्या दोब्बर बनाएको छ, जसले यसलाई विश्वव्यापी सफलताको कथा बनाएको छ!', NULL, NULL, '2026-08-09 07:13:18'),
(13, 5, 21, 'Dashain is Nepal\'s biggest party – it lasts 15 days! People fly kites, play on giant bamboo swings, and even build ferris wheels! The sky is filled with colorful kites, and children shout \"Changa cheit\" whenever they cut someone\'s kite string!', 'Why do you think Dashain is celebrated with so much fun and excitement?', '[\"It\'s a public holiday\", \"It\'s a time for family, celebration, and fun activities\", \"People get gifts\", \"It\'s the only holiday\"]', 1, 'How many days does Dashain last?', '[\"10 days\", \"15 days\", \"20 days\", \"25 days\"]', 1, 'Dashain is Nepal\'s biggest festival – it\'s 15 days of family reunions, delicious food, and fun activities like kite flying and swings. It\'s a time to celebrate with loved ones!', 'दशैं नेपालको सबैभन्दा ठूलो पार्टी हो – यो १५ दिनसम्म चल्छ! मानिसहरू चङ्गा उडाउँछन्, विशाल बाँसको पिङ खेल्छन्, र फेरिस ह्वील पनि बनाउँछन्! आकाश रंगीविरंगी चङ्गाहरूले भरिन्छ, र बच्चाहरूले कसैको चङ्गाको डोरी काट्दा \"चङ्गा चैत\" भनेर कराउँछन्!', 'दशैं यति धेरै मजा र उत्साहका साथ किन मनाइन्छ?', '[\"यो सार्वजनिक बिदा हो\", \"यो परिवार, उत्सव, र रमाइला गतिविधिहरूको समय हो\", \"मानिसहरूलाई उपहार मिल्छ\", \"यो मात्र चाड हो\"]', 'दशैं कति दिनसम्म चल्छ?', '[\"१० दिन\", \"१५ दिन\", \"२० दिन\", \"२५ दिन\"]', 'दशैं नेपालको सबैभन्दा ठूलो चाड हो – यो १५ दिनको परिवार पुनर्मिलन, स्वादिष्ट खाना, र चङ्गा उडाउने र पिङ खेल्ने जस्ता रमाइला गतिविधिहरूको समय हो। यो आफन्तहरूसँग उत्सव मनाउने समय हो!', NULL, NULL, '2026-08-09 07:13:18'),
(14, 5, 21, 'During Dashain, elders put tika (red powder mixed with rice) on younger people\'s foreheads. It\'s like getting a special blessing! They also give jamara – barley sprouts that look like tiny green crowns. Getting tika means you\'ve been blessed for the whole year!', 'Why is receiving tika and jamara during Dashain so special?', '[\"It\'s a sign of respect and blessings from elders\", \"It\'s a fashion trend\", \"It\'s a gift\", \"It\'s a game\"]', 0, 'What do elders give to younger people during Dashain?', '[\"Money\", \"Tika and jamara\", \"New clothes\", \"Toys\"]', 1, 'Tika and jamara are blessings from elders. When you receive them, it means you\'ve been blessed with good luck, health, and happiness for the whole year!', 'दशैंको समयमा, ठूलाबडाले कान्छाहरूको निधारमा टीका (रातो पाउडर र चामल) लगाइदिन्छन्। यो विशेष आशीर्वाद पाउनु जस्तै हो! तिनीहरूले जमरा पनि दिन्छन् – जौको बिरुवा जो साना हरियो मुकुट जस्तै देखिन्छ। टीका पाउनुको अर्थ तपाईंले पूरै वर्षको लागि आशीर्वाद पाउनु हो!', 'दशैंमा टीका र जमरा प्राप्त गर्नु किन यति विशेष छ?', '[\"यो ठूलाबडाको सम्मान र आशीर्वादको चिन्ह हो\", \"यो फेसन ट्रेन्ड हो\", \"यो उपहार हो\", \"यो खेल हो\"]', 'दशैंमा ठूलाबडाले कान्छाहरूलाई के दिन्छन्?', '[\"पैसा\", \"टीका र जमरा\", \"नयाँ लुगा\", \"खेलौना\"]', 'टीका र जमरा ठूलाबडाको आशीर्वाद हो। जब तपाईंले तिनीहरू प्राप्त गर्नुहुन्छ, यसको अर्थ तपाईंले पूरै वर्षको लागि शुभकामना, स्वास्थ्य, र खुशीको आशीर्वाद पाउनुभएको छ!', NULL, NULL, '2026-08-09 07:13:18'),
(15, 5, 21, 'The most important day of Dashain is called Bijaya Dashami – the Day of Victory! It\'s believed that the goddess Durga defeated a powerful demon on this day. People celebrate by flying kites, eating delicious food, and spending time with family. It\'s like Nepal\'s own New Year\'s Day!', 'Why is Bijaya Dashami called the \"Day of Victory\"?', '[\"It marks the end of the festival\", \"It\'s the day Durga defeated the demon\", \"It\'s a public holiday\", \"It\'s the day people get gifts\"]', 1, 'What is the most important day of Dashain called?', '[\"Bijaya Dashami\", \"Ghatasthapana\", \"Fulpati\", \"Maha Ashtami\"]', 0, 'Bijaya Dashami means \"Day of Victory\" – it\'s when Durga defeated the demon. It\'s the most important day of Dashain, celebrated with family, feasts, and blessings.', 'दशैंको सबैभन्दा महत्वपूर्ण दिनलाई विजया दशमी भनिन्छ – विजयको दिन! यो विश्वास गरिन्छ कि देवी दुर्गाले यस दिन एउटा शक्तिशाली राक्षसलाई पराजित गरेकी थिइन्। मानिसहरू चङ्गा उडाएर, स्वादिष्ट खाना खाएर, र परिवारसँग समय बिताएर उत्सव मनाउँछन्। यो नेपालको आफ्नै नयाँ वर्षको दिन जस्तै हो!', 'विजया दशमीलाई \"विजयको दिन\" किन भनिन्छ?', '[\"यसले चाडको अन्त्य गर्छ\", \"यो दुर्गाले राक्षसलाई पराजित गरेको दिन हो\", \"यो सार्वजनिक बिदा हो\", \"यो मानिसहरूले उपहार पाउने दिन हो\"]', 'दशैंको सबैभन्दा महत्वपूर्ण दिनलाई के भनिन्छ?', '[\"विजया दशमी\", \"घटस्थापना\", \"फूलपाती\", \"महा अष्टमी\"]', 'विजया दशमीको अर्थ \"विजयको दिन\" हो – यो दुर्गाले राक्षसलाई पराजित गरेको दिन हो। यो दशैंको सबैभन्दा महत्वपूर्ण दिन हो, जुन परिवार, भोज, र आशीर्वादको साथ मनाइन्छ।', NULL, NULL, '2026-08-09 07:13:18'),
(16, 6, 21, 'Tihar is called the Festival of Lights – and it\'s beautiful! People light thousands of oil lamps (called diyas) and place them around their homes. The whole country glows like a sky full of stars! It\'s believed that the goddess Lakshmi visits homes that are lit up and brings good fortune!', 'Why is Tihar called the \"Festival of Lights\"?', '[\"Because people light oil lamps all around their homes\", \"Because it\'s a fire festival\", \"Because of fireworks\", \"Because it\'s very bright\"]', 0, 'Which goddess is worshipped during Tihar?', '[\"Durga\", \"Lakshmi\", \"Saraswati\", \"Kali\"]', 1, 'Tihar is the Festival of Lights because people light diyas (oil lamps) to welcome the goddess Lakshmi. They believe she visits lit homes and brings good fortune!', 'तिहारलाई बत्तीको चाड भनिन्छ – र यो अत्यन्तै सुन्दर छ! मानिसहरू हजारौं दियो बाल्छन् र तिनीहरूलाई आफ्नो घरको वरिपरि राख्छन्। सम्पूर्ण देश ताराले भरिएको आकाश जस्तै चम्किन्छ! यो विश्वास गरिन्छ कि देवी लक्ष्मी उज्यालो भएका घरहरूमा जानुहुन्छ र शुभ भाग्य ल्याउनुहुन्छ!', 'तिहारलाई \"बत्तीको चाड\" किन भनिन्छ?', '[\"किनभने मानिसहरू घरको वरिपरि दियो बाल्छन्\", \"किनभने यो आगोको चाड हो\", \"आतिशबाजीको कारणले\", \"किनभने यो धेरै उज्यालो छ\"]', 'तिहारमा कुन देवीको पूजा गरिन्छ?', '[\"दुर्गा\", \"लक्ष्मी\", \"सरस्वती\", \"काली\"]', 'तिहारलाई बत्तीको चाड भनिन्छ किनभने मानिसहरूले देवी लक्ष्मीलाई स्वागत गर्न दियो बाल्छन्। तिनीहरू विश्वास गर्छन् कि उहाँ उज्यालो भएका घरहरूमा आउनुहुन्छ र शुभ भाग्य ल्याउनुहुन्छ!', NULL, NULL, '2026-08-09 07:13:18'),
(17, 6, 21, 'Tihar is the only festival where animals are honoured! Each day celebrates a different animal: crows (as messengers), dogs (as guardians), cows (as mothers), and oxen (as helpers). On Dog Day, even street dogs get tika and garlands – they\'re treated like kings!', 'Why do you think Tihar includes honouring animals?', '[\"Because animals are useful to humans\", \"Because they are considered messengers and guardians\", \"Because they are pets\", \"Because they are strong\"]', 1, 'Which animal is honoured on the third day of Tihar (Lakshmi Puja)?', '[\"Cow\", \"Dog\", \"Ox\", \"Crow\"]', 0, 'Tihar honours different animals on different days – crows as messengers, dogs as guardians, cows as mothers, and oxen as helpers. Even street dogs are treated like kings on Dog Day!', 'तिहार मात्र त्यस्तो चाड हो जहाँ जनावरहरूको सम्मान गरिन्छ! प्रत्येक दिन फरक जनावरको उत्सव मनाइन्छ: काग (दूतको रूपमा), कुकुर (संरक्षकको रूपमा), गाई (आमाको रूपमा), र गोरु (सहायकको रूपमा)। कुकुर दिवसमा, सडकका कुकुरहरूलाई पनि टीका र माला लगाइन्छ – तिनीहरूलाई राजा जस्तै व्यवहार गरिन्छ!', 'तिहारमा जनावरहरूको सम्मान किन गरिन्छ होला?', '[\"किनभने जनावरहरू मानिसको लागि उपयोगी छन्\", \"किनभने तिनीहरूलाई दूत र संरक्षक मानिन्छ\", \"किनभने तिनीहरू घरपालुवा हुन्\", \"किनभने तिनीहरू बलिया छन्\"]', 'तिहारको तेस्रो दिन (लक्ष्मी पूजा) कुन जनावरको सम्मान गरिन्छ?', '[\"गाई\", \"कुकुर\", \"गोरु\", \"काग\"]', 'तिहारले विभिन्न दिनहरूमा विभिन्न जनावरहरूको सम्मान गर्छ – कागलाई दूतको रूपमा, कुकुरलाई संरक्षकको रूपमा, गाईलाई आमाको रूपमा, र गोरुलाई सहायकको रूपमा। कुकुर दिवसमा सडकका कुकुरहरूलाई पनि राजा जस्तै व्यवहार गरिन्छ!', NULL, NULL, '2026-08-09 07:13:18'),
(18, 6, 21, 'Bhai Tika is the last and most touching day of Tihar. Sisters put tika on their brothers\' foreheads and pray for their long life. Brothers give gifts to their sisters in return. It\'s a beautiful celebration of the special bond between brothers and sisters!', 'Why is Bhai Tika an important celebration?', '[\"It celebrates the bond between brothers and sisters\", \"It\'s a public holiday\", \"It involves giving gifts\", \"It\'s the only day for family\"]', 0, 'What is the final day of Tihar called?', '[\"Lakshmi Puja\", \"Bhai Tika\", \"Kukur Puja\", \"Gai Puja\"]', 1, 'Bhai Tika celebrates the love between brothers and sisters. Sisters pray for their brothers\' long lives, and brothers give gifts in return – it\'s a beautiful family tradition!', 'भाइ टीका तिहारको अन्तिम र सबैभन्दा मार्मिक दिन हो। दिदीबहिनीले दाजुभाइको निधारमा टीका लगाइदिन्छन् र उनीहरूको दीर्घायुको कामना गर्छन्। दाजुभाइले बदलामा दिदीबहिनीलाई उपहार दिन्छन्। यो दाजुभाइ-दिदीबहिनीको विशेष बन्धनको सुन्दर उत्सव हो!', 'भाइ टीका किन महत्वपूर्ण उत्सव हो?', '[\"यसले दाजुभाइ-दिदीबहिनीको बन्धनको उत्सव मनाउँछ\", \"यो सार्वजनिक बिदा हो\", \"यसमा उपहार दिने समावेश छ\", \"यो परिवारको लागि मात्र दिन हो\"]', 'तिहारको अन्तिम दिनलाई के भनिन्छ?', '[\"लक्ष्मी पूजा\", \"भाइ टीका\", \"कुकुर पूजा\", \"गाई पूजा\"]', 'भाइ टीकाले दाजुभाइ-दिदीबहिनीको मायाको उत्सव मनाउँछ। दिदीबहिनीले दाजुभाइको दीर्घायुको कामना गर्छन्, र दाजुभाइले बदलामा उपहार दिन्छन् – यो एउटा सुन्दर पारिवारिक परम्परा हो!', NULL, NULL, '2026-08-09 07:13:18'),
(19, 7, 21, 'Dal Bhat is the meal that keeps Nepal running! It\'s eaten twice a day – for lunch and dinner – and it\'s so important that people say \"Dal Bhat – 24 hours power!\" The best part? You can eat it with your hands – it\'s more fun!', 'Why do you think Dal Bhat is eaten so often in Nepal?', '[\"It\'s cheap and filling\", \"It\'s the only food available\", \"It\'s a national dish for special occasions\", \"It\'s the tastiest food\"]', 0, 'What is the staple food of Nepal?', '[\"Dal Bhat\", \"Momo\", \"Chowmein\", \"Noodles\"]', 0, 'Dal Bhat is Nepal\'s staple food – it\'s eaten twice a day because it\'s filling, nutritious, and delicious. People say \"Dal Bhat – 24 hours power\" because it gives you energy for the whole day!', 'दाल भात नेपाललाई चलाउने खाना हो! यो दिनको दुई पटक – खाजा र बेलुकी – खाइन्छ, र यो यति महत्वपूर्ण छ कि मानिसहरू भन्छन् \"दाल भात – २४ घण्टा पावर!\" सबैभन्दा राम्रो भाग? तपाईं यसलाई हातले खान सक्नुहुन्छ – यो झन् मजाको छ!', 'दाल भात नेपालमा किन यति धेरै खाइन्छ?', '[\"यो सस्तो र पेट भरिने छ\", \"यो मात्र उपलब्ध खाना हो\", \"यो विशेष अवसरहरूको लागि राष्ट्रिय परिकार हो\", \"यो सबैभन्दा स्वादिलो खाना हो\"]', 'नेपालको मुख्य खाना के हो?', '[\"दाल भात\", \"मःमः\", \"चाउमिन\", \"नुडल्स\"]', 'दाल भात नेपालको मुख्य खाना हो – यो दिनको दुई पटक खाइन्छ किनभने यो पेट भरिने, पौष्टिक, र स्वादिलो छ। मानिसहरू भन्छन् \"दाल भात – २४ घण्टा पावर\" किनभने यसले तपाईंलाई पूरै दिनको ऊर्जा दिन्छ!', NULL, NULL, '2026-08-09 07:13:18'),
(20, 7, 21, 'Momo is Nepal\'s favourite snack – and it\'s delicious! These little dumplings are filled with meat or vegetables and served with a spicy tomato sauce called achar. Achar is so spicy that it can make your tongue tingle! Momos are eaten everywhere – from street stalls to fancy restaurants!', 'Why is Momo so popular in Nepal?', '[\"It\'s delicious and comes in many flavours\", \"It\'s easy to cook\", \"It\'s only for festivals\", \"It\'s very cheap\"]', 0, 'What is the spicy dipping sauce for Momo called?', '[\"Achar\", \"Chutney\", \"Salsa\", \"Ketchup\"]', 0, 'Momo is Nepal\'s favourite snack because it\'s delicious, versatile, and comes in many flavours. The spicy achar makes it even more exciting – it can make your tongue tingle!', 'मःमः नेपालको मनपर्ने खाजा हो – र यो स्वादिलो छ! यी साना मोतीहरूमा मासु वा तरकारी भरिएको हुन्छ र अचार भनिने मसलादार टमाटरको चटनीसँग खाइन्छ। अचार यति मसलादार छ कि यसले तपाईंको जिब्रोलाई झमझमाउन सक्छ! मःमः जताततै खाइन्छ – सडकका पसलदेखि राम्रो रेस्टुरेन्टसम्म!', 'मःमः नेपालमा किन यति लोकप्रिय छ?', '[\"यो स्वादिलो छ र धेरै स्वादहरूमा आउँछ\", \"यो पकाउन सजिलो छ\", \"यो केवल चाडपर्वको लागि हो\", \"यो धेरै सस्तो छ\"]', 'मःमको मसलादार चटनीलाई के भनिन्छ?', '[\"अचार\", \"चटनी\", \"साल्सा\", \"केचप\"]', 'मःमः नेपालको मनपर्ने खाजा हो किनभने यो स्वादिलो, बहुमुखी, र धेरै स्वादहरूमा आउँछ। मसलादार अचारले यसलाई झन् रोमाञ्चक बनाउँछ – यसले तपाईंको जिब्रोलाई झमझमाउन सक्छ!', NULL, NULL, '2026-08-09 07:13:18'),
(21, 7, 21, 'Sel Roti is like Nepal\'s own sweet doughnut! It\'s crispy on the outside and soft on the inside. People make it during festivals like Dashain and Tihar – the whole house smells amazing! Sel Roti is so popular that there are even competitions to see who can make the best one!', 'Why is Sel Roti prepared during festivals?', '[\"It\'s a special sweet treat that can be shared\", \"It\'s easy to make\", \"It\'s the only sweet available\", \"It\'s very cheap\"]', 0, 'Which festivals is Sel Roti commonly made for?', '[\"Dashain\", \"Tihar\", \"Both\", \"None\"]', 2, 'Sel Roti is a special sweet treat prepared during Dashain and Tihar. It\'s crispy on the outside, soft inside, and shared with family and neighbours – it\'s a delicious festival tradition!', 'सेल रोटी नेपालको आफ्नै मीठो डोनट जस्तै हो! यो बाहिरी भाग कुरकुरे र भित्री भाग नरम हुन्छ। मानिसहरू दशैं र तिहार जस्ता चाडपर्वहरूमा यो बनाउँछन् – पूरा घरमा अद्भुत गन्ध आउँछ! सेल रोटी यति लोकप्रिय छ कि यसको उत्कृष्ट बनाउने को हो भनेर प्रतियोगिताहरू पनि हुन्छन्!', 'सेल रोटी चाडपर्वमा किन बनाइन्छ?', '[\"यो बाँड्न मिल्ने विशेष मिठाई हो\", \"यो बनाउन सजिलो छ\", \"यो मात्र उपलब्ध मिठाई हो\", \"यो धेरै सस्तो छ\"]', 'सेल रोटी कुन चाडपर्वहरूमा बनाइन्छ?', '[\"दशैं\", \"तिहार\", \"दुवै\", \"कुनै पनि होइन\"]', 'सेल रोटी दशैं र तिहारमा बनाइने विशेष मीठो परिकार हो। यो बाहिरबाट कुरकुरे, भित्रबाट नरम, र परिवार र छिमेकीहरूसँग बाँडिन्छ – यो एउटा स्वादिष्ट चाडपर्व परम्परा हो!', NULL, NULL, '2026-08-09 07:13:18'),
(22, 8, 21, 'The one-horned rhinoceros is one of the rarest animals on Earth – you can only find it in Nepal and India! It has one horn that can grow up to 60 cm long. In Chitwan National Park, you can see them grazing in the grasslands like giant prehistoric creatures!', 'Why is the one-horned rhinoceros so rare and special?', '[\"It only lives in Nepal and India\", \"It has a long horn\", \"It is very big\", \"It is very fast\"]', 0, 'Which national park is famous for the one-horned rhinoceros?', '[\"Sagarmatha\", \"Chitwan\", \"Bardiya\", \"Langtang\"]', 1, 'The one-horned rhino is found only in Nepal and India, making it incredibly rare. Chitwan National Park is the best place to see these magnificent creatures in the wild!', 'एकसिङ्गे गैंडा पृथ्वीको सबैभन्दा दुर्लभ जनावरहरूमध्ये एक हो – तपाईं यसलाई नेपाल र भारतमा मात्र फेला पार्न सक्नुहुन्छ! यसको एउटा सिङ हुन्छ जो ६० सेन्टिमिटरसम्म लामो हुन सक्छ। चितवन राष्ट्रिय निकुञ्जमा, तपाईं तिनीहरूलाई विशाल प्रागैतिहासिक प्राणीहरू जस्तै घाँसे मैदानमा चर्दै देख्न सक्नुहुन्छ!', 'एकसिङ्गे गैंडा किन यति दुर्लभ र विशेष छ?', '[\"यो नेपाल र भारतमा मात्र बस्छ\", \"यसको लामो सिङ छ\", \"यो धेरै ठूलो छ\", \"यो धेरै छिटो छ\"]', 'एकसिङ्गे गैंडाको लागि कुन राष्ट्रिय निकुञ्ज प्रसिद्ध छ?', '[\"सगरमाथा\", \"चितवन\", \"बर्दिया\", \"लाङटाङ\"]', 'एकसिङ्गे गैंडा नेपाल र भारतमा मात्र पाइन्छ, जसले यसलाई अत्यन्तै दुर्लभ बनाउँछ। चितवन राष्ट्रिय निकुञ्ज यी भव्य प्राणीहरूलाई जंगलमा हेर्नको लागि उत्तम स्थान हो!', NULL, NULL, '2026-08-09 07:13:18'),
(23, 8, 21, 'The Bengal tiger is one of the most powerful animals on Earth – a single tiger can weigh as much as 300 kg! Nepal has doubled its tiger population in recent years, making it one of the most successful conservation stories in the world!', 'Why is Nepal\'s tiger conservation success so important?', '[\"Tigers are important for the ecosystem\", \"Tigers are beautiful\", \"Tigers are friendly\", \"Tigers are fast\"]', 0, 'Where do Bengal tigers live in Nepal?', '[\"In the mountains\", \"In the Terai forests\", \"In the cities\", \"In the ocean\"]', 1, 'Nepal\'s tiger conservation is a global success story – the tiger population has doubled thanks to protection efforts. Tigers are top predators and keep the ecosystem balanced.', 'बंगाल बाघ पृथ्वीको सबैभन्दा शक्तिशाली जनावरहरूमध्ये एक हो – एउटा बाघको तौल ३०० किलोग्रामसम्म हुन सक्छ! नेपालले हालका वर्षहरूमा आफ्नो बाघको जनसंख्या दोब्बर बनाएको छ, जसले यसलाई विश्वको सबैभन्दा सफल संरक्षण कथाहरूमध्ये एक बनाएको छ!', 'नेपालको बाघ संरक्षण सफलता किन यति महत्वपूर्ण छ?', '[\"बाघहरू पारिस्थितिकी प्रणालीको लागि महत्वपूर्ण छन्\", \"बाघहरू सुन्दर छन्\", \"बाघहरू मित्रवत छन्\", \"बाघहरू छिटो छन्\"]', 'बंगाल बाघहरू नेपालमा कहाँ बस्छन्?', '[\"पहाडमा\", \"तराईका जंगलहरूमा\", \"सहरहरूमा\", \"समुद्रमा\"]', 'नेपालको बाघ संरक्षण विश्वव्यापी सफलताको कथा हो – संरक्षण प्रयासहरूको कारण बाघको जनसंख्या दोब्बर भएको छ। बाघहरू शीर्ष शिकारी हुन् र पारिस्थितिकी प्रणाली सन्तुलित राख्छन्।', NULL, NULL, '2026-08-09 07:13:18'),
(24, 8, 21, 'The Koshi River is like a giant water snake! It flows all the way from the Himalayas to India, where it forms a huge delta. The river provides water for millions of people and is home to hundreds of fish species. The river is so important that people call it the \"lifeline of the Terai\"!', 'Why is the Koshi River called the \"lifeline of the Terai\"?', '[\"It provides water for farming and daily life\", \"It has many fish\", \"It is a tourist attraction\", \"It is very long\"]', 0, 'Which river is known as the \"lifeline of the Terai\"?', '[\"Koshi\", \"Gandaki\", \"Karnali\", \"Bagmati\"]', 0, 'The Koshi River is called the lifeline of the Terai because it provides water for farming, drinking, and daily life for millions of people in the region.', 'कोशी नदी विशाल पानीको सर्प जस्तै हो! यो हिमालयदेखि भारतसम्म बग्छ, जहाँ यसले विशाल डेल्टा बनाउँछ। नदीले लाखौं मानिसहरूलाई पानी प्रदान गर्छ र सयौं माछा प्रजातिहरूको घर हो। नदी यति महत्वपूर्ण छ कि मानिसहरू यसलाई \"तराईको जीवन रेखा\" भन्छन्!', 'कोशी नदीलाई \"तराईको जीवन रेखा\" किन भनिन्छ?', '[\"यसले खेती र दैनिक जीवनको लागि पानी प्रदान गर्छ\", \"यसमा धेरै माछाहरू छन्\", \"यो पर्यटक आकर्षण हो\", \"यो धेरै लामो छ\"]', 'कुन नदीलाई \"तराईको जीवन रेखा\" भनिन्छ?', '[\"कोशी\", \"गण्डकी\", \"कर्णाली\", \"बागमती\"]', 'कोशी नदीलाई तराईको जीवन रेखा भनिन्छ किनभने यसले क्षेत्रका लाखौं मानिसहरूको खेती, पिउने, र दैनिक जीवनको लागि पानी प्रदान गर्छ।', NULL, NULL, '2026-08-09 07:13:18'),
(25, 9, 21, 'Lumbini is the birthplace of Lord Buddha – the founder of Buddhism! It\'s a sacred place where people from all over the world come to meditate. The site has a beautiful garden with a pond where Buddha is said to have bathed after his birth. It\'s one of the most peaceful places on Earth!', 'Why is Lumbini so special to Buddhists worldwide?', '[\"It\'s where Buddha was born\", \"It\'s where he died\", \"It\'s a tourist attraction\", \"It\'s a city\"]', 0, 'Which city is known as the birthplace of Lord Buddha?', '[\"Kathmandu\", \"Lumbini\", \"Pokhara\", \"Biratnagar\"]', 1, 'Lumbini is where Lord Buddha was born over 2,500 years ago. It\'s one of the most sacred places for Buddhists and a UNESCO World Heritage Site.', 'लुम्बिनी भगवान बुद्धको जन्मस्थल हो – बुद्ध धर्मका संस्थापक! यो पवित्र स्थान हो जहाँ विश्वभरका मानिसहरू ध्यान गर्न आउँछन्। यस स्थानमा एउटा सुन्दर बगैंचा र पोखरी छ जहाँ बुद्धले जन्मपछि स्नान गरेको भनिन्छ। यो पृथ्वीको सबैभन्दा शान्त स्थानहरूमध्ये एक हो!', 'लुम्बिनी विश्वभरका बौद्धहरूको लागि किन यति विशेष छ?', '[\"यो बुद्ध जन्मेको ठाउँ हो\", \"यो उनी मरेको ठाउँ हो\", \"यो पर्यटक आकर्षण हो\", \"यो सहर हो\"]', 'भगवान बुद्धको जन्मस्थलको रूपमा कुन सहर चिनिन्छ?', '[\"काठमाडौं\", \"लुम्बिनी\", \"पोखरा\", \"विराटनगर\"]', 'लुम्बिनी २,५०० वर्षभन्दा पहिले भगवान बुद्ध जन्मेको ठाउँ हो। यो बौद्धहरूको लागि सबैभन्दा पवित्र स्थानहरूमध्ये एक हो र युनेस्को विश्व सम्पदा स्थल हो।', NULL, NULL, '2026-08-09 07:13:18'),
(26, 9, 21, 'Nepal is like a giant museum of culture! Over 120 languages are spoken in the country – that\'s almost one language for every 250,000 people! Each ethnic group has its own unique traditions, clothing, and food. It\'s like visiting 100 different countries all in one place!', 'Why is Nepal called a \"melting pot\" of cultures?', '[\"It has many ethnic groups and languages\", \"It has many tourists\", \"It has many temples\", \"It has many cities\"]', 0, 'Approximately how many languages are spoken in Nepal?', '[\"30\", \"120\", \"200\", \"300\"]', 1, 'Nepal is incredibly diverse – over 120 languages and many ethnic groups live together, each with their own unique traditions, clothing, and food.', 'नेपाल संस्कृतिको विशाल संग्रहालय जस्तै हो! देशमा १२० भन्दा बढी भाषाहरू बोलिन्छन् – यो प्रत्येक २,५०,००० मानिसको लागि लगभग एउटा भाषा हो! प्रत्येक जातीय समूहको आफ्नै अद्वितीय परम्परा, लुगा, र खाना छ। यो एउटै ठाउँमा १०० विभिन्न देशहरू भ्रमण गर्नु जस्तै हो!', 'नेपाललाई संस्कृतिको \"पग्लने भाँडो\" किन भनिन्छ?', '[\"यहाँ धेरै जातीय समूह र भाषाहरू छन्\", \"यहाँ धेरै पर्यटकहरू छन्\", \"यहाँ धेरै मन्दिरहरू छन्\", \"यहाँ धेरै सहरहरू छन्\"]', 'नेपालमा लगभग कति भाषाहरू बोलिन्छन्?', '[\"३०\", \"१२०\", \"२००\", \"३००\"]', 'नेपाल अत्यन्तै विविधतापूर्ण छ – १२० भन्दा बढी भाषाहरू र धेरै जातीय समूहहरू एकसाथ बस्छन्, प्रत्येकको आफ्नै अद्वितीय परम्परा, लुगा, र खाना छ।', NULL, NULL, '2026-08-09 07:13:18'),
(27, 9, 21, 'Nepal\'s temples and palaces are so special that UNESCO protects them! The temples are decorated with intricate carvings of gods, goddesses, and mythical creatures. Some temples even have statues with multiple arms and heads – they look like they\'re from a fantasy movie! They\'re more than 1,000 years old!', 'Why are Nepal\'s temples and palaces protected by UNESCO?', '[\"They are very beautiful\", \"They have cultural and historical significance\", \"They are tourist attractions\", \"They are very tall\"]', 1, 'How old are some of Nepal\'s temples?', '[\"100 years\", \"500 years\", \"More than 1,000 years\", \"More than 2,000 years\"]', 2, 'Nepal\'s temples and palaces are protected by UNESCO because they are incredibly old, beautiful, and culturally significant. Some are more than 1,000 years old!', 'नेपालका मन्दिर र दरबारहरू यति विशेष छन् कि युनेस्कोले तिनीहरूको संरक्षण गर्छ! मन्दिरहरू देवी-देवता र पौराणिक प्राणीहरूका जटिल नक्काशीहरूले सजिएका छन्। केही मन्दिरहरूमा धेरै हात र टाउका भएका मूर्तिहरू पनि छन् – तिनीहरू काल्पनिक चलचित्रबाट आएको जस्तो देखिन्छन्! तिनीहरू १,००० वर्षभन्दा पुराना छन्!', 'नेपालका मन्दिर र दरबारहरू युनेस्कोद्वारा किन संरक्षित गरिएका छन्?', '[\"तिनीहरू धेरै सुन्दर छन्\", \"तिनीहरूको सांस्कृतिक र ऐतिहासिक महत्व छ\", \"तिनीहरू पर्यटक आकर्षण हुन्\", \"तिनीहरू धेरै अग्ला छन्\"]', 'नेपालका केही मन्दिरहरू कति पुराना छन्?', '[\"१०० वर्ष\", \"५०० वर्ष\", \"१,००० वर्षभन्दा बढी\", \"२,००० वर्षभन्दा बढी\"]', 'नेपालका मन्दिर र दरबारहरू युनेस्कोद्वारा संरक्षित छन् किनभने तिनीहरू अत्यन्तै पुराना, सुन्दर, र सांस्कृतिक रूपमा महत्वपूर्ण छन्। केही १,००० वर्षभन्दा पुराना छन्!', NULL, NULL, '2026-08-09 07:13:18');

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

--
-- Dumping data for table `children`
--

INSERT INTO `children` (`child_id`, `parent_id`, `username`, `age`, `mascot_id`, `total_coins`, `current_level`, `created_at`) VALUES
(1, 1, 'testkid', 8, 1, 0, 1, '2026-08-11 14:16:34');

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
(21, 'Capybara Nepal Adventure', 'capybara-nepal-adventure', 'capybara_quiz', 'Learn about Nepal with Capybara!', 6, 12, 1);

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
(21, 1, '2026-08-09 17:12:57'),
(21, 2, '2026-08-09 17:12:57'),
(21, 3, '2026-08-09 17:12:57'),
(21, 4, '2026-08-09 17:12:57'),
(21, 5, '2026-08-09 17:12:57');

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
(1, 'Test', 'Parent', 'test@email.com', '$2y$10$dummyhash1234567890', '9841000001', '2026-08-11 14:16:34');

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
  MODIFY `child_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `child_badges`
--
ALTER TABLE `child_badges`
  MODIFY `child_badge_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `child_progress`
--
ALTER TABLE `child_progress`
  MODIFY `progress_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `coin_transactions`
--
ALTER TABLE `coin_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `game_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `hangman_words`
--
ALTER TABLE `hangman_words`
  MODIFY `word_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `mascots`
--
ALTER TABLE `mascots`
  MODIFY `mascot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `parent_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

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
  MODIFY `option_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `scores`
--
ALTER TABLE `scores`
  MODIFY `score_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

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
