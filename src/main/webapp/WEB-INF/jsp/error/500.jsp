<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% response.setStatus(HttpServletResponse.SC_OK); %>
<!DOCTYPE html>
<html lang="ko">

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<body class="bg-background flex items-center justify-center min-h-screen px-6">
<div class="text-center max-w-lg w-full">
    <!-- 로고 -->
    <img src="${pageContext.request.contextPath}/images/logo-stacked.png" alt="Pommy" class="w-32 mx-auto mb-8 opacity-80">

    <!-- 500 이모지 -->
    <div class="text-6xl mb-4">😵‍💫</div>

    <h2 class="text-2xl font-bold text-gray-800 mb-2">
        서버에 문제가 생겼어요
    </h2>

    <p class="text-gray-600 mb-8">
        잠시 후 다시 시도해주세요.<br>
        문제가 지속되면 관리자에게 문의해주세요.
    </p>

    <div class="flex justify-center gap-4">
        <!-- 이전 페이지 (history.back) -->
        <button onclick="history.back()"
                class="bg-white text-gray-600 font-bold py-3 px-6 rounded-full shadow hover:bg-gray-50 transition-colors cursor-pointer">
            이전 페이지
        </button>

        <!-- 홈으로 (location.href) -->
        <button onclick="location.href='${pageContext.request.contextPath}/main'"
                class="bg-point text-white font-bold py-3 px-8 rounded-full shadow-lg hover:bg-opacity-90 transition-colors cursor-pointer">
            홈으로 가기
        </button>
    </div>


</div>
</body>
</html>