package com.ems.controller;

import com.ems.model.User;
import com.ems.service.PaymentManager;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/processPayment")
public class AdminPaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminPaymentServlet.class.getName());
    private PaymentManager paymentManager;

    @Override
    public void init() throws ServletException {
        super.init();
        this.paymentManager = new PaymentManager();
        LOGGER.info("AdminPaymentServlet initialized successfully");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String redirectUrl = request.getContextPath() + "/admin/dashboard";

        // Authentication and Authorization Check
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=" + 
                URLEncoder.encode("Authentication required.", StandardCharsets.UTF_8));
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only Administrators can process payments.");
            return;
        }

        // Extract and Validate Input - NOW USING BOOKING ID
        String bookingIdStr = request.getParameter("bookingId");
        String amountStr = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");
        String paymentType = request.getParameter("paymentType");

        LOGGER.info("Payment parameters - BookingID: " + bookingIdStr + ", Amount: " + amountStr + 
                   ", Method: " + paymentMethod + ", Type: " + paymentType);

        // Enhanced validation
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            sendErrorRedirect(response, redirectUrl, "Booking ID is required.");
            return;
        }

        if (amountStr == null || amountStr.trim().isEmpty()) {
            sendErrorRedirect(response, redirectUrl, "Payment amount is required.");
            return;
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            sendErrorRedirect(response, redirectUrl, "Payment method is required.");
            return;
        }

        if (paymentType == null || paymentType.trim().isEmpty()) {
            sendErrorRedirect(response, redirectUrl, "Payment type (Full/Advance) is required.");
            return;
        }

        int bookingId = -1;
        BigDecimal amount = null;

        try {
            // Parse Booking ID with better error handling
            bookingIdStr = bookingIdStr.trim();
            if (!bookingIdStr.matches("\\d+")) {
                sendErrorRedirect(response, redirectUrl, "Booking ID must be a valid number.");
                return;
            }
            bookingId = Integer.parseInt(bookingIdStr);
            
            if (bookingId <= 0) {
                sendErrorRedirect(response, redirectUrl, "Booking ID must be a positive number.");
                return;
            }

            // Parse Amount with better error handling
            amountStr = amountStr.trim().replaceAll(",", ""); // Remove commas if present
            if (!amountStr.matches("-?\\d+(\\.\\d+)?")) {
                sendErrorRedirect(response, redirectUrl, "Amount must be a valid number (e.g., 1000 or 1000.50).");
                return;
            }
            
            amount = new BigDecimal(amountStr);
            
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                sendErrorRedirect(response, redirectUrl, "Payment amount must be greater than zero.");
                return;
            }

            // Validate payment type
            if (!"Full".equalsIgnoreCase(paymentType) && !"Advance".equalsIgnoreCase(paymentType)) {
                sendErrorRedirect(response, redirectUrl, "Payment type must be either 'Full' or 'Advance'.");
                return;
            }

        } catch (NumberFormatException e) {
            LOGGER.warning("Number format exception - BookingID: " + bookingIdStr + ", Amount: " + amountStr + " - " + e.getMessage());
            sendErrorRedirect(response, redirectUrl, "Invalid number format. Please enter valid numbers for Booking ID and Amount.");
            return;
        } catch (Exception e) {
            LOGGER.severe("Unexpected error during parsing: " + e.getMessage());
            sendErrorRedirect(response, redirectUrl, "An error occurred while processing your request. Please try again.");
            return;
        }

        // Process Payment
        try {
            LOGGER.info(String.format(
                "Processing admin payment - BookingID: %d, Amount: %s, Method: %s, Type: %s, AdminID: %d",
                bookingId, amount, paymentMethod, paymentType, user.getUserId()
            ));

            // We need to update PaymentManager to accept bookingId instead of eventId
            boolean success = paymentManager.processAdminPayment(bookingId, amount, paymentMethod, paymentType, user.getUserId());

            if (success) {
                String successMsg = String.format("Payment of NPR %s recorded successfully for Booking ID %d!", 
                    amount.setScale(2).toString(), bookingId);
                LOGGER.info("Payment processed successfully for Booking ID: " + bookingId);
                sendSuccessRedirect(response, redirectUrl, successMsg);
            } else {
                String errorMsg = paymentManager.getLastError() != null ? 
                    paymentManager.getLastError() : "Payment failed due to an unknown service error.";
                LOGGER.warning("Payment failed for Booking ID " + bookingId + ": " + errorMsg);
                sendErrorRedirect(response, redirectUrl, errorMsg);
            }
        } catch (Exception e) {
            LOGGER.severe("Unexpected error processing payment for Booking ID " + bookingId + ": " + e.getMessage());
            sendErrorRedirect(response, redirectUrl, "An unexpected server error occurred. Please try again.");
        }
    }

    /**
     * New method to process payment using bookingId
     */
    private boolean processAdminPaymentByBooking(int bookingId, BigDecimal amount, String paymentMethod, 
                                               String paymentType, int adminUserId) {
        try {
            // This method needs to be implemented in PaymentManager
            // For now, we'll use a workaround by getting the eventId from booking
            return paymentManager.processAdminPayment(
                bookingId, amount, paymentMethod, paymentType, adminUserId);
        } catch (Exception e) {
            LOGGER.severe("Error in processAdminPaymentByBooking: " + e.getMessage());
            return false;
        }
    }

    private void sendErrorRedirect(HttpServletResponse response, String redirectUrl, String errorMessage) throws IOException {
        String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
        response.sendRedirect(redirectUrl + "?errorMessage=" + encodedMessage + "#payments");
    }

    private void sendSuccessRedirect(HttpServletResponse response, String redirectUrl, String successMessage) throws IOException {
        String encodedMessage = URLEncoder.encode(successMessage, StandardCharsets.UTF_8);
        response.sendRedirect(redirectUrl + "?successMessage=" + encodedMessage + "#payments");
    }
}