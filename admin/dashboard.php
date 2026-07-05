<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <link rel="stylesheet" href="adminstyles.css">
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
                <a href="logout.php" class="sidebar-link">
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
                                <img src="avatar/avatar.png" class="avatar img-fluid" alt="User">
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
                                        <h6 class="mb-2 fw-bold">
                                            TOTAL LEARNERS
                                        </h6>
                                        <p class="fw-bold mb-2">
                                            number of learners
                                        </p>
                                        <div class="mb-0">
                                            <span class="badge text-success me-2">
                                                +XX%
                                            </span>
                                            <span class="fw-bold">
                                                Since Last Month
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-3 ">
                                <div class="card shadow">
                                    <div class="card-body py-4 rounded-4">
                                        <h6 class="mb-2 fw-bold">
                                            QUESTION POOL
                                        </h6>
                                        <p class="fw-bold mb-2">
                                            number of questions
                                        </p>
                                        <div class="mb-0">
                                            <span class="badge text-success me-2">
                                                +XX
                                            </span>
                                            <span class="fw-bold">
                                                Since Last Month
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-3 ">
                                <div class="card shadow">
                                    <div class="card-body py-4 rounded-4">
                                        <h6 class="mb-2 fw-bold">
                                            STORE ITEMS
                                        </h6>
                                        <p class="fw-bold mb-2">
                                            number of items
                                        </p>
                                        <div class="mb-0">
                                            <span class="badge text-success me-2">
                                                +XX%
                                            </span>
                                            <span class="fw-bold">
                                                Since Last Month
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12 col-md-3 ">
                                <div class="card shadow">
                                    <div class="card-body py-4 rounded-4">
                                        <h6 class="mb-2 fw-bold">
                                            COMPLETED SALES
                                        </h6>
                                        <p class="fw-bold mb-2">
                                            number of sales
                                        </p>
                                        <div class="mb-0">
                                            <span class="badge text-success me-2">
                                                +XX%
                                            </span>
                                            <span class="fw-bold">
                                                Since Last Month
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
                                    <table class="table" id="purchase-log">
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
                                            <i class='bx bx-plus'></i> Create Math Question
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
        <h5 class="modal-title">
            <i class='bx bx-question-mark' ></i> Register New Question
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal">
        </button>
      </div>
      <div class="modal-body">
        <form id="questionForm">
          <label class="fw-bold mb-1">Select Target Group</label>
          <select class="form-select mb-3" name="target_group" required>
            <option value="maths">MATHS (Earth Defense / Fraction Fruit)</option>
            <option value="english">ENGLISH (Word Matcher / Sentence Builder)</option>
            <option value="story">STORY BOOKS (Vance Mysteries / Adventure Tales)</option>
          </select>

          <label class="fw-bold mb-1">Sub-Category Identifier</label>
          <input type="text" class="form-control mb-3" name="subcategory" placeholder="e.g. Fractions">

          <label class="fw-bold mb-1">Equation / Formulation Prompt String</label>
          <input type="text" class="form-control mb-3" name="prompt" placeholder="e.g. 5 + ? = 12" required>

          <label class="fw-bold mb-1">Correct Key Value</label>
          <input type="text" class="form-control mb-3" name="answer" placeholder="e.g. 7" required>

          <label class="fw-bold mb-1">Difficulty Scaling Rank</label>
          <select class="form-select mb-3" name="difficulty">
            <option value="easy">Easy</option>
            <option value="medium" selected>Medium</option>
            <option value="hard">Hard</option>
          </select>

          <label class="fw-bold mb-1">Award Coin Points Value</label>
          <input type="number" class="form-control mb-2" name="points" value="10" min="1" required>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-success" id="saveQuestionBtn">Save to Vault</button>
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
          <label class="fw-bold mb-1">Asset Title</label>
          <input type="text" class="form-control mb-3" name="item_name" placeholder="e.g. Tracing Numbers Pack" required>

          <label class="fw-bold mb-1">Inventory Classification</label>
          <select class="form-select mb-3" name="category">
            <option value="worksheet">Worksheet Packet (PDF)</option>
            <option value="helper">In-Game Helper Potion</option>
            <option value="avatar">Avatar Cosmetic Frame</option>
          </select>

          <label class="fw-bold mb-1">Required Coins Cost</label>
          <input type="number" class="form-control mb-3" name="price" value="50" min="1" required>

          <label class="fw-bold mb-1">Mascot / Icon Emoji Character</label>
          <input type="text" class="form-control mb-3" name="icon" placeholder="e.g. 📚" maxlength="4">

          <label class="fw-bold mb-1">Brief Description</label>
          <textarea class="form-control mb-3" name="description" rows="2" placeholder="Describe what the child receives..."></textarea>

          <label class="fw-bold mb-1">Sandbox Available Stock</label>
          <input type="number" class="form-control mb-2" name="stock" value="10" min="0">
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
    <script src="script.js"></script>
    
</body>
</html>