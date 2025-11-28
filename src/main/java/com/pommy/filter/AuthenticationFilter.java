package com.pommy.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 인증 필터
 * 세션이 필요한 경로에 대해 인증 여부를 확인
 */
public class AuthenticationFilter implements Filter {

    // 인증이 필요 없는 경로 목록
    private static final List<String> EXCLUDED_PATHS = Arrays.asList(
            "/auth/", // 인증 관련 페이지 (로그인, 회원가입, 로그아웃)
            "/prompt/main", // 메인 페이지
            "/prompt/detail", // 상세 페이지
            "/prompt/search", // 검색 페이지
            "/index", // 홈 페이지
            "/uploads/", // 업로드된 파일
            "/images/", // 이미지 리소스
            "/js/", // JavaScript 파일
            "/css/", // CSS 파일
            "/WEB-INF/jsp/error/" // 에러 페이지
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 초기화 작업 (필요한 경우)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestPath = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // 컨텍스트 경로 제거
        if (contextPath != null && !contextPath.isEmpty()) {
            requestPath = requestPath.substring(contextPath.length());
        }

        // 인증이 필요 없는 경로인지 확인
        if (isExcludedPath(requestPath)) {
            chain.doFilter(request, response);
            return;
        }

        // 세션 확인
        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            // 세션이 없거나 userId가 없으면 로그인 페이지로 리다이렉트
            httpResponse.sendRedirect(contextPath + "/auth/login");
            return;
        }

        // 인증된 사용자이면 다음 필터로 진행
        chain.doFilter(request, response);
    }

    /**
     * 요청 경로가 인증이 필요 없는 경로인지 확인
     * 
     * @param path 요청 경로
     * @return 인증이 필요 없으면 true, 필요하면 false
     */
    private boolean isExcludedPath(String path) {
        if (path == null || path.isEmpty()) {
            return true;
        }

        // 루트 경로 또는 홈 경로
        if (path.equals("/") || path.equals("")) {
            return true;
        }

        // 정확히 일치하는 경로 확인
        for (String excludedPath : EXCLUDED_PATHS) {
            if (path.equals(excludedPath) || path.startsWith(excludedPath)) {
                return true;
            }
        }

        // 정적 리소스 확인 (확장자 기반)
        if (path.matches(".*\\.(css|js|png|jpg|jpeg|gif|svg|ico|woff|woff2|ttf|eot)$")) {
            return true;
        }

        return false;
    }

    @Override
    public void destroy() {
        // 리소스 정리 (필요한 경우)
    }
}
