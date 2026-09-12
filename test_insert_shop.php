<?php
include 'database/includes/db_connect.php';

$sql = "INSERT IGNORE INTO `shop_items` (`item_id`, `item_name`, `description`, `price_coins`, `icon_url`) VALUES
(1, 'Super Jump Boost', 'Jump higher in capybara game', 50, '🚀'),
(2, 'Extra Life', 'Get one extra life in mini-games', 100, '❤️'),
(3, 'Double Coins (1 hr)', 'Earn double coins for 1 hour', 200, '💎'),
(4, 'Golden Capybara Skin', 'Exclusive shiny skin for capybara', 500, '✨');";

if($conn->query($sql)){
    echo "Inserted shop_items successfully!";
} else {
    echo "Error inserting: " . $conn->error;
}
?>
