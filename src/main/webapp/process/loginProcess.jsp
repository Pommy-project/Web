<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    // 실제로는 DB 검증 필요
    if (id != null && !id.equals("")) {
        session.setAttribute("nickname", id); // 편의상 ID를 닉네임으로 사용
        response.sendRedirect("../main.jsp");
    } else {
        response.sendRedirect("../login.jsp?error=1");
    }
%>