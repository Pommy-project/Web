package com.pommy.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.pommy.model.PromptMeme;
import com.pommy.service.PromptMemeService;
import com.pommy.service.PromptMemeServiceImpl;

/**
 * 업로드 관련 요청을 처리하는 컨트롤러
 */
@WebServlet("/upload/*")
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
            // 업로드 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/upload/form");
        } else if (path.equals("/form")) {
            // 업로드 폼 페이지 표시
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }
            request.getRequestDispatcher("/WEB-INF/jsp/prompt/upload.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();

        if (path == null || path.equals("/")) {
            // 업로드 처리
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            Long userId = (Long) session.getAttribute("userId");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String promptContent = request.getParameter("prompt");
            String aiType = request.getParameter("ai"); // 첫 번째 AI 타입만 사용

            // 데이터 유효성 검사
            if (title == null || title.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/upload/form?error=missing_title");
                return;
            }

            if (promptContent == null || promptContent.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/upload/form?error=missing_prompt");
                return;
            }

            if (aiType == null || aiType.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/upload/form?error=missing_ai");
                return;
            }

            // PromptMeme 객체 생성
            PromptMeme promptMeme = new PromptMeme();
            promptMeme.setUserId(userId);
            promptMeme.setTitle(title.trim());
            promptMeme.setDescription(description != null ? description.trim() : null);
            promptMeme.setPromptContent(promptContent.trim());
            promptMeme.setAiType(aiType.trim());
            promptMeme.setViewCount(0);

            // Service를 통해 DB에 저장
            promptMemeService.createPromptMeme(promptMeme);

            // 메인 페이지로 이동
            response.sendRedirect(request.getContextPath() + "/prompt/main");
        }
    }
}

