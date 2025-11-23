<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.pommy.model.PromptMeme" %>
<%@ page import="com.pommy.model.AIType" %>
<%
    // 로그인 체크
    if (session.getAttribute("nickname") == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login");
        return;
    }
    
    // 컨트롤러에서 전달받은 데이터 사용
    String myNickname = (String) request.getAttribute("myNickname");
    List<PromptMeme> myPromptMemes = (List<PromptMeme>) request.getAttribute("myPromptMemes");
    
    if (myNickname == null) {
        myNickname = (String) session.getAttribute("nickname");
    }
    if (myPromptMemes == null) {
        myPromptMemes = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>

<body class="bg-background">
    <div class="max-w-5xl mx-auto px-6 min-h-screen mt-24">
        
        <button onclick="location.href='${pageContext.request.contextPath}/prompt/main'" class="text-sm text-gray-600 hover:text-point mb-4 inline-block transition-colors">
            &larr; 메인으로
        </button>

        <div class="flex items-center justify-between mb-6">
            <h1 class="text-3xl font-bold text-gray-800">
                <span class="text-point"><%= myNickname %></span>님의 페이지
            </h1>
            <button onclick="location.href='${pageContext.request.contextPath}/auth/logout'"
                    class="bg-gray-300 text-gray-700 font-semibold py-2 px-4 rounded-lg shadow hover:bg-gray-400 transition-colors">
                로그아웃
            </button>
        </div>

        <section>
            <h2 class="text-2xl font-bold mb-4 text-gray-800">내가 올린 밈 (<%= myPromptMemes.size() %>개)</h2>
            
            <% if (!myPromptMemes.isEmpty()) { %>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                    <% for (PromptMeme meme : myPromptMemes) {
                        if (meme == null) continue;
                        Long id = meme.getId();
                        String title = meme.getTitle() != null ? meme.getTitle() : "제목 없음";
                        String desc = meme.getDescription();
                        String imageUrl = meme.getImageUrl();
                        
                        if (id == null) continue;
                        String[] colors = {"bg-red-100", "bg-blue-100", "bg-green-100", "bg-yellow-100", "bg-purple-100"};
                        String randomColor = colors[(int)(id % colors.length)];
                    %>
                        <div class="bg-white rounded-xl shadow-md overflow-hidden hover:scale-105 transition-transform duration-300"
                             onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=<%= id %>'">
                            <% if (imageUrl != null && !imageUrl.isEmpty()) { %>
                                <img class="w-full h-48 object-cover" src="<%= imageUrl %>" alt="<%= title %>">
                            <% } else { %>
                                <div class="w-full h-48 <%= randomColor %> flex items-center justify-center text-4xl">
                                    📷
                                </div>
                            <% } %>
                            <div class="p-4">
                                <h3 class="font-bold text-lg"><%= title %></h3>
                                <p class="text-sm text-gray-600">by <%= myNickname %></p>
                                <p class="text-sm text-gray-500 mt-2 truncate">
                                    <%= (desc != null && !desc.isEmpty()) ? desc : "설명이 없습니다." %>
                                </p>
                                <form method="post" action="${pageContext.request.contextPath}/prompt/delete" style="display: inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                    <input type="hidden" name="id" value="<%= id %>">
                                    <button type="submit" onclick="event.stopPropagation();" 
                                            class="mt-3 w-full bg-red-100 text-red-700 font-semibold py-2 px-4 rounded-lg hover:bg-red-200 transition-colors">
                                        삭제
                                    </button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="bg-white p-10 rounded-xl shadow text-center">
                    <p class="text-gray-500 mb-4">아직 업로드한 프롬프트가 없습니다.</p>
                    <a href="${pageContext.request.contextPath}/upload/form" class="bg-point text-white font-bold py-2 px-6 rounded-full hover:bg-opacity-90">
                        첫 프롬프트 올리기
                    </a>
                </div>
            <% } %>
        </section>
    </div>
    <%@ include file="../../jspf/footer.jspf" %>
</body>
</html>