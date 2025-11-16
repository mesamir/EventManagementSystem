package com.ems.controller;

import com.ems.dao.CmsBannerDAO;
import com.ems.model.CmsBanner;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.*;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/cms/banners")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024)
public class CmsBannerServlet extends HttpServlet {
    private CmsBannerDAO bannerDAO;

    @Override
    public void init() {
        bannerDAO = new CmsBannerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<CmsBanner> banners = bannerDAO.getAllBanners();
            request.setAttribute("banners", banners);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Failed to load banners.");
        }
        request.getRequestDispatcher("/cms_banners.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Part filePart = request.getPart("bannerImage");
        String altText = request.getParameter("altText");
        String position = request.getParameter("position");
        boolean active = "on".equals(request.getParameter("active"));

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadDir = getServletContext().getRealPath("/uploads/banners");
        Files.createDirectories(Paths.get(uploadDir));
        String filePath = uploadDir + File.separator + fileName;

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);
        }

        CmsBanner banner = new CmsBanner();
        banner.setImageUrl("uploads/banners/" + fileName);
        banner.setAltText(altText);
        banner.setPosition(position);
        banner.setActive(active);

        try {
            bannerDAO.saveBanner(banner);
            response.sendRedirect("banners?successMessage=Banner uploaded successfully");
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Failed to save banner.");
            doGet(request, response);
        }
    }
}

