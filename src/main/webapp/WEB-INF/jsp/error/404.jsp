<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<%-- 공통 헤더 (CSS, 폰트) --%>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<body class="bg-background flex items-center justify-center min-h-screen px-6">
<div class="text-center max-w-lg w-full">
    <!-- 로고 -->
    <img src="${pageContext.request.contextPath}/images/logo-stacked.png" alt="Pommy" class="w-32 mx-auto mb-8 opacity-80">

    <!-- 404 텍스트 (통통 튀는 애니메이션) -->
    <h1 class="text-8xl font-extrabold text-point mb-4 animate-bounce">404</h1>

    <h2 class="text-2xl font-bold text-gray-800 mb-2">
        페이지를 찾을 수 없어요 🐹
    </h2>

    <p class="text-gray-600 mb-8">
        요청하신 페이지가 삭제되었거나,<br>
        주소가 잘못 입력된 것 같습니다.
    </p>

    <!-- 홈으로 버튼 (JavaScript 이동) -->
    <button onclick="location.href='${pageContext.request.contextPath}/main'"
            class="inline-block bg-point text-white font-bold py-3 px-8 rounded-full shadow-lg hover:bg-opacity-90 transition-transform transform hover:scale-105 cursor-pointer">
        홈으로 돌아가기
    </button>
</div>
</body>
</html>