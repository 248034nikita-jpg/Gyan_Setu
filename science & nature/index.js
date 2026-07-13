
        // ============================================================
        //  LANGUAGE TOGGLE (Simplest possible)
        // ============================================================
        function toggleLanguage() {
            document.body.classList.toggle('lang-np');
            const btn = document.getElementById('langBtnText');
            if (document.body.classList.contains('lang-np')) {
                btn.textContent = 'English';
                showToast('भाषा: नेपाली');
            } else {
                btn.textContent = 'नेपाली';
                showToast('Language: English');
            }
        }

        // ============================================================
        //  SOUND TOGGLE
        // ============================================================
        let isSoundOn = true;
        const soundBtn = document.getElementById('btnSoundToggle');
        const soundNotif = document.getElementById('soundNotification');
        const snIcon = document.getElementById('snIcon');
        const snText = document.getElementById('snText');

        function toggleSound() {
            isSoundOn = !isSoundOn;
            soundBtn.innerHTML = isSoundOn ? '🔊' : '🔇';
            if (isSoundOn) {
                snIcon.textContent = '🔊';
                snText.textContent = 'Sound On';
                soundNotif.className = 'sound-notification sn-on show';
            } else {
                snIcon.textContent = '🔇';
                snText.textContent = 'Sound Off';
                soundNotif.className = 'sound-notification sn-off show';
            }
            clearTimeout(window._soundTimer);
            window._soundTimer = setTimeout(() => soundNotif.classList.remove('show'), 1500);
        }

        // ============================================================
        //  TAB SWITCHING
        // ============================================================
        function showTab(tabId) {
            const map = { games: 'game-tab', progress: 'progress-tab', store: 'store-tab' };
            document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
            const t = document.getElementById(map[tabId]);
            if (t) t.classList.add('active');

            document.querySelectorAll('header nav a').forEach(el => el.classList.remove('active'));
            const link = document.getElementById('nav-' + tabId);
            if (link) link.classList.add('active');

            const titles = {
                games: { en: 'Play & Learn', np: 'खेलौं र सिकौं' },
                progress: { en: 'My Progress Dashboard', np: 'मेरो प्रगति ड्यासबोर्ड' },
                store: { en: 'Parent Shop', np: 'अभिभावक पसल' }
            };
            const icons = { games: '🎮', progress: '📊', store: '🛍️' };
            const isNp = document.body.classList.contains('lang-np');
            document.querySelector('#pageTitle .en').textContent = titles[tabId].en;
            document.querySelector('#pageTitle .np').textContent = titles[tabId].np;
            document.querySelector('#pageTitle .icon').textContent = icons[tabId] || '🎮';
        }

        // ============================================================
        //  SUBJECT FILTER
        // ============================================================
        function filterSubject(subject, btn) {
            document.querySelectorAll('.subject-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            document.querySelectorAll('.game-card').forEach(card => {
                const sub = card.getAttribute('data-subject');
                card.style.display = (subject === 'all' || sub === subject) ? 'flex' : 'none';
            });
        }

        // ============================================================
        //  AGE SELECTOR
        // ============================================================
        function toggleAgeSelector() {
            const d = document.getElementById('ageDropdown');
            d.style.display = d.style.display === 'block' ? 'none' : 'block';
        }

        function selectAge(val) {
            const el = document.getElementById('ageSelectorVal');
            el.setAttribute('data-age', val);
            const isNp = document.body.classList.contains('lang-np');
            el.innerHTML = `
                <span class="en">Age</span>
                <span class="np">उमेर</span>
                ${val}
            `;
            document.querySelectorAll('.age-option').forEach(o => o.classList.remove('selected'));
            event.target.classList.add('selected');
            document.getElementById('ageDropdown').style.display = 'none';
            showToast((isNp ? 'उमेर' : 'Age') + ' changed to ' + val);
        }
        document.addEventListener('click', function(e) {
            const wrap = document.querySelector('.age-selector-wrapper');
            if (wrap && !wrap.contains(e.target)) document.getElementById('ageDropdown').style.display = 'none';
        });

        // ============================================================
        //  TOAST
        // ============================================================
        function showToast(msg) {
            const c = document.getElementById('toastContainer');
            const t = document.createElement('div');
            t.className = 'toast';
            t.textContent = msg;
            c.appendChild(t);
            setTimeout(() => t.remove(), 2500);
        }

        // ============================================================
        //  MATH GAME
        // ============================================================
        let activeAnswer = 0;

        function startMathGame() {
            document.getElementById('mainGameGrid').style.display = 'none';
            document.getElementById('mathGameBox').style.display = 'block';
            generateQuestion();
        }

        function generateQuestion() {
            const a = Math.floor(Math.random() * 8) + 2;
            const b = Math.floor(Math.random() * 8) + 1;
            activeAnswer = a + b;
            document.getElementById('mathQuestion').textContent = `${a} + ${b} = ?`;
            let opts = [activeAnswer];
            while (opts.length < 4) {
                let w = activeAnswer + (Math.random() > 0.5 ? 1 : -1) * (Math.floor(Math.random() * 4) + 1);
                if (w > 0 && !opts.includes(w)) opts.push(w);
            }
            opts.sort(() => Math.random() - 0.5);
            const box = document.getElementById('mathOptions');
            box.innerHTML = '';
            opts.forEach(o => {
                box.innerHTML += `<button class="option-btn" onclick="checkAnswer(${o},this)">${o}</button>`;
            });
        }

        function checkAnswer(selected, el) {
            if (selected === activeAnswer) {
                el.style.background = '#d1fae5';
                el.style.borderColor = '#22c55e';
                let coins = parseInt(document.getElementById('headerCoins').textContent) + 10;
                document.getElementById('headerCoins').textContent = coins;
                document.getElementById('statCoins').textContent = coins;
                showToast('+10 Coins!');
                setTimeout(() => {
                    document.getElementById('mathGameBox').style.display = 'none';
                    document.getElementById('mainGameGrid').style.display = 'grid';
                }, 1000);
            } else {
                el.style.background = '#fee2e2';
                el.style.borderColor = '#f43f5e';
            }
        }

        function startScienceQuiz() { showToast('🌌 Space module coming soon!'); }

        // ============================================================
        //  STORYBOOK
        // ============================================================
        const stories = [{
            title: "The Thirsty Crow",
            left: "Once, a thirsty crow searched everywhere in a hot village for fresh water. Suddenly, he spotted a pitcher with a little bit of water at the very bottom.",
            right: "He couldn't reach it! So, he dropped small pebbles into the pitcher one-by-one. The water rose and he drank happily! Moral: Where there is a will, there is a way."
        }];

        function openStoryBook(idx) {
            const s = stories[idx];
            document.getElementById('storyModalTitleText').textContent = s.title;
            document.getElementById('storyPageLeft').textContent = s.left;
            document.getElementById('storyPageRight').textContent = s.right;
            document.getElementById('storyModal').style.display = 'flex';
        }

        function closeStoryBook() {
            document.getElementById('storyModal').style.display = 'none';
            let b = parseInt(document.getElementById('statBooks').textContent) + 1;
            document.getElementById('statBooks').textContent = b;
            showToast('Story finished! +1 book');
        }

        function handleStoryPrev() { showToast('Already on page 1'); }

        function handleStoryNext() { closeStoryBook(); }

        // ============================================================
        //  STORE & CART
        // ============================================================
        let cart = [];

        function addToCart(name, price) {
            cart.push({ name, price, id: Date.now() });
            updateCartUI();
            showToast(name + ' added to cart!');
        }

        function removeFromCart(id) {
            cart = cart.filter(item => item.id !== id);
            updateCartUI();
        }

        function clearCart() {
            cart = [];
            updateCartUI();
        }

        function updateCartUI() {
            const list = document.getElementById('cartItemsList');
            const totalEl = document.getElementById('cartTotalVal');
            const badge = document.getElementById('fcBadge');
            const floatBtn = document.getElementById('floatingCheckout');

            list.innerHTML = '';
            let total = 0;
            if (cart.length === 0) {
                const isNp = document.body.classList.contains('lang-np');
                list.innerHTML = `<div class="cart-empty-text">
                    <span class="en">Your cart is empty!</span>
                    <span class="np">तपाईंको कार्ट खाली छ!</span>
                </div>`;
                totalEl.textContent = 'Rs. 0';
                badge.textContent = 'Rs. 0';
                floatBtn.classList.remove('show');
                return;
            }
            floatBtn.classList.add('show');

            cart.forEach(item => {
                total += item.price;
                const div = document.createElement('div');
                div.className = 'cart-item';
                div.innerHTML = `
                    <div class="cart-item-info">
                        <span class="cart-item-name">${item.name}</span>
                        <span class="cart-item-price">Rs. ${item.price}</span>
                    </div>
                    <button class="remove-btn" onclick="removeFromCart(${item.id})">✕</button>
                `;
                list.appendChild(div);
            });
            totalEl.textContent = `Rs. ${total}`;
            badge.textContent = `Rs. ${total}`;
        }

        // ============================================================
        //  PAYMENT MODAL
        // ============================================================
        let selectedMethod = 'esewa';
        const expectedOTP = '1234';

        function toggleProceed() {
            document.getElementById('proceedBtn').disabled = !document.getElementById('termsCheck').checked;
        }

        function openCheckoutModal() {
            const total = document.getElementById('cartTotalVal').textContent;
            if (total === 'Rs. 0' || cart.length === 0) {
                showToast('Cart is empty!');
                return;
            }
            document.getElementById('paymentModal').classList.add('open');
            document.getElementById('formSection').style.display = 'block';
            document.getElementById('otpSection').style.display = 'none';
            document.getElementById('processingSection').style.display = 'none';
            document.getElementById('successSection').style.display = 'none';
            document.getElementById('payId').value = '';
            document.getElementById('otpInput').value = '';
            document.getElementById('termsCheck').checked = false;
            document.getElementById('proceedBtn').disabled = true;
            document.getElementById('modalPayAmount').textContent = total;
            selectMethod('esewa');
        }

        function closePaymentModal() {
            document.getElementById('paymentModal').classList.remove('open');
        }

        function selectMethod(method) {
            selectedMethod = method;
            document.querySelectorAll('.pay-method').forEach(el => el.classList.remove('active'));
            document.getElementById('m-' + method).classList.add('active');

            const labels = {
                esewa: { en: 'eSewa Mobile Number', np: 'eSewa मोबाइल नम्बर' },
                khalti: { en: 'Khalti Mobile Number', np: 'Khalti मोबाइल नम्बर' },
                banking: { en: 'Bank Account / App ID', np: 'बैंक खाता / एप ID' }
            };
            const isNp = document.body.classList.contains('lang-np');
            document.getElementById('idLabel').innerHTML = `
                <span class="en">${labels[method].en}</span>
                <span class="np">${labels[method].np}</span>
            `;
            document.getElementById('payId').value = '';
        }

        function goToOTP() {
            const val = document.getElementById('payId').value.trim();
            if (selectedMethod === 'esewa' || selectedMethod === 'khalti') {
                if (!/^\d{10}$/.test(val)) {
                    alert('Please enter a valid 10-digit mobile number.');
                    document.getElementById('payId').focus();
                    return;
                }
            } else {
                if (val.length < 4) {
                    alert('Please enter a valid Bank Account / App ID.');
                    document.getElementById('payId').focus();
                    return;
                }
            }
            let masked = val;
            if (selectedMethod !== 'banking') {
                masked = val.slice(0, 2) + '******' + val.slice(-2);
            } else {
                masked = val.slice(0, 2) + '****' + val.slice(-2);
            }
            document.getElementById('otpMasked').textContent = masked;

            document.getElementById('formSection').style.display = 'none';
            document.getElementById('otpSection').style.display = 'block';
            document.getElementById('otpInput').value = '';
            document.getElementById('otpInput').focus();
        }
        function verifyOTP() {
    document.getElementById('otpSection').style.display = 'none';
    document.getElementById('processingSection').style.display = 'block';

    setTimeout(() => {
        document.getElementById('processingSection').style.display = 'none';
        document.getElementById('successSection').style.display = 'block';

        // ===== ADD THIS =====
        // Get current coins
        let currentCoins = parseInt(document.getElementById('headerCoins').textContent);

        // Get total cart amount (remove "Rs. " and convert to number)
        let totalText = document.getElementById('cartTotalVal').textContent;
        let totalAmount = parseInt(totalText.replace('Rs. ', ''));

        // Deduct from coins
        let newCoins = currentCoins - totalAmount;

        // Make sure coins don't go negative
        if (newCoins < 0) newCoins = 0;

        // Update both displays
        document.getElementById('headerCoins').textContent = newCoins;
        document.getElementById('statCoins').textContent = newCoins;
        // ===== END OF ADDED CODE =====

        // Generate transaction ID
        const date = new Date();
        const ts = date.getFullYear() +
            String(date.getMonth() + 1).padStart(2, '0') +
            String(date.getDate()).padStart(2, '0');
        const rand = Math.random().toString(36).substring(2, 8).toUpperCase();
        document.getElementById('txnId').textContent = `TXN-${ts}-${rand}`;

        cart = [];
        updateCartUI();
    }, 1800);
}

        // ============================================================
        //  ESC & ENTER
        // ============================================================
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                if (document.getElementById('paymentModal').classList.contains('open')) closePaymentModal();
                if (document.getElementById('storyModal').style.display === 'flex') closeStoryBook();
            }
            if (e.key === 'Enter') {
                if (document.getElementById('otpSection').style.display === 'block') verifyOTP();
            }
        });

        // ============================================================
        //  INIT
        // ============================================================
        document.addEventListener('DOMContentLoaded', function() {
            updateCartUI();
        });
