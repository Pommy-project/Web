<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<body class="bg-background flex items-center justify-center min-h-screen">
<div class="max-w-md w-full bg-white p-8 rounded-xl shadow-lg">
    <h1 class="text-3xl font-bold text-center text-point mb-6">회원가입</h1>
    <form action="process/signupProcess.jsp" method="post" class="space-y-4">
        <input type="text" name="id" placeholder="아이디" required class="w-full px-3 py-2 border rounded-md">
        <input type="password" name="pw" placeholder="비밀번호" required class="w-full px-3 py-2 border rounded-md">
        <input type="text" name="nickname" placeholder="닉네임" required class="w-full px-3 py-2 border rounded-md">
        <button type="submit" class="w-full bg-point text-white font-bold py-2 rounded-md">가입완료</button>
    </form>
</div>
</body>
</html>