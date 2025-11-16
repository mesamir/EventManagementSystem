package com.ems.controller;

import com.ems.dao.CmsPageDAO;
import com.ems.model.CmsPage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/pages/*") // More specific pattern
public class PageDisplayServlet extends HttpServlet {
    private CmsPageDAO pageDAO;

    @Override
    public void init() {
        pageDAO = new CmsPageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            try {
                // Show list of published pages or redirect
                showPublishedPagesList(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(PageDisplayServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            return;
        }
        
        // Extract slug from /pages/our-vendor -> our-vendor
        String slug = pathInfo.substring(1); // Remove leading slash
        
        try {
            CmsPage page = pageDAO.getPageBySlug(slug);
            
            if (page != null && "PUBLISHED".equals(page.getStatus())) {
                request.setAttribute("page", page);
                request.getRequestDispatcher("/page-template.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found or not published");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
    
    private void showPublishedPagesList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        request.setAttribute("publishedPages", pageDAO.getPagesByStatus("PUBLISHED"));
        request.getRequestDispatcher("/pages-list.jsp").forward(request, response);
    }
}