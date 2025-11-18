<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String nickname = request.getParameter("nickname");
    // DB 저장 로직 생략
    session.setAttribute("nickname", nickname);
    response.sendRedirect("../main.jsp");
%>