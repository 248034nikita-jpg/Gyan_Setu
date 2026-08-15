        /* ─── STATE ─── */
        let cart = [];
        let currentLang = 'en'; // 'en' or 'np'
        let soundOn = true;
        let selectedMethod = 'esewa';
        let otpCode = '1234'; // demo

        /* ─── DOM REFS ─── */
        const cartItemsList = document.getElementById('cartItemsList');
        const cartTotalVal = document.getElementById('cartTotalVal');
        const fcBadge = document.getElementById('fcBadge');
        const checkoutItemsList = document.getElementById('checkoutItemsList');
        const checkoutTotalVal = document.getElementById('checkoutTotalVal');
        const checkoutProceedBtn = document.getElementById('checkoutProceedBtn');
        const checkoutEmpty = document.getElementById('checkoutEmpty');
        const modalPayAmount = document.getElementById('modalPayAmount');
        const termsCheck = document.getElementById('termsCheck');
        const proceedBtn = document.getElementById('proceedBtn');
        const payId = document.getElementById('payId');
        const otpInput = document.getElementById('otpInput');

        /* ─── LANGUAGE TOGGLE ─── */
        function toggleLanguage() {
            currentLang = currentLang === 'en' ? 'np' : 'en';
            const btnText = document.getElementById('langBtnText');
            btnText.textContent = currentLang === 'en' ? 'नेपाली' : 'English';

            document.querySelectorAll('.en').forEach(el => el.style.display = currentLang === 'en' ? '' : 'none');
            document.querySelectorAll('.np').forEach(el => el.style.display = currentLang === 'np' ? '' : 'none');
        }

        // initial: hide nepali
        document.querySelectorAll('.np').forEach(el => el.style.display = 'none');

        /* ─── SOUND TOGGLE ─── */
        function toggleSound() {
            soundOn = !soundOn;
            const btn = document.getElementById('btnSoundToggle');
            const notif = document.getElementById('soundNotification');
            const icon = document.getElementById('snIcon');
            const text = document.getElementById('snText');
            if (soundOn) {
                btn.innerHTML = '<span>🔊</span>';
                icon.textContent = '🔊';
                text.textContent = currentLang === 'en' ? 'Sound On' : 'ध्वनि चालू';
            } else {
                btn.innerHTML = '<span>🔇</span>';
                icon.textContent = '🔇';
                text.textContent = currentLang === 'en' ? 'Sound Off' : 'ध्वनि बन्द';
            }
            notif.classList.add('show');
            clearTimeout(window._soundNotifTimer);
            window._soundNotifTimer = setTimeout(() => notif.classList.remove('show'), 1500);
        }

        /* ─── CART HELPERS ─── */
        function addToCart(name, price) {
            const existing = cart.find(item => item.name === name);
            if (existing) {
                existing.qty += 1;
            } else {
                cart.push({ name, price, qty: 1 });
            }
            renderAll();
            showFloatingFeedback('Added: ' + name);
        }

        function removeFromCart(name) {
            cart = cart.filter(item => item.name !== name);
            renderAll();
        }

        function clearCart() {
            cart = [];
            renderAll();
        }

        function clearCartFromCheckout() {
            cart = [];
            renderAll();
            closeCheckoutPopup();
        }

        function getTotal() {
            return cart.reduce((sum, item) => sum + item.price * item.qty, 0);
        }

        function renderAll() {
            renderCartPanel();
            renderCheckoutPopup();
            updateFloatingBadge();
        }

        function renderCartPanel() {
            if (cart.length === 0) {
                cartItemsList.innerHTML =
                    `<div class="cart-empty-text"><span class="en">Your cart is empty!</span><span class="np">तपाईंको कार्ट खाली छ!</span></div>`;
                cartTotalVal.textContent = 'Rs. 0';
                return;
            }
            let html = '';
            cart.forEach(item => {
                const nameEn = item.name;
                const nameNp = getNepaliName(item.name);
                html += `
                    <div class="cart-item-row">
                        <span>
                            <span class="en">${nameEn}</span>
                            <span class="np">${nameNp}</span>
                            <span class="qty">×${item.qty}</span>
                        </span>
                        <span>
                            <span class="price">Rs. ${item.price * item.qty}</span>
                            <button class="remove-btn" onclick="removeFromCart('${item.name}')">✕</button>
                        </span>
                    </div>
                `;
            });
            cartItemsList.innerHTML = html;
            cartTotalVal.textContent = 'Rs. ' + getTotal();
        }

        function renderCheckoutPopup() {
            const list = document.getElementById('checkoutItemsList');
            const empty = document.getElementById('checkoutEmpty');
            const total = document.getElementById('checkoutTotalVal');
            const btn = document.getElementById('checkoutProceedBtn');

            if (cart.length === 0) {
                list.innerHTML =
                    `<div class="checkout-empty"><span class="en">Your cart is empty!</span><span class="np">तपाईंको कार्ट खाली छ!</span></div>`;
                total.textContent = 'Rs. 0';
                btn.disabled = true;
                return;
            }
            let html = '';
            cart.forEach(item => {
                const nameEn = item.name;
                const nameNp = getNepaliName(item.name);
                html += `
                    <div class="checkout-item-row">
                        <span>
                            <span class="en">${nameEn}</span>
                            <span class="np">${nameNp}</span>
                            <span class="qty">×${item.qty}</span>
                        </span>
                        <span>
                            <span class="price">Rs. ${item.price * item.qty}</span>
                            <button class="remove-btn" onclick="removeFromCart('${item.name}'); renderAll();">✕</button>
                        </span>
                    </div>
                `;
            });
            list.innerHTML = html;
            total.textContent = 'Rs. ' + getTotal();
            btn.disabled = false;
        }

        function updateFloatingBadge() {
            fcBadge.textContent = 'Rs. ' + getTotal();
        }

        function showFloatingFeedback(msg) {
            console.log(msg);
        }

        function getNepaliName(enName) {
            const map = {
                'Math Worksheets PDF': 'गणित कार्यपत्र PDF',
                'Math Quiz App': 'गणित क्विज एप',
                'Numbers are Fun eBook': '"नम्बर रमाइलो छ" ईबुक',
                'Alphabet Printables': 'वर्णमाला प्रिन्ट सामग्री',
                'Cursive Writing Course': 'कर्सिव लेखन पाठ्यक्रम',
                'Story eBook Boxset': 'नैतिक कथा ईबुक सेट',
                'Plant Growth Worksheets': 'बिरुवा वृद्धि कार्यपत्र',
                'Solar System VR': 'सौर्यमण्डल VR',
                'Science Experiment Videos': 'विज्ञान प्रयोग भिडियोहरू'
            };
            return map[enName] || enName;
        }

        /* ─── CHECKOUT POPUP ─── */
        function openCheckoutPopup() {
            document.getElementById('checkoutOverlay').classList.add('open');
            renderCheckoutPopup();
        }

        function closeCheckoutPopup() {
            document.getElementById('checkoutOverlay').classList.remove('open');
        }

        function proceedFromCheckout() {
            if (cart.length === 0) return;
            closeCheckoutPopup();
            openPaymentModal();
        }

        /* ─── PAYMENT MODAL ─── */
        function openPaymentModal() {
            const total = getTotal();
            if (total === 0) return;
            document.getElementById('paymentModal').classList.add('open');
            modalPayAmount.textContent = 'Rs. ' + total;
            document.getElementById('formSection').style.display = 'block';
            document.getElementById('otpSection').classList.remove('active');
            document.getElementById('processingSection').classList.remove('active');
            document.getElementById('successSection').classList.remove('active');
            termsCheck.checked = false;
            proceedBtn.disabled = true;
            payId.value = '';
            otpInput.value = '';
            selectMethod('esewa');
        }

        function closePaymentModal() {
            document.getElementById('paymentModal').classList.remove('open');
            document.getElementById('formSection').style.display = 'block';
            document.getElementById('otpSection').classList.remove('active');
            document.getElementById('processingSection').classList.remove('active');
            document.getElementById('successSection').classList.remove('active');
        }

        function selectMethod(method) {
            selectedMethod = method;
            document.querySelectorAll('.pay-method').forEach(el => el.classList.remove('active'));
            const map = { esewa: 'm-esewa', khalti: 'm-khalti', banking: 'm-banking' };
            const el = document.getElementById(map[method]);
            if (el) el.classList.add('active');

            const label = document.getElementById('idLabel');
            const input = document.getElementById('payId');
            if (method === 'esewa') {
                label.innerHTML =
                    '<span class="en">eSewa Mobile Number</span><span class="np">eSewa मोबाइल नम्बर</span>';
                input.placeholder = 'e.g. 98XXXXXXXX';
            } else if (method === 'khalti') {
                label.innerHTML =
                    '<span class="en">Khalti Mobile Number</span><span class="np">Khalti मोबाइल नम्बर</span>';
                input.placeholder = 'e.g. 98XXXXXXXX';
            } else {
                label.innerHTML =
                    '<span class="en">Bank Account Number</span><span class="np">बैंक खाता नम्बर</span>';
                input.placeholder = 'e.g. 01-XXXX-XX';
            }
        }

        function toggleProceed() {
            proceedBtn.disabled = !termsCheck.checked;
        }

        function goToOTP() {
            if (!termsCheck.checked) return;
            const idVal = payId.value.trim();
            if (!idVal) {
                alert(currentLang === 'en' ? 'Please enter your payment ID.' : 'कृपया तपाईंको भुक्तान आईडी प्रविष्ट गर्नुहोस्।');
                return;
            }
            const masked = idVal.length > 4 ? idVal.slice(0, 2) + '******' + idVal.slice(-2) : '98******XX';
            document.getElementById('otpMasked').textContent = masked;

            document.getElementById('formSection').style.display = 'none';
            document.getElementById('otpSection').classList.add('active');
            otpInput.value = '';
            otpInput.focus();
        }

        function verifyOTP() {
            const code = otpInput.value.trim();
            if (code.length !== 4) {
                alert(currentLang === 'en' ? 'Please enter a 4-digit OTP.' : 'कृपया ४-अंक OTP प्रविष्ट गर्नुहोस्।');
                return;
            }
            document.getElementById('otpSection').classList.remove('active');
            document.getElementById('processingSection').classList.add('active');

            setTimeout(() => {
                document.getElementById('processingSection').classList.remove('active');
                document.getElementById('successSection').classList.add('active');
                const txn = 'TXN-' + String(Math.floor(100000 + Math.random() * 900000));
                document.getElementById('txnId').textContent = txn;
                cart = [];
                renderAll();
            }, 2000);
        }

        /* ─── KEYBOARD: Enter on OTP ─── */
        document.getElementById('otpInput')?.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') verifyOTP();
        });

        /* ─── INIT ─── */
        renderAll();

        console.log('🛍️ ज्ञान_Setu — Parent Shop ready.');
