<?php
session_start();

// Must be logged in as a parent to set up a child profile
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'parent') {
    header("Location: login.php");
    exit();
}

$parent_name = $_SESSION['name'] ?? 'Parent';
$first_name  = explode(' ', $parent_name)[0];
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Gyan Setu – Create Child Profile</title>
  <meta name="description" content="Set up your child's learning profile on Gyan Setu to unlock age-appropriate educational games and progress tracking."/>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Nunito', sans-serif;
      min-height: 100vh;
      background: linear-gradient(135deg, #6b7fc4 0%, #1abcbf 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow: hidden;
      padding: 30px 16px;
    }

    /* ── Decorative blobs ── */
    .blob {
      position: absolute;
      border-radius: 50%;
      filter: blur(60px);
      opacity: 0.35;
      pointer-events: none;
    }
    .blob-1 { width: 400px; height: 400px; background: #fff; top: -120px; left: -120px; }
    .blob-2 { width: 300px; height: 300px; background: #ffe4b5; bottom: -80px; right: -80px; }
    .blob-3 { width: 200px; height: 200px; background: #f78fb3; top: 50%; right: 60px; }

    /* ── Card ── */
    .card-wrap {
      background: #fff;
      border-radius: 24px;
      padding: 40px 42px 36px;
      width: 100%;
      max-width: 500px;
      box-shadow: 0 16px 60px rgba(0,0,0,0.2);
      position: relative;
      z-index: 10;
      animation: cardIn 0.4s cubic-bezier(0.34,1.4,0.64,1);
    }

    @keyframes cardIn {
      from { opacity: 0; transform: scale(0.92) translateY(24px); }
      to   { opacity: 1; transform: scale(1) translateY(0); }
    }

    /* ── Step badge ── */
    .step-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: linear-gradient(135deg,#1abcbf,#6b7fc4);
      color: #fff;
      font-size: 11px;
      font-weight: 800;
      padding: 4px 12px;
      border-radius: 20px;
      letter-spacing: 0.07em;
      margin-bottom: 16px;
    }

    /* ── logo ── */
    .mascot-wrap { display: flex; justify-content: center; margin-bottom: 14px; }
  
    /* ── Titles ── */
    .card-title    { font-size: 1.45rem; font-weight: 900; color: #1a1a2e; text-align: center; margin-bottom: 5px; }
    .card-subtitle { text-align: center; font-size: .87rem; color: #888; margin-bottom: 28px; line-height: 1.5; }

    /* ── Progress bar ── */
    .progress-track { height: 5px; background: #eef0fb; border-radius: 3px; margin-bottom: 28px; overflow: hidden; }
    .progress-fill  { height: 100%; width: 0; background: linear-gradient(90deg,#1abcbf,#6b7fc4); border-radius: 3px; transition: width 0.5s ease; }

    /* ── Field labels ── */
    .field-label { font-size: .72rem; font-weight: 800; letter-spacing: .07em; color: #999; margin-bottom: 6px; }

    /* ── Input wrap ── */
    .input-wrap {
      display: flex; align-items: center;
      border: 2px solid #e8eaf6; border-radius: 12px;
      padding: 0 14px; margin-bottom: 18px;
      background: #f9faff; transition: border-color .2s, box-shadow .2s;
    }
    .input-wrap:focus-within {
      border-color: #1abcbf; background: #fff;
      box-shadow: 0 0 0 4px rgba(26,188,191,0.12);
    }
    .input-wrap .icon { font-size: 1.1rem; color: #c5c8e6; margin-right: 10px; flex-shrink: 0; }
    .input-wrap input, .input-wrap select {
      border: none; background: transparent; width: 100%;
      padding: 13px 0; font-family: 'Nunito', sans-serif;
      font-size: .95rem; color: #1a1a2e; outline: none; appearance: none;
    }
    .input-wrap input::placeholder { color: #c5c8e6; }

    /* ── Two-column row ── */
    .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

    /* ── Avatar picker ── */
    .avatar-section-label { font-size: .72rem; font-weight: 800; letter-spacing: .07em; color: #999; margin-bottom: 10px; }
    .avatar-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 10px;
      margin-bottom: 20px;
    }
    .avatar-option {
      aspect-ratio: 1;
      border-radius: 14px;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.7rem; cursor: pointer;
      border: 2.5px solid transparent;
      background: #f0f4ff;
      transition: border-color .2s, transform .15s, background .2s;
      position: relative;
    }
    .avatar-option:hover { transform: scale(1.1); background: #e8eeff; }
    .avatar-option.selected {
      border-color: #1abcbf;
      background: linear-gradient(135deg, #e6fafa, #f0f4ff);
      box-shadow: 0 0 0 3px rgba(26,188,191,0.2);
    }
    .avatar-option.selected::after {
      content: '✓';
      position: absolute;
      top: -5px; right: -5px;
      width: 18px; height: 18px;
      background: #1abcbf;
      color: #fff;
      font-size: 10px;
      font-weight: 900;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
    }

    /* ── Selected mascot preview ── */
    .preview-box {
      border: 2px solid #e8eaf6;
      border-radius: 14px;
      padding: 14px 16px;
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 22px;
      background: #f9faff;
      min-height: 68px;
    }
    .preview-circle {
      width: 50px; height: 50px;
      border-radius: 50%;
      background: linear-gradient(135deg,#1abcbf,#6b7fc4);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.6rem;
      border: 2.5px solid #1abcbf;
      flex-shrink: 0;
      transition: all 0.3s;
    }
    .preview-info { flex: 1; }
    .preview-name { font-size: 14px; font-weight: 800; color: #1a1a2e; }
    .preview-hint { font-size: 11.5px; color: #aab; margin-top: 2px; }

    /* ── Submit button ── */
    .btn-launch {
      display: block; width: 100%;
      background: linear-gradient(135deg, #1abcbf, #6b7fc4);
      color: #fff; border: none; border-radius: 14px; padding: 15px;
      font-family: 'Nunito', sans-serif; font-weight: 900;
      font-size: 1.05rem; letter-spacing: .04em; cursor: pointer;
      transition: opacity .2s, transform .15s;
      box-shadow: 0 6px 20px rgba(26,188,191,0.35);
    }
    .btn-launch:hover  { opacity: 0.88; transform: translateY(-2px); }
    .btn-launch:active { transform: translateY(0); }

    /* ── Messages ── */
    .msg {
      border-radius: 10px; padding: 10px 14px;
      font-size: .83rem; font-weight: 700;
      margin-bottom: 14px; display: none;
      animation: fadeIn 0.2s ease;
    }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(-4px); } to { opacity: 1; } }
    .msg.error   { background: #fff0f0; border: 1.5px solid #fca5a5; color: #dc2626; }
    .msg.success { background: #f0fff4; border: 1.5px solid #86efac; color: #16a34a; }

    /* ── Responsive ── */
    @media (max-width: 520px) {
      .card-wrap { padding: 28px 22px 26px; }
      .avatar-grid { grid-template-columns: repeat(4, 1fr); gap: 8px; }
      .two-col { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

  <!-- Decorative blobs -->
  <div class="blob blob-1"></div>
  <div class="blob blob-2"></div>
  <div class="blob blob-3"></div>

  <!-- Card -->
  <div class="card-wrap">


    <!-- Owl mascot -->
    <div class="mascot-wrap">
      <img src = "assets/images/logo.png" alt="Gyan Setu Logo" style="width:72px; height:90px;"/>
    </div>

    <!-- Progress bar -->
    <div class="progress-track"><div class="progress-fill" id="progressBar"></div></div>

    <h1 class="card-title">Welcome, <?php echo htmlspecialchars($first_name); ?>! 🎉</h1>
    <p class="card-subtitle">
      Your parent account is ready.<br>
      Now let's create your child's learning space.
    </p>

    <!-- Error / success -->
    <div class="msg error"   id="profileError"></div>
    <div class="msg success" id="profileSuccess"></div>

    <!-- Child's display name -->
    <p class="field-label">CHILD'S NAME</p>
    <div class="input-wrap">
      <span class="icon">🧒</span>
      <input type="text" id="childName" placeholder="E.g. Ram, Angel, Priya" maxlength="40"
             oninput="updateProgress()" autocomplete="off"/>
    </div>

    <!-- Age + grade row -->
    <div class="two-col">
      <div>
        <p class="field-label">AGE</p>
        <div class="input-wrap">
          <span class="icon">🎂</span>
          <select id="childAge" onchange="updateProgress()">
            <option value="" disabled selected>Select</option>
            4</option><option>5</option>
            <option>6</option><option>7</option><option>8</option>
            <option>9</option><option>10</option>
          </select>
        </div>
      </div>
      <div>
        <p class="field-label">SELECTED MASCOT</p>
        <div class="input-wrap" style="cursor:pointer" onclick="document.getElementById('avatarSection').scrollIntoView({behavior:'smooth'})">
          <span class="icon">🎭</span>
          <input type="text" id="avatarDisplay" placeholder="Pick one below ↓" readonly style="cursor:pointer"/>
        </div>
      </div>
    </div>

    <!-- Avatar picker -->
    <div id="avatarSection">
      <p class="avatar-section-label">PICK AN EXPLORER MASCOT</p>
      <div class="avatar-grid" id="avatarGrid"></div>
    </div>

    <!-- Preview box -->
    <div class="preview-box" id="previewBox">
      <div class="preview-circle" id="previewCircle">
        <span id="previewEmoji" style="opacity:0.35">🎭</span>
      </div>
      <div class="preview-info">
        <div class="preview-name" id="previewName">No mascot chosen yet</div>
        <div class="preview-hint" id="previewHint">Select an avatar above to personalise your child's space</div>
      </div>
    </div>

    <!-- Back + Submit -->
    <button class="btn-launch" id="launchBtn" onclick="handleLaunch()">
      Launch Learning Platform!
    </button>

    <div style="display:flex; justify-content:space-between; align-items:center; margin-top:16px;">
      <a href="parent-dashboard.php" style="font-size:.85rem; color:#1abcbf; font-weight:700; text-decoration:none;">
        ← Back to Dashboard
      </a>
      <a href="parent-dashboard.php" style="font-size:.82rem; color:#999; text-decoration:none;">
        Skip for now →
      </a>
    </div>

  </div><!-- end card-wrap -->

  <script>
    const AVATARS = [
      { emoji: '🦉', name: 'Wise Owl',     hint: 'Curious & clever!' },
      { emoji: '🦊', name: 'Clever Fox',   hint: 'Quick & sly!' },
      { emoji: '🐬', name: 'Playful Dolphin', hint: 'Smart & friendly!' },
      { emoji: '🦁', name: 'Brave Lion',   hint: 'Bold & fearless!' },
      { emoji: '🐢', name: 'Steady Turtle',hint: 'Patient & wise!' },
      { emoji: '🦋', name: 'Free Butterfly',hint: 'Creative & free!' },
      { emoji: '🐸', name: 'Hopping Frog', hint: 'Leaps to learn!' },
      { emoji: '🦄', name: 'Magic Unicorn',hint: 'Rare & wonderful!' },
    ];

    let selectedAvatar = null;

    // Build avatar grid
    function buildGrid() {
      const grid = document.getElementById('avatarGrid');
      AVATARS.forEach((a, i) => {
        const div = document.createElement('div');
        div.className = 'avatar-option';
        div.textContent = a.emoji;
        div.title = a.name;
        div.onclick = () => selectAvatar(i, div, a);
        grid.appendChild(div);
      });
    }

    function selectAvatar(i, el, a) {
      document.querySelectorAll('.avatar-option').forEach(o => o.classList.remove('selected'));
      el.classList.add('selected');
      selectedAvatar = a;

      // Update avatar display input
      document.getElementById('avatarDisplay').value = a.name;

      // Update preview
      const emoji = document.getElementById('previewEmoji');
      emoji.textContent = a.emoji;
      emoji.style.opacity = '1';
      document.getElementById('previewCircle').style.background = 'linear-gradient(135deg,#1abcbf,#6b7fc4)';
      document.getElementById('previewName').textContent = a.name;
      document.getElementById('previewHint').textContent = a.hint;

      updateProgress();
    }

    // Progress bar: tracks how many of 3 fields are filled
    function updateProgress() {
      const name = document.getElementById('childName').value.trim();
      const age  = document.getElementById('childAge').value;
      let filled = 0;
      if (name) filled++;
      if (age)  filled++;
      if (selectedAvatar) filled++;
      document.getElementById('progressBar').style.width = (filled / 3 * 100) + '%';
    }

    function showError(msg) {
      const el = document.getElementById('profileError');
      el.textContent = msg; el.style.display = 'block';
      document.getElementById('profileSuccess').style.display = 'none';
    }
    function showSuccess(msg) {
      const el = document.getElementById('profileSuccess');
      el.textContent = msg; el.style.display = 'block';
      document.getElementById('profileError').style.display = 'none';
    }

    function handleLaunch() {
      const name = document.getElementById('childName').value.trim();
      const age  = document.getElementById('childAge').value;

      document.getElementById('profileError').style.display = 'none';
      document.getElementById('profileSuccess').style.display = 'none';

      if (!name)           { showError("Please enter your child's name."); return; }
      if (!age)            { showError("Please select your child's age."); return; }
      if (!selectedAvatar) { showError('Please pick a mascot avatar.'); return; }

      const btn = document.getElementById('launchBtn');
      btn.disabled = true;
      btn.textContent = '⏳ Setting up…';

      const formData = new URLSearchParams();
      formData.append('child_name',   name);
      formData.append('child_age',    age);
      formData.append('mascot_emoji', selectedAvatar.emoji);
      formData.append('mascot_name',  selectedAvatar.name);

      fetch('save_child_profile.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
      })
      .then(r => r.json())
      .then(data => {
        if (data.status === 'success') {
          showSuccess('🎉 ' + data.message + ' Redirecting…');
          setTimeout(() => { window.location.href = data.redirect; }, 1400);
        } else {
          showError(data.message);
          btn.disabled = false;
          btn.textContent = '🚀 Launch Learning Platform!';
        }
      })
      .catch(() => {
        showError('An unexpected error occurred. Please try again.');
        btn.disabled = false;
        btn.textContent = '🚀 Launch Learning Platform!';
      });
    }

    buildGrid();
    updateProgress();
  </script>
</body>
</html>
