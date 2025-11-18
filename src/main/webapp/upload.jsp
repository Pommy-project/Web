<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 로그인 체크
    if (session.getAttribute("nickname") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<body class="bg-background">
    <div class="max-w-2xl mx-auto mt-24 px-6 pb-10">
        <div class="bg-white p-8 rounded-xl shadow-lg space-y-6">
            <h1 class="text-3xl font-bold text-gray-800">새 프롬프트 업로드</h1>
            
            <form action="process/uploadProcess.jsp" method="post" class="space-y-6">
                <div>
                    <label for="upload-title" class="block text-sm font-medium text-gray-700">제목</label>
                    <input type="text" id="upload-title" name="title" placeholder="멋진 밈의 제목을 붙여주세요"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-main focus:border-main">
                </div>

                <div>
                    <label for="upload-description" class="block text-sm font-medium text-gray-700">설명 (선택)</label>
                    <textarea id="upload-description" name="description" rows="3" placeholder="이 밈에 대한 간단한 설명을 추가하세요..."
                              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-main focus:border-main"></textarea>
                </div>

                <div>
                    <label for="upload-prompt" class="block text-sm font-medium text-gray-700">프롬프트 내용</label>
                    <textarea id="upload-prompt" name="prompt" rows="8" placeholder="여기에 프롬프트 내용을 입력하세요..."
                              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-main focus:border-main"></textarea>
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-gray-700">미리보기 사진</label>
                    <input type="file" class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-main file:text-gray-800 hover:file:bg-opacity-90">
                    <p class="text-xs text-gray-400 mt-1">* 현재 데모 버전에서는 실제 파일이 저장되지 않고 랜덤 썸네일로 대체됩니다.</p>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">사용 AI (여러 개 선택 가능)</label>
                    <div class="flex flex-wrap gap-3">
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="checkbox" name="ai" value="GPT" class="accent-point w-4 h-4"> <span>GPT</span>
                        </label>
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="checkbox" name="ai" value="Gemini" class="accent-point w-4 h-4"> <span>Gemini</span>
                        </label>
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="checkbox" name="ai" value="Midjourney" class="accent-point w-4 h-4"> <span>Midjourney</span>
                        </label>
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="checkbox" name="ai" value="Sora" class="accent-point w-4 h-4"> <span>Sora</span>
                        </label>
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="checkbox" name="ai" value="DALL-E" class="accent-point w-4 h-4"> <span>DALL-E</span>
                        </label>
                    </div>
                </div>

                <div class="flex gap-4">
                    <button type="button" onclick="location.href='main.jsp'"
                            class="w-full bg-gray-200 text-gray-800 font-bold py-2 px-4 rounded-md hover:bg-gray-300 transition-colors">
                        취소
                    </button>
                    <button type="submit"
                            class="w-full bg-point text-white font-bold py-2 px-4 rounded-md hover:bg-opacity-90 transition-colors">
                        업로드하기
                    </button>
                </div>
            </form>
        </div>
    </div>
    <%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>