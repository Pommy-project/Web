// /Web/js/ui.js

// 1. 알림창 표시 함수
function showNotification(message) {
    const box = document.getElementById('notification-box');
    const msgSpan = document.getElementById('notification-message');
    if (!box || !msgSpan) return;

    msgSpan.textContent = message;
    box.style.display = 'block';
    
    // 3초 뒤에 사라짐
    setTimeout(() => {
        box.style.display = 'none';
    }, 3000);
}

// 2. 헤더 검색창 토글 함수 (이게 없어서 검색창이 안 떴습니다)
function toggleHeaderSearch() {
    const popover = document.getElementById('header-search-popover');
    const input = document.getElementById('header-search-input');
    
    if (!popover) return;

    // hidden 클래스를 넣었다 뺐다 함
    if (popover.classList.contains('hidden')) {
        popover.classList.remove('hidden');
        if(input) input.focus(); // 켜지면 바로 입력 가능하게 포커스
    } else {
        popover.classList.add('hidden');
    }
}