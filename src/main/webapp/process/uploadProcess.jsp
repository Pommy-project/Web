<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    // 1. 한글 깨짐 방지
    request.setCharacterEncoding("UTF-8");

    // 2. 폼 데이터 받기
    String title = request.getParameter("title");
    String desc = request.getParameter("description");
    String prompt = request.getParameter("prompt");
    String nickname = (String) session.getAttribute("nickname");
    
    // [중요] AI 다중 선택 값 받기 (getParameterValues 사용)
    String[] ais = request.getParameterValues("ai");
    
    // 3. 데이터 유효성 검사
    if (title == null || title.trim().isEmpty()) {
        response.sendRedirect("../upload.jsp?error=missing_title");
        return;
    }

    // 4. 데이터를 저장할 맵(Map) 생성 (DB 대신 임시 사용)
    Map<String, Object> newPost = new HashMap<>();
    newPost.put("id", System.currentTimeMillis()); // 고유 ID (시간 사용)
    newPost.put("title", title);
    newPost.put("desc", desc);
    newPost.put("prompt", prompt);
    newPost.put("author", nickname != null ? nickname : "익명");
    newPost.put("views", 0);
    
    // AI 리스트 처리
    List<String> aiList = (ais != null) ? Arrays.asList(ais) : new ArrayList<>();
    newPost.put("ais", aiList);

    // 5. 서버 전체 공유 공간(application)에 리스트 저장
    // (DB가 없으므로 서버가 켜져있는 동안만 메모리에 저장하는 방식)
    List<Map<String, Object>> postList = (List<Map<String, Object>>) application.getAttribute("globalPostList");
    
    if (postList == null) {
        postList = new ArrayList<>();
        application.setAttribute("globalPostList", postList);
    }
    
    // 최신 글이 맨 위에 오도록 0번 인덱스에 추가
    postList.add(0, newPost);

    // 6. 메인 페이지로 이동
    response.sendRedirect("../main.jsp");
%>