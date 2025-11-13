// /Web/js/state.js
// ===== 앱 상태 =====
const appState = {
    isLoggedIn: false,
    nickname: null,
    redirectAfterLogin: null,
    notificationTimer: null,
    rankingSliderInterval: null,
    currentRank: 0,
};

const RANKING_COUNT = 3;
const AUTO_SLIDE_DELAY = 4000;
