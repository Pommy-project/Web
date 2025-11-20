package com.pommy.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.pommy.model.PromptMeme;
import com.pommy.service.PromptMemeService;
import com.pommy.service.PromptMemeServiceImpl;

/**
 * 프롬프트 밈 관련 요청을 처리하는 컨트롤러
 * 메인 페이지, 상세 페이지, 검색 페이지 처리
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
            List<PromptMeme> allPromptMemes = promptMemeService.getAllPromptMemes();
            List<PromptMeme> top3PromptMemes = promptMemeService.getTop3ByViewCount();
            
            request.setAttribute("promptMemes", allPromptMemes);
            request.setAttribute("top3PromptMemes", top3PromptMemes);
            
            request.getRequestDispatcher("/WEB-INF/jsp/prompt/main.jsp")
                    .forward(request, response);
        } else if (path.equals("/detail")) {
            // 상세 페이지 표시
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    Long id = Long.parseLong(idStr);
                    PromptMeme promptMeme = promptMemeService.getPromptMemeById(id);
                    
                    if (promptMeme != null) {
                        // 조회수 증가
                        promptMemeService.incrementViewCount(id);
                        promptMeme.setViewCount(promptMeme.getViewCount() + 1);
                        
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
            
            request.setAttribute("keyword", keyword);
            request.setAttribute("searchResults", searchResults);
            
            request.getRequestDispatcher("/WEB-INF/jsp/prompt/search.jsp")
                    .forward(request, response);
        }
    }
}

