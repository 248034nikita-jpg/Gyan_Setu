USE gyan_setu;
CREATE TABLE coin (
    coin_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon_url VARCHAR(255),
    points_required INT NOT NULL
);

CREATE TABLE child_coin (
    child_coin_id INT AUTO_INCREMENT PRIMARY KEY,
    child_id INT NOT NULL,
    coin_id INT NOT NULL,
    date_earned TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE,
    FOREIGN KEY (coin_id) REFERENCES coin(coin_id) ON DELETE CASCADE
);