<?php
session_start();
if (!isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    header('Location: login.php');
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <link rel="stylesheet" href="../css/admin.css">
</head>
<body>
    <div class="wrapper">

        <!-- Sidebar content -->
        <aside id="sidebar">
            <div class="d-flex justify-content-between p-4">
                <div class="sidebar-logo">
                    <a href="#">ज्ञान Setu</a>
                </div>
                <button class="toggle-btn border-0" type="button">
                    <i id="icon" class='bx bx-chevrons-right'></i>
                </button>
            </div>
            <ul class="sidebar-nav">
                <li class="sidebar-items">
                    <a href="#" class="sidebar-link">
                        <i class='bx bx-line-chart'></i>                     
                        <span>Overview Dashboard</span>
                    </a>
                </li>
                <li class="sidebar-items">
                    <a href="#" class="sidebar-link">
                        <i class='bx bx-brain' ></i>
                        <span>Question Vault</span>
                    </a>
                </li>
                <li class="sidebar-items">
                    <a href="#" class="sidebar-link">
                        <i class='bx bx-store'></i>
                        <span>Store Manager</span>
                    </a>
                </li>
                <li class="sidebar-items">
                    <a href="#" class="sidebar-link">
                        <i class='bx bxs-user-account'></i>
                        <span>Children Spaces</span>
                    </a>
                </li>
                <li class="sidebar-items">
                    <a href="#" class="sidebar-link">
                        <i class='bx bxs-server' ></i>
                        <span>PHP/ MySQL Setup</span>
                    </a>
                </li>
                <li class="sidebar-items">
                    <a href="#" class="sidebar-link">
                        <i class='bx bx-bell'></i>
                        <span>Notifications</span>
                    </a>
                </li>
                <li class="sidebar-items">
                    <a href="#" class="sidebar-link">
                        <i class='bx bxs-cog'></i>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>
            <div class="sidebar-footer">
                <a href="../logout.php" class="sidebar-link">
                    <i class='bx bx-log-out' ></i>
                    <span>Logout</span>
                </a>
            </div>
        </aside>

        <!-- navigation bar contents -->
        <div class="main">
            <nav class="navbar navbar-expand px-4 py-3">

                <!-- search bar -->
                <form action="#" class="d-none d-sm-inline-block">
                    <div class="input-group input-group-navbar">
                        <input type="text" class="form-control border-0 rounded-0 pe-0" placeholder="Search..." aria-label="Search">
                        <button class="btn border-0 rounded-0" type="button">
                            <i class='bx bx-search-alt-2' ></i>
                        </button>
                    </div>
                </form>

                <!-- Account settings -->
                <div class="navbar-collapse collapse">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item dropdown">
                            <a href="#" data-bs-toggle="dropdown" class="nav-icon pe-med-0">
                                <img src="../assets/images/avatar/avatar.png" class="avatar img-fluid" alt="User">
                            </a>
                            <div class="dropdown-menu dropdown-menu-end rounded-0 boarder-0 shadow mt-3">
                                <a href="#" class="dropdown-item">
                                    <i class='bx bx-data' ></i>
                                    <span>Analytics</span>
                                </a><a href="#" class="dropdown-item">
                                    <i class='bx bx-cog' ></i>
                                    <span>Settings</span>
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="#" class="dropdown-item">
                                    <i class='bx bx-help-circle' ></i>
                                    <span>Help Center</span>
                                </a>
                            </div>
                        </li>
                    </ul>
                </div>
            </nav>
            <main class="content px-3 py-4">
                <div class="container-fluid">
                    <div class="mb-3">
                        <h3 class="fw-bold fs-4 mb-3">
                            Admin Dashboard
                        </h3>
                        
                        <!-- information cards -->

                        <div class="row">
                            <div class="col-12 col-md-3 ">
                                <div class="card shadow">
                                    <div class="card-body py-4 rounded-4">
                                        <h6 class="mb-2 fw-bold text-muted">
                                            TOTAL LEARNERS
                                        </h6>
                                        <h4 class="fw-bold mb-2 text-dark" id="total-learners">
                                            --
                                        </h4>
                                        <div class="mb-0">
                                            <span class="badge text-success me-2">
                                                Active
                                            </span>
                                            <span class="text-muted small">
                                                Enrolled Kids
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-3 ">
                                <div class="card shadow">
                                    <div class="card-body py-4 rounded-4">
                                        <h6 class="mb-2 fw-bold text-muted">
                                            QUESTION POOL
                                        </h6>
                                        <h4 class="fw-bold mb-2 text-dark" id="question-pool">
                                            --
                                        </h4>
                                        <div class="mb-0">
                                            <span class="badge text-success me-2">
                                                Active
                                            </span>
                                            <span class="text-muted small">
                                                Quiz Questions
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-3 ">
                                <div class="card shadow">
                                    <div class="card-body py-4 rounded-4">
                                        <h6 class="mb-2 fw-bold text-muted">
                                            STORE ITEMS
                                        </h6>
                                        <h4 class="fw-bold mb-2 text-dark" id="store-items">
                                            --
                                        </h4>
                                        <div class="mb-0">
                                            <span class="badge text-success me-2">
                                                Active
                                            </span>
                                            <span class="text-muted small">
                                                Child & Parent Items
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-3 ">
                                <div class="card shadow">
                                    <div class="card-body py-4 rounded-4">
                                        <h6 class="mb-2 fw-bold text-muted">
                                            COMPLETED SALES
                                        </h6>
                                        <h4 class="fw-bold mb-2 text-dark" id="completed-sales">
                                            --
                                        </h4>
                                        <div class="mb-0">
                                            <span class="badge text-success me-2">
                                                Active
                                            </span>
                                            <span class="text-muted small">
                                                Total Orders
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- store purchase log -->
                        <div class="row">
                            <div class="col-12 col-md-8">
                                <div class="card shadow p-4 mt-3 rounded-4">
                                    <h5 class="fw-bold fs-4 my-3 text-success">
                                        <i class='bx bx-book-content'></i> Child Store Purchase Log
                                    </h5>
                                    <table class="table" id="purchase-log">
                                        <thead>
                                            <tr class="text-muted">
                                            <th scope="col">Child Profile</th>
                                            <th scope="col">Purchased Reward</th>
                                            <th scope="col">Timestamp</th>
                                            <th scope="col">Cost</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- rows injected here by js -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="col-12 col-md-4">
                                <div class="card shadow p-4 mt-3 rounded-4">
                                    <h5 class="fw-bold fs-4 my-3 text-warning">
                                        <i class='bx bxs-trophy'></i> Top Explorers 
                                    </h5>
                                    <ul class="list-unstyled" id="top-explorers-list">
                                         <!-- items injected here by js -->
                                    </ul>
                                </div> 
                                </div>
                            </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12 col-md-8">
                                <div class="card shadow p-4 mt-3 rounded-4">
                                    <h5 class="fw-bold fs-4 my-3 text-success">
                                        <i class='bx bx-book-content'></i> Parent Store Purchase Log
                                    </h5>
                                    <table class="table" id="parent-purchase-log">
                                        <thead>
                                            <tr class="text-muted">
                                            <th scope="col">Parent Name</th>
                                            <th scope="col">Purchased Item</th>
                                            <th scope="col">Timestamp</th>
                                            <th scope="col">Cost</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- rows injected here by js -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="col-12 col-md-4">
                                <div class="card shadow p-4 mt-3 rounded-4">
                                    <h5 class="fw-bold fs-4 my-3">
                                        <i class='bx bxs-magic-wand' ></i> Quick Tasks
                                    </h5>
                                    <div class="d-grid gap-2">
                                        <button type="button" class="btn btn-outline-success text-start" data-bs-toggle="modal" data-bs-target="#questionModal">
                                            <i class='bx bxs-game'></i> Add Whack-a-Mole Question
                                        </button>
                                        <button type="button" class="btn btn-outline-success text-start" data-bs-toggle="modal" data-bs-target="#rewardModal">
                                            <i class='bx bxs-cart-add'></i> List New Reward Item
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <footer class="footer">
                <div class="container-fluid">
                    <div class="row text-body-secondary">
                        <div class="col-6 text-start">
                            <a href="#" class="text-body-secondary">
                                <strong>ज्ञान Setu</strong>
                            </a>
                        </div>
                        <div class="col-6 text-end text-body-secondary d-none d-md-block">
                            <ul class="list-inline mb-0">
                                <li class="list-inline-item">
                                    <a href="#" class="text-body-secondary">Contact</a>
                                </li>
                                <li class="list-inline-item">
                                    <a href="#" class="text-body-secondary">About Us</a>
                                </li>
                                <li class="list-inline-item">
                                    <a href="#" class="text-body-secondary">Terms and Conditions</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </div>
    <!-- wrapper close -->
     <!-- ===== Modal: Register New Question ===== -->
<div class="modal fade" id="questionModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title d-flex align-items-center gap-2">
            <i class='bx bxs-game'></i> Add Whack-a-Mole Question
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form id="questionForm">
          <input type="hidden" name="game_id" value="1">
          <input type="hidden" name="course_id" value="1">

          <label class="fw-bold mb-1">Whack-a-Mole Topic</label>
          <select class="form-select mb-3" name="target_group" required>
            <option value="grammar" selected>ENGLISH: Grammar (is/am/are, verbs, pronouns)</option>
            <option value="vocabulary">ENGLISH: Vocabulary (opposites, word match, plurals)</option>
          </select>

          <label class="fw-bold mb-1">Grammar / Vocabulary Concept</label>
          <input type="text" class="form-control mb-3" name="subcategory" placeholder="e.g. is / am / are or Plurals" required>

          <label class="fw-bold mb-1">Sentence Prompt (Displayed above Moles)</label>
          <input type="text" class="form-control mb-3" name="prompt" placeholder="e.g. She ___ a doctor." required>

          <div class="p-3 bg-light rounded-3 mb-3 border">
            <h6 class="fw-bold text-success mb-2"><i class='bx bx-check-circle'></i> Mole Hole Answers (4 Total)</h6>
            
            <label class="form-label small fw-bold text-success mb-1">Target Mole (Correct Answer to Whack) *</label>
            <input type="text" class="form-control mb-2 border-success" name="answer" placeholder="e.g. is" required>

            <label class="form-label small fw-bold text-muted mb-1">Wrong Mole 1 (Distractor) *</label>
            <input type="text" class="form-control mb-2" name="distractor_1" placeholder="e.g. am" required>

            <label class="form-label small fw-bold text-muted mb-1">Wrong Mole 2 (Distractor) *</label>
            <input type="text" class="form-control mb-2" name="distractor_2" placeholder="e.g. are" required>

            <label class="form-label small fw-bold text-muted mb-1">Wrong Mole 3 (Distractor) *</label>
            <input type="text" class="form-control mb-1" name="distractor_3" placeholder="e.g. were" required>
          </div>

          <label class="fw-bold mb-1">Difficulty Tier</label>
          <select class="form-select mb-3" name="difficulty">
            <option value="easy">Tier 1 (Easy)</option>
            <option value="medium" selected>Tier 2 (Medium)</option>
            <option value="hard">Tier 3 (Hard)</option>
          </select>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-success" id="saveQuestionBtn">Add to Whack-a-Mole</button>
      </div>
    </div>
  </div>
</div>

<!-- ===== Modal: New Reward Item Details ===== -->
<div class="modal fade" id="rewardModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title">
            <i class='bx bx-store' ></i> New Reward Item Details
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form id="rewardForm">
          <label class="fw-bold mb-1">Asset Title (item_name)</label>
          <input type="text" class="form-control mb-3" name="item_name" placeholder="e.g. Capybara Mascot Costume" required>

          <label class="fw-bold mb-1">Required Coins Cost (price_coins)</label>
          <input type="number" class="form-control mb-3" name="price" value="50" min="1" required>

          <label class="fw-bold mb-1">Mascot / Icon Emoji Character (icon_url)</label>
          <input type="text" class="form-control mb-3" name="icon" placeholder="e.g. 🦫 or 🚀" maxlength="255">

          <label class="fw-bold mb-1">Brief Description</label>
          <textarea class="form-control mb-3" name="description" rows="2" placeholder="Describe what the child receives..."></textarea>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-success" id="saveRewardBtn">Save Item</button>
      </div>
    </div>
  </div>
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
    <script src="../js/admin.js"></script>
    
</body>
</html>