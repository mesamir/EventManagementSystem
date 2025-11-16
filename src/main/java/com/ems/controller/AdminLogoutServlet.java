package com.ems.controller;

import com.ems.model.User;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling Admin logout requests.
 */
@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        performLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        performLogout(request, response);
    }

    /**
     * Performs the logout logic by invalidating the session if no other non-admin users remain.
     * It uses the "loggedInUser" attribute set by AdminLoginServlet.
     */
    private void performLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        String identifier = "Unknown Admin";
        String logoutMessage = "";

        if (session != null) {
            User user = (User) session.getAttribute("loggedInUser");
            
            // Check if the current session attribute actually belongs to an admin
            if (user != null && "admin".equals(user.getRole())) {
                identifier = user.getEmail();
                
                // 1. Remove the admin's attribute
                session.removeAttribute("loggedInUser");
                
                // 2. Check if other known non-admin sessions (vendor, customer) remain
                // This logic is retained from your original intent to support multiple user types.
                boolean hasVendorUser = session.getAttribute("vendorUser") != null;
                boolean hasCustomerUser = session.getAttribute("customerUser") != null;
                
                if (!hasVendorUser && !hasCustomerUser) {
                    // No other user types logged in - invalidate completely
                    session.invalidate();
                    logoutMessage = "Admin (" + identifier + ") logged out successfully. Session invalidated.";
                    System.out.println("Admin " + identifier + " - Session completely invalidated.");
                } else {
                    // Other user types remain - keep session
                    logoutMessage = "Admin (" + identifier + ") logged out. Other user sessions remain active.";
                    System.out.println("Admin " + identifier + " - Only admin attributes removed.");
                }

            } else {
                logoutMessage = "No active admin user found in session.";
                System.out.println("No active admin user found in session.");
            }
        } else {
            logoutMessage = "No active session found.";
            System.out.println("No active session to invalidate.");
        }

        // Redirect to the admin login page
        String encodedMessage = URLEncoder.encode(logoutMessage, StandardCharsets.UTF_8.toString());
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp?logoutMessage=" + encodedMessage);
    }
}
