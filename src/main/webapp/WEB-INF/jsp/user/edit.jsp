<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pommy.model.User" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/mypage");
        return;
    }

    List<String> errors = (List<String>) request.getAttribute("errors");
    String successMessage = (String) request.getAttribute("successMessage");

    String nicknameValue = (String) request.getAttribute("formNickname");
    if (nicknameValue == null && user.getNickname() != null) {
        nicknameValue = user.getNickname();
    }
%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="../../jspf/header.jspf" %>
<body class="bg-background">
    <div class="max-w-2xl mx-auto mt-24 px-6 pb-12">
        <button onclick="location.href='${pageContext.request.contextPath}/mypage'" class="text-sm text-gray-600 hover:text-point transition-colors mb-6 inline-flex items-center gap-1">
            &larr; 마이페이지로
        </button>

        <div class="bg-white rounded-2xl shadow-lg p-8 space-y-6">
            <header class="space-y-1">
                <p class="text-sm text-gray-500">내 정보</p>
                <h1 class="text-3xl font-bold text-gray-800">프로필 수정</h1>
                <p class="text-gray-500 text-sm">아이디는 변경할 수 없으며, 닉네임과 비밀번호를 관리할 수 있습니다.</p>
            </header>

            <% if (successMessage != null) { %>
                <div class="bg-emerald-50 text-emerald-700 px-4 py-3 rounded-lg text-sm">
                    <%= successMessage %>
                </div>
            <% } %>

            <% if (errors != null && !errors.isEmpty()) { %>
                <div class="bg-red-50 text-red-700 px-4 py-3 rounded-lg text-sm space-y-1">
                    <% for (String error : errors) { %>
                        <p><%= error %></p>
                    <% } %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/mypage/edit" method="post" class="space-y-5">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-1">아이디 (변경 불가)</label>
                    <input type="text" value="<%= user.getUsername() != null ? user.getUsername() : "" %>" readonly
                           class="w-full px-4 py-3 rounded-lg border border-gray-200 bg-gray-50 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label for="nickname" class="block text-sm font-semibold text-gray-700 mb-1">닉네임</label>
                    <input type="text" id="nickname" name="nickname" value="<%= nicknameValue != null ? nicknameValue : "" %>" required
                           class="w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-point focus:ring-2 focus:ring-point/30 transition">
                    <p class="text-xs text-gray-400 mt-1">2~20자 사이로 설정해주세요.</p>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label for="password" class="block text-sm font-semibold text-gray-700 mb-1">새 비밀번호</label>
                        <input type="password" id="password" name="password" placeholder="변경 시에만 입력"
                               class="w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-point focus:ring-2 focus:ring-point/30 transition">
                        <p class="text-xs text-gray-400 mt-1">8자 이상, 영문과 숫자를 포함해야 합니다.</p>
                    </div>
                    <div>
                        <label for="confirmPassword" class="block text-sm font-semibold text-gray-700 mb-1">비밀번호 확인</label>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               class="w-full px-4 py-3 rounded-lg border border-gray-200 focus:border-point focus:ring-2 focus:ring-point/30 transition">
                    </div>
                </div>

                <div class="flex items-center justify-end gap-3 pt-4">
                    <button type="button" onclick="location.href='${pageContext.request.contextPath}/mypage'"
                            class="px-5 py-3 rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-50 transition">
                        취소
                    </button>
                    <button type="submit"
                            class="px-6 py-3 rounded-lg bg-point text-white font-semibold shadow hover:bg-point/90 transition">
                        변경 사항 저장
                    </button>
                </div>
            </form>
        </div>
    </div>
    <%@ include file="../../jspf/footer.jspf" %>
</body>
</html>

