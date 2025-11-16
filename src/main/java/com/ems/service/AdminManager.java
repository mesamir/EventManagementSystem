// src/main/java/com/ems/service/AdminManager.java
package com.ems.service;

import com.ems.dao.AdminDAO;
import com.ems.model.Admin;
import java.util.List;

public class AdminManager {
    private AdminDAO adminDAO;

    public AdminManager() {
        this.adminDAO = new AdminDAO();
    }

    /**
     * Adds a new admin profile. This is typically called after a user registers with an 'admin' role.
     * @param userId The User ID associated with this admin profile.
     * @param adminLevel The admin's level (e.g., "Standard", "Super Admin").
     * @return true if the admin profile was added successfully, false otherwise.
     */
    public boolean addAdminProfile(int userId, String adminLevel) {
        // Basic validation
        if (userId <= 0 || adminLevel == null || adminLevel.trim().isEmpty()) {
            System.err.println("AdminManager: Invalid data for adding admin profile.");
            return false;
        }
        Admin newAdmin = new Admin(userId, adminLevel);
        return adminDAO.addAdmin(newAdmin);
    }

    /**
     * Retrieves an admin's profile by their associated User ID.
     * @param userId The User ID of the logged-in admin.
     * @return The Admin object if found, null otherwise.
     */
    public Admin getAdminByUserId(int userId) {
        return adminDAO.getAdminByUserId(userId);
    }

    /**
     * Retrieves all admins.
     * @return A list of all Admin objects.
     */
    public List<Admin> getAllAdmins() {
        return adminDAO.getAllAdmins();
    }

    // You can add update and delete methods for Admin here
    public boolean updateAdminProfile(Admin admin) {
        if (admin == null || admin.getAdminId() <= 0) {
            System.err.println("AdminManager: Invalid admin data for update.");
            return false;
        }
        return adminDAO.updateAdmin(admin);
    }

    public boolean deleteAdminProfile(int adminId) {
        if (adminId <= 0) {
            System.err.println("AdminManager: Invalid admin ID for delete.");
            return false;
        }
        return adminDAO.deleteAdmin(adminId);
    }
}

