package com.pommy.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.pommy.model.User;
import com.pommy.service.UserService;
import com.pommy.service.UserServiceImpl;
import com.pommy.util.PasswordUtil;

/**
 * 인증 관련 요청을 처리하는 컨트롤러
 * 로그인, 로그아웃, 회원가입 처리
 */
@WebServlet("/auth/*")
public class AuthController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();

        if (path == null || path.equals("/")) {
            // 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/auth/login");
        } else if (path.equals("/login")) {
            // 로그인 페이지 표시
            request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp")
                    .forward(request, response);
        } else if (path.equals("/signup")) {
            // 회원가입 페이지 표시
            request.getRequestDispatcher("/WEB-INF/jsp/auth/signup.jsp")
                    .forward(request, response);
        } else if (path.equals("/logout")) {
            // 로그아웃 처리
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/prompt/main");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();

        if (path != null && path.equals("/login")) {
            // 로그인 처리
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            // 입력 검증
            if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
                request.setAttribute("errorMessage", "아이디와 비밀번호를 입력해주세요.");
                request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp")
                        .forward(request, response);
                return;
            }

            username = username.trim();

            // 아이디 형식 검증
            if (!username.matches("^[a-zA-Z0-9]{4,20}$")) {
                request.setAttribute("errorMessage", "아이디는 영문, 숫자만 사용 가능하며 4-20자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp")
                        .forward(request, response);
                return;
            }

            User user = userService.getUserByUsername(username);

            if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
                // 비밀번호 검증 성공 (BCrypt로 해시 비교)
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("nickname", user.getNickname());
                session.setAttribute("username", user.getUsername());

                response.sendRedirect(request.getContextPath() + "/prompt/main");
            } else {
                // 로그인 실패
                request.setAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
                request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp")
                        .forward(request, response);
            }

        } else if (path != null && path.equals("/signup")) {
            // 회원가입 처리
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String nickname = request.getParameter("nickname");

            // 입력 검증
            if (username == null || password == null || nickname == null
                    || username.trim().isEmpty() || password.trim().isEmpty() || nickname.trim().isEmpty()) {
                request.setAttribute("errorMessage", "모든 필드를 입력해주세요.");
                request.getRequestDispatcher("/WEB-INF/jsp/auth/signup.jsp")
                        .forward(request, response);
                return;
            }

            username = username.trim();
            nickname = nickname.trim();

            // 아이디 형식 검증
            if (!username.matches("^[a-zA-Z0-9]{4,20}$")) {
                request.setAttribute("errorMessage", "아이디는 영문, 숫자만 사용 가능하며 4-20자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/jsp/auth/signup.jsp")
                        .forward(request, response);
                return;
            }

            // 비밀번호 형식 검증
            if (password.length() < 8 || !password.matches("^(?=.*[a-zA-Z])(?=.*[0-9]).+$")) {
                request.setAttribute("errorMessage", "비밀번호는 최소 8자 이상이며 영문과 숫자를 포함해야 합니다.");
                request.getRequestDispatcher("/WEB-INF/jsp/auth/signup.jsp")
                        .forward(request, response);
                return;
            }

            // 닉네임 형식 검증
            if (nickname.length() < 2 || nickname.length() > 20) {
                request.setAttribute("errorMessage", "닉네임은 2-20자여야 합니다.");
                request.getRequestDispatcher("/WEB-INF/jsp/auth/signup.jsp")
                        .forward(request, response);
                return;
            }

            // 중복 아이디 체크
            User existingUser = userService.getUserByUsername(username);
            if (existingUser != null) {
                request.setAttribute("errorMessage", "이미 존재하는 아이디입니다.");
                request.getRequestDispatcher("/WEB-INF/jsp/auth/signup.jsp")
                        .forward(request, response);
                return;
            }

            // 비밀번호 해시화 (BCrypt 사용)
            String hashedPassword = PasswordUtil.hashPassword(password);
            User user = new User(username, hashedPassword, nickname);
            userService.createUser(user);

            // 회원가입 후 자동 로그인
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("nickname", user.getNickname());
            session.setAttribute("username", user.getUsername());

            response.sendRedirect(request.getContextPath() + "/prompt/main");
        }
    }
}
