package com.pommy.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.pommy.model.User;
import com.pommy.model.PromptMeme;
import com.pommy.service.UserService;
import com.pommy.service.UserServiceImpl;
import com.pommy.service.PromptMemeService;
import com.pommy.service.PromptMemeServiceImpl;

/**
 * 마이페이지 관련 요청을 처리하는 컨트롤러
 */
@WebServlet("/mypage/*")
public class MypageController extends HttpServlet {

    private UserService userService;
    private PromptMemeService promptMemeService;

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserServiceImpl();
        promptMemeService = new PromptMemeServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            Long userId = (Long) session.getAttribute("userId");
            String nickname = (String) session.getAttribute("nickname");

            // 사용자 정보 조회
            User user = userService.getUserById(userId);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "사용자를 찾을 수 없습니다.");
                return;
            }

            // 사용자가 작성한 프롬프트 밈 조회
            List<PromptMeme> myPromptMemes = promptMemeService.getPromptMemesByUserId(userId);
            if (myPromptMemes == null) {
                myPromptMemes = new java.util.ArrayList<>();
            }

            request.setAttribute("user", user);
            request.setAttribute("myNickname", nickname != null ? nickname : user.getNickname());
            request.setAttribute("myPromptMemes", myPromptMemes);

            request.getRequestDispatcher("/WEB-INF/jsp/user/mypage.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다: " + e.getMessage());
        }
    }
}

