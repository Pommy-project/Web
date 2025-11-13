// /Web/js/router.js

//페이지 이동 관련
function navigateTo(pageId) {
    document.querySelectorAll('.page').forEach(page => {
        page.style.display = 'none';
    });

    const targetPage = document.getElementById(pageId);
    if (targetPage) {
        targetPage.style.display = 'block';
    } else {
        console.error(`Page not found: ${pageId}`);
        document.getElementById('main-page').style.display = 'block';
    }

    if (pageId === 'main-page') {
        setTimeout(initMainPageSlider, 0); // ranking.js 함수
    }

    window.scrollTo(0, 0);
}

function secureNavigate(pageId) {
    if (appState.isLoggedIn) {
        navigateTo(pageId);
    } else {
        appState.redirectAfterLogin = pageId;
        navigateTo('login-page');
    }
}
