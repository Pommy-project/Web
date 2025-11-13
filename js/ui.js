// /Web/js/ui.js

// ===== 알림 =====
function showNotification(message) {
    const notifBox = document.getElementById('notification-box');
    const notifMessage = document.getElementById('notification-message');

    if (appState.notificationTimer) {
        clearTimeout(appState.notificationTimer);
    }

    notifMessage.textContent = message;
    notifBox.style.display = 'block';
    notifBox.classList.remove('animate-fade-out');
    notifBox.classList.add('animate-fade-in');

    appState.notificationTimer = setTimeout(() => {
        notifBox.classList.remove('animate-fade-in');
        notifBox.classList.add('animate-fade-out');
        setTimeout(() => {
            notifBox.style.display = 'none';
        }, 500);
    }, 2500);
}

// ===== 헤더 검색 팝업 토글 =====
function toggleHeaderSearch() {
    const box = document.getElementById('header-search-popover');
    if (!box) return;
    const isHidden = box.classList.contains('hidden');
    if (isHidden) {
        box.classList.remove('hidden');
        setTimeout(() => {
            const input = document.getElementById('header-search-input');
            if (input) input.focus();
        }, 0);
    } else {
        box.classList.add('hidden');
    }
}
