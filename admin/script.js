const hamburger=document.querySelector(".toggle-btn");
const toggler = document.querySelector("#icon");
hamburger.addEventListener("click", function() {
    document.querySelector("#sidebar").classList.toggle("expand");
    toggler.classList.toggle("bx-chevrons-right");
    toggler.classList.toggle("bx-chevrons-left");    
});


// ===== Child Store Purchase Log =====
async function loadPurchaseLog() {
    try {
        const res = await fetch('api/store_purchases.php');
        const purchases = await res.json();
        const tbody = document.querySelector('#purchase-log tbody');
        tbody.innerHTML = purchases.map(p => `
            <tr>
                <td class="fw-bold">${p.child_name}</td>
                <td class="text-success fw-semibold">${p.reward_icon ?? ''} ${p.reward_name}</td>
                <td class="text-muted">${formatTimestamp(p.purchased_at)}</td>
                <td>
                    <span class="badge bg-warning text-dark rounded-pill">
                        🪙 ${p.cost} Pts
                    </span>
                </td>
            </tr>
        `).join('');
    } catch (err) {
        console.error('Failed to load child purchase log:', err);
    }
}

// ===== Parent Store Purchase Log =====
async function loadParentPurchaseLog() {
    try {
        const res = await fetch('api/parent_purchases.php');
        const purchases = await res.json();
        const tbody = document.querySelector('#parent-purchase-log tbody');
        tbody.innerHTML = purchases.map(p => `
            <tr>
                <td class="fw-bold">${p.parent_name}</td>
                <td class="text-success fw-semibold">${p.purchased_item}</td>
                <td class="text-muted">${formatTimestamp(p.purchased_at)}</td>
                <td>
                    <span class="badge bg-warning text-dark rounded-pill">
                        Rs. ${parseFloat(p.cost).toFixed(2)}
                    </span>
                </td>
            </tr>
        `).join('');
    } catch (err) {
        console.error('Failed to load parent purchase log:', err);
    }
}

// ===== Helper: format ISO timestamp into readable date/time =====
function formatTimestamp(iso) {
    const d = new Date(iso);
    return d.toLocaleString('en-US', {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit', hour12: true
    }).replace(',', '');
}

// ===== Top Explorers =====
async function loadTopExplorers() {
    try {
        const res = await fetch('api/top_explorers.php');
        const explorers = await res.json();
        const list = document.getElementById('top-explorers-list');
        list.innerHTML = explorers.map((e, index) => `
            <li class="d-flex align-items-center justify-content-between p-2 mb-2 rounded"
                style="border-left: 4px solid ${index === 0 ? '#f0ad4e' : '#ced4da'}; background:#f8f9fa;">
                <div class="d-flex align-items-center gap-2">
                    <img src="${e.avatar}" width="32" height="32" class="rounded-circle">
                    <div>
                        <div class="fw-bold">${e.name}</div>
                        <small class="text-muted">Age ${e.age}</small>
                    </div>
                </div>
                <span class="badge bg-warning text-dark rounded-pill">
                    🪙 ${e.points} Pts
                </span>
            </li>
        `).join('');
    } catch (err) {
        console.error('Failed to load top explorers:', err);
    }
}

// ===== Run all three on page load =====
document.addEventListener('DOMContentLoaded', () => {
    loadPurchaseLog();
    loadParentPurchaseLog();
    loadTopExplorers();
});

// ===== Save Question (modal) =====
document.getElementById('saveQuestionBtn').addEventListener('click', function () {
    const form = document.getElementById('questionForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    const data = Object.fromEntries(new FormData(form));
    console.log('New question to save:', data);

    // TODO: send to backend, e.g.
    // fetch('api/add_question.php', { method: 'POST', body: new FormData(form) })

    bootstrap.Modal.getInstance(document.getElementById('questionModal')).hide();
    form.reset();
});

// ===== Save Reward Item (modal) =====
document.getElementById('saveRewardBtn').addEventListener('click', function () {
    const form = document.getElementById('rewardForm');
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }
    const data = Object.fromEntries(new FormData(form));
    console.log('New reward item to save:', data);

    // TODO: send to backend, e.g.
    // fetch('api/add_store_item.php', { method: 'POST', body: new FormData(form) })

    bootstrap.Modal.getInstance(document.getElementById('rewardModal')).hide();
    form.reset();
});