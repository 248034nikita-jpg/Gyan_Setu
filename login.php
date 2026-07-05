<?php
session_start();
include 'database/includes/db_connect.php';

// ─── Handle Sign-In POST (AJAX or standard form) ────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['signIn'])) {

    $is_ajax = isset($_POST['ajax']) ||
               (isset($_SERVER['HTTP_X_REQUESTED_WITH']) &&
                strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest');

    function sendJson($status, $message, $redirect = null) {
        header('Content-Type: application/json');
        echo json_encode(['status' => $status, 'message' => $message, 'redirect' => $redirect]);
        exit();
    }

    $identifier = isset($_POST['email_or_username']) ? trim($_POST['email_or_username']) : '';
    $password   = $_POST['password'] ?? '';

    if (empty($identifier) || empty($password)) {
        sendJson('error', 'Please fill in all required fields.');
    }

    // ── Admin login check (email or username) ───────────────────────────────
    /*$stmt = $conn->prepare("SELECT admin_id, username, email, password_hash FROM admins WHERE email = ? OR username = ?");
    if ($stmt) {
        $stmt->bind_param("ss", $identifier, $identifier);
        $stmt->execute();
        $adminRow = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        if ($adminRow && password_verify($password, $adminRow['password_hash'])) {
            session_regenerate_id(true); // Prevent session fixation
            $_SESSION['role']           = 'admin';
            $_SESSION['admin_id']       = $adminRow['admin_id'];
            $_SESSION['admin_username']  = $adminRow['username'];
            sendJson('success', 'Logged in as Admin successfully!', 'admin.php');
        }
    }*/

    // ── Parent login (contains @) ──────────────────────────────────────────
    if (strpos($identifier, '@') !== false) {
        $stmt = $conn->prepare(
            "SELECT parent_id, full_name, email, password_hash FROM parents WHERE email = ?"
        );
        $stmt->bind_param("s", $identifier);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        if ($row && password_verify($password, $row['password_hash'])) {
            $_SESSION['role']    = 'parent';
            $_SESSION['user_id'] = $row['parent_id'];
            $_SESSION['name']    = $row['full_name'];
            $_SESSION['email']   = $row['email'];
            sendJson('success', 'Logged in successfully!', 'child-dashboard.php');
        }

    } else {
        // ── Child login (username, no @) ───────────────────────────────────
        $stmt = $conn->prepare(
            "SELECT child_id, username,  parent_id FROM children WHERE username = ?"
        );
        $stmt->bind_param("s", $identifier);
        $stmt->execute();
        $row = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        if ($row && password_verify($password, $row['password_hash'])) {
            $_SESSION['role']      = 'child';
            $_SESSION['user_id']   = $row['child_id'];
            $_SESSION['username']  = $row['username'];
            $_SESSION['parent_id'] = $row['parent_id'];
            sendJson('success', 'Logged in successfully!', 'child-dashboard.php');
        }
    }

    // If we reach here, credentials were invalid
    sendJson('error', 'Invalid email/username or password.');
}

// ─── Redirect already-logged-in users ────────────────────────────────────────
if (isset($_SESSION['role'])) {
    if ($_SESSION['role'] === 'admin') {
        header('Location: admin.php');
    } else {
        header('Location: child-dashboard.php');
    }
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Gyan Setu – Sign In</title>
  <meta name="description" content="Sign in to your Gyan Setu account as a parent or student to access the learning dashboard."/>
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
    }

    /* ── Lily pad decorations ── */
    .lily { position: absolute; pointer-events: none; }
    .lily-tl { left: -30px; top: 100px; width: 200px; }
    .lily-br { right: -20px; bottom: 60px; width: 200px; }

    /* ── Card ── */
    .card-wrap {
      background: #ffffff;
      border-radius: 20px;
      padding: 38px 40px 32px;
      width: 100%;
      max-width: 460px;
      box-shadow: 0 8px 40px rgba(0,0,0,.18);
      position: relative;
      z-index: 10;
    }

    .card-title {
      font-size: 1.4rem;
      font-weight: 800;
      color: #1a1a2e;
      text-align: center;
      margin-bottom: 22px;
    }

    /* ── Role Tabs ── */
    .role-tabs {
      display: flex;
      border: 1.5px solid #d0d5e8;
      border-radius: 30px;
      overflow: hidden;
      margin-bottom: 24px;
    }
    .role-tabs button {
      flex: 1; border: none; background: transparent;
      padding: 9px 0; font-family: 'Nunito', sans-serif;
      font-weight: 700; font-size: .9rem; color: #666;
      cursor: pointer; transition: background .2s, color .2s;
    }
    .role-tabs button.active {
      background: #1abcbf; color: #fff; border-radius: 28px;
    }

    /* ── Form Fields ── */
    .field-label {
      font-size: .72rem; font-weight: 700;
      letter-spacing: .06em; color: #888; margin-bottom: 5px;
    }
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
    .eye-btn {
      background: none; border: none; cursor: pointer;
      color: #aab; font-size: .95rem; flex-shrink: 0;
    }

    /* ── Primary Button ── */
    .btn-primary-gs {
      display: block; width: 100%;
      background: #1abcbf; color: #fff;
      border: none; border-radius: 10px; padding: 13px;
      font-family: 'Nunito', sans-serif; font-weight: 800;
      font-size: 1rem; letter-spacing: .05em;
      cursor: pointer; transition: background .2s, transform .1s;
      margin-bottom: 20px;
    }
    .btn-primary-gs:hover { background: #14a5a8; transform: translateY(-1px); }
    .btn-primary-gs:active { transform: translateY(0); }

    /* ── Divider ── */
    .divider {
      display: flex; align-items: center;
      gap: 12px; color: #bbb; font-size: .82rem; margin-bottom: 16px;
    }
    .divider::before, .divider::after {
      content: ''; flex: 1; height: 1px; background: #e0e4f0;
    }

    /* ── Social Buttons ── */
    .social-row { display: flex; gap: 12px; margin-bottom: 22px; }
    .btn-social {
      flex: 1; display: flex; align-items: center; justify-content: center;
      gap: 8px; border: 1.5px solid #d6daf0; border-radius: 10px;
      padding: 10px 0; background: #fff; font-family: 'Nunito', sans-serif;
      font-weight: 700; font-size: .88rem; color: #333;
      cursor: pointer; transition: border-color .2s, background .2s;
    }
    .btn-social:hover { border-color: #aab; background: #f5f6ff; }

    /* ── Footer text ── */
    .card-footer-text { text-align: center; font-size: .85rem; color: #777; }
    .card-footer-text a { color: #1abcbf; font-weight: 700; text-decoration: none; }
    .card-footer-text a:hover { text-decoration: underline; }
    .terms-row { text-align: center; font-size: .75rem; color: #aaa; margin-top: 10px; }
    .terms-row a { color: #aaa; text-decoration: none; }
    .terms-row a:hover { color: #1abcbf; }

    /* ── Error / success messages ── */
    .error-msg {
      background: #fff0f0; border: 1px solid #fca5a5;
      border-radius: 8px; padding: 8px 12px;
      font-size: .83rem; color: #dc2626;
      margin-bottom: 12px; display: none;
    }
  </style>
</head>
<body>

  <!-- Lily pad TL -->
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

  <!-- Lily pad BR -->
  <div class="lily lily-br">
    <svg viewBox="0 0 200 160" xmlns="http://www.w3.org/2000/svg">
      <ellipse cx="120" cy="90" rx="70" ry="38" fill="#3a9c4e" opacity=".85"/>
      <ellipse cx="60"  cy="110" rx="52" ry="26" fill="#2d7d3e" opacity=".7"/>
      <circle cx="115" cy="55" r="13" fill="#f78fb3"/>
      <circle cx="115" cy="55" r="5"  fill="#ffe4b5"/>
    </svg>
  </div>

  <!-- Card -->
  <div class="card-wrap">
    <h1 class="card-title">Sign in to Gyan Setu</h1>

    <!-- Role Tabs -->
    <div class="role-tabs" id="roleTabs">
      <button onclick="setRole('student')" id="tab-student">Student</button>
      <button onclick="setRole('teacher')" id="tab-teacher">Teacher</button>
      <button onclick="setRole('home')"    id="tab-home"    class="active">Home</button>
    </div>

    <!-- Error -->
    <div class="error-msg" id="loginError"></div>

    <!-- Email / Username -->
    <p class="field-label" id="loginLabel">EMAIL ADDRESS</p>
    <div class="input-wrap">
      <span class="icon" id="loginIcon">✉️</span>
      <input type="email" id="loginEmail" placeholder="Enter email address" autocomplete="email"/>
    </div>

    <!-- Password -->
    <p class="field-label">PASSWORD</p>
    <div class="input-wrap">
      <span class="icon">🔒</span>
      <input type="password" id="loginPassword" placeholder="Enter your password" autocomplete="current-password"/>
      <button class="eye-btn" onclick="togglePwd('loginPassword', this)" type="button">👁</button>
    </div>

    <!-- Submit -->
    <button class="btn-primary-gs" id="loginBtn" onclick="handleLogin()">LOG IN AS A PARENT</button>

    <!-- Divider -->
    <div class="divider">OR CONTINUE WITH</div>

    <!-- Social -->
    <div class="social-row">
      <button class="btn-social">
  <svg width="18" height="18" viewBox="0 0 24 24">
    <path
      d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073c0 6.019 4.388 11.009 10.125 11.927v-8.437H7.078v-3.49h3.047V9.413c0-3.017 1.792-4.686 4.533-4.686 1.313 0 2.686.235 2.686.235v2.963h-1.514c-1.491 0-1.956.928-1.956 1.88v2.268h3.328l-.532 3.49h-2.796V24C19.612 23.082 24 18.092 24 12.073z"
      fill="#1877F2"
    />
  </svg>
  Sign in with Facebook
</button>
        
      <button class="btn-social">
        <svg width="18" height="18" viewBox="0 0 186.69 190.5"><g transform="translate(1184.583 765.171)"><path d="M-1089.333-687.239v36.888h51.262c-2.251 11.863-9.006 21.908-19.137 28.662l30.913 23.986c18.011-16.625 28.402-41.044 28.402-70.052 0-6.754-.606-13.249-1.732-19.483z" fill="#4285f4"/><path d="M-1142.714-651.791l-6.972 5.337-24.679 19.223c15.673 31.086 47.796 52.561 85.03 52.561 25.717 0 47.278-8.486 63.038-23.033l-30.913-23.986c-8.486 5.715-19.31 9.179-32.125 9.179-24.765 0-45.806-16.712-53.379-39.281z" fill="#34a853"/><path d="M-1174.365-712.61c-6.494 12.815-10.217 27.276-10.217 42.689s3.723 29.874 10.217 42.689c0 .086 31.693-24.592 31.693-24.592-1.905-5.715-3.031-11.776-3.031-18.098s1.126-12.383 3.031-18.098z" fill="#fbbc05"/><path d="M-1089.333-727.244c14.028 0 26.497 4.849 36.455 14.201l27.276-27.276c-16.539-15.413-38.013-24.852-63.731-24.852-37.234 0-69.359 21.388-85.032 52.561l31.692 24.592c7.574-22.569 28.615-39.226 53.34-39.226z" fill="#ea4335"/></g></svg>
        Sign in with Google
      </button>
    </div>

    <p class="card-footer-text">Don't have an account? <a href="signup.php">Sign up</a></p>
    <p class="card-footer-text" style="margin-top:15px;"><a href="index.html">← Back to Home</a></p>
    <p class="terms-row"><a href="#">Terms and Conditions</a> | <a href="#">Policy</a> | <a href="admin-login.php">Educator / Admin Portal</a></p>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    let currentRole = 'home';

    function setRole(role) {
      currentRole = role;
      document.querySelectorAll('.role-tabs button').forEach(b => b.classList.remove('active'));
      document.getElementById('tab-' + role).classList.add('active');

      const labels = {
        student: 'LOG IN AS A STUDENT',
        teacher: 'LOG IN AS A TEACHER',
        home:    'LOG IN AS A PARENT'
      };
      document.getElementById('loginBtn').textContent = labels[role];

      const input = document.getElementById('loginEmail');
      const label = document.getElementById('loginLabel');
      const icon  = document.getElementById('loginIcon');

      if (role === 'student') {
        label.textContent    = 'USERNAME';
        input.placeholder    = 'Enter child username';
        input.type           = 'text';
        icon.textContent     = '👤';
      } else {
        label.textContent    = 'EMAIL ADDRESS';
        input.placeholder    = 'Enter email address';
        input.type           = 'email';
        icon.textContent     = '✉️';
      }
    }

    function togglePwd(id, btn) {
      const inp = document.getElementById(id);
      inp.type       = inp.type === 'password' ? 'text' : 'password';
      btn.textContent = inp.type === 'password' ? '👁' : '🙈';
    }

    function showError(msg) {
      const el = document.getElementById('loginError');
      el.textContent   = msg;
      el.style.display = 'block';
    }

    function handleLogin() {
      const identifier = document.getElementById('loginEmail').value.trim();
      const password   = document.getElementById('loginPassword').value;
      document.getElementById('loginError').style.display = 'none';

      if (!identifier) {
        showError(currentRole === 'student' ? 'Please enter your username.' : 'Please enter your email address.');
        return;
      }
      if (!password) { showError('Please enter your password.'); return; }

      if (currentRole === 'teacher') {
        showError('Teacher authentication is not supported yet.');
        return;
      }

      if (currentRole !== 'student') {
        const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRe.test(identifier)) { showError('Please enter a valid email address.'); return; }
      }

      const btn = document.getElementById('loginBtn');
      btn.disabled    = true;
      btn.textContent = 'Signing in…';

      const formData = new URLSearchParams();
      formData.append('signIn', '1');
      formData.append('email_or_username', identifier);
      formData.append('password', password);
      formData.append('ajax', '1');

      fetch('login.php', {
        method:  'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body:    formData.toString()
      })
      .then(r => r.json())
      .then(data => {
        if (data.status === 'success') {
          window.location.href = data.redirect;
        } else {
          showError(data.message);
          btn.disabled    = false;
          btn.textContent = currentRole === 'student' ? 'LOG IN AS A STUDENT' :
                            currentRole === 'teacher' ? 'LOG IN AS A TEACHER' : 'LOG IN AS A PARENT';
        }
      })
      .catch(() => {
        showError('An unexpected error occurred. Please try again.');
        btn.disabled    = false;
        btn.textContent = 'LOG IN AS A PARENT';
      });
    }
  </script>
</body>
</html>
