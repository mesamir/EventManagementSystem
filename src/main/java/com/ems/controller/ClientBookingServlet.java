// src/main/java/com/ems/controller/ClientBookingServlet.java
package com.ems.controller;

import com.ems.model.User;
import com.ems.model.Booking;
import com.ems.service.BookingManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

/**
 * Servlet for handling POST requests to book an event.
 * Updated to align with new workflow: no vendor assignment during booking creation
 */
@WebServlet("/client/book-event")
public class ClientBookingServlet extends HttpServlet {
    private BookingManager bookingService;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingService = new BookingManager();
    }

    /**
     * Handles POST requests for booking an event without vendor assignment.
     *
     * @param request The HttpServletRequest object containing booking details.
     * @param response The HttpServletResponse object for redirecting.
     * @throws ServletException if a servlet-specific error occurs.
     * @throws IOException if an I/O error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String messageType = "error";
        String messageText = "An unknown error occurred.";

        // --- Authorization Check ---
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?errorMessage=Please log in to book an event.");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"customer".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard?errorMessage=Access denied. Only customers can book events.");
            return;
        }

        // Get parameters from the form
        String eventIdStr = request.getParameter("eventId");
        String serviceBooked = request.getParameter("serviceBooked"); // e.g., "Venue Rental", "Catering Package"
        String amountStr = request.getParameter("amount"); // Total estimated cost
        String notes = request.getParameter("notes");

        // Basic server-side validation
        try {
            if (eventIdStr == null || eventIdStr.isEmpty() ||
                serviceBooked == null || serviceBooked.trim().isEmpty() ||
                amountStr == null || amountStr.trim().isEmpty()) {
                messageText = "Event ID, Service Booked, and Amount are required.";
                sendRedirect(response, request, messageType, messageText);
                return;
            }

            int eventId = Integer.parseInt(eventIdStr);
            BigDecimal amount = new BigDecimal(amountStr);

            // Validate amount
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                messageText = "Amount must be greater than zero.";
                sendRedirect(response, request, messageType, messageText);
                return;
            }

            // Create booking without vendor assignment (new workflow)
            Booking newBooking = bookingService.createBookingWithoutVendor(
                eventId, 
                loggedInUser.getUserId(), 
                serviceBooked.trim(), 
                amount, 
                notes != null ? notes.trim() : ""
            );

            if (newBooking != null) {
                messageType = "success";
                messageText = "Booking request submitted successfully! Booking ID: " + newBooking.getBookingId() + 
                    ". The booking is pending and vendors will be assigned later.";
            } else {
                messageText = "Failed to submit booking request. Please ensure the event exists and is approved.";
            }

        } catch (NumberFormatException e) {
            messageText = "Invalid Event ID or Amount format. Please use valid numbers.";
            System.err.println("ClientBookingServlet: NumberFormatException - " + e.getMessage());
        } catch (SQLException e) {
            messageText = "Database error occurred while creating booking. Please try again.";
            System.err.println("ClientBookingServlet: SQLException - " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            messageText = "An unexpected error occurred: " + e.getMessage();
            System.err.println("ClientBookingServlet: Unexpected error - " + e.getMessage());
            e.printStackTrace();
        }

        sendRedirect(response, request, messageType, messageText);
    }

    /**
     * Handles GET requests to show booking form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // --- Authorization Check ---
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?errorMessage=Please log in to book an event.");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"customer".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard?errorMessage=Access denied. Only customers can book events.");
            return;
        }

        // Get event ID from parameters if provided
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
            try {
                int eventId = Integer.parseInt(eventIdStr);
                request.setAttribute("eventId", eventId);
            } catch (NumberFormatException e) {
                // Ignore invalid event ID, form will work without it
                System.err.println("Invalid event ID in GET request: " + eventIdStr);
            }
        }

        // Forward to booking form JSP
        request.getRequestDispatcher("/book-event.jsp").forward(request, response);
    }

    /**
     * Helper method to send redirect with message
     */
    private void sendRedirect(HttpServletResponse response, HttpServletRequest request, 
                            String messageType, String messageText) throws IOException {
        String redirectUrl = request.getContextPath() + "/client/dashboard?" + messageType + "Message=" +
                             URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString()) + "#my-bookings";
        response.sendRedirect(redirectUrl);
    }
}