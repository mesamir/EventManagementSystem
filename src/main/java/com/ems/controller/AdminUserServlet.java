package com.ems.controller;

import com.ems.model.User;
import com.ems.service.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // --- Server-Side Authorization Check ---
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Not an Admin.");
            return;
        }
        // --- End Authorization Check ---

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");
        String idToDeleteStr = request.getParameter("idToDelete");
        
        boolean success = false;
        String message = "";

        try {
            if ("add".equals(action)) {
                success = handleAddUser(request);
                message = success ? "User added successfully!" : "Failed to add user. Email might already exist.";

            } else if ("edit".equals(action)) {
                success = handleEditUser(request, userIdStr);
                message = success ? "User updated successfully!" : "Failed to update user.";

            } else if ("delete".equals(action)) {
                success = handleDeleteUser(idToDeleteStr);
                message = success ? "User deleted successfully!" : "Failed to delete user.";

            } else {
                message = "Invalid action specified.";
            }

        } catch (NumberFormatException e) {
            message = "Invalid ID format: " + e.getMessage();
            System.err.println("AdminUserServlet: NumberFormatException - " + e.getMessage());
        } catch (Exception e) {
            message = "An unexpected error occurred: " + e.getMessage();
            System.err.println("AdminUserServlet: Unexpected error - " + e.getMessage());
            e.printStackTrace();
        }

        // Redirect back to the same servlet to trigger doGet and refresh the list.
        String redirectUrl = request.getContextPath() + "/admin/users";
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());

        if (success) {
            redirectUrl += "?successMessage=" + encodedMessage;
        } else {
            redirectUrl += "?errorMessage=" + encodedMessage;
        }
        response.sendRedirect(redirectUrl);
    }

    /**
     * Handles adding a new user
     */
    private boolean handleAddUser(HttpServletRequest request) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");

        // Validate required fields
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            role == null || role.trim().isEmpty()) {
            return false;
        }

        return userService.registerUser(name, email, password, phone, address, role);
    }

    /**
     * Handles editing an existing user
     */
    private boolean handleEditUser(HttpServletRequest request, String userIdStr) {
        // Validate user ID
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            throw new NumberFormatException("Missing or empty userId for edit action.");
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr.trim());
        } catch (NumberFormatException e) {
            throw new NumberFormatException("Invalid user ID format: " + userIdStr);
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");

        // Validate required fields
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            return false;
        }

        User userToUpdate = userService.getUserById(userId);
        if (userToUpdate != null) {
            userToUpdate.setName(name);
            userToUpdate.setEmail(email);
            
            // Only update password if provided
            if (password != null && !password.trim().isEmpty()) {
                userToUpdate.setPasswordHash(password);
            }
            
            userToUpdate.setPhone(phone);
            userToUpdate.setAddress(address);
            userToUpdate.setRole(role);

            return userService.updateUser(userToUpdate);
        } else {
            return false;
        }
    }

    /**
     * Handles deleting a user
     */
    private boolean handleDeleteUser(String idToDeleteStr) {
        // Validate user ID
        if (idToDeleteStr == null || idToDeleteStr.trim().isEmpty()) {
            throw new NumberFormatException("Missing or empty idToDelete for delete action.");
        }

        int userId;
        try {
            userId = Integer.parseInt(idToDeleteStr.trim());
        } catch (NumberFormatException e) {
            throw new NumberFormatException("Invalid user ID format for deletion: " + idToDeleteStr);
        }

        // Check if user exists before deletion
        User userToDelete = userService.getUserById(userId);
        if (userToDelete == null) {
            return false;
        }

        return userService.deleteUser(userId);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // --- Server-Side Authorization Check ---
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Not an Admin.");
            return;
        }
        // --- End Authorization Check ---

        // Fetch all users to display on the dashboard
        List<com.ems.model.User> users = userService.getAllUsers();
        request.setAttribute("users", users);

        // Fetch total counts for dashboard overview
        int totalUsers = userService.getTotalUsersCount();
        int totalVendors = userService.getTotalVendorsCount();
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalVendors", totalVendors);

        // Forward to the admin dashboard JSP.
        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
    }
}