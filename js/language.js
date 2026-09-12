// Language Toggle Script

function toggleLanguage(lang) {
    // Update all data-en and data-ne elements
    const elements = document.querySelectorAll('[data-en]');
    
    elements.forEach(el => {
        if (el.closest && (
            el.closest('.logo') ||
            el.closest('.footer-logo') ||
            el.closest('[translate="no"]') ||
            el.closest('.no-translate')
        )) {
            return;
        }

        if (lang === 'ne' && el.dataset.ne) {
            el.textContent = el.dataset.ne;
        } else if (lang === 'en' && el.dataset.en) {
            el.textContent = el.dataset.en;
        }
    });

    // Update checkbox state if present
    const langCheckbox = document.getElementById('lang-toggle-checkbox');
    if (langCheckbox) {
        langCheckbox.checked = (lang === 'ne');
    }

    // Update legacy button active states if present
    const enBtn = document.getElementById('en-btn');
    const neBtn = document.getElementById('ne-btn');
    document.querySelectorAll('.lang-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    if (lang === 'en' && enBtn) {
        enBtn.classList.add('active');
    } else if (lang === 'ne' && neBtn) {
        neBtn.classList.add('active');
    }

    // Save to localStorage
    localStorage.setItem('gyansetu_lang', lang);

    // Update HTML lang attribute
    document.documentElement.lang = lang;
}

// Attach event listeners and load saved language
document.addEventListener('DOMContentLoaded', () => {
    const langCheckbox = document.getElementById('lang-toggle-checkbox');
    if (langCheckbox) {
        langCheckbox.addEventListener('change', function() {
            toggleLanguage(this.checked ? 'ne' : 'en');
        });
    }

    const savedLang = localStorage.getItem('gyansetu_lang') || 'en';
    toggleLanguage(savedLang);
});