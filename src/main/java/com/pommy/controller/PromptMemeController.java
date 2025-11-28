package com.pommy.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import com.pommy.model.AIType;
import com.pommy.model.PromptMeme;
import com.pommy.model.User;
import com.pommy.service.PromptMemeService;
import com.pommy.service.PromptMemeServiceImpl;
import com.pommy.service.UserService;
import com.pommy.service.UserServiceImpl;

/**
 * 프롬프트 밈 관련 요청을 처리하는 컨트롤러
 * 메인 페이지, 상세 페이지, 검색 페이지, 삭제, 업데이트 처리
 */
@WebServlet("/prompt/*")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024, // 10MB
        maxRequestSize = 10 * 1024 * 1024, // 10MB
        fileSizeThreshold = 1024 * 1024 // 1MB
)
public class PromptMemeController extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/prompt/main");
        } else if (path.equals("/main")) {
            renderMainPage(request, response);
        } else if (path.equals("/detail")) {
            renderDetailPage(request, response);
        } else if (path.equals("/search")) {
            renderSearchPage(request, response);
        } else if (path.equals("/edit")) {
            renderEditForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }

        Long userId = (Long) session.getAttribute("userId");

        if (path != null && path.equals("/delete")) {
            handleDelete(request, response, userId);
        } else if (path != null && path.equals("/update")) {
            handleUpdate(request, response, userId);
        }
    }

    /**
     * 메인 페이지 렌더링
     */
    private void renderMainPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<PromptMeme> allPromptMemes = promptMemeService.getAllPromptMemes();
            List<PromptMeme> top3PromptMemes = promptMemeService.getTop3ByViewCount();

            // 사용자 닉네임 맵 생성
            Set<Long> userIds = new HashSet<>();
            if (allPromptMemes != null) {
                for (PromptMeme meme : allPromptMemes) {
                    if (meme.getUserId() != null) {
                        userIds.add(meme.getUserId());
                    }
                }
            }
            if (top3PromptMemes != null) {
                for (PromptMeme meme : top3PromptMemes) {
                    if (meme.getUserId() != null) {
                        userIds.add(meme.getUserId());
                    }
                }
            }

            Map<Long, String> userNicknameMap = buildUserNicknameMap(new ArrayList<>(userIds));

            request.setAttribute("promptMemes", allPromptMemes);
            request.setAttribute("top3PromptMemes", top3PromptMemes);
            request.setAttribute("userNicknameMap", userNicknameMap);

            request.getRequestDispatcher("/WEB-INF/jsp/prompt/main.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "서버 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * 상세 페이지 렌더링
     */
    private void renderDetailPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID가 필요합니다.");
            return;
        }

        try {
            Long id = Long.parseLong(idStr);
            PromptMeme promptMeme = promptMemeService.getPromptMemeById(id);

            if (promptMeme == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "프롬프트 밈을 찾을 수 없습니다.");
                return;
            }

            // 세션에서 현재 사용자 ID 확인
            HttpSession session = request.getSession(false);
            Long currentUserId = null;
            if (session != null) {
                currentUserId = (Long) session.getAttribute("userId");
            }

            // 본인이 작성한 글이 아닐 때만 조회수 증가
            if (currentUserId == null || !promptMeme.getUserId().equals(currentUserId)) {
                promptMemeService.incrementViewCount(id);
                promptMeme.setViewCount(promptMeme.getViewCount() + 1);
            }

            request.setAttribute("promptMeme", promptMeme);
            request.getRequestDispatcher("/WEB-INF/jsp/prompt/detail.jsp")
                    .forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 ID 형식입니다.");
        }
    }

    /**
     * 검색 페이지 렌더링
     */
    private void renderSearchPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("q");
        List<PromptMeme> searchResults = null;

        if (keyword != null && !keyword.trim().isEmpty()) {
            searchResults = promptMemeService.searchByTitle(keyword.trim());
        } else {
            searchResults = promptMemeService.getAllPromptMemes();
        }

        // 사용자 닉네임 맵 생성
        Set<Long> userIds = new HashSet<>();
        if (searchResults != null && !searchResults.isEmpty()) {
            for (PromptMeme meme : searchResults) {
                if (meme.getUserId() != null) {
                    userIds.add(meme.getUserId());
                }
            }
        }

        Map<Long, String> userNicknameMap = buildUserNicknameMap(new ArrayList<>(userIds));

        request.setAttribute("keyword", keyword);
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("userNicknameMap", userNicknameMap);

        request.getRequestDispatcher("/WEB-INF/jsp/prompt/search.jsp")
                .forward(request, response);
    }

    /**
     * 수정 폼 렌더링
     */
    private void renderEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID가 필요합니다.");
            return;
        }

        try {
            Long id = Long.parseLong(idStr);
            PromptMeme promptMeme = promptMemeService.getPromptMemeById(id);
            if (promptMeme == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "프롬프트 밈을 찾을 수 없습니다.");
                return;
            }

            Long sessionUserId = (Long) session.getAttribute("userId");
            if (!promptMeme.getUserId().equals(sessionUserId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "수정 권한이 없습니다.");
                return;
            }

            request.setAttribute("promptMeme", promptMeme);
            request.setAttribute("aiTypes", AIType.values());
            request.getRequestDispatcher("/WEB-INF/jsp/prompt/edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 ID 형식입니다.");
        }
    }

    /**
     * 삭제 처리
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID가 필요합니다.");
            return;
        }

        try {
            Long id = Long.parseLong(idStr);
            PromptMeme promptMeme = promptMemeService.getPromptMemeById(id);

            if (promptMeme == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "프롬프트 밈을 찾을 수 없습니다.");
                return;
            }

            // 본인 글만 삭제 가능
            if (!promptMeme.getUserId().equals(userId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "삭제 권한이 없습니다.");
                return;
            }

            promptMemeService.deletePromptMeme(id);
            response.sendRedirect(request.getContextPath() + "/mypage");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 ID 형식입니다.");
        }
    }

    /**
     * 업데이트 처리
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID가 필요합니다.");
            return;
        }

        try {
            Long id = Long.parseLong(idStr);
            PromptMeme promptMeme = promptMemeService.getPromptMemeById(id);

            if (promptMeme == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "프롬프트 밈을 찾을 수 없습니다.");
                return;
            }

            if (!promptMeme.getUserId().equals(userId)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "수정 권한이 없습니다.");
                return;
            }

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String promptContent = request.getParameter("prompt");
            String snsUrl = request.getParameter("snsUrl");
            String aiType = request.getParameter("ai");

            List<String> errors = new ArrayList<>();

            if (title == null || title.trim().isEmpty()) {
                errors.add("제목을 입력해주세요.");
            }
            if (promptContent == null || promptContent.trim().isEmpty()) {
                errors.add("프롬프트 내용을 입력해주세요.");
            }
            if (aiType == null || aiType.trim().isEmpty()) {
                errors.add("AI 종류를 선택해주세요.");
            }

            AIType selectedAiType = null;
            if (aiType != null && !aiType.trim().isEmpty()) {
                selectedAiType = AIType.fromValue(aiType.trim());
                if (selectedAiType == null) {
                    errors.add("올바르지 않은 AI 타입입니다.");
                }
            }

            if (!errors.isEmpty()) {
                promptMeme.setTitle(title);
                promptMeme.setDescription(description);
                promptMeme.setPromptContent(promptContent);
                promptMeme.setSnsUrl(snsUrl);
                promptMeme.setAiType(aiType);

                request.setAttribute("errors", errors);
                request.setAttribute("promptMeme", promptMeme);
                request.setAttribute("aiTypes", AIType.values());
                request.getRequestDispatcher("/WEB-INF/jsp/prompt/edit.jsp").forward(request, response);
                return;
            }

            promptMeme.setTitle(title.trim());
            promptMeme.setDescription(description != null && !description.trim().isEmpty() ? description.trim() : null);
            promptMeme.setPromptContent(promptContent.trim());
            promptMeme.setSnsUrl(snsUrl != null && !snsUrl.trim().isEmpty() ? snsUrl.trim() : null);

            if (selectedAiType != null) {
                promptMeme.setAiTypeEnum(selectedAiType);
            }

            // 이미지 파일 업로드 처리
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                if (fileName != null && !fileName.isEmpty()) {
                    // 파일 확장자 검증
                    String extension = "";
                    int lastDot = fileName.lastIndexOf('.');
                    if (lastDot > 0) {
                        extension = fileName.substring(lastDot + 1).toLowerCase();
                    }

                    // 이미지 파일만 허용
                    if (extension.matches("jpg|jpeg|png|gif|webp")) {
                        // [변경 1] 저장 경로를 프로젝트 소스 폴더의 절대 경로로 설정
                        String uploadDir = new File("src/main/webapp/uploads").getAbsolutePath();

                        // 기존 이미지 파일 삭제 (있는 경우)
                        String oldImageUrl = promptMeme.getImageUrl();
                        if (oldImageUrl != null && !oldImageUrl.isEmpty()) {
                            try {
                                String oldFileName = oldImageUrl.substring(oldImageUrl.lastIndexOf('/') + 1);

                                // [변경 2] 위에서 만든 절대 경로(uploadDir)를 사용하여 삭제할 파일 찾기
                                File oldFile = new File(uploadDir, oldFileName);

                                if (oldFile.exists()) {
                                    oldFile.delete();
                                }
                            } catch (Exception e) {
                                // 기존 파일 삭제 실패는 무시 (로그만 남김)
                                e.printStackTrace();
                            }
                        }

                        // 폴더가 없으면 생성
                        File uploadDirFile = new File(uploadDir);
                        if (!uploadDirFile.exists()) {
                            uploadDirFile.mkdirs();
                        }

                        // 고유한 파일명 생성
                        String uniqueFileName = UUID.randomUUID().toString() + "." + extension;
                        String filePath = uploadDir + File.separator + uniqueFileName;

                        // [변경 3] 설정한 경로에 파일 저장
                        filePart.write(filePath);

                        // DB에는 웹 접근 경로(/uploads/...)로 저장
                        promptMeme.setImageUrl(uniqueFileName);
                    } else {
                        errors.add("이미지 파일은 JPG, PNG, GIF, WEBP 형식만 지원됩니다.");
                    }
                }
            }

            // 이미지 파일 검증 오류가 있으면 다시 폼으로
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("promptMeme", promptMeme);
                request.setAttribute("aiTypes", AIType.values());
                request.getRequestDispatcher("/WEB-INF/jsp/prompt/edit.jsp").forward(request, response);
                return;
            }

            promptMemeService.updatePromptMeme(promptMeme);
            response.sendRedirect(request.getContextPath() + "/prompt/detail?id=" + id);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 ID 형식입니다.");
        }
    }

    /**
     * 사용자 ID 목록으로부터 닉네임 맵 생성 (N+1 쿼리 문제 해결)
     * 
     * @param userIds 사용자 ID 목록
     * @return 사용자 ID를 키로, 닉네임을 값으로 하는 맵
     */
    private Map<Long, String> buildUserNicknameMap(List<Long> userIds) {
        Map<Long, String> userNicknameMap = new HashMap<>();

        if (userIds == null || userIds.isEmpty()) {
            return userNicknameMap;
        }

        try {
            UserService userService = new UserServiceImpl();
            List<User> users = userService.getUsersByIds(userIds);

            for (User user : users) {
                if (user != null && user.getNickname() != null) {
                    userNicknameMap.put(user.getId(), user.getNickname());
                }
            }

            // 조회되지 않은 사용자에 대한 기본값 설정
            for (Long userId : userIds) {
                if (!userNicknameMap.containsKey(userId)) {
                    userNicknameMap.put(userId, "알 수 없음");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시 모든 사용자에 대해 기본값 설정
            for (Long userId : userIds) {
                userNicknameMap.put(userId, "알 수 없음");
            }
        }

        return userNicknameMap;
    }
}