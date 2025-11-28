<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pommy.model.PromptMeme" %>
<%@ page import="com.pommy.model.AIType" %>
<%
    PromptMeme promptMeme = (PromptMeme) request.getAttribute("promptMeme");
    if (promptMeme == null) {
        response.sendRedirect(request.getContextPath() + "/mypage");
        return;
    }

    List<String> errors = (List<String>) request.getAttribute("errors");
    AIType[] aiTypes = (AIType[]) request.getAttribute("aiTypes");
    if (aiTypes == null) {
        aiTypes = AIType.values();
    }

    String selectedAiType = promptMeme.getAiType();
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>
<body class="bg-background">
    <div class="max-w-3xl mx-auto mt-24 px-6 pb-12">
        <button onclick="location.href='${pageContext.request.contextPath}/mypage'" class="text-sm text-gray-600 hover:text-point transition-colors mb-6 inline-flex items-center gap-1">
            &larr; 마이페이지로
        </button>

        <div class="bg-white rounded-2xl shadow-lg p-8 space-y-6">
            <header class="space-y-1">
                <p class="text-sm text-gray-500">내 프롬프트</p>
                <h1 class="text-3xl font-bold text-gray-800">프롬프트 수정</h1>
                <p class="text-gray-500 text-sm">제목, 설명, 프롬프트 텍스트, 이미지, SNS 링크, AI 종류를 수정할 수 있어요.</p>
            </header>

            <% if (errors != null && !errors.isEmpty()) { %>
                <div class="bg-red-50 text-red-700 px-4 py-3 rounded-lg text-sm space-y-1">
                    <% for (String error : errors) { %>
                        <p><%= error %></p>
                    <% } %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/prompt/update" method="post" enctype="multipart/form-data" class="space-y-6">
                <input type="hidden" name="id" value="<%= promptMeme.getId() %>">

                <div>
                    <label for="image" class="block text-sm font-semibold text-gray-700 mb-2">미리보기 이미지</label>
                    <div class="space-y-3">
                        <div id="image-preview-container" class="relative">
                            <% if (promptMeme.getImageUrl() != null && !promptMeme.getImageUrl().isEmpty()) { %>
                                <div class="relative w-full h-64 rounded-lg overflow-hidden border border-gray-200 bg-gray-50">
                                    <img id="current-image" src="<%= promptMeme.getImageUrl() %>" alt="현재 이미지" 
                                         class="w-full h-full object-cover">
                                    <div class="absolute inset-0 bg-black bg-opacity-0 hover:bg-opacity-20 transition-opacity flex items-center justify-center">
                                        <span class="text-white text-sm font-semibold opacity-0 hover:opacity-100 transition-opacity">현재 이미지</span>
                                    </div>
                                </div>
                            <% } else { %>
                                <div id="no-image-placeholder" class="w-full h-64 rounded-lg border-2 border-dashed border-gray-300 bg-gray-50 flex items-center justify-center">
                                    <div class="text-center text-gray-400">
                                        <svg class="w-16 h-16 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                        </svg>
                                        <p class="text-sm">이미지 없음</p>
                                    </div>
                                </div>
                            <% } %>
                            <div id="new-image-preview" class="hidden mt-3 relative w-full h-64 rounded-lg overflow-hidden border border-gray-200 bg-gray-50">
                                <img id="preview-img" src="" alt="새 이미지 미리보기" class="w-full h-full object-cover">
                                <button type="button" onclick="handleClearImagePreview()" 
                                        class="absolute top-2 right-2 bg-red-500 text-white rounded-full w-8 h-8 flex items-center justify-center hover:bg-red-600 transition">
                                    ✕
                                </button>
                                <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white text-sm py-1 px-2 text-center">
                                    새로 선택한 이미지
                                </div>
                            </div>
                        </div>
                        <div>
                            <input type="file" id="image" name="image" accept="image/jpeg,image/jpg,image/png,image/gif,image/webp" 
                                   onchange="handleImagePreview(this)"
                                   class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-main file:text-gray-800 hover:file:bg-opacity-90">
                            <p class="text-xs text-gray-400 mt-1">* JPG, PNG, GIF, WEBP 형식만 지원됩니다. (최대 10MB) 이미지를 변경하지 않으려면 선택하지 마세요.</p>
                        </div>
                    </div>
                </div>

                <div>
                    <label for="title" class="block text-sm font-semibold text-gray-700 mb-1">제목</label>
                    <input type="text" id="title" name="title" value="<%= promptMeme.getTitle() != null ? promptMeme.getTitle() : "" %>" required
                           class="w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-point focus:ring-2 focus:ring-point/30 transition">
                </div>

                <div>
                    <label for="description" class="block text-sm font-semibold text-gray-700 mb-1">설명 (선택)</label>
                    <textarea id="description" name="description" rows="3"
                              class="w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-point focus:ring-2 focus:ring-point/30 transition"
                              placeholder="간단한 설명을 입력하세요."><%= promptMeme.getDescription() != null ? promptMeme.getDescription() : "" %></textarea>
                </div>

                <div>
                    <label for="prompt" class="block text-sm font-semibold text-gray-700 mb-1">프롬프트 내용</label>
                    <textarea id="prompt" name="prompt" rows="8" required
                              class="w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-point focus:ring-2 focus:ring-point/30 transition"
                              placeholder="사용한 프롬프트를 입력하세요."><%= promptMeme.getPromptContent() != null ? promptMeme.getPromptContent() : "" %></textarea>
                </div>

                <div>
                    <label for="snsUrl" class="block text-sm font-semibold text-gray-700 mb-1">SNS / 출처 링크 (선택)</label>
                    <input type="url" id="snsUrl" name="snsUrl" value="<%= promptMeme.getSnsUrl() != null ? promptMeme.getSnsUrl() : "" %>"
                           placeholder="https://instagram.com/your-profile"
                           class="w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-point focus:ring-2 focus:ring-point/30 transition">
                </div>

                <div>
                    <p class="block text-sm font-semibold text-gray-700 mb-2">사용한 AI</p>
                    <div class="flex flex-wrap gap-3">
                        <% for (AIType type : aiTypes) {
                            String value = type.getValue();
                            boolean checked = value.equalsIgnoreCase(selectedAiType);
                        %>
                            <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                                <input type="radio" name="ai" value="<%= value %>" class="accent-point w-4 h-4" <%= checked ? "checked" : "" %>>
                                <span><%= value %></span>
                            </label>
                        <% } %>
                    </div>
                </div>

                <div class="flex flex-col md:flex-row gap-3 pt-4">
                    <button type="button" onclick="location.href='${pageContext.request.contextPath}/prompt/detail?id=<%= promptMeme.getId() %>'"
                            class="flex-1 px-5 py-3 rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-50 transition">
                        취소
                    </button>
                    <button type="submit"
                            class="flex-1 px-6 py-3 rounded-lg bg-point text-white font-semibold shadow hover:bg-point/90 transition">
                        변경 사항 저장
                    </button>
                </div>
            </form>
        </div>
    </div>
    <%@ include file="../../jspf/footer.jspf" %>
    <script src="${pageContext.request.contextPath}/js/imagePreview.js"></script>
    <script>
        // edit.jsp 전용 이미지 미리보기 함수
        function handleImagePreview(input) {
            previewImage(input, {
                previewContainerId: 'new-image-preview',
                previewImgId: 'preview-img',
                placeholderId: 'no-image-placeholder',
                currentImageId: 'current-image'
            });
        }

        function handleClearImagePreview() {
            clearImagePreview({
                previewContainerId: 'new-image-preview',
                fileInputId: 'image',
                placeholderId: 'no-image-placeholder',
                currentImageId: 'current-image'
            });
        }
    </script>
</body>
</html>

