// /Web/js/auth.js

// 로그인/회원가입/로그아웃/닉네임 반영

function handleLogin() {
    const nickname = document.getElementById('login-id').value || 'DemoUser';
    if (!nickname) {
        showNotification('아이디를 입력해주세요.');
        return;
    }
    appState.isLoggedIn = true;
    appState.nickname = nickname;
    localStorage.setItem('pommyNickname', nickname);
    updateUI();

    const redirectTo = appState.redirectAfterLogin || 'main-page';
    appState.redirectAfterLogin = null;
    navigateTo(redirectTo);
    showNotification(`${nickname}님, 환영합니다!`);
}

function handleSignup() {
    const nickname = document.getElementById('signup-nickname').value;
    if (!nickname) {
        showNotification('닉네임을 입력해주세요.');
        return;
    }
    appState.isLoggedIn = true;
    appState.nickname = nickname;
    localStorage.setItem('pommyNickname', nickname);
    updateUI();

    const redirectTo = appState.redirectAfterLogin || 'main-page';
    appState.redirectAfterLogin = null;
    navigateTo(redirectTo);
    showNotification(`회원가입 완료! ${nickname}님, 환영합니다!`);
}

function handleLogout() {
    appState.isLoggedIn = false;
    appState.nickname = null;
    localStorage.removeItem('pommyNickname');
    updateUI();
    navigateTo('main-page');
    showNotification('로그아웃 되었습니다.');
}

function updateUI() {
    const logoutButton = document.getElementById('logout-button-main');
    const storedNickname = localStorage.getItem('pommyNickname');

    if (storedNickname) {
        appState.isLoggedIn = true;
        appState.nickname = storedNickname;
    } else {
        appState.isLoggedIn = false;
        appState.nickname = null;
    }

    if (appState.isLoggedIn) {
        const mypageNickname = document.getElementById('mypage-nickname');
        if (mypageNickname) mypageNickname.textContent = appState.nickname;
        document.querySelectorAll('.mypage-nickname-display').forEach(el => {
            el.textContent = appState.nickname;
        });
        if (logoutButton) logoutButton.style.display = 'block';
    } else {
        if (logoutButton) logoutButton.style.display = 'none';
    }
}
