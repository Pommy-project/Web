<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>

<body class="bg-background">
    <div class="max-w-2xl mx-auto mt-24 px-6 pb-10">
        <div class="bg-white p-8 rounded-xl shadow-lg space-y-6">
            <h1 class="text-3xl font-bold text-gray-800">새 프롬프트 업로드</h1>
            
            <form action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data" class="space-y-6">
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
                    <label for="upload-image" class="block text-sm font-medium text-gray-700 mb-2">미리보기 사진</label>
                    <div class="space-y-3">
                        <div id="image-preview-container" class="relative">
                            <div id="no-image-placeholder" class="w-full h-64 rounded-lg border-2 border-dashed border-gray-300 bg-gray-50 flex items-center justify-center">
                                <div class="text-center text-gray-400">
                                    <svg class="w-16 h-16 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                    </svg>
                                    <p class="text-sm">이미지를 선택해주세요</p>
                                </div>
                            </div>
                            <div id="new-image-preview" class="hidden mt-3 relative w-full h-64 rounded-lg overflow-hidden border border-gray-200 bg-gray-50">
                                <img id="preview-img" src="" alt="이미지 미리보기" class="w-full h-full object-cover">
                                <button type="button" onclick="handleClearImagePreview()" 
                                        class="absolute top-2 right-2 bg-red-500 text-white rounded-full w-8 h-8 flex items-center justify-center hover:bg-red-600 transition">
                                    ✕
                                </button>
                                <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white text-sm py-1 px-2 text-center">
                                    선택한 이미지
                                </div>
                            </div>
                        </div>
                        <div>
                            <input type="file" id="upload-image" name="image" accept="image/jpeg,image/jpg,image/png,image/gif,image/webp" 
                                   onchange="handleImagePreview(this)"
                                   class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-main file:text-gray-800 hover:file:bg-opacity-90">
                            <p class="text-xs text-gray-400 mt-1">* JPG, PNG, GIF, WEBP 형식만 지원됩니다. (최대 10MB)</p>
                        </div>
                    </div>
                </div>

                <div>
                    <label for="upload-sns" class="block text-sm font-medium text-gray-700">SNS URL (선택)</label>
                    <input type="url" id="upload-sns" name="snsUrl" placeholder="https://instagram.com/your-profile 또는 https://twitter.com/your-profile"
                           class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-main focus:border-main">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">사용 AI</label>
                    <div class="flex flex-wrap gap-3">
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="radio" name="ai" value="GPT" class="accent-point w-4 h-4"> <span>GPT</span>
                        </label>
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="radio" name="ai" value="GEMINI" class="accent-point w-4 h-4"> <span>Gemini</span>
                        </label>
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="radio" name="ai" value="MIDJOURNEY" class="accent-point w-4 h-4"> <span>Midjourney</span>
                        </label>
                        <label class="cursor-pointer flex items-center gap-2 bg-gray-50 px-3 py-2 rounded-lg border hover:bg-gray-100">
                            <input type="radio" name="ai" value="SORA" class="accent-point w-4 h-4"> <span>Sora</span>
                        </label>
                    </div>
                </div>

                <div class="flex gap-4">
                    <button type="button" onclick="location.href='${pageContext.request.contextPath}/prompt/main'"
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
    <%@ include file="../../jspf/footer.jspf" %>
    <script src="${pageContext.request.contextPath}/js/imagePreview.js"></script>
    <script>
        // upload.jsp 전용 이미지 미리보기 함수
        function handleImagePreview(input) {
            previewImage(input, {
                previewContainerId: 'new-image-preview',
                previewImgId: 'preview-img',
                placeholderId: 'no-image-placeholder'
            });
        }

        function handleClearImagePreview() {
            clearImagePreview({
                previewContainerId: 'new-image-preview',
                fileInputId: 'upload-image',
                placeholderId: 'no-image-placeholder'
            });
        }
    </script>
</body>
</html>