<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.pommy.model.PromptMeme" %>
<%@ page import="com.pommy.model.AIType" %>
<%
    // 컨트롤러에서 전달받은 데이터 사용
    List<PromptMeme> promptMemes = (List<PromptMeme>) request.getAttribute("promptMemes");
    List<PromptMeme> top3PromptMemes = (List<PromptMeme>) request.getAttribute("top3PromptMemes");
    Map<Long, String> userNicknameMap = (Map<Long, String>) request.getAttribute("userNicknameMap");
    
    if (promptMemes == null) {
        promptMemes = new ArrayList<>();
    }
    if (top3PromptMemes == null) {
        top3PromptMemes = new ArrayList<>();
    }
    if (userNicknameMap == null) {
        userNicknameMap = new HashMap<>();
    }
    
    // 랭킹 3개 (최대 3개)
    PromptMeme rank1 = top3PromptMemes.size() > 0 ? top3PromptMemes.get(0) : null;
    PromptMeme rank2 = top3PromptMemes.size() > 1 ? top3PromptMemes.get(1) : null;
    PromptMeme rank3 = top3PromptMemes.size() > 2 ? top3PromptMemes.get(2) : null;
%>
<!DOCTYPE html>
<html lang="ko">

<%@ include file="../../jspf/header.jspf" %>

<body class="bg-background">
    <div id="splash-screen" class="fixed inset-0 bg-main flex items-center justify-center z-50 transition-opacity duration-500 ease-out">
        <img src="${pageContext.request.contextPath}/images/logo-stacked.png" alt="Pommy Logo" class="w-48 animate-bounce-in">
    </div>

    <div class="max-w-5xl mx-auto px-6 min-h-screen relative">
        
        <header class="flex items-center py-4 relative z-20">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/images/logo-horizontal.png" alt="Logo" class="h-8">
            </a>
            <%@ include file="../../jspf/nav.jspf" %>
        </header>

        <div id="header-search-popover" class="hidden absolute right-0 top-16 z-50 bg-white/95 border border-main/40 rounded-xl shadow-lg px-4 py-3">
            <form action="${pageContext.request.contextPath}/prompt/search" method="get" class="flex items-center gap-2">
                <input id="header-search-input" type="search" name="q" placeholder="검색어를 입력하세요" class="w-52 px-3 py-2 text-sm border border-gray-300 rounded-lg">
                <button type="submit" class="text-sm font-semibold text-white bg-point px-3 py-2 rounded-lg">검색</button>
                <button type="button" onclick="toggleHeaderSearch()" class="text-gray-400">✕</button>
            </form>
        </div>

        <section class="space-y-4 mt-6 relative z-10">
            <h2 class="text-2xl font-bold text-gray-800">🔥 조회수 랭킹</h2>

            <div class="relative w-full max-w-md mx-auto">
                <div class="overflow-visible rounded-xl">
                    <div id="ranking-track">
                        
                        <% if (rank1 != null) { 
                            String author1 = userNicknameMap.getOrDefault(rank1.getUserId(), "알 수 없음");
                            String imageUrl1 = rank1.getImageUrl() != null ? rank1.getImageUrl() : "https://placehold.co/800x400/FFD572/FFF8E1?text=Ranking+1";
                        %>
                        <div class="ranking-slide slide-center">
                            <div class="relative bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer transform transition-transform duration-300 ease-out hover:scale-105" onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=<%= rank1.getId() %>'">
                                <div class="relative">
                                    <img class="w-full h-48 object-cover" src="<%= imageUrl1 %>" alt="1위">
                                    <span class="absolute top-3 left-3 bg-white bg-opacity-80 backdrop-blur-sm text-gray-800 text-xl font-bold px-3 py-1 rounded-md">🥇</span>
                                    <div class="absolute top-3 right-3 bg-black/40 text-white text-xs px-2 py-1 rounded-full">
                                        조회수 <%= rank1.getViewCount() != null ? rank1.getViewCount() : 0 %>
                                    </div>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold text-xl"><%= rank1.getTitle() != null ? rank1.getTitle() : "제목 없음" %></h3>
                                    <p class="text-sm text-gray-600">by <%= author1 %></p>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <% if (rank2 != null) { 
                            String author2 = userNicknameMap.getOrDefault(rank2.getUserId(), "알 수 없음");
                            String imageUrl2 = rank2.getImageUrl() != null ? rank2.getImageUrl() : "https://placehold.co/800x400/CCCCCC/FFF8E1?text=Ranking+2";
                        %>
                        <div class="ranking-slide slide-right">
                            <div class="relative bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer transform transition-transform duration-300 ease-out hover:scale-105" onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=<%= rank2.getId() %>'">
                                <div class="relative">
                                    <img class="w-full h-48 object-cover" src="<%= imageUrl2 %>" alt="2위">
                                    <span class="absolute top-3 left-3 bg-white bg-opacity-80 backdrop-blur-sm text-gray-800 text-xl font-bold px-3 py-1 rounded-md">🥈</span>
                                    <div class="absolute top-3 right-3 bg-black/40 text-white text-xs px-2 py-1 rounded-full">
                                        조회수 <%= rank2.getViewCount() != null ? rank2.getViewCount() : 0 %>
                                    </div>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold text-lg"><%= rank2.getTitle() != null ? rank2.getTitle() : "제목 없음" %></h3>
                                    <p class="text-sm text-gray-600">by <%= author2 %></p>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <% if (rank3 != null) { 
                            String author3 = userNicknameMap.getOrDefault(rank3.getUserId(), "알 수 없음");
                            String imageUrl3 = rank3.getImageUrl() != null ? rank3.getImageUrl() : "https://placehold.co/800x400/B08D57/FFF8E1?text=Ranking+3";
                        %>
                        <div class="ranking-slide slide-left">
                            <div class="relative bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer transform transition-transform duration-300 ease-out hover:scale-105" onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=<%= rank3.getId() %>'">
                                <div class="relative">
                                    <img class="w-full h-48 object-cover" src="<%= imageUrl3 %>" alt="3위">
                                    <span class="absolute top-3 left-3 bg-white bg-opacity-80 backdrop-blur-sm text-gray-800 text-xl font-bold px-3 py-1 rounded-md">🥉</span>
                                    <div class="absolute top-3 right-3 bg-black/40 text-white text-xs px-2 py-1 rounded-full">
                                        조회수 <%= rank3.getViewCount() != null ? rank3.getViewCount() : 0 %>
                                    </div>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold text-lg"><%= rank3.getTitle() != null ? rank3.getTitle() : "제목 없음" %></h3>
                                    <p class="text-sm text-gray-600">by <%= author3 %></p>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <button onclick="prevRank()" class="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-4 bg-white bg-opacity-70 p-2 rounded-full shadow-md z-10">◀</button>
                <button onclick="nextRank()" class="absolute right-0 top-1/2 -translate-y-1/2 translate-x-4 bg-white bg-opacity-70 p-2 rounded-full shadow-md z-10">▶</button>
                <div id="ranking-indicators" class="flex justify-center gap-2 mt-10">
                    <button onclick="showRankByDot(0)" class="w-3 h-3 bg-point rounded-full"></button>
                    <button onclick="showRankByDot(1)" class="w-3 h-3 bg-gray-300 rounded-full"></button>
                    <button onclick="showRankByDot(2)" class="w-3 h-3 bg-gray-300 rounded-full"></button>
                </div>
            </div>
        </section>

        <section class="space-y-4 pb-10 mt-10">
            <h2 class="text-2xl font-bold text-gray-800">✨ 최신 프롬프트</h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

                <%
                    if (promptMemes != null && !promptMemes.isEmpty()) {
                        for (PromptMeme meme : promptMemes) {
                            if (meme == null) continue;
                            String title = meme.getTitle() != null ? meme.getTitle() : "제목 없음";
                            String author = userNicknameMap.getOrDefault(meme.getUserId(), "알 수 없음");
                            String desc = meme.getDescription();
                            List<AIType> aiTypes = meme.getAiTypes();
                            Long id = meme.getId();
                            
                            int views = meme.getViewCount() != null ? meme.getViewCount() : 0;
                            
                            // 설명을 간단하게 줄이는 로직
                            String simpleDesc = "설명 없음";
                            if (desc != null && !desc.isEmpty()) {
                                if (desc.length() > 12) {
                                    simpleDesc = desc.substring(0, 12) + "...";
                                } else {
                                    simpleDesc = desc;
                                }
                            }

                            String[] colors = {"bg-red-100", "bg-blue-100", "bg-green-100", "bg-yellow-100", "bg-purple-100"};
                            String randomColor = colors[(int)(id % colors.length)];
                            String imageUrl = meme.getImageUrl();
                %>
                    <div class="bg-white rounded-xl shadow-md overflow-hidden cursor-pointer hover:scale-105 transition-transform"
                         onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=<%= id %>'">
                        
                        <div class="relative h-48 w-full">
                            <% if (imageUrl != null && !imageUrl.isEmpty()) { %>
                                <img class="w-full h-48 object-cover" src="<%= imageUrl %>" alt="<%= title %>">
                            <% } else { %>
                                <div class="w-full h-full <%= randomColor %> flex items-center justify-center text-4xl text-gray-400">
                                    📷
                                </div>
                            <% } %>
                            <div class="absolute top-3 right-3 bg-black/40 text-white text-xs px-2 py-1 rounded-full flex items-center gap-1">
                                <svg class="w-3 h-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                                <span><%= views %></span>
                            </div>
                        </div>

                        <div class="p-4">
                            <h3 class="font-bold text-lg truncate"><%= title %></h3> <p class="text-sm text-gray-600">by <%= author %></p>
                            
                            <p class="text-sm text-gray-500 mt-2 truncate">
                                <%= simpleDesc %>
                            </p>
                            
                            <div class="flex gap-2 mt-2 flex-wrap">
                                <% 
                                if(aiTypes != null && !aiTypes.isEmpty()) {
                                    for (AIType ai : aiTypes) { 
                                        String colorClass = "bg-gray-200 text-gray-700";
                                        if(ai == AIType.GEMINI) colorClass = "bg-green-100 text-green-700";
                                        else if(ai == AIType.GPT) colorClass = "bg-blue-100 text-blue-700";
                                        else if(ai == AIType.SORA) colorClass = "bg-purple-100 text-purple-700";
                                        else if(ai == AIType.MIDJOURNEY) colorClass = "bg-gray-200 text-gray-700";
                                %>
                                    <span class="<%= colorClass %> text-xs px-2 py-0.5 rounded-full"><%= ai.getValue() %></span>
                                <% 
                                    } 
                                }
                                %>
                            </div>
                        </div>
                    </div>
                <% 
                        } 
                    } else { 
                %>
                    <div class="col-span-full text-center py-10 bg-white rounded-xl shadow-sm">
                        <h3 class="text-lg font-bold text-gray-400">아직 업로드된 글이 없습니다.</h3>
                        <p class="text-sm text-gray-400 mt-1">첫 번째 주인공이 되어보세요! ✨</p>
                    </div>
                <% } %>

            </div>
        </section>
    </div>
    <%@ include file="../../jspf/footer.jspf" %>
    <script>
        document.addEventListener('DOMContentLoaded', function(){
            // Splash screen 처리
            const splash = document.getElementById('splash-screen');
            if (splash) {
                // 새로고침인지 확인
                const navigation = performance.getEntriesByType('navigation')[0];
                const isReload = navigation && navigation.type === 'reload';
                
                // 새로고침이 아닌 경우 splash-screen 즉시 숨김
                if (!isReload) {
                    splash.style.display = 'none';
                } else {
                    // 새로고침인 경우 splash-screen 표시
                    setTimeout(() => {
                        splash.style.opacity = '0';
                        setTimeout(() => { splash.style.display = 'none'; }, 500);
                    }, 1500);
                }
            }
            
            // 랭킹 슬라이더 초기화
            if(typeof initMainPageSlider==='function')initMainPageSlider();
        });
    </script>
</body>
</html>