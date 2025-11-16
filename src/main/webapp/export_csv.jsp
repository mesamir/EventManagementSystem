<%@ page language="java" contentType="text/csv; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ems.service.ReportManager" %>
<%@ page import="com.ems.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // --- Server-Side Authorization Check ---
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("loggedInUser") == null || !"admin".equalsIgnoreCase(((User)session.getAttribute("loggedInUser")).getRole())) {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.getWriter().write("Access Denied.");
        return;
    }
    // --- End Authorization Check ---

    // Get request parameters
    String reportType = request.getParameter("type");
    String timeFilter = request.getParameter("time");
    String statusFilter = request.getParameter("status");

    // File name for download
    String fileName = "report_" + reportType + ".csv";

    // Set HTTP headers for file download
    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
    
    PrintWriter writer = response.getWriter();
    ReportManager reportManager = new ReportManager();

    try {
        // Fetch the raw data from the service layer
        List<?> reportData = reportManager.getReportData(reportType, timeFilter, statusFilter);

        // A switch to handle different report types and format them as CSV
        switch (reportType) {
            case "event_summary_report":
            case "full_event_report":
                // CSV Header
                writer.println("Event ID,Event Name,Event Date,Client ID,Status");
                // CSV Data
                for (Object item : reportData) {
                    Event event = (Event) item;
                    writer.println(
                        event.getEventId() + "," +
                        event.getClientId() + "," +
                        event.getDate() + "," +
                        event.getStatus()
                    );
                }
                break;
            case "vendor_performance_report":
                writer.println("Vendor ID,Vendor Name,Total Events,Total Revenue,Average Rating");
                for (Object item : reportData) {
                    VendorPerformance vp = (VendorPerformance) item;
                    writer.println(
                        vp.getVendorId() + "," +
                        vp.getVendorName() + "," +
                        vp.getTotalEvents() + "," +
                        vp.getTotalRevenue() + "," +
                        vp.getAverageRating()
                    );
                }
                break;
            case "financial_report":
                writer.println("Financial Metric,Value");
                // Assuming getReportData returns a list of FinancialReportSummary objects
                for (Object item : reportData) {
                    // Example: FinancialReportSummary frs = (FinancialReportSummary) item;
                    // writer.println(frs.getMetric() + "," + frs.getValue());
                }
                break;
            case "full_vendor_report":
                writer.println("Vendor ID,Vendor Name,Vendor Contact,Registration Date,Status");
                for (Object item : reportData) {
                    Vendor vendor = (Vendor) item;
                    writer.println(
                        vendor.getVendorId() + "," +
                        vendor.getCompanyName() + "," +
                        vendor.getContactPerson() + "," + // Assuming these fields exist
                        vendor.getRegistrationDate() + "," +
                        vendor.getStatus()
                    );
                }
                break;
            case "full_payments_report":
                writer.println("Payment ID,Booking ID,Amount,Payment Date,Status");
                for (Object item : reportData) {
                    Payment payment = (Payment) item;
                    writer.println(
                        payment.getPaymentId() + "," +
                        payment.getBookingId() + "," +
                        payment.getAmount() + "," +
                        payment.getPaymentDate() + "," +
                        payment.getStatus()
                    );
                }
                break;
            default:
                writer.println("Error: Invalid report type.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                break;
        }

    } catch (SQLException e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        writer.println("Error: Database error while exporting report.");
        System.err.println("Database error exporting CSV: " + e.getMessage());
    } finally {
        if (writer != null) {
            writer.flush();
            writer.close();
        }
    }
%>