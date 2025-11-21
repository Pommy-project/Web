<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // 1. 서버 메모리에서 글 목록 가져오기
    List<Map<String, Object>> postList = (List<Map<String, Object>>) application.getAttribute("globalPostList");

    if (postList == null) {
        postList = new ArrayList<>();
        application.setAttribute("globalPostList", postList);
    }

    // 2. 랭킹 데이터(ID 1, 2, 3)가 존재하는지 확인하고, 없으면 강제로 추가
    // (Lambda나 Stream을 쓰면 좋지만, JSP 호환성을 위해 기본 for문 사용)
    boolean hasRank1 = false, hasRank2 = false, hasRank3 = false;
    
    for (Map<String, Object> p : postList) {
        Object idObj = p.get("id");
        // Long 타입 안전하게 변환
        long id = (idObj instanceof Long) ? (Long)idObj : ((Number)idObj).longValue();
        
        if (id == 1L) hasRank1 = true;
        if (id == 2L) hasRank2 = true;
        if (id == 3L) hasRank3 = true;
    }

    // 랭킹 1위가 없으면 추가
    if (!hasRank1) {
        Map<String, Object> p1 = new HashMap<>();
        p1.put("id", 1L);
        p1.put("title", "우주 비행사 햄스터");
        p1.put("author", "SpaceHam");
        p1.put("desc", "용감한 햄스터가 우주를 여행합니다.");
        p1.put("views", 1234);
        p1.put("ais", Arrays.asList("Gemini", "Midjourney"));
        p1.put("prompt", "A hamster in space suit...");
        postList.add(p1);
    }
    // 랭킹 2위가 없으면 추가
    if (!hasRank2) {
        Map<String, Object> p2 = new HashMap<>();
        p2.put("id", 2L);
        p2.put("title", "사이버펑크 고양이");
        p2.put("author", "CatLover");
        p2.put("desc", "네온 사인 아래의 고양이.");
        p2.put("views", 982);
        p2.put("ais", Arrays.asList("Midjourney"));
        p2.put("prompt", "Cyberpunk cat...");
        postList.add(p2);
    }
    // 랭킹 3위가 없으면 추가
    if (!hasRank3) {
        Map<String, Object> p3 = new HashMap<>();
        p3.put("id", 3L);
        p3.put("title", "중세 기사 댕댕이");
        p3.put("author", "DogKnight");
        p3.put("desc", "성지키는 강아지 기사.");
        p3.put("views", 856);
        p3.put("ais", Arrays.asList("DALL-E"));
        p3.put("prompt", "A dog knight...");
        postList.add(p3);
    }

    // 3. 화면에 뿌리기 위해 변수에 할당
    Map<String, Object> rank1 = new HashMap<>();
    Map<String, Object> rank2 = new HashMap<>();
    Map<String, Object> rank3 = new HashMap<>();

    for (Map<String, Object> p : postList) {
        Object idObj = p.get("id");
        long id = (idObj instanceof Long) ? (Long)idObj : ((Number)idObj).longValue();
        
        if (id == 1L) rank1 = p;
        if (id == 2L) rank2 = p;
        if (id == 3L) rank3 = p;
    }
%>
<!DOCTYPE html>
<html lang="ko">

<%@ include file="../../jspf/header.jspf" %>

<body class="bg-background">
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
                        
                        <div class="ranking-slide slide-center">
                            <div class="relative bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer transform transition-transform duration-300 ease-out hover:scale-105" onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=1'">
                                <div class="relative">
                                    <img class="w-full h-48 object-cover" src="https://placehold.co/800x400/FFD572/FFF8E1?text=Ranking+1" alt="1위">
                                    <span class="absolute top-3 left-3 bg-white bg-opacity-80 backdrop-blur-sm text-gray-800 text-xl font-bold px-3 py-1 rounded-md">🥇</span>
                                    <div class="absolute top-3 right-3 bg-black/40 text-white text-xs px-2 py-1 rounded-full">
                                        조회수 <%= rank1.get("views") %>
                                    </div>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold text-xl"><%= rank1.get("title") %></h3>
                                    <p class="text-sm text-gray-600">by <%= rank1.get("author") %></p>
                                </div>
                            </div>
                        </div>

                        <div class="ranking-slide slide-right">
                            <div class="relative bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer transform transition-transform duration-300 ease-out hover:scale-105" onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=2'">
                                <div class="relative">
                                    <img class="w-full h-48 object-cover" src="https://placehold.co/800x400/CCCCCC/FFF8E1?text=Ranking+2" alt="2위">
                                    <span class="absolute top-3 left-3 bg-white bg-opacity-80 backdrop-blur-sm text-gray-800 text-xl font-bold px-3 py-1 rounded-md">🥈</span>
                                    <div class="absolute top-3 right-3 bg-black/40 text-white text-xs px-2 py-1 rounded-full">
                                        조회수 <%= rank2.get("views") %>
                                    </div>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold text-lg"><%= rank2.get("title") %></h3>
                                    <p class="text-sm text-gray-600">by <%= rank2.get("author") %></p>
                                </div>
                            </div>
                        </div>

                        <div class="ranking-slide slide-left">
                            <div class="relative bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer transform transition-transform duration-300 ease-out hover:scale-105" onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=3'">
                                <div class="relative">
                                    <img class="w-full h-48 object-cover" src="https://placehold.co/800x400/B08D57/FFF8E1?text=Ranking+3" alt="3위">
                                    <span class="absolute top-3 left-3 bg-white bg-opacity-80 backdrop-blur-sm text-gray-800 text-xl font-bold px-3 py-1 rounded-md">🥉</span>
                                    <div class="absolute top-3 right-3 bg-black/40 text-white text-xs px-2 py-1 rounded-full">
                                        조회수 <%= rank3.get("views") %>
                                    </div>
                                </div>
                                <div class="p-4">
                                    <h3 class="font-bold text-lg"><%= rank3.get("title") %></h3>
                                    <p class="text-sm text-gray-600">by <%= rank3.get("author") %></p>
                                </div>
                            </div>
                        </div>
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
                    if (postList != null && !postList.isEmpty()) {
                        for (Map<String, Object> post : postList) {
                            String title = (String) post.get("title");
                            String author = (String) post.get("author");
                            String desc = (String) post.get("desc");
                            List<String> aiList = (List<String>) post.get("ais");
                            Long id = (Long) post.get("id");
                            
                            Object viewsObj = post.get("views");
                            int views = (viewsObj != null) ? (Integer) viewsObj : 0;
                            
                            // ▼▼▼ [추가된 부분] 설명을 간단하게 줄이는 로직 ▼▼▼
                            String simpleDesc = "설명 없음";
                            if (desc != null && !desc.isEmpty()) {
                                if (desc.length() > 12) {
                                    simpleDesc = desc.substring(0, 12) + "...";
                                } else {
                                    simpleDesc = desc;
                                }
                            }
                            // ▲▲▲

                            String[] colors = {"bg-red-100", "bg-blue-100", "bg-green-100", "bg-yellow-100", "bg-purple-100"};
                            String randomColor = colors[(int)(id % colors.length)];
                %>
                    <div class="bg-white rounded-xl shadow-md overflow-hidden cursor-pointer hover:scale-105 transition-transform"
                         onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=<%= id %>'">
                        
                        <div class="relative h-48 w-full">
                            <div class="w-full h-full <%= randomColor %> flex items-center justify-center text-4xl text-gray-400">
                                📷
                            </div>
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
                                if(aiList != null) {
                                    for (String ai : aiList) { 
                                        String colorClass = "bg-gray-200 text-gray-700";
                                        if(ai.equals("Gemini")) colorClass = "bg-green-100 text-green-700";
                                        else if(ai.equals("GPT")) colorClass = "bg-blue-100 text-blue-700";
                                        else if(ai.equals("Sora")) colorClass = "bg-purple-100 text-purple-700";
                                %>
                                    <span class="<%= colorClass %> text-xs px-2 py-0.5 rounded-full"><%= ai %></span>
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
    <script>document.addEventListener('DOMContentLoaded', function(){if(typeof initMainPageSlider==='function')initMainPageSlider();});</script>
</body>
</html>