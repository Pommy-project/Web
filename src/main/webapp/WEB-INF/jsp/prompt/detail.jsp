<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.pommy.model.PromptMeme" %>
<%@ page import="com.pommy.model.AIType" %>
<%@ page import="com.pommy.service.UserService" %>
<%@ page import="com.pommy.service.UserServiceImpl" %>
<%
    // 컨트롤러에서 전달받은 데이터 사용
    PromptMeme promptMeme = (PromptMeme) request.getAttribute("promptMeme");
    
    String title = "정보 없음";
    String author = "Unknown";
    String desc = "삭제되었거나 존재하지 않는 게시물입니다.";
    String prompt = "";
    String snsUrl = null;
    String imageUrl = null;
    List<AIType> aiTypes = new ArrayList<>();
    int currentViews = 0;
    boolean isFound = false;
    
    UserService userService = new UserServiceImpl();
    
    if (promptMeme != null) {
        isFound = true;
        title = promptMeme.getTitle();
        author = userService.getUserById(promptMeme.getUserId()).getNickname();
        desc = promptMeme.getDescription();
        prompt = promptMeme.getPromptContent();
        snsUrl = promptMeme.getSnsUrl();
        imageUrl = promptMeme.getImageUrl();
        aiTypes = promptMeme.getAiTypes();
        currentViews = promptMeme.getViewCount() != null ? promptMeme.getViewCount() : 0;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>

<body class="bg-background">
    <div class="max-w-2xl mx-auto mt-24 px-6 pb-10">
        <div class="bg-white p-8 rounded-xl shadow-lg space-y-6">
            
            <div class="flex items-center justify-between">
                <button onclick="location.href='${pageContext.request.contextPath}/prompt/main'" class="text-sm text-gray-600 hover:text-point transition-colors">
                    &larr; 뒤로가기
                </button>

                <div class="flex items-center gap-1 text-sm text-gray-500">
                    <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                    </svg>
                    <span id="detail-view-count">조회수 <%= currentViews %></span>
                </div>
            </div>

            <div>
                <h1 class="text-3xl font-bold text-gray-800 mb-2"><%= title %></h1>
                <p class="text-lg font-semibold text-gray-700">
                    by <span class="text-point"><%= author %></span>
                </p>
            </div>

            <div>
                <h2 class="text-xl font-bold mb-2">미리보기</h2>
                <% if (isFound && imageUrl != null && !imageUrl.isEmpty()) { %>
                    <img class="w-full h-64 object-cover rounded-lg shadow-md" src="<%= imageUrl %>" alt="<%= title %>">
                <% } else { %>
                    <div class="w-full h-64 bg-gradient-to-r from-yellow-100 to-orange-100 rounded-lg shadow-md flex items-center justify-center text-4xl text-gray-400">
                        📷
                    </div>
                <% } %>
            </div>

            <div>
                <h2 class="text-xl font-bold mb-2">설명</h2>
                <p class="text-gray-700 whitespace-pre-wrap"><%= (desc != null && !desc.isEmpty()) ? desc : "설명이 없습니다." %></p>
            </div>

            <div>
                <h2 class="text-xl font-bold mb-2">프롬프트</h2>
                <pre class="bg-gray-100 p-4 rounded-md text-sm text-gray-800 overflow-x-auto whitespace-pre-wrap"><%= prompt %></pre>
            </div>

            <div>
                <h2 class="text-xl font-bold mb-2">사용된 AI</h2>
                <div class="flex gap-3 flex-wrap">
                    <% 
                    if (aiTypes != null && !aiTypes.isEmpty()) {
                        for (AIType ai : aiTypes) {
                            String colorClass = "bg-gray-200 text-gray-700";
                            String aiName = ai.getValue();
                            String aiLink = ai.getUrl(); // Enum에서 URL 가져오기
                            
                            if (ai == AIType.GEMINI) {
                                colorClass = "bg-green-100 text-green-700";
                            } else if (ai == AIType.GPT) {
                                colorClass = "bg-blue-100 text-blue-700";
                            } else if (ai == AIType.MIDJOURNEY) {
                                colorClass = "bg-gray-200 text-gray-700";
                            } else if (ai == AIType.SORA) {
                                colorClass = "bg-purple-100 text-purple-700";
                            }
                    %>
                        <a href="<%= aiLink %>" target="_blank" class="<%= colorClass %> font-semibold py-2 px-4 rounded-lg hover:opacity-80 transition-opacity">
                            <%= aiName %>
                        </a>
                    <% 
                        }
                    } else {
                    %>
                        <span class="text-gray-500">선택된 AI 정보가 없습니다.</span>
                    <% } %>
                </div>
            </div>

            <div>
                <h2 class="text-xl font-bold mb-2">SNS / 출처</h2>
                <div class="flex gap-3 flex-wrap">
                    <% if (snsUrl != null && !snsUrl.isEmpty()) { %>
                        <a href="<%= snsUrl %>" target="_blank" class="bg-pink-100 text-pink-700 font-semibold py-2 px-4 rounded-lg hover:bg-pink-200 transition-colors">
                            SNS 링크 이동
                        </a>
                    <% } else { %>
                        <span class="text-gray-500">SNS 링크가 없습니다.</span>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="../../jspf/footer.jspf" %>
</body>
</html>