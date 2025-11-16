package com.ems.controller;

import com.ems.model.User;
import com.ems.service.UserService;
import com.ems.service.VendorManager;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/admin/add-vendor") // Maps this servlet for admin adding vendors
public class AdminAddVendorServlet extends HttpServlet {
    private UserService userService;
    private VendorManager vendorManager;

    @Override
    public void init() throws ServletException {
        super.init();
        userService = new UserService();
        vendorManager = new VendorManager();
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

        // Just forward to the admin add vendor JSP form
        request.getRequestDispatcher("/admin_add_vendor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // --- Server-Side Authorization Check ---
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"admin".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Not an Admin.");
            return;
        }
        // --- End Authorization Check ---

        // Get user parameters
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Get vendor profile parameters
        String companyName = request.getParameter("companyName");
        String serviceType = request.getParameter("serviceType");
        String contactPerson = request.getParameter("contactPerson");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String description = request.getParameter("description");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String portfolioLink = request.getParameter("portfolioLink");

        String messageType = "error";
        String messageText = "Failed to add new vendor.";
        StringBuilder validationErrors = new StringBuilder();

        // --- Server-Side Validation for User Details ---
        if (name == null || name.trim().isEmpty()) {
            validationErrors.append("Full Name is required.<br>");
        }
        if (email == null || email.trim().isEmpty()) {
            validationErrors.append("Email Address is required.<br>");
        } else if (!isValidEmail(email)) {
            validationErrors.append("Please enter a valid email address.<br>");
        }
        if (password == null || password.isEmpty()) {
            validationErrors.append("Password is required.<br>");
        } else if (!isValidPassword(password)) {
            validationErrors.append("Password must be at least 8 characters, including uppercase, lowercase, number, and special character.<br>");
        }
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            validationErrors.append("Confirm Password is required.<br>");
        } else if (!password.equals(confirmPassword)) {
            validationErrors.append("Passwords do not match.<br>");
        }

        // --- Server-Side Validation for Vendor Profile Details ---
        if (companyName == null || companyName.trim().isEmpty()) {
            validationErrors.append("Company Name is required.<br>");
        }
        if (serviceType == null || serviceType.trim().isEmpty()) {
            validationErrors.append("Service Type is required.<br>");
        }
        if (contactPerson == null || contactPerson.trim().isEmpty()) {
            validationErrors.append("Contact Person is required.<br>");
        }
        if (phone == null || phone.trim().isEmpty()) {
            validationErrors.append("Phone number is required.<br>");
        }
        if (address == null || address.trim().isEmpty()) {
            validationErrors.append("Address is required.<br>");
        }

        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        try {
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                minPrice = new BigDecimal(minPriceStr);
            }
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                maxPrice = new BigDecimal(maxPriceStr);
            }
            if (minPrice != null && maxPrice != null && minPrice.compareTo(maxPrice) > 0) {
                validationErrors.append("Minimum price cannot be greater than maximum price.<br>");
            }
        } catch (NumberFormatException e) {
            validationErrors.append("Invalid number format for price fields.<br>");
        }

        if (validationErrors.length() > 0) {
            request.setAttribute("errorMessage", validationErrors.toString());
            // Re-populate form fields to retain user input
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("companyName", companyName);
            request.setAttribute("serviceType", serviceType);
            request.setAttribute("contactPerson", contactPerson);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("description", description);
            request.setAttribute("minPrice", minPriceStr);
            request.setAttribute("maxPrice", maxPriceStr);
            request.setAttribute("portfolioLink", portfolioLink);
            request.getRequestDispatcher("/admin_add_vendor.jsp").forward(request, response);
            return;
        }

        try {
            // 1. Register the new user with 'vendor' role
            boolean userRegistered = userService.registerUser(name, email, password, phone, address, "vendor");

            if (userRegistered) {
                // 2. Retrieve the newly created user to get their userId
                User newVendorUser = userService.getUserByEmail(email); // Assuming email is unique and can retrieve user

                if (newVendorUser != null) {
                    // 3. Create the vendor profile linked to the new user's ID
                    boolean vendorProfileAdded = vendorManager.addVendorProfile(
                            newVendorUser.getUserId(), companyName, serviceType, contactPerson,
                            phone, email, address, description, minPrice, maxPrice, portfolioLink
                    );

                    if (vendorProfileAdded) {
                        messageType = "success";
                        messageText = "New vendor '" + companyName + "' added successfully!";
                    } else {
                        // If vendor profile creation fails, consider rolling back user creation (more advanced)
                        messageText = "User created, but failed to add vendor profile. Please check logs.";
                    }
                } else {
                    messageText = "User registration succeeded, but could not retrieve user for vendor profile creation.";
                }
            } else {
                messageText = "Failed to register new user. Email might already exist.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            messageText = "An unexpected server error occurred: " + e.getMessage();
        }

        // Redirect back to the Admin Dashboard Vendor Management section with a message
        String redirectUrl = request.getContextPath() + "/admin/dashboard?" + messageType + "Message=" +
                URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString()) + "#vendors";
        response.sendRedirect(redirectUrl);
    }

    // Helper method for email validation
    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

    // Helper method for password validation (same as in RegistrationServlet)
    private boolean isValidPassword(String password) {
        // At least 8 characters, one uppercase, one lowercase, one number, one special character
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        return password.matches(passwordRegex);
    }
}
