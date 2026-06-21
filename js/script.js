/* ==========================================
   GYAN SETU JAVASCRIPT
========================================== */


/* ==========================================
   MOBILE NAVIGATION MENU
========================================== */

const menuToggle = document.querySelector(".menu-toggle");

const navWrapper = document.querySelector(".nav-wrapper");


if(menuToggle && navWrapper){

menuToggle.addEventListener("click", function(){

navWrapper.classList.toggle("show");

});

}


/* ==========================================
   CLOSE MENU WHEN NAV LINK IS CLICKED
========================================== */

const dashboardLinks = document.querySelectorAll(".dashboard-menu a");

dashboardLinks.forEach(function(link){

link.addEventListener("click", function(){

if(navWrapper){

navWrapper.classList.remove("show");

}

});

});


/* ==========================================
   CLOSE MENU WHEN HOME PAGE LINKS ARE CLICKED
========================================== */

const homeLinks = document.querySelectorAll(".nav-links a");

homeLinks.forEach(function(link){

link.addEventListener("click", function(){

if(navWrapper){

navWrapper.classList.remove("show");

}

});

});


/* ==========================================
   CLOSE MENU WHEN WINDOW IS RESIZED
========================================== */

window.addEventListener("resize", function(){

if(window.innerWidth > 768){

if(navWrapper){

navWrapper.classList.remove("show");

}

}

});

/* ==========================================
   BILINGUAL TOGGLE (ENGLISH/NEPALI)
========================================== */

const langTranslations = {
    "Gyan Setu": "ज्ञान सेतु",
    "Home": "गृहपृष्ठ",
    "How to Join": "कसरी जोडिने",
    "About Us": "हाम्रो बारेमा",
    "Language": "भाषा",
    "Sign In": "साइन इन",
    "Sign Up": "साइन अप",
    "Made for Nepal's Young Learners": "नेपालका युवा सिकारुहरूका लागि बनाइएको",
    "Play, Learn,": "खेल्नुहोस्, सिक्नुहोस्,",
    "Grow Together": "सँगै बढ्नुहोस्",
    "Gyan Setu is a free bilingual learning adventure for children aged 4–10. Help Setu earn coins, explore stories, solve quizzes, and enjoy learning in both Nepali and English.": "ज्ञान सेतु ४-१० वर्षका बालबालिकाहरूको लागि नि:शुल्क दोभाषे सिकाइ यात्रा हो। सेतुलाई सिक्का कमाउन, कथाहरू अन्वेषण गर्न, प्रश्नोत्तरीहरू हल गर्न, र नेपाली र अंग्रेजी दुवैमा सिक्न मद्दत गर्नुहोस्।",
    "Play for Free 🎮": "नि:शुल्क खेल्नुहोस् 🎮",
    "Create Family Account 👨‍👩‍👧": "पारिवारिक खाता बनाउनुहोस् 👨‍👩‍👧",
    "Learn More ↓": "थप जान्नुहोस् ↓",
    "4-10": "४-१०",
    "Age Range": "उमेर समूह",
    "2": "२",
    "Languages": "भाषाहरू",
    "5+": "५+",
    "Games": "खेलहरू",
    "What's Inside?": "भित्र के छ?",
    "Everything a young learner needs": "युवा सिकारुलाई चाहिने सबै कुरा",
    "A complete learning ecosystem — games, tracking, worksheets, and parental oversight in one place.": "एक पूर्ण सिकाइ इकोसिस्टम - खेलहरू, ट्र्याकिङ, कार्यपत्रहरू, र अभिभावकीय निगरानी एकै ठाउँमा।",
    "Bilingual": "दोभाषे",
    "One-click switch between Nepali and English for all content, games, and interface elements.": "सबै सामग्री, खेल र इन्टरफेस तत्वहरूको लागि नेपाली र अंग्रेजी बीच एक-क्लिक स्विच।",
    "Family Account": "पारिवारिक खाता",
    "Track each child's progress, reset chapters, print reports, and manage your child's profile.": "प्रत्येक बच्चाको प्रगति ट्र्याक गर्नुहोस्, अध्यायहरू रिसेट गर्नुहोस्, रिपोर्टहरू छाप्नुहोस्, र आफ्नो बच्चाको प्रोफाइल व्यवस्थापन गर्नुहोस्।",
    "Coin Rewards": "सिक्का पुरस्कार",
    "Earn coins by playing. Spend them in the shop on printable worksheets and bonus content.": "खेलेर सिक्का कमाउनुहोस्। प्रिन्ट गर्न मिल्ने कार्यपत्र र बोनस सामग्रीका लागि पसलमा खर्च गर्नुहोस्।",
    "Progress Tracking": "प्रगति ट्र्याकिङ",
    "Parents can check how many coins each child earned, which chapters they reached and their scores.": "अभिभावकहरूले प्रत्येक बच्चाले कति सिक्का कमाए, कुन अध्यायमा पुगे र उनीहरूको स्कोर जाँच गर्न सक्छन्।",
    "Sponsor a Child's Education": "बच्चाको शिक्षा प्रायोजन गर्नुहोस्",
    "Help us reach more children": "हामीलाई थप बालबालिकामा पुग्न मद्दत गर्नुहोस्",
    "Because we kept Premium affordable, your donation goes incredibly far.": "हामीले प्रिमियमलाई किफायती राखेको हुनाले, तपाईंको दानले ठूलो सहयोग पुर्याउँछ।",
    "Gives a child 15 days of full Premium access": "बच्चालाई १५ दिनको पूर्ण प्रिमियम पहुँच दिन्छ",
    "Sponsors one child for a complete month of learning": "एक बच्चालाई पूरा एक महिनाको सिकाइको लागि प्रायोजन गर्दछ",
    "Funds a full quarter (3 months) for one family": "एउटा परिवारको लागि पूरा त्रैमासिक (३ महिना) कोष दिन्छ",
    "Sponsors 5 children for a full month each": "५ बालबालिकालाई एक महिनाको लागि प्रायोजन गर्दछ",
    "Gives one child a full year of Premium access": "एक बच्चालाई एक वर्षको पूर्ण प्रिमियम पहुँच दिन्छ",
    "Sponsor a child": "बालबालिका प्रायोजन गर्नुहोस्",
    "Rs 150": "रु १५०",
    "Rs 300": "रु ३००",
    "Rs 600": "रु ६००",
    "Rs 1500": "रु १५००",
    "Rs": "रु",
    "Enter custom amount": "आफू अनुकूल रकम प्रविष्ट गर्नुहोस्",
    "Pay": "भुक्तानी",
    "Donate Now": "अहिले दान गर्नुहोस्",
    "Children sponsored so far": "अहिलेसम्म प्रायोजित बालबालिकाहरू",
    "Generous Donors": "उदार दाताहरू",
    "Total Raised": "कुल संकलन",
    "Need sponsored access for your family?": "तपाईंको परिवारको लागि प्रायोजित पहुँच चाहिन्छ?",
    "If Rs. XX/month is beyond your means, apply here.": "यदि रु. XX/महिना तपाइँको क्षमता भन्दा बाहिर छ भने, यहाँ आवेदन दिनुहोस्।",
    "Apply for free access →": "नि:शुल्क पहुँचको लागि आवेदन दिनुहोस् →",
    "A fun bilingual learning platform helping Nepal's children learn, play and grow together.": "नेपालका बालबालिकालाई सँगै सिक्न, खेल्न र हुर्कन मद्दत गर्ने एउटा रमाइलो दोभाषे सिकाइ प्लेटफर्म।",
    "Quick Links": "द्रुत लिङ्कहरू",
    "Resources": "स्रोतहरू",
    "Privacy Policy": "गोपनीयता नीति",
    "Terms & Conditions": "नियम र सर्तहरू",
    "Contact": "सम्पर्क",
    "Connect": "जडान गर्नुहोस्",
    "Email": "इमेल",
    "© 2025 Gyan Setu. All rights reserved.": "© २०२५ ज्ञान सेतु। सबै अधिकार सुरक्षित।"
};

const reverseTranslations = {};
for(let key in langTranslations) {
    reverseTranslations[langTranslations[key]] = key;
}

let currentLang = localStorage.getItem('gyansetu_lang') || 'en';

function translateNode(node, dict) {
    if (node.nodeType === Node.TEXT_NODE) {
        let text = node.nodeValue.trim();
        if (text && dict[text]) {
            node.nodeValue = node.nodeValue.replace(text, dict[text]);
        }
    } else if (node.nodeType === Node.ELEMENT_NODE) {
        if (node.tagName === 'SCRIPT' || node.tagName === 'STYLE') return;
        if (node.placeholder && dict[node.placeholder.trim()]) {
            node.placeholder = dict[node.placeholder.trim()];
        }
        for (let child of node.childNodes) {
            translateNode(child, dict);
        }
    }
}

function updateLanguage(lang) {
    const dict = lang === 'ne' ? langTranslations : reverseTranslations;
    translateNode(document.body, dict);
    localStorage.setItem('gyansetu_lang', lang);
}

document.addEventListener('DOMContentLoaded', () => {
    const langBtn = document.querySelector('.language-btn');
    if (langBtn) {
        langBtn.addEventListener('click', function(e) {
            e.preventDefault();
            currentLang = currentLang === 'en' ? 'ne' : 'en';
            updateLanguage(currentLang);
        });
    }

    if (currentLang === 'ne') {
        updateLanguage('ne');
    }
});