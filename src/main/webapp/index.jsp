<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<%@ include file="/WEB-INF/jspf/header.jspf" %>

<body class="bg-background min-h-screen flex flex-col">

    <div id="splash-screen" class="fixed inset-0 bg-main flex items-center justify-center z-50 transition-opacity duration-500 ease-out">
        <img src="${pageContext.request.contextPath}/images/logo-stacked.png" alt="Pommy Logo" class="w-48 animate-bounce-in">
    </div>

    <header class="flex items-center justify-between py-6 px-6 max-w-5xl mx-auto w-full animate-fade-in">
        <div class="flex items-center gap-2">
            <img src="${pageContext.request.contextPath}/images/logo-horizontal.png" alt="Pommy Logo" class="h-8">
        </div>
        <a href="main.jsp" class="flex items-center gap-2 bg-white text-gray-800 text-sm font-semibold py-2 px-4 rounded-full shadow hover:bg-gray-100 transition-colors">
            홈으로 이동 &rarr;
        </a>
    </header>

    <main class="flex-1 flex flex-col items-center justify-center px-4 pb-40">
        <div class="flex flex-col items-center gap-4 animate-bounce-in">
            <img src="${pageContext.request.contextPath}/images/logo-stacked.png" alt="Pommy Logo" class="w-60">
            <h1 class="text-2xl md:text-3xl font-extrabold text-gray-900 text-center">
                프롬프트 밈을 발견하고, 공유하는 공간
            </h1>
            <p class="text-gray-600 text-center max-w-xl">
                재미있는 AI 프롬프트 밈을 모아보고, 나만의 밈을 업로드해보세요.
            </p>
        </div>

        <form action="search.jsp" method="get" class="relative w-full max-w-xl mt-4 animate-fade-in" style="animation-delay: 0.2s;">
            <input type="search" name="q" placeholder="재미있는 프롬프트 밈을 검색해보세요!"
                   class="w-full pl-12 pr-4 py-3 rounded-full shadow-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-main bg-white/90">
            <button type="submit" class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-point">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
            </button>
        </form>
    </main>

    <%@ include file="/WEB-INF/jspf/footer.jspf" %>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const splash = document.getElementById('splash-screen');
            if (splash) {
                setTimeout(() => {
                    splash.style.opacity = '0';
                    setTimeout(() => { splash.style.display = 'none'; }, 500);
                }, 1500);
            }
        });
    </script>

</body>
</html>