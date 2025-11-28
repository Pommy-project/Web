package com.pommy.controller;

import java.io.IOException;
import java.util.ArrayList;
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
import com.pommy.util.PasswordUtil;

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
        String path = request.getPathInfo();
        if (path == null || "/".equals(path)) {
            renderMypage(request, response);
        } else if ("/edit".equals(path)) {
            renderEditForm(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if ("/edit".equals(path)) {
            handleProfileUpdate(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    /**
     * 마이페이지 렌더링
     */
    private void renderMypage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Long userId = (Long) session.getAttribute("userId");
            String nickname = (String) session.getAttribute("nickname");

            User user = userService.getUserById(userId);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "사용자를 찾을 수 없습니다.");
                return;
            }

            List<PromptMeme> myPromptMemes = promptMemeService.getPromptMemesByUserId(userId);
            if (myPromptMemes == null) {
                myPromptMemes = new ArrayList<>();
            }

            request.setAttribute("user", user);
            request.setAttribute("myNickname", nickname != null ? nickname : user.getNickname());
            request.setAttribute("myPromptMemes", myPromptMemes);

            request.getRequestDispatcher("/WEB-INF/jsp/user/mypage.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "서버 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * 프로필 수정 폼 렌더링
     */
    private void renderEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Long userId = (Long) session.getAttribute("userId");
            User user = userService.getUserById(userId);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "사용자를 찾을 수 없습니다.");
                return;
            }

            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/jsp/user/edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "서버 오류가 발생했습니다: " + e.getMessage());
        }
    }

    /**
     * 프로필 업데이트 처리
     */
    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");
        try {
            User user = userService.getUserById(userId);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "사용자를 찾을 수 없습니다.");
                return;
            }

            String nickname = request.getParameter("nickname");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            List<String> errors = new ArrayList<>();

            if (nickname == null || nickname.trim().isEmpty()) {
                errors.add("닉네임을 입력해주세요.");
            } else if (nickname.trim().length() < 2 || nickname.trim().length() > 20) {
                errors.add("닉네임은 2-20자여야 합니다.");
            }

            boolean passwordProvided = password != null && !password.trim().isEmpty();
            if (passwordProvided) {
                if (password.trim().length() < 8 || !password.trim().matches("^(?=.*[a-zA-Z])(?=.*[0-9]).+$")) {
                    errors.add("비밀번호는 최소 8자이며 영문과 숫자를 포함해야 합니다.");
                }
                if (confirmPassword == null || !password.trim().equals(confirmPassword.trim())) {
                    errors.add("비밀번호와 확인 비밀번호가 일치하지 않습니다.");
                }
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("user", user);
                request.setAttribute("formNickname", nickname);
                request.getRequestDispatcher("/WEB-INF/jsp/user/edit.jsp").forward(request, response);
                return;
            }

            user.setNickname(nickname.trim());
            if (passwordProvided) {
                user.setPassword(PasswordUtil.hashPassword(password.trim()));
            }

            userService.updateUser(user);
            session.setAttribute("nickname", user.getNickname());

            request.setAttribute("user", user);
            request.setAttribute("successMessage", "회원 정보가 수정되었습니다.");
            request.getRequestDispatcher("/WEB-INF/jsp/user/edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "서버 오류가 발생했습니다: " + e.getMessage());
        }
    }
}
