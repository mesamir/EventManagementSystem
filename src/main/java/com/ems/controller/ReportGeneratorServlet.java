// src/main/java/com/ems/controller/ReportGeneratorServlet.java
package com.ems.controller;

import com.ems.model.Admin;
import com.ems.model.User;
import com.ems.service.ReportManager;
import com.ems.util.ReportHtmlBuilder;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet dedicated to handling AJAX requests for generating dynamic reports.
 * It receives report type, time filters, and status filters, and returns
 * the corresponding HTML content to be injected into the dashboard.
 */
@WebServlet("/admin/reports/generate")
public class ReportGeneratorServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ReportGeneratorServlet.class.getName());
    private ReportManager reportManager;

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize the dedicated ReportManager service
        reportManager = new ReportManager();
    }

   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Authorization check
        if (session == null || session.getAttribute("loggedInUser") == null) {
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, 
                "Unauthorized access. Please log in.");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            sendErrorResponse(response, HttpServletResponse.SC_FORBIDDEN, 
                "Access Denied. Admin privileges required.");
            return;
        }

        String reportType = request.getParameter("type");
        String timeFilter = request.getParameter("time");
        String statusFilter = request.getParameter("status");

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try {
            if (reportType == null || reportType.trim().isEmpty()) {
                throw new IllegalArgumentException("No report type specified.");
            }

            List<?> reportData = reportManager.getReportData(reportType, timeFilter, statusFilter);
            String htmlReport = ReportHtmlBuilder.buildHtmlTable(reportType, reportData);

            response.getWriter().write(htmlReport);

        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid report request: {0}", e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error generating report: " + reportType, e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Database error occurred while generating report.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error generating report: " + reportType, e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "An unexpected error occurred.");
        }
    }

    private void sendErrorResponse(HttpServletResponse response, int status, String message) 
            throws IOException {
        response.setStatus(status);
        response.getWriter().write(
            "<div class='p-4 bg-red-50 border border-red-200 rounded-lg'>" +
            "<p class='text-red-700'><i class='fas fa-exclamation-circle mr-2'></i>" + message + "</p>" +
            "</div>"
        );
    }
    // Validate and sanitize report type
        private boolean isValidReportType(String reportType) {
            return Arrays.asList(
                "financial_report", "event_summary_report", "vendor_performance_report", 
                "full_vendor_report", "full_payments_report"
            ).contains(reportType);
        }
}