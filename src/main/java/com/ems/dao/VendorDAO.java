// src/main/java/com/ems/dao/VendorDAO.java
package com.ems.dao;

import com.ems.model.Vendor;
import com.ems.model.VendorPerformance;
import static com.ems.service.VendorManager.STATUS_APPROVED;
import com.ems.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.stream.Collectors;

public class VendorDAO {

    /**
     * Creates a new vendor in the database.
     *
     * @param vendor The Vendor object to add.
     * @return The generated vendorId if successful, -1 otherwise.
     */
    public int addVendor(Vendor vendor) {
        String sql = "INSERT INTO vendors (userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status, registrationDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int vendorId = -1;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, vendor.getUserId());
            stmt.setString(2, vendor.getCompanyName());
            stmt.setString(3, vendor.getServiceType());
            stmt.setString(4, vendor.getContactPerson());
            stmt.setString(5, vendor.getPhone());
            stmt.setString(6, vendor.getEmail());
            stmt.setString(7, vendor.getAddress());
            stmt.setString(8, vendor.getDescription());
            stmt.setBigDecimal(9, vendor.getMinPrice());
            stmt.setBigDecimal(10, vendor.getMaxPrice());
            stmt.setString(11, vendor.getPortfolioLink());
            stmt.setString(12, vendor.getStatus());
            stmt.setObject(13, vendor.getRegistrationDate());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        vendorId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding vendorDAO.CompanyName(): " + e.getMessage());
            e.printStackTrace();
        }
        return vendorId;
    }

    /**
     * Retrieves a vendor by their unique ID.
     *
     * @param vendorId The ID of the vendor to retrieve.
     * @return The Vendor object if found, null otherwise.
     */
    public Vendor getVendorById(int vendorId) {
        String sql = "SELECT vendorId, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status, registrationDate FROM Vendors WHERE vendorId = ?";
        Vendor vendor = null;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vendorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    vendor = mapResultSetToVendor(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting vendorDAO.vendorId(): " + e.getMessage());
            e.printStackTrace();
        }
        return vendor;
    }

    /**
     * Retrieves a list of all vendors from the database.
     *
     * @return A list of Vendor objects.
     */
    public List<Vendor> getAllVendors() {
        List<Vendor> vendors = new ArrayList<>();
        String sql = "SELECT vendorId, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status, registrationDate FROM vendors";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                vendors.add(mapResultSetToVendor(rs));
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in VendorDAO.getAllVendors(): " + e.getMessage());
            e.printStackTrace();
        }
        return vendors;
    }

    /**
     * Retrieves a vendor by their associated User ID.
     *
     * @param userId The ID of the user.
     * @return The Vendor object if found, or null otherwise.
     * @throws java.sql.SQLException
     */
    public Vendor getVendorByUserId(int userId) throws SQLException {
        String sql = "SELECT vendorId, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status, registrationDate FROM Vendors WHERE userId = ?";
        Vendor vendor = null;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    vendor = mapResultSetToVendor(rs);
                }
            }
        }
        return vendor;
    }

    /**
     * Updates an existing vendor record in the database.
     *
     * @param vendor The Vendor object with updated information.
     * @return true if the vendor was updated successfully, false otherwise.
     */
    public boolean updateVendor(Vendor vendor) throws SQLException {
        String sql = "UPDATE Vendors SET companyName = ?, serviceType = ?, contactPerson = ?, phone = ?, email = ?, address = ?, description = ?, minPrice = ?, maxPrice = ?, portfolioLink = ?, status = ? WHERE vendorId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, vendor.getCompanyName());
            pstmt.setString(2, vendor.getServiceType());
            pstmt.setString(3, vendor.getContactPerson());
            pstmt.setString(4, vendor.getPhone());
            pstmt.setString(5, vendor.getEmail());
            pstmt.setString(6, vendor.getAddress());
            pstmt.setString(7, vendor.getDescription());
            pstmt.setBigDecimal(8, vendor.getMinPrice());
            pstmt.setBigDecimal(9, vendor.getMaxPrice());
            pstmt.setString(10, vendor.getPortfolioLink());
            pstmt.setString(11, vendor.getStatus());
            pstmt.setInt(12, vendor.getVendorId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating vendorDAO.getVendorId(): " + e.getMessage());
            e.printStackTrace();
            throw e; // Re-throw the exception after logging
        }
    }

    /**
     * Deletes a vendor record from the database.
     *
     * @param vendorId The ID of the vendor to delete.
     * @return true if the vendor was deleted successfully, false otherwise.
     */
    public boolean deleteVendor(int vendorId) {
        String sql = "DELETE FROM Vendors WHERE vendorId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, vendorId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting vendorDAO.VendorId(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates the status of a specific vendor in the database.
     *
     * @param vendorId The ID of the vendor whose status is to be updated.
     * @param newStatus The new status to set.
     * @return true if the status was updated successfully, false otherwise.
     */
    public boolean updateVendorStatus(int vendorId, String newStatus) {
        String sql = "UPDATE Vendors SET status = ? WHERE vendorId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, vendorId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating vendor status vendorDAO.VendorId(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves all approved vendors from the database.
     *
     * @return A list of all approved Vendor objects.
     */
    public List<Vendor> getApprovedVendors() {
        List<Vendor> approvedVendors = new ArrayList<>();
        String sql = "SELECT vendorId, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status, registrationDate FROM Vendors WHERE status = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, STATUS_APPROVED);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    approvedVendors.add(mapResultSetToVendor(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting approved vendor: " + e.getMessage());
            e.printStackTrace();
        }
        return approvedVendors;
    }

    /**
     * Retrieves a list of vendors based on a specific list of Vendor IDs.
     */
    public List<Vendor> getVendorsByIds(List<String> vendorIds) {
        if (vendorIds == null || vendorIds.isEmpty()) {
            return Collections.emptyList();
        }

        List<Vendor> vendors = new ArrayList<>();
        String placeholders = vendorIds.stream().map(id -> "?").collect(Collectors.joining(", "));
        String sql = "SELECT vendorId, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status, registrationDate FROM Vendors WHERE vendorId IN (" + placeholders + ")";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < vendorIds.size(); i++) {
                stmt.setInt(i + 1, Integer.parseInt(vendorIds.get(i))); // Fixed: parse to int
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    vendors.add(mapResultSetToVendor(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting vendors by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return vendors;
    }

    /**
     * Creates a new, minimal vendor profile linked to a user.
     *
     * @param userId The ID of the user to link the profile to.
     * @return true if the profile was added successfully, false otherwise.
     */
    public boolean addVendorProfile(int userId) throws SQLException {
        String sql = "INSERT INTO Vendors (userId) VALUES (?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Retrieves a list of all vendors with a specific status.
     *
     * @param status The status to filter by.
     * @return A list of Vendor objects matching the status.
     */
    public List<Vendor> getVendorsByStatus(String status) throws SQLException {
        List<Vendor> vendors = new ArrayList<>();
        String sql = "SELECT vendorId, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status, registrationDate FROM Vendors WHERE status = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    vendors.add(mapResultSetToVendor(rs)); // Use the helper method
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting vendors by status: " + status + " - " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return vendors;
    }

    /**
     * Helper method to map a ResultSet row to a Vendor object.
     */
    private Vendor mapResultSetToVendor(ResultSet rs) throws SQLException {
        Vendor vendor = new Vendor();
        vendor.setVendorId(rs.getInt("vendorId"));
        vendor.setUserId(rs.getInt("userId"));
        vendor.setCompanyName(rs.getString("companyName"));
        vendor.setServiceType(rs.getString("serviceType"));
        vendor.setContactPerson(rs.getString("contactPerson"));
        vendor.setPhone(rs.getString("phone"));
        vendor.setEmail(rs.getString("email"));
        vendor.setAddress(rs.getString("address"));
        vendor.setDescription(rs.getString("description"));
        
        // Handle potential null values for prices
        BigDecimal minPrice = rs.getBigDecimal("minPrice");
        BigDecimal maxPrice = rs.getBigDecimal("maxPrice");
        vendor.setMinPrice(rs.wasNull() ? BigDecimal.ZERO : minPrice);
        vendor.setMaxPrice(rs.wasNull() ? BigDecimal.ZERO : maxPrice);
        
        vendor.setPortfolioLink(rs.getString("portfolioLink"));
        vendor.setStatus(rs.getString("status"));
        
        // Handle registration date
        java.sql.Timestamp regDate = rs.getTimestamp("registrationDate");
        vendor.setRegistrationDate(regDate != null ? regDate.toLocalDateTime() : LocalDateTime.now());
        
        return vendor;
    }

    /**
     * Retrieves vendors based on time and status filters.
     */
    public List<Vendor> getFilteredVendors(java.util.Date filterDate, String statusFilter) throws SQLException {
        List<Vendor> vendors = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT vendorId, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status, registrationDate " +
            "FROM Vendors WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();

        if (filterDate != null) {
            sql.append(" AND registrationDate >= ?");
            params.add(new java.sql.Date(filterDate.getTime()));
        }

        if (statusFilter != null && !"all_statuses".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND status = ?");
            params.add(statusFilter);
        }
        
        sql.append(" ORDER BY registrationDate DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof java.sql.Date) {
                    stmt.setDate(i + 1, (java.sql.Date) param);
                } else if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    vendors.add(mapResultSetToVendor(rs)); // FIXED: Added this line to populate the list
                }
            }
        }
        return vendors;
    }

    /**
     * Retrieves vendor performance data.
     */
    public List<VendorPerformance> getVendorPerformance(Date filterDate) throws SQLException {
        List<VendorPerformance> performanceList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT v.vendorId, v.companyName, COUNT(DISTINCT e.eventId) AS totalEvents, COALESCE(SUM(p.amount), 0) AS totalRevenue " +
            "FROM vendors v " +
            "LEFT JOIN events e ON v.vendorId = e.sellectedVendorId " + // FIXED: Use vendorId instead of userId
            "LEFT JOIN bookings b ON e.eventId = b.eventId " + // ADDED: Join through bookings
            "LEFT JOIN payments p ON b.bookingId = p.bookingId " + // FIXED: Join payments to bookings
            "WHERE (e.status = 'Completed' OR e.status IS NULL)" // FIXED: Handle NULL cases
        );

        if (filterDate != null) {
            sql.append(" AND e.date >= ?");
        }

        sql.append(" GROUP BY v.vendorId, v.companyName " + // FIXED: Group by vendorId
                  "ORDER BY totalRevenue DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            if (filterDate != null) {
                stmt.setDate(1, new java.sql.Date(filterDate.getTime()));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    VendorPerformance vp = new VendorPerformance();
                    vp.setVendorId(rs.getInt("vendorId")); // FIXED: Use vendorId
                    vp.setVendorName(rs.getString("companyName"));
                    vp.setTotalEvents(rs.getLong("totalEvents"));
                    vp.setTotalRevenue(rs.getDouble("totalRevenue"));
                    vp.setAverageRating(0.0); // You might want to calculate this from reviews

                    performanceList.add(vp);
                }
            }
        }
        return performanceList;
    }

    /**
     * Gets vendor company name by vendor ID.
     */
    public String getVendorCompanyName(int vendorId) throws SQLException {
        String sql = "SELECT companyName FROM vendors WHERE vendorId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vendorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("companyName");
                }
            }
        }
        return "Unknown Vendor";
    }
}