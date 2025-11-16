package com.ems.controller;

import com.ems.dao.CmsPageDAO;
import com.ems.model.CmsPage;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/cms/pages")
public class CmsPageEditorServlet extends HttpServlet {
    private CmsPageDAO pageDAO;
    private Gson gson;

    @Override
    public void init() {
        pageDAO = new CmsPageDAO();
        gson = new Gson();
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        
        // Handle JSON data fetch for editing
        if ("fetch".equalsIgnoreCase(action)) {
            handleFetchPage(request, response);
            return;
        }
        
        if ("delete".equalsIgnoreCase(action)) {
            handleDelete(request, response);
            return;
        }

        super.service(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Transfer success/error messages from redirect parameters to the request
        String successMessage = request.getParameter("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
        }
        String errorMessage = request.getParameter("errorMessage");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        }

        try {
            request.setAttribute("pages", pageDAO.getAllPages());
        } catch (SQLException e) {
            request.setAttribute("errorMessage", 
                (request.getAttribute("errorMessage") != null ? 
                 request.getAttribute("errorMessage") + " AND " : "") + 
                "Failed to load pages: " + e.getMessage());
        }

        request.getRequestDispatcher("/cms_pages.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id"); 
        String slug = request.getParameter("slug");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String status = request.getParameter("status"); 
        
        // Input Validation
        if (slug == null || slug.trim().isEmpty() || 
            title == null || title.trim().isEmpty()) {
            handleValidationError(request, response, "Slug and title are required fields.");
            return;
        }
        
        // Clean inputs
        slug = slug.trim();
        title = title.trim();
        content = content != null ? content.trim() : "";
        
        CmsPage page = new CmsPage();
        long id = 0;

        if (idParam != null && !idParam.isEmpty()) {
            try {
                id = Long.parseLong(idParam);
                page.setId(id);
            } catch (NumberFormatException e) {
                handleValidationError(request, response, "Invalid page ID format.");
                return;
            }
        }

        page.setSlug(slug);
        page.setTitle(title);
        page.setContent(content);
        page.setStatus(status != null && !status.isEmpty() ? status : "DRAFT");
        
        String successMsg = (id == 0) ? "Page created successfully!" : "Page updated successfully!";
        
        try {
            // Check for duplicate slug
            if (id == 0) {
                if (pageDAO.slugExists(slug)) {
                    handleValidationError(request, response, "A page with this slug already exists.");
                    return;
                }
            } else {
                if (pageDAO.slugExists(slug, id)) {
                    handleValidationError(request, response, "A page with this slug already exists.");
                    return;
                }
            }
            
            pageDAO.saveOrUpdate(page); 
            
            String encodedMsg = URLEncoder.encode(successMsg, StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/admin/cms/pages?successMessage=" + encodedMsg);

        } catch (SQLException e) {
            handleDatabaseError(request, response, "Failed to save page: " + e.getMessage());
        }
    }

    protected void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String redirectURI = request.getContextPath() + "/admin/cms/pages";

        if (idParam == null || idParam.isEmpty()) {
            String encodedMsg = URLEncoder.encode("Page ID is required for deletion.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectURI + "?errorMessage=" + encodedMsg);
            return;
        }

        try {
            long id = Long.parseLong(idParam);
            pageDAO.delete(id); 
            
            String encodedMsg = URLEncoder.encode("Page deleted successfully.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectURI + "?successMessage=" + encodedMsg);

        } catch (NumberFormatException e) {
            String encodedMsg = URLEncoder.encode("Invalid page ID format.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectURI + "?errorMessage=" + encodedMsg);
        } catch (SQLException e) {
            String encodedMsg = URLEncoder.encode("Failed to delete page: " + e.getMessage(), StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectURI + "?errorMessage=" + encodedMsg);
        }
    }

    /**
     * Handle JSON fetch for page data (for editing)
     */
    protected void handleFetchPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            sendJsonError(response, "Page ID is required");
            return;
        }

        try {
            long id = Long.parseLong(idParam);
            CmsPage page = pageDAO.getPageById(id);
            
            if (page == null) {
                sendJsonError(response, "Page not found");
                return;
            }
            
            // Set response type to JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            // Convert page object to JSON
            String pageJson = gson.toJson(page);
            response.getWriter().write(pageJson);
            
        } catch (NumberFormatException e) {
            sendJsonError(response, "Invalid page ID format");
        } catch (SQLException e) {
            sendJsonError(response, "Database error: " + e.getMessage());
        }
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"error\": \"" + message + "\"}");
    }

    private void handleValidationError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        try {
            request.setAttribute("pages", pageDAO.getAllPages());
        } catch (SQLException e) {
            request.setAttribute("errorMessage", errorMessage + " Also failed to reload pages: " + e.getMessage());
        }
        request.getRequestDispatcher("/cms_pages.jsp").forward(request, response);
    }
    
    private void handleDatabaseError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        try {
            request.setAttribute("pages", pageDAO.getAllPages());
        } catch (SQLException nestedException) {
            request.setAttribute("errorMessage", errorMessage + " AND failed to reload page list: " + nestedException.getMessage());
        }
        request.getRequestDispatcher("/cms_pages.jsp").forward(request, response);
    }
}