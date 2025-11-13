// /Web/js/app.js

// 초기화

document.addEventListener('DOMContentLoaded', () => {
    updateUI();

    const splash = document.getElementById('splash-screen');
    setTimeout(() => {
        splash.style.opacity = '0';
        setTimeout(() => {
            splash.style.display = 'none';
            navigateTo('intro-page');   // 첫 화면은 랜딩
        }, 500);
    }, 1500);

    const introSearchInput = document.getElementById('intro-search-input');
    if (introSearchInput) {
        introSearchInput.addEventListener('keydown', (event) => {
            if (event.key === 'Enter') {
                handleIntroSearch();
            }
        });
    }

    const headerSearchInput = document.getElementById('header-search-input');
    if (headerSearchInput) {
        headerSearchInput.addEventListener('keydown', (event) => {
            if (event.key === 'Enter') {
                handleHeaderSearch();
            }
        });
    }
});
