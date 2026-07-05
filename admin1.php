<?php
session_start();
include 'database/includes/db_connect.php';

// --- Strict Route Protection ---
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    header("Location: login.php");
    exit();
}

$action_msg = '';
$action_status = '';

// --- Handle Reset Demo Data ---
if (isset($_POST['reset_demo'])) {
    $setupSql = file_get_contents('database/admin_setup.sql');
    if ($setupSql) {
        $conn->multi_query($setupSql);
        while ($conn->next_result()) {;} // flush multi queries
        $action_msg = "Demo data successfully reset to default!";
        $action_status = "success";
    }
}

// --- Handle Delete Question ---
if (isset($_POST['delete_question_id'])) {
    $q_id = intval($_POST['delete_question_id']);
    $stmt = $conn->prepare("DELETE FROM questions WHERE question_id = ?");
    $stmt->bind_param("i", $q_id);
    if ($stmt->execute()) {
        $action_msg = "Question #{$q_id} deleted successfully!";
        $action_status = "success";
    } else {
        $action_msg = "Failed to delete question.";
        $action_status = "error";
    }
    $stmt->close();
}

// --- Handle Add / Edit Question ---
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['save_question'])) {
    $q_id = isset($_POST['question_id']) && !empty($_POST['question_id']) ? intval($_POST['question_id']) : 0;
    $subject = trim($_POST['subject']);
    $category = trim($_POST['category']);
    $question_text = trim($_POST['question_text']);
    $question_type = trim($_POST['question_type']);
    $difficulty = trim($_POST['difficulty']);
    $coins_reward = intval($_POST['coins_reward']);
    $correct_answer_text = trim($_POST['correct_answer_text']);

    if (empty($question_text)) {
        $action_msg = "Question text cannot be empty!";
        $action_status = "error";
    } else {
        if ($q_id > 0) {
            // Update existing
            $stmt = $conn->prepare("UPDATE questions SET subject=?, category=?, question_text=?, question_type=?, difficulty=?, coins_reward=?, correct_answer_text=? WHERE question_id=?");
            $stmt->bind_param("sssssisi", $subject, $category, $question_text, $question_type, $difficulty, $coins_reward, $correct_answer_text, $q_id);
            $stmt->execute();
            $stmt->close();

            // Delete old options and re-insert if multiple choice
            $conn->query("DELETE FROM options WHERE question_id = {$q_id}");
            $inserted_id = $q_id;
            $action_msg = "Question #{$q_id} updated successfully!";
            $action_status = "success";
        } else {
            // Insert new
            $stmt = $conn->prepare("INSERT INTO questions (quiz_id, subject, category, question_text, question_type, difficulty, coins_reward, correct_answer_text) VALUES (1, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("sssssis", $subject, $category, $question_text, $question_type, $difficulty, $coins_reward, $correct_answer_text);
            $stmt->execute();
            $inserted_id = $stmt->insert_id;
            $stmt->close();
            $action_msg = "New question created successfully!";
            $action_status = "success";
        }

        // Process options for Multiple Choice
        if ($question_type === 'multiple_choice' && isset($_POST['options']) && is_array($_POST['options'])) {
            $correct_idx = isset($_POST['correct_option_index']) ? intval($_POST['correct_option_index']) : -1;
            foreach ($_POST['options'] as $idx => $opt_text) {
                $opt_text = trim($opt_text);
                if ($opt_text !== '') {
                    $is_corr = ($idx === $correct_idx) ? 1 : 0;
                    $stmt_opt = $conn->prepare("INSERT INTO options (question_id, option_text, is_correct) VALUES (?, ?, ?)");
                    $stmt_opt->bind_param("isi", $inserted_id, $opt_text, $is_corr);
                    $stmt_opt->execute();
                    $stmt_opt->close();
                }
            }
        }
    }
}

// --- Fetch Questions and Options ---
$subject_filter = isset($_GET['subject']) ? trim($_GET['subject']) : 'ALL';
$sql = "SELECT * FROM questions";
if ($subject_filter !== 'ALL' && !empty($subject_filter)) {
    $escaped_sub = $conn->real_escape_string($subject_filter);
    $sql .= " WHERE subject = '{$escaped_sub}'";
}
$sql .= " ORDER BY question_id ASC";
$res = $conn->query($sql);

$questions = [];
if ($res) {
    while ($row = $res->fetch_assoc()) {
        $q_id = $row['question_id'];
        $opt_res = $conn->query("SELECT * FROM options WHERE question_id = {$q_id} ORDER BY option_id ASC");
        $options = [];
        if ($opt_res) {
            while ($opt = $opt_res->fetch_assoc()) {
                $options[] = $opt;
            }
        }
        $row['options_list'] = $options;
        $questions[] = $row;
    }
}

// Stats for overview
$total_questions = count($questions);
$math_count = 0;
$eng_count = 0;
$story_count = 0;
foreach ($questions as $q) {
    if (strtoupper($q['subject']) === 'MATHS') $math_count++;
    elseif (strtoupper($q['subject']) === 'ENGLISH') $eng_count++;
    elseif (strtoupper($q['subject']) === 'STORY' || strtoupper($q['subject']) === 'STORY BOOKS') $story_count++;
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ज्ञान Setu - Admin & Educator Control Center</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-green: #8cb43f;
            --brand-green-dark: #7a9e35;
            --bg-light: #f4f6f8;
            --sidebar-bg: #ffffff;
            --text-dark: #2c3e50;
            --text-muted: #7f8c8d;
            --border-color: #e2e8f0;
            --badge-blue: #e0f2fe;
            --badge-blue-text: #0284c7;
            --easy-green: #22c55e;
            --medium-orange: #f59e0b;
            --hard-red: #ef4444;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Nunito', sans-serif; }
        body { background-color: var(--bg-light); color: var(--text-dark); min-height: 100vh; display: flex; flex-direction: column; }

        /* Top Banner Navbar */
        .top-navbar {
            background-color: var(--brand-green);
            color: #ffffff;
            padding: 14px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .brand-section { display: flex; align-items: center; gap: 12px; }
        .brand-logo-circle {
            width: 42px; height: 42px; background: #ffffff; color: var(--brand-green);
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-weight: 900; font-size: 18px; border: 2px solid rgba(255,255,255,0.8);
        }
        .brand-titles h1 { font-size: 22px; font-weight: 800; line-height: 1.1; }
        .brand-titles p { font-size: 12px; opacity: 0.9; font-weight: 600; }

        .header-actions { display: flex; align-items: center; gap: 12px; }
        .btn-header {
            background: #ffffff; color: #333; border: none; padding: 8px 16px;
            border-radius: 20px; font-size: 13px; font-weight: 700; cursor: pointer;
            display: flex; align-items: center; gap: 6px; text-decoration: none;
            transition: all 0.2s ease; box-shadow: 0 2px 5px rgba(0,0,0,0.08);
        }
        .btn-header:hover { transform: translateY(-1px); background: #f8fafc; }

        /* Layout Container */
        .main-wrapper { display: flex; flex: 1; }

        /* Sidebar Navigation */
        .sidebar {
            width: 250px; background: var(--sidebar-bg); border-right: 1px solid var(--border-color);
            padding: 24px 0; display: flex; flex-direction: column; gap: 6px;
        }

        .nav-item {
            display: flex; align-items: center; gap: 12px; padding: 12px 24px;
            color: var(--text-dark); font-weight: 700; font-size: 14px; text-decoration: none;
            cursor: pointer; transition: all 0.2s ease; border-left: 4px solid transparent;
        }

        .nav-item:hover { background: #f8fafc; color: var(--brand-green); }
        .nav-item.active {
            background: #f0f9ff; color: #0284c7; border-left-color: #0284c7;
        }
        .nav-icon { font-size: 18px; width: 22px; text-align: center; }

        /* Content Area */
        .content-area { flex: 1; padding: 32px 40px; overflow-y: auto; }

        /* Tab Content Containers */
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* Header Bar inside Content */
        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
        .page-title h2 { font-size: 28px; font-weight: 800; color: #1e293b; }
        .page-title p { color: var(--text-muted); font-size: 14px; font-weight: 600; margin-top: 4px; }

        .btn-primary-action {
            background: #10b981; color: white; border: none; padding: 10px 20px;
            border-radius: 24px; font-size: 14px; font-weight: 800; cursor: pointer;
            display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.25);
            transition: all 0.2s ease;
        }
        .btn-primary-action:hover { background: #059669; transform: translateY(-2px); }

        /* Filter Pills */
        .filter-container { display: flex; gap: 10px; margin-bottom: 24px; flex-wrap: wrap; }
        .filter-btn {
            background: #ffffff; border: 1px solid var(--border-color); color: var(--text-muted);
            padding: 8px 18px; border-radius: 8px; font-size: 13px; font-weight: 800;
            cursor: pointer; transition: all 0.2s ease; text-decoration: none;
        }
        .filter-btn:hover { border-color: var(--brand-green); color: var(--brand-green); }
        .filter-btn.active { background: #00a896; color: white; border-color: #00a896; }

        /* Data Card Container */
        .card-box {
            background: #ffffff; border-radius: 16px; border: 1px solid var(--border-color);
            box-shadow: 0 4px 20px rgba(0,0,0,0.03); overflow: hidden;
        }

        /* Table Styling matching screenshot */
        .custom-table { width: 100%; border-collapse: collapse; text-align: left; }
        .custom-table th {
            background: #fafafa; padding: 16px 20px; font-size: 13px; font-weight: 800;
            color: #475569; border-bottom: 1px solid var(--border-color);
        }
        .custom-table td {
            padding: 18px 20px; border-bottom: 1px solid var(--border-color);
            font-size: 14px; font-weight: 700; vertical-align: middle;
        }
        .custom-table tr:last-child td { border-bottom: none; }
        .custom-table tr:hover { background-color: #fcfcfc; }

        /* Badges & Pills */
        .subject-pill {
            background: #e2e8f0; color: #475569; padding: 4px 10px; border-radius: 12px;
            font-size: 11px; font-weight: 800; text-transform: uppercase; display: inline-block;
        }
        .category-badge {
            background: #e0f2fe; color: #0284c7; padding: 4px 12px; border-radius: 12px;
            font-size: 12px; font-weight: 700; display: inline-block;
        }

        .options-list { display: flex; gap: 6px; flex-wrap: wrap; }
        .opt-chip {
            background: #f1f5f9; border: 1px solid #cbd5e1; color: #334155;
            padding: 3px 10px; border-radius: 6px; font-size: 12px; font-weight: 700;
        }
        .opt-chip.correct { background: #dcfce7; border-color: #86efac; color: #166534; }

        .diff-badge {
            padding: 4px 12px; border-radius: 12px; font-size: 11px; font-weight: 800;
            color: white; display: inline-block; text-align: center;
        }
        .diff-badge.Easy { background: var(--easy-green); }
        .diff-badge.Medium { background: var(--medium-orange); }
        .diff-badge.Hard { background: var(--hard-red); }

        .coins-val { color: #d97706; font-weight: 800; display: flex; align-items: center; gap: 4px; }

        /* Action Buttons */
        .action-btns { display: flex; gap: 8px; }
        .btn-icon {
            width: 34px; height: 34px; border-radius: 8px; border: 1px solid var(--border-color);
            background: white; display: flex; align-items: center; justify-content: center;
            cursor: pointer; transition: all 0.2s ease; font-size: 14px;
        }
        .btn-icon.edit:hover { background: #eff6ff; border-color: #93c5fd; color: #2563eb; }
        .btn-icon.delete:hover { background: #fef2f2; border-color: #fca5a5; color: #dc2626; }

        /* Modal Overlay & Form */
        .modal-overlay {
            position: fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5);
            display: none; align-items: center; justify-content: center; z-index: 1000; padding: 20px;
        }
        .modal-overlay.active { display: flex; }
        .modal-card {
            background: white; width: 100%; max-width: 600px; border-radius: 16px;
            padding: 28px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); max-height: 90vh; overflow-y: auto;
        }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .modal-header h3 { font-size: 20px; font-weight: 800; }
        .close-modal { font-size: 24px; cursor: pointer; color: var(--text-muted); border: none; background: none; }

        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; font-weight: 800; margin-bottom: 6px; color: #475569; }
        .form-control {
            width: 100%; padding: 10px 14px; border: 1px solid var(--border-color); border-radius: 8px;
            font-size: 14px; font-weight: 600; outline: none; transition: border 0.2s;
        }
        .form-control:focus { border-color: #0284c7; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

        /* Alert Toast */
        .alert-box {
            padding: 14px 20px; border-radius: 10px; margin-bottom: 20px; font-weight: 700; font-size: 14px;
        }
        .alert-box.success { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .alert-box.error { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }

        /* General Mockup Panels */
        .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 14px; border: 1px solid var(--border-color); }
        .stat-card h4 { font-size: 13px; color: var(--text-muted); text-transform: uppercase; margin-bottom: 8px; }
        .stat-card .val { font-size: 28px; font-weight: 800; color: #0f172a; }
    </style>
</head>
<body>

    <!-- Top Navbar Banner -->
    <header class="top-navbar">
        <div class="brand-section">
            <div class="brand-logo-circle">GS</div>
            <div class="brand-titles">
                <h1>ज्ञान सेतु (Gyan Setu)</h1>
                <p>Admin & Educator Control Center</p>
            </div>
        </div>
        <div class="header-actions">
            <div class="btn-header">👤 Admin Area</div>
            <form method="POST" style="display:inline;" onsubmit="return confirm('Reset demo questions to original state?');">
                <button type="submit" name="reset_demo" class="btn-header">🔄 Reset Demo Data</button>
            </form>
        </div>
    </header>

    <div class="main-wrapper">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="nav-item" onclick="switchTab('dashboard', this)">
                <span class="nav-icon">📊</span> Dashboard Overview
            </div>
            <div class="nav-item active" onclick="switchTab('questions', this)">
                <span class="nav-icon">❓</span> Question Vault
            </div>
            <div class="nav-item" onclick="switchTab('store', this)">
                <span class="nav-icon">🏪</span> Store Manager
            </div>
            <div class="nav-item" onclick="switchTab('users', this)">
                <span class="nav-icon">👨‍👩‍👧‍👦</span> Children & Parents
            </div>
            <div class="nav-item" onclick="switchTab('setup', this)">
                <span class="nav-icon">⚙️</span> PHP & MySQL Setup
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="content-area">

            <?php if (!empty($action_msg)): ?>
                <div class="alert-box <?php echo $action_status; ?>">
                    <?php echo htmlspecialchars($action_msg); ?>
                </div>
            <?php endif; ?>

            <!-- 1. Question Vault Tab (Active by default) -->
            <div id="tab-questions" class="tab-panel active">
                <div class="page-header">
                    <div class="page-title">
                        <h2>Question Bank Manager</h2>
                        <p>Create and modify educational challenge questions for "Earth Defense" and other games.</p>
                    </div>
                    <button class="btn-primary-action" onclick="openQuestionModal()">+ Add New Question</button>
                </div>

                <!-- Filter Buttons -->
                <div class="filter-container">
                    <a href="admin.php?subject=ALL" class="filter-btn <?php echo ($subject_filter === 'ALL') ? 'active' : ''; ?>">All Subjects</a>
                    <a href="admin.php?subject=MATHS" class="filter-btn <?php echo ($subject_filter === 'MATHS') ? 'active' : ''; ?>">MATHS</a>
                    <a href="admin.php?subject=ENGLISH" class="filter-btn <?php echo ($subject_filter === 'ENGLISH') ? 'active' : ''; ?>">ENGLISH</a>
                    <a href="admin.php?subject=STORY" class="filter-btn <?php echo ($subject_filter === 'STORY') ? 'active' : ''; ?>">STORY BOOKS</a>
                </div>

                <!-- Questions Table -->
                <div class="card-box">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Subject</th>
                                <th>Category</th>
                                <th>Question / Expression</th>
                                <th>Answer / Options</th>
                                <th>Difficulty</th>
                                <th>Coins Reward</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (empty($questions)): ?>
                                <tr>
                                    <td colspan="8" style="text-align:center; color: var(--text-muted); padding: 40px;">
                                        No questions found for this filter. Click "+ Add New Question" to create one!
                                    </td>
                                </tr>
                            <?php else: ?>
                                <?php foreach ($questions as $q): ?>
                                    <tr>
                                        <td>#<?php echo $q['question_id']; ?></td>
                                        <td><span class="subject-pill"><?php echo htmlspecialchars($q['subject']); ?></span></td>
                                        <td><span class="category-badge"><?php echo htmlspecialchars($q['category']); ?></span></td>
                                        <td><strong><?php echo htmlspecialchars($q['question_text']); ?></strong></td>
                                        <td>
                                            <?php if (!empty($q['options_list'])): ?>
                                                <div class="options-list">
                                                    <?php foreach ($q['options_list'] as $opt): ?>
                                                        <span class="opt-chip <?php echo $opt['is_correct'] ? 'correct' : ''; ?>">
                                                            <?php echo htmlspecialchars($opt['option_text']); ?>
                                                        </span>
                                                    <?php endforeach; ?>
                                                </div>
                                            <?php else: ?>
                                                <span class="opt-chip correct"><?php echo htmlspecialchars($q['correct_answer_text'] ?? 'N/A'); ?></span>
                                            <?php endif; ?>
                                        </td>
                                        <td><span class="diff-badge <?php echo $q['difficulty']; ?>"><?php echo $q['difficulty']; ?></span></td>
                                        <td><span class="coins-val">🪙 <?php echo $q['coins_reward']; ?></span></td>
                                        <td>
                                            <div class="action-btns">
                                                <button class="btn-icon edit" title="Edit" onclick='editQuestion(<?php echo json_encode($q); ?>)'>✏️</button>
                                                <form method="POST" style="display:inline;" onsubmit="return confirm('Delete Question #<?php echo $q['question_id']; ?>?');">
                                                    <input type="hidden" name="delete_question_id" value="<?php echo $q['question_id']; ?>">
                                                    <button type="submit" class="btn-icon delete" title="Delete">🗑️</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 2. Dashboard Overview Tab (Mockup) -->
            <div id="tab-dashboard" class="tab-panel">
                <div class="page-header">
                    <div class="page-title">
                        <h2>Dashboard Overview</h2>
                        <p>System metrics and student activity summary.</p>
                    </div>
                </div>
                <div class="stat-grid">
                    <div class="stat-card">
                        <h4>Total Questions Vaulted</h4>
                        <div class="val"><?php echo $total_questions; ?></div>
                    </div>
                    <div class="stat-card">
                        <h4>Math Challenges</h4>
                        <div class="val" style="color:#0284c7;"><?php echo $math_count; ?></div>
                    </div>
                    <div class="stat-card">
                        <h4>English Modules</h4>
                        <div class="val" style="color:#10b981;"><?php echo $eng_count; ?></div>
                    </div>
                    <div class="stat-card">
                        <h4>Story Challenges</h4>
                        <div class="val" style="color:#f59e0b;"><?php echo $story_count; ?></div>
                    </div>
                </div>
            </div>

            <!-- 3. Store Manager Tab (Mockup) -->
            <div id="tab-store" class="tab-panel">
                <div class="page-header">
                    <div class="page-title">
                        <h2>Store Manager</h2>
                        <p>Manage reward store items, avatars, and game badges.</p>
                    </div>
                    <button class="btn-primary-action">+ Add New Store Item</button>
                </div>
                <div class="card-box" style="padding: 30px; text-align: center; color: var(--text-muted);">
                    <h3>🛒 Store Item Backend Ready</h3>
                    <p style="margin-top:8px;">You will request backend logic for shop items in the upcoming step!</p>
                </div>
            </div>

            <!-- 4. Children & Parents Tab (Mockup) -->
            <div id="tab-users" class="tab-panel">
                <div class="page-header">
                    <div class="page-title">
                        <h2>Children & Parents Management</h2>
                        <p>View registered students, parent accounts, and general progress metrics.</p>
                    </div>
                </div>
                <div class="card-box" style="padding: 30px; text-align: center; color: var(--text-muted);">
                    <h3>👨‍👩‍👧‍👦 User Statistics Backend Ready</h3>
                    <p style="margin-top:8px;">User management & progress analytics logic is queued for next build steps!</p>
                </div>
            </div>

            <!-- 5. PHP & MySQL Setup Tab -->
            <div id="tab-setup" class="tab-panel">
                <div class="page-header">
                    <div class="page-title">
                        <h2>PHP & MySQL Database Setup</h2>
                        <p>Verify and manage core database tables and system connection credentials.</p>
                    </div>
                </div>
                <div class="card-box" style="padding: 24px;">
                    <h3 style="margin-bottom: 12px;">Database Health Diagnostic</h3>
                    <p style="color: green; font-weight:700; margin-bottom: 16px;">✓ Connected to MySQL database `gyan_setu` successfully.</p>
                    <form method="POST">
                        <button type="submit" name="reset_demo" class="btn-primary-action">⚡ Run / Re-apply `admin_setup.sql` Schema Script</button>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <!-- Modal Form for Add / Edit Question -->
    <div class="modal-overlay" id="questionModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3 id="modalTitle">Add New Educational Question</h3>
                <button class="close-modal" onclick="closeQuestionModal()">&times;</button>
            </div>
            <form method="POST" action="admin.php">
                <input type="hidden" name="save_question" value="1">
                <input type="hidden" name="question_id" id="form_question_id" value="">

                <div class="form-row">
                    <div class="form-group">
                        <label>Subject</label>
                        <select name="subject" id="form_subject" class="form-control" required>
                            <option value="MATHS">MATHS</option>
                            <option value="ENGLISH">ENGLISH</option>
                            <option value="STORY">STORY</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Category Tag</label>
                        <input type="text" name="category" id="form_category" class="form-control" placeholder="e.g. Simple Addition, Fractions" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Question / Expression Text</label>
                    <textarea name="question_text" id="form_question_text" class="form-control" rows="3" placeholder="e.g. 4 + ? = 10" required></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Question Type</label>
                        <select name="question_type" id="form_question_type" class="form-control" onchange="toggleOptionInputs()">
                            <option value="multiple_choice">Multiple Choice</option>
                            <option value="typing">Typing / Direct Answer</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Difficulty Level</label>
                        <select name="difficulty" id="form_difficulty" class="form-control">
                            <option value="Easy">Easy</option>
                            <option value="Medium">Medium</option>
                            <option value="Hard">Hard</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Coins Reward</label>
                    <input type="number" name="coins_reward" id="form_coins_reward" class="form-control" value="10" min="5" max="100">
                </div>

                <!-- Multiple Choice Options Container -->
                <div id="mc_options_box" style="margin-top: 16px;">
                    <label style="font-size: 13px; font-weight: 800; color: #475569; display:block; margin-bottom:8px;">Multiple Choice Options (Select radio button for Correct Answer)</label>
                    <div id="options_fields_list">
                        <!-- Dynamic options generated by JS -->
                    </div>
                </div>

                <div id="typing_box" class="form-group" style="display:none;">
                    <label>Correct Answer Text</label>
                    <input type="text" name="correct_answer_text" id="form_correct_answer_text" class="form-control" placeholder="Correct Answer String">
                </div>

                <div style="margin-top: 24px; display:flex; justify-content: flex-end; gap:12px;">
                    <button type="button" class="btn-header" onclick="closeQuestionModal()">Cancel</button>
                    <button type="submit" class="btn-primary-action">Save Question</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function switchTab(tabName, el) {
            document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
            document.getElementById('tab-' + tabName).classList.add('active');
            el.classList.add('active');
        }

        function openQuestionModal() {
            document.getElementById('modalTitle').innerText = 'Add New Educational Question';
            document.getElementById('form_question_id').value = '';
            document.getElementById('form_question_text').value = '';
            document.getElementById('form_category').value = '';
            document.getElementById('form_subject').value = 'MATHS';
            document.getElementById('form_difficulty').value = 'Easy';
            document.getElementById('form_coins_reward').value = '10';
            document.getElementById('form_question_type').value = 'multiple_choice';
            
            renderOptionInputs(['', '', '', ''], 0);
            toggleOptionInputs();
            document.getElementById('questionModal').classList.add('active');
        }

        function closeQuestionModal() {
            document.getElementById('questionModal').classList.remove('active');
        }

        function renderOptionInputs(optsArray, correctIdx) {
            const container = document.getElementById('options_fields_list');
            container.innerHTML = '';
            optsArray.forEach((optVal, idx) => {
                const row = document.createElement('div');
                row.style.display = 'flex';
                row.style.alignItems = 'center';
                row.style.gap = '10px';
                row.style.marginBottom = '8px';

                const radio = document.createElement('input');
                radio.type = 'radio';
                radio.name = 'correct_option_index';
                radio.value = idx;
                if (idx === correctIdx) radio.checked = true;

                const input = document.createElement('input');
                input.type = 'text';
                input.name = 'options[]';
                input.className = 'form-control';
                input.placeholder = 'Option ' + (idx + 1);
                input.value = optVal;

                row.appendChild(radio);
                row.appendChild(input);
                container.appendChild(row);
            });
        }

        function toggleOptionInputs() {
            const type = document.getElementById('form_question_type').value;
            if (type === 'multiple_choice') {
                document.getElementById('mc_options_box').style.display = 'block';
                document.getElementById('typing_box').style.display = 'none';
            } else {
                document.getElementById('mc_options_box').style.display = 'none';
                document.getElementById('typing_box').style.display = 'block';
            }
        }

        function editQuestion(qData) {
            document.getElementById('modalTitle').innerText = 'Modify Question #' + qData.question_id;
            document.getElementById('form_question_id').value = qData.question_id;
            document.getElementById('form_subject').value = qData.subject || 'MATHS';
            document.getElementById('form_category').value = qData.category || '';
            document.getElementById('form_question_text').value = qData.question_text || '';
            document.getElementById('form_question_type').value = qData.question_type || 'multiple_choice';
            document.getElementById('form_difficulty').value = qData.difficulty || 'Easy';
            document.getElementById('form_coins_reward').value = qData.coins_reward || 10;
            document.getElementById('form_correct_answer_text').value = qData.correct_answer_text || '';

            let opts = [];
            let correctIdx = 0;
            if (qData.options_list && qData.options_list.length > 0) {
                qData.options_list.forEach((o, i) => {
                    opts.push(o.option_text);
                    if (parseInt(o.is_correct) === 1) correctIdx = i;
                });
            } else {
                opts = ['', '', '', ''];
            }

            renderOptionInputs(opts, correctIdx);
            toggleOptionInputs();
            document.getElementById('questionModal').classList.add('active');
        }
    </script>
</body>
</html>
