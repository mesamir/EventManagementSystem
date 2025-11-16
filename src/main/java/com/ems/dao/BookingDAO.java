package com.ems.dao;

import com.ems.model.Booking;
import com.ems.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class BookingDAO {
    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());

    /**
     * Creates a new booking in the database.
     * Updated: Removed vendor assignment dependency
     * @param booking The Booking object to add.
     * @return The generated bookingID if successful, -1 otherwise.
     */
    public int createBooking(Booking booking) throws SQLException {
        System.out.println("=== BOOKINGDAO: Creating Booking ===");
        System.out.println("Event ID: " + booking.getEventId() + ", User ID: " + booking.getUserId());
        
        // Updated SQL - vendorID is now optional
        String sql = "INSERT INTO bookings (eventID, userID, vendorID, serviceBooked, bookingDate, amount, status, notes, advanceRequiredPercentage, advanceAmountDue, amountPaid) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, booking.getEventId());                    // eventID
            pstmt.setInt(2, booking.getUserId());                     // userID
            
            // Vendor ID is now optional - handle null case
            if (booking.getVendorId() != null && booking.getVendorId() > 0) {
                pstmt.setInt(3, booking.getVendorId());               // vendorID
            } else {
                pstmt.setNull(3, java.sql.Types.INTEGER);             // vendorID can be null
            }
            
            pstmt.setString(4, booking.getServiceBooked());           // serviceBooked
            pstmt.setDate(5, java.sql.Date.valueOf(booking.getBookingDate().toLocalDate())); // bookingDate
            pstmt.setBigDecimal(6, booking.getAmount());              // amount
            pstmt.setString(7, booking.getStatus() != null ? booking.getStatus() : "Pending"); // status
            pstmt.setString(8, booking.getNotes() != null ? booking.getNotes() : ""); // notes
            pstmt.setBigDecimal(9, booking.getAdvanceRequiredPercentage() != null ? booking.getAdvanceRequiredPercentage() : new BigDecimal("30")); // advanceRequiredPercentage
            pstmt.setBigDecimal(10, booking.getAdvanceAmountDue() != null ? booking.getAdvanceAmountDue() : BigDecimal.ZERO); // advanceAmountDue
            pstmt.setBigDecimal(11, booking.getAmountPaid() != null ? booking.getAmountPaid() : BigDecimal.ZERO); // amountPaid
            
            System.out.println("Executing insert for Event ID: " + booking.getEventId());
            
            int affectedRows = pstmt.executeUpdate();
            System.out.println("Affected rows: " + affectedRows);
            
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int bookingId = rs.getInt(1);
                        System.out.println("✅ SUCCESS: Booking created with ID: " + bookingId);
                        return bookingId;
                    } else {
                        System.out.println("⚠️ No generated keys returned");
                        return -1;
                    }
                }
            } else {
                System.out.println("❌ No rows affected");
                return -1;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ SQL Error: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
            throw e;
        }
    }

    /**
     * Creates a booking without vendor assignment (for new workflow)
     * @param eventId The event ID
     * @param userId The user ID
     * @param serviceBooked The service type
     * @param amount The total amount
     * @return The generated booking ID if successful, -1 otherwise
     */
    public int createBookingWithoutVendor(int eventId, int userId, String serviceBooked, BigDecimal amount) throws SQLException {
        System.out.println("=== BOOKINGDAO: Creating Booking Without Vendor ===");
        
        String sql = "INSERT INTO bookings (eventID, userID, serviceBooked, bookingDate, amount, status, advanceRequiredPercentage, advanceAmountDue, amountPaid) " +
                     "VALUES (?, ?, ?, ?, ?, 'Pending', ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, eventId);
            pstmt.setInt(2, userId);
            pstmt.setString(3, serviceBooked);
            pstmt.setDate(4, java.sql.Date.valueOf(LocalDateTime.now().toLocalDate()));
            pstmt.setBigDecimal(5, amount);
            
            // Calculate advance amounts
            BigDecimal advancePercentage = new BigDecimal("30");
            BigDecimal advanceAmountDue = amount.multiply(advancePercentage).divide(new BigDecimal("100"));
            
            pstmt.setBigDecimal(6, advancePercentage);
            pstmt.setBigDecimal(7, advanceAmountDue);
            pstmt.setBigDecimal(8, BigDecimal.ZERO); // Initial amount paid
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int bookingId = rs.getInt(1);
                        System.out.println("✅ SUCCESS: Booking created without vendor, ID: " + bookingId);
                        return bookingId;
                    }
                }
            }
            return -1;
            
        } catch (SQLException e) {
            System.out.println("❌ SQL Error creating booking without vendor: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Assigns a vendor to an existing booking (separate process)
     * @param bookingId The booking ID
     * @param vendorId The vendor ID to assign
     * @return true if successful, false otherwise
     */
    public boolean assignVendorToBooking(int bookingId, int vendorId) {
        System.out.println("=== BOOKINGDAO: Assigning Vendor to Booking ===");
        
        String sql = "UPDATE bookings SET vendorID = ?, status = 'Vendor Assigned' WHERE bookingID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vendorId);
            stmt.setInt(2, bookingId);

            int rowsAffected = stmt.executeUpdate();
            System.out.println("Vendor assignment affected rows: " + rowsAffected);
            
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error assigning vendor to booking: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Removes vendor assignment from a booking
     * @param bookingId The booking ID
     * @return true if successful, false otherwise
     */
    public boolean removeVendorAssignment(int bookingId) {
        String sql = "UPDATE bookings SET vendorID = NULL, status = 'Pending' WHERE bookingID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error removing vendor assignment: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves a booking by its ID.
     * @param bookingId
     * @param bookingId The ID of the booking to retrieve.
     * @return The Booking object if found, null otherwise.
     */
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM bookings WHERE bookingID = ?";
        Booking booking = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    booking = extractBookingFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return booking;
    }

    /**
     * Retrieves a Booking object using its associated Event ID.
     * @param eventId The ID of the event linked to the booking.
     * @return The Booking object if found, or null otherwise.
     */
    public Booking getBookingByEventId(int eventId) throws SQLException {
        String sql = "SELECT * FROM bookings WHERE eventID = ?";
        Booking booking = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, eventId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    booking = extractBookingFromResultSet(rs);
                }
            }
        }
        return booking;
    }

    /**
     * Updates advance payment details and status for a booking.
     * @param bookingId The ID of the booking to update.
     * @param advancePercentage The percentage of the total amount required as advance.
     * @param advanceAmountDue The calculated advance amount due.
     * @param status The new status of the booking.
     * @return true if successful, false otherwise.
     */
    public boolean updateBookingAdvanceDetails(int bookingId, BigDecimal advancePercentage, BigDecimal advanceAmountDue, String status) {
        String sql = "UPDATE bookings SET advanceRequiredPercentage = ?, advanceAmountDue = ?, status = ? WHERE bookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, advancePercentage);
            stmt.setBigDecimal(2, advanceAmountDue);
            stmt.setString(3, status);
            stmt.setInt(4, bookingId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating booking advance details: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates the amount paid for a booking and potentially its status.
     * @param bookingId The ID of the booking.
     * @param amountPaid The new cumulative amount paid.
     * @param newStatus The new status (e.g., 'Advance Paid', 'Confirmed').
     * @return true if updated successfully, false otherwise.
     */
    public boolean updateBookingAmountPaidAndStatus(int bookingId, BigDecimal amountPaid, String newStatus) {
        String sql = "UPDATE bookings SET amountPaid = ?, status = ? WHERE bookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, amountPaid);
            stmt.setString(2, newStatus);
            stmt.setInt(3, bookingId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating booking amount paid and status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates the status of a specific booking.
     * @param bookingId The ID of the booking to update.
     * @param newStatus The new status to set.
     * @return true if successful, false otherwise.
     */
    public boolean updateBookingStatus(int bookingId, String newStatus) {
        String sql = "UPDATE bookings SET status = ? WHERE bookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus);
            stmt.setInt(2, bookingId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating booking status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing booking's details in the database.
     * @param booking The Booking object with updated information.
     * @return true if the booking was updated successfully, false otherwise.
     */
    public boolean updateBooking(Booking booking) {
        System.out.println("=== BOOKINGDAO: Updating Booking ID: " + booking.getBookingId() + " ===");
        
        String sql = "UPDATE bookings SET eventID = ?, vendorID = ?, serviceBooked = ?, bookingDate = ?, amount = ?, status = ?, notes = ?, advanceRequiredPercentage = ?, advanceAmountDue = ?, amountPaid = ? WHERE bookingID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, booking.getEventId());
            
            // Handle vendor ID - can be null now
            if (booking.getVendorId() != null && booking.getVendorId() > 0) {
                stmt.setInt(2, booking.getVendorId());
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            
            stmt.setString(3, booking.getServiceBooked());
            
            // Fix the bookingDate parameter - convert LocalDateTime to java.sql.Date
            if (booking.getBookingDate() != null) {
                stmt.setDate(4, java.sql.Date.valueOf(booking.getBookingDate().toLocalDate()));
            } else {
                stmt.setDate(4, java.sql.Date.valueOf(LocalDateTime.now().toLocalDate()));
            }
            
            stmt.setBigDecimal(5, booking.getAmount());
            stmt.setString(6, booking.getStatus());
            stmt.setString(7, booking.getNotes());
            stmt.setBigDecimal(8, booking.getAdvanceRequiredPercentage());
            stmt.setBigDecimal(9, booking.getAdvanceAmountDue());
            stmt.setBigDecimal(10, booking.getAmountPaid());
            stmt.setInt(11, booking.getBookingId());

            System.out.println("Executing update for Booking ID: " + booking.getBookingId());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Update affected rows: " + rowsAffected);
            
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating booking: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves all bookings from the database with joined event and vendor data.
     * @return A list of all Booking objects with associated names.
     */
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, e.type AS eventType, u.name AS clientName, v.companyName AS vendorCompanyName " +
                     "FROM bookings b " +
                     "JOIN events e ON b.eventID = e.eventID " +
                     "JOIN users u ON e.clientID = u.userID " +
                     "LEFT JOIN vendors v ON b.vendorID = v.vendorID " +  // Changed to LEFT JOIN for optional vendor
                     "ORDER BY b.bookingDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) { 

            while (rs.next()) {
                bookings.add(extractBookingWithJoinData(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting all bookings: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Retrieves bookings for a specific client (user).
     * @param clientId The ID of the client (user).
     * @return A list of Booking objects for that client.
     */
    public List<Booking> getBookingsByClientId(int clientId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, e.type AS eventType, u.name AS clientName, v.companyName AS vendorCompanyName " +
                     "FROM bookings b " +
                     "JOIN events e ON b.eventID = e.eventID " +
                     "JOIN users u ON e.clientID = u.userID " +
                     "LEFT JOIN vendors v ON b.vendorID = v.vendorID " +  // Changed to LEFT JOIN
                     "WHERE e.clientID = ? " +
                     "ORDER BY b.bookingDate DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clientId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(extractBookingWithJoinData(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error getting bookings by client ID: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Retrieves bookings assigned to a specific vendor.
     * @param vendorId The ID of the vendor.
     * @return A list of Booking objects assigned to that vendor.
     */
    public List<Booking> getBookingsByVendorId(int vendorId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, e.type AS eventType, u.name AS clientName, v.companyName AS vendorCompanyName " +
                     "FROM bookings b " +
                     "JOIN events e ON b.eventID = e.eventID " +
                     "JOIN users u ON e.clientID = u.userID " +
                     "JOIN vendors v ON b.vendorID = v.vendorID " +
                     "WHERE b.vendorID = ? " +
                     "ORDER BY b.bookingDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vendorId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = extractBookingFromResultSet(rs);
                    
                    // Set additional joined fields
                    booking.setEventName(rs.getString("eventType"));
                    booking.setClientName(rs.getString("clientName"));
                    booking.setVendorCompanyName(rs.getString("vendorCompanyName"));
                    
                    bookings.add(booking);
                }
            }

            LOGGER.info("Found " + bookings.size() + " bookings for vendor ID: " + vendorId);

        } catch (SQLException e) {
            LOGGER.severe("Error getting bookings by vendor ID: " + e.getMessage());
        }
        return bookings;
    }

    /**
     * Retrieves bookings without vendor assignment
     * @return A list of Booking objects without vendor assignment
     */
    public List<Booking> getBookingsWithoutVendor() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, e.type AS eventType, u.name AS clientName " +
                     "FROM bookings b " +
                     "JOIN events e ON b.eventID = e.eventID " +
                     "JOIN users u ON e.clientID = u.userID " +
                     "WHERE b.vendorID IS NULL " +
                     "ORDER BY b.bookingDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Booking booking = extractBookingFromResultSet(rs);
                booking.setEventName(rs.getString("eventType"));
                booking.setClientName(rs.getString("clientName"));
                bookings.add(booking);
            }

        } catch (SQLException e) {
            System.err.println("Error getting bookings without vendor: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * Updates only the amount paid for a booking.
     * @param bookingId The ID of the booking.
     * @param amountPaid The new amount paid.
     * @return true if updated successfully, false otherwise.
     */
    public boolean updateAmountPaid(int bookingId, BigDecimal amountPaid) {
        String sql = "UPDATE bookings SET amountPaid = ? WHERE bookingID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBigDecimal(1, amountPaid);
            stmt.setInt(2, bookingId);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating amount paid for booking ID: " + bookingId + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Helper method to extract Booking with joined data
     */
    private Booking extractBookingWithJoinData(ResultSet rs) throws SQLException {
        Booking booking = extractBookingFromResultSet(rs);
        booking.setEventName(rs.getString("eventType"));
        booking.setClientName(rs.getString("clientName"));
        booking.setVendorCompanyName(rs.getString("vendorCompanyName"));
        return booking;
    }

    /**
     * Helper method to extract Booking from ResultSet
     */
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("bookingID"));
        booking.setEventId(rs.getInt("eventID"));
        booking.setUserId(rs.getInt("userID"));
        
        // Vendor ID can be null now
        int vendorId = rs.getInt("vendorID");
        if (!rs.wasNull()) {
            booking.setVendorId(vendorId);
        }
        
        booking.setServiceBooked(rs.getString("serviceBooked"));
        booking.setAmount(rs.getBigDecimal("amount"));
        booking.setStatus(rs.getString("status"));
        booking.setNotes(rs.getString("notes"));
        booking.setAdvanceRequiredPercentage(rs.getBigDecimal("advanceRequiredPercentage"));
        booking.setAdvanceAmountDue(rs.getBigDecimal("advanceAmountDue"));
        booking.setAmountPaid(rs.getBigDecimal("amountPaid"));
        
        // Handle timestamp conversion
        java.sql.Timestamp timestamp = rs.getTimestamp("bookingDate");
        if (timestamp != null) {
            booking.setBookingDate(timestamp.toLocalDateTime());
        }
        
        return booking;
    }
    // In BookingDAO.java


}