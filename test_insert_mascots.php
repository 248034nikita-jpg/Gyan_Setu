<?php
include 'database/includes/db_connect.php';

$sql = "INSERT IGNORE INTO `mascots` (`mascot_id`, `name`, `emoji_or_icon`, `description`, `point_cost`, `is_active`, `created_at`) VALUES
(1, 'Wise Owl', '🦉', 'Curious & clever!', 0, 1, '2026-08-01 08:02:05'),
(2, 'Clever Fox', '🦊', 'Quick & sly!', 0, 1, '2026-08-01 08:02:05'),
(3, 'Playful Dolphin', '🐬', 'Smart & friendly!', 0, 1, '2026-08-01 08:02:05'),
(4, 'Brave Lion', '🦁', 'Bold & fearless!', 0, 1, '2026-08-01 08:02:05'),
(5, 'Steady Turtle', '🐢', 'Patient & wise!', 0, 1, '2026-08-01 08:02:05'),
(6, 'Free Butterfly', '🦋', 'Creative & free!', 0, 1, '2026-08-01 08:02:05'),
(7, 'Hopping Frog', '🐸', 'Leaps to learn!', 0, 1, '2026-08-01 08:02:05'),
(8, 'Magic Unicorn', '🦄', 'Rare & wonderful!', 50, 1, '2026-08-01 08:02:05')";

if($conn->query($sql)){
    echo "Inserted mascots successfully!";
} else {
    echo "Error inserting: " . $conn->error;
}
?>
