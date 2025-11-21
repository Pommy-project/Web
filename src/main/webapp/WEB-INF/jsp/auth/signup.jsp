<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>
<body class="bg-background flex items-center justify-center min-h-screen">
<div class="max-w-md w-full bg-white p-8 rounded-xl shadow-lg">
    <h1 class="text-3xl font-bold text-center text-point mb-6">회원가입</h1>
    <form action="${pageContext.request.contextPath}/auth/signup" method="post" class="space-y-4">
        <div>
            <input type="text" name="username" value="${param.username}" placeholder="아이디 (영문/숫자, 4-20자)" required 
                   class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-point">
            <p class="text-xs text-gray-500 mt-1">영문, 숫자만 사용 가능하며 4-20자여야 합니다.</p>
        </div>
        <div>
            <input type="password" name="password" placeholder="비밀번호 (최소 8자, 영문+숫자)" required 
                   class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-point">
            <p class="text-xs text-gray-500 mt-1">최소 8자 이상이며 영문과 숫자를 포함해야 합니다.</p>
        </div>
        <div>
            <input type="text" name="nickname" value="${param.nickname}" placeholder="닉네임 (2-20자)" required 
                   class="w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-point">
            <p class="text-xs text-gray-500 mt-1">2-20자여야 합니다.</p>
        </div>
        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { 
        %>
            <div class="text-red-500 text-sm"><%= errorMessage %></div>
        <% } %>
        <button type="submit" class="w-full bg-point text-white font-bold py-2 rounded-md hover:bg-opacity-90 transition-colors">
            가입완료
        </button>
    </form>
    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/auth/login" class="text-sm text-gray-600">이미 회원이신가요? <b>로그인</b></a>
    </div>
</div>
</body>
</html>

