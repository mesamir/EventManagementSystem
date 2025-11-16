package com.ems.controller;

import com.ems.dao.VendorDAO;
import com.ems.model.Vendor;
import com.ems.service.VendorManager;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for displaying a public list of approved vendors.
 * This servlet retrieves a list of all approved vendors and forwards it to a JSP page
 * for rendering. No authentication is required to access this page.
 */
@WebServlet("/vendors")
public class PublicVendorDisplayServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PublicVendorDisplayServlet.class.getName());
    private VendorManager vendorManager;
    private VendorDAO vendorDAO;

    /**
     * Initializes the servlet by creating an instance of VendorManager.
     * @throws ServletException if a servlet-specific error occurs.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        vendorManager = new VendorManager();
        vendorDAO = new VendorDAO();
    }

    /**
     * Handles GET requests to display the list of approved vendors.
     *
     * @param request The HttpServletRequest object.
     * @param response The HttpServletResponse object.
     * @throws ServletException if a servlet-specific error occurs.
     * @throws IOException if an I/O error occurs.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
        // Corrected line to get only approved vendors
        List<Vendor> vendorsList = vendorDAO.getApprovedVendors(); 
        
        request.setAttribute("vendors", vendorsList);
        request.getRequestDispatcher("/vendors.jsp").forward(request, response);
    } catch (Exception e) {
        // It's a good idea to handle exceptions here to prevent the application from crashing
        // For example, you could log the error and forward to an error page
        e.printStackTrace(); 
        request.setAttribute("errorMessage", "Could not retrieve vendors due to a server error.");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
    }
}
