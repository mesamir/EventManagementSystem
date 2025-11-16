package com.ems.controller;

import com.ems.model.Admin;
import com.ems.model.User;
import com.ems.service.AdminManager;
import com.ems.service.UserService;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling admin profile-related actions, including
 * viewing the profile and updating it.
 * This servlet ensures that only logged-in users with the 'admin' role
 * can access and modify their profiles.
 */
@WebServlet("/admin/profile")
public class AdminProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminProfileServlet.class.getName());
    private AdminManager adminManager;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        adminManager = new AdminManager();
        userService = new UserService();
    }

    // --- Utility Method for Authorization ---
    private User authorizeAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return null;
        }
        
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            String errorMessage = URLEncoder.encode("Access Denied: Not an Admin.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?errorMessage=" + errorMessage);
            return null;
        }
        return loggedInUser;
    }

    // -------------------------------------------------------------------------
    // GET Request: Display Profile Page
    // -------------------------------------------------------------------------

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User loggedInUser = authorizeAdmin(request, response);
        if (loggedInUser == null) {
            return; // Authorization failed, response already handled
        }

        // Retrieve the Admin-specific data. NOTE: The User object (loggedInUser) is already in the session.
        Admin adminProfile = adminManager.getAdminByUserId(loggedInUser.getUserId());
        // CRITICAL CORRECTION: Check the object, not the manager
        if (adminProfile == null) {
            LOGGER.log(Level.WARNING, "Admin profile not found for user ID: {0}", loggedInUser.getUserId());
            String errorMessage = URLEncoder.encode("Admin profile not found. Please contact support.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?errorMessage=" + errorMessage);
            return;
        }
        // Set the Admin object for use in the JSP. The User object is available via session.
        request.setAttribute("adminProfile", adminProfile);
        // CRITICAL CORRECTION: Forward to the correct JSP you created
        request.getRequestDispatcher("/admin_profile.jsp").forward(request, response);
    }

    // -------------------------------------------------------------------------
    // POST Request: Update Profile (Handles form submission from modal)
    // -------------------------------------------------------------------------

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User loggedInUser = authorizeAdmin(request, response);
        if (loggedInUser == null) {
            return; // Authorization failed
        }
        
        String redirectUrl = request.getContextPath() + "/admin/profile"; // Redirect back to the profile page
        String messageType = "error";
        String messageText = "Failed to update profile. Please check your input.";

        try {
            // 1. Get input parameters from the form (from admin_profile.jsp)
            String name = request.getParameter("name"); // Corrected parameter case
           // String phone = request.getParameter("phone");
            String email = request.getParameter("email");
           // String address = request.getParameter("address");

            // 2. Update the general User details (for name, email, etc.)
            loggedInUser.setName(name);
            loggedInUser.setEmail(email);
            // Add other User fields here if needed (e.g., setPhone, setAddress if stored in User table)
            boolean userUpdateSuccess = userService.updateUser(loggedInUser);

            // 3. Update the Admin-specific details
            // 3. Update the Admin-specific details
            Admin adminToUpdate = adminManager.getAdminByUserId(loggedInUser.getUserId());
            
            if (adminToUpdate != null) {
                // REMOVE THESE LINES: They are not properties of the Admin model
                // adminToUpdate.setPhone(phone); 
                // adminToUpdate.setAddress(address);
                // adminToUpdate.setEmail(email); 

                boolean adminUpdateSuccess = adminManager.updateAdminProfile(adminToUpdate); // This updates Admin-specific data only
// ...date);
                
                // 4. Set final message based on success
                if (userUpdateSuccess && adminUpdateSuccess) {
                    // Update session with the newly updated User object
                    request.getSession().setAttribute("loggedInUser", loggedInUser); 
                    messageType = "success";
                    messageText = "Admin profile updated successfully!";
                } else {
                    messageText = "Profile update failed. Could not save changes to the database.";
                }
            } else {
                 LOGGER.log(Level.WARNING, "Admin profile not found for user ID: {0} during update attempt.", loggedInUser.getUserId());
                 messageText = "Admin profile not found for update.";
            }

        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Unexpected error during profile update for user ID: " + loggedInUser.getUserId(), e);
             messageText = "An unexpected error occurred.";
        }

        String encodedMessageText = URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString());
        response.sendRedirect(redirectUrl + "?" + messageType + "Message=" + encodedMessageText);
    }
    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, User loggedInUser, String redirectUrl) throws IOException {
        String messageType = "error";
        String messageText = "Failed to update profile details.";

        try {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // 1. Update User table properties (Name, Email, Phone, Address)
            loggedInUser.setName(name);
            loggedInUser.setEmail(email);
            loggedInUser.setPhone(phone); 
            loggedInUser.setAddress(address); 
            
            boolean userUpdateSuccess = userService.updateUser(loggedInUser);

            // 2. Update Admin table properties (Optional, but required if AdminManager.updateAdminProfile() is called)
            // Note: Since phone/email/address are in User model, Admin profile update is usually minimal.
            // Ensure the manager method is called if required for other admin-specific fields.
            Admin adminToUpdate = adminManager.getAdminByUserId(loggedInUser.getUserId());
            adminManager.updateAdminProfile(adminToUpdate); 
            
            if (userUpdateSuccess) {
                request.getSession().setAttribute("loggedInUser", loggedInUser); 
                messageType = "success";
                messageText = "Profile details updated successfully!";
            } else {
                messageText = "Database failure: Could not save User changes.";
            }

        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Unexpected error during profile update: " + e.getMessage(), e);
             messageText = "An unexpected error occurred.";
        }

        String encodedMessageText = URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString());
        response.sendRedirect(redirectUrl + "?" + messageType + "Message=" + encodedMessageText);
    }
    
    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response, User loggedInUser, String redirectUrl) throws IOException {
        String messageType = "error";
        String messageText = "Failed to change password.";

        try {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            
            // NOTE: The UserService must have a method to verify the current password 
            // and update the new one securely (hashed).
            boolean success = userService.changePassword(loggedInUser.getUserId(), currentPassword, newPassword);

            if (success) {
                messageType = "success";
                messageText = "Password changed successfully!";
            } else {
                messageText = "Password change failed. Check your current password.";
            }

        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Unexpected error during password change: " + e.getMessage(), e);
             messageText = "An unexpected error occurred.";
        }

        String encodedMessageText = URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString());
        response.sendRedirect(redirectUrl + "?" + messageType + "Message=" + encodedMessageText);
    }
}