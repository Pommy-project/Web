// /Web/js/prompts.js

// 검색 + 업로드

// ===== 검색 공통 로직 =====
function executeSearch(term) {
    const searchTerm = term.trim();
    if (!searchTerm) {
        showNotification('검색어를 입력해주세요.');
        return;
    }

    const searchKeywordSpan = document.getElementById('search-keyword');
    const resultsList = document.getElementById('search-prompt-list');
    const noResultsMessage = document.getElementById('search-no-results');

    searchKeywordSpan.textContent = searchTerm;

    if (searchTerm.includes('햄스터') || searchTerm.toLowerCase().includes('hamster')) {
        resultsList.style.display = 'grid';
        noResultsMessage.classList.add('hidden');
    } else {
        resultsList.style.display = 'none';
        noResultsMessage.classList.remove('hidden');
    }

    navigateTo('search-page');
}

function handleIntroSearch() {
    const input = document.getElementById('intro-search-input');
    if (!input) return;
    executeSearch(input.value);
}

function handleHeaderSearch() {
    const input = document.getElementById('header-search-input');
    if (!input) return;
    executeSearch(input.value);
    toggleHeaderSearch();
}

function handleUpload() {
    const title  = document.getElementById('upload-title').value.trim();
    const desc   = document.getElementById('upload-description').value.trim();
    const author = appState.nickname || 'Guest';
    const views  = 0;

    if (!title) {
        showNotification('제목을 입력해주세요.');
        return;
    }

    const mainList = document.getElementById('main-prompt-list');
    if (!mainList) return;

    // --- 사용 AI 선택 값 읽기 ---
    const aiSelect = document.getElementById('upload-ai');
    const selectedAis = aiSelect
        ? Array.from(aiSelect.selectedOptions).map(o => o.value)
        : [];

    // 선택된 AI들로 뱃지 HTML 만들어주기
    let aiBadgesHtml = '';
    selectedAis.forEach(ai => {
        let colorClass = 'bg-gray-200 text-gray-700';
        if (ai === 'Gemini')           colorClass = 'bg-green-100 text-green-700';
        else if (ai === 'GPT')        colorClass = 'bg-blue-100 text-blue-700';
        else if (ai === 'Midjourney') colorClass = 'bg-gray-200 text-gray-700';
        else if (ai === 'Sora')       colorClass = 'bg-purple-100 text-purple-700';

        aiBadgesHtml += `
            <span class="${colorClass} text-xs px-2 py-0.5 rounded-full">${ai}</span>
        `;
    });

    const card = document.createElement('div');
    card.className =
        'relative bg-white rounded-xl shadow-md overflow-hidden cursor-pointer transform ' +
        'transition-transform duration-300 ease-out hover:scale-105';
    card.onclick = () => navigateTo('detail-page');

    card.innerHTML = `
  <img class="w-full h-48 object-cover"
       src="https://placehold.co/600x400/FFD572/FFF8E1?text=MiiM+Preview"
       alt="프롬프트 미리보기">

  <div class="absolute top-3 right-3 bg-black/40 text-white text-xs px-2 py-1 rounded-full flex items-center gap-1">
    <svg class="w-3 h-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
    </svg>
    <!-- 🔽 이 span 수정 -->
    <span class="view-count-text" data-views="${views}">조회수 ${views}</span>
  </div>

  <div class="p-4">
    <h3 class="font-bold text-lg">${title}</h3>
    <p class="text-sm text-gray-600">by ${author}</p>
    <p class="text-sm text-gray-500 mt-2 truncate">
      ${desc || '설명이 없습니다.'}
    </p>
    ${selectedAis.length ? `
      <div class="flex gap-2 mt-2">
        ${aiBadgesHtml}
      </div>
    ` : ''}
  </div>
`;


    // 클릭 시 디테일로 이동 + 조회수 증가
    card.onclick = () => openPromptDetailFromCard(card);

    mainList.prepend(card);

    showNotification('업로드 되었습니다!');
    navigateTo('main-page');

    document.getElementById('upload-title').value = '';
    document.getElementById('upload-description').value = '';
    document.getElementById('upload-prompt').value = '';
    document.getElementById('upload-sns').value = '';
}

// 카드 클릭 시 디테일 페이지로 이동하면서 조회수 1 증가
function openPromptDetailFromCard(cardEl) {
    const badge = cardEl.querySelector('.view-count-text');

    if (badge) {
        let current = parseInt(badge.dataset.views || '0', 10);
        current += 1;

        // 카드 안 배지 숫자 갱신
        badge.dataset.views = current;
        badge.textContent = `조회수 ${current}`;

        // 디테일 페이지 상단 조회수에도 반영
        const detailSpan = document.getElementById('detail-view-count');
        if (detailSpan) {
            detailSpan.textContent = `조회수 ${current}`;
        }
    }

    navigateTo('detail-page');
}

