// src/main/java/com/ems/service/GuestManager.java
package com.ems.service;

import com.ems.model.Event;
import com.ems.dao.GuestDAO;
import com.ems.model.Guest;
import java.util.List;
import java.util.ArrayList; // For bulk operations
import jakarta.mail.MessagingException; // To catch email errors
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GuestManager {
    private static final Logger LOGGER = Logger.getLogger(GuestManager.class.getName());
    private GuestDAO guestDAO;
    private EventManager eventManager; // Required to fetch event details
    

    public GuestManager() {
        this.guestDAO = new GuestDAO();
        this.eventManager = new EventManager(); // Initialize EventManager
    }
    
    /**
        * Retrieves a single guest by ID, typically for public RSVP links.
        * @param guestId The ID of the guest to retrieve.
        * @return The Guest object or null if not found.
        */
       public Guest getGuestById(int guestId) {
           // Delegates the call to the Data Access Object (DAO)
           return guestDAO.getGuestById(guestId);
       }

    /**
     * Creates a new guest for a specific event.
     * @param eventId The ID of the event the guest belongs to.
     * @param name The guest's name.
     * @param email The guest's email (optional).
     * @param phone The guest's phone number (optional).
     * @return true if the guest was added successfully, false otherwise.
     */
    public boolean createGuest(int eventId, String name, String email, String phone) {
        if (eventId <= 0 || name == null || name.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Invalid data for creating guest. Event ID: {0}, Name: {1}", 
                      new Object[]{eventId, name});
            return false;
        }
        
        // Validate email format if provided
        if (email != null && !email.trim().isEmpty() && !isValidEmail(email)) {
            LOGGER.log(Level.WARNING, "Invalid email format: {0}", email);
            return false;
        }
        Guest newGuest = new Guest(eventId, name.trim(), email != null ? email.trim() : null, phone != null ? phone.trim() : null);
        return guestDAO.addGuest(newGuest);
    }

    /**
     * Retrieves all guests for a given event.
     * @param eventId The ID of the event.
     * @return A list of Guest objects.
     */
    public List<Guest> getGuestsForEvent(int eventId) {
        if (eventId <= 0) {
           LOGGER.log(Level.WARNING, "Invalid Event ID for retrieving guests: {0}", eventId);
            return new ArrayList<>();
        }
        return guestDAO.getGuestsByEventId(eventId);
    }

    /**
     * Updates an existing guest's details.
     * @param guest The Guest object with updated information.
     * @return true if the guest was updated successfully, false otherwise.
     */
    public boolean updateGuest(Guest guest) {
        if (guest == null || guest.getGuestId() <= 0 || guest.getName().trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Invalid guest data for update");
            return false;
        }
        return guestDAO.updateGuest(guest);
    }

    /**
     * Updates the RSVP status of a guest.
     * @param guestId The ID of the guest.
     * @param status The new RSVP status ("Pending", "Confirmed", "Declined").
     * @return true if the status was updated successfully, false otherwise.
     */
    public boolean updateRsvpStatus(int guestId, String status) {
        if (guestId <= 0 || status == null || status.trim().isEmpty()) {
            System.err.println("GuestManager: Invalid guest ID or status for RSVP update.");
            return false;
        }
        // Basic validation for allowed RSVP statuses
        if (!("Pending".equalsIgnoreCase(status) || "Confirmed".equalsIgnoreCase(status) || "Declined".equalsIgnoreCase(status))) {
             LOGGER.log(Level.WARNING, "Invalid RSVP status provided: {0}", status);
            return false;
        }
        return guestDAO.updateRsvpStatus(guestId, status.trim());
    }

    /**
     * Deletes a guest from the database.
     * @param guestId The ID of the guest to delete.
     * @return true if the guest was deleted successfully, false otherwise.
     */
    public boolean deleteGuest(int guestId) {
        if (guestId <= 0) {
            LOGGER.log(Level.WARNING, "Invalid guest ID for deletion: {0}", guestId);
            return false;
        }
        return guestDAO.deleteGuest(guestId);
    }

    /**
     * Sends digital invitations to a list of guests for an event using EmailService.
     * @param guestIds A list of guest IDs to send invitations to (SELECTED by the host).
     * @param eventId The ID of the event.
     * @return true if ALL selected invitations were processed, false if critical errors occurred.
     */
    public boolean sendInvitations(List<Integer> guestIds, int eventId) {
        if (guestIds == null || guestIds.isEmpty()) {
            LOGGER.log(Level.INFO, "No guests selected for sending invitations.");
            return true;
        }

        // 1. Fetch Event Details
        Event event = eventManager.getEventById(eventId);
        if (event == null) {
            LOGGER.log(Level.SEVERE, "Event not found for ID: {0}. Cannot send invitations.", eventId);
            return false;
        }

        // 2. Fetch Guest Objects (CORRECTED LOGIC) 🚀
        // Use the bulk retrieval method to fetch ONLY the guests whose IDs were selected.
        List<Guest> guests = guestDAO.getGuestsByIds(guestIds); 
        int successfulSends = 0;
         List<Integer> successfullySentGuestIds = new ArrayList<>();
        LOGGER.log(Level.INFO, "Starting invitation process for Event ID {0} ({1}) to {2} selected guests.", 
                   new Object[]{eventId, event.getType(), guests.size()});

        for (Guest guest : guests) {
            if (guest.getEmail() == null || guest.getEmail().trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "Skipping guest {0} (ID: {1}): No valid email address.", new Object[]{guest.getName(), guest.getGuestId()});
                continue;
            }

            try {
                // --- A. Construct RSVP Link ---
                // Ensure URL encoding for the event title in the link
                String eventTitleEncoded = URLEncoder.encode(event.getType(), "UTF-8");
                String guestNameEncoded = URLEncoder.encode(guest.getName(), "UTF-8");
                
                String rsvpUrl = "http://localhost:8080/ems/rsvpServlet" + // Changed to rsvpServlet for initial load 
                                 "?eventID=" + event.getEventId() +
                                 "&guestID=" + guest.getGuestId() + 
                                 "&title=" + eventTitleEncoded +
                                 "&name=" + guestNameEncoded;
                
                String subject = "You're Invited: " + event.getType();
                String emailBody = generateEmailBody(event, guest, rsvpUrl);
                
                LOGGER.log(Level.INFO, "Recipient string being sent: {0}", guest.getEmail());
                    

                // --- B. Send Email via Service ---
                EmailService.sendEmail(guest.getEmail(), subject, emailBody);
                successfullySentGuestIds.add(guest.getGuestId());
                //successfulSends++;

                // --- C. Update Database Status ---
                guestDAO.updateInvitationSentDate(guest.getGuestId());
                successfulSends++;
                
                LOGGER.log(Level.INFO, "Invitation sent successfully to: {0} ({1})", new Object[]{guest.getName(), guest.getEmail()});

            } catch (MessagingException e) {
                LOGGER.log(Level.SEVERE, "EMAIL SEND FAILED for guest " + guest.getEmail(), e);
            } catch (UnsupportedEncodingException e) {
                LOGGER.log(Level.SEVERE, "Error encoding URL parameters.", e);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "General error during invitation process for guest " + guest.getGuestId(), e);
            }
        }
        
        // Bulk update invitation sent dates for successful sends
        if (!successfullySentGuestIds.isEmpty()) {
            guestDAO.bulkUpdateInvitationSentDates(successfullySentGuestIds);
        }

        LOGGER.log(Level.INFO, "Invitation process completed: {0}/{1} successful", 
                  new Object[]{successfulSends, guestIds.size()});
        
        return successfulSends > 0;
    }
    /**
     * Generates a simple HTML body for the invitation email.
     */
    private String generateEmailBody(Event event, Guest guest, String rsvpUrl) {
        // NOTE: For production, this should load an HTML template.
        return "Dear " + guest.getName() + ",\n\n" +
               "We are excited to invite you to " + event.getType() + 
               " on " + event.getDate() + " at " + event.getLocation() + ".\n\n" +
               "Please click the link below to confirm your attendance:\n" + rsvpUrl + "\n\n" +
               "We look forward to celebrating with you!\n\n" +
               "Best Regards,\nThe Event Management Team";
    }
    /**
     * Gets guest statistics for an event
     */
    public Map<String, Integer> getGuestStatistics(int eventId) {
        Map<String, Integer> stats = new HashMap<>();
        List<Guest> guests = getGuestsForEvent(eventId);
        
        int totalGuests = guests.size();
        int pendingGuests = (int) guests.stream()
                .filter(g -> "Pending".equalsIgnoreCase(g.getRsvpStatus()))
                .count();
        int confirmedGuests = (int) guests.stream()
                .filter(g -> "Confirmed".equalsIgnoreCase(g.getRsvpStatus()))
                .count();
        int declinedGuests = (int) guests.stream()
                .filter(g -> "Declined".equalsIgnoreCase(g.getRsvpStatus()))
                .count();
        
        stats.put("totalGuests", totalGuests);
        stats.put("pendingGuests", pendingGuests);
        stats.put("confirmedGuests", confirmedGuests);
        stats.put("declinedGuests", declinedGuests);
        
        return stats;
    }

    /**
     * Validates email format
     */
    private boolean isValidEmail(String email) {
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }
    
    
    /**
     * Simulates importing guests from a file.
     * For a real application, this would parse a CSV/Excel file.
     * Currently, this is a placeholder for future implementation.
     * @param eventId The event ID to associate guests with.
     * @param fileContent A string representing file content (e.g., CSV lines).
     * @return true if import is successful (simulated), false otherwise.
     */
    public boolean importGuests(int eventId, String fileContent) {
        LOGGER.log(Level.INFO, "Simulating guest import for Event ID {0}", eventId);
        // Placeholder implementation
        // In real implementation, parse CSV/Excel and call guestDAO.addGuest for each record
        return true;
    }
}

