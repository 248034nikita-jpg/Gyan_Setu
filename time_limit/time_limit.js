/**
 * time_limit/time_limit.js - Safe Screentime Mode Client Tracker
 * Utilizes Page Visibility API to count down screentime only when browser tab is active.
 * Shows non-disruptive 5-minute warning prompt during games and time-out modal when expired.
 */

(function () {
    let remainingSeconds = null;
    let currentLimitMinutes = null;
    let isUnlimited = false;
    let isExpired = false;
    let isChildSession = false;
    let tickInterval = null;
    let unsyncedSeconds = 0;
    let isWarningShown = sessionStorage.getItem('screentime_warned_5m') === 'true';

    // Helper to calculate API URL relative to root
    function getApiUrl() {
        const urlParams = new URLSearchParams(window.location.search);
        const urlChildId = urlParams.get('child_id');
        if (urlChildId && urlChildId !== '0') {
            localStorage.setItem('child_id', urlChildId);
            localStorage.setItem('active_child_id', urlChildId);
        }
        const childId = urlChildId || localStorage.getItem('child_id') || localStorage.getItem('active_child_id') || (window.CHILD_ID ? String(window.CHILD_ID) : '');
        const base = getSiteUrl('time_limit/screentime_api.php');
        if (childId && childId !== '0') {
            return `${base}?child_id=${encodeURIComponent(childId)}`;
        }
        return base;
    }

    // Helper to build a correct relative path to a root-level page (e.g. grownup-gate.php)
    // Works regardless of how many folders deep the current page is inside Gyan_Setu/
    function getSiteUrl(page) {
        const parts = window.location.pathname.split('/').filter(Boolean);
        const rootIdx = parts.findIndex(p => p.toLowerCase() === 'gyan_setu');
        if (rootIdx === -1) {
            const clean = page.replace(/^\/+/, '');
            return '/' + clean;
        }
        const lastPart = parts[parts.length - 1] || '';
        const isFile = lastPart.includes('.');
        const dirCount = isFile ? (parts.length - 1 - (rootIdx + 1)) : (parts.length - (rootIdx + 1));
        const prefix = dirCount > 0 ? '../'.repeat(dirCount) : '';
        return prefix + page;
    }

    // Format seconds into live child-friendly string (e.g., 1h 58m 32s, 24m 32s, 45s)
    function formatChildFriendlyTime(seconds) {
        if (seconds === null || isUnlimited) return '🔓 Unlimited';
        if (seconds <= 0) return '0s';

        const totalSecs = Math.max(0, parseInt(seconds, 10));
        const hours = Math.floor(totalSecs / 3600);
        const mins  = Math.floor((totalSecs % 3600) / 60);
        const secs  = totalSecs % 60;
        const padSecs = String(secs).padStart(2, '0');

        if (hours > 0) {
            return `${hours}h ${mins}m ${padSecs}s`;
        } else if (mins > 0) {
            return `${mins}m ${padSecs}s`;
        } else {
            return `${secs}s`;
        }
    }

    // Update banner counter if present on page
    function updateBannerDisplay() {
        const counterEl = document.getElementById('screentime-banner-counter');
        if (!counterEl) return;

        if (isUnlimited || remainingSeconds === null || !isChildSession) {
            // No limit set or parent mode: show ONLY the animated hourglass icon
            counterEl.innerHTML = `<span class="hourglass-anim" style="font-size: 26px; display: inline-block;">⏳</span>`;
            counterEl.style.color = '#ffffff';
        } else {
            const timeStr = formatChildFriendlyTime(remainingSeconds);

            counterEl.innerHTML = `
                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; line-height: 1.1;">
                    <span class="hourglass-anim" style="font-size: 20px; display: inline-block; margin-bottom: 2px;">⏳</span>
                    <span style="font-size: 14px; font-weight: 900; letter-spacing: 0.02em; white-space: nowrap;">${timeStr}</span>
                    <span style="font-size: 11px; font-weight: 700; opacity: 0.85; margin-top: 1px;">left</span>
                </div>
            `;

            if (remainingSeconds <= 300 && remainingSeconds > 0) {
                counterEl.style.color = '#ffcc00';
            } else if (isExpired) {
                counterEl.style.color = '#ff6b6b';
            } else {
                counterEl.style.color = '#ffffff';
            }
        }
    }

    // Show 5-minute warning prompt
    function show5MinuteWarning() {
        if (isWarningShown) return;
        isWarningShown = true;
        sessionStorage.setItem('screentime_warned_5m', 'true');

        if (document.getElementById('screentime-warning-prompt')) return;

        const promptDiv = document.createElement('div');
        promptDiv.id = 'screentime-warning-prompt';
        promptDiv.className = 'screentime-warning-prompt';
        promptDiv.innerHTML = `
            <div class="prompt-icon">⏰</div>
            <div class="prompt-content">
                <h4>Time is Almost Up!</h4>
                <p>You have 5 minutes of screentime remaining for today.</p>
            </div>
            <button class="prompt-btn" type="button" id="screentime-dismiss-btn">Got it! 👍</button>
        `;

        document.body.appendChild(promptDiv);

        document.getElementById('screentime-dismiss-btn').addEventListener('click', function () {
            promptDiv.style.opacity = '0';
            promptDiv.style.transform = 'translateY(-20px)';
            setTimeout(() => promptDiv.remove(), 300);
        });

        // Auto dismiss after 12 seconds
        setTimeout(() => {
            if (document.body.contains(promptDiv)) {
                promptDiv.style.opacity = '0';
                promptDiv.style.transform = 'translateY(-20px)';
                setTimeout(() => promptDiv.remove(), 300);
            }
        }, 12000);
    }

    // Show Fullscreen Time's Up Modal
    function showTimeoutModal() {
        if (document.getElementById('screentime-timeout-overlay')) return;

        const modalDiv = document.createElement('div');
        modalDiv.id = 'screentime-timeout-overlay';
        modalDiv.className = 'screentime-timeout-overlay';
        modalDiv.innerHTML = `
            <div class="screentime-timeout-card">
                <div class="timeout-mascot">⌛</div>
                <h2>Time's Up for Today!</h2>
                <p>Great job learning today! You have reached your daily screentime limit. Ask a parent if you'd like to extend your limit.</p>
                <div class="timeout-actions">
                    <a href="${getSiteUrl('grownup-gate.php')}" class="btn-timeout-parent">👨‍👩‍👧 Parent Access / Extend Time</a>
                </div>
            </div>
        `;

        document.body.appendChild(modalDiv);
    }

    // Main status check & tick execution
    async function fetchStatus() {
        try {
            const apiUrl = getApiUrl();
            const sep = apiUrl.includes('?') ? '&' : '?';
            const res = await fetch(`${apiUrl}${sep}action=get_status&_t=${Date.now()}`);
            if (!res.ok) return;
            const data = await res.json();

            if (!data.success || !data.is_child) {
                isChildSession = false;
                stopTimer();
                updateBannerDisplay();
                return;
            }

            isChildSession = true;
            isUnlimited = Boolean(data.unlimited);

            const newLimitMinutes = data.daily_limit_minutes ? parseInt(data.daily_limit_minutes, 10) : 0;
            const limitChanged = (currentLimitMinutes !== null && currentLimitMinutes !== newLimitMinutes);
            currentLimitMinutes = newLimitMinutes;

            // Only override local remainingSeconds if initial load or parent altered limit
            if (remainingSeconds === null || limitChanged) {
                remainingSeconds = data.remaining_seconds !== null ? parseInt(data.remaining_seconds, 10) : null;
                unsyncedSeconds = 0;
            }

            isExpired = Boolean(data.is_expired) || (!isUnlimited && remainingSeconds !== null && remainingSeconds <= 0);

            updateBannerDisplay();

            if (isExpired) {
                showTimeoutModal();
            } else if (!isUnlimited && remainingSeconds !== null && remainingSeconds <= 300) {
                show5MinuteWarning();
            }
        } catch (e) {
            console.error('Screentime fetch error:', e);
        }
    }

    function sendTick(elapsedSeconds) {
        if (!isChildSession || isUnlimited || isExpired || elapsedSeconds <= 0) return;

        try {
            const formData = new FormData();
            formData.append('action', 'tick');
            formData.append('elapsed', elapsedSeconds);

            const apiUrl = getApiUrl();
            if (navigator.sendBeacon && document.hidden) {
                navigator.sendBeacon(apiUrl, formData);
                return;
            }

            fetch(apiUrl, {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data && data.success) {
                    isUnlimited = Boolean(data.unlimited);
                    isExpired = Boolean(data.is_expired);
                    if (isExpired) showTimeoutModal();
                }
            })
            .catch(err => console.error('Screentime tick error:', err));
        } catch (e) {
            console.error('Screentime tick exception:', e);
        }
    }

    function startTimer() {
        if (tickInterval) clearInterval(tickInterval);

        tickInterval = setInterval(() => {
            // Page Visibility API check: do NOT tick if document is hidden!
            if (document.hidden || !isChildSession || isUnlimited || isExpired) return;

            if (remainingSeconds !== null && remainingSeconds > 0) {
                remainingSeconds--;
                unsyncedSeconds++;
                updateBannerDisplay();

                if (remainingSeconds <= 300 && remainingSeconds > 0) {
                    show5MinuteWarning();
                }

                if (remainingSeconds <= 0) {
                    isExpired = true;
                    showTimeoutModal();
                }
            }

            // Flush sync to DB every 5 seconds
            if (unsyncedSeconds >= 5) {
                const toSync = unsyncedSeconds;
                unsyncedSeconds = 0;
                sendTick(toSync);
            }
        }, 1000);
    }

    function stopTimer() {
        if (tickInterval) {
            clearInterval(tickInterval);
            tickInterval = null;
        }
    }

    // Page Visibility API handler
    document.addEventListener('visibilitychange', function () {
        if (document.hidden) {
            // Tab is hidden -> immediately flush unsynced elapsed time to server DB
            if (unsyncedSeconds > 0) {
                const toSync = unsyncedSeconds;
                unsyncedSeconds = 0;
                sendTick(toSync);
            }
            stopTimer();
        } else {
            // Tab is back in focus -> resume local timer from exact remainingSeconds without resetting
            startTimer();
            fetchStatus();
        }
    });

    // Flush unsynced time when unloading page
    window.addEventListener('pagehide', function () {
        if (unsyncedSeconds > 0 && isChildSession && !isUnlimited) {
            const toSync = unsyncedSeconds;
            unsyncedSeconds = 0;
            sendTick(toSync);
        }
    });

    // Initialize on DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            fetchStatus().then(() => startTimer());
        });
    } else {
        fetchStatus().then(() => startTimer());
    }
})();
