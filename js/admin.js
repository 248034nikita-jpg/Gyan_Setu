// ===== Sidebar Navigation Toggle =====
const hamburger = document.querySelector(".toggle-btn");
const toggler = document.querySelector("#icon");
if (hamburger && toggler) {
    hamburger.addEventListener("click", function() {
        document.querySelector("#sidebar").classList.toggle("expand");
        toggler.classList.toggle("bx-chevrons-right");
        toggler.classList.toggle("bx-chevrons-left");    
    });
}

// ===== Helper: Format ISO / MySQL timestamp into readable date/time =====
function formatTimestamp(iso) {
    if (!iso) return '-';
    // Replace space with T if needed for consistent Date parsing
    const normalized = iso.replace(' ', 'T');
    const d = new Date(normalized);
    if (isNaN(d.getTime())) return iso;
    return d.toLocaleString('en-US', {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit', hour12: true
    }).replace(',', '');
}

// ===== Helper: Show feedback toast/alert =====
function showDashboardAlert(message, type = 'success') {
    let alertBox = document.getElementById('dashboardAlert');
    if (!alertBox) {
        alertBox = document.createElement('div');
        alertBox.id = 'dashboardAlert';
        alertBox.style.position = 'fixed';
        alertBox.style.top = '20px';
        alertBox.style.right = '20px';
        alertBox.style.zIndex = '9999';
        alertBox.style.minWidth = '280px';
        document.body.appendChild(alertBox);
    }
    const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
    alertBox.innerHTML = `
        <div class="alert ${bgClass} text-white shadow d-flex align-items-center justify-content-between p-3 rounded-3" role="alert">
            <span>${message}</span>
            <button type="button" class="btn-close btn-close-white ms-3" onclick="this.parentElement.remove()"></button>
        </div>
    `;
    setTimeout(() => {
        if (alertBox.firstElementChild) {
            alertBox.firstElementChild.remove();
        }
    }, 4000);
}

// ===== 1. Overview Dashboard Statistics =====
async function loadDashboardStats() {
    try {
        const res = await fetch('api/dashboard_stats.php');
        if (!res.ok) throw new Error(`HTTP error ${res.status}`);
        const stats = await res.json();

        const elLearners = document.getElementById('total-learners');
        if (elLearners && stats.total_learners !== undefined) {
            elLearners.textContent = stats.total_learners.toLocaleString();
        }

        const elQuestions = document.getElementById('question-pool');
        if (elQuestions && stats.total_questions !== undefined) {
            elQuestions.textContent = stats.total_questions.toLocaleString();
        }

        const elItems = document.getElementById('store-items');
        if (elItems && stats.total_items !== undefined) {
            elItems.textContent = stats.total_items.toLocaleString();
        }

        const elSales = document.getElementById('completed-sales');
        if (elSales && stats.total_sales !== undefined) {
            elSales.textContent = stats.total_sales.toLocaleString();
        }
    } catch (err) {
        console.error('Failed to load dashboard statistics:', err);
    }
}

// ===== 2. Child Store Purchase Log =====
// Database mapping: purchases (coins_spent, purchase_date) JOIN children (username) JOIN shop_items (item_name, icon_url)
async function loadPurchaseLog() {
    try {
        const res = await fetch('api/store_purchases.php');
        if (!res.ok) throw new Error(`HTTP error ${res.status}`);
        const purchases = await res.json();
        const tbody = document.querySelector('#purchase-log tbody');
        if (!tbody) return;

        if (!Array.isArray(purchases) || purchases.length === 0) {
            tbody.innerHTML = `<tr><td colspan="4" class="text-center text-muted py-3">No child purchases recorded yet</td></tr>`;
            return;
        }

        tbody.innerHTML = purchases.map(p => `
            <tr>
                <td class="fw-bold">${p.child_name || 'Child'}</td>
                <td class="text-success fw-semibold">${p.reward_icon ?? '🎁'} ${p.reward_name}</td>
                <td class="text-muted">${formatTimestamp(p.purchased_at)}</td>
                <td>
                    <span class="badge bg-warning text-dark rounded-pill">
                        🪙 ${p.cost} Coins
                    </span>
                </td>
            </tr>
        `).join('');
    } catch (err) {
        console.error('Failed to load child purchase log:', err);
        const tbody = document.querySelector('#purchase-log tbody');
        if (tbody) {
            tbody.innerHTML = `<tr><td colspan="4" class="text-center text-muted py-3">No purchase logs available</td></tr>`;
        }
    }
}

// ===== 3. Parent Store Purchase Log =====
// Database mapping: parent_orders (amount_paid, order_date) JOIN parents (first_name, last_name) JOIN parent_shop_items (title)
async function loadParentPurchaseLog() {
    try {
        const res = await fetch('api/parent_purchases.php');
        if (!res.ok) throw new Error(`HTTP error ${res.status}`);
        const purchases = await res.json();
        const tbody = document.querySelector('#parent-purchase-log tbody');
        if (!tbody) return;

        if (!Array.isArray(purchases) || purchases.length === 0) {
            tbody.innerHTML = `<tr><td colspan="4" class="text-center text-muted py-3">No parent purchases recorded yet</td></tr>`;
            return;
        }

        tbody.innerHTML = purchases.map(p => `
            <tr>
                <td class="fw-bold">${p.parent_name || 'Parent'}</td>
                <td class="text-success fw-semibold">${p.purchased_item}</td>
                <td class="text-muted">${formatTimestamp(p.purchased_at)}</td>
                <td>
                    <span class="badge bg-warning text-dark rounded-pill">
                        Rs. ${parseFloat(p.cost || 0).toFixed(2)}
                    </span>
                </td>
            </tr>
        `).join('');
    } catch (err) {
        console.error('Failed to load parent purchase log:', err);
        const tbody = document.querySelector('#parent-purchase-log tbody');
        if (tbody) {
            tbody.innerHTML = `<tr><td colspan="4" class="text-center text-muted py-3">No parent purchase logs available</td></tr>`;
        }
    }
}

// ===== 4. Top Explorers =====
// Database mapping: children (username, age, total_coins) LEFT JOIN mascots (emoji_or_icon)
async function loadTopExplorers() {
    try {
        const res = await fetch('api/top_explorers.php');
        if (!res.ok) throw new Error(`HTTP error ${res.status}`);
        const explorers = await res.json();
        const list = document.getElementById('top-explorers-list');
        if (!list) return;

        if (!Array.isArray(explorers) || explorers.length === 0) {
            list.innerHTML = `<li class="text-muted text-center py-3">No explorers recorded yet</li>`;
            return;
        }

        list.innerHTML = explorers.map((e, index) => `
            <li class="d-flex align-items-center justify-content-between p-2 mb-2 rounded"
                style="border-left: 4px solid ${index === 0 ? '#f0ad4e' : '#ced4da'}; background:#f8f9fa;">
                <div class="d-flex align-items-center gap-2">
                    <span class="fs-3 me-1">${e.avatar || '🧒'}</span>
                    <div>
                        <div class="fw-bold">${e.name}</div>
                        <small class="text-muted">Age ${e.age || 5}</small>
                    </div>
                </div>
                <span class="badge bg-warning text-dark rounded-pill">
                    🪙 ${e.points || 0} Coins
                </span>
            </li>
        `).join('');
    } catch (err) {
        console.error('Failed to load top explorers:', err);
        const list = document.getElementById('top-explorers-list');
        if (list) {
            list.innerHTML = `<li class="text-muted text-center py-3">No explorers found</li>`;
        }
    }
}

// ===== 5. Save Whack-a-Mole Question (modal shortcut) =====
// Database mapping: quiz_questions (game_id=1, course_id=1, question_text, topic, concept, question_type='multiple_choice', difficulty_tier)
//                  quiz_options (question_id, option_text, is_correct)
const saveQuestionBtn = document.getElementById('saveQuestionBtn');
if (saveQuestionBtn) {
    saveQuestionBtn.addEventListener('click', async function () {
        const form = document.getElementById('questionForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);

        // Always target Whack-a-Mole (game_id=1, course_id=1)
        const targetGroup = formData.get('target_group') || 'grammar';
        const subcategory = formData.get('subcategory') || 'General';
        const promptText = formData.get('prompt') || '';
        const answerText = formData.get('answer') || '';
        const d1 = formData.get('distractor_1') || '';
        const d2 = formData.get('distractor_2') || '';
        const d3 = formData.get('distractor_3') || '';
        const difficulty = formData.get('difficulty') || 'medium';

        // Check that all 4 mole options are supplied
        if (!d1.trim() || !d2.trim() || !d3.trim()) {
            showDashboardAlert('Whack-a-Mole needs 1 correct answer + 3 wrong mole options so all 4 holes are covered.', 'error');
            return;
        }

        formData.set('game_id', '1');
        formData.set('course_id', '1');
        formData.set('topic', targetGroup);
        formData.set('concept', subcategory);
        formData.set('question_text', promptText);
        formData.set('correct_answer', answerText);
        formData.set('difficulty_tier', difficulty === 'easy' ? '1' : (difficulty === 'hard' ? '3' : '2'));
        formData.set('question_type', 'multiple_choice');

        saveQuestionBtn.disabled = true;
        saveQuestionBtn.textContent = 'Adding to Game...';

        try {
            const res = await fetch('api/add_question.php', {
                method: 'POST',
                body: formData
            });
            const data = await res.json();

            if (res.ok && data.success) {
                showDashboardAlert(data.message || 'Whack-a-Mole question added to question pool!', 'success');
                const modalEl = document.getElementById('questionModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) modal.hide();
                form.reset();
                loadDashboardStats(); // Refresh Question Pool counter
            } else {
                showDashboardAlert(data.error || 'Failed to save question.', 'error');
            }
        } catch (err) {
            console.error('Failed to submit Whack-a-Mole question:', err);
            showDashboardAlert('Error communicating with server.', 'error');
        } finally {
            saveQuestionBtn.disabled = false;
            saveQuestionBtn.textContent = 'Add to Whack-a-Mole';
        }
    });
}

// ===== 6. Save Reward Item (modal) =====
// Database mapping: shop_items (item_name, description, price_coins, icon_url)
const saveRewardBtn = document.getElementById('saveRewardBtn');
if (saveRewardBtn) {
    saveRewardBtn.addEventListener('click', async function () {
        const form = document.getElementById('rewardForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);

        // Map inputs to match shop_items schema
        const itemName = formData.get('item_name') || '';
        const price = formData.get('price') || formData.get('price_coins') || '50';
        const icon = formData.get('icon') || formData.get('icon_url') || '🎁';
        const description = formData.get('description') || '';

        formData.set('item_name', itemName);
        formData.set('price_coins', price);
        formData.set('icon_url', icon);
        formData.set('description', description);

        saveRewardBtn.disabled = true;
        saveRewardBtn.textContent = 'Saving...';

        try {
            const res = await fetch('api/add_store_item.php', {
                method: 'POST',
                body: formData
            });
            const data = await res.json();

            if (res.ok && data.success) {
                showDashboardAlert(data.message || 'Reward item saved successfully!', 'success');
                const modalEl = document.getElementById('rewardModal');
                const modal = bootstrap.Modal.getInstance(modalEl);
                if (modal) modal.hide();
                form.reset();
                loadDashboardStats(); // Refresh Store Items counter
            } else {
                showDashboardAlert(data.error || 'Failed to save store item.', 'error');
            }
        } catch (err) {
            console.error('Failed to submit reward item:', err);
            showDashboardAlert('Error communicating with server.', 'error');
        } finally {
            saveRewardBtn.disabled = false;
            saveRewardBtn.textContent = 'Save Item';
        }
    });
}

// ===== 7. Initialize Dashboard on Page Load =====
document.addEventListener('DOMContentLoaded', () => {
    loadDashboardStats();
    loadPurchaseLog();
    loadParentPurchaseLog();
    loadTopExplorers();
});