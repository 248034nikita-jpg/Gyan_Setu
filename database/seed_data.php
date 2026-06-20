<?php
include 'includes/db_connect.php';

// Check if data is already seeded
$res = $conn->query("SELECT COUNT(*) FROM courses");
$count = $res->fetch_row()[0];

if ($count > 0) {
    die("Database already seeded with courses!\n");
}

echo "Seeding database gyan_setu...\n";

// 1. Seed Courses
$conn->query("INSERT INTO courses (title, description, difficulty_level) VALUES 
('Mathematics', 'Learn numbers, addition, subtraction, and basic geometry.', 'Beginner'),
('English Language', 'Improve vocabulary, sentence structure, and grammar.', 'Beginner'),
('Science & Nature', 'Explore animals, planets, and natural science.', 'Intermediate')");

$first_course_id = $conn->insert_id;
$math_id = $first_course_id;
$eng_id = $first_course_id + 1;
$sci_id = $first_course_id + 2;

// 2. Seed Lessons
// Math lessons
$conn->query("INSERT INTO lessons (course_id, title, content, order_number) VALUES 
($math_id, 'Counting Fun', 'Learn to count from 1 to 20 with friendly characters.', 1),
($math_id, 'Simple Addition', 'Adding objects together: 1 apple + 2 apples = 3 apples.', 2)");

$first_math_lesson_id = $conn->insert_id;
$math_l1 = $first_math_lesson_id;
$math_l2 = $first_math_lesson_id + 1;

// English lessons
$conn->query("INSERT INTO lessons (course_id, title, content, order_number) VALUES 
($eng_id, 'Alphabet Adventures', 'Learn the sound of the English alphabet from A to Z.', 1),
($eng_id, 'Sentence Builder', 'How to form basic sentences like \"This is a cat.\"', 2)");

$first_eng_lesson_id = $conn->insert_id;
$eng_l1 = $first_eng_lesson_id;
$eng_l2 = $first_eng_lesson_id + 1;

// Science lessons
$conn->query("INSERT INTO lessons (course_id, title, content, order_number) VALUES 
($sci_id, 'The Solar System', 'Meet the Sun and the eight planets orbiting it.', 1),
($sci_id, 'Plant Growth', 'See how seeds grow with water, soil, and sunlight.', 2)");

$first_sci_lesson_id = $conn->insert_id;
$sci_l1 = $first_sci_lesson_id;
$sci_l2 = $first_sci_lesson_id + 1;

// 3. Seed Quizzes
$conn->query("INSERT INTO quizzes (lesson_id, title, passing_score) VALUES 
($math_l1, 'Counting Quiz', 70),
($math_l2, 'Addition Quiz', 70),
($eng_l1, 'Alphabet Quiz', 70),
($eng_l2, 'Sentence Quiz', 70),
($sci_l1, 'Space Quiz', 70),
($sci_l2, 'Plant Quiz', 70)");

$first_quiz_id = $conn->insert_id;
$q_math1 = $first_quiz_id;
$q_math2 = $first_quiz_id + 1;
$q_eng1 = $first_quiz_id + 2;
$q_eng2 = $first_quiz_id + 3;
$q_sci1 = $first_quiz_id + 4;
$q_sci2 = $first_quiz_id + 5;

// 4. Seed Questions & Options
// Math 1 Quiz Questions
$conn->query("INSERT INTO questions (quiz_id, question_text, question_type) VALUES ($q_math1, 'What number comes after 5?', 'multiple_choice')");
$qm1_q1 = $conn->insert_id;
$conn->query("INSERT INTO options (question_id, option_text, is_correct) VALUES 
($qm1_q1, '4', 0),
($qm1_q1, '6', 1),
($qm1_q1, '7', 0),
($qm1_q1, '5', 0)");

// Math 2 Quiz Questions
$conn->query("INSERT INTO questions (quiz_id, question_text, question_type) VALUES ($q_math2, 'What is 3 + 4?', 'multiple_choice')");
$qm2_q1 = $conn->insert_id;
$conn->query("INSERT INTO options (question_id, option_text, is_correct) VALUES 
($qm2_q1, '6', 0),
($qm2_q1, '7', 1),
($qm2_q1, '8', 0),
($qm2_q1, '9', 0)");

// English 1 Quiz Questions
$conn->query("INSERT INTO questions (quiz_id, question_text, question_type) VALUES ($q_eng1, 'Which letter is a vowel?', 'multiple_choice')");
$qe1_q1 = $conn->insert_id;
$conn->query("INSERT INTO options (question_id, option_text, is_correct) VALUES 
($qe1_q1, 'B', 0),
($qe1_q1, 'C', 0),
($qe1_q1, 'E', 1),
($qe1_q1, 'D', 0)");

// 5. Seed Coins (Badges)
$conn->query("INSERT INTO coin (name, description, icon_url, points_required) VALUES 
('First Step', 'Earned for your first score!', 'assets/images/coin.png', 10),
('Math Genius', 'Answered a math quiz perfectly!', 'assets/images/coin.png', 50),
('English Scholar', 'Completed all English lessons!', 'assets/images/coin.png', 100),
('Super Star', 'Earned 200 total points!', 'assets/images/coin.png', 200)");

// 6. Seed Shop Items
$conn->query("INSERT INTO shop_items (item_name, description, price_points, icon_url) VALUES 
('Rocket Avatar Skin', 'Fly high with a shiny rocket space avatar!', 50, '🚀'),
('Math Explorer E-Book', 'An interactive math puzzle book with over 50 challenges.', 100, '📚'),
('Adventure Game Pass', 'Unlock a secret bonus level in the Game Zone!', 150, '🎮'),
('Golden Crown Badge', 'Wear the royal gold crown in your profile!', 200, '👑')");

echo "Seeding completed successfully!\n";
?>
