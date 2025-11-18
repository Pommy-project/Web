<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // 1. 검색어 가져오기
    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("q");
    if (keyword == null) keyword = "";
    
    // 2. 전체 게시글 목록 가져오기
    List<Map<String, Object>> allPosts = (List<Map<String, Object>>) application.getAttribute("globalPostList");
    List<Map<String, Object>> searchResults = new ArrayList<>();

    // 3. 검색 로직 (제목 또는 프롬프트 내용에 키워드가 있는지 확인)
    if (allPosts != null && !keyword.trim().isEmpty()) {
        for (Map<String, Object> post : allPosts) {
            String title = (String) post.get("title");
            String prompt = (String) post.get("prompt"); // 프롬프트 내용도 검색
            
            // 대소문자 구분 없이 검색 (둘 다 소문자로 바꿔서 비교)
            if (title.toLowerCase().contains(keyword.toLowerCase()) || 
                prompt.toLowerCase().contains(keyword.toLowerCase())) {
                searchResults.add(post);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<body class="bg-background">
    <div class="max-w-5xl mx-auto px-6 mt-24 min-h-screen">
        
        <button onclick="location.href='main.jsp'" class="text-sm text-gray-600 hover:text-point mb-4 inline-block transition-colors">
            &larr; 메인으로
        </button>

        <h1 class="text-3xl font-bold text-gray-800">
            '<span class="text-point"><%= keyword %></span>'에 대한 검색 결과
        </h1>

        <section class="mt-6 pb-10">
            <% if (!searchResults.isEmpty()) { %>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <% for (Map<String, Object> post : searchResults) { 
                        Long id = (Long) post.get("id");
                        String title = (String) post.get("title");
                        String author = (String) post.get("author");
                        String desc = (String) post.get("desc");
                        List<String> aiList = (List<String>) post.get("ais");
                        
                        // 썸네일 색상 랜덤
                        String[] colors = {"bg-red-100", "bg-blue-100", "bg-green-100", "bg-yellow-100", "bg-purple-100"};
                        String randomColor = colors[(int)(id % colors.length)];
                    %>
                        <div class="bg-white rounded-xl shadow-md overflow-hidden cursor-pointer hover:scale-105 transition-transform duration-300"
                             onclick="location.href='detail.jsp?id=<%= id %>'">
                            <div class="w-full h-48 <%= randomColor %> flex items-center justify-center text-gray-400 text-4xl">
                                🔍
                            </div>
                            <div class="p-4">
                                <h3 class="font-bold text-lg"><%= title %></h3>
                                <p class="text-sm text-gray-600">by <%= author %></p>
                                <p class="text-sm text-gray-500 mt-2 truncate">
                                    <%= (desc != null && !desc.isEmpty()) ? desc : "설명이 없습니다." %>
                                </p>
                                <div class="flex gap-2 mt-2 flex-wrap">
                                    <% if(aiList != null) { for (String ai : aiList) { %>
                                        <span class="bg-gray-200 text-gray-700 text-xs px-2 py-0.5 rounded-full"><%= ai %></span>
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
    <%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>