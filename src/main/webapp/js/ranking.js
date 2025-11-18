// /Web/js/ranking.js

// 전역 변수로 설정 (state.js 없이 단독 동작)
let currentRank = 0;
let rankingSliderInterval = null;
const RANKING_COUNT = 3;
const AUTO_SLIDE_DELAY = 4000;

function applyRankingLayout() {
    const slides = document.querySelectorAll('#ranking-track .ranking-slide');
    const indicatorsEl = document.getElementById('ranking-indicators');
    const indicators = indicatorsEl ? indicatorsEl.children : [];

    if (slides.length < RANKING_COUNT) return;

    const center = currentRank;
    const left = (center - 1 + RANKING_COUNT) % RANKING_COUNT;
    const right = (center + 1) % RANKING_COUNT;

    slides.forEach((slide, idx) => {
        slide.classList.remove('slide-left', 'slide-center', 'slide-right');
        if (idx === center) slide.classList.add('slide-center');
        else if (idx === left) slide.classList.add('slide-left');
        else if (idx === right) slide.classList.add('slide-right');
    });

    for (let i = 0; i < indicators.length; i++) {
        indicators[i].classList.toggle('bg-point', i === center);
        indicators[i].classList.toggle('bg-gray-300', i !== center);
    }
}

function initMainPageSlider() {
    const track = document.getElementById('ranking-track');
    if (!track) return;

    if (rankingSliderInterval) {
        clearInterval(rankingSliderInterval);
    }

    currentRank = 0;
    applyRankingLayout();
    startRankingSlider();
}

function nextRank() {
    currentRank = (currentRank + 1) % RANKING_COUNT;
    applyRankingLayout();
    resetAutoSlide();
}

function prevRank() {
    currentRank = (currentRank - 1 + RANKING_COUNT) % RANKING_COUNT;
    applyRankingLayout();
    resetAutoSlide();
}

function showRankByDot(logicalIndex) {
    if (logicalIndex < 0 || logicalIndex >= RANKING_COUNT) return;
    currentRank = logicalIndex;
    applyRankingLayout();
    resetAutoSlide();
}

function resetAutoSlide() {
    if (rankingSliderInterval) {
        clearInterval(rankingSliderInterval);
    }
    rankingSliderInterval = setInterval(nextRank, AUTO_SLIDE_DELAY);
}

function startRankingSlider() {
    resetAutoSlide();
}