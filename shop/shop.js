
        // ─── DATA ───
        let cart = [];
        let currentLanguage = 'en';
        let soundEnabled = true;
        let currentMethod = 'esewa';
        let audioCtx = null;

        // ─── SOUND ENGINE ───
        function playBeep(freq = 600, duration = 100, type = 'sine') {
            if (!soundEnabled) return;
            try {
                if (!audioCtx) {
                    audioCtx = new(window.AudioContext || window.webkitAudioContext)();
                }
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.type = type;
                osc.frequency.value = freq;
                gain.gain.setValueAtTime(0.15, audioCtx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + duration / 1000);
                osc.connect(gain);
                gain.connect(audioCtx.destination);
                osc.start();
                osc.stop(audioCtx.currentTime + duration / 1000);
            } catch (e) { /* silently fail */ }
        }

        function clickSound() { playBeep(800, 60); }

        function removeSound() { playBeep(500, 80, 'triangle'); }

        function successSound() {
            playBeep(880, 120);
            setTimeout(() => playBeep(1100, 120), 150);
        }

        // ─── CART HELPERS ───
        function getCartTotal() {
            return cart.reduce((sum, item) => sum + item.price, 0);
        }

        function updateCartUI() {
            const list = document.getElementById('cartItemsList');
            const totalVal = document.getElementById('cartTotalVal');
            const total = getCartTotal();
            totalVal.textContent = 'Rs. ' + total;

            if (cart.length === 0) {
                list.innerHTML =
                    '<div class="cart-empty-text"><span class="en">Your cart is empty!</span><span class="np">तपाईंको कार्ट खाली छ!</span></div>';
            } else {
                list.innerHTML = cart.map((item, idx) =>
                    `<div class="cart-item-row">
                                <span class="name">${item.name}</span>
                                <span class="price">Rs. ${item.price}</span>
                                <button class="remove-btn" onclick="removeFromCart(${idx})">✕</button>
                            </div>`
                ).join('');
            }

            document.getElementById('fcBadge').textContent = 'Rs. ' + total;
            renderCheckoutPopup();
        }

        function addToCart(name, price) {
            cart.push({ name, price });
            updateCartUI();
            applyLanguage();
            clickSound();
            showSoundNotif('🛒', 'Added: ' + name);
        }

        function removeFromCart(index) {
            cart.splice(index, 1);
            updateCartUI();
            applyLanguage();
            removeSound();
            showSoundNotif('🗑️', 'Removed item');
        }

        function clearCart() {
            if (cart.length === 0) return;
            cart = [];
            updateCartUI();
            applyLanguage();
            renderCheckoutPopup();
            removeSound();
            showSoundNotif('🧹', 'Cart cleared');
        }

        function clearCartFromCheckout() {
            clearCart();
            renderCheckoutPopup();
        }

        // ─── CHECKOUT POPUP ───
        function renderCheckoutPopup() {
            const container = document.getElementById('checkoutItemsList');
            const totalSpan = document.getElementById('checkoutTotalVal');
            const proceedBtn = document.getElementById('checkoutProceedBtn');
            const total = getCartTotal();
            totalSpan.textContent = 'Rs. ' + total;

            if (cart.length === 0) {
                container.innerHTML = `
                            <div class="checkout-empty">
                                <span class="en">Your cart is empty!</span>
                                <span class="np">तपाईंको कार्ट खाली छ!</span>
                            </div>
                        `;
                proceedBtn.disabled = true;
                return;
            }

            container.innerHTML = cart.map((item, idx) =>
                `<div class="checkout-item-row">
                            <span class="item-name">${item.name}</span>
                            <span class="item-price">Rs. ${item.price}</span>
                            <button class="item-remove" onclick="removeFromCheckout(${idx})" title="Remove">✕</button>
                        </div>`
            ).join('');
            proceedBtn.disabled = false;
            applyLanguage();
        }

        function removeFromCheckout(index) {
            removeFromCart(index);
            renderCheckoutPopup();
            updateCartUI();
        }

        function openCheckoutPopup() {
            renderCheckoutPopup();
            document.getElementById('checkoutOverlay').classList.add('open');
            document.body.style.overflow = 'hidden';
            applyLanguage();
            clickSound();
        }

        function closeCheckoutPopup() {
            document.getElementById('checkoutOverlay').classList.remove('open');
            document.body.style.overflow = '';
            clickSound();
        }

        function proceedFromCheckout() {
            if (cart.length === 0) return;
            closeCheckoutPopup();
            clickSound();
            openCheckoutModal();
        }

        // ─── PAYMENT MODAL ───
        function openCheckoutModal() {
            const total = getCartTotal();
            document.getElementById('modalPayAmount').textContent = 'Rs. ' + total;
            document.getElementById('paymentModal').classList.add('open');
            document.body.style.overflow = 'hidden';
            document.getElementById('formSection').style.display = 'block';
            document.getElementById('otpSection').style.display = 'none';
            document.getElementById('processingSection').style.display = 'none';
            document.getElementById('successSection').style.display = 'none';
            document.getElementById('termsCheck').checked = false;
            document.getElementById('proceedBtn').disabled = true;
            document.getElementById('payId').value = '';
            document.getElementById('otpInput').value = '';
            applyLanguage();
            clickSound();
        }

        function closePaymentModal() {
            document.getElementById('paymentModal').classList.remove('open');
            document.body.style.overflow = '';
            clickSound();
        }

        function selectMethod(method) {
            currentMethod = method;
            document.querySelectorAll('.pay-method').forEach(el => el.classList.remove('active'));
            const el = document.getElementById('m-' + method);
            if (el) el.classList.add('active');
            const label = document.getElementById('idLabel');
            if (method === 'esewa') {
                label.innerHTML =
                    '<span class="en">eSewa Mobile Number</span><span class="np">eSewa मोबाइल नम्बर</span>';
                document.getElementById('payId').placeholder = 'e.g. 98XXXXXXXX';
            } else if (method === 'khalti') {
                label.innerHTML =
                    '<span class="en">Khalti Mobile Number</span><span class="np">Khalti मोबाइल नम्बर</span>';
                document.getElementById('payId').placeholder = 'e.g. 98XXXXXXXX';
            } else {
                label.innerHTML =
                    '<span class="en">Bank Account / Customer ID</span><span class="np">बैंक खाता / ग्राहक ID</span>';
                document.getElementById('payId').placeholder = 'e.g. 01-XXXX-XX';
            }
            applyLanguage();
            clickSound();
        }

        function toggleProceed() {
            const checked = document.getElementById('termsCheck').checked;
            document.getElementById('proceedBtn').disabled = !checked;
        }

        function goToOTP() {
            const id = document.getElementById('payId').value.trim();
            if (!id) {
                alert('Please enter your ' + (currentMethod === 'banking' ? 'bank ID' : 'mobile number') + '.');
                return;
            }
            let masked = id;
            if (id.length >= 4) {
                masked = id.slice(0, 2) + '******' + id.slice(-2);
            }
            document.getElementById('otpMasked').textContent = masked;
            document.getElementById('formSection').style.display = 'none';
            document.getElementById('otpSection').style.display = 'block';
            document.getElementById('otpInput').value = '';
            applyLanguage();
            clickSound();
        }

        // ─── UPDATED: accept any 4-digit code ───
        function verifyOTP() {
            const otp = document.getElementById('otpInput').value.trim();
            // Accept any 4-digit numeric code (or any 4 characters for flexibility)
            if (otp.length !== 4 || isNaN(otp)) {
                alert('Please enter a valid 4-digit code.');
                return;
            }
            // Proceed with payment
            document.getElementById('otpSection').style.display = 'none';
            document.getElementById('processingSection').style.display = 'block';

            setTimeout(() => {
                document.getElementById('processingSection').style.display = 'none';
                document.getElementById('successSection').style.display = 'block';
                const txn = 'TXN-' + Date.now().toString().slice(-6);
                document.getElementById('txnId').textContent = txn;
                cart = [];
                updateCartUI();
                renderCheckoutPopup();
                applyLanguage();
                successSound();
                showSoundNotif('✅', 'Payment Successful!');
            }, 2200);
        }

        // ─── LANGUAGE ───
        function toggleLanguage() {
            currentLanguage = currentLanguage === 'en' ? 'np' : 'en';
            document.getElementById('langBtnText').textContent = currentLanguage === 'en' ? 'नेपाली' : 'English';
            applyLanguage();
            clickSound();
        }

        function applyLanguage() {
            const isEn = currentLanguage === 'en';
            document.querySelectorAll('.en').forEach(el => el.style.display = isEn ? '' : 'none');
            document.querySelectorAll('.np').forEach(el => el.style.display = isEn ? 'none' : '');

            // handle all dynamic parts (we do a broad pass)
            const allEn = document.querySelectorAll('.en');
            const allNp = document.querySelectorAll('.np');
            allEn.forEach(el => el.style.display = isEn ? '' : 'none');
            allNp.forEach(el => el.style.display = isEn ? 'none' : '');

            // special for age selector
            const ageVal = document.getElementById('ageSelectorVal');
            if (ageVal) {
                const en = ageVal.querySelector('.en');
                const np = ageVal.querySelector('.np');
                if (en) en.style.display = isEn ? '' : 'none';
                if (np) np.style.display = isEn ? 'none' : '';
            }
        }

        // ─── TABS ───
        function showTab(tab) {
            document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('nav a').forEach(el => el.classList.remove('active'));

            const map = { 'games': 'game-tab', 'progress': 'progress-tab', 'store': 'store-tab' };
            const el = document.getElementById(map[tab]);
            if (el) el.classList.add('active');

            const navMap = { 'games': 'nav-games', 'progress': 'nav-progress', 'store': 'nav-store' };
            const navEl = document.getElementById(navMap[tab]);
            if (navEl) navEl.classList.add('active');

            applyLanguage();
            clickSound();
        }

        // ─── AGE ───
        function toggleAgeSelector() {
            document.getElementById('ageDropdown').classList.toggle('open');
            clickSound();
        }

        function selectAge(age) {
            document.getElementById('ageSelectorVal').setAttribute('data-age', age);
            document.getElementById('ageSelectorVal').innerHTML =
                `<span class="en">Age</span><span class="np">उमेर</span> ${age}`;
            document.querySelectorAll('.age-option').forEach(el => el.classList.remove('selected'));
            document.querySelectorAll('.age-option').forEach(el => {
                if (el.textContent.includes(age)) el.classList.add('selected');
            });
            document.getElementById('ageDropdown').classList.remove('open');
            applyLanguage();
            clickSound();
        }

        // ─── SUBJECT FILTER ───
        function filterSubject(subject, btn) {
            document.querySelectorAll('.subject-btn').forEach(el => el.classList.remove('active'));
            if (btn) btn.classList.add('active');
            showSoundNotif('🔍', 'Filter: ' + (subject === 'all' ? 'All' : subject));
            clickSound();
        }

        // ─── SOUND TOGGLE ───
        function toggleSound() {
            soundEnabled = !soundEnabled;
            const btn = document.getElementById('btnSoundToggle');
            btn.innerHTML = soundEnabled ? '<span>🔊</span>' : '<span>🔇</span>';
            showSoundNotif(soundEnabled ? '🔊' : '🔇', soundEnabled ? 'Sound On' : 'Sound Off');
            if (soundEnabled) {
                playBeep(1000, 80);
            }
        }

        let notifTimer;

        function showSoundNotif(icon, text) {
            const el = document.getElementById('soundNotification');
            document.getElementById('snIcon').textContent = icon;
            document.getElementById('snText').textContent = text;
            el.classList.add('show');
            clearTimeout(notifTimer);
            notifTimer = setTimeout(() => el.classList.remove('show'), 2000);
        }

        // ─── INIT ───
        document.addEventListener('DOMContentLoaded', function() {
            applyLanguage();
            updateCartUI();
            document.addEventListener('click', function(e) {
                const wrapper = document.querySelector('.age-selector-wrapper');
                if (wrapper && !wrapper.contains(e.target)) {
                    document.getElementById('ageDropdown').classList.remove('open');
                }
            });
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    if (document.getElementById('checkoutOverlay').classList.contains('open')) {
                        closeCheckoutPopup();
                    }
                    if (document.getElementById('paymentModal').classList.contains('open')) {
                        closePaymentModal();
                    }
                }
            });
            // init audio context on first user gesture
            document.addEventListener('click', function initAudio() {
                if (!audioCtx) {
                    audioCtx = new(window.AudioContext || window.webkitAudioContext)();
                }
                document.removeEventListener('click', initAudio);
            }, { once: true });
        });
