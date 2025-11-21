package com.pommy.filter;

import java.io.IOException;

import jakarta.servlet.*;

/**
 * 문자 인코딩 필터
 * 모든 요청과 응답에 UTF-8 인코딩을 적용
 */
public class CharacterEncodingFilter implements Filter {

    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.isEmpty()) {
            encoding = encodingParam;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        // 요청 인코딩 설정
        request.setCharacterEncoding(encoding);
        // 응답 인코딩 설정
        response.setCharacterEncoding(encoding);
        response.setContentType("text/html; charset=" + encoding);

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 리소스 정리 (필요한 경우)
    }
}
