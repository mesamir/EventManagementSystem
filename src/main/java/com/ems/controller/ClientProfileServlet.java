package com.ems.controller;

import com.ems.model.User;
import com.ems.model.Client;
import com.ems.service.ClientManager;

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

/**
 * Servlet for handling client profile-related actions, including
 * viewing the profile, updating it, and creating the profile on first access.
 * This servlet ensures that only logged-in users with the 'client' role
 * can access and modify their profiles.
 */
@WebServlet("/client/profile")
public class ClientProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ClientProfileServlet.class.getName());
    private ClientManager clientManager;
    
    // Helper method for robust role check
    private boolean isAuthorized(User user) {
        if (user == null) {
            return false;
        }
        String role = user.getRole().toLowerCase();
        // Authorize if the role is 'client' OR 'customer'
        return "client".equals(role) || "customer".equals(role);
    }

    /**
     * Initializes the servlet by creating an instance of the ClientManager.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        clientManager = new ClientManager();
    }

    /**
     * Handles GET requests to retrieve and display the client's profile for editing.
     * It also handles first-time profile creation if the client profile is missing.
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
        String redirectUrl = request.getContextPath() + "/client/dashboard#my-profile";

        // ... Authorization Check (Correct) ...
        // Authorization Check
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        // --- FIX: Use robust authorization check for client/customer roles ---
        if (!isAuthorized(loggedInUser)) {
            String errorMessage = URLEncoder.encode("Access Denied: Invalid role for profile access.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectUrl + "?errorMessage=" + errorMessage);
            return;
        }

        // Retrieve the client profile
        Client clientProfile = clientManager.getCustomerProfileByUserId(loggedInUser.getUserId());

        // --- Logic to create profile if missing (Corrected in previous steps) ---
        if (clientProfile == null) {
            LOGGER.log(Level.INFO, "Client profile missing for user ID: {0}. Creating new profile.", loggedInUser.getUserId());
            
            Client newClient = new Client(
                loggedInUser.getUserId(),
                loggedInUser.getName(),
                loggedInUser.getEmail(),
                loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "",
                loggedInUser.getAddress() != null ? loggedInUser.getAddress() : ""
            );
            
            boolean success = clientManager.addCustomerProfile(newClient);
            
            if (!success) {
                String errorMessage = URLEncoder.encode("Failed to initialize profile. Please try again.", StandardCharsets.UTF_8.toString());
                response.sendRedirect(redirectUrl + "?errorMessage=" + errorMessage);
                return;
            }
            
            clientProfile = clientManager.getCustomerProfileByUserId(loggedInUser.getUserId());
            
            if (clientProfile == null) {
                String errorMessage = URLEncoder.encode("Profile created but failed to retrieve.", StandardCharsets.UTF_8.toString());
                response.sendRedirect(redirectUrl + "?errorMessage=" + errorMessage);
                return;
            }
        }

        // Profile is now guaranteed to exist
        request.setAttribute("clientProfile", clientProfile);
        request.setAttribute("loggedInUser", loggedInUser);
        request.getRequestDispatcher("/clientProfile.jsp").forward(request, response);
    }

    /**
     * Handles POST requests to update the client's profile (phone and address).
     *
     * @param request The HttpServletRequest object.
     * @param response The HttpServletResponse object.
     * @throws ServletException if a servlet-specific error occurs.
     * @throws IOException if an I/O error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String redirectUrl = request.getContextPath() + "/client/dashboard#my-profile";

        // Authorization Check
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        // --- FIX: Use robust authorization check for client/customer roles ---
        if (!isAuthorized(loggedInUser)) {
            String errorMessage = URLEncoder.encode("Access Denied: Invalid role for profile access.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectUrl + "?errorMessage=" + errorMessage);
            return;
        }

        // Get Client-specific parameters
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        String messageType = "error";
        String messageText = "Failed to update profile. Please check your input and try again.";

        try {
            // Retrieve the existing profile to get the customerId
            Client clientToUpdate = clientManager.getCustomerProfileByUserId(loggedInUser.getUserId());

            if (clientToUpdate == null || clientToUpdate.getCustomerId() == 0) {
                LOGGER.log(Level.WARNING, "Client profile not found for user ID: {0} during update attempt.", loggedInUser.getUserId());
                messageText = "Client profile not found for update. Please try logging in again.";
            } else {
                // Update only the mutable fields
                clientToUpdate.setPhone(phone);
                clientToUpdate.setAddress(address);

                boolean success = clientManager.updateCustomerProfile(clientToUpdate);

                if (success) {
                    messageType = "success";
                    messageText = "Client profile updated successfully!";
                } else {
                    messageText = "Failed to update client profile in database.";
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during client profile update.", e);
            messageText = "An unexpected error occurred during update.";
        }

        String encodedMessageText = URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString());
        response.sendRedirect(redirectUrl + "?" + messageType + "Message=" + encodedMessageText);
    }
}
