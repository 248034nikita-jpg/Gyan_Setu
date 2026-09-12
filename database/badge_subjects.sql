-- Run once to make badge subjects data-driven. New games can use any subject name;
-- badge pages will group game categories by this value automatically.
ALTER TABLE games ADD COLUMN IF NOT EXISTS subject VARCHAR(100) NULL AFTER title;
UPDATE games SET subject = 'English' WHERE game_id = 1;
UPDATE games SET subject = 'Science' WHERE game_id = 4;
