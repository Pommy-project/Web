<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String idStr = request.getParameter("id");
    
    // 기본값
    String title = "정보 없음";
    String author = "Unknown";
    String desc = "삭제되었거나 존재하지 않는 게시물입니다.";
    String prompt = "";
    List<String> aiList = new ArrayList<>();
    int currentViews = 0;
    
    List<Map<String, Object>> postList = (List<Map<String, Object>>) application.getAttribute("globalPostList");
    boolean isFound = false;

    if (idStr != null && postList != null) {
        try {
            long targetId = Long.parseLong(idStr);
            for (Map<String, Object> post : postList) {
                Object idObj = post.get("id");
                long postId = (idObj instanceof Long) ? (Long)idObj : ((Number)idObj).longValue();
                
                if (postId == targetId) {
                    // 데이터 매핑
                    title = (String) post.get("title");
                    author = (String) post.get("author");
                    desc = (String) post.get("desc");
                    prompt = (String) post.get("prompt");
                    aiList = (List<String>) post.get("ais");
                    
                    // 조회수 증가 로직
                    Object vObj = post.get("views");
                    int v = (vObj != null) ? (Integer) vObj : 0;
                    v++; 
                    post.put("views", v); // 증가된 값 저장
                    currentViews = v;     // 화면 표시용 변수 업데이트
                    
                    isFound = true;
                    break;
                }
            }
        } catch (Exception e) {}
    }
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<body class="bg-background">
    <div class="max-w-2xl mx-auto mt-24 px-6 pb-10">
        <div class="bg-white p-8 rounded-xl shadow-lg space-y-6">
            
            <div class="flex items-center justify-between">
                <button onclick="location.href='main.jsp'" class="text-sm text-gray-600 hover:text-point transition-colors">
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
                <% if (isFound) { %>
                    <div class="w-full h-64 bg-gradient-to-r from-yellow-100 to-orange-100 rounded-lg shadow-md flex items-center justify-center text-4xl text-gray-400">
                        📷
                    </div>
                <% } else { %>
                    <div class="w-full h-64 bg-gray-200 rounded-lg shadow-md flex items-center justify-center text-gray-500">
                        이미지 없음
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
                    if (aiList != null && !aiList.isEmpty()) {
                        for (String ai : aiList) {
                            String colorClass = "bg-gray-200 text-gray-700";
                            if (ai.equals("Gemini")) colorClass = "bg-green-100 text-green-700";
                            else if (ai.equals("GPT")) colorClass = "bg-blue-100 text-blue-700";
                            else if (ai.equals("Midjourney")) colorClass = "bg-gray-200 text-gray-700";
                            else if (ai.equals("Sora")) colorClass = "bg-purple-100 text-purple-700";
                    %>
                        <span class="<%= colorClass %> font-semibold py-2 px-4 rounded-lg">
                            <%= ai %>
                        </span>
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
                    <button class="bg-pink-100 text-pink-700 font-semibold py-2 px-4 rounded-lg hover:bg-pink-200">Instagram</button>
                    <button class="bg-blue-100 text-blue-700 font-semibold py-2 px-4 rounded-lg hover:bg-blue-200">Twitter</button>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>