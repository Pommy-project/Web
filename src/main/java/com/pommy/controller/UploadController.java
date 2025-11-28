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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/jsp/prompt/upload.jsp")
                .forward(request, response);
    }

    /**
     * 업로드 처리
     */
    private void handleUpload(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

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


            // ⭐ FileServeController에서 사용한 동일한 방식 적용
            // 1) UploadController.class 파일의 실제 위치 찾기
            String classPath = UploadController.class
                    .getProtectionDomain()
                    .getCodeSource()
                    .getLocation()
                    .getPath();

            File classFile = new File(classPath);

            // 2) 프로젝트 root로 역추적 (4단계 상위 폴더)
            File projectRoot = classFile.getParentFile()  // /WEB-INF/classes
                    .getParentFile()                    // /WEB-INF
                    .getParentFile()                    // /pommy_war_exploded
                    .getParentFile();                   // Tomcat의 webapps/pommy_war_exploded (실제 WAR 위치)

            // 3) 개발용 프로젝트 root로 맞추기 (src/main/webapp/uploads)
            // ⚠️ 만약 exploded 환경일 때도 동일하게 맞추고 싶으면 아래처럼 src 기준으로 맞춤
            File uploadDirFile = new File(projectRoot.getAbsolutePath() + "/src/main/webapp/uploads");

            // 4) 폴더 없으면 생성
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            // 고유 파일명 생성
            String uniqueFileName = java.util.UUID.randomUUID().toString() + "." + extension;
            File savedFile = new File(uploadDirFile, uniqueFileName);

            // 저장
            filePart.write(savedFile.getAbsolutePath());

            System.out.println("========================================");
            System.out.println("[UploadController] 파일 업로드 완료");
            System.out.println("원본 파일명 : " + fileName);
            System.out.println("저장 위치   : " + savedFile.getAbsolutePath());
            System.out.println("========================================");

            // DB에는 파일명만 저장
            return uniqueFileName;

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[UploadController] 업로드 중 오류 발생: " + e.getMessage());
            return null;
        }
    }
}

