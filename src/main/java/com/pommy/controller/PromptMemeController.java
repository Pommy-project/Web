package com.pommy.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
            // 메인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/prompt/main");
        } else if (path.equals("/main")) {
            // 메인 페이지 표시
            try {
                List<PromptMeme> allPromptMemes = promptMemeService.getAllPromptMemes();
                List<PromptMeme> top3PromptMemes = promptMemeService.getTop3ByViewCount();

                // 성능 개선: N+1 쿼리 문제 해결
                // 모든 프롬프트의 userId를 모아서 한 번에 조회
                Map<Long, String> userNicknameMap = new HashMap<>();
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

                // 한 번에 모든 사용자 조회 (단일 쿼리로 최적화)
                if (!userIds.isEmpty()) {
                    UserService userService = new UserServiceImpl();
                    List<Long> userIdList = new ArrayList<>(userIds);
                    List<User> users = userService.getUsersByIds(userIdList);

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
                }

                request.setAttribute("promptMemes", allPromptMemes);
                request.setAttribute("top3PromptMemes", top3PromptMemes);
                request.setAttribute("userNicknameMap", userNicknameMap); // 사용자 닉네임 맵 전달

                request.getRequestDispatcher("/WEB-INF/jsp/prompt/main.jsp")
                        .forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다: " + e.getMessage());
            }
        } else if (path.equals("/detail")) {
            // 상세 페이지 표시
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    Long id = Long.parseLong(idStr);
                    PromptMeme promptMeme = promptMemeService.getPromptMemeById(id);

                    if (promptMeme != null) {
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
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "프롬프트 밈을 찾을 수 없습니다.");
                        return;
                    }
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 ID 형식입니다.");
                    return;
                }
            }
            request.getRequestDispatcher("/WEB-INF/jsp/prompt/detail.jsp")
                    .forward(request, response);
        } else if (path.equals("/search")) {
            // 검색 페이지 표시
            String keyword = request.getParameter("q");
            List<PromptMeme> searchResults = null;

            if (keyword != null && !keyword.trim().isEmpty()) {
                searchResults = promptMemeService.searchByTitle(keyword.trim());
            } else {
                // 키워드가 없으면 전체 목록
                searchResults = promptMemeService.getAllPromptMemes();
            }

            // 성능 개선: N+1 쿼리 문제 해결
            // 모든 검색 결과의 userId를 모아서 한 번에 조회
            Map<Long, String> userNicknameMap = new HashMap<>();
            if (searchResults != null && !searchResults.isEmpty()) {
                Set<Long> userIds = new HashSet<>();
                for (PromptMeme meme : searchResults) {
                    if (meme.getUserId() != null) {
                        userIds.add(meme.getUserId());
                    }
                }

                // 한 번에 모든 사용자 조회 (단일 쿼리로 최적화)
                if (!userIds.isEmpty()) {
                    UserService userService = new UserServiceImpl();
                    List<Long> userIdList = new ArrayList<>(userIds);
                    List<User> users = userService.getUsersByIds(userIdList);

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
                }
            }

            request.setAttribute("keyword", keyword);
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("userNicknameMap", userNicknameMap); // 사용자 닉네임 맵 전달

            request.getRequestDispatcher("/WEB-INF/jsp/prompt/search.jsp")
                    .forward(request, response);
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
            // 삭제 처리
            String idStr = request.getParameter("id");
            if (idStr != null) {
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
        } else if (path != null && path.equals("/update")) {
            // 업데이트 처리
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    Long id = Long.parseLong(idStr);
                    PromptMeme promptMeme = promptMemeService.getPromptMemeById(id);

                    if (promptMeme == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "프롬프트 밈을 찾을 수 없습니다.");
                        return;
                    }

                    // 본인 글만 수정 가능
                    if (!promptMeme.getUserId().equals(userId)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "수정 권한이 없습니다.");
                        return;
                    }

                    // 업데이트할 데이터 받기
                    String title = request.getParameter("title");
                    String description = request.getParameter("description");
                    String promptContent = request.getParameter("prompt");
                    String snsUrl = request.getParameter("snsUrl");
                    String aiType = request.getParameter("ai"); // 단일 AI 타입만 받기

                    if (title != null && !title.trim().isEmpty()) {
                        promptMeme.setTitle(title.trim());
                    }
                    if (description != null) {
                        promptMeme.setDescription(description.trim().isEmpty() ? null : description.trim());
                    }
                    if (promptContent != null && !promptContent.trim().isEmpty()) {
                        promptMeme.setPromptContent(promptContent.trim());
                    }
                    if (snsUrl != null) {
                        promptMeme.setSnsUrl(snsUrl.trim().isEmpty() ? null : snsUrl.trim());
                    }
                    // AI 타입 단일 선택 처리
                    if (aiType != null && !aiType.trim().isEmpty()) {
                        AIType selectedAiType = AIType.fromValue(aiType.trim());
                        if (selectedAiType != null) {
                            promptMeme.setAiTypeEnum(selectedAiType); // 단일 AI 타입만 설정
                        }
                    }

                    promptMemeService.updatePromptMeme(promptMeme);
                    response.sendRedirect(request.getContextPath() + "/prompt/detail?id=" + id);
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 ID 형식입니다.");
                }
            }
        }
    }
}