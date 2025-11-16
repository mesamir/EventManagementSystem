package com.ems.controller;

import com.ems.model.User;
import com.ems.model.Vendor;
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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling vendor profile-related actions, including
 * viewing the profile and updating it.
 * This servlet ensures that only logged-in users with the 'vendor' role
 * can access and modify their profiles.
 */
@WebServlet("/vendor/profile")
public class VendorProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(VendorProfileServlet.class.getName());
    private VendorManager vendorManager;

    /**
     * Initializes the servlet by creating an instance of the VendorManager.
     * @throws ServletException if a servlet-specific error occurs.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        vendorManager = new VendorManager();
    }

    /**
     * Handles GET requests to retrieve and display the vendor's profile for editing.
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
        String redirectUrl = request.getContextPath() + "/vendor/dashboard#my-profile";

        // Authorization Check
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"vendor".equalsIgnoreCase(loggedInUser.getRole())) {
            String errorMessage = URLEncoder.encode("Access Denied: Not a Vendor.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectUrl + "?errorMessage=" + errorMessage);
            return;
        }

        Vendor vendorProfile = vendorManager.getVendorByUserId(loggedInUser.getUserId());
        if (vendorProfile == null) {
            LOGGER.log(Level.WARNING, "Vendor profile not found for user ID: {0}", loggedInUser.getUserId());
            String errorMessage = URLEncoder.encode("Vendor profile not found. Please contact support.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectUrl + "?errorMessage=" + errorMessage);
            return;
        }
        request.setAttribute("vendorProfile", vendorProfile);
        request.setAttribute("loggedInUser", loggedInUser);
        request.getRequestDispatcher("/edit_vendor_profile.jsp").forward(request, response);
    }

    /**
     * Handles POST requests to update the vendor's profile.
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
        String redirectUrl = request.getContextPath() + "/vendor/dashboard#my-profile";

        // Authorization Check
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"vendor".equalsIgnoreCase(loggedInUser.getRole())) {
            String errorMessage = URLEncoder.encode("Access Denied: Not a Vendor.", StandardCharsets.UTF_8.toString());
            response.sendRedirect(redirectUrl + "?errorMessage=" + errorMessage);
            return;
        }

        String companyName = request.getParameter("companyName");
        String serviceType = request.getParameter("serviceType");
        String contactPerson = request.getParameter("contactPerson");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String description = request.getParameter("description");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String portfolioLink = request.getParameter("portfolioLink");

        String messageType = "error";
        String messageText = "Failed to update profile. Please check your input and try again.";

        try {
            Vendor vendorToUpdate = vendorManager.getVendorByUserId(loggedInUser.getUserId());

            if (vendorToUpdate == null) {
                LOGGER.log(Level.WARNING, "Vendor profile not found for user ID: {0} during update attempt.", loggedInUser.getUserId());
                messageText = "Vendor profile not found for update.";
            } else {
                BigDecimal minPrice = minPriceStr != null && !minPriceStr.isEmpty() ? new BigDecimal(minPriceStr) : null;
                BigDecimal maxPrice = maxPriceStr != null && !maxPriceStr.isEmpty() ? new BigDecimal(maxPriceStr) : null;

                vendorToUpdate.setCompanyName(companyName);
                vendorToUpdate.setServiceType(serviceType);
                vendorToUpdate.setContactPerson(contactPerson);
                vendorToUpdate.setPhone(phone);
                vendorToUpdate.setEmail(email);
                vendorToUpdate.setAddress(address);
                vendorToUpdate.setDescription(description);
                vendorToUpdate.setMinPrice(minPrice);
                vendorToUpdate.setMaxPrice(maxPrice);
                vendorToUpdate.setPortfolioLink(portfolioLink);

                boolean success = vendorManager.updateVendor(vendorToUpdate);

                if (success) {
                    messageType = "success";
                    messageText = "Vendor profile updated successfully!";
                } else {
                    messageText = "Failed to update vendor profile in database.";
                }
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid number format for price fields.", e);
            messageText = "Invalid number format for price fields. Please enter valid numbers.";
        }

        String encodedMessageText = URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString());
        response.sendRedirect(redirectUrl + "?" + messageType + "Message=" + encodedMessageText);
    }
}
