package com.ems.controller;

import com.ems.model.User;
import com.ems.service.UserService;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Pattern;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling general user login requests (Vendor and Customer).
 * Admin login is explicitly denied and redirected to the appropriate path.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService userService;
    // Simplified regex for common use cases, though a robust library is preferred in production.
    private static final String EMAIL_REGEX = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    private static final Pattern EMAIL_PATTERN = Pattern.compile(EMAIL_REGEX);

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
    }

    /**
     * Handles POST requests for user login (Customer/Vendor only).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String errorMessage = "";

        // --- Server-Side Validation ---
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            errorMessage = "Email and Password are required.";
        } else if (!isValidEmail(email)) {
            errorMessage = "Please enter a valid email address.";
        }

        if (!errorMessage.isEmpty()) {
            String encodedError = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/login.jsp?errorMessage=" + encodedError);
            return;
        }

        User user = userService.authenticateUser(email, password);

        if (user != null) {
            // Check if the user is an admin. If so, deny login here and force them to the admin path.
            // Using equalsIgnoreCase for robustness, although database ENUM should ensure lowercase.
            if ("admin".equalsIgnoreCase(user.getRole())) {
                errorMessage = "Administrative access requires the dedicated admin login page.";
                String encodedError = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/login.jsp?errorMessage=" + encodedError);
                return;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);

            String redirectPath;
            switch (user.getRole().toLowerCase()) { // Use toLowerCase just in case of slight role casing differences
                case "vendor":
                    redirectPath = request.getContextPath() + "/vendor/dashboard";
                    break;
                case "customer":
                    redirectPath = request.getContextPath() + "/client/dashboard";
                    break;
                default:
                    // Handle unknown/invalid roles by logging out and redirecting to the login page
                    session.invalidate(); 
                    errorMessage = "Unknown user role. Please contact support.";
                    String encodedError = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
                    response.sendRedirect(request.getContextPath() + "/login.jsp?errorMessage=" + encodedError);
                    return;
            }
            response.sendRedirect(redirectPath);
        } else {
            errorMessage = "Invalid email or password.";
            String encodedError = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/login.jsp?errorMessage=" + encodedError);
        }
    }

    /**
     * Handles GET requests to display the login form or redirect if already authenticated.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            User user = (User) session.getAttribute("loggedInUser");
            String redirectPath;

            // Admin case is intentionally omitted; they should use /admin route for dashboard access
            if ("vendor".equalsIgnoreCase(user.getRole())) {
                redirectPath = request.getContextPath() + "/vendor/dashboard";
            } else if ("customer".equalsIgnoreCase(user.getRole())) {
                redirectPath = request.getContextPath() + "/client/dashboard";
            } else {
                // For 'admin' or unknown roles, just forward to login page to prevent confusion
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            response.sendRedirect(redirectPath);
        } else {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Validates an email address format.
     */
    private boolean isValidEmail(String email) {
        if (email == null) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
}