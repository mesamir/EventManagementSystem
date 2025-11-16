package com.ems.controller;

import com.ems.model.User;
import com.ems.service.UserService;
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
 * Servlet for handling dedicated Admin login requests.
 * Mapped to /admin
 */
@WebServlet("/admin")
public class AdminLoginServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService(); 
    }

    /**
     * Handles POST requests for admin login authentication.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String errorMessage = "";

        // Minimal Server-Side Validation
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            errorMessage = "Admin Email and Password are required.";
        }

        if (!errorMessage.isEmpty()) {
            String encodedError = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/adminLogin.jsp?errorMessage=" + encodedError);
            return;
        }

        User user = userService.authenticateUser(email, password);

        // Check if user exists AND if their role is explicitly 'admin'
        if (user != null && "admin".equalsIgnoreCase(user.getRole())) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            // Successful login: Redirect to the admin dashboard servlet
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        } else {
            // Login failed (User null, password wrong, or role is not admin)
            errorMessage = "Invalid admin credentials or user is not an administrator.";
            String encodedError = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/adminLogin.jsp?errorMessage=" + encodedError);
        }
    }

    /**
     * Handles GET requests, redirecting to the dashboard if already logged in as admin,
     * or forwarding to the login page otherwise.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        boolean isAdminLoggedIn = false;
        
        if (session != null && session.getAttribute("loggedInUser") != null) {
            User user = (User) session.getAttribute("loggedInUser");
            // Use equalsIgnoreCase here for consistency with other role checks
            if ("admin".equalsIgnoreCase(user.getRole())) {
                isAdminLoggedIn = true;
            }
        }

        if (isAdminLoggedIn) {
            String redirectPath = request.getContextPath() + "/admin/dashboard";
            response.sendRedirect(redirectPath);
            return; 
        } else {
            // Forward to the admin login JSP to display the form
            request.getRequestDispatcher("/adminLogin.jsp").forward(request, response);
        }
    }
}