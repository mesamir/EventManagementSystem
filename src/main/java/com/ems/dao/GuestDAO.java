// src/main/java/com/ems/dao/GuestDAO.java
package com.ems.dao;

import com.ems.model.Guest;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GuestDAO {
    private static final Logger LOGGER = Logger.getLogger(GuestDAO.class.getName());

    /**
     * Inserts a new guest into the Guests table.
     * @param guest The Guest object to insert.
     * @return true if the guest was inserted successfully, false otherwise.
     */
    public boolean addGuest(Guest guest) {
        if (guest == null || guest.getEventId() <= 0 || guest.getName() == null) {
            LOGGER.log(Level.WARNING, "Invalid guest data provided for insertion");
            return false;
        }
        String sql = "INSERT INTO Guests (eventID, name, email, phone, rsvpStatus, invitationSentDate) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, guest.getEventId());
            pstmt.setString(2, guest.getName());
            pstmt.setString(3, guest.getEmail());
            pstmt.setString(4, guest.getPhone());
            pstmt.setString(5, guest.getRsvpStatus());
            pstmt.setTimestamp(6, guest.getInvitationSentDate()); // Can be null initially

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        guest.setGuestId(generatedKeys.getInt(1));
                         LOGGER.log(Level.INFO, "Guest added successfully with ID: {0}", guest.getGuestId());
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
             LOGGER.log(Level.SEVERE, "Error adding guest: " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * Retrieves a guest by their ID.
     * @param guestId The ID of the guest to retrieve.
     * @return The Guest object if found, null otherwise.
     */
    public Guest getGuestById(int guestId) {
        String sql = "SELECT guestID, eventID, name, email, phone, rsvpStatus, invitationSentDate, rsvpResponseDate FROM Guests WHERE guestID = ?";
        Guest guest = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, guestId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guestID"));
                    guest.setEventId(rs.getInt("eventID"));
                    guest.setName(rs.getString("name"));
                    guest.setEmail(rs.getString("email"));
                    guest.setPhone(rs.getString("phone"));
                    guest.setRsvpStatus(rs.getString("rsvpStatus"));
                    guest.setInvitationSentDate(rs.getTimestamp("invitationSentDate"));
                    guest.setRsvpResponseDate(rs.getTimestamp("rsvpResponseDate"));
                }
            }
        } catch (SQLException e) {
             LOGGER.log(Level.SEVERE, "Error getting guest by ID: " + e.getMessage(), e);
        }
        return guest;
    }
    
// NEW METHOD: Bulk retrieval for 'Send Invitations' functionality
// ----------------------------------------------------------------------
    /**
     * Retrieves a list of Guest objects based on a list of Guest IDs.
     * Uses a SQL IN clause for efficient bulk retrieval.
     * @param guestIds A list of guest IDs to fetch.
     * @return A list of Guest objects corresponding to the provided IDs.
     */
    public List<Guest> getGuestsByIds(List<Integer> guestIds) {
        List<Guest> guests = new ArrayList<>();
        if (guestIds == null || guestIds.isEmpty()) {
            return guests;
        }

        // Construct the SQL IN clause string: e.g., "(?, ?, ?)"
        String inClause = String.join(",", java.util.Collections.nCopies(guestIds.size(), "?"));
        String sql = "SELECT guestID, eventID, name, email, phone, rsvpStatus, invitationSentDate, rsvpResponseDate FROM Guests WHERE guestID IN (" + inClause + ")";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            // Set the parameters for the IN clause
            for (int i = 0; i < guestIds.size(); i++) {
                pstmt.setInt(i + 1, guestIds.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Guest guest = new Guest();
                    guest.setGuestId(rs.getInt("guestID"));
                    guest.setEventId(rs.getInt("eventID"));
                    guest.setName(rs.getString("name"));
                    guest.setEmail(rs.getString("email"));
                    guest.setPhone(rs.getString("phone"));
                    guest.setRsvpStatus(rs.getString("rsvpStatus"));
                    guest.setInvitationSentDate(rs.getTimestamp("invitationSentDate"));
                    guest.setRsvpResponseDate(rs.getTimestamp("rsvpResponseDate"));
                    guests.add(guest);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting guests by IDs: " + e.getMessage(), e);
        }
        return guests;
    }
// -----------
    /**
     * Retrieves all guests for a specific event.
     * @param eventId The ID of the event.
     * @return A list of Guest objects for the given event.
     */
    public List<Guest> getGuestsByEventId(int eventId) {
        List<Guest> guests = new ArrayList<>();
        String sql = "SELECT guestID, eventID, name, email, phone, rsvpStatus, invitationSentDate, rsvpResponseDate FROM Guests WHERE eventID = ? ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, eventId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Guest guest = new Guest();
                    guest.setGuestId(rs.getInt("guestID"));
                    guest.setEventId(rs.getInt("eventID"));
                    guest.setName(rs.getString("name"));
                    guest.setEmail(rs.getString("email"));
                    guest.setPhone(rs.getString("phone"));
                    guest.setRsvpStatus(rs.getString("rsvpStatus"));
                    guest.setInvitationSentDate(rs.getTimestamp("invitationSentDate"));
                    guest.setRsvpResponseDate(rs.getTimestamp("rsvpResponseDate"));
                    guests.add(guest);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting guests by event ID: " + e.getMessage(), e);
        }
        return guests;
    }

    /**
     * Updates an existing guest's information.
     * @param guest The Guest object with updated information.
     * @return true if the guest was updated successfully, false otherwise.
     */
    public boolean updateGuest(Guest guest) {
        String sql = "UPDATE Guests SET name = ?, email = ?, phone = ?, rsvpStatus = ?, invitationSentDate = ?, rsvpResponseDate = ? WHERE guestID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, guest.getName());
            pstmt.setString(2, guest.getEmail());
            pstmt.setString(3, guest.getPhone());
            pstmt.setString(4, guest.getRsvpStatus());
            pstmt.setTimestamp(5, guest.getInvitationSentDate());
            pstmt.setTimestamp(6, guest.getRsvpResponseDate());
            pstmt.setInt(7, guest.getGuestId());
            
            int rowsAffected = pstmt.executeUpdate();
            boolean success = rowsAffected > 0;
            if (success) {
                LOGGER.log(Level.INFO, "Guest updated successfully: {0}", guest.getGuestId());
            }
            return success;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating guest: " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * Updates only the RSVP status and response date for a guest.
     * @param guestId The ID of the guest to update.
     * @param newStatus The new RSVP status.
     * @return true if the status was updated successfully, false otherwise.
     */
    public boolean updateRsvpStatus(int guestId, String newStatus) {
        String sql = "UPDATE Guests SET rsvpStatus = ?, rsvpResponseDate = CURRENT_TIMESTAMP WHERE guestID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, guestId);
            int rowsAffected = pstmt.executeUpdate();
             boolean success = rowsAffected > 0;
            if (success) {
                LOGGER.log(Level.INFO, "RSVP status updated for guest {0}: {1}", new Object[]{guestId, newStatus});
            }
            return success;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating RSVP status for guest " + guestId + ": " + e.getMessage(), e);
            return false;
        }
    }

    /**
     * Updates the invitation sent date for a guest.
     * @param guestId The ID of the guest.
     * @return true if the date was updated successfully, false otherwise.
     */
    public boolean updateInvitationSentDate(int guestId) {
        String sql = "UPDATE Guests SET invitationSentDate = CURRENT_TIMESTAMP WHERE guestID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, guestId);
            int rowsAffected = pstmt.executeUpdate();
            boolean success = rowsAffected > 0;
            if (success) {
                LOGGER.log(Level.INFO, "Invitation sent date updated for guest: {0}", guestId);
            }
            return success;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating invitation sent date for guest " + guestId + ": " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Bulk update invitation sent dates for multiple guests
     * @param guestIds
     * @return 
     */
    public boolean bulkUpdateInvitationSentDates(List<Integer> guestIds) {
        if (guestIds == null || guestIds.isEmpty()) {
            return true;
        }

        String sql = "UPDATE Guests SET invitationSentDate = CURRENT_TIMESTAMP WHERE guestID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false);
            int successCount = 0;
            
            for (Integer guestId : guestIds) {
                pstmt.setInt(1, guestId);
                pstmt.addBatch();
            }
            
            int[] results = pstmt.executeBatch();
            conn.commit();
            
            for (int result : results) {
                if (result > 0) {
                    successCount++;
                }
            }
            
            LOGGER.log(Level.INFO, "Bulk invitation date update: {0}/{1} successful", 
                      new Object[]{successCount, guestIds.size()});
            return successCount == guestIds.size();
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error bulk updating invitation dates", e);
            return false;
        }
    }

    /**
     * Deletes a guest from the database.
     * @param guestId The ID of the guest to delete.
     * @return true if the guest was deleted successfully, false otherwise.
     */
    public boolean deleteGuest(int guestId) {
        String sql = "DELETE FROM Guests WHERE guestID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, guestId);
            int rowsAffected = pstmt.executeUpdate();
            boolean success = rowsAffected > 0;
            if (success) {
                LOGGER.log(Level.INFO, "Guest deleted successfully: {0}", guestId);
            }
            return success;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting guest: " + e.getMessage(), e);
            return false;
        }
    }
 /**
     * Extracts Guest object from ResultSet (helper method)
     */
    private Guest extractGuestFromResultSet(ResultSet rs) throws SQLException {
        Guest guest = new Guest();
        guest.setGuestId(rs.getInt("guestID"));
        guest.setEventId(rs.getInt("eventID"));
        guest.setName(rs.getString("name"));
        guest.setEmail(rs.getString("email"));
        guest.setPhone(rs.getString("phone"));
        guest.setRsvpStatus(rs.getString("rsvpStatus"));
        guest.setInvitationSentDate(rs.getTimestamp("invitationSentDate"));
        guest.setRsvpResponseDate(rs.getTimestamp("rsvpResponseDate"));
        return guest;
    }
}
