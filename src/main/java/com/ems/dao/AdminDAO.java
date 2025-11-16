// src/main/java/com/ems/dao/AdminDAO.java
package com.ems.dao;

import com.ems.model.Admin;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    /**
     * Inserts a new admin profile into the Admins table.
     * @param admin The Admin object to insert.
     * @return true if the admin was inserted successfully, false otherwise.
     */
    public boolean addAdmin(Admin admin) {
        String sql = "INSERT INTO Admins (userID, adminLevel) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, admin.getUserId());
            pstmt.setString(2, admin.getAdminLevel());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves an admin by their User ID.
     * @param userId The User ID associated with the admin.
     * @return The Admin object if found, null otherwise.
     */
    public Admin getAdminByUserId(int userId) {
        String sql = "SELECT adminID, userID, adminLevel, lastLogin FROM Admins WHERE userID = ?";
        Admin admin = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setAdminId(rs.getInt("adminID"));
                    admin.setUserId(rs.getInt("userID"));
                    admin.setAdminLevel(rs.getString("adminLevel"));
                    admin.setLastLogin(rs.getTimestamp("lastLogin"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }

    /**
     * Retrieves all admins from the database.
     * @return A list of all Admin objects.
     */
    public List<Admin> getAllAdmins() {
        List<Admin> admins = new ArrayList<>();
        String sql = "SELECT adminID, userID, adminLevel, lastLogin FROM Admins";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("adminID"));
                admin.setUserId(rs.getInt("userID"));
                admin.setAdminLevel(rs.getString("adminLevel"));
                admin.setLastLogin(rs.getTimestamp("lastLogin"));
                admins.add(admin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admins;
    }

    // You can add update and delete methods for Admin here
    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE Admins SET adminLevel = ? WHERE adminID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, admin.getAdminLevel());
            pstmt.setInt(2, admin.getAdminId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAdmin(int adminId) {
        String sql = "DELETE FROM Admins WHERE adminID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, adminId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

