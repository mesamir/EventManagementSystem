package com.ems.service;

import com.ems.dao.VendorDAO;
import com.ems.model.Vendor;


import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

/**
 * A service layer class that manages business logic related to vendors. It acts
 * as an intermediary between the application's presentation layer (e.g.,
 * servlets) and the data access layer (VendorDAO).
 */
public class VendorManager {

    // Public constants for vendor status to ensure consistency across the application
    public static final String STATUS_PENDING_APPROVAL = "Pending Approval";
    public static final String STATUS_APPROVED = "Approved";
    public static final String STATUS_REJECTED = "Rejected";
    public static final String STATUS_INACTIVE = "Inactive";

    private VendorDAO vendorDAO;

    public VendorManager() {
        this.vendorDAO = new VendorDAO();
    }

    
    /**
     * Retrieves a vendor by their ID.
     *
     * @param vendorId The ID of the vendor to retrieve.
     * @return The Vendor object if found, or null otherwise.
     */
    public Vendor getVendorById(int vendorId) {
        return vendorDAO.getVendorById(vendorId);
    }

    /**
     * Retrieves a list of all vendors.
     *
     * @return A list of all Vendor objects.
     */
    public List<Vendor> getAllVendors(){
        return vendorDAO.getAllVendors();
    }

    /**
     * Retrieves a list of all vendors with a specific status.
     *
     * @param status The status to filter by (e.g., "Pending", "Approved").
     * @return A list of Vendor objects matching the status, or an empty list.
     */
    public List<Vendor> getVendorsByStatus(String status) {
        try {
            return vendorDAO.getVendorsByStatus(status);
        } catch (SQLException e) {
            System.err.println("Database error while fetching vendors by status " + status + ": " + e.getMessage());
            e.printStackTrace();
            return null; // Or return new ArrayList<>();
        }
    }

    /**
     * Retrieves a vendor by their associated User ID.
     *
     * @param userId The ID of the user.
     * @return The Vendor object if found, or null otherwise.
     */
    public Vendor getVendorByUserId(int userId) {
        try {
            return vendorDAO.getVendorByUserId(userId);
        } catch (SQLException e) {
            System.err.println("Database error while fetching vendor profile for userId " + userId + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Approves a vendor's registration.
     *
     * @param vendorId The ID of the vendor to approve.
     * @return true if the status was updated successfully, false otherwise.
     */
    public boolean approveVendor(int vendorId) {
        Vendor vendor = vendorDAO.getVendorById(vendorId);
        if (vendor == null) {
            System.err.println("VendorManager: Vendor with ID " + vendorId + " not found for approval.");
            return false;
        }
        if (!STATUS_PENDING_APPROVAL.equalsIgnoreCase(vendor.getStatus())) {
            System.err.println("VendorManager: Vendor " + vendorId + " cannot be approved. Current status: " + vendor.getStatus());
            return false;
        }
        return vendorDAO.updateVendorStatus(vendorId, STATUS_APPROVED);
    }

     /**
     * Rejects a vendor's registration.
     *
     * @param vendorId The ID of the vendor to reject.
     * @return true if the status was updated successfully, false otherwise.
     */
    public boolean rejectVendor(int vendorId) {
        Vendor vendor = vendorDAO.getVendorById(vendorId);
        if (vendor == null) {
            System.err.println("VendorManager: Vendor with ID " + vendorId + " not found for rejection.");
            return false;
        }
        if (!STATUS_PENDING_APPROVAL.equalsIgnoreCase(vendor.getStatus())) {
            System.err.println("VendorManager: Vendor " + vendorId + " cannot be rejected. Current status: " + vendor.getStatus());
            return false;
        }
        return vendorDAO.updateVendorStatus(vendorId, STATUS_REJECTED);
    }

   
    /**
     * Deletes a vendor profile from the database.
     *
     * @param vendorId The ID of the vendor to delete.
     * @return true if the deletion was successful, false otherwise.
     */
    public boolean deleteVendor(int vendorId) {
        return vendorDAO.deleteVendor(vendorId);
    }
/**
     * Deactivates a vendor's status (e.g., from Approved to Inactive).
     *
     * @param vendorId The ID of the vendor to deactivate.
     * @return true if the vendor was successfully deactivated, false otherwise.
     */
    public boolean deactivateVendor(int vendorId) {
        Vendor vendor = vendorDAO.getVendorById(vendorId);
        if (vendor == null) {
            System.err.println("VendorManager: Vendor with ID " + vendorId + " not found for deactivation.");
            return false;
        }
        if (STATUS_INACTIVE.equalsIgnoreCase(vendor.getStatus()) || STATUS_REJECTED.equalsIgnoreCase(vendor.getStatus())) {
            System.err.println("VendorManager: Vendor " + vendorId + " cannot be deactivated. Current status: " + vendor.getStatus());
            return false;
        }
        return vendorDAO.updateVendorStatus(vendorId, STATUS_INACTIVE);
    }


   

  /**
     * Retrieves all APPROVED vendors from the database for public display.
     *
     * @return A list of approved Vendor objects.
     */
    public List<Vendor> getApprovedVendors(){
        return vendorDAO.getApprovedVendors();
    }
     /**
     * Updates an existing vendor profile with full details.
     *
     * @param vendor The Vendor object with updated information.
     * @return true if the update was successful, false otherwise.
     */
    public boolean updateVendor(Vendor vendor) {
        try {
            return vendorDAO.updateVendor(vendor);
        } catch (SQLException e) {
            System.err.println("Database error while updating vendor profile for vendorId " + vendor.getVendorId() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Adds a new vendor profile to the system. This method handles basic
     * validation and sets the initial status.
     *
     * @param userId The ID of the user associated with this vendor.
     * @param companyName The vendor's company name.
     * @param serviceType The type of service offered.
     * @param contactPerson The name of the primary contact person.
     * @param phone The vendor's phone number.
     * @param email The vendor's email address.
     * @param address The vendor's address.
     * @param description A description of the vendor's services.
     * @param minPrice The minimum price for services.
     * @param maxPrice The maximum price for services.
     * @param portfolioLink A link to the vendor's portfolio.
     * @return true if the vendor was successfully added, false otherwise.
     */
    public boolean addVendorProfile(int userId, String companyName, String serviceType, String contactPerson,
                                String phone, String email, String address, String description,
                                BigDecimal minPrice, BigDecimal maxPrice, String portfolioLink) {
            try {
                // Create a new Vendor object with the provided data
                Vendor vendor = new Vendor();
                vendor.setUserId(userId);
                vendor.setCompanyName(companyName);
                vendor.setServiceType(serviceType);
                vendor.setContactPerson(contactPerson);
                vendor.setPhone(phone);
                vendor.setEmail(email);
                vendor.setAddress(address);
                vendor.setDescription(description);
                vendor.setMinPrice(minPrice);
                vendor.setMaxPrice(maxPrice);
                vendor.setPortfolioLink(portfolioLink);
                vendor.setStatus(STATUS_PENDING_APPROVAL);
                vendor.setRegistrationDate(java.time.LocalDateTime.now());

                // Call the DAO to add the vendor
                return vendorDAO.addVendor(vendor) > 0;

            } catch (Exception e) {
                System.err.println("Error adding vendor profile: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
        }

}
