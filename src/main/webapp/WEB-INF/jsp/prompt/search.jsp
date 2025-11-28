<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.pommy.model.PromptMeme" %>
<%@ page import="com.pommy.model.AIType" %>
<%
    // 컨트롤러에서 전달받은 데이터 사용
    String keyword = (String) request.getAttribute("keyword");
    List<PromptMeme> searchResults = (List<PromptMeme>) request.getAttribute("searchResults");
    Map<Long, String> userNicknameMap = (Map<Long, String>) request.getAttribute("userNicknameMap");
    
    if (keyword == null) keyword = "";
    if (searchResults == null) {
        searchResults = new ArrayList<>();
    }
    if (userNicknameMap == null) {
        userNicknameMap = new HashMap<>();
    }
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>

<body class="bg-background">
    <div id="splash-screen" class="fixed inset-0 bg-main flex items-center justify-center z-50 transition-opacity duration-500 ease-out">
        <img src="${pageContext.request.contextPath}/images/logo-stacked.png" alt="Pommy Logo" class="w-48 animate-bounce-in">
    </div>

    <div class="max-w-5xl mx-auto px-6 mt-24 min-h-screen">
        
        <button onclick="location.href='${pageContext.request.contextPath}/prompt/main'" class="text-sm text-gray-600 hover:text-point mb-4 inline-block transition-colors">
            &larr; 메인으로
        </button>

        <h1 class="text-3xl font-bold text-gray-800">
            '<span class="text-point"><%= keyword %></span>'에 대한 검색 결과
        </h1>

        <section class="mt-6 pb-10">
            <% if (!searchResults.isEmpty()) { %>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <% for (PromptMeme meme : searchResults) { 
                        Long id = meme.getId();
                        String title = meme.getTitle();
                        String author = userNicknameMap.getOrDefault(meme.getUserId(), "알 수 없음");
                        String desc = meme.getDescription();
                        List<AIType> aiTypes = meme.getAiTypes();
                        String imageUrl = meme.getImageUrl();
                        
                        // 썸네일 색상 랜덤
                        String[] colors = {"bg-red-100", "bg-blue-100", "bg-green-100", "bg-yellow-100", "bg-purple-100"};
                        String randomColor = colors[(int)(id % colors.length)];
                    %>
                        <div class="bg-white rounded-xl shadow-md overflow-hidden cursor-pointer hover:scale-105 transition-transform duration-300"
                             onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=<%= id %>'">
                            <% if (imageUrl != null && !imageUrl.isEmpty()) { %>
                                <img class="w-full h-48 object-cover"  src="${pageContext.request.contextPath}/file/image?name=<%= imageUrl %>" alt="<%= title %>">
                            <% } else { %>
                                <div class="w-full h-48 <%= randomColor %> flex items-center justify-center text-gray-400 text-4xl">
                                    🔍
                                </div>
                            <% } %>
                            <div class="p-4">
                                <h3 class="font-bold text-lg"><%= title %></h3>
                                <p class="text-sm text-gray-600">by <%= author %></p>
                                <p class="text-sm text-gray-500 mt-2 truncate">
                                    <%= (desc != null && !desc.isEmpty()) ? desc : "설명이 없습니다." %>
                                </p>
                                <div class="flex gap-2 mt-2 flex-wrap">
                                    <% if(aiTypes != null && !aiTypes.isEmpty()) { 
                                        for (AIType ai : aiTypes) { 
                                            String colorClass = "bg-gray-200 text-gray-700";
                                            if(ai == AIType.GEMINI) colorClass = "bg-green-100 text-green-700";
                                            else if(ai == AIType.GPT) colorClass = "bg-blue-100 text-blue-700";
                                            else if(ai == AIType.SORA) colorClass = "bg-purple-100 text-purple-700";
                                    %>
                                        <span class="<%= colorClass %> text-xs px-2 py-0.5 rounded-full"><%= ai.getValue() %></span>
                                    <% }} %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="text-center py-16">
                    <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                    <h3 class="mt-2 text-lg font-semibold text-gray-800">검색 결과가 없습니다</h3>
                    <p class="mt-1 text-sm text-gray-500">다른 검색어로 다시 시도해보세요.</p>
                </div>
            <% } %>
        </section>
    </div>
    <%@ include file="../../jspf/footer.jspf" %>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const splash = document.getElementById('splash-screen');
            if (splash) {
                // 새로고침인지 확인
                const navigation = performance.getEntriesByType('navigation')[0];
                const isReload = navigation && navigation.type === 'reload';
                
                // 새로고침이 아닌 경우 splash-screen 즉시 숨김
                if (!isReload) {
                    splash.style.display = 'none';
                    return;
                }
                
                // 새로고침인 경우 splash-screen 표시
                setTimeout(() => {
                    splash.style.opacity = '0';
                    setTimeout(() => { splash.style.display = 'none'; }, 500);
                }, 1500);
            }
        });
    </script>
</body>
</html>