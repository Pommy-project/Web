<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>

<body class="bg-background min-h-screen flex flex-col">
    <div class="max-w-5xl mx-auto px-6 min-h-screen flex flex-col items-center justify-center">
        <div class="text-center">
            <div class="mb-8">
                <img src="${pageContext.request.contextPath}/images/logo-stacked.png" alt="Pommy Logo" class="w-48 mx-auto animate-bounce-in">
            </div>
            
            <h1 class="text-8xl font-extrabold text-point mb-4">404</h1>
            <h2 class="text-3xl font-bold text-gray-800 mb-4">페이지를 찾을 수 없습니다</h2>
            <p class="text-gray-600 mb-8 max-w-md mx-auto">
                요청하신 페이지가 존재하지 않거나 이동되었을 수 있습니다.<br>
                주소를 다시 확인해주세요.
            </p>
            
            <div class="flex gap-4 justify-center">
                <a href="${pageContext.request.contextPath}/" 
                   class="bg-main text-gray-800 font-semibold py-3 px-6 rounded-full shadow hover:bg-opacity-90 transition-colors">
                    홈으로 이동
                </a>
                <a href="${pageContext.request.contextPath}/prompt/main" 
                   class="bg-white text-gray-800 font-semibold py-3 px-6 rounded-full shadow hover:bg-gray-100 transition-colors">
                    메인으로 이동
                </a>
            </div>
        </div>
    </div>
    <%@ include file="../../jspf/footer.jspf" %>
</body>
</html>



