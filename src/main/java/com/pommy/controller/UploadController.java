package com.pommy.controller;

import com.pommy.model.PromptMeme;
import com.pommy.service.PromptMemeService;
import com.pommy.service.PromptMemeServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

/**
 * 업로드 관련 요청을 처리하는 컨트롤러
 */
@WebServlet("/upload/*")
@MultipartConfig(
    maxFileSize = 10 * 1024 * 1024, // 10MB
    maxRequestSize = 10 * 1024 * 1024, // 10MB
    fileSizeThreshold = 1024 * 1024 // 1MB
)
public class UploadController extends HttpServlet {

    private PromptMemeService promptMemeService;

    @Override
    public void init() throws ServletException {
        super.init();
        promptMemeService = new PromptMemeServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null || path.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/upload/form");
        } else if (path.equals("/form")) {
            renderUploadForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null || path.equals("/")) {
            handleUpload(request, response);
        }
    }

    /**
     * 업로드 폼 페이지 렌더링
     */
    private void renderUploadForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/prompt/upload.jsp")
                .forward(request, response);
    }

    /**
     * 업로드 처리
     */
    private void handleUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String promptContent = request.getParameter("prompt");
        String snsUrl = request.getParameter("snsUrl");
        String aiType = request.getParameter("ai");

        // 데이터 유효성 검사
        if (title == null || title.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/upload/form?error=missing_title");
            return;
        }

        if (promptContent == null || promptContent.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/upload/form?error=missing_prompt");
            return;
        }

        if (aiType == null || aiType.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/upload/form?error=missing_ai");
            return;
        }

        // 이미지 파일 업로드 처리
        String imageUrl = processImageUpload(request);

        // PromptMeme 객체 생성
        PromptMeme promptMeme = new PromptMeme();
        promptMeme.setUserId(userId);
        promptMeme.setTitle(title.trim());
        promptMeme.setDescription(description != null && !description.trim().isEmpty() ? description.trim() : null);
        promptMeme.setPromptContent(promptContent.trim());
        promptMeme.setSnsUrl(snsUrl != null && !snsUrl.trim().isEmpty() ? snsUrl.trim() : null);
        promptMeme.setImageUrl(imageUrl);
        promptMeme.setAiType(aiType);
        promptMeme.setViewCount(0);

        // Service를 통해 DB에 저장
        promptMemeService.createPromptMeme(promptMeme);

        // 메인 페이지로 이동
        response.sendRedirect(request.getContextPath() + "/prompt/main");
    }

    /**
     * 이미지 파일 업로드 처리
     * 
     * @param request HttpServletRequest
     * @return 업로드된 이미지 URL, 업로드 실패 시 null
     */
    private String processImageUpload(HttpServletRequest request) {
        try {
            Part filePart = request.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                return null;
            }

            String fileName = filePart.getSubmittedFileName();
            if (fileName == null || fileName.isEmpty()) {
                return null;
            }

            // 파일 확장자 검증
            String extension = "";
            int lastDot = fileName.lastIndexOf('.');
            if (lastDot > 0) {
                extension = fileName.substring(lastDot + 1).toLowerCase();
            }

            // 이미지 파일만 허용
            if (!extension.matches("jpg|jpeg|png|gif|webp")) {
                return null;
            }

            // 업로드 디렉토리 설정
            String uploadDir = getServletContext().getRealPath("/uploads");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            // 고유한 파일명 생성
            String uniqueFileName = UUID.randomUUID().toString() + "." + extension;
            String filePath = uploadDir + File.separator + uniqueFileName;

            // 파일 저장
            filePart.write(filePath);
            return request.getContextPath() + "/uploads/" + uniqueFileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}

