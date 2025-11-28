package com.pommy.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;

@WebServlet("/file/image")
public class FileServeController extends HttpServlet {

    private String uploadDir;

    @Override
    public void init() {
        try {
            // FileServeController.class 파일의 실제 위치 찾기
            String classPath = FileServeController.class
                    .getProtectionDomain()
                    .getCodeSource()
                    .getLocation()
                    .getPath();

            File classFile = new File(classPath);
            File projectRoot = classFile.getParentFile().getParentFile().getParentFile().getParentFile();

            uploadDir = projectRoot.getAbsolutePath() + "/src/main/webapp/uploads/";
            System.out.println("[FileServeController] (resolved) uploadDir = " + uploadDir);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String filename = request.getParameter("name");
        if (filename == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // ★ 추가된 부분: "/uploads/파일명" → "파일명"으로 자동 변환
        if (filename.startsWith("/uploads/")) {
            filename = filename.substring("/uploads/".length());
        } else if (filename.startsWith("uploads/")) {
            filename = filename.substring("uploads/".length());
        }

        // 앞뒤 슬래시 제거
        filename = filename.replaceAll("^/+", "").trim();

        File file = new File(uploadDir + filename);

        System.out.println("[FileServeController] 요청 파일 = " + file.getAbsolutePath());


        if (!file.exists()) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mimeType = request.getServletContext().getMimeType(filename);
        if (mimeType == null) mimeType = "application/octet-stream";
        response.setContentType(mimeType);

        java.nio.file.Files.copy(file.toPath(), response.getOutputStream());
    }
}

