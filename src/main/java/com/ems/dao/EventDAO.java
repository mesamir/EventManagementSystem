package com.ems.dao;

import com.ems.model.Event;
import com.ems.model.Vendor;
import com.ems.model.EventVendorAssignment;
import com.ems.model.VendorSelection;
import com.ems.util.DBConnection;
import java.math.BigDecimal;

import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public class EventDAO {

   private static final Logger LOGGER = Logger.getLogger(EventDAO.class.getName());
  /**
 * Adds a new event to the Events table with vendor assignments - IMPROVED VERSION
 */
public boolean addEvent(Event event, List<Integer> selectedVendorIds) {
    String sql = "INSERT INTO Events ("
            + "clientID, type, date, budget, status, description, guestCount, "
            + "locationPreference, location, "
            + "paymentStatus, paidAmount, advancePaid"
            + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false); // Start transaction

        ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        // Set parameters
        ps.setInt(1, event.getClientId());
        ps.setString(2, event.getType());
        ps.setDate(3, new java.sql.Date(event.getDate().getTime())); // Convert LocalDate to java.sql.Date
        
        if (event.getBudget() != null) {
            ps.setBigDecimal(4, event.getBudget());
        } else {
            ps.setNull(4, Types.DECIMAL);
        }
        
        ps.setString(5, event.getStatus() != null ? event.getStatus() : "Pending Approval");
        ps.setString(6, event.getDescription());
        
        if (event.getGuestCount() != null) {
            ps.setInt(7, event.getGuestCount());
        } else {
            ps.setNull(7, Types.INTEGER);
        }
        
        ps.setString(8, event.getLocationPreference());
        ps.setString(9, event.getLocation());
        ps.setString(10, event.getPaymentStatus() != null ? event.getPaymentStatus() : "pending");
        
        if (event.getPaidAmount() != null) {
            ps.setBigDecimal(11, event.getPaidAmount());
        } else {
            ps.setBigDecimal(11, BigDecimal.ZERO);
        }
        
        if (event.getAdvancePaid() != null) {
            ps.setBigDecimal(12, event.getAdvancePaid());
        } else {
            ps.setBigDecimal(12, BigDecimal.ZERO);
        }

        int rows = ps.executeUpdate();

        if (rows > 0) {
            // Get the generated event ID
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int newEventId = rs.getInt(1);
                event.setEventId(newEventId);

                // Store selected vendors if any
                if (selectedVendorIds != null && !selectedVendorIds.isEmpty()) {
                    boolean vendorsStored = storeSelectedVendors(newEventId, selectedVendorIds);
                    if (!vendorsStored) {
                        conn.rollback();
                        System.err.println("❌ Failed to store selected vendors for event " + newEventId);
                        return false;
                    }
                    System.out.println("✅ Successfully stored " + selectedVendorIds.size() + " vendors for event " + newEventId);
                } else {
                    System.out.println("ℹ️ No vendors selected for event " + newEventId);
                }

                conn.commit();
                System.out.println("✅ Event created successfully with ID: " + newEventId);
                return true;
            }
        }
        
        conn.rollback();
        return false;

    } catch (SQLException e) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        System.err.println("❌ Error creating event: " + e.getMessage());
        e.printStackTrace();
        return false;
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
    

    
    /**
     * Retrieves an event by ID with selected vendors
     */
    public Event getEventById(int eventId) {
        String sql = "SELECT e.*, u.name AS clientName " 
                + "FROM Events e "
                + "JOIN Users u ON e.clientID = u.userID "
                + "WHERE e.eventID = ?";

        Event event = null;

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                event = new Event();
                event.setEventId(rs.getInt("eventID"));
                event.setClientId(rs.getInt("clientID"));
                event.setClientName(rs.getString("clientName"));
                event.setType(rs.getString("type"));
                event.setDate(rs.getDate("date"));
                event.setBudget(rs.getBigDecimal("budget"));
                event.setStatus(rs.getString("status"));
                event.setVenueId(rs.getObject("venueID", Integer.class));
                event.setDescription(rs.getString("description"));
                event.setGuestCount(rs.getObject("guestCount", Integer.class));
                event.setLocationPreference(rs.getString("locationPreference"));
                event.setCreationDate(rs.getDate("creationDate"));
                event.setLocation(rs.getString("location"));
                event.setPaymentStatus(rs.getString("paymentStatus"));
                event.setPaidAmount(rs.getBigDecimal("paidAmount"));
                event.setAdvancePaid(rs.getBigDecimal("advancePaid"));
                
                // Load selected vendors
                List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(eventId);
                event.setSelectedVendors(selectedVendors);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return event;
    }
  /**
     * Retrieves all events with selected vendors
     */
    public List<Event> getAllEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, u.name AS clientName " 
                + "FROM Events e "
                + "JOIN Users u ON e.clientID = u.userID "
                + "ORDER BY e.creationDate DESC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getInt("eventID"));
                event.setClientId(rs.getInt("clientID"));
                event.setClientName(rs.getString("clientName"));
                event.setType(rs.getString("type"));
                event.setDate(rs.getDate("date"));
                event.setBudget(rs.getBigDecimal("budget"));
                event.setStatus(rs.getString("status"));
                event.setVenueId(rs.getObject("venueID", Integer.class));
                event.setDescription(rs.getString("description"));
                event.setGuestCount(rs.getObject("guestCount", Integer.class));
                event.setLocationPreference(rs.getString("locationPreference"));
                event.setCreationDate(rs.getDate("creationDate"));
                event.setLocation(rs.getString("location"));
                event.setPaymentStatus(rs.getString("paymentStatus"));
                event.setPaidAmount(rs.getBigDecimal("paidAmount"));
                event.setAdvancePaid(rs.getBigDecimal("advancePaid"));

                // Load selected vendors
                List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(event.getEventId());
                event.setSelectedVendors(selectedVendors);

                list.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    /**
     * Updates event fields
     */
    public boolean updateEvent(Event event) {
        String sql = "UPDATE Events SET "
            + "clientID=?, type=?, date=?, budget=?, description=?, guestCount=?, "
            + "locationPreference=?, status=?, location=?, "
            + "paymentStatus=?, paidAmount=?, advancePaid=? "
            + "WHERE eventID=?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, event.getClientId());
            ps.setString(2, event.getType());
            ps.setDate(3, event.getDate());
            
            if (event.getBudget() != null) {
                ps.setBigDecimal(4, event.getBudget());
            } else {
                ps.setNull(4, Types.DECIMAL);
            }
            
            ps.setString(5, event.getDescription());
            
            if (event.getGuestCount() != null) {
                ps.setInt(6, event.getGuestCount());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            
            ps.setString(7, event.getLocationPreference());
            ps.setString(8, event.getStatus());
            ps.setString(9, event.getLocation());
            ps.setString(10, event.getPaymentStatus());
            
            if (event.getPaidAmount() != null) {
                ps.setBigDecimal(11, event.getPaidAmount());
            } else {
                ps.setBigDecimal(11, BigDecimal.ZERO);
            }
            
            if (event.getAdvancePaid() != null) {
                ps.setBigDecimal(12, event.getAdvancePaid());
            } else {
                ps.setBigDecimal(12, BigDecimal.ZERO);
            }
            
            ps.setInt(13, event.getEventId());

            int rowsUpdated = ps.executeUpdate();
            System.out.println("DAO: Updated " + rowsUpdated + " rows for event ID: " + event.getEventId());
            return rowsUpdated > 0;

        } catch (SQLException e) {
            System.err.println("SQL Error updating event " + event.getEventId() + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
/**
 * Get event with selected vendors (for dashboard display)
 */
public Event getEventWithVendors(int eventId) {
    // First get the basic event data
    Event event = getEventById(eventId);
    
    if (event != null) {
        // Load selected vendors for this event
        List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(eventId);
        event.setSelectedVendors(selectedVendors);
    }
    
    return event;
}
/**
     * Update event with vendor assignments
     */
    public boolean updateEventWithVendors(Event event, List<Integer> selectedVendorIds) {
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Update event details
            boolean eventUpdated = updateEvent(event);
            if (!eventUpdated) {
                conn.rollback();
                return false;
            }
            
            // 2. Update vendor assignments
            if (selectedVendorIds != null) {
                boolean vendorsUpdated = storeSelectedVendors(event.getEventId(), selectedVendorIds);
                if (!vendorsUpdated) {
                    conn.rollback();
                    return false;
                }
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
/**
 * Get all events with their selected vendors (for admin dashboard)
 */
public List<Event> getAllEventsWithVendors() {
    List<Event> events = getAllEvents(); // This gets basic event data
    
    // Populate selected vendors for each event
    for (Event event : events) {
        List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(event.getEventId());
        event.setSelectedVendors(selectedVendors);
    }
    
    return events;
}
/**
 * Update event vendors while preserving existing status for vendors that remain selected
 */
public boolean updateEventVendorsWithStatus(int eventId, List<Integer> newVendorIds, List<VendorSelection> currentVendors) {
    Connection conn = null;
    
    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false);
        
        // Create a map of current vendor statuses for quick lookup
        Map<Integer, String> currentStatusMap = new HashMap<>();
        for (VendorSelection vendor : currentVendors) {
            currentStatusMap.put(vendor.getVendorId(), vendor.getStatus());
        }
        
        // Clear existing vendors
        String deleteSql = "DELETE FROM event_vendors WHERE eventID = ?";
        try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
            deleteStmt.setInt(1, eventId);
            deleteStmt.executeUpdate();
        }
        
        // Insert new vendors with preserved status where applicable
        if (newVendorIds != null && !newVendorIds.isEmpty()) {
            String insertSql = "INSERT INTO event_vendors (eventID, vendorID, vendorStatus) VALUES (?, ?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                for (Integer vendorId : newVendorIds) {
                    insertStmt.setInt(1, eventId);
                    insertStmt.setInt(2, vendorId);
                    
                    // Preserve status if vendor was previously selected, otherwise default to "Pending"
                    String status = currentStatusMap.getOrDefault(vendorId, "Pending");
                    insertStmt.setString(3, status);
                    
                    insertStmt.addBatch();
                }
                insertStmt.executeBatch();
            }
        }
        
        conn.commit();
        LOGGER.info("✅ Updated " + (newVendorIds != null ? newVendorIds.size() : 0) + 
                   " vendors for event " + eventId + " with status preservation");
        return true;
        
    } catch (SQLException e) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        LOGGER.severe("❌ Error updating vendors with status preservation: " + e.getMessage());
        e.printStackTrace();
        return false;
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

/**
 * Get events by client ID with selected vendors (for client dashboard)
 */
public List<Event> getEventsByClientIdWithVendors(int clientId) {
    List<Event> events = getEventsByClientId(clientId); // This gets basic event data
    
    // Populate selected vendors for each event
    for (Event event : events) {
        List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(event.getEventId());
        event.setSelectedVendors(selectedVendors);
    }
    
    return events;
}

    /**
     * Updates only the payment status and paid amount for an event. This is
     * useful for transactional updates (like after a successful payment).
     *
     * @param eventId The ID of the event to update.
     * @param paymentStatus The new payment status.
     * @param paidAmount The new paid amount.
     * @return true if the update was successful, false otherwise.
     */
    
    /**
 * Update event payment with status and transaction reference
 */
public boolean updateEventPayment(int eventId, BigDecimal newTotalPaid, String newStatus, String transactionRef) {
    String sql = "UPDATE Events SET paymentStatus=?, paidAmount=?, status=?, last_transaction_id=? WHERE eventID=?";
    
    try (Connection conn = DBConnection.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, determinePaymentStatus(newTotalPaid, eventId)); // paymentStatus
        ps.setBigDecimal(2, newTotalPaid); // paidAmount
        ps.setString(3, newStatus); // status
        ps.setString(4, transactionRef); // last_transaction_id
        ps.setInt(5, eventId);

        int rowsAffected = ps.executeUpdate();
        System.out.println("Updated event payment - Rows affected: " + rowsAffected);
        return rowsAffected > 0;

    } catch (SQLException e) {
        System.err.println("Error updating event payment: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

    /**
     *
     * @param eventId
     * @param newStatus
     * @return
     */
    public boolean updateEventStatus(int eventId, String newStatus) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(
                "UPDATE Events SET status=? WHERE eventID=?")) {

            ps.setString(1, newStatus);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteEvent(int eventId) {
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps
                = conn.prepareStatement("DELETE FROM Events WHERE eventID=?")) {

            ps.setInt(1, eventId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     *
     * @param filterDate
     * @param statusFilter
     * @return 
     * @throws SQLException
     */
    public List<Event> getFilteredEvents(java.util.Date filterDate, String statusFilter) throws SQLException {
        List<Event> events = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        // --- Step 1: Build the SQL query correctly ---
        // FIX: Ensure all required columns for Event object are selected, including client/vendor joins
         StringBuilder sql = new StringBuilder(
            "SELECT e.*, u.name AS clientName "  // Removed vendor join
            + "FROM Events e "
            + "JOIN Users u ON e.clientID = u.userID "
            + "WHERE 1=1" // Base condition
    );

        // Use a list to store parameters for proper indexing
        List<Object> params = new ArrayList<>();

        if (filterDate != null) {
            // Add the date condition to the SQL query (e.g., events on or after this date)
            sql.append(" AND e.date >= ?");
            // Convert java.util.Date to java.sql.Date for PreparedStatement
            params.add(new java.sql.Date(filterDate.getTime()));
        }

        if (statusFilter != null && !"all_statuses".equalsIgnoreCase(statusFilter)) {
            // Add the status condition
            sql.append(" AND e.status = ?");
            params.add(statusFilter); // Add the status to the list
        }

        // Add sorting
        sql.append(" ORDER BY e.date DESC");

        try {
            conn = DBConnection.getConnection();

            if (conn == null) {
                // This block is only for the mock environment context.
                System.err.println("MOCK ERROR: Connection is null. Returning empty list.");
                return events;
            }

            stmt = conn.prepareStatement(sql.toString());

            // --- Step 2: Set parameters using a single index loop ---
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                // JDBC parameter indexing starts at 1
                int paramIndex = i + 1;

                if (param instanceof java.sql.Date) {
                    stmt.setDate(paramIndex, (java.sql.Date) param);
                } else if (param instanceof String) {
                    stmt.setString(paramIndex, (String) param);
                }
            }

            rs = stmt.executeQuery();

            // Populate events
            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getInt("eventID"));
                event.setClientId(rs.getInt("clientID"));
                event.setClientName(rs.getString("clientName")); // From JOIN
                event.setType(rs.getString("type"));
                event.setDate(rs.getDate("date"));
                event.setBudget(rs.getBigDecimal("budget"));
                event.setStatus(rs.getString("status"));
                event.setVenueId(rs.getObject("venueID", Integer.class));
                event.setDescription(rs.getString("description"));
                event.setGuestCount(rs.getObject("guestCount", Integer.class));
                event.setLocationPreference(rs.getString("locationPreference"));
                event.setCreationDate(rs.getDate("creationDate"));
              
                // NEW FIELDS
                event.setLocation(rs.getString("location"));
                event.setPaymentStatus(rs.getString("paymentStatus"));
                event.setPaidAmount(rs.getBigDecimal("paidAmount"));

                events.add(event);
            }

        } catch (SQLException e) {
            // Log the actual exception before re-throwing it
            System.err.println("Database error during event filtering: " + e.getMessage());
            throw e; // Re-throw the exception to the caller
        } finally {
            // Close resources safely
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ignore) {
            }
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException ignore) {
            }
            // Closing the connection is crucial
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ignore) {
            }
        }

        return events;
    }

     // Add missing method implementations
    public List<Event> getEventsByClientId(int clientId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, u.name AS clientName " 
                + "FROM Events e "
                + "JOIN Users u ON e.clientID = u.userID "
                + "WHERE e.clientID = ? "
                + "ORDER BY e.creationDate DESC";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getInt("eventID"));
                event.setClientId(rs.getInt("clientID"));
                event.setClientName(rs.getString("clientName"));
                event.setType(rs.getString("type"));
                event.setDate(rs.getDate("date"));
                event.setBudget(rs.getBigDecimal("budget"));
                event.setStatus(rs.getString("status"));
                event.setVenueId(rs.getObject("venueID", Integer.class));
                event.setDescription(rs.getString("description"));
                event.setGuestCount(rs.getObject("guestCount", Integer.class));
                event.setLocationPreference(rs.getString("locationPreference"));
                event.setCreationDate(rs.getDate("creationDate"));
                event.setLocation(rs.getString("location"));
                event.setPaymentStatus(rs.getString("paymentStatus"));
                event.setPaidAmount(rs.getBigDecimal("paidAmount"));
                event.setAdvancePaid(rs.getBigDecimal("advancePaid"));

                // Load selected vendors
                List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(event.getEventId());
                event.setSelectedVendors(selectedVendors);

                list.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

   

    /**
     * * Assigns a vendor to an event.
     *
     * @param eventId The ID of the event.
     * @param vendorId The ID of the vendor to assign (or null to unassign).
     * @return true if the vendor was assigned successfully, false otherwise.
     */
   // In EventDAO.java
/**
 * Assign vendor to event with vendor type
 */
public boolean assignVendorToEvent(int eventId, int vendorId, String vendorType) {
    String sql = "INSERT INTO event_vendors (eventID, vendorID, vendorStatus) VALUES (?, ?, 'Pending')";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, eventId);
        ps.setInt(2, vendorId);
        // vendorType is stored in the Vendors table, so we don't need to store it here
        
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

     /* Updates event fields excluding vendor assignment.
 */
          // ----------------------------------------------------------------------

          // NEW MULTI-VENDOR MANAGEMENT METHODS USING 'event_vendors' TABLE
    // ----------------------------------------------------------------------

    /**
     * Invites a vendor to an event and sets their initial status (defaults to 'Pending').
     * Assumes vendorName is provided through another source or joins in the retrieval.
     *
     * @param eventId The ID of the event.
     * @param vendorId The ID of the vendor being invited.
     * @param status The initial status ('Pending', 'Confirmed', 'Rejected').
     * @return true if the invitation was recorded successfully, false otherwise.
     */
    public boolean inviteVendorToEvent(int eventId, int vendorId, String status) {
                String sql = "INSERT INTO event_vendors (eventID, vendorID, vendorStatus) VALUES (?, ?, ?)";
                // Default status to 'Pending' if not explicitly provided or invalid
        String finalStatus = (status != null && !status.trim().isEmpty()) ? status : "Pending";
                try (Connection conn = DBConnection.getConnection();
                            PreparedStatement ps = conn.prepareStatement(sql)
                ) {


                            ps.setInt(1, eventId);
                            ps.setInt(2, vendorId);
                            ps.setString(3, finalStatus);
                            
            return ps.executeUpdate() > 0;
                        } catch (SQLIntegrityConstraintViolationException e) {
                                        System.err.println("Error: Vendor " + vendorId + " is already associated with Event " + eventId + " or FK violation.");
                                        return false;
                            }catch (SQLException e) {
                                        e.printStackTrace();
                                        return false;
                            }
            }


    
        /**
     * Updates the status of a specific vendor for a specific event.
     *
     * @param eventId The ID of the event.
     * @param vendorId The ID of the vendor whose status is being updated.
     * @param newStatus The new status ('Pending', 'Confirmed', 'Rejected').
     * @return true if the status was updated successfully, false otherwise.
     */
    public boolean updateEventVendorStatus(int eventId, int vendorId, String newStatus) {
                String sql = "UPDATE event_vendors SET vendorStatus = ? WHERE eventID = ? AND vendorID = ?";
                
        try (Connection conn = DBConnection.getConnection();
                            PreparedStatement ps = conn.prepareStatement(sql)
                ) {


                            ps.setString(1, newStatus);
                            ps.setInt(2, eventId);
                            ps.setInt(3, vendorId);
                            
            return ps.executeUpdate() > 0;
                        } catch (SQLException e) {
                                        e.printStackTrace();
                                        return false;
                            }
            }


    
  
  /**
 * Retrieves all vendors invited to a specific event, along with their status.
 * Joins with the Vendors table to get the company name.
 *
 * @param eventId The ID of the event.
 * @return A list of EventVendorAssignment objects for the event.
 */
public List<EventVendorAssignment> getVendorsByEventId(int eventId) {
    List<EventVendorAssignment> assignments = new ArrayList<>();
    
    String sql = "SELECT ev.id, ev.vendorID, ev.vendorStatus, v.companyName, v.serviceType, v.contactPerson " +
                "FROM event_vendors ev " +
                "JOIN Vendors v ON ev.vendorID = v.vendorID " +
                "WHERE ev.eventID = ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, eventId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            // Create using default constructor and setters
            EventVendorAssignment assignment = new EventVendorAssignment();
            
            // Set all properties using setters
            assignment.setId(rs.getInt("id"));
            assignment.setVendorId(rs.getInt("vendorID"));
            assignment.setVendorName(rs.getString("companyName"));
            assignment.setVendorType(rs.getString("serviceType"));
            assignment.setStatus(rs.getString("vendorStatus"));
            // Set contactPerson if you have that field in your class
            // assignment.setContactPerson(rs.getString("contactPerson"));
            
            assignments.add(assignment);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return assignments;
}
  
     

/**
 * Remove vendor assignment using the assignment ID (primary key)
 */
public boolean removeVendorAssignment(int assignmentId) {
    String sql = "DELETE FROM event_vendors WHERE id = ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, assignmentId);
        int rowsAffected = ps.executeUpdate();
        System.out.println("Removed vendor assignment with ID: " + assignmentId);
        return rowsAffected > 0;
    } catch (SQLException e) {
        System.err.println("Error removing vendor assignment: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

/* Helper method to determine payment status based on amount paid
 */
private String determinePaymentStatus(BigDecimal paidAmount, int eventId) {
    try {
        // Get event budget to determine payment status
        String budgetSql = "SELECT budget FROM Events WHERE eventID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(budgetSql)) {
            
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                BigDecimal budget = rs.getBigDecimal("budget");
                if (budget != null) {
                    if (paidAmount.compareTo(budget) >= 0) {
                        return "fully_paid";
                    } else if (paidAmount.compareTo(BigDecimal.ZERO) > 0) {
                        return "advance_paid";
                    }
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return "pending";
}
 /**
     * Update vendor assignment status
     */
    public boolean updateVendorAssignmentStatus(int assignmentId, String vendorStatus) {
        String sql = "UPDATE event_vendors SET vendorStatus = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, vendorStatus);
            ps.setInt(2, assignmentId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Updated vendor assignment " + assignmentId + " to status: " + vendorStatus);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating vendor assignment status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
public Event getEventDetails(int eventId) throws SQLException {
    String sql = "SELECT * FROM events WHERE eventID = ?";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, eventId);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            Event event = new Event();
            event.setEventId(rs.getInt("eventID"));
            event.setClientId(rs.getInt("clientID"));
            event.setType(rs.getString("type"));
             event.setDate(rs.getDate("date"));
            event.setBudget(rs.getBigDecimal("budget"));
            event.setStatus(rs.getString("status"));
            event.setDescription(rs.getString("description"));
            event.setLocation(rs.getString("location"));
            event.setPaymentStatus(rs.getString("paymentStatus"));
            event.setPaidAmount(rs.getBigDecimal("paidAmount"));
            event.setGuestCount(rs.getInt("guestCount"));
          
            
            return event;
        }
    }
    return null;
}
public Event getEventWithVendor(int eventId) throws SQLException {
        String sql = "SELECT e.*, v.companyName as vendorCompanyName " +
                    "FROM events e " +
                    "LEFT JOIN vendors v ON e.assignedVendorID = v.vendorId " +
                    "WHERE e.eventId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Event event = mapResultSetToEvent(rs);
                    // Set vendor name if available
                    String vendorName = rs.getString("vendorCompanyName");
                    if (vendorName != null) {
                        // You might need to add a transient field for vendor name
                        // or handle it differently
                    }
                    return event;
                }
            }
        }
        return null;
    }
 /**
     * Helper method to map ResultSet to Event object.
     */
    private Event mapResultSetToEvent(ResultSet rs) throws SQLException {
        Event event = new Event();
        
        event.setEventId(rs.getInt("eventID"));
        event.setClientId(rs.getInt("clientID"));
        event.setClientName(rs.getString("clientName"));
        event.setType(rs.getString("type"));
        event.setDate(rs.getDate("date"));
        event.setBudget(rs.getBigDecimal("budget"));
        event.setStatus(rs.getString("status"));
        event.setVenueId(rs.getObject("venueID", Integer.class));
        event.setDescription(rs.getString("description"));
        event.setGuestCount(rs.getObject("guestCount", Integer.class));
        event.setLocationPreference(rs.getString("locationPreference"));
        event.setCreationDate(rs.getDate("creationDate"));

        // Vendor data - from JOIN
      
        // Other fields
        event.setLocation(rs.getString("location"));
        event.setPaymentStatus(rs.getString("paymentStatus"));
        event.setPaidAmount(rs.getBigDecimal("paidAmount"));

        return event;
    }
   /**
 * Store selected vendors in event_vendors table - FIXED VERSION with better transaction handling
 */
public boolean storeSelectedVendors(int eventId, List<Integer> vendorIds) {
    Connection conn = null;
    PreparedStatement deleteStmt = null;
    PreparedStatement insertStmt = null;
    
    try {
        conn = DBConnection.getConnection();
        
        // Set shorter transaction timeout and isolation level
        conn.setAutoCommit(false);
        conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
        
        // 1. First delete existing selections with a quick timeout
        String deleteSql = "DELETE FROM event_vendors WHERE eventID = ?";
        deleteStmt = conn.prepareStatement(deleteSql);
        deleteStmt.setInt(1, eventId);
        deleteStmt.setQueryTimeout(10); // 10 seconds timeout
        int deletedRows = deleteStmt.executeUpdate();
        System.out.println("Deleted " + deletedRows + " existing vendor selections for event " + eventId);
        
        // Close delete statement immediately
        if (deleteStmt != null) {
            deleteStmt.close();
            deleteStmt = null;
        }
        
        // 2. If no vendors to insert, commit and return
        if (vendorIds == null || vendorIds.isEmpty()) {
            conn.commit();
            System.out.println("No vendors to insert for event " + eventId);
            return true;
        }
        
        // 3. Insert new vendor selections in smaller batches with individual commits
        String insertSql = "INSERT INTO event_vendors (eventID, vendorID, vendorStatus) VALUES (?, ?, 'Pending')";
        insertStmt = conn.prepareStatement(insertSql);
        insertStmt.setQueryTimeout(10); // 10 seconds timeout
        
        int batchSize = 5; // Smaller batch size
        int count = 0;
        
        for (Integer vendorId : vendorIds) {
            insertStmt.setInt(1, eventId);
            insertStmt.setInt(2, vendorId);
            insertStmt.addBatch();
            count++;
            
            // Execute batch in smaller chunks and commit frequently
            if (count % batchSize == 0) {
                try {
                    insertStmt.executeBatch();
                    conn.commit(); // Commit after each batch
                    System.out.println("Executed and committed batch of " + batchSize + " vendors");
                } catch (SQLException e) {
                    // If batch fails, try individual inserts
                    System.out.println("Batch insert failed, trying individual inserts...");
                    executeIndividualInserts(conn, eventId, vendorIds);
                    break;
                }
            }
        }
        
        // Execute remaining batch
        if (count % batchSize != 0) {
            try {
                insertStmt.executeBatch();
                conn.commit();
                System.out.println("Executed and committed final batch of " + (count % batchSize) + " vendors");
            } catch (SQLException e) {
                // If final batch fails, try individual inserts
                System.out.println("Final batch insert failed, trying individual inserts...");
                executeIndividualInserts(conn, eventId, vendorIds);
            }
        }
        
        System.out.println("✅ Successfully stored " + vendorIds.size() + " vendors for event " + eventId);
        return true;
        
    } catch (SQLException e) {
        // Rollback on error
        if (conn != null) {
            try {
                conn.rollback();
                System.out.println("❌ Transaction rolled back due to error: " + e.getMessage());
            } catch (SQLException rollbackEx) {
                System.err.println("Rollback failed: " + rollbackEx.getMessage());
            }
        }
        System.err.println("❌ Error storing vendors for event " + eventId + ": " + e.getMessage());
        e.printStackTrace();
        return false;
    } finally {
        // Close resources properly
        try {
            if (insertStmt != null) insertStmt.close();
            if (deleteStmt != null) deleteStmt.close();
            if (conn != null) {
                conn.setAutoCommit(true); // Reset auto-commit
                conn.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage());
        }
    }
}

/**
 * Fallback method for individual inserts if batch fails
 */
private boolean executeIndividualInserts(Connection conn, int eventId, List<Integer> vendorIds) {
    PreparedStatement insertStmt = null;
    String insertSql = "INSERT INTO event_vendors (eventID, vendorID, vendorStatus) VALUES (?, ?, 'Pending')";
    
    try {
        insertStmt = conn.prepareStatement(insertSql);
        insertStmt.setQueryTimeout(5); // Even shorter timeout for individual inserts
        
        int successCount = 0;
        for (Integer vendorId : vendorIds) {
            try {
                insertStmt.setInt(1, eventId);
                insertStmt.setInt(2, vendorId);
                int result = insertStmt.executeUpdate();
                if (result > 0) {
                    successCount++;
                    conn.commit(); // Commit after each successful insert
                }
            } catch (SQLException e) {
                System.err.println("Failed to insert vendor " + vendorId + ": " + e.getMessage());
                conn.rollback(); // Rollback the failed insert
                // Continue with next vendor
            }
        }
        
        System.out.println("✅ Individual inserts completed: " + successCount + "/" + vendorIds.size() + " vendors stored");
        return successCount > 0;
        
    } catch (SQLException e) {
        System.err.println("Error in individual inserts: " + e.getMessage());
        return false;
    } finally {
        try {
            if (insertStmt != null) insertStmt.close();
        } catch (SQLException e) {
            System.err.println("Error closing statement: " + e.getMessage());
        }
    }
}
 /**
 * Get selected vendors for an event with complete vendor details - CORRECTED VERSION
 */
public List<VendorSelection> getSelectedVendorsForEvent(int eventId) {
    List<VendorSelection> vendorSelections = new ArrayList<>();
    String sql = "SELECT v.vendorID, v.companyName, v.serviceType, v.contactPerson, v.phone, v.email, ev.vendorStatus " +
                "FROM vendors v " +
                "INNER JOIN event_vendors ev ON v.vendorID = ev.vendorID " +
                "WHERE ev.eventID = ? " +
                "ORDER BY v.companyName";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, eventId);
        ResultSet rs = stmt.executeQuery();
        
        while (rs.next()) {
            VendorSelection vendorSelection = new VendorSelection();
            
            // Set basic vendor information
            vendorSelection.setVendorId(rs.getInt("vendorID"));
            vendorSelection.setCompanyName(rs.getString("companyName"));
            vendorSelection.setServiceType(rs.getString("serviceType"));
            vendorSelection.setContactPerson(rs.getString("contactPerson"));
            vendorSelection.setPhone(rs.getString("phone"));
            vendorSelection.setEmail(rs.getString("email"));
            
            // Set status - use vendorStatus from event_vendors table
            String vendorStatus = rs.getString("vendorStatus");
            vendorSelection.setStatus(vendorStatus);
            vendorSelection.setVendorStatus(vendorStatus); // Also set for JSP compatibility
            
            vendorSelections.add(vendorSelection);
        }
        
        System.out.println("✅ Loaded " + vendorSelections.size() + " vendors for event " + eventId);
        
    } catch (SQLException e) {
        System.err.println("❌ Error loading vendors for event " + eventId + ": " + e.getMessage());
        e.printStackTrace();
    }
    return vendorSelections;
}




/**
 * Get all events with their selected vendors for admin dashboard
 */
public List<Event> getAllEventsWithSelectedVendors() {
    List<Event> events = getAllEvents(); // Use your existing method
    
    // Populate selected vendors for each event
    for (Event event : events) {
        List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(event.getEventId());
        event.setSelectedVendors(selectedVendors);
    }
    
    return events;
}

/**
 * Get the last inserted event ID (needed after creating a new event)
 */
public int getLastInsertedEventId() {
    String sql = "SELECT LAST_INSERT_ID() as last_id";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        
        if (rs.next()) {
            return rs.getInt("last_id");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return -1;
}
}