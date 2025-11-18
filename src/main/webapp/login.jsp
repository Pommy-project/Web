<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<body class="bg-background flex items-center justify-center min-h-screen">
<div class="max-w-md w-full bg-white p-8 rounded-xl shadow-lg">
    <div class="flex justify-center mb-8"><img src="../../../images/logo-stacked.png" class="w-40"></div>

    <form action="process/loginProcess.jsp" method="post" class="space-y-4">
        <div>
            <label class="block text-sm font-medium text-gray-700">아이디</label>
            <input type="text" name="id" required class="w-full px-3 py-2 border rounded-md">
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700">비밀번호</label>
            <input type="password" name="pw" required class="w-full px-3 py-2 border rounded-md">
        </div>
        <button type="submit" class="w-full bg-point text-white font-bold py-2 rounded-md">로그인</button>
    </form>
    <div class="text-center mt-4">
        <a href="signup.jsp" class="text-sm text-gray-600">회원이 아니신가요? <b>회원가입</b></a>
    </div>
</div>
</body>
</html>