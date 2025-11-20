package com.pommy.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * 루트 경로(/) 요청을 처리하는 컨트롤러
 * home/home.jsp로 포워드
 */
@WebServlet("/index")
public class IndexController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // home/home.jsp로 포워드
        request.getRequestDispatcher("/WEB-INF/jsp/home/home.jsp")
                .forward(request, response);
    }
}
