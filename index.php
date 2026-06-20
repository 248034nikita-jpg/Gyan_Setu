<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gyan Setu - Sign In / Sign Up</title>
    <!-- Link Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Link to Stylesheet -->
    <link rel="stylesheet" href="style.css">
    <style>
        /* Modern Error/Alert Styling */
        .alert {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px 15px;
            border-radius: 6px;
            margin: 15px auto;
            width: 90%;
            max-width: 400px;
            font-size: 14px;
            border: 1px solid #f5c6cb;
            text-align: center;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        /* Page container centering adjustments */
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .container {
            margin: 20px auto;
        }
        .form-title {
            text-align: center;
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 20px;
        }
        .back-home {
            margin-top: 15px;
            font-size: 14px;
            text-align: center;
        }
        .back-home a {
            color: #7b7beb;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        .back-home a:hover {
            color: #5555d9;
        }
    </style>
</head>
<body>

    <!-- Display Error Messages Beautifully -->
    <?php if (isset($_GET['error'])): ?>
        <div class="alert">
            <i class="fas fa-exclamation-circle"></i>
            <span>
                <?php
                $err = $_GET['error'];
                if ($err === 'email_exists') {
                    echo "Email is already registered. Please sign in.";
                } elseif ($err === 'invalid_credentials') {
                    echo "Invalid email/username or password.";
                } elseif ($err === 'empty_fields') {
                    echo "Please fill in all the required fields.";
                } elseif ($err === 'registration_failed') {
                    echo "Registration failed. Please try again.";
                } else {
                    echo "An unexpected error occurred. Please try again.";
                }
                ?>
            </span>
        </div>
    <?php endif; ?>

    <!-- SIGN UP CONTAINER -->
    <div class="container" id="signup" style="display: none;">
        <h1 class="form-title">Create Account</h1>
        <form action="register.php" method="post">
           <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="fname" id="fname" placeholder="First Name" required>
                <label for="fname">First Name</label>
           </div>
           <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" name="lname" id="lname" placeholder="Last Name" required>
                <label for="lname">Last Name</label>
           </div>
           <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" id="email_up" placeholder="Email" required>
                <label for="email_up">Email</label>
           </div>
           <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" id="password_up" placeholder="Password" required>
                <label for="password_up">Password</label>
            </div>
            <input type="submit" class="btn" value="Sign Up" name="signUp">
        </form>
        <p class="or">------- or -------</p>
        <div class="icons">
            <i class="fab fa-google"></i>
            <i class="fab fa-facebook"></i>
        </div>
        <div class="links">
            <p>Already have an account?</p>
            <button class="btn-toggle" id="signInButton">Sign In</button>
        </div>
    </div>    

    <!-- SIGN IN CONTAINER -->
    <div class="container" id="signIn">
        <h1 class="form-title">Welcome Back</h1>
        <form action="register.php" method="post">
           <div class="input-group">
                <i class="fas fa-user-circle"></i>
                <input type="text" name="email_or_username" id="email_or_username" placeholder="Email or Username" required>
                <label for="email_or_username">Email or Username</label>
           </div>
           <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" id="password_in" placeholder="Password" required>
                <label for="password_in">Password</label>
            </div>
            <a href="#" class="forgot" style="display: block; text-align: right; margin-bottom: 15px; color: #7b7beb; text-decoration: none; font-size: 13px;">Forgot Password?</a>
            <input type="submit" class="btn" value="Sign In" name="signIn">
        </form>
        <p class="or">------- or -------</p>
        <div class="icons">
            <i class="fab fa-google"></i>
            <i class="fab fa-facebook"></i>
        </div>
        <div class="links">
            <p>Don't have an account?</p>
            <button class="btn-toggle" id="signUpButton">Sign Up</button>
        </div>
    </div>

    <div class="back-home">
        <a href="index.html"><i class="fas fa-arrow-left"></i> Back to Homepage</a>
    </div>

    <!-- Toggle Script -->
    <script>
        const signUpButton = document.getElementById('signUpButton');
        const signInButton = document.getElementById('signInButton');
        const signInForm = document.getElementById('signIn');
        const signUpForm = document.getElementById('signup');

        function showSignUp() {
            signInForm.style.display = "none";
            signUpForm.style.display = "block";
        }

        function showSignIn() {
            signInForm.style.display = "block";
            signUpForm.style.display = "none";
        }

        signUpButton.addEventListener('click', function(e) {
            e.preventDefault();
            showSignUp();
            window.location.hash = 'signup';
        });
        
        signInButton.addEventListener('click', function(e) {
            e.preventDefault();
            showSignIn();
            window.location.hash = 'signIn';
        });

        // Parse hash on initial load
        if (window.location.hash === '#signup' || window.location.hash === '#signUp') {
            showSignUp();
        } else {
            showSignIn();
        }
    </script>
</body>
</html>