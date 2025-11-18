<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // 1. 로그인 체크 및 닉네임 가져오기
    if (session.getAttribute("nickname") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String myNickname = (String) session.getAttribute("nickname");

    // 2. 전체 게시글 가져오기
    List<Map<String, Object>> allPosts = (List<Map<String, Object>>) application.getAttribute("globalPostList");
    List<Map<String, Object>> myPosts = new ArrayList<>();

    // 3. 필터링: 작성자(author)가 나(myNickname)와 같은 글만 골라냄
    if (allPosts != null) {
        for (Map<String, Object> post : allPosts) {
            String author = (String) post.get("author");
            if (author != null && author.equals(myNickname)) {
                myPosts.add(post);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<body class="bg-background">
    <div class="max-w-5xl mx-auto px-6 min-h-screen mt-24">
        
        <button onclick="location.href='main.jsp'" class="text-sm text-gray-600 hover:text-point mb-4 inline-block transition-colors">
            &larr; 메인으로
        </button>

        <div class="flex items-center justify-between mb-6">
            <h1 class="text-3xl font-bold text-gray-800">
                <span class="text-point"><%= myNickname %></span>님의 페이지
            </h1>
            <button onclick="location.href='process/logout.jsp'"
                    class="bg-gray-300 text-gray-700 font-semibold py-2 px-4 rounded-lg shadow hover:bg-gray-400 transition-colors">
                로그아웃
            </button>
        </div>

        <section>
            <h2 class="text-2xl font-bold mb-4 text-gray-800">내가 올린 밈 (<%= myPosts.size() %>개)</h2>
            
            <% if (!myPosts.isEmpty()) { %>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                    <% for (Map<String, Object> post : myPosts) {
                        Long id = (Long) post.get("id");
                        String title = (String) post.get("title");
                        String desc = (String) post.get("desc");
                        
                        String[] colors = {"bg-red-100", "bg-blue-100", "bg-green-100", "bg-yellow-100", "bg-purple-100"};
                        String randomColor = colors[(int)(id % colors.length)];
                    %>
                        <div class="bg-white rounded-xl shadow-md overflow-hidden hover:scale-105 transition-transform duration-300"
                             onclick="location.href='detail.jsp?id=<%= id %>'">
                            <div class="w-full h-48 <%= randomColor %> flex items-center justify-center text-4xl">
                                👤
                            </div>
                            <div class="p-4">
                                <h3 class="font-bold text-lg"><%= title %></h3>
                                <p class="text-sm text-gray-600">by <%= myNickname %></p>
                                <p class="text-sm text-gray-500 mt-2 truncate">
                                    <%= (desc != null && !desc.isEmpty()) ? desc : "설명이 없습니다." %>
                                </p>
                                <button onclick="event.stopPropagation(); alert('DB 연결 후 삭제 가능합니다.');" 
                                        class="mt-3 w-full bg-red-100 text-red-700 font-semibold py-2 px-4 rounded-lg hover:bg-red-200 transition-colors">
                                    삭제
                                </button>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="bg-white p-10 rounded-xl shadow text-center">
                    <p class="text-gray-500 mb-4">아직 업로드한 프롬프트가 없습니다.</p>
                    <a href="upload.jsp" class="bg-point text-white font-bold py-2 px-6 rounded-full hover:bg-opacity-90">
                        첫 프롬프트 올리기
                    </a>
                </div>
            <% } %>
        </section>
    </div>
    <%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>