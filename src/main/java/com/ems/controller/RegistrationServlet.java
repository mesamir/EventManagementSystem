package com.ems.controller;

import com.ems.model.Client;
import com.ems.model.User;
import com.ems.service.UserService;
import com.ems.service.VendorManager;
import com.ems.service.ClientManager;
import com.ems.service.AdminManager;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling user registration requests.
 * It processes form data from the registration page, registers a new user
 * in the main users table, and then creates a role-specific profile
 * (e.g., vendor, customer, admin).
 */
@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegistrationServlet.class.getName());

    private UserService userService;
    private VendorManager vendorManager;
    private ClientManager customerManager;
    private AdminManager adminManager;

    /**
     * Initializes the servlet by creating instances of the necessary service managers.
     * @throws ServletException if a servlet-specific error occurs.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
        vendorManager = new VendorManager();
        customerManager = new ClientManager();
        adminManager = new AdminManager();
    }

    /**
     * Handles POST requests for user registration.
     *
     * @param request The HttpServletRequest object.
     * @param response The HttpServletResponse object.
     * @throws ServletException if a servlet-specific error occurs.
     * @throws IOException if an I/O error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (phone == null) phone = "";
        if (address == null) address = "";

        // Basic server-side validation for password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
            return;
        }

        
        boolean registrationSuccess = userService.registerUserAndProfile(request, name, email, password, phone, address, role);

    // 3. Handle Outcome
    if (registrationSuccess) {
        LOGGER.log(Level.INFO, "Registration Successful for user: {0} as {1}.", new Object[]{email, role});
        response.sendRedirect(request.getContextPath() + "/login.jsp?registrationSuccess=true");
    } else {
        // The service failed due to existing email, database error, or profile creation/rollback error.
        // The Service should ideally log the specific reason internally.
        
        // Check if an error message was set by the Service (e.g., "Email already exists")
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage == null) {
            errorMessage = "Registration failed due to a system error. Please try again or contact support.";
        }
        
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("registration.jsp").forward(request, response);
    }
    }

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("registration.jsp").forward(request, response);
    }
}
