<?php
session_start();

// Protection: Only allow access if logged in as a child or parent
if (!isset($_SESSION['role'])) {
    header("Location: login.php");
    exit();
}

$has_error = false;

// Handle verification check
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['answer'])) {
        // Sanitize and validate integer input
        $user_answer = filter_input(INPUT_POST, 'answer', FILTER_VALIDATE_INT);
        $correct_answer = $_SESSION['grownup_math_ans'] ?? null;

        if ($user_answer !== false && $user_answer !== null && $correct_answer !== null && $user_answer === $correct_answer) {
            // Correct answer
            if ($_SESSION['role'] === 'parent') {
                // Already a parent, go straight to parent-dashboard
                header("Location: parent-dashboard.php");
            } else {
                // Elevate to parent
                $_SESSION['grownup_verified'] = true;
                header("Location: parent-access.php");
            }
            exit();
        } else {
            // Incorrect answer: set error flag
            $has_error = true;
        }
    }
}

// Generate new random math question (multiples of 5 only)
$op = (rand(0, 1) === 0) ? 'add' : 'subtract';

if ($op === 'add') {
    $a = rand(2, 16) * 5; // Multiples of 5 between 10 and 80
    $b = rand(2, 16) * 5; // Multiples of 5 between 10 and 80
    $ans = $a + $b;
} else {
    // Subtraction: Ensure A >= B + 10 to keep results positive and simple
    $a = rand(6, 18) * 5; // Multiples of 5 between 30 and 90
    $b = rand(2, ($a / 5) - 2) * 5; // Multiples of 5 between 10 and (A - 10)
    $ans = $a - $b;
}

// Store answer and details in session
$_SESSION['grownup_math_a'] = $a;
$_SESSION['grownup_math_b'] = $b;
$_SESSION['grownup_math_op'] = $op;
$_SESSION['grownup_math_ans'] = $ans;
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - Entering Grown Up Area</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Nunito', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #d2f1ff 0%, #e6f7ff 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
        }

        /* Circle back button at the top-left */
        .back-button-container {
            position: absolute;
            top: 30px;
            left: 30px;
            z-index: 10;
        }

        .back-btn-img {
            width: 60px;
            height: 60px;
            cursor: pointer;
            transition: transform 0.2s ease, filter 0.2s ease;
        }

        .back-btn-img:hover {
            transform: scale(1.1);
            filter: brightness(1.05);
        }

        /* Card layout */
        .gate-card {
            background: linear-gradient(135deg, #2d6b9f 0%, #1e4d75 100%);
            width: 100%;
            max-width: 500px;
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 16px 40px rgba(0, 0, 0, 0.2);
            text-align: center;
            border: 2px solid #3d80b8;
            margin-bottom: 25px;
        }

        .title-text {
            color: #1a1a2e;
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 25px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        /* Large white input block */
        .input-block-container {
            background: #ffffff;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: inset 0 4px 10px rgba(0, 0, 0, 0.08);
        }

        .answer-input {
            width: 100%;
            border: none;
            outline: none;
            text-align: center;
            font-size: 3rem;
            font-weight: 800;
            color: #1e4d75;
            font-family: inherit;
        }

        /* Remove default spin buttons for input number */
        .answer-input::-webkit-outer-spin-button,
        .answer-input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        .answer-input[type=number] {
            -moz-appearance: textfield;
        }

        /* Question label */
        .question-label {
            color: #ffffff;
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        /* Action button */
        .submit-btn {
            width: 100%;
            background: #fcf0d4;
            border: none;
            outline: none;
            border-radius: 12px;
            color: #3d80b8;
            font-size: 1.2rem;
            font-weight: 800;
            padding: 16px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.4);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        /* Language Toggle links */
        .lang-selector {
            font-size: 1.1rem;
            color: #1e4d75;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .lang-link {
            cursor: pointer;
            text-decoration: none;
            color: #2d6b9f;
            transition: color 0.2s ease;
            padding: 0 5px;
        }

        .lang-link.active {
            color: #1e4d75;
            text-decoration: underline;
            font-weight: 800;
        }

        .lang-link:hover {
            color: #102e48;
        }

        /* Error message container */
        .error-msg {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 1rem;
            border: 1px solid #f5c6cb;
            display: none;
            animation: shake 0.4s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-6px); }
            75% { transform: translateX(6px); }
        }

        
    </style>
</head>
<body>

    <!-- Back Button at the top-left -->
    <div class="back-button-container">
        <a href="child-dashboard.php" id="back-link">
            <img src="assets/images/back_button.png" alt="Go Back" class="back-btn-img" id="back-btn-img">
        </a>
    </div>

    <!-- Page Title -->
    <h1 class="title-text" id="gate-title">Entering Grown Up Area</h1>

    <div class="gate-card">
        <!-- Error Message block -->
        <div class="error-msg" id="error-message"></div>

        <form action="grownup-gate.php" method="POST" id="gate-form">
            <!-- Large white input block -->
            <div class="input-block-container">
                <input type="number" 
                       name="answer" 
                       id="answer-input" 
                       class="answer-input" 
                       required 
                       pattern="-?\d*" 
                       inputmode="numeric" 
                       placeholder="" 
                       autofocus>
            </div>

            <!-- Mathematical question prompt -->
            <div class="question-label" id="question-label">
                <!-- Generated by JS translation -->
            </div>

            <!-- Submit Button -->
            <button type="submit" class="submit-btn" id="submit-btn">Continue</button>
        </form>
    </div>

    <!-- Language Selector English | Nepali -->
    <div class="lang-selector">
        <span class="lang-link" id="lang-en" onclick="changeLanguage('en')">English</span>
        |
        <span class="lang-link" id="lang-ne" onclick="changeLanguage('ne')">नेपाली</span>
    </div>


    <script>
        // Question variables injected from PHP
        const numA = <?php echo $a; ?>;
        const numB = <?php echo $b; ?>;
        const opType = "<?php echo $op; ?>";
        const hasError = <?php echo $has_error ? 'true' : 'false'; ?>;

        // Translation dictionary
        const translations = {
            en: {
                title: "Entering Grown Up Area",
                sumQuestion: "Please enter the sum of <strong>{A}</strong> and <strong>{B}</strong>.",
                diffQuestion: "Please subtract <strong>{B}</strong> from <strong>{A}</strong>.",
                button: "Continue to Parent Dashboard",
                error: "Incorrect answer. Please try again!",
                placeholder: "Enter answer",
                backTitle: "Go Back"
            },
            ne: {
                title: "अभिभावक क्षेत्रमा प्रवेश गर्दै",
                sumQuestion: "कृपया <strong>{A}</strong> र <strong>{B}</strong> को जोड् लेख्नुहोस्।",
                diffQuestion: "कृपया <strong>{A}</strong> बाट <strong>{B}</strong> घटाउँदा कति हुन्छ लेख्नुहोस्।",
                button: "कन्टिन्यु",
                error: "गलत उत्तर। कृपया पुनः प्रयास गर्नुहोस्!",
                placeholder: "उत्तर लेख्नुहोस्",
                backTitle: "फिर्ता जानुहोस्"
}
        };

        // Convert standard digits to Nepali digits
        function toNepaliDigits(num) {
            const nepDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
            return num.toString().split('').map(digit => nepDigits[digit] || digit).join('');
        }

        // Apply selected language
        function changeLanguage(lang) {
            // Save selection to local storage
            localStorage.setItem('gyansetu_lang', lang);

            // Update active states in UI links
            document.getElementById('lang-en').classList.toggle('active', lang === 'en');
            document.getElementById('lang-ne').classList.toggle('active', lang === 'ne');

            // Translate static elements
            document.getElementById('gate-title').textContent = translations[lang].title;
            document.getElementById('submit-btn').textContent = translations[lang].button;
            document.getElementById('answer-input').placeholder = translations[lang].placeholder;
            document.getElementById('back-btn-img').title = translations[lang].backTitle;
            

            // Render math question
            let formattedA = (lang === 'ne') ? toNepaliDigits(numA) : numA;
            let formattedB = (lang === 'ne') ? toNepaliDigits(numB) : numB;

            let questionTemplate = (opType === 'add') ? translations[lang].sumQuestion : translations[lang].diffQuestion;
            let questionText = questionTemplate.replace('{A}', formattedA).replace('{B}', formattedB);
            document.getElementById('question-label').innerHTML = questionText;

            // Render error if present
            const errorContainer = document.getElementById('error-message');
            if (hasError) {
                errorContainer.textContent = translations[lang].error;
                errorContainer.style.display = 'block';
            } else {
                errorContainer.style.display = 'none';
            }
        }

        // Initialize language from localStorage or default 'en'
        document.addEventListener('DOMContentLoaded', () => {
            const savedLang = localStorage.getItem('gyansetu_lang') || 'en';
            changeLanguage(savedLang);

            // Ensure answer input only takes integer values
            const input = document.getElementById('answer-input');
            input.addEventListener('keydown', (e) => {
                // Allow backspace, delete, tab, escape, enter, minus sign, arrows
                const allowedKeys = ['Backspace', 'Delete', 'Tab', 'Escape', 'Enter', '-', 'ArrowLeft', 'ArrowRight'];
                if (allowedKeys.includes(e.key)) {
                    return;
                }
                // Allow digits
                if (/\d/.test(e.key)) {
                    return;
                }
                // Block everything else
                e.preventDefault();
            });

            // Prevent decimal paste
            input.addEventListener('paste', (e) => {
                const pasteData = (e.clipboardData || window.clipboardData).getData('text');
                if (!/^-?\d+$/.test(pasteData)) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>
