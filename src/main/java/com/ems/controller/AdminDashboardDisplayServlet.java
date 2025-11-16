package com.ems.controller;

import com.ems.model.*;
import com.ems.service.*;
import com.ems.dao.EventDAO; // Add this import

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/dashboard")
public class AdminDashboardDisplayServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardDisplayServlet.class.getName());

    private UserService userService;
    private EventManager eventManager;
    private VendorManager vendorManager;
    private BookingManager bookingManager;
    private PaymentManager paymentManager;
    private ClientManager clientManager;
    private AdminManager adminManager;
    private ReportManager reportManager;
    private EventDAO eventDAO; // Add this

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        eventManager = new EventManager();
        vendorManager = new VendorManager();
        bookingManager = new BookingManager();
        paymentManager = new PaymentManager();
        clientManager = new ClientManager();
        adminManager = new AdminManager();
        reportManager = new ReportManager();
        eventDAO = new EventDAO(); // Initialize EventDAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAuthorizedAdmin(request, response)) return;

        loadDashboardData(request);
        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAuthorizedAdmin(request, response)) return;

        // Report generation logic
        String reportType = request.getParameter("reportType");
        String timeFilter = request.getParameter("timeFilter");
        String statusFilter = request.getParameter("statusFilter");

        try {
            List<?> reportData = reportManager.getReportData(reportType, timeFilter, statusFilter);
            request.setAttribute("reportData", reportData);
            request.setAttribute("reportType", reportType);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error generating report: " + reportType, e);
            request.setAttribute("errorMessage", "Database error while generating report.");
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid report type: " + reportType, e);
            request.setAttribute("errorMessage", e.getMessage());
        }

        loadDashboardData(request);
        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
    }

    // ─────────────────────────────────────────────────────────────────────────────
    // Utility Methods
    // ─────────────────────────────────────────────────────────────────────────────

    private boolean isAuthorizedAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return false;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Not an Admin.");
            return false;
        }

        return true;
    }

    private void loadDashboardData(HttpServletRequest request) {
        try {
            List<User> users = userService.getAllUsers();
            
            // FIX: Use EventDAO to get events with selected vendors
            List<Event> events = eventDAO.getAllEventsWithSelectedVendors();
            
            List<Vendor> vendors = vendorManager.getAllVendors();
            List<Booking> bookings = bookingManager.getAllBookingsForAdmin();
            List<Payment> payments = paymentManager.getAllPayments();
            List<Client> customers = clientManager.getAllCustomers();

            BigDecimal totalRevenue = calculateTotalRevenue(bookings);
            BigDecimal adminShare = calculateAdminShare(payments);
            int pendingBookings = countPendingBookings(bookings);

            request.setAttribute("users", users);
            request.setAttribute("events", events);
            request.setAttribute("vendors", vendors);
            request.setAttribute("bookings", bookings);
            request.setAttribute("payments", payments);
            request.setAttribute("customers", customers);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("adminShare", adminShare);
            request.setAttribute("pendingBookingsCount", pendingBookings); // Add this attribute
            
            // Chart data for Chart.js
            Map<String, Object> overviewChartData = new LinkedHashMap<>();
            overviewChartData.put("Total Users", users != null ? users.size() : 0);
            overviewChartData.put("Total Events", events != null ? events.size() : 0);
            overviewChartData.put("Total Bookings", bookings != null ? bookings.size() : 0);
            overviewChartData.put("Pending Bookings", pendingBookings);
            overviewChartData.put("Total Revenue", totalRevenue);
            overviewChartData.put("Admin Share", adminShare);
            overviewChartData.put("Total Vendors", vendors != null ? vendors.size() : 0);
            overviewChartData.put("Total Clients", customers != null ? customers.size() : 0);

            request.setAttribute("overviewChartData", overviewChartData);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading dashboard data", e);
            request.setAttribute("errorMessage", "Failed to load dashboard data.");
        }
    }

    private BigDecimal calculateTotalRevenue(List<Booking> bookings) {
        BigDecimal total = BigDecimal.ZERO;
        if (bookings != null) {
            for (Booking b : bookings) {
                String status = b.getStatus();
                if (status != null && (
                        "Completed".equalsIgnoreCase(status) ||
                        "Confirmed".equalsIgnoreCase(status) ||
                        "Advance Paid".equalsIgnoreCase(status))) {
                    if (b.getAmountPaid() != null) {
                        total = total.add(b.getAmountPaid());
                    }
                }
            }
        }
        LOGGER.log(Level.INFO, "Calculated Total Revenue: {0}", total);
        return total;
    }

    private BigDecimal calculateAdminShare(List<Payment> payments) {
        BigDecimal adminShare = BigDecimal.ZERO;
        if (payments != null) {
            for (Payment p : payments) {
                if (p.getAdminShare() != null) {
                    adminShare = adminShare.add(p.getAdminShare());
                }
            }
        }
        LOGGER.log(Level.INFO, "Calculated Admin Share: {0}", adminShare);
        return adminShare;
    }

    private int countPendingBookings(List<Booking> bookings) {
        int count = 0;
        if (bookings != null) {
            for (Booking b : bookings) {
                String status = b.getStatus();
                if ("Pending".equalsIgnoreCase(status) || "Advance Payment Due".equalsIgnoreCase(status)) {
                    count++;
                }
            }
        }
        LOGGER.log(Level.INFO, "Counted Pending Bookings: {0}", count);
        return count;
    }
}