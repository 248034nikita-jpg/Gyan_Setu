<?php
session_start();
include 'database/includes/db_connect.php';

// ─── Handle Sign-Up POST (AJAX) ───────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['signUp'])) {

    function sendJson($status, $message, $redirect = null) {
        header('Content-Type: application/json');
        echo json_encode(['status' => $status, 'message' => $message, 'redirect' => $redirect]);
        exit();
    }

    $fname    = trim($_POST['fname']    ?? '');
    $lname    = trim($_POST['lname']    ?? '');
    $email    = trim($_POST['email']    ?? '');
    $password = $_POST['password']      ?? '';

    if (empty($fname) || empty($lname) || empty($email) || empty($password)) {
        sendJson('error', 'Please fill in all the required fields.');
    }

    if (!filter_var($email, FILTER_VALIDATE_EMAIL) ||
        !preg_match('/^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/', $email)) {
        sendJson('error', 'Please enter a valid email address.');
    }

    if (strlen($password) < 6) {
        sendJson('error', 'Password must be at least 6 characters.');
    }

    $fullname = trim($fname . ' ' . $lname);

    // Check duplicate email
    $stmt = $conn->prepare("SELECT parent_id FROM parents WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();
    if ($stmt->num_rows > 0) {
        $stmt->close();
        sendJson('error', 'Email is already registered. Please sign in.');
    }
    $stmt->close();

    // Insert parent
    $password_hash = password_hash($password, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("INSERT INTO parents (first_name, last_name, email, password_hash) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $fname, $lname, $email, $password_hash);

    if ($stmt->execute()) {
        $_SESSION['role']    = 'parent';
        $_SESSION['user_id'] = $stmt->insert_id;
        $_SESSION['name']    = $fullname;
        $_SESSION['email']   = $email;
        $stmt->close();
        // After signup → child profile setup
        sendJson('success', 'Account created successfully!', 'child_profilesetuppage.php');
        //status: "success", message: "Account created successfully!", redirect: "child_profilesetuppage.php"
    } else {
        $stmt->close();
        sendJson('error', 'Registration failed. Please try again.');
        //status: "error", message: "Registration failed. Please try again."
    }
}

// ─── Redirect already-logged-in users 
if (isset($_SESSION['role'])) {
    header('Location: child-dashboard.php');
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Gyan Setu – Sign Up</title>
  <meta name="description" content="Create a free Gyan Setu parent account to set up your child's personalised learning space."/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Nunito', sans-serif;
      min-height: 100vh;
      background: #6b7fc4;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
      padding: 30px 16px;
    }

    .lily { position: absolute; pointer-events: none; }
    .lily-tl { left: -30px; top: 80px;  width: 200px; }
    .lily-br { right: -20px; bottom: 50px; width: 200px; }

    .card-wrap {
      background: #fff;
      border-radius: 20px;
      padding: 38px 40px 32px;
      width: 100%;
      max-width: 460px;
      box-shadow: 0 8px 40px rgba(0,0,0,.18);
      position: relative;
      z-index: 10;
    }

    .card-title    { font-size: 1.4rem; font-weight: 800; color: #1a1a2e; text-align: center; margin-bottom: 4px; }
    .card-subtitle { text-align: center; font-size: .85rem; color: #888; margin-bottom: 22px; }

    .role-tabs { display: flex; border: 1.5px solid #d0d5e8; border-radius: 30px; overflow: hidden; margin-bottom: 24px; }
    .role-tabs button {
      flex: 1; border: none; background: transparent;
      padding: 9px 0; font-family: 'Nunito', sans-serif;
      font-weight: 700; font-size: .9rem; color: #666;
      cursor: pointer; transition: background .2s, color .2s;
    }
    .role-tabs button.active { background: #1abcbf; color: #fff; border-radius: 28px; }

    .field-label { font-size: .72rem; font-weight: 700; letter-spacing: .06em; color: #888; margin-bottom: 5px; }
    .input-wrap {
      display: flex; align-items: center;
      border: 1.5px solid #d6daf0; border-radius: 10px;
      padding: 0 14px; margin-bottom: 16px;
      background: #f9faff; transition: border-color .2s;
    }
    .input-wrap:focus-within { border-color: #1abcbf; background: #fff; }
    .input-wrap .icon { font-size: 1rem; color: #aab; margin-right: 10px; flex-shrink: 0; }
    .input-wrap input {
      border: none; background: transparent; width: 100%;
      padding: 12px 0; font-family: 'Nunito', sans-serif;
      font-size: .95rem; color: #333; outline: none;
    }
    .input-wrap input::placeholder { color: #bbb; }
    .eye-btn { background: none; border: none; cursor: pointer; color: #aab; font-size: .95rem; }

    /* Password strength */
    .pwd-strength { margin-top: -10px; margin-bottom: 14px; }
    .pwd-strength-bar   { height: 4px; border-radius: 2px; background: #eee; overflow: hidden; margin-bottom: 4px; }
    .pwd-strength-fill  { height: 100%; width: 0; border-radius: 2px; transition: width .3s, background .3s; }
    .pwd-strength-label { font-size: .72rem; color: #aaa; }

    .btn-primary-gs {
      display: block; width: 100%; background: #1abcbf;
      color: #fff; border: none; border-radius: 10px; padding: 13px;
      font-family: 'Nunito', sans-serif; font-weight: 800;
      font-size: 1rem; letter-spacing: .05em; cursor: pointer;
      transition: background .2s, transform .1s; margin-bottom: 20px;
    }
    .btn-primary-gs:hover  { background: #14a5a8; transform: translateY(-1px); }
    .btn-primary-gs:active { transform: translateY(0); }

    .divider { display: flex; align-items: center; gap: 12px; color: #bbb; font-size: .82rem; margin-bottom: 16px; }
    .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: #e0e4f0; }

    .social-row { display: flex; gap: 12px; margin-bottom: 22px; }
    .btn-social {
      flex: 1; display: flex; align-items: center; justify-content: center;
      gap: 8px; border: 1.5px solid #d6daf0; border-radius: 10px;
      padding: 10px 0; background: #fff; font-family: 'Nunito', sans-serif;
      font-weight: 700; font-size: .88rem; color: #333;
      cursor: pointer; transition: border-color .2s, background .2s;
    }
    .btn-social:hover { border-color: #aab; background: #f5f6ff; }

    .card-footer-text { text-align: center; font-size: .85rem; color: #777; }
    .card-footer-text a { color: #1abcbf; font-weight: 700; text-decoration: none; }

    .error-msg {
      background: #fff0f0; border: 1px solid #fca5a5;
      border-radius: 8px; padding: 8px 12px;
      font-size: .83rem; color: #dc2626; margin-bottom: 12px; display: none;
    }
    .success-msg {
      background: #f0fff4; border: 1px solid #86efac;
      border-radius: 8px; padding: 8px 12px;
      font-size: .83rem; color: #16a34a; margin-bottom: 12px; display: none;
    }
  </style>
</head>
<body>

  <div class="lily lily-tl">
    <svg viewBox="0 0 200 160" xmlns="http://www.w3.org/2000/svg">
      <ellipse cx="70" cy="110" rx="70" ry="40" fill="#3a9c4e" opacity=".85"/>
      <ellipse cx="130" cy="125" rx="55" ry="28" fill="#2d7d3e" opacity=".7"/>
      <circle cx="80" cy="75" r="14" fill="#f78fb3"/>
      <circle cx="80" cy="75" r="6"  fill="#ffe4b5"/>
      <circle cx="140" cy="95" r="10" fill="#f78fb3" opacity=".8"/>
      <circle cx="140" cy="95" r="4"  fill="#ffe4b5"/>
    </svg>
  </div>
  <div class="lily lily-br">
    <svg viewBox="0 0 200 160" xmlns="http://www.w3.org/2000/svg">
      <ellipse cx="120" cy="90" rx="70" ry="38" fill="#3a9c4e" opacity=".85"/>
      <ellipse cx="60"  cy="110" rx="52" ry="26" fill="#2d7d3e" opacity=".7"/>
      <circle cx="115" cy="55" r="13" fill="#f78fb3"/>
      <circle cx="115" cy="55" r="5"  fill="#ffe4b5"/>
    </svg>
  </div>

  <div class="card-wrap">
    <h1 class="card-title">Sign up for Gyan Setu</h1>
    <p class="card-subtitle">Create an account to start earning and learning!</p>

    <div class="role-tabs">
      <button onclick="setRole('student')" id="tab-student">Student</button>
      <button onclick="setRole('teacher')" id="tab-teacher">Teacher</button>
      <button onclick="setRole('home')"    id="tab-home"    class="active">Home</button>
    </div>

    <div class="error-msg"   id="signupError"></div>
    <div class="success-msg" id="signupSuccess"></div>

    <div class="row">
      <div class="col-md-6">
        <p class="field-label" id="fnameLabel">PARENT'S FIRST NAME</p>
        <div class="input-wrap">
          <span class="icon">👤</span>
          <input type="text" id="signupFname" placeholder="First name" autocomplete="given-name"/>
        </div>
      </div>
      <div class="col-md-6">
        <p class="field-label" id="lnameLabel">PARENT'S LAST NAME</p>
        <div class="input-wrap">
          <span class="icon">👤</span>
          <input type="text" id="signupLname" placeholder="Last name" autocomplete="family-name"/>
        </div>
      </div>
    </div>

    <p class="field-label">EMAIL ADDRESS</p>
    <div class="input-wrap">
      <span class="icon">✉️</span>
      <input type="email" id="signupEmail" placeholder="Enter email address" autocomplete="email"/>
    </div>

    <p class="field-label">PASSWORD</p>
    <div class="input-wrap">
      <span class="icon">🔒</span>
      <input type="password" id="signupPassword" placeholder="Enter your password"
             oninput="checkStrength(this.value)" autocomplete="new-password"/>
      <button class="eye-btn" onclick="togglePwd('signupPassword', this)" type="button">👁</button>
    </div>
    <div class="pwd-strength">
      <div class="pwd-strength-bar"><div class="pwd-strength-fill" id="pwdBar"></div></div>
      <span class="pwd-strength-label" id="pwdLabel"></span>
    </div>

    <button class="btn-primary-gs" id="signupBtn" onclick="handleSignup()">CREATE ACCOUNT AS PARENT</button>

    <div class="divider">OR CONTINUE WITH</div>

    <div class="social-row">
      <button class="btn-social">
        <svg width="18" height="18" viewBox="0 0 15 15"><path fill="#1877F2" d="M15 8a7 7 0 00-7-7 7 7 0 00-1.094 13.915v-4.892H5.13V8h1.777V6.458c0-1.754 1.045-2.724 2.644-2.724.766 0 1.567.137 1.567.137v1.723h-.883c-.87 0-1.14.54-1.14 1.093V8h1.941l-.31 2.023H9.094v4.892A7.001 7.001 0 0015 8z"/><path fill="#ffffff" d="M10.725 10.023L11.035 8H9.094V6.687c0-.553.27-1.093 1.14-1.093h.883V3.87s-.801-.137-1.567-.137c-1.6 0-2.644.97-2.644 2.724V8H5.13v2.023h1.777v4.892a7.037 7.037 0 002.188 0v-4.892h1.63z"/></svg>
        Sign Up with Facebook
      </button>
      <button class="btn-social">
        <svg width="18" height="18" viewBox="0 0 186.69 190.5"><g transform="translate(1184.583 765.171)"><path d="M-1089.333-687.239v36.888h51.262c-2.251 11.863-9.006 21.908-19.137 28.662l30.913 23.986c18.011-16.625 28.402-41.044 28.402-70.052 0-6.754-.606-13.249-1.732-19.483z" fill="#4285f4"/><path d="M-1142.714-651.791l-6.972 5.337-24.679 19.223c15.673 31.086 47.796 52.561 85.03 52.561 25.717 0 47.278-8.486 63.038-23.033l-30.913-23.986c-8.486 5.715-19.31 9.179-32.125 9.179-24.765 0-45.806-16.712-53.379-39.281z" fill="#34a853"/><path d="M-1174.365-712.61c-6.494 12.815-10.217 27.276-10.217 42.689s3.723 29.874 10.217 42.689c0 .086 31.693-24.592 31.693-24.592-1.905-5.715-3.031-11.776-3.031-18.098s1.126-12.383 3.031-18.098z" fill="#fbbc05"/><path d="M-1089.333-727.244c14.028 0 26.497 4.849 36.455 14.201l27.276-27.276c-16.539-15.413-38.013-24.852-63.731-24.852-37.234 0-69.359 21.388-85.032 52.561l31.692 24.592c7.574-22.569 28.615-39.226 53.34-39.226z" fill="#ea4335"/></g></svg>
        Sign Up with Google
      </button>
    </div>

    <p class="card-footer-text">Already have an account? <a href="login.php">Sign in</a></p>
    <p class="card-footer-text" style="margin-top:15px;"><a href="index.html">← Back to Home</a></p>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    let currentRole = 'home';

    const roleLabels = {
      student: { fname: "STUDENT'S FIRST NAME", lname: "STUDENT'S LAST NAME", btn: 'CREATE ACCOUNT AS STUDENT' },
      teacher: { fname: "TEACHER'S FIRST NAME", lname: "TEACHER'S LAST NAME", btn: 'CREATE ACCOUNT AS TEACHER' },
      home:    { fname: "PARENT'S FIRST NAME",  lname: "PARENT'S LAST NAME",  btn: 'CREATE ACCOUNT AS PARENT'  }
    };

    function setRole(role) {
      currentRole = role;
      document.querySelectorAll('.role-tabs button').forEach(b => b.classList.remove('active'));
      document.getElementById('tab-' + role).classList.add('active');
      document.getElementById('fnameLabel').textContent = roleLabels[role].fname;
      document.getElementById('lnameLabel').textContent = roleLabels[role].lname;
      document.getElementById('signupBtn').textContent = roleLabels[role].btn;
    }

    function togglePwd(id, btn) {
      const inp = document.getElementById(id);
      inp.type        = inp.type === 'password' ? 'text' : 'password';
      btn.textContent = inp.type === 'password' ? '👁' : '🙈';
    }

    function checkStrength(val) {
      const bar   = document.getElementById('pwdBar');
      const label = document.getElementById('pwdLabel');
      let score = 0;
      if (val.length >= 8)           score++;
      if (/[A-Z]/.test(val))         score++;
      if (/[0-9]/.test(val))         score++;
      if (/[^A-Za-z0-9]/.test(val)) score++;
      const configs = [
        { width: '0%',   color: '#eee',    text: '' },
        { width: '25%',  color: '#ef4444', text: 'Weak' },
        { width: '50%',  color: '#f97316', text: 'Fair' },
        { width: '75%',  color: '#eab308', text: 'Good' },
        { width: '100%', color: '#22c55e', text: 'Strong' },
      ];
      const c = configs[score];
      bar.style.width      = c.width;
      bar.style.background = c.color;
      label.textContent    = c.text;
      label.style.color    = c.color;
    }

    function showError(msg) {
      const el = document.getElementById('signupError');
      el.textContent   = msg; el.style.display = 'block';
      document.getElementById('signupSuccess').style.display = 'none';
    }
    function showSuccess(msg) {
      const el = document.getElementById('signupSuccess');
      el.textContent   = msg; el.style.display = 'block';
      document.getElementById('signupError').style.display = 'none';
    }

    function handleSignup() {
      const fname    = document.getElementById('signupFname').value.trim();
      const lname    = document.getElementById('signupLname').value.trim();
      const email    = document.getElementById('signupEmail').value.trim();
      const password = document.getElementById('signupPassword').value;

      document.getElementById('signupError').style.display   = 'none';
      document.getElementById('signupSuccess').style.display = 'none';

      if (currentRole === 'student') {
        showError('Student accounts are created by a parent from the Parent Dashboard.');
        return;
      }
      if (currentRole === 'teacher') {
        showError('Teacher registration is not supported yet.');
        return;
      }

      if (!fname)    { showError('Please enter your first name.'); return; }
      if (!lname)    { showError('Please enter your last name.'); return; }
      if (!email)    { showError('Please enter your email address.'); return; }
      if (!password) { showError('Please enter a password.'); return; }
      if (password.length < 6) { showError('Password must be at least 6 characters.'); return; }

      const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRe.test(email)) { showError('Please enter a valid email address.'); return; }

      const btn = document.getElementById('signupBtn');
      btn.disabled    = true;
      btn.textContent = 'Creating account…';

      const formData = new URLSearchParams();
      formData.append('signUp', '1');
      formData.append('fname',  fname);
      formData.append('lname',  lname);
      formData.append('email',  email);
      formData.append('password', password);
      formData.append('ajax',   '1');

      fetch('signup.php', {
        method:  'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body:    formData.toString()
      })
      .then(r => r.json())
      .then(data => {
        if (data.status === 'success') {
          showSuccess('🎉 ' + data.message + ' Redirecting…');
          setTimeout(() => { window.location.href = data.redirect; }, 1200);
        } else {
          showError(data.message);
          btn.disabled    = false;
          btn.textContent = roleLabels[currentRole].btn;
        }
      })
      .catch(() => {
        showError('An unexpected error occurred. Please try again.');
        btn.disabled    = false;
        btn.textContent = roleLabels[currentRole].btn;
      });
    }
  </script>
</body>
</html>
