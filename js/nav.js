/**
 * js/nav.js – Shared Navigation Bar Loader & Interactivity
 */
(async function loadSharedNav() {
    try {
        const placeholder = document.getElementById('nav-placeholder');
        if (!placeholder) return;

        const response = await fetch('nav.html');
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const navHTML = await response.text();
        placeholder.innerHTML = navHTML;

        // Initialize nav interactivity, mascot avatar & active link highlight
        initNavInteractivity();
        highlightActiveLink();
        updateProfileMascot();
    } catch (err) {
        console.error('Failed to load navigation bar:', err);
    }
})();

function updateProfileMascot() {
    const mascot = window.USER_MASCOT || document.body.getAttribute('data-user-mascot');
    const name = window.USER_NAME || document.body.getAttribute('data-user-name');

    if (mascot) {
        const avatarBtn = document.getElementById('profileAvatarBtn');
        if (avatarBtn) {
            avatarBtn.textContent = mascot;
        }
    }
    if (name) {
        const dhName = document.querySelector('.dropdown-header .dh-name');
        if (dhName) {
            dhName.textContent = name;
        }
    }
}

function initNavInteractivity() {
    // 1. Profile Dropdown Toggle
    const avatarBtn = document.getElementById('profileAvatarBtn');
    const dropdownMenu = document.getElementById('profileDropdownMenu');
    const dropdownWrapper = document.getElementById('profileDropdownWrapper');

    if (avatarBtn && dropdownMenu) {
        avatarBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            const isOpen = dropdownMenu.classList.toggle('open');
            avatarBtn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
        });

        document.addEventListener('click', function (e) {
            if (dropdownWrapper && !dropdownWrapper.contains(e.target)) {
                dropdownMenu.classList.remove('open');
                avatarBtn.setAttribute('aria-expanded', 'false');
            }
        });
    }

    // 2. Mobile Navigation Toggle
    const toggleBtn = document.getElementById('menuToggleBtn');
    const navWrapper = document.querySelector('.nav-wrapper');

    if (toggleBtn && navWrapper) {
        toggleBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            const isOpen = navWrapper.classList.toggle('show');
            toggleBtn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
            toggleBtn.innerHTML = isOpen ? '&#10005;' : '&#9776;';
        });

        navWrapper.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', function () {
                navWrapper.classList.remove('show');
                toggleBtn.setAttribute('aria-expanded', 'false');
                toggleBtn.innerHTML = '&#9776;';
            });
        });

        document.addEventListener('click', function (e) {
            if (!navWrapper.contains(e.target) && !toggleBtn.contains(e.target)) {
                navWrapper.classList.remove('show');
                toggleBtn.setAttribute('aria-expanded', 'false');
                toggleBtn.innerHTML = '&#9776;';
            }
        });
    }
}

function highlightActiveLink() {
    const currentPath = window.location.pathname.split('/').pop() || 'child-dashboard.php';
    const menuLinks = document.querySelectorAll('.dashboard-menu a');

    menuLinks.forEach(link => {
        const linkPath = link.getAttribute('href').split('?')[0].split('/').pop();
        if (linkPath === currentPath) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
}
