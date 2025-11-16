package com.ems.dao;

import com.ems.model.Payment;
import com.ems.util.DBConnection;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PaymentDAO {
    private static final Logger LOGGER = Logger.getLogger(PaymentDAO.class.getName());

    // Payment status constants matching your ENUM
    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_COMPLETED = "Completed";
    public static final String STATUS_FAILED = "Failed";
    public static final String STATUS_REFUNDED = "Refunded";

    /**
     * Adds a new payment record to the database.
     * Generates transactionID automatically if not provided.
     * @param payment The Payment object to add.
     * @return The generated paymentID if successful, -1 otherwise.
     */
    public int addPayment(Payment payment) {
        String sql = "INSERT INTO payments (bookingID, amount, vendorShare, adminShare, status, transactionID, paymentMethod, stripePaymentIntentID, stripeCustomerID, stripeClientSecret, paymentType) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int paymentId = -1;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Generate transactionID if null
            if (payment.getTransactionId() == null || payment.getTransactionId().isEmpty()) {
                payment.setTransactionId("TXN_" + System.currentTimeMillis());
            }

            // Set default status if null
            if (payment.getStatus() == null || payment.getStatus().isEmpty()) {
                payment.setStatus(STATUS_PENDING);
            }

            stmt.setInt(1, payment.getBookingId());
            stmt.setBigDecimal(2, payment.getAmount());
            
            // Handle nullable vendorShare and adminShare
            if (payment.getVendorShare() != null) {
                stmt.setBigDecimal(3, payment.getVendorShare());
            } else {
                stmt.setNull(3, java.sql.Types.DECIMAL);
            }
            
            if (payment.getAdminShare() != null) {
                stmt.setBigDecimal(4, payment.getAdminShare());
            } else {
                stmt.setNull(4, java.sql.Types.DECIMAL);
            }
            
            stmt.setString(5, payment.getStatus());
            stmt.setString(6, payment.getTransactionId());
            stmt.setString(7, payment.getPaymentMethod());
            stmt.setString(8, payment.getStripePaymentIntentId());
            stmt.setString(9, payment.getStripeCustomerId());
            stmt.setString(10, payment.getStripeClientSecret());
            stmt.setString(11, payment.getPaymentType());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        paymentId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding payment", e);
        }
        return paymentId;
    }

    /**
     * Retrieves a payment by its ID.
     */
    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT * FROM payments WHERE paymentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, paymentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payment by ID: " + paymentId, e);
        }
        return null;
    }

    /**
     * Updates an existing payment record.
     */
    public boolean updatePayment(Payment payment) {
        String sql = "UPDATE payments SET bookingID = ?, amount = ?, vendorShare = ?, adminShare = ?, status = ?, transactionID = ?, paymentMethod = ?, stripePaymentIntentID = ?, stripeCustomerID = ?, stripeClientSecret = ?, paymentType = ? WHERE paymentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, payment.getBookingId());
            stmt.setBigDecimal(2, payment.getAmount());
            
            // Handle nullable vendorShare and adminShare
            if (payment.getVendorShare() != null) {
                stmt.setBigDecimal(3, payment.getVendorShare());
            } else {
                stmt.setNull(3, java.sql.Types.DECIMAL);
            }
            
            if (payment.getAdminShare() != null) {
                stmt.setBigDecimal(4, payment.getAdminShare());
            } else {
                stmt.setNull(4, java.sql.Types.DECIMAL);
            }
            
            stmt.setString(5, payment.getStatus());
            stmt.setString(6, payment.getTransactionId());
            stmt.setString(7, payment.getPaymentMethod());
            stmt.setString(8, payment.getStripePaymentIntentId());
            stmt.setString(9, payment.getStripeCustomerId());
            stmt.setString(10, payment.getStripeClientSecret());
            stmt.setString(11, payment.getPaymentType());
            stmt.setInt(12, payment.getPaymentId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment: " + payment.getPaymentId(), e);
            return false;
        }
    }

    /**
     * Updates the status of a specific payment.
     * @param paymentId The ID of the payment to update.
     * @param newStatus The new status to set (must be valid ENUM value).
     * @return true if the status was updated successfully, false otherwise.
     */
    public boolean updatePaymentStatus(int paymentId, String newStatus) {
        String sql = "UPDATE payments SET status = ? WHERE paymentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus);
            stmt.setInt(2, paymentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status: " + paymentId, e);
            return false;
        }
    }

    /**
     * Deletes a payment by ID.
     */
    public boolean deletePayment(int paymentId) {
        String sql = "DELETE FROM payments WHERE paymentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, paymentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting payment: " + paymentId, e);
            return false;
        }
    }

    /**
     * Get all payments for a booking
     */
    public List<Payment> getPaymentsByBookingId(int bookingId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE bookingID = ? ORDER BY paymentDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payments by booking ID: " + bookingId, e);
        }
        return payments;
    }

    /**
     * Retrieves all payments associated with a client's events/bookings.
     * @param clientId The ID of the client (user).
     * @return A list of Payment objects for that client.
     */
    public List<Payment> getPaymentsByClientId(int clientId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, e.type AS eventName, u.name AS clientName FROM payments p " +
                     "JOIN bookings b ON p.bookingID = b.bookingID " +
                     "JOIN events e ON b.eventID = e.eventID " +
                     "JOIN users u ON e.clientID = u.userID " +
                     "WHERE e.clientID = ? ORDER BY p.paymentDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clientId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payment payment = mapResultSetToPayment(rs);
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payments by client ID: " + clientId, e);
        }
        return payments;
    }

    /**
     * Retrieves all payments for bookings assigned to a specific vendor.
     * @param vendorId The ID of the vendor.
     * @return List of Payment objects.
     */
    public List<Payment> getPaymentsByVendorId(int vendorId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, e.type AS eventName, u.name AS clientName, b.vendorID FROM payments p " +
                     "JOIN bookings b ON p.bookingID = b.bookingID " +
                     "JOIN events e ON b.eventID = e.eventID " +
                     "JOIN users u ON e.clientID = u.userID " +
                     "WHERE b.vendorID = ? ORDER BY p.paymentDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vendorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payment payment = mapResultSetToPayment(rs);
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payments by vendor ID: " + vendorId, e);
        }
        return payments;
    }
    /**
     * Get recent payments for vendor
     */
    public List<Payment> getRecentPaymentsByVendorId(int vendorId, int days) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.* FROM payments p " +
                     "JOIN bookings b ON p.bookingID = b.bookingID " +
                     "WHERE b.vendorID = ? AND p.paymentDate >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                     "ORDER BY p.paymentDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, vendorId);
            stmt.setInt(2, days);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(extractPaymentFromResultSet(rs));
                }
            }
        }
        return payments;
    }

    /**
     * Get total payment amount for vendor in date range
     */
    public BigDecimal getVendorPaymentTotal(int vendorId, LocalDateTime startDate, LocalDateTime endDate) throws SQLException {
        String sql = "SELECT SUM(p.amount) as total FROM payments p " +
                     "JOIN bookings b ON p.bookingID = b.bookingID " +
                     "WHERE b.vendorID = ? AND p.paymentDate BETWEEN ? AND ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, vendorId);
            stmt.setTimestamp(2, Timestamp.valueOf(startDate));
            stmt.setTimestamp(3, Timestamp.valueOf(endDate));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal("total");
                    return total != null ? total : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }
/**
     * Get payments by status for vendor
     */
    public List<Payment> getVendorPaymentsByStatus(int vendorId, String status) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.* FROM payments p " +
                     "JOIN bookings b ON p.bookingID = b.bookingID " +
                     "WHERE b.vendorID = ? AND p.status = ? " +
                     "ORDER BY p.paymentDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, vendorId);
            stmt.setString(2, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(extractPaymentFromResultSet(rs));
                }
            }
        }
        return payments;
    }
     /**
     * Helper method to extract Payment from ResultSet
     */
    private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("paymentID"));
        payment.setBookingId(rs.getInt("bookingID"));
        payment.setAmount(rs.getBigDecimal("amount"));
        
        Timestamp paymentDate = rs.getTimestamp("paymentDate");
        if (paymentDate != null) {
            payment.setPaymentDate(paymentDate.toLocalDateTime());
        }
        
        payment.setStatus(rs.getString("status"));
        payment.setTransactionId(rs.getString("transactionId"));
        payment.setPaymentMethod(rs.getString("paymentMethod"));
        payment.setPaymentType(rs.getString("paymentType"));
        return payment;
    }
    /**
     * Retrieves all payments.
     */
    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY paymentDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all payments", e);
        }
        return payments;
    }

    /**
     * Updates payment status for all payments associated with a specific booking ID.
     * @param bookingId The ID of the booking whose payments status should be updated.
     * @param status The new status to set.
     * @return true if one or more rows were updated successfully, false otherwise.
     */
    public boolean updatePaymentStatusByBookingId(int bookingId, String status) {
        String sql = "UPDATE payments SET status = ? WHERE bookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status for booking ID: " + bookingId, e);
            return false;
        }
    }

    /**
     * Retrieves payments based on time and status filters.
     */
    public List<Payment> getFilteredPayments(java.sql.Date filterDate, String statusFilter) {
        List<Payment> payments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM payments WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (filterDate != null) {
            sql.append(" AND paymentDate >= ?");
            params.add(filterDate);
        }

        if (statusFilter != null && !"all_statuses".equalsIgnoreCase(statusFilter)) {
            sql.append(" AND status = ?");
            params.add(statusFilter);
        }

        sql.append(" ORDER BY paymentDate DESC");

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
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting filtered payments", e);
        }

        return payments;
    }

   /**
 * Add payment with Stripe details including client secret
 */
public int addStripePayment(Payment payment) {
    String sql = "INSERT INTO payments (bookingID, amount, vendorShare, adminShare, status, transactionID, " +
                 "paymentMethod, stripePaymentIntentID, stripeCustomerID, stripeClientSecret, paymentType) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    int paymentId = -1;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        // ENSURE STATUS IS NEVER NULL
        String status = payment.getStatus();
        if (status == null || status.trim().isEmpty()) {
            status = STATUS_PENDING;
            payment.setStatus(status);
        }
        
        stmt.setInt(1, payment.getBookingId());
        stmt.setBigDecimal(2, payment.getAmount());
        
        if (payment.getVendorShare() != null) {
            stmt.setBigDecimal(3, payment.getVendorShare());
        } else {
            stmt.setNull(3, java.sql.Types.DECIMAL);
        }
        
        if (payment.getAdminShare() != null) {
            stmt.setBigDecimal(4, payment.getAdminShare());
        } else {
            stmt.setNull(4, java.sql.Types.DECIMAL);
        }
        
        stmt.setString(5, status); // Use the ensured status
        stmt.setString(6, payment.getTransactionId());
        stmt.setString(7, payment.getPaymentMethod());
        stmt.setString(8, payment.getStripePaymentIntentId());
        stmt.setString(9, payment.getStripeCustomerId());
        stmt.setString(10, payment.getStripeClientSecret());
        stmt.setString(11, payment.getPaymentType());
        
        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    paymentId = rs.getInt(1);
                }
            }
        }
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error adding Stripe payment", e);
    }
    return paymentId;
}
    /**
     * Retrieves payment by Stripe PaymentIntentID.
     */
    public Payment getPaymentByStripeIntentId(String stripePaymentIntentId) {
        String sql = "SELECT * FROM payments WHERE stripePaymentIntentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, stripePaymentIntentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payment by Stripe intent ID: " + stripePaymentIntentId, e);
        }
        return null;
    }

    /**
     * Updates payment status by Stripe PaymentIntentID.
     */
    public boolean updatePaymentStatusByStripeIntentId(String stripePaymentIntentId, String status) {
        String sql = "UPDATE payments SET status = ? WHERE stripePaymentIntentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setString(2, stripePaymentIntentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status by Stripe intent ID: " + stripePaymentIntentId, e);
            return false;
        }
    }

    /**
     * Creates a minimal payment record using raw data from a webhook event.
     */
    public boolean addPaymentRecord(int bookingId, BigDecimal amount, String status, String stripePaymentIntentId) {
        String sql = "INSERT INTO payments (bookingID, amount, status, stripePaymentIntentID, paymentType) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId); 
            stmt.setBigDecimal(2, amount);
            stmt.setString(3, status != null ? status : STATUS_PENDING);
            stmt.setString(4, stripePaymentIntentId);
            stmt.setString(5, "STRIPE");

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding payment record from webhook data: " + stripePaymentIntentId, e);
            return false;
        }
    }

    /**
     * Updates the status and final amount based on the Stripe Payment Intent ID.
     */
    public boolean updatePaymentStatusWithAmount(String stripePaymentIntentId, String reference, String newStatus, BigDecimal amount) {
        String sql = "UPDATE payments SET status = ?, amount = ? WHERE stripePaymentIntentID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus);
            stmt.setBigDecimal(2, amount);
            stmt.setString(3, stripePaymentIntentId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status and amount via webhook for intent: " + stripePaymentIntentId, e);
            return false;
        }
    }

    /**
     * Updates payment status using a String identifier (like Intent ID)
     */
    public boolean updatePaymentStatus(String keyId, String oldStatusRef, String newStatus) {
        return updatePaymentStatusByStripeIntentId(keyId, newStatus);
    }

    /**
     * Helper method to map ResultSet to Payment object.
     */
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("paymentID"));
        payment.setBookingId(rs.getInt("bookingID"));
        payment.setAmount(rs.getBigDecimal("amount"));
        
        // Handle nullable decimal fields
        BigDecimal vendorShare = rs.getBigDecimal("vendorShare");
        if (!rs.wasNull()) {
            payment.setVendorShare(vendorShare);
        }
        
        BigDecimal adminShare = rs.getBigDecimal("adminShare");
        if (!rs.wasNull()) {
            payment.setAdminShare(adminShare);
        }

        // paymentDate is automatically set by database as timestamp
        Timestamp ts = rs.getTimestamp("paymentDate");
        if (ts != null) {
            payment.setPaymentDate(ts.toLocalDateTime());
        }

        payment.setStatus(rs.getString("status"));
        payment.setTransactionId(rs.getString("transactionID"));
        payment.setPaymentMethod(rs.getString("paymentMethod"));
        payment.setStripePaymentIntentId(rs.getString("stripePaymentIntentID"));
        payment.setStripeCustomerId(rs.getString("stripeCustomerID"));
        payment.setStripeClientSecret(rs.getString("stripeClientSecret"));
        payment.setPaymentType(rs.getString("paymentType"));

        return payment;
    }

    /**
     * Validates if a payment status is valid according to the ENUM
     */
    public boolean isValidStatus(String status) {
        return STATUS_PENDING.equals(status) || 
               STATUS_COMPLETED.equals(status) || 
               STATUS_FAILED.equals(status) || 
               STATUS_REFUNDED.equals(status);
    }
    /**
 * Calculate vendor and admin shares based on commission rate.
 * @param payment The payment object to calculate shares for
 * @param commissionRate The commission rate as a percentage (e.g., 10.0 for 10%)
 */
public void calculateShares(Payment payment, BigDecimal commissionRate) {
    if (payment == null || payment.getAmount() == null || commissionRate == null) {
        LOGGER.warning("Invalid parameters for calculateShares");
        return;
    }

    try {
        BigDecimal amount = payment.getAmount();
        
        // Ensure commissionRate is represented as a percentage (e.g., 10 for 10%)
        // Divide by 100 to get the decimal rate (e.g., 0.10)
        BigDecimal rateDecimal = commissionRate.divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
        
        // Calculate commission amount
        BigDecimal commission = amount.multiply(rateDecimal);
        
        // Set scale and rounding for currency (2 decimal places)
        commission = commission.setScale(2, RoundingMode.HALF_UP);
        
        // Calculate vendor share (total amount minus commission)
        BigDecimal vendorShare = amount.subtract(commission).setScale(2, RoundingMode.HALF_UP);
        
        // Set the shares on the payment object
        payment.setVendorShare(vendorShare);
        payment.setAdminShare(commission);
        
        LOGGER.info(String.format(
            "Shares calculated - Amount: %s, Commission Rate: %s%%, Vendor Share: %s, Admin Share: %s",
            amount, commissionRate, vendorShare, commission
        ));
        
    } catch (Exception e) {
        LOGGER.severe("Error calculating shares: " + e.getMessage());
        // Fallback: if calculation fails, set equal shares or handle appropriately
        BigDecimal amount = payment.getAmount();
        payment.setVendorShare(amount);
        payment.setAdminShare(BigDecimal.ZERO);
    }
}
/**
 * Updates the Stripe Payment Intent ID for a payment record
 * @param paymentId The ID of the payment to update
 * @param paymentIntentId The Stripe Payment Intent ID to set
 * @return true if updated successfully, false otherwise
 */
public boolean updatePaymentIntentId(int paymentId, String paymentIntentId) {
    String sql = "UPDATE payments SET stripePaymentIntentID = ? WHERE paymentID = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, paymentIntentId);
        stmt.setInt(2, paymentId);
        
        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error updating payment intent ID for payment: " + paymentId, e);
        return false;
    }
}
/**
 * Updates both Stripe Payment Intent ID and client secret for a payment record
 * @param paymentId The ID of the payment to update
 * @param paymentIntentId The Stripe Payment Intent ID to set
 * @param clientSecret The Stripe client secret to set
 * @return true if updated successfully, false otherwise
 */
public boolean updateStripePaymentDetails(int paymentId, String paymentIntentId, String clientSecret) {
    String sql = "UPDATE payments SET stripePaymentIntentID = ?, stripeClientSecret = ? WHERE paymentID = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setString(1, paymentIntentId);
        stmt.setString(2, clientSecret);
        stmt.setInt(3, paymentId);
        
        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        LOGGER.log(Level.SEVERE, "Error updating Stripe payment details for payment: " + paymentId, e);
        return false;
    }
}
}
