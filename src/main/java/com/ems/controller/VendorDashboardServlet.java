package com.ems.controller;

import com.ems.model.User;
import com.ems.model.Vendor;
import com.ems.model.Booking;
import com.ems.model.Event;
import com.ems.model.Payment;
import com.ems.service.VendorManager;
import com.ems.service.BookingManager;
import com.ems.service.PaymentManager;
import com.ems.service.UserService;
import com.ems.service.EventManager;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling the vendor dashboard view.
 * This servlet retrieves a logged-in vendor's profile, their bookings,
 * and payments, and then forwards this data to the vendor_dashboard.jsp for display.
 * It also performs crucial server-side authorization checks.
 */
@WebServlet("/vendor/dashboard")
public class VendorDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(VendorDashboardServlet.class.getName());

    private VendorManager vendorManager;
    private BookingManager bookingManager;
    private PaymentManager paymentManager;
    private UserService userService;
    private EventManager eventManager;
    
    // Commission rates - 10% admin, 90% vendor
    private static final BigDecimal VENDOR_COMMISSION_RATE = new BigDecimal("0.90");
    private static final BigDecimal ADMIN_COMMISSION_RATE = new BigDecimal("0.10");

    /**
     * Initializes the servlet and its managers.
     * @throws ServletException if a servlet-specific error occurs.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        vendorManager = new VendorManager();
        bookingManager = new BookingManager();
        paymentManager = new PaymentManager();
        userService = new UserService();
        eventManager = new EventManager();
    }

    /**
     * Handles GET requests to display the vendor dashboard.
     *
     * @param request The HttpServletRequest object.
     * @param response The HttpServletResponse object.
     * @throws ServletException if a servlet-specific error occurs.
     * @throws IOException if an I/O error occurs.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // --- Server-Side Authorization Check ---
        if (session == null || session.getAttribute("loggedInUser") == null) {
            LOGGER.log(Level.WARNING, "Unauthorized access to vendor dashboard: no session or loggedInUser.");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"vendor".equalsIgnoreCase(loggedInUser.getRole())) {
            LOGGER.log(Level.WARNING, "Access Denied to vendor dashboard: User {0} is not a vendor. Role: {1}",
                    new Object[]{loggedInUser.getEmail(), loggedInUser.getRole()});
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only Vendors can access this dashboard.");
            return;
        }

        int userId = loggedInUser.getUserId();
        Vendor vendorProfile = vendorManager.getVendorByUserId(userId);
        if (vendorProfile == null) {
            LOGGER.log(Level.SEVERE, "Vendor profile not found for userID: {0}. This indicates a data integrity issue.", userId);
            request.setAttribute("errorMessage", "Your vendor profile is not complete. Please contact support.");
            request.getRequestDispatcher("/vendor_dashboard.jsp").forward(request, response);
            return;
        }
        
        LOGGER.log(Level.INFO, "User {0} accessing vendor dashboard. Found profile for company: {1} (VendorID: {2})",
                new Object[]{loggedInUser.getEmail(), vendorProfile.getCompanyName(), vendorProfile.getVendorId()});
        
        int vendorId = vendorProfile.getVendorId();
        
        // Fetch vendor-specific data
        List<Booking> vendorBookings = bookingManager.getVendorsBookings(vendorId);
        List<Payment> vendorPayments = paymentManager.getPaymentsByVendorId(vendorId);
        
        // Process data to show vendor share amounts only (90% of total)
        List<Booking> processedBookings = processBookingsWithVendorShare(vendorBookings);
        List<Payment> processedPayments = processPaymentsWithVendorShare(vendorPayments);
        
        // Calculate comprehensive financial metrics using vendor shares
        VendorFinancialSummary financialSummary = calculateVendorFinancialSummary(processedBookings, processedPayments);
        
        // Set data as request attributes
        request.setAttribute("loggedInUser", loggedInUser);
        request.setAttribute("vendorProfile", vendorProfile);
        request.setAttribute("vendorBookings", processedBookings); // Use processed bookings with vendor shares
        request.setAttribute("vendorPayments", processedPayments); // Use processed payments with vendor shares
        request.setAttribute("financialSummary", financialSummary);
        
        // Forward to the vendor dashboard JSP
        LOGGER.log(Level.INFO, "Forwarding to /vendor_dashboard.jsp with vendor share financial data (90% vendor, 10% admin)");
        request.getRequestDispatcher("/vendor_dashboard.jsp").forward(request, response);
    }

    /**
     * Calculate vendor share based on commission percentage
     * Commission is 90% for vendor, 10% for platform
     */
    private BigDecimal calculateVendorShare(BigDecimal totalAmount) {
        if (totalAmount == null) return BigDecimal.ZERO;
        return totalAmount.multiply(VENDOR_COMMISSION_RATE).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Process bookings to include vendor share amounts (90% of total)
     */
    private List<Booking> processBookingsWithVendorShare(List<Booking> bookings) {
        if (bookings == null) return Collections.emptyList();
        
        List<Booking> processedBookings = new ArrayList<>();
        for (Booking booking : bookings) {
            // Create a copy to avoid modifying original object
            Booking processedBooking = new Booking();
            // Copy all properties
            processedBooking.setBookingId(booking.getBookingId());
            processedBooking.setEventId(booking.getEventId());
            processedBooking.setUserId(booking.getUserId());
            processedBooking.setVendorId(booking.getVendorId());
            processedBooking.setServiceBooked(booking.getServiceBooked());
            processedBooking.setBookingDate(booking.getBookingDate());
            processedBooking.setStatus(booking.getStatus());
            processedBooking.setNotes(booking.getNotes());
            processedBooking.setAdvanceRequiredPercentage(booking.getAdvanceRequiredPercentage());
            
            // Calculate vendor shares (90% of amounts)
            BigDecimal totalAmount = booking.getAmount() != null ? booking.getAmount() : BigDecimal.ZERO;
            BigDecimal vendorShare = calculateVendorShare(totalAmount);
            
            // Set vendor share amounts
            processedBooking.setAmount(vendorShare); // Total amount becomes vendor share
            processedBooking.setAmountPaid(calculateVendorShare(booking.getAmountPaid() != null ? booking.getAmountPaid() : BigDecimal.ZERO));
            processedBooking.setAdvanceAmountDue(calculateVendorShare(booking.getAdvanceAmountDue() != null ? booking.getAdvanceAmountDue() : BigDecimal.ZERO));
            
            // Set display names
            processedBooking.setEventName(booking.getEventName());
            processedBooking.setClientName(booking.getClientName());
            processedBooking.setVendorCompanyName(booking.getVendorCompanyName());
            
            processedBookings.add(processedBooking);
        }
        return processedBookings;
    }

    /**
     * Process payments to show vendor share amounts (90% of total)
     */
    private List<Payment> processPaymentsWithVendorShare(List<Payment> payments) {
        if (payments == null) return Collections.emptyList();
        
        List<Payment> processedPayments = new ArrayList<>();
        for (Payment payment : payments) {
            // Use vendorShare from payment if available, otherwise calculate
            BigDecimal vendorShare = payment.getVendorShare();
            if (vendorShare == null) {
                vendorShare = calculateVendorShare(payment.getAmount());
            }
            
            // Create a copy with vendor share as the display amount
            Payment processedPayment = new Payment();
            processedPayment.setPaymentId(payment.getPaymentId());
            processedPayment.setBookingId(payment.getBookingId());
            processedPayment.setAmount(vendorShare); // Show vendor share as the amount
            processedPayment.setVendorShare(vendorShare);
            processedPayment.setAdminShare(payment.getAdminShare());
            processedPayment.setPaymentDate(payment.getPaymentDate());
            processedPayment.setStatus(payment.getStatus());
            processedPayment.setTransactionId(payment.getTransactionId());
            processedPayment.setPaymentMethod(payment.getPaymentMethod());
            processedPayment.setPaymentType(payment.getPaymentType());
            
            processedPayments.add(processedPayment);
        }
        return processedPayments;
    }

    /**
     * Calculate financial summary using vendor share amounts (90% of total)
     */
    private VendorFinancialSummary calculateVendorFinancialSummary(List<Booking> vendorBookings, List<Payment> vendorPayments) {
        VendorFinancialSummary summary = new VendorFinancialSummary();
        
        if (vendorBookings == null) vendorBookings = Collections.emptyList();
        if (vendorPayments == null) vendorPayments = Collections.emptyList();
        
        // Calculate earnings from vendor share amounts
        BigDecimal totalEarnings = BigDecimal.ZERO;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        BigDecimal pendingAmount = BigDecimal.ZERO;
        BigDecimal advanceDue = BigDecimal.ZERO;
        BigDecimal balanceDue = BigDecimal.ZERO;
        
        for (Booking booking : vendorBookings) {
            // These amounts are already vendor shares after processing (90% of total)
            BigDecimal vendorAmount = booking.getAmount() != null ? booking.getAmount() : BigDecimal.ZERO;
            BigDecimal vendorAmountPaid = booking.getAmountPaid() != null ? booking.getAmountPaid() : BigDecimal.ZERO;
            String status = booking.getStatus();
            
            // Total revenue (vendor share of all confirmed/completed bookings)
            if ("Confirmed".equals(status) || "Completed".equals(status) || 
                "Advance Paid".equals(status) || "Confirmed & Fully Paid".equals(status)) {
                totalRevenue = totalRevenue.add(vendorAmount);
            }
            
            // Total earnings (actual vendor share received)
            totalEarnings = totalEarnings.add(vendorAmountPaid);
            
            // Pending amount (vendor share of confirmed but not fully paid)
            if (("Confirmed".equals(status) || "Advance Paid".equals(status)) && 
                vendorAmount.compareTo(vendorAmountPaid) > 0) {
                pendingAmount = pendingAmount.add(vendorAmount.subtract(vendorAmountPaid));
            }
            
            // Advance due (vendor share of advance payment due)
            if ("Advance Payment Due".equals(status) && booking.getAdvanceAmountDue() != null) {
                advanceDue = advanceDue.add(booking.getAdvanceAmountDue());
            }
            
            // Balance due (vendor share of all unpaid amounts)
            if (vendorAmount.compareTo(vendorAmountPaid) > 0) {
                balanceDue = balanceDue.add(vendorAmount.subtract(vendorAmountPaid));
            }
        }
        
        // Calculate payment metrics using vendor shares (90% of total)
        BigDecimal totalPaymentsAmount = BigDecimal.ZERO;
        BigDecimal recentPayments = BigDecimal.ZERO;
        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        
        for (Payment payment : vendorPayments) {
            // Use vendor share amount for calculations (90% of total)
            BigDecimal vendorShare = payment.getVendorShare() != null ? payment.getVendorShare() : calculateVendorShare(payment.getAmount());
            totalPaymentsAmount = totalPaymentsAmount.add(vendorShare);
            
            // Recent payments (last 30 days)
            if (payment.getPaymentDate() != null && 
                payment.getPaymentDate().isAfter(thirtyDaysAgo)) {
                recentPayments = recentPayments.add(vendorShare);
            }
        }
        
        // Set all calculated values
        summary.setTotalEarnings(totalEarnings);
        summary.setTotalRevenue(totalRevenue);
        summary.setPendingAmount(pendingAmount);
        summary.setAdvanceDue(advanceDue);
        summary.setBalanceDue(balanceDue);
        summary.setTotalPaymentsAmount(totalPaymentsAmount);
        summary.setRecentPayments(recentPayments);
        summary.setTotalBookings(vendorBookings.size());
        summary.setCompletedBookings((int) vendorBookings.stream()
            .filter(b -> "Completed".equals(b.getStatus()))
            .count());
        summary.setPendingBookings((int) vendorBookings.stream()
            .filter(b -> "Pending".equals(b.getStatus()) || "Advance Payment Due".equals(b.getStatus()))
            .count());
        
        LOGGER.info("Vendor Financial Summary Calculated (90% vendor share): " + summary.toString());
        return summary;
    }

    /**
     * Handles POST requests. In this case, it simply reloads the dashboard.
     *
     * @param request The HttpServletRequest object.
     * @param response The HttpServletResponse object.
     * @throws ServletException if a servlet-specific error occurs.
     * @throws IOException if an I/O error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Inner class to hold vendor financial summary data
     */
    public static class VendorFinancialSummary {
        private BigDecimal totalEarnings;
        private BigDecimal totalRevenue;
        private BigDecimal pendingAmount;
        private BigDecimal advanceDue;
        private BigDecimal balanceDue;
        private BigDecimal totalPaymentsAmount;
        private BigDecimal recentPayments;
        private int totalBookings;
        private int completedBookings;
        private int pendingBookings;
        
        public VendorFinancialSummary() {
            this.totalEarnings = BigDecimal.ZERO;
            this.totalRevenue = BigDecimal.ZERO;
            this.pendingAmount = BigDecimal.ZERO;
            this.advanceDue = BigDecimal.ZERO;
            this.balanceDue = BigDecimal.ZERO;
            this.totalPaymentsAmount = BigDecimal.ZERO;
            this.recentPayments = BigDecimal.ZERO;
        }
        
        // Getters and Setters
        public BigDecimal getTotalEarnings() { return totalEarnings; }
        public void setTotalEarnings(BigDecimal totalEarnings) { this.totalEarnings = totalEarnings; }
        
        public BigDecimal getTotalRevenue() { return totalRevenue; }
        public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
        
        public BigDecimal getPendingAmount() { return pendingAmount; }
        public void setPendingAmount(BigDecimal pendingAmount) { this.pendingAmount = pendingAmount; }
        
        public BigDecimal getAdvanceDue() { return advanceDue; }
        public void setAdvanceDue(BigDecimal advanceDue) { this.advanceDue = advanceDue; }
        
        public BigDecimal getBalanceDue() { return balanceDue; }
        public void setBalanceDue(BigDecimal balanceDue) { this.balanceDue = balanceDue; }
        
        public BigDecimal getTotalPaymentsAmount() { return totalPaymentsAmount; }
        public void setTotalPaymentsAmount(BigDecimal totalPaymentsAmount) { this.totalPaymentsAmount = totalPaymentsAmount; }
        
        public BigDecimal getRecentPayments() { return recentPayments; }
        public void setRecentPayments(BigDecimal recentPayments) { this.recentPayments = recentPayments; }
        
        public int getTotalBookings() { return totalBookings; }
        public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }
        
        public int getCompletedBookings() { return completedBookings; }
        public void setCompletedBookings(int completedBookings) { this.completedBookings = completedBookings; }
        
        public int getPendingBookings() { return pendingBookings; }
        public void setPendingBookings(int pendingBookings) { this.pendingBookings = pendingBookings; }
        
        @Override
        public String toString() {
            return String.format(
                "VendorFinancialSummary{totalEarnings=%.2f, totalRevenue=%.2f, pendingAmount=%.2f, " +
                "advanceDue=%.2f, balanceDue=%.2f, totalPayments=%.2f, recentPayments=%.2f, " +
                "bookings=%d, completed=%d, pending=%d}",
                totalEarnings.doubleValue(), totalRevenue.doubleValue(), pendingAmount.doubleValue(),
                advanceDue.doubleValue(), balanceDue.doubleValue(), totalPaymentsAmount.doubleValue(),
                recentPayments.doubleValue(), totalBookings, completedBookings, pendingBookings
            );
        }
    }
}