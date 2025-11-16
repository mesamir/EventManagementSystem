<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ems.service.ReportManager" %>
<%@ page import="com.ems.util.ReportHtmlBuilder" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.ems.model.User" %>

<%! 
    // This is a declaration block for methods or variables
    private ReportManager reportManager = new ReportManager();
%>

<%
    // Set content type for AJAX response
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");

    // --- Server-Side Authorization Check (essential even in JSPs) ---
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("loggedInUser") == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write("<p class='text-red-500'>Unauthorized access. Please log in.</p>");
        return;
    }
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.getWriter().write("<p class='text-red-500'>Access Denied: Not an Admin.</p>");
        return;
    }
    // --- End Authorization Check ---

    // Get parameters from the AJAX request
    String reportType = request.getParameter("type");
    String timeFilter = request.getParameter("time");
    String statusFilter = request.getParameter("status");

    if (reportType == null || reportType.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("<p class='text-red-500'>Error: No report type specified.</p>");
        return;
    }

    try {
        // Call the service layer to get the data (separating concerns to a degree)
        List<?> reportData = reportManager.getReportData(reportType, timeFilter, statusFilter);
        
        // Use a utility to build the HTML (further separation)
        String htmlReport = ReportHtmlBuilder.buildHtmlTable(reportType, reportData);
        
        // Write the generated HTML back to the response
        out.print(htmlReport);

    } catch (SQLException e) {
        // Log the error for debugging
        System.err.println("Database error generating report: " + e.getMessage());
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("<div class='p-4 text-red-700 bg-red-100 border border-red-200 rounded-lg'>" +
                  "<p>An internal server error occurred while retrieving data.</p></div>");
    } catch (IllegalArgumentException e) {
        // Handle invalid report types
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("<div class='p-4 text-red-700 bg-red-100 border border-red-200 rounded-lg'>" +
                  "<p>" + e.getMessage() + "</p></div>");
    } catch (Exception e) {
        // Catch any other unexpected exceptions
        System.err.println("Unexpected error: " + e.getMessage());
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("<div class='p-4 text-red-700 bg-red-100 border border-red-200 rounded-lg'>" +
                  "<p>An unexpected error occurred.</p></div>");
    }
%>