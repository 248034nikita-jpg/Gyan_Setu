-- Drop existing tables if they exist
DROP TABLE IF EXISTS user_responses;
DROP TABLE IF EXISTS quiz_attempts;
DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- Then run all the CREATE TABLE statements from above
-- Then insert sample data

CREATE TABLE child_game_intro (
    child_id INT NOT NULL,
    game_id INT NOT NULL,
    seen_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (child_id, game_id),

    FOREIGN KEY (child_id)
        REFERENCES children(child_id)
        ON DELETE CASCADE,

    FOREIGN KEY (game_id)
        REFERENCES games(game_id)
        ON DELETE CASCADE
);