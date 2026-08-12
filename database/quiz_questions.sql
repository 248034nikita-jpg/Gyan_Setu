-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 08, 2026 at 04:10 PM
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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `idx_questions_game_tier` (`game_id`,`difficulty_tier`),
  ADD KEY `idx_questions_course_tier` (`course_id`,`difficulty_tier`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=481;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD CONSTRAINT `fk_questions_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_questions_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
