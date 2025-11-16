// src/main/java/com/ems/controller/ClientDashboardDisplayServlet.java
package com.ems.controller;

import com.ems.model.User;
import com.ems.model.Event;
import com.ems.model.Booking;
import com.ems.model.Client;
import com.ems.model.Payment;
import com.ems.service.EventManager;
import com.ems.service.BookingManager;
import com.ems.service.ClientManager;
import com.ems.service.PaymentManager;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to display the customer's dashboard.
 * This servlet handles the fetching of all customer-specific data (events,
 * bookings, and payments) and forwards it to the customer dashboard JSP for rendering.
 * It follows the "POST-Redirect-GET" pattern, serving as the target for GET requests
 * after state-changing actions are completed by other servlets.
 */
@WebServlet("/client/dashboard")
public class ClientDashboardDisplayServlet extends HttpServlet {

    private static final String ATTR_LOGGED_IN_USER = "loggedInUser";
    private static final String ATTR_CUSTOMER_EVENTS = "customerEvents";
    private static final String ATTR_CLIENT_PROFILE = "clientProfile"; // Added for consistency
    private static final String ATTR_CUSTOMER_BOOKINGS = "customerBookings";
    private static final String ATTR_CUSTOMER_PAYMENTS = "customerPayments";
    private static final String USER_ROLE_CUSTOMER = "customer";
    private static final String JSP_LOGIN_PAGE = "/login.jsp?error=unauthorized";
    private static final String JSP_CUSTOMER_DASHBOARD = "/client_dashboard.jsp";

    private EventManager eventManager;
    private BookingManager bookingManager;
    private PaymentManager paymentManager;
    private ClientManager clientManager; // New Manager

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize service managers to handle business logic
        eventManager = new EventManager();
        bookingManager = new BookingManager();
        paymentManager = new PaymentManager();
        clientManager = new ClientManager(); // Initialize ClientManager
    }

    /**
     * Handles GET requests to display the customer dashboard. It performs
     * authorization, fetches all necessary data, and forwards it to the JSP.
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

        // --- Authorization Check (Basic Login) ---
        if (session == null || session.getAttribute(ATTR_LOGGED_IN_USER) == null) {
            response.sendRedirect(request.getContextPath() + JSP_LOGIN_PAGE);
            return;
        }

        User loggedInUser = (User) session.getAttribute(ATTR_LOGGED_IN_USER);
        
        // --- FIX: Robust Authorization Check for 'client' OR 'customer' ---
        String role = loggedInUser.getRole().toLowerCase();
        if (!"customer".equals(role) && !"client".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Invalid role for profile access.");
            return;
        }
        // --- End Authorization Check ---

        int userId = loggedInUser.getUserId();

        try {
            // CRITICAL STEP 1: Fetch the Client Profile for the dashboard display
            Client clientProfile = clientManager.getCustomerProfileByUserId(userId);
            
            // NOTE: If clientProfile is null here, it means the record is missing. 
            // The ClientProfileServlet should handle creation on first access, but 
            // for display purposes here, null is acceptable if the JSP handles it.
            
            // CRITICAL STEP 2: Fetch all other dashboard data
            List<Event> customerEvents = eventManager.getEventsWithPaymentStatus(userId);
            List<Booking> customerBookings = bookingManager.getCustomerBookings(userId);
            List<Payment> customerPayments = paymentManager.getCustomersPayments(userId);

            // Set the fetched data as request attributes
            request.setAttribute(ATTR_LOGGED_IN_USER, loggedInUser);
            request.setAttribute(ATTR_CLIENT_PROFILE, clientProfile); // Set the client profile!
            request.setAttribute(ATTR_CUSTOMER_EVENTS, customerEvents);
            request.setAttribute(ATTR_CUSTOMER_BOOKINGS, customerBookings);
            request.setAttribute(ATTR_CUSTOMER_PAYMENTS, customerPayments);

            // Forward the request to the customer dashboard JSP
            request.getRequestDispatcher(JSP_CUSTOMER_DASHBOARD).forward(request, response);

        } catch (Exception e) {
            System.err.println("Error loading customer dashboard for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            
            // Re-fetch essential data if possible, or forward with error message
            request.setAttribute("errorMessage", "Unable to load dashboard data. Please try again.");
            request.getRequestDispatcher(JSP_CUSTOMER_DASHBOARD).forward(request, response);
        }
    }
}