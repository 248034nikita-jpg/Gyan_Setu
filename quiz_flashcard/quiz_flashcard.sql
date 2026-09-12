ALTER TABLE children ADD COLUMN IF NOT EXISTS total_stars INT NOT NULL DEFAULT 0 AFTER total_coins;

INSERT IGNORE INTO games (game_id, title, slug, game_type, description, min_age, max_age, is_active) 
VALUES (4, 'Quiz & Flashcards', 'quiz-flashcards', 'quiz_flashcards', 'Science, Nature, Space quiz and flashcards with fun facts and puzzles. Learn about Nepal, animals, planets, and more!', 4, 12, 1);

CREATE TABLE IF NOT EXISTS flashcard_subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    name_en VARCHAR(100) NOT NULL,
    name_ne VARCHAR(100) NOT NULL,
    icon VARCHAR(10) NOT NULL,
    description_en TEXT,
    description_ne TEXT,
    is_active TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flashcard_levels (
    level_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id INT NOT NULL,
    level_name_en VARCHAR(50) NOT NULL,
    level_name_ne VARCHAR(50) NOT NULL,
    icon VARCHAR(10),
    difficulty_tier INT NOT NULL,
    description_en TEXT,
    description_ne TEXT,
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (subject_id) REFERENCES flashcard_subjects(subject_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flashcard_questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    level_id INT NOT NULL,
    type ENUM('mcq','puzzle') NOT NULL,
    question_en TEXT NOT NULL,
    question_ne TEXT NOT NULL,
    hint_en TEXT,
    hint_ne TEXT,
    fun_fact_en TEXT,
    fun_fact_ne TEXT,
    correct_order JSON NULL,
    FOREIGN KEY (level_id) REFERENCES flashcard_levels(level_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flashcard_options (
    option_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL,
    option_text_en TEXT NOT NULL,
    option_text_ne TEXT NOT NULL,
    emoji VARCHAR(10) NOT NULL,
    is_correct TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (question_id) REFERENCES flashcard_questions(question_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flashcard_puzzle_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL,
    item_id_code VARCHAR(10) NOT NULL,
    item_label_en VARCHAR(255) NOT NULL,
    item_label_ne VARCHAR(255) NOT NULL,
    emoji VARCHAR(10) NOT NULL,
    FOREIGN KEY (question_id) REFERENCES flashcard_questions(question_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flashcard_decks (
    deck_id INT PRIMARY KEY AUTO_INCREMENT,
    level_id INT NOT NULL,
    deck_name_en VARCHAR(100),
    deck_name_ne VARCHAR(100),
    FOREIGN KEY (level_id) REFERENCES flashcard_levels(level_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS flashcard_cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    deck_id INT NOT NULL,
    card_icon VARCHAR(10) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    name_ne VARCHAR(100) NOT NULL,
    subtitle_en VARCHAR(100),
    subtitle_ne VARCHAR(100),
    tag_en VARCHAR(50),
    tag_ne VARCHAR(50),
    facts_en JSON NOT NULL,
    facts_ne JSON NOT NULL,
    FOREIGN KEY (deck_id) REFERENCES flashcard_decks(deck_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS child_flashcard_question_progress (
    child_id INT NOT NULL,
    question_id INT NOT NULL,
    attempts INT NOT NULL DEFAULT 0,
    correct_attempts INT NOT NULL DEFAULT 0,
    stars_earned INT NOT NULL DEFAULT 0,
    coins_earned INT NOT NULL DEFAULT 0,
    PRIMARY KEY (child_id, question_id),
    FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES flashcard_questions(question_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS child_flashcard_card_progress (
    child_id INT NOT NULL,
    card_id INT NOT NULL,
    flipped_count INT NOT NULL DEFAULT 0,
    stars_earned INT NOT NULL DEFAULT 0,
    PRIMARY KEY (child_id, card_id),
    FOREIGN KEY (child_id) REFERENCES children(child_id) ON DELETE CASCADE,
    FOREIGN KEY (card_id) REFERENCES flashcard_cards(card_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_flashcard_levels_subject ON flashcard_levels(subject_id);
CREATE INDEX idx_flashcard_questions_level ON flashcard_questions(level_id);
CREATE INDEX idx_flashcard_options_question ON flashcard_options(question_id);
CREATE INDEX idx_flashcard_puzzle_items_question ON flashcard_puzzle_items(question_id);
CREATE INDEX idx_flashcard_decks_level ON flashcard_decks(level_id);
CREATE INDEX idx_flashcard_cards_deck ON flashcard_cards(deck_id);

INSERT IGNORE INTO flashcard_subjects (subject_id, name_en, name_ne, icon, description_en, description_ne) VALUES
(1, 'Science', 'विज्ञान', '🔬', 'Physics & Chemistry', 'भौतिकशास्त्र र रसायनशास्त्र'),
(2, 'Nature', 'प्रकृति', '🌱', 'Plants & Animals', 'बिरुवा र जनावरहरू'),
(3, 'Solar System', 'सौर्य प्रणाली', '🪐', 'Space & Planets', 'अन्तरिक्ष र ग्रहहरू'),
(4, 'Flashcards', 'फ्ल्यास कार्ड', '🃏', 'Science, Nature & Space', 'विज्ञान, प्रकृति र अन्तरिक्ष');

INSERT IGNORE INTO flashcard_levels (level_id, subject_id, level_name_en, level_name_ne, icon, difficulty_tier, description_en, description_ne) VALUES
(1, 1, 'Basic', 'आधारभूत', '🌱', 1, 'Simple fun questions!', 'सरल रमाइला प्रश्नहरू!'),
(2, 1, 'Intermediate', 'मध्यवर्ती', '🌟', 2, 'A bit more tricky!', 'अलि गाह्रो!'),
(3, 1, 'Advanced', 'उन्नत', '🚀', 3, 'Super brain challenge!', 'सुपर मस्तिष्क चुनौती!'),
(4, 2, 'Basic', 'आधारभूत', '🌱', 1, 'Simple fun questions!', 'सरल रमाइला प्रश्नहरू!'),
(5, 2, 'Intermediate', 'मध्यवर्ती', '🌟', 2, 'A bit more tricky!', 'अलि गाह्रो!'),
(6, 2, 'Advanced', 'उन्नत', '🚀', 3, 'Super brain challenge!', 'सुपर मस्तिष्क चुनौती!'),
(7, 3, 'Basic', 'आधारभूत', '🌱', 1, 'Simple fun questions!', 'सरल रमाइला प्रश्नहरू!'),
(8, 3, 'Intermediate', 'मध्यवर्ती', '🌟', 2, 'A bit more tricky!', 'अलि गाह्रो!'),
(9, 3, 'Advanced', 'उन्नत', '🚀', 3, 'Super brain challenge!', 'सुपर मस्तिष्क चुनौती!'),
(10, 4, 'Basic', 'आधारभूत', '🌱', 1, 'Simple flashcard deck', 'सरल फ्ल्यास कार्ड डेक'),
(11, 4, 'Intermediate', 'मध्यवर्ती', '🌟', 2, 'Intermediate flashcard deck', 'मध्यवर्ती फ्ल्यास कार्ड डेक'),
(12, 4, 'Advanced', 'उन्नत', '🚀', 3, 'Advanced flashcard deck', 'उन्नत फ्ल्यास कार्ड डेक');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1001, 1, 'mcq', 'What color do we see the Sun as? 🌞', 'सूर्य हामीलाई कस्तो रंगको देखिन्छ? 🌞', 'The Sun is actually white, but our sky makes it look yellow!', 'सूर्य वास्तवमा सेतो हो, तर हाम्रो आकाशले यसलाई पहेंलो देखाउँछ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2001, 1001, 'Yellow', 'पहेंलो', '☀️', 1),
(2002, 1001, 'Red', 'रातो', '🔴', 0),
(2003, 1001, 'Blue', 'निलो', '🔵', 0),
(2004, 1001, 'Green', 'हरियो', '🟢', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1002, 1, 'mcq', 'What gas do we blow out when we breathe? 💨', 'सास फेर्दा हामी बाहिर कुन ग्यास निकाल्छौं? 💨', 'We breathe in oxygen and breathe out carbon dioxide – plants love it!', 'हामी अक्सिजन सास लिन्छौं र कार्बन डाइअक्साइड बाहिर निकाल्छौं – बोटबिरुवालाई यो मन पर्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2005, 1002, 'Oxygen', 'अक्सिजन', '💨', 0),
(2006, 1002, 'Carbon Dioxide', 'कार्बन डाइअक्साइड', '🫧', 1),
(2007, 1002, 'Nitrogen', 'नाइट्रोजन', '🧪', 0),
(2008, 1002, 'Hydrogen', 'हाइड्रोजन', '💧', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1003, 1, 'mcq', 'Which of these can flow and take the shape of a glass? 🥤', 'यी मध्ये कुन गिलासको आकार लिन सक्छ? 🥤', 'Water is a liquid – it can be solid as ice or gas as steam too!', 'पानी तरल हो – यो बरफजस्तै ठोस वा भापजस्तै ग्यास पनि हुन सक्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2009, 1003, 'Water', 'पानी', '💧', 1),
(2010, 1003, 'Ice', 'बरफ', '🧊', 0),
(2011, 1003, 'Steam', 'भाप', '♨️', 0),
(2012, 1003, 'Rock', 'ढुङ्गा', '🪨', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1004, 1, 'mcq', 'What force keeps our feet on the ground? 🦶', 'हामीलाई जमिनमा टाँसिराख्ने बल के हो? 🦶', 'Gravity is like a giant magnet that pulls everything down to Earth!', 'गुरुत्वाकर्षण एउटा विशाल चुम्बक जस्तै हो जसले सबैलाई पृथ्वीतिर तान्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2013, 1004, 'Gravity', 'गुरुत्वाकर्षण', '⬇️', 1),
(2014, 1004, 'Magnetism', 'चुम्बकत्व', '🧲', 0),
(2015, 1004, 'Friction', 'घर्षण', '✋', 0),
(2016, 1004, 'Buoyancy', 'उत्प्लावन', '🛟', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1005, 1, 'mcq', 'Which body part do we use to hear music? 🎵', 'संगीत सुन्न हामी कुन अंग प्रयोग गर्छौं? 🎵', 'Your ears catch sound waves and send them straight to your brain!', 'तपाईंको कानले ध्वनि तरंगहरू समात्छ र मस्तिष्कमा पठाउँछ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2017, 1005, 'Ears', 'कान', '👂', 1),
(2018, 1005, 'Eyes', 'आँखा', '👀', 0),
(2019, 1005, 'Nose', 'नाक', '👃', 0),
(2020, 1005, 'Mouth', 'मुख', '👄', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1006, 1, 'puzzle', 'Put the states of matter in order from coldest to hottest:', 'पदार्थका अवस्थाहरूलाई चिसोदेखि तातोसम्म मिलाउनुहोस्:', 'Solid → Liquid → Gas', 'ठोस → तरल → ग्यास', 'When you heat or cool things, they can change from one state to another!', 'तातो वा चिसो पार्दा पदार्थको अवस्था परिवर्तन हुन्छ!', '["a","b","c"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3001, 1006, 'a', 'Solid', 'ठोस', '🧊'),
(3002, 1006, 'b', 'Liquid', 'तरल', '💧'),
(3003, 1006, 'c', 'Gas', 'ग्यास', '♨️');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1007, 2, 'mcq', 'What is the fancy name for water? 💧', 'पानीको विशेष नाम के हो? 💧', 'Every water drop is made of two hydrogen atoms and one oxygen atom!', 'हरेक पानीको थोपा दुई हाइड्रोजन परमाणु र एक अक्सिजन परमाणुले बनेको हुन्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2021, 1007, 'H₂O', 'H₂O', '💧', 1),
(2022, 1007, 'CO₂', 'CO₂', '🫧', 0),
(2023, 1007, 'NaCl', 'NaCl', '🧂', 0),
(2024, 1007, 'O₂', 'O₂', '💨', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1008, 2, 'mcq', 'Which part of a plant is like its kitchen? 🍳', 'बोटको कुन भाग भान्सा जस्तै हो? 🍳', 'Leaves use sunshine to cook food – it\'s called photosynthesis!', 'पातहरूले खाना पकाउन घामको प्रयोग गर्छन् – यसलाई प्रकाश संश्लेषण भनिन्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2025, 1008, 'Leaves', 'पात', '🍃', 1),
(2026, 1008, 'Roots', 'जरा', '🌱', 0),
(2027, 1008, 'Stem', 'डाँठ', '🌿', 0),
(2028, 1008, 'Flowers', 'फूल', '🌸', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1009, 2, 'mcq', 'Who is the fastest runner on land? 🏃‍♂️', 'जमिनमा सबैभन्दा छिटो दौडने कुन हो? 🏃‍♂️', 'Cheetahs can zoom at 70 mph – that\'s like a car on the highway!', 'चितुवा ७० माइल प्रति घण्टाको गतिमा दौडन सक्छ – त्यो राजमार्गको कार जस्तै हो!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2029, 1009, 'Cheetah', 'चितुवा', '🐆', 1),
(2030, 1009, 'Lion', 'सिंह', '🦁', 0),
(2031, 1009, 'Horse', 'घोडा', '🐴', 0),
(2032, 1009, 'Dog', 'कुकुर', '🐕', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1010, 2, 'mcq', 'What is the biggest organ in your body? 🫀', 'तपाईंको शरीरको सबैभन्दा ठूलो अंग कुन हो? 🫀', 'Your skin is like a superhero cape – it protects you from germs!', 'तपाईंको छाला सुपरहीरोको पोशाक जस्तै हो – यसले कीटाणुबाट जोगाउँछ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2033, 1010, 'Skin', 'छाला', '🧴', 1),
(2034, 1010, 'Liver', 'कलेजो', '🧫', 0),
(2035, 1010, 'Brain', 'मस्तिष्क', '🧠', 0),
(2036, 1010, 'Heart', 'मुटु', '❤️', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1011, 2, 'mcq', 'Which planet is called the Red Planet? 🔴', 'कुन ग्रहलाई रातो ग्रह भनिन्छ? 🔴', 'Mars is red because it\'s covered in rusty iron – like an old bike!', 'मंगल रातो छ किनभने यो खिया लागेको फलामले ढाकिएको छ – पुरानो साइकल जस्तै!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2037, 1011, 'Mars', 'मंगल', '🔴', 1),
(2038, 1011, 'Venus', 'शुक्र', '🟡', 0),
(2039, 1011, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2040, 1011, 'Saturn', 'शनि', '🪐', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1012, 2, 'puzzle', 'Arrange these planets from smallest to largest:', 'यी ग्रहहरूलाई सानोदेखि ठूलोसम्म मिलाउनुहोस्:', 'Mercury → Mars → Venus → Earth', 'बुध → मंगल → शुक्र → पृथ्वी', 'Jupiter is the biggest – it could swallow all the other planets!', 'बृहस्पति सबैभन्दा ठूलो हो – यसले अरू सबै ग्रहहरू निल्न सक्छ!', '["d","b","c","a"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3004, 1012, 'a', 'Earth', 'पृथ्वी', '🌍'),
(3005, 1012, 'b', 'Mars', 'मंगल', '🔴'),
(3006, 1012, 'c', 'Venus', 'शुक्र', '🟡'),
(3007, 1012, 'd', 'Mercury', 'बुध', '☿️');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1013, 3, 'mcq', 'What number tells us if water is neutral? ⚖️', 'पानी सन्तुलित छ कि भन्ने संख्या कति हो? ⚖️', 'Pure water has a neutral pH of 7 – it\'s not sour or bitter!', 'शुद्ध पानीको पीएच ७ हुन्छ – यो न त अमिलो न त तीतो!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2041, 1013, '7', '७', '⚖️', 1),
(2042, 1013, '1', '१', '🧪', 0),
(2043, 1013, '14', '१४', '🧪', 0),
(2044, 1013, '5', '५', '🧪', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1014, 3, 'mcq', 'Who came up with the idea that everything is relative? 🧠', 'सबै कुरा सापेक्षिक हो भन्ने विचार कसले दियो? 🧠', 'Albert Einstein was super smart – he changed how we think about time!', 'अल्बर्ट आइन्स्टाइन धेरै बुद्धिमान थिए – उनले समयको बारेमा हाम्रो सोच परिवर्तन गरे!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2045, 1014, 'Einstein', 'आइन्स्टाइन', '🧑‍🔬', 1),
(2046, 1014, 'Newton', 'न्यूटन', '🍎', 0),
(2047, 1014, 'Darwin', 'डार्विन', '🐒', 0),
(2048, 1014, 'Galileo', 'ग्यालिलियो', '🔭', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1015, 3, 'mcq', 'Which gas fills most of our air? 🌬️', 'हाम्रो हावामा सबैभन्दा धेरै कुन ग्यास छ? 🌬️', 'About 78% of the air we breathe is nitrogen – it\'s everywhere!', 'हामीले सास फेर्ने हावाको करिब ७८% नाइट्रोजन हो – यो जताततै छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2049, 1015, 'Nitrogen', 'नाइट्रोजन', '🧪', 1),
(2050, 1015, 'Oxygen', 'अक्सिजन', '💨', 0),
(2051, 1015, 'Carbon Dioxide', 'कार्बन डाइअक्साइड', '🫧', 0),
(2052, 1015, 'Argon', 'आर्गन', '🧪', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1016, 3, 'mcq', 'Which sea creature can grow back its arms? 🌊', 'कुन समुद्री प्राणीले आफ्ना हातहरू फेरि उमार्न सक्छ? 🌊', 'Starfish are like superheroes – they can regrow lost arms!', 'तारा माछा सुपरहीरो जस्तै हुन् – तिनीहरूले हराएको पाखुरा फेरि उमार्न सक्छन्!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2053, 1016, 'Starfish', 'तारा माछा', '⭐', 1),
(2054, 1016, 'Dog', 'कुकुर', '🐕', 0),
(2055, 1016, 'Cat', 'बिरालो', '🐱', 0),
(2056, 1016, 'Bird', 'चरा', '🐦', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1017, 3, 'mcq', 'What do we call the push or pull that moves things? 💪', 'वस्तुहरूलाई धकेल्ने वा तान्ने कसरी भनिन्छ? 💪', 'Force is measured in Newtons – named after Sir Isaac Newton!', 'बललाई न्यूटनमा मापन गरिन्छ – सर आइज्याक न्यूटनको नाममा!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2057, 1017, 'Force', 'बल', '⚡', 1),
(2058, 1017, 'Energy', 'ऊर्जा', '🔋', 0),
(2059, 1017, 'Power', 'शक्ति', '💡', 0),
(2060, 1017, 'Pressure', 'दबाव', '📏', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1018, 3, 'puzzle', 'Put these planets in order from closest to farthest from the Sun:', 'यी ग्रहहरूलाई सूर्यबाट नजिकदेखि टाढासम्म मिलाउनुहोस्:', 'Mercury → Venus → Earth → Mars', 'बुध → शुक्र → पृथ्वी → मंगल', 'The Sun\'s light takes 8 minutes to reach us – that\'s a long trip!', 'सूर्यको प्रकाश हामीसम्म आउन ८ मिनेट लाग्छ – त्यो लामो यात्रा हो!', '["c","b","d","a"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3008, 1018, 'a', 'Mars', 'मंगल', '🔴'),
(3009, 1018, 'b', 'Venus', 'शुक्र', '♀️'),
(3010, 1018, 'c', 'Mercury', 'बुध', '☿️'),
(3011, 1018, 'd', 'Earth', 'पृथ्वी', '🌍');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1019, 4, 'mcq', 'Which animal is the king of the jungle? 👑', 'कुन जनावर जंगलको राजा हो? 👑', 'Lions live in big families called prides – they love company!', 'सिंह ठूला परिवारमा बस्छन् जसलाई प्राइड भनिन्छ – उनीहरूलाई साथी मन पर्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2061, 1019, 'Lion', 'सिंह', '🦁', 1),
(2062, 1019, 'Tiger', 'बाघ', '🐯', 0),
(2063, 1019, 'Bear', 'भालु', '🐻', 0),
(2064, 1019, 'Elephant', 'हात्ती', '🐘', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1020, 4, 'mcq', 'What do bees collect from flowers to make honey? 🍯', 'मौरीले मह बनाउन फूलबाट के सङ्कलन गर्छ? 🍯', 'Bees are busy little workers – they turn nectar into sweet honey!', 'मौरीहरू व्यस्त साना कामदार हुन् – तिनीहरू मकरन्दलाई मीठो मह बनाउँछन्!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2065, 1020, 'Nectar', 'मकरन्द', '🍯', 1),
(2066, 1020, 'Pollen', 'पराग', '🌸', 0),
(2067, 1020, 'Water', 'पानी', '💧', 0),
(2068, 1020, 'Leaves', 'पात', '🍃', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1021, 4, 'mcq', 'Which season comes right after winter? 🌷', 'जाडो पछि कुन ऋतु आउँछ? 🌷', 'Spring is when flowers pop up and animals wake from their long naps!', 'वसन्तमा फूल फुल्छन् र जनावरहरू आफ्नो लामो निद्राबाट जाग्छन्!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2069, 1021, 'Spring', 'वसन्त', '🌷', 1),
(2070, 1021, 'Summer', 'ग्रीष्म', '☀️', 0),
(2071, 1021, 'Autumn', 'शरद', '🍂', 0),
(2072, 1021, 'Monsoon', 'वर्षा', '🌧️', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1022, 4, 'mcq', 'What is a baby frog called? 🐸', 'बच्चा भ्यागुतालाई के भनिन्छ? 🐸', 'Tadpoles swim in water and grow legs to become frogs – amazing!', 'ट्याडपोल पानीमा पौडिन्छ र खुट्टा उमारेर भ्यागुता बन्छ – अचम्म!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2073, 1022, 'Tadpole', 'ट्याडपोल', '🐸', 1),
(2074, 1022, 'Caterpillar', 'क्याटरपिलर', '🐛', 0),
(2075, 1022, 'Chick', 'चल्लो', '🐣', 0),
(2076, 1022, 'Puppy', 'कुकुरको बच्चा', '🐶', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1023, 4, 'mcq', 'Which plant has a really long trunk and huge leaves? 🌴', 'कुन बोटको लामो हाँगा र ठूला पात हुन्छ? 🌴', 'Banana trees are actually giant herbs – not trees at all!', 'केराको रूख वास्तवमा विशाल जडीबुटी हो – रूख होइन!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2077, 1023, 'Banana tree', 'केराको रूख', '🍌', 1),
(2078, 1023, 'Pine tree', 'पाइन रूख', '🌲', 0),
(2079, 1023, 'Oak tree', 'ओक रूख', '🌳', 0),
(2080, 1023, 'Bamboo', 'बाँस', '🎋', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1024, 4, 'puzzle', 'Put the butterfly life cycle in order:', 'पुतलीको जीवन चक्र मिलाउनुहोस्:', 'Egg → Caterpillar → Chrysalis → Butterfly', 'अण्डा → क्याटरपिलर → कोष → पुतली', 'A butterfly goes through a magical change called metamorphosis!', 'पुतलीले कायापलट भनिने जादुई परिवर्तनबाट गुज्रन्छ!', '["a","b","c","d"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3012, 1024, 'a', 'Egg', 'अण्डा', '🥚'),
(3013, 1024, 'b', 'Caterpillar', 'क्याटरपिलर', '🐛'),
(3014, 1024, 'c', 'Chrysalis', 'कोष', '🦋'),
(3015, 1024, 'd', 'Butterfly', 'पुतली', '🦋');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1025, 5, 'mcq', 'What is the largest animal on Earth? 🐋', 'पृथ्वीमा सबैभन्दा ठूलो जनावर कुन हो? 🐋', 'A blue whale weighs as much as 33 elephants – that\'s huge!', 'नीलो ह्वेलको तौल ३३ हात्तीको बराबर हुन्छ – त्यो विशाल हो!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2081, 1025, 'Blue Whale', 'नीलो ह्वेल', '🐋', 1),
(2082, 1025, 'Elephant', 'हात्ती', '🐘', 0),
(2083, 1025, 'Giraffe', 'जिराफ', '🦒', 0),
(2084, 1025, 'Hippo', 'हिप्पो', '🦛', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1026, 5, 'mcq', 'What do trees give us that helps us breathe? 🌳', 'रूखहरूले हामीलाई सास फेर्न के दिन्छ? 🌳', 'Trees are like nature\'s oxygen factories – they keep our air fresh!', 'रूखहरू प्रकृतिको अक्सिजन कारखाना जस्तै हुन् – तिनीहरूले हावा ताजा राख्छन्!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2085, 1026, 'Oxygen', 'अक्सिजन', '💨', 1),
(2086, 1026, 'Carbon Dioxide', 'कार्बन डाइअक्साइड', '🫧', 0),
(2087, 1026, 'Nitrogen', 'नाइट्रोजन', '🧪', 0),
(2088, 1026, 'Hydrogen', 'हाइड्रोजन', '💧', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1027, 5, 'mcq', 'Which bird can talk like a human? 🗣️', 'कुन चराले मानिसजस्तै बोल्न सक्छ? 🗣️', 'Parrots are clever copycats – they can learn to say words!', 'सुगा चलाख नक्कल गर्ने हुन् – तिनीहरूले शब्दहरू भन्न सिक्न सक्छन्!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2089, 1027, 'Parrot', 'सुगा', '🦜', 1),
(2090, 1027, 'Sparrow', 'भँगेरा', '🐦', 0),
(2091, 1027, 'Eagle', 'चील', '🦅', 0),
(2092, 1027, 'Owl', 'लाटोकोसेरो', '🦉', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1028, 5, 'mcq', 'What is the process called when plants make food? 🌿', 'बोटबिरुवाले खाना बनाउने प्रक्रियालाई के भनिन्छ? 🌿', 'Photosynthesis is like a recipe – sunlight + water + air = plant food!', 'प्रकाश संश्लेषण एउटा रेसिपी जस्तै हो – घाम + पानी + हावा = बोटको खाना!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2093, 1028, 'Photosynthesis', 'प्रकाश संश्लेषण', '🌱', 1),
(2094, 1028, 'Respiration', 'श्वसन', '🫁', 0),
(2095, 1028, 'Digestion', 'पाचन', '🍽️', 0),
(2096, 1028, 'Circulation', 'संचार', '❤️', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1029, 5, 'mcq', 'Which animal has black and white stripes? 🦓', 'कुन जनावरको कालो र सेतो धर्का हुन्छ? 🦓', 'Zebra stripes are like fingerprints – each one is unique!', 'जेब्राका धर्काहरू औंठाछाप जस्तै हुन् – प्रत्येक फरक हुन्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2097, 1029, 'Zebra', 'जेब्रा', '🦓', 1),
(2098, 1029, 'Tiger', 'बाघ', '🐯', 0),
(2099, 1029, 'Panda', 'पाण्डा', '🐼', 0),
(2100, 1029, 'Skunk', 'स्कंक', '🦨', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1030, 5, 'puzzle', 'Order the food chain from plant to top hunter:', 'खाद्य शृंखलालाई बोटबाट शीर्ष शिकारीसम्म मिलाउनुहोस्:', 'Grass → Rabbit → Fox → Lion', 'घाँस → खरायो → फ्याक्स → सिंह', 'Everything in nature is connected – like a big chain of friends!', 'प्रकृतिमा सबै कुरा जोडिएको छ – साथीहरूको ठूलो शृंखला जस्तै!', '["a","b","c","d"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3016, 1030, 'a', 'Grass', 'घाँस', '🌾'),
(3017, 1030, 'b', 'Rabbit', 'खरायो', '🐇'),
(3018, 1030, 'c', 'Fox', 'फ्याक्स', '🦊'),
(3019, 1030, 'd', 'Lion', 'सिंह', '🦁');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1031, 6, 'mcq', 'What is the biggest internal organ we have? 🧬', 'हाम्रो भित्रको सबैभन्दा ठूलो अंग कुन हो? 🧬', 'Your liver is like a filter – it cleans your blood every day!', 'तपाईंको कलेजो फिल्टर जस्तै हो – यसले दैनिक रगत सफा गर्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2101, 1031, 'Liver', 'कलेजो', '🧫', 1),
(2102, 1031, 'Brain', 'मस्तिष्क', '🧠', 0),
(2103, 1031, 'Heart', 'मुटु', '❤️', 0),
(2104, 1031, 'Lungs', 'फोक्सो', '🫁', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1032, 6, 'mcq', 'Which animal carries its babies in a pouch? 🦘', 'कुन जनावरले आफ्ना बच्चाहरूलाई झोलामा बोक्छ? 🦘', 'Kangaroos are marsupials – their babies grow in a cozy pouch!', 'कंगारूहरू मार्सुपियल हुन् – तिनीहरूका बच्चाहरू आरामदायी झोलामा बढ्छन्!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2105, 1032, 'Kangaroo', 'कंगारू', '🦘', 1),
(2106, 1032, 'Bear', 'भालु', '🐻', 0),
(2107, 1032, 'Elephant', 'हात्ती', '🐘', 0),
(2108, 1032, 'Giraffe', 'जिराफ', '🦒', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1033, 6, 'mcq', 'Which element is most common in the Earth\'s crust? 🪨', 'पृथ्वीको क्रस्टमा सबैभन्दा धेरै कुन तत्व पाइन्छ? 🪨', 'Oxygen makes up nearly half of the Earth\'s crust – it\'s everywhere!', 'अक्सिजनले पृथ्वीको क्रस्टको लगभग आधा भाग ओगट्छ – यो जताततै छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2109, 1033, 'Oxygen', 'अक्सिजन', '💨', 1),
(2110, 1033, 'Silicon', 'सिलिकन', '🔮', 0),
(2111, 1033, 'Aluminium', 'एल्युमिनियम', '🔩', 0),
(2112, 1033, 'Iron', 'फलाम', '⚙️', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1034, 6, 'mcq', 'What is the study of plants called? 🌿', 'बोटबिरुवाको अध्ययनलाई के भनिन्छ? 🌿', 'Botany is all about plants – from tiny mosses to giant trees!', 'वनस्पतिशास्त्र बोटबिरुवाको बारेमा हो – साना मसदेखि विशाल रूखसम्म!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2113, 1034, 'Botany', 'वनस्पतिशास्त्र', '🌿', 1),
(2114, 1034, 'Zoology', 'प्राणीशास्त्र', '🐾', 0),
(2115, 1034, 'Ecology', 'पारिस्थितिकी', '🌍', 0),
(2116, 1034, 'Geology', 'भूविज्ञान', '⛰️', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1035, 6, 'mcq', 'Which organ cleans our blood and makes pee? 🧼', 'कुन अंगले रगत सफा गर्छ र पिसाब बनाउँछ? 🧼', 'Kidneys work like a washing machine – they filter waste from blood!', 'मृगौला वासिङ मेसिन जस्तै काम गर्छ – यसले रगतबाट फोहोर फिल्टर गर्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2117, 1035, 'Kidneys', 'मृगौला', '🧫', 1),
(2118, 1035, 'Liver', 'कलेजो', '🧫', 0),
(2119, 1035, 'Heart', 'मुटु', '❤️', 0),
(2120, 1035, 'Lungs', 'फोक्सो', '🫁', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1036, 6, 'puzzle', 'Order the human life stages from baby to adult:', 'मानव जीवनका चरणहरूलाई बच्चादेखि वयस्कसम्म मिलाउनुहोस्:', 'Baby → Child → Teenager → Adult', 'बच्चा → बालक → किशोर → वयस्क', 'We all start as babies and grow up – everyone does!', 'हामी सबै बच्चाबाट सुरु हुन्छौं र ठूला हुन्छौं – सबैले यस्तै गर्छन्!', '["b","a","d","c"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3020, 1036, 'a', 'Child', 'बालक', '🧒'),
(3021, 1036, 'b', 'Baby', 'बच्चा', '👶'),
(3022, 1036, 'c', 'Adult', 'वयस्क', '🧑'),
(3023, 1036, 'd', 'Teenager', 'किशोर', '🧑‍🎓');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1037, 7, 'mcq', 'Which planet is closest to the Sun? 🌞', 'कुन ग्रह सूर्यको सबैभन्दा नजिक छ? 🌞', 'Mercury is tiny and fast – it orbits the Sun in just 88 days!', 'बुध सानो र छिटो छ – यसले सूर्यको परिक्रमा जम्मा ८८ दिनमा गर्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2121, 1037, 'Mercury', 'बुध', '☿️', 1),
(2122, 1037, 'Venus', 'शुक्र', '♀️', 0),
(2123, 1037, 'Earth', 'पृथ्वी', '🌍', 0),
(2124, 1037, 'Mars', 'मंगल', '🔴', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1038, 7, 'mcq', 'Which planet looks red like rust? 🔴', 'कुन ग्रह खिया जस्तै रातो देखिन्छ? 🔴', 'Mars is red because of iron rust – like an old bicycle!', 'मंगल रातो छ किनभने फलामको खिया – पुरानो साइकल जस्तै!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2125, 1038, 'Mars', 'मंगल', '🔴', 1),
(2126, 1038, 'Venus', 'शुक्र', '🟡', 0),
(2127, 1038, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2128, 1038, 'Saturn', 'शनि', '🪐', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1039, 7, 'mcq', 'Which planet has beautiful rings around it? 💍', 'कुन ग्रहको वरिपरि सुन्दर वलय छ? 💍', 'Saturn\'s rings are made of ice and rock – they sparkle like jewels!', 'शनिका वलय बरफ र ढुङ्गाले बनेका छन् – तिनीहरू रत्नजस्तै चम्किन्छन्!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2129, 1039, 'Saturn', 'शनि', '🪐', 1),
(2130, 1039, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2131, 1039, 'Neptune', 'नेप्च्युन', '🔵', 0),
(2132, 1039, 'Uranus', 'युरेनस', '🟢', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1040, 7, 'mcq', 'Which planet is the biggest of them all? 🐘', 'सबैभन्दा ठूलो ग्रह कुन हो? 🐘', 'Jupiter is so huge that all the other planets could fit inside!', 'बृहस्पति यति ठूलो छ कि अरू सबै ग्रहहरू यसको भित्र अटाउन सक्छन्!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2133, 1040, 'Jupiter', 'बृहस्पति', '🟠', 1),
(2134, 1040, 'Saturn', 'शनि', '🪐', 0),
(2135, 1040, 'Neptune', 'नेप्च्युन', '🔵', 0),
(2136, 1040, 'Uranus', 'युरेनस', '🟢', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1041, 7, 'mcq', 'What is the name of our galaxy? 🌌', 'हाम्रो आकाशगंगाको नाम के हो? 🌌', 'Our galaxy looks like a milky swirl in the night sky – that\'s why it\'s called the Milky Way!', 'हाम्रो आकाशगंगा रातको आकाशमा दुधको जस्तै देखिन्छ – त्यसैले यसलाई दुधको बाटो भनिन्छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2137, 1041, 'Milky Way', 'दुधको बाटो', '🌌', 1),
(2138, 1041, 'Andromeda', 'एन्ड्रोमेडा', '🌠', 0),
(2139, 1041, 'Triangulum', 'त्रिभुज', '🔺', 0),
(2140, 1041, 'Sombrero', 'सोम्ब्रेरो', '🎩', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1042, 7, 'puzzle', 'Order these planets from closest to farthest from the Sun:', 'यी ग्रहहरूलाई सूर्यबाट नजिकदेखि टाढासम्म मिलाउनुहोस्:', 'Mercury → Venus → Earth → Mars', 'बुध → शुक्र → पृथ्वी → मंगल', 'The inner planets are small and rocky – the outer ones are big gas balls!', 'भित्री ग्रहहरू साना र चट्टानी हुन् – बाहिरी ग्रहहरू ठूला ग्यासका बल हुन्!', '["b","c","a","d"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3024, 1042, 'a', 'Earth', 'पृथ्वी', '🌍'),
(3025, 1042, 'b', 'Mercury', 'बुध', '☿️'),
(3026, 1042, 'c', 'Venus', 'शुक्र', '♀️'),
(3027, 1042, 'd', 'Mars', 'मंगल', '🔴');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1043, 8, 'mcq', 'What is Saturn\'s biggest moon called? 🌕', 'शनिको सबैभन्दा ठूलो चन्द्रमाको नाम के हो? 🌕', 'Titan is even bigger than Mercury – it has its own thick air!', 'टाइटान बुधभन्दा पनि ठूलो छ – यसको आफ्नै बाक्लो हावा छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2141, 1043, 'Titan', 'टाइटान', '🌕', 1),
(2142, 1043, 'Europa', 'युरोपा', '🌕', 0),
(2143, 1043, 'Ganymede', 'ग्यानिमेड', '🌕', 0),
(2144, 1043, 'Callisto', 'क्यालिस्टो', '🌕', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1044, 8, 'mcq', 'Which planet has a day that\'s longer than its year? ⏳', 'कुन ग्रहको दिन वर्षभन्दा लामो छ? ⏳', 'Venus spins so slowly that a day there lasts longer than a year – crazy!', 'शुक्र यति ढिलो घुम्छ कि त्यहाँको दिन वर्षभन्दा लामो हुन्छ – पागल!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2145, 1044, 'Venus', 'शुक्र', '♀️', 1),
(2146, 1044, 'Mercury', 'बुध', '☿️', 0),
(2147, 1044, 'Mars', 'मंगल', '🔴', 0),
(2148, 1044, 'Jupiter', 'बृहस्पति', '🟠', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1045, 8, 'mcq', 'What is the famous big storm on Jupiter called? 🌪️', 'बृहस्पतिमा रहेको प्रसिद्ध ठूलो आँधीलाई के भनिन्छ? 🌪️', 'The Great Red Spot is a giant storm – it\'s been raging for hundreds of years!', 'ठूलो रातो धब्बा एक विशाल आँधी हो – यो सयौं वर्षदेखि चलिरहेको छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2149, 1045, 'Great Red Spot', 'ठूलो रातो धब्बा', '🌀', 1),
(2150, 1045, 'Great Dark Spot', 'ठूलो कालो धब्बा', '🌑', 0),
(2151, 1045, 'Eye of Jupiter', 'बृहस्पतिको आँखा', '👁️', 0),
(2152, 1045, 'Jupiter\'s Hurricane', 'बृहस्पतिको आँधी', '💨', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1046, 8, 'mcq', 'Which planet is often called the "Morning Star"? ⭐', 'कुन ग्रहलाई प्रायः "बिहानी तारा" भनिन्छ? ⭐', 'Venus shines bright in the morning and evening – it\'s a dazzling star!', 'शुक्र बिहान र साँझ उज्यालो हुन्छ – यो चम्किलो तारा हो!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2153, 1046, 'Venus', 'शुक्र', '♀️', 1),
(2154, 1046, 'Mars', 'मंगल', '🔴', 0),
(2155, 1046, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2156, 1046, 'Saturn', 'शनि', '🪐', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1047, 8, 'mcq', 'What is the tiniest planet in our solar system? 🪐', 'हाम्रो सौर्यमण्डलको सबैभन्दा सानो ग्रह कुन हो? 🪐', 'Mercury is the smallest – it\'s only a little bigger than our Moon!', 'बुध सबैभन्दा सानो हो – यो हाम्रो चन्द्रमाभन्दा अलि मात्र ठूलो छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2157, 1047, 'Mercury', 'बुध', '☿️', 1),
(2158, 1047, 'Mars', 'मंगल', '🔴', 0),
(2159, 1047, 'Venus', 'शुक्र', '♀️', 0),
(2160, 1047, 'Neptune', 'नेप्च्युन', '🔵', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1048, 8, 'puzzle', 'Put these planets in order from smallest to largest:', 'यी ग्रहहरूलाई सानोदेखि ठूलोसम्म मिलाउनुहोस्:', 'Mercury → Mars → Venus → Earth', 'बुध → मंगल → शुक्र → पृथ्वी', 'Earth is the biggest rocky planet, but Jupiter is the real giant!', 'पृथ्वी सबैभन्दा ठूलो चट्टानी ग्रह हो, तर बृहस्पति साँचो विशाल हो!', '["d","b","c","a"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3028, 1048, 'a', 'Earth', 'पृथ्वी', '🌍'),
(3029, 1048, 'b', 'Mars', 'मंगल', '🔴'),
(3030, 1048, 'c', 'Venus', 'शुक्र', '♀️'),
(3031, 1048, 'd', 'Mercury', 'बुध', '☿️');

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1049, 9, 'mcq', 'Which body was demoted to a dwarf planet? 😢', 'कुन पिण्डलाई बौना ग्रहको रूपमा पुन: वर्गीकृत गरियो? 😢', 'Pluto got kicked out of the planet club in 2006 – but it\'s still cool!', 'प्लुटोलाई २००६ मा ग्रह क्लबबाट निकालियो – तर यो अझै राम्रो छ!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2161, 1049, 'Pluto', 'प्लुटो', '♇', 1),
(2162, 1049, 'Ceres', 'सेरेस', '🌑', 0),
(2163, 1049, 'Eris', 'एरिस', '🌑', 0),
(2164, 1049, 'Makemake', 'मेकमेक', '🌑', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1050, 9, 'mcq', 'Which planet has the most moons? 🌙', 'कुन ग्रहमा सबैभन्दा धेरै चन्द्रमा छन्? 🌙', 'Saturn has over 80 moons – that\'s a whole solar system of friends!', 'शनिसँग ८० भन्दा बढी चन्द्रमा छन् – त्यो साथीहरूको सम्पूर्ण सौर्यमण्डल हो!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2165, 1050, 'Saturn', 'शनि', '🪐', 1),
(2166, 1050, 'Jupiter', 'बृहस्पति', '🟠', 0),
(2167, 1050, 'Uranus', 'युरेनस', '🟢', 0),
(2168, 1050, 'Neptune', 'नेप्च्युन', '🔵', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1051, 9, 'mcq', 'What is the Kuiper Belt? 🧊', 'काइपर बेल्ट के हो? 🧊', 'The Kuiper Belt is like a giant freezer full of icy rocks and dwarf planets!', 'काइपर बेल्ट बरफीय ढुङ्गा र बौना ग्रहहरूले भरिएको विशाल फ्रिजर जस्तै हो!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2169, 1051, 'A ring of icy stuff past Neptune', 'नेप्च्युनभन्दा पर बरफीय क्षेत्र', '🧊', 1),
(2170, 1051, 'A belt of asteroids between Mars and Jupiter', 'मंगल र बृहस्पतिबीचको क्षुद्रग्रह घेरा', '🪨', 0),
(2171, 1051, 'A big gas cloud around the Sun', 'सूर्यको वरिपरि ठूलो ग्यास बादल', '☁️', 0),
(2172, 1051, 'A layer of the Sun\'s atmosphere', 'सूर्यको वायुमण्डलको तह', '☀️', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1052, 9, 'mcq', 'What is the Sun mostly made of? ☀️', 'सूर्य प्रायः केले बनेको छ? ☀️', 'The Sun is a giant ball of gas – mostly hydrogen and helium, like a star!', 'सूर्य ग्यासको विशाल बल हो – प्रायः हाइड्रोजन र हेलियम, तारा जस्तै!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2173, 1052, 'Hydrogen and Helium', 'हाइड्रोजन र हेलियम', '💨', 1),
(2174, 1052, 'Oxygen and Carbon', 'अक्सिजन र कार्बन', '🌿', 0),
(2175, 1052, 'Iron and Nickel', 'फलाम र निकेल', '⚙️', 0),
(2176, 1052, 'Silicon and Aluminium', 'सिलिकन र एल्युमिनियम', '🔮', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, fun_fact_en, fun_fact_ne) VALUES
(1053, 9, 'mcq', 'How fast do you need to go to escape Earth\'s gravity? 🚀', 'पृथ्वीको गुरुत्वाकर्षणबाट मुक्त हुन कति छिटो जानुपर्छ? 🚀', 'That\'s called escape velocity – it\'s like a rocket\'s need for speed!', 'यसलाई पलायन वेग भनिन्छ – यो रकेटको गतिको आवश्यकता जस्तै हो!');
INSERT IGNORE INTO flashcard_options (option_id, question_id, option_text_en, option_text_ne, emoji, is_correct) VALUES
(2177, 1053, '11.2 km/s', '११.२ किमी/से', '🚀', 1),
(2178, 1053, '7.9 km/s', '७.९ किमी/से', '🛰️', 0),
(2179, 1053, '3.5 km/s', '३.५ किमी/से', '✈️', 0),
(2180, 1053, '15 km/s', '१५ किमी/से', '🚀', 0);

INSERT IGNORE INTO flashcard_questions (question_id, level_id, type, question_en, question_ne, hint_en, hint_ne, fun_fact_en, fun_fact_ne, correct_order) VALUES
(1054, 9, 'puzzle', 'Order these planets by distance from the Sun (closest to farthest):', 'यी ग्रहहरूलाई सूर्यबाट दूरी (नजिकदेखि टाढा) अनुसार मिलाउनुहोस्:', 'Mercury → Venus → Earth → Mars', 'बुध → शुक्र → पृथ्वी → मंगल', 'It takes 8 minutes for sunlight to reach us – that\'s a long journey!', 'सूर्यको प्रकाश हामीसम्म आउन ८ मिनेट लाग्छ – त्यो लामो यात्रा हो!', '["c","b","d","a"]');
INSERT IGNORE INTO flashcard_puzzle_items (item_id, question_id, item_id_code, item_label_en, item_label_ne, emoji) VALUES
(3032, 1054, 'a', 'Mars', 'मंगल', '🔴'),
(3033, 1054, 'b', 'Venus', 'शुक्र', '♀️'),
(3034, 1054, 'c', 'Mercury', 'बुध', '☿️'),
(3035, 1054, 'd', 'Earth', 'पृथ्वी', '🌍');

INSERT IGNORE INTO flashcard_decks (deck_id, level_id, deck_name_en, deck_name_ne) VALUES
(1, 10, 'Basic Flashcards', 'आधारभूत फ्ल्यास कार्ड'),
(2, 11, 'Intermediate Flashcards', 'मध्यवर्ती फ्ल्यास कार्ड'),
(3, 12, 'Advanced Flashcards', 'उन्नत फ्ल्यास कार्ड');

INSERT IGNORE INTO flashcard_cards (card_id, deck_id, card_icon, name_en, name_ne, subtitle_en, subtitle_ne, tag_en, tag_ne, facts_en, facts_ne) VALUES
(4001, 1, '☀️', 'The Sun', 'सूर्य', 'Our Star', 'हाम्रो तारा', 'Star', 'तारा', '["The Sun gives us light and heat – it\'s a big, bright star!","It\'s so huge that 1 million Earths could fit inside!","The Sun is about 5,500°C on the surface – that\'s super hot!"]', '["सूर्यले हामीलाई उज्यालो र गर्मी दिन्छ – यो एउटा ठूलो, चम्किलो तारा हो!","यति ठूलो छ कि १० लाख पृथ्वीहरू यसको भित्र अटाउन सक्छन्!","सूर्यको सतहको तापक्रम करिब ५,५००°C छ – त्यो धेरै तातो हो!"]'),
(4002, 1, '☿', 'Mercury', 'बुध', 'The Swift Planet', 'छिटो ग्रह', 'Terrestrial', 'स्थलीय', '["Mercury is the tiniest planet and the closest to the Sun!","It has almost no air, so days are boiling hot and nights are freezing cold!","A year on Mercury is just 88 Earth days – super short!"]', '["बुध सबैभन्दा सानो ग्रह हो र सूर्यको सबैभन्दा नजिक छ!","यहाँ लगभग हावा छैन, त्यसैले दिनमा धेरै तातो र रातमा धेरै चिसो हुन्छ!","बुधको एक वर्ष जम्मा ८८ पृथ्वी दिन हो – धेरै छोटो!"]'),
(4003, 1, '♀', 'Venus', 'शुक्र', 'The Evening Star', 'साँझको तारा', 'Terrestrial', 'स्थलीय', '["Venus is the hottest planet – even hotter than Mercury!","It spins backwards – the Sun rises in the west and sets in the east!","Its thick clouds are made of acid – yikes!"]', '["शुक्र सबैभन्दा तातो ग्रह हो – बुधभन्दा पनि तातो!","यो उल्टो घुम्छ – सूर्य पश्चिममा उदाउँछ र पूर्वमा अस्ताउँछ!","यसको बाक्लो बादलहरू एसिडले बनेका छन् – ओहो!"]'),
(4004, 1, '🌍', 'Earth', 'पृथ्वी', 'The Blue Marble', 'निलो संगमरमर', 'Terrestrial', 'स्थलीय', '["Earth is the only planet we know that has life!","About 71% of Earth is covered with water – that\'s why it looks blue!","We have one moon that lights up our night sky."]', '["पृथ्वी मात्र त्यो ग्रह हो जहाँ जीवन छ!","पृथ्वीको करिब ७१% पानीले ढाकिएको छ – त्यसैले यो निलो देखिन्छ!","हामीसँग एउटा चन्द्रमा छ जसले रातको आकाश उज्यालो बनाउँछ।"]'),
(4005, 1, '♂', 'Mars', 'मंगल', 'The Red Planet', 'रातो ग्रह', 'Terrestrial', 'स्थलीय', '["Mars is called the Red Planet because of rusty iron on its surface!","It has the tallest volcano in the solar system – Olympus Mons!","Mars has two tiny moons: Phobos and Deimos."]', '["मंगललाई रातो ग्रह भनिन्छ किनभने यसको सतहमा खिया लागेको फलाम छ!","यसमा सौर्यमण्डलको सबैभन्दा अग्लो ज्वालामुखी छ – ओलम्पस मोन्स!","मंगलका दुई साना चन्द्रमा छन्: फोबोस र डेमोस।"]'),
(4006, 1, '🌙', 'The Moon', 'चन्द्रमा', 'Earth\'s Companion', 'पृथ्वीको साथी', 'Moon', 'चन्द्रमा', '["The Moon is Earth\'s only natural satellite – it orbits around us!","It\'s about 384,400 km away – that\'s far but we can see it every night!","There\'s no air on the Moon, so footprints stay forever!"]', '["चन्द्रमा पृथ्वीको एकमात्र प्राकृतिक उपग्रह हो – यो हाम्रो वरिपरि घुम्छ!","यो करिब ३,८४,४०० किमी टाढा छ – त्यो धेरै टाढा तर हामी यसलाई हरेक रात देख्न सक्छौं!","चन्द्रमामा हावा छैन, त्यसैले पाइलाका छाप सधैं रहन्छन्!"]'),
(4007, 1, '🧊', 'States of Matter', 'पदार्थका अवस्थाहरू', 'Solid, Liquid, Gas', 'ठोस, तरल, ग्यास', 'Science', 'विज्ञान', '["Solids keep their shape – like ice cubes and rocks!","Liquids flow and take the shape of their container – like water and milk!","Gases fill up any space – like the air we breathe!","Heating or cooling can change matter from one state to another – cool, right?"]', '["ठोस पदार्थहरू आफ्नो आकार राख्छन् – जस्तै बरफका टुक्रा र ढुङ्गा!","तरल पदार्थ बग्छन् र भाँडाको आकार लिन्छन् – जस्तै पानी र दूध!","ग्यासहरू कुनै पनि ठाउँ भर्छन् – जस्तै हामीले सास फेर्ने हावा!","तातो वा चिसोले पदार्थको अवस्था परिवर्तन गर्न सक्छ – रमाइलो, हैन?"]'),
(4008, 1, '💧', 'The Water Cycle', 'पानीको चक्र', 'Water on the Move', 'पानीको गतिशीलता', 'Nature', 'प्रकृति', '["Evaporation: the Sun heats water and turns it into vapor!","Condensation: vapor cools and makes clouds!","Precipitation: water falls back as rain or snow!","Collection: water gathers in rivers, lakes, and oceans – and the cycle starts again!"]', '["वाष्पीकरण: सूर्यले पानीलाई तताउँछ र वाष्प बनाउँछ!","संघनन: वाष्प चिसो हुन्छ र बादल बनाउँछ!","वर्षा: पानी फेरि वर्षा वा हिउँको रूपमा खस्छ!","सङ्कलन: पानी नदी, ताल र महासागरमा जम्मा हुन्छ – र चक्र फेरि सुरु हुन्छ!"]'),
(4009, 1, '🌱', 'Plant Parts', 'बोटका भागहरू', 'Roots, Stem, Leaves, Flowers', 'जरा, डाँठ, पात, फूल', 'Nature', 'प्रकृति', '["Roots hold the plant in the ground and drink water and minerals!","Stems stand tall and carry food and water around the plant!","Leaves are like little kitchens – they make food using sunlight!","Flowers are the pretty part – they make seeds for new plants!"]', '["जराले बोटलाई जमिनमा टाँस्छ र पानी र खनिज पिउँछ!","डाँठले बोटलाई उभ्याउँछ र खाना र पानी बोटभरि पुर्याउँछ!","पातहरू सानो भान्सा जस्तै हुन् – तिनीहरूले सूर्यको प्रकाश प्रयोग गरेर खाना बनाउँछन्!","फूलहरू सुन्दर भाग हुन् – तिनीहरूले नयाँ बोटका लागि बीउ बनाउँछन्!"]'),
(4010, 1, '👁️', 'The Five Senses', 'पाँच इन्द्रियहरू', 'See, Hear, Smell, Taste, Touch', 'देख्नु, सुन्नु, सुँघ्नु, स्वाद लिनु, छुनु', 'Science', 'विज्ञान', '["Sight – our eyes help us see colors, shapes, and faces!","Hearing – our ears catch sounds and music!","Smell – our nose picks up yummy and yucky smells!","Taste – our tongue tastes sweet, sour, salty, bitter, and umami!","Touch – our skin feels things like soft, rough, hot, and cold!"]', '["दृष्टि – हाम्रा आँखाले रंग, आकार र अनुहार देख्न मद्दत गर्छ!","श्रवण – हाम्रा कानले आवाज र संगीत सुन्छन्!","घ्राण – हाम्रो नाकले मीठो र फोहोर गन्ध पत्ता लगाउँछ!","स्वाद – हाम्रो जिब्रोले मीठो, अमिलो, नुनिलो, तीतो र उमामी स्वाद लिन्छ!","स्पर्श – हाम्रो छालाले नरम, नराम्रो, तातो र चिसो महसुस गर्छ!"]'),
(4011, 1, '☀️', 'Weather Types', 'मौसम प्रकार', 'Sunny, Rainy, Cloudy, Snowy', 'घाम, वर्षा, बादली, हिउँ', 'Nature', 'प्रकृति', '["Sunny – bright and warm, great for playing outside!","Rainy – water drops fall from clouds, don\'t forget your umbrella!","Cloudy – the sky is covered with clouds, sometimes it rains!","Snowy – ice crystals fall as snowflakes, perfect for snowmen!","Weather changes how we dress and what we do every day!"]', '["घाम – उज्यालो र न्यानो, बाहिर खेल्नको लागि उत्तम!","वर्षा – बादलबाट पानीका थोपा खस्छन्, आफ्नो छाता नबिर्सनुहोस्!","बादली – आकाश बादलले ढाकिएको छ, कहिलेकाहीँ वर्षा हुन्छ!","हिउँ – बरफका क्रिस्टल हिउँका फोका जस्तै खस्छन्, हिउँमानिस बनाउन उत्तम!","मौसमले हाम्रो पहिरन र हामीले दैनिक के गर्छौं भनेर परिवर्तन गर्छ!"]'),
(4012, 1, '🌿', 'Living vs Non-Living', 'जीवित र निर्जीव', 'What is alive?', 'के जीवित छ?', 'Science', 'विज्ञान', '["Living things grow, need food, and can have babies – like plants and animals!","People, dogs, and trees are living things.","Non-living things don\'t grow or need food – like rocks, chairs, and toys!","Living things react to changes around them – like a plant bending toward the sun!"]', '["जीवित चीजहरू बढ्छन्, खाना चाहिन्छ र बच्चा जन्माउँछन् – जस्तै बोट र जनावर!","मानिस, कुकुर र रूखहरू जीवित चीजहरू हुन्।","निर्जीव चीजहरू बढ्दैनन् र खाना चाहिँदैन – जस्तै ढुङ्गा, कुर्सी र खेलौना!","जीवित चीजहरू आफ्नो वरपरको परिवर्तनमा प्रतिक्रिया दिन्छन् – जस्तै सूर्यतिर झुकेको बोट!"]'),
(4013, 2, '♃', 'Jupiter', 'बृहस्पति', 'The Giant', 'विशाल', 'Gas Giant', 'ग्यासको विशाल', '["Jupiter is the biggest planet – you could fit 1,300 Earths inside!","It has a giant storm called the Great Red Spot – it\'s bigger than Earth!","Jupiter has 79 known moons – that\'s a lot of friends!"]', '["बृहस्पति सबैभन्दा ठूलो ग्रह हो – यसको भित्र १३०० पृथ्वीहरू अटाउन सक्छन्!","यसमा ठूलो आँधी छ जसलाई ठूलो रातो धब्बा भनिन्छ – यो पृथ्वीभन्दा ठूलो छ!","बृहस्पतिसँग ७९ ज्ञात चन्द्रमा छन् – त्यो धेरै साथीहरू!"]'),
(4014, 2, '♄', 'Saturn', 'शनि', 'The Ringed World', 'वलय भएको संसार', 'Gas Giant', 'ग्यासको विशाल', '["Saturn has beautiful rings made of ice and rock – they sparkle!","Saturn is so light that it would float in a giant bathtub – weird, right?","It has 82 known moons – the most in the solar system!"]', '["शनिसँग बरफ र ढुङ्गाले बनेका सुन्दर वलय छन् – तिनीहरू चम्किन्छन्!","शनि यति हलुका छ कि यो एउटा विशाल नुहाउने टबमा पौडिन सक्छ – अनौठो, हैन?","यससँग ८२ ज्ञात चन्द्रमा छन् – सौर्यमण्डलमा सबैभन्दा धेरै!"]'),
(4015, 2, '⛢', 'Uranus', 'युरेनस', 'The Sideways Planet', 'छेउको ग्रह', 'Ice Giant', 'बरफको विशाल', '["Uranus spins on its side – almost like a rolling ball!","It\'s the coldest planet – -224°C, brrr!","It has 27 known moons, all named after Shakespeare characters!"]', '["युरेनस आफ्नो छेउमा घुम्छ – लगभग एउटा बल जस्तै!","यो सबैभन्दा चिसो ग्रह हो – -२२४°C, हिउँ!","यससँग २७ ज्ञात चन्द्रमा छन्, सबै शेक्सपियरका पात्रहरूको नाममा!"]'),
(4016, 2, '♆', 'Neptune', 'नेप्च्युन', 'The Windy World', 'हावायुक्त संसार', 'Ice Giant', 'बरफको विशाल', '["Neptune is the windiest planet – winds blow at 2,100 km/h!","It\'s the farthest planet from the Sun – very cold and dark!","It has 14 known moons, with the largest named Triton."]', '["नेप्च्युन सबैभन्दा हावायुक्त ग्रह हो – हावा २,१०० किमी/घण्टाको गतिले बहन्छ!","यो सूर्यबाट सबैभन्दा टाढाको ग्रह हो – धेरै चिसो र अँधेरो!","यससँग १४ ज्ञात चन्द्रमा छन्, सबैभन्दा ठूलोको नाम ट्राइटन हो।"]'),
(4017, 2, '☄️', 'Asteroid Belt', 'क्षुद्रग्रह घेरा', 'Between Mars & Jupiter', 'मंगल र बृहस्पतिबीच', 'Belt', 'घेरा', '["The asteroid belt is a huge ring of rocks between Mars and Jupiter!","There are millions of asteroids – some are tiny, some are huge!","The biggest one is Ceres – it\'s a dwarf planet!"]', '["क्षुद्रग्रह घेरा मंगल र बृहस्पतिबीच ढुङ्गाहरूको विशाल घेरा हो!","त्यहाँ लाखौं क्षुद्रग्रहहरू छन् – कोही साना, कोही ठूला!","सबैभन्दा ठूलो सेरेस हो – यो एउटा बौना ग्रह हो!"]'),
(4018, 2, '🪐', 'Pluto', 'प्लुटो', 'Dwarf Planet', 'बौना ग्रह', 'Dwarf Planet', 'बौना ग्रह', '["Pluto is a dwarf planet – it\'s smaller than our Moon!","It has 5 moons – the biggest one is Charon, almost as big as Pluto!","Pluto was reclassified as a dwarf planet in 2006 – poor Pluto!"]', '["प्लुटो एउटा बौना ग्रह हो – यो हाम्रो चन्द्रमाभन्दा सानो छ!","यससँग ५ चन्द्रमा छन् – सबैभन्दा ठूलो चारोन हो, लगभग प्लुटो जति ठूलो!","प्लुटोलाई २००६ मा बौना ग्रहको रूपमा पुन: वर्गीकृत गरियो – गरिब प्लुटो!"]'),
(4019, 2, '🌱', 'Photosynthesis', 'प्रकाश संश्लेषण', 'How Plants Make Food', 'बोटबिरुवाले कसरी खाना बनाउँछन्', 'Science', 'विज्ञान', '["Plants use sunlight, water, and CO₂ to make their own food!","The green stuff in leaves – chlorophyll – catches sunlight!","Plants release oxygen – that\'s the air we breathe!","Without plants, we wouldn\'t have any oxygen – thank you, plants!"]', '["बोटबिरुवाले आफ्नो खाना बनाउन सूर्यको प्रकाश, पानी र CO₂ प्रयोग गर्छन्!","पातको हरियो भाग – क्लोरोफिल – सूर्यको प्रकाश समात्छ!","बोटबिरुवाले अक्सिजन छोड्छन् – त्यो हामीले सास फेर्ने हावा हो!","बोटबिरुवा नभएको भए हामीसँग अक्सिजन हुँदैन – धन्यवाद, बोटबिरुवा!"]'),
(4020, 2, '🐾', 'Food Chains', 'खाद्य शृंखला', 'Who Eats Whom?', 'कसले कसलाई खान्छ?', 'Nature', 'प्रकृति', '["Producers – like plants – make their own food from sunlight!","Consumers – like rabbits and foxes – eat other living things!","Decomposers – like fungi and bacteria – break down dead things!","A food chain shows how energy flows in nature – it\'s all connected!"]', '["उत्पादकहरू – जस्तै बोट – सूर्यको प्रकाशबाट आफ्नो खाना बनाउँछन्!","उपभोक्ताहरू – जस्तै खरायो र फ्याक्स – अरू जीवित चीजहरू खान्छन्!","विघटनकर्ताहरू – जस्तै फङ्गस र ब्याक्टेरिया – मरेका चीजहरू विघटन गर्छन्!","खाद्य शृंखलाले प्रकृतिमा ऊर्जा कसरी प्रवाह हुन्छ देखाउँछ – यो सबै जोडिएको छ!"]'),
(4021, 2, '🧠', 'Human Body Systems', 'मानव शरीर प्रणाली', 'How We Work', 'हामी कसरी काम गर्छौं', 'Science', 'विज्ञान', '["Skeletal system – bones support us and protect our insides!","Muscular system – muscles let us run, jump, and play!","Digestive system – it breaks down food so we get energy!","Respiratory system – our lungs take in oxygen and let out CO₂!","All systems work together – teamwork makes the body work!"]', '["कंकाल प्रणाली – हड्डीहरूले हामीलाई सहारा दिन्छन् र भित्री अंगहरूको सुरक्षा गर्छन्!","मांसपेशी प्रणाली – मांसपेशीले हामीलाई दौडन, हामफाल्न र खेल्न दिन्छ!","पाचन प्रणाली – यसले खानालाई पचाउँछ ताकि हामीलाई ऊर्जा मिलोस्!","श्वसन प्रणाली – हाम्रो फोक्सोले अक्सिजन लिन्छ र CO₂ बाहिर निकाल्छ!","सबै प्रणालीहरू मिलेर काम गर्छन् – टोली कार्यले शरीर काम गर्छ!"]'),
(4022, 2, '🌍', 'Ecosystems', 'पारिस्थितिकी तंत्र', 'Nature\'s Communities', 'प्रकृतिका समुदायहरू', 'Nature', 'प्रकृति', '["An ecosystem is a community of living and non-living things!","Forests, deserts, oceans, and grasslands are all ecosystems!","Each ecosystem has its own plants, animals, and weather!","Living things depend on each other – it\'s like a big family!"]', '["पारिस्थितिकी तंत्र भनेको जीवित र निर्जीव चीजहरूको समुदाय हो!","वन, मरुभूमि, महासागर र घाँसे मैदानहरू सबै पारिस्थितिकी तंत्र हुन्!","प्रत्येक पारिस्थितिकी तंत्रको आफ्नै बोटबिरुवा, जनावर र मौसम हुन्छ!","जीवित चीजहरू एकअर्कामा निर्भर हुन्छन् – यो ठूलो परिवार जस्तै हो!"]'),
(4023, 2, '🐾', 'Animal Classification', 'जनावर वर्गीकरण', 'Mammals, Birds, Fish & More', 'स्तनधारी, चरा, माछा र अरू', 'Nature', 'प्रकृति', '["Mammals have fur or hair and feed milk to their babies – like lions and dogs!","Birds have feathers, lay eggs, and many can fly – like eagles and penguins!","Reptiles have scales and are cold-blooded – like snakes and turtles!","Amphibians live on land and water – like frogs and salamanders!","Fish live in water, have gills and fins – like sharks and salmon!"]', '["स्तनधारीहरूको रौं वा कपाल हुन्छ र बच्चाहरूलाई दूध खुवाउँछन् – जस्तै सिंह र कुकुर!","चराहरूमा प्वाँख हुन्छ, अण्डा पार्छन्, र धेरै उड्न सक्छन् – जस्तै चील र पेंगुइन!","सरीसृपहरूमा स्केल हुन्छ र चिसो रगतका हुन्छन् – जस्तै सर्प र कछुवा!","उभयचरहरू जमिन र पानीमा बस्छन् – जस्तै भ्यागुता र सलामन्डर!","माछाहरू पानीमा बस्छन्, गिल र पखेटा हुन्छ – जस्तै शार्क र सामन!"]'),
(4024, 2, '🌱', 'Plant Life Cycle', 'बोटको जीवन चक्र', 'From Seed to Flower', 'बीउदेखि फूलसम्म', 'Nature', 'प्रकृति', '["Seed – it\'s the start of a new plant, waiting to grow!","Germination – the seed sprouts and sends roots down!","Growth – the plant grows leaves and stems to catch sunlight!","Reproduction – the plant makes flowers and new seeds!","The cycle goes on as seeds spread to make new plants – nature\'s magic!"]', '["बीउ – यो नयाँ बोटको सुरुवात हो, बढ्नको लागि पर्खिरहेको!","अंकुरण – बीउ अंकुरिन्छ र जरा तल पठाउँछ!","वृद्धि – बोटले सूर्यको प्रकाश समात्न पात र डाँठ उमार्छ!","प्रजनन – बोटले फूल र नयाँ बीउ बनाउँछ!","चक्र जारी रहन्छ किनभने बीउहरू फैलिएर नयाँ बोट बनाउँछन् – प्रकृतिको जादू!"]'),
(4025, 3, '☀️', 'Solar Mass', 'सौर्य द्रव्यमान', '1.989 × 10³⁰ kg', '१.९८९ × १०³⁰ किग्रा', 'Star', 'तारा', '["The Sun is so heavy that it holds 99.86% of all the mass in our solar system!","It would take 333,000 Earths to match the Sun\'s weight – wow!","Every second, the Sun loses 4 million tons of mass as it shines – that\'s crazy!"]', '["सूर्य यति भारी छ कि यसले हाम्रो सौर्यमण्डलको ९९.८६% द्रव्यमान समाउँछ!","सूर्यको तौल बराबर गर्न ३,३३,००० पृथ्वीहरू चाहिन्छ – वाह!","प्रत्येक सेकेन्ड, सूर्यले चम्किरहेको बेला ४ लाख टन द्रव्यमान गुमाउँछ – त्यो अचम्मको हो!"]'),
(4026, 3, '☿', 'Mercury\'s Orbit', 'बुधको कक्षा', '88 Days, Eccentric', '८८ दिन, अण्डाकार', 'Terrestrial', 'स्थलीय', '["Mercury has the most oval-shaped orbit of all planets – it\'s not a perfect circle!","Its distance from the Sun changes a lot – from 46 to 70 million km!","Mercury zips around the Sun at 47.87 km/s – faster than any other planet!"]', '["बुधको कक्षा सबैभन्दा अण्डाकार छ – यो पूरा वृत्त होइन!","सूर्यबाट यसको दूरी धेरै परिवर्तन हुन्छ – ४६ देखि ७० मिलियन किमी!","बुध सूर्यको वरिपरि ४७.८७ किमी/सेकेन्डको गतिमा घुम्छ – अरू कुनै ग्रहभन्दा छिटो!"]'),
(4027, 3, '♀', 'Venus\' Rotation', 'शुक्रको घुमाव', '243 Days — Longer than Year', '२४३ दिन — वर्षभन्दा लामो', 'Terrestrial', 'स्थलीय', '["Venus takes 243 Earth days to spin once – that\'s longer than its year (225 days)!","So a day on Venus is longer than a year – weird!","It spins backwards, so the Sun rises in the west – that\'s topsy-turvy!"]', '["शुक्रलाई एक पटक घुम्न २४३ पृथ्वी दिन लाग्छ – त्यो यसको वर्ष (२२५ दिन) भन्दा लामो छ!","त्यसैले शुक्रमा एउटा दिन वर्षभन्दा लामो हुन्छ – अनौठो!","यो उल्टो घुम्छ, त्यसैले सूर्य पश्चिममा उदाउँछ – त्यो उल्टो हुन्छ!"]'),
(4028, 3, '🌍', 'Earth\'s Axial Tilt', 'पृथ्वीको अक्षीय झुकाव', '23.5° — Causes Seasons', '२३.५° — ऋतुहरूको कारण', 'Terrestrial', 'स्थलीय', '["Earth is tilted at 23.5° – that\'s why we have four seasons!","The tilt changes slightly over 41,000 years – a slow wobble!","The tilt also makes days longer in summer and shorter in winter!"]', '["पृथ्वी २३.५° मा झुकेको छ – त्यसैले हामीलाई चार ऋतुहरू हुन्छन्!","झुकाव ४१,००० वर्षमा अलि परिवर्तन हुन्छ – एक ढिलो हल्लाउने!","झुकावले गर्मीमा दिन लामो र जाडोमा छोटो बनाउँछ!"]'),
(4029, 3, '♂', 'Mars\' Atmosphere', 'मंगलको वायुमण्डल', '95% CO₂, Very Thin', '९५% CO₂, धेरै पातलो', 'Terrestrial', 'स्थलीय', '["Mars\' atmosphere is very thin – only 1% as thick as Earth\'s!","It\'s mostly carbon dioxide (95%) – not good for breathing!","Dust storms on Mars can cover the whole planet – like a big blanket!"]', '["मंगलको वायुमण्डल धेरै पातलो छ – पृथ्वीको भन्दा १% मात्र बाक्लो!","यो प्रायः कार्बन डाइअक्साइड (९५%) हो – सास फेर्नको लागि राम्रो छैन!","मंगलमा धुलोको आँधीले पूरै ग्रह ढाक्न सक्छ – ठूलो कम्बल जस्तै!"]'),
(4030, 3, '♃', 'Jupiter\'s Composition', 'बृहस्पतिको संरचना', '90% H, 10% He', '९०% H, १०% He', 'Gas Giant', 'ग्यासको विशाल', '["Jupiter is mostly hydrogen (90%) and helium (10%) – just like the Sun!","It has no solid surface – it\'s a giant ball of gas!","Jupiter\'s gravity is 2.5 times stronger than Earth\'s – you\'d be heavier there!"]', '["बृहस्पति प्रायः हाइड्रोजन (९०%) र हेलियम (१०%) हो – सूर्य जस्तै!","यसको कुनै ठोस सतह छैन – यो ग्यासको विशाल बल हो!","बृहस्पतिको गुरुत्वाकर्षण पृथ्वीको भन्दा २.५ गुणा बलियो छ – त्यहाँ तपाईं भारी हुनुहुन्छ!"]'),
(4031, 3, '🧬', 'DNA & Genetics', 'DNA र आनुवंशिकता', 'The Blueprint of Life', 'जीवनको नक्सा', 'Science', 'विज्ञान', '["DNA is like a recipe book that tells living things how to grow and function!","Genes are small bits of DNA that decide traits like eye color and height!","We get our DNA from our parents – that\'s why we look like them!","Changes in DNA – mutations – can create new traits and help evolution!"]', '["DNA एउटा रेसिपी किताब जस्तै हो जसले जीवित चीजहरूलाई कसरी बढ्न र काम गर्ने भन्ने बताउँछ!","जीनहरू DNA का साना टुक्रा हुन् जसले आँखाको रङ र उचाइ जस्ता विशेषताहरू निर्धारण गर्छन्!","हामी आफ्नो DNA आमाबाबुबाट पाउँछौं – त्यसैले हामी उनीहरू जस्तै देखिन्छौं!","DNA मा परिवर्तन – उत्परिवर्तन – नयाँ विशेषताहरू सिर्जना गर्न र विकासमा मद्दत गर्न सक्छ!"]'),
(4032, 3, '🧬', 'Evolution', 'विकास', 'Change Over Time', 'समयसँगै परिवर्तन', 'Science', 'विज्ञान', '["Natural selection means creatures with useful traits survive and have babies!","Adaptations help animals live better in their homes – like polar bears\' white fur!","Fossils are like time capsules – they show us ancient life!","All life on Earth is related – we all share a common ancestor, way back!"]', '["प्राकृतिक चयन भनेको उपयोगी विशेषताहरू भएका प्राणीहरू बाँच्छन् र बच्चा जन्माउँछन्!","अनुकूलनले जनावरहरूलाई आफ्नो घरमा राम्रोसँग बाँच्न मद्दत गर्छ – जस्तै ध्रुवीय भालुको सेतो फर!","जीवाश्महरू समय क्याप्सूल जस्तै हुन् – तिनीहरूले हामीलाई प्राचीन जीवन देखाउँछन्!","पृथ्वीमा सबै जीवन सम्बन्धित छ – हामी सबैको एउटै साझा पूर्वज छ, धेरै पहिले!"]'),
(4033, 3, '🌍', 'Biodiversity', 'जैविक विविधता', 'Variety of Life', 'जीवनको विविधता', 'Nature', 'प्रकृति', '["Biodiversity means all the different kinds of life on Earth – from tiny bugs to giant whales!","There are millions of species – each one is unique!","Biodiversity keeps ecosystems healthy – like a team with different players!","When we lose species, biodiversity drops – and that\'s bad for nature.","We can help by protecting forests, oceans, and all animals!"]', '["जैविक विविधता भनेको पृथ्वीमा जीवनका सबै विभिन्न प्रकारहरू हुन् – साना किरादेखि विशाल ह्वेलसम्म!","त्यहाँ लाखौं प्रजातिहरू छन् – प्रत्येक अद्वितीय छ!","जैविक विविधताले पारिस्थितिकी तंत्रलाई स्वस्थ राख्छ – विभिन्न खेलाडीहरू भएको टोली जस्तै!","जब हामीले प्रजातिहरू गुमाउँछौं, जैविक विविधता घट्छ – र त्यो प्रकृतिको लागि खराब हो।","हामी वन, महासागर र सबै जनावरहरूको संरक्षण गरेर मद्दत गर्न सक्छौं!"]'),
(4034, 3, '🌡️', 'Climate Change', 'जलवायु परिवर्तन', 'Our Warming Planet', 'हाम्रो तातो हुँदै गएको ग्रह', 'Nature', 'प्रकृति', '["Climate change means Earth is getting warmer over time.","It\'s caused by gases like CO₂ from cars, factories, and cutting down trees.","Effects include melting ice, rising seas, and wilder weather.","We can help by using clean energy, planting trees, and recycling!"]', '["जलवायु परिवर्तन भनेको पृथ्वी समयसँगै तातो हुँदै गइरहेको छ।","यो कार, कारखाना र रूख कटानबाट CO₂ जस्ता ग्यासहरूका कारण हुन्छ।","प्रभावहरूमा बरफ पग्लनु, समुद्रको सतह बढ्नु र मौसम अझ खराब हुनु समावेश छ।","हामी स्वच्छ ऊर्जा प्रयोग गरेर, रूख रोपेर र रिसाइकल गरेर मद्दत गर्न सक्छौं!"]'),
(4035, 3, '🔬', 'Cell Biology', 'कोशिका जीवविज्ञान', 'The Building Blocks of Life', 'जीवनका निर्माण ईंटहरू', 'Science', 'विज्ञान', '["Cells are the smallest unit of life – every living thing is made of cells!","Some cells have a nucleus (eukaryotic) and some don\'t (prokaryotic).","Cells have parts called organelles – like a nucleus, mitochondria, and ribosomes!","Cells divide to make new cells – that\'s how we grow and heal!"]', '["कोशिकाहरू जीवनको सबैभन्दा सानो एकाइ हुन् – प्रत्येक जीवित चीज कोशिकाहरूले बनेको हुन्छ!","कतिपय कोशिकाहरूमा न्यूक्लियस (युकेरियोटिक) हुन्छ र कतिपयमा हुँदैन (प्रोकेरियोटिक)।","कोशिकाहरूमा अंगहरू हुन्छन् – जस्तै न्यूक्लियस, माइटोकोन्ड्रिया र राइबोसोम!","कोशिकाहरू विभाजित भएर नयाँ कोशिकाहरू बनाउँछन् – त्यसरी हामी बढ्छौं र निको हुन्छौं!"]'),
(4036, 3, '🌿', 'Ecological Succession', 'पारिस्थितिक उत्तराधिकार', 'Nature\'s Rebuilding', 'प्रकृतिको पुन: निर्माण', 'Nature', 'प्रकृति', '["Primary succession – new land forms like islands from volcanoes!","Secondary succession – land recovers after a fire or flood.","First come pioneer species – like lichens and mosses – they prepare the soil.","Over time, a stable ecosystem called a climax community develops.","Nature always finds a way to rebuild!"]', '["प्राथमिक उत्तराधिकार – ज्वालामुखीबाट टापुहरू जस्तै नयाँ जमिन बन्छ!","द्वितीयक उत्तराधिकार – आगो वा बाढीपछि जमिन पुन: प्राप्त हुन्छ।","पहिले अग्रणी प्रजातिहरू आउँछन् – जस्तै लाइकेन र मस – तिनीहरूले माटो तयार गर्छन्।","समयसँगै, क्लाइम्याक्स समुदाय भनिने स्थिर पारिस्थितिकी तंत्र विकास हुन्छ।","प्रकृतिले सधैं पुन: निर्माण गर्ने तरिका खोज्छ!"]');