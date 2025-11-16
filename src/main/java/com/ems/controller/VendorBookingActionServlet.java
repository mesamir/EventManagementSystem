package com.ems.controller;

import com.ems.model.User;
import com.ems.model.Booking;
import com.ems.model.Vendor;
import com.ems.service.BookingManager;
import com.ems.service.VendorManager;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/vendor/booking-action")
public class VendorBookingActionServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(VendorBookingActionServlet.class.getName());
    private BookingManager bookingManager;
    private VendorManager vendorManager;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingManager = new BookingManager();
        vendorManager = new VendorManager();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAuthorizedVendor(request.getSession(false))) {
    redirectToLogin(response, request);  // Add request parameter
    return;
}

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");
        String redirectUrl = request.getContextPath() + "/vendor/dashboard#my-bookings";

        if (!"viewDetails".equals(action) || bookingIdStr == null || bookingIdStr.isEmpty()) {
            redirectWithMessage(response, redirectUrl, "error", 
                "Invalid action or missing booking ID for GET request.");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Vendor vendorProfile = vendorManager.getVendorByUserId(loggedInUser.getUserId());
            Booking booking = verifyBookingOwnership(bookingId, vendorProfile.getVendorId());

            if (booking != null) {
                request.setAttribute("booking", booking);
                request.getRequestDispatcher("/view_booking_details.jsp").forward(request, response);
            } else {
                redirectWithMessage(response, redirectUrl, "error",
                    "Booking not found or you do not have permission to view it.");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid Booking ID format: {0}", bookingIdStr);
            redirectWithMessage(response, redirectUrl, "error", "Invalid Booking ID format.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving booking details", e);
            redirectWithMessage(response, redirectUrl, "error", 
                "System error occurred while retrieving booking details.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
if (!isAuthorizedVendor(request.getSession(false))) {
    redirectToLogin(response, request);  // Add request parameter
    return;
}
        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");
        String redirectUrl = request.getContextPath() + "/vendor/dashboard#my-bookings";

        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            redirectWithMessage(response, redirectUrl, "error", "Booking ID is required.");
            return;
        }

        if (!isValidBookingAction(action)) {
            redirectWithMessage(response, redirectUrl, "error", "Invalid action specified.");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            Vendor currentVendor = vendorManager.getVendorByUserId(loggedInUser.getUserId());
            Booking booking = verifyBookingOwnership(bookingId, currentVendor.getVendorId());

            if (booking == null) {
                redirectWithMessage(response, redirectUrl, "error", 
                    "Booking not found or access denied.");
                return;
            }

            boolean success = processBookingAction(action, bookingId);
            String messageType = success ? "success" : "error";
            String messageText = getActionMessage(action, success);

            redirectWithMessage(response, redirectUrl, messageType, messageText);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid Booking ID format: {0}", bookingIdStr);
            redirectWithMessage(response, redirectUrl, "error", "Invalid Booking ID format.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing booking action", e);
            redirectWithMessage(response, redirectUrl, "error", 
                "System error occurred while processing your request.");
        }
    }

    // ========== HELPER METHODS ==========

    private boolean isAuthorizedVendor(HttpSession session) {
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        return "vendor".equalsIgnoreCase(loggedInUser.getRole());
    }

    private void redirectToLogin(HttpServletResponse response, HttpServletRequest request) throws IOException {
    response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
}

    private Booking verifyBookingOwnership(int bookingId, int vendorId) {
        Booking booking = bookingManager.getBookingDetails(bookingId);
        return (booking != null && booking.getVendorId() == vendorId) ? booking : null;
    }

    private boolean isValidBookingAction(String action) {
        return "acceptBooking".equals(action) || "declineBooking".equals(action);
    }

    private boolean processBookingAction(String action, int bookingId) {
        switch (action) {
            case "acceptBooking":
                return bookingManager.vendorAcceptBooking(bookingId);
            case "declineBooking":
                return bookingManager.vendorDeclineBooking(bookingId);
            default:
                return false;
        }
    }

    private String getActionMessage(String action, boolean success) {
        if (success) {
            return "acceptBooking".equals(action) 
                ? "Booking accepted successfully!" 
                : "Booking declined successfully!";
        } else {
            return "acceptBooking".equals(action)
                ? "Failed to accept booking. It might not be in a 'Pending' status."
                : "Failed to decline booking. It might not be in a 'Pending' status.";
        }
    }

    private void redirectWithMessage(HttpServletResponse response, String baseUrl, 
                                   String messageType, String messageText) throws IOException {
        String encodedMessage = URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString());
        response.sendRedirect(baseUrl + "?" + messageType + "Message=" + encodedMessage);
    }
}