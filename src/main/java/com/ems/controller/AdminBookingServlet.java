// src/main/java/com/ems/controller/AdminBookingServlet.java
package com.ems.controller;

import com.ems.model.User;
import com.ems.model.Booking;
import com.ems.dao.BookingDAO;
import com.ems.service.BookingManager;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Servlet for handling admin-related booking actions.
 * Updated to align with new workflow: no vendor assignment during booking creation
 */
@WebServlet("/admin/bookings")
public class AdminBookingServlet extends HttpServlet {
    private BookingManager bookingManager;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.bookingManager = new BookingManager();
        this.bookingDAO = new BookingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Authorization Check
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Not an Admin.");
            return;
        }

        String action = request.getParameter("action");
        String messageType = "error";
        String messageText = "An unknown error occurred.";

        try {
            switch (action) {
                case "add":
                    messageText = addNewBooking(request);
                    messageType = "success";
                    break;
                case "edit":
                    messageText = editBooking(request);
                    messageType = "success";
                    break;
                case "confirm":
                    messageText = confirmBooking(request);
                    messageType = "success";
                    break;
                case "cancel":
                    messageText = cancelBooking(request);
                    messageType = "success";
                    break;
                case "assign-vendor": // NEW: Assign vendor to existing booking
                    messageText = assignVendorToBooking(request);
                    messageType = "success";
                    break;
                case "remove-vendor": // NEW: Remove vendor assignment
                    messageText = removeVendorAssignment(request);
                    messageType = "success";
                    break;
                case "set-advance": // NEW: Set advance payment requirements
                    messageText = setAdvancePayment(request);
                    messageType = "success";
                    break;
                default:
                    messageText = "Invalid action specified: " + (action != null ? action : "null");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            messageText = "Error: " + e.getMessage();
        }

        // Redirect back with message
        String redirectUrl = request.getContextPath() + "/admin/dashboard?" + messageType + "Message=" +
                         URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString()) + "#bookings";
        response.sendRedirect(redirectUrl);
    }

    /**
     * Handles adding a new booking without vendor assignment (new workflow)
     */
    private String addNewBooking(HttpServletRequest request) throws Exception {
        System.out.println("=== ADMIN: ADDING NEW BOOKING (NO VENDOR) ===");
        
        // Get form parameters
        String eventIdStr = request.getParameter("eventId");
        String vendorIdStr = request.getParameter("vendorId"); // NOW OPTIONAL
        String serviceBooked = request.getParameter("serviceBooked");
        String amountStr = request.getParameter("amount");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");
        String advancePercentageStr = request.getParameter("advanceRequiredPercentage");

        // Validate required fields - VENDOR ID IS NOW OPTIONAL
        if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
            throw new Exception("Event ID is required");
        }
        if (serviceBooked == null || serviceBooked.trim().isEmpty()) {
            throw new Exception("Service booked is required");
        }
        if (amountStr == null || amountStr.trim().isEmpty()) {
            throw new Exception("Amount is required");
        }

        // Parse values
        int eventId = Integer.parseInt(eventIdStr);
        Integer vendorId = null;
        if (vendorIdStr != null && !vendorIdStr.trim().isEmpty()) {
            vendorId = Integer.parseInt(vendorIdStr);
        }
        BigDecimal amount = new BigDecimal(amountStr);
        
        BigDecimal advancePercentage = (advancePercentageStr != null && !advancePercentageStr.trim().isEmpty()) ?
                                      new BigDecimal(advancePercentageStr) : new BigDecimal("30");
        BigDecimal advanceDue = amount.multiply(advancePercentage).divide(new BigDecimal("100"), 2, BigDecimal.ROUND_HALF_UP);

        // Create booking object - vendor ID is optional now
        Booking booking = new Booking();
        booking.setEventId(eventId);
        booking.setUserId(1); // Set a default user ID (admin user)
        booking.setVendorId(vendorId); // Can be null
        booking.setServiceBooked(serviceBooked);
        booking.setAmount(amount);
        booking.setStatus(status != null ? status : "Pending");
        booking.setNotes(notes);
        booking.setAdvanceRequiredPercentage(advancePercentage);
        booking.setAdvanceAmountDue(advanceDue);
        booking.setAmountPaid(BigDecimal.ZERO); // Start with zero paid
        booking.setBookingDate(LocalDateTime.now());
        
        System.out.println("Final Booking Object (No Vendor Assignment):");
        System.out.println("- Event ID: " + booking.getEventId());
        System.out.println("- Vendor ID: " + booking.getVendorId());
        System.out.println("- Service: " + booking.getServiceBooked());
        System.out.println("- Amount: " + booking.getAmount());
        System.out.println("- Status: " + booking.getStatus());

        int bookingId = bookingDAO.createBooking(booking);

        if (bookingId <= 0) {
            throw new Exception("Failed to create booking in database");
        }

        return "Booking created successfully with ID: " + bookingId + ". Vendor can be assigned later.";
    }

    /**
     * Handles editing an existing booking
     * Updated: Vendor ID is now optional
     */
    private String editBooking(HttpServletRequest request) throws Exception {
        System.out.println("=== ADMIN: EDITING BOOKING ===");
        
        // Log all parameters for debugging
        System.out.println("=== EDIT FORM PARAMETERS ===");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println(paramName + ": " + paramValue);
        }
        System.out.println("======================");
        
        // Get form parameters
        String bookingIdStr = request.getParameter("bookingId");
        String eventIdStr = request.getParameter("eventId");
        String vendorIdStr = request.getParameter("vendorId"); // OPTIONAL
        String serviceBooked = request.getParameter("serviceBooked");
        String amountStr = request.getParameter("amount");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");
        String advancePercentageStr = request.getParameter("advanceRequiredPercentage");
        String advanceDueStr = request.getParameter("advanceAmountDue");
        String amountPaidStr = request.getParameter("amountPaid");

        // Validate required fields
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            throw new Exception("Booking ID is required for editing");
        }
        if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
            throw new Exception("Event ID is required");
        }
        if (serviceBooked == null || serviceBooked.trim().isEmpty()) {
            throw new Exception("Service booked is required");
        }
        if (amountStr == null || amountStr.trim().isEmpty()) {
            throw new Exception("Amount is required");
        }

        // Parse values
        int bookingId = Integer.parseInt(bookingIdStr);
        int eventId = Integer.parseInt(eventIdStr);
        
        // Vendor ID is now optional
        Integer vendorId = null;
        if (vendorIdStr != null && !vendorIdStr.trim().isEmpty()) {
            vendorId = Integer.parseInt(vendorIdStr);
        }
        
        BigDecimal amount = new BigDecimal(amountStr);
        
        BigDecimal advancePercentage = (advancePercentageStr != null && !advancePercentageStr.trim().isEmpty()) ?
                                      new BigDecimal(advancePercentageStr) : new BigDecimal("30");
        BigDecimal advanceDue = (advanceDueStr != null && !advanceDueStr.trim().isEmpty()) ?
                               new BigDecimal(advanceDueStr) : BigDecimal.ZERO;
        BigDecimal amountPaid = (amountPaidStr != null && !amountPaidStr.trim().isEmpty()) ?
                               new BigDecimal(amountPaidStr) : BigDecimal.ZERO;

        // Create booking object with updated values
        Booking booking = new Booking();
        booking.setBookingId(bookingId);
        booking.setEventId(eventId);
        booking.setVendorId(vendorId); // Can be null
        booking.setServiceBooked(serviceBooked);
        booking.setAmount(amount);
        booking.setStatus(status != null ? status : "Pending");
        booking.setNotes(notes);
        booking.setAdvanceRequiredPercentage(advancePercentage);
        booking.setAdvanceAmountDue(advanceDue);
        booking.setAmountPaid(amountPaid);
        booking.setBookingDate(LocalDateTime.now());

        System.out.println("Editing Booking ID: " + bookingId);
        System.out.println("- Event ID: " + eventId);
        System.out.println("- Vendor ID: " + vendorId);
        System.out.println("- Service: " + serviceBooked);
        System.out.println("- Amount: " + amount);
        System.out.println("- Status: " + status);

        // Use BookingDAO to update booking
        boolean success = bookingDAO.updateBooking(booking);

        if (!success) {
            throw new Exception("Failed to update booking in database");
        }

        return "Booking #" + bookingId + " updated successfully!";
    }

    /**
     * NEW: Assign vendor to existing booking (separate process)
     */
    private String assignVendorToBooking(HttpServletRequest request) throws Exception {
        System.out.println("=== ADMIN: ASSIGNING VENDOR TO BOOKING ===");
        
        String bookingIdStr = request.getParameter("bookingId");
        String vendorIdStr = request.getParameter("vendorId");
        
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            throw new Exception("Booking ID is required");
        }
        if (vendorIdStr == null || vendorIdStr.trim().isEmpty()) {
            throw new Exception("Vendor ID is required for assignment");
        }
        
        int bookingId = Integer.parseInt(bookingIdStr);
        int vendorId = Integer.parseInt(vendorIdStr);
        
        System.out.println("Assigning Vendor " + vendorId + " to Booking " + bookingId);
        
        boolean success = bookingManager.assignVendorToBooking(bookingId, vendorId);
        
        if (!success) {
            throw new Exception("Failed to assign vendor to booking. Please check if booking and vendor exist.");
        }
        
        return "Vendor successfully assigned to booking #" + bookingId;
    }

    /**
     * NEW: Remove vendor assignment from booking
     */
    private String removeVendorAssignment(HttpServletRequest request) throws Exception {
        System.out.println("=== ADMIN: REMOVING VENDOR ASSIGNMENT ===");
        
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            throw new Exception("Booking ID is required");
        }
        
        int bookingId = Integer.parseInt(bookingIdStr);
        
        System.out.println("Removing vendor assignment from Booking " + bookingId);
        
        boolean success = bookingManager.removeVendorAssignment(bookingId);
        
        if (!success) {
            throw new Exception("Failed to remove vendor assignment from booking.");
        }
        
        return "Vendor assignment removed from booking #" + bookingId;
    }

    /**
     * NEW: Set advance payment requirements for booking
     */
    private String setAdvancePayment(HttpServletRequest request) throws Exception {
        System.out.println("=== ADMIN: SETTING ADVANCE PAYMENT ===");
        
        String bookingIdStr = request.getParameter("bookingId");
        String advancePercentageStr = request.getParameter("advancePercentage");
        
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            throw new Exception("Booking ID is required");
        }
        if (advancePercentageStr == null || advancePercentageStr.trim().isEmpty()) {
            throw new Exception("Advance percentage is required");
        }
        
        int bookingId = Integer.parseInt(bookingIdStr);
        BigDecimal advancePercentage = new BigDecimal(advancePercentageStr);
        
        // Validate percentage
        if (advancePercentage.compareTo(BigDecimal.ZERO) < 0 || 
            advancePercentage.compareTo(new BigDecimal("100")) > 0) {
            throw new Exception("Advance percentage must be between 0 and 100");
        }
        
        System.out.println("Setting advance payment for Booking " + bookingId + ": " + advancePercentage + "%");
        
        boolean success = bookingManager.adminSetAdvancePayment(bookingId, advancePercentage);
        
        if (!success) {
            throw new Exception("Failed to set advance payment for booking.");
        }
        
        return "Advance payment set to " + advancePercentage + "% for booking #" + bookingId;
    }

    /**
     * Handles confirming an existing booking
     */
    private String confirmBooking(HttpServletRequest request) throws Exception {
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            return "Booking ID is missing for confirm action.";
        }
        
        int bookingId = Integer.parseInt(bookingIdStr);
        boolean success = bookingManager.adminConfirmBooking(bookingId);
        
        return success ? "Booking confirmed successfully!" : 
                        "Failed to confirm booking. It might not be in a confirmable status.";
    }

    /**
     * Handles canceling an existing booking
     */
    private String cancelBooking(HttpServletRequest request) throws Exception {
        String bookingIdStr = request.getParameter("bookingId");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            return "Booking ID is missing for cancel action.";
        }
        
        int bookingId = Integer.parseInt(bookingIdStr);
        boolean success = bookingManager.adminCancelBooking(bookingId);
        
        return success ? "Booking cancelled successfully!" : 
                        "Failed to cancel booking. It might already be completed or cancelled.";
    }

    /**
     * Handles GET requests, redirecting to the bookings section of the admin dashboard.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard#bookings");
    }
}