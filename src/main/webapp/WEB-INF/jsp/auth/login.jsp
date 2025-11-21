<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>
<body class="bg-background flex items-center justify-center min-h-screen">
<div class="max-w-md w-full bg-white p-8 rounded-xl shadow-lg">
    <div class="flex justify-center mb-8"><img src="${pageContext.request.contextPath}/images/logo-stacked.png" class="w-40"></div>

    <form action="${pageContext.request.contextPath}/auth/login" method="post" class="space-y-4">
        <div>
            <label class="block text-sm font-medium text-gray-700">아이디</label>
            <input type="text" name="username" value="${param.username}" required 
                   class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-point">
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700">비밀번호</label>
            <input type="password" name="password" required 
                   class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-point">
        </div>
        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { 
        %>
            <div class="text-red-500 text-sm"><%= errorMessage %></div>
        <% } %>
        <button type="submit" class="w-full bg-point text-white font-bold py-2 rounded-md hover:bg-opacity-90 transition-colors">
            로그인
        </button>
    </form>
    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/auth/signup" class="text-sm text-gray-600">회원이 아니신가요? <b>회원가입</b></a>
    </div>
</div>
</body>
</html>

