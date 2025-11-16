// src/main/java/com/ems/controller/RsvpServlet.java
package com.ems.controller;

import com.ems.model.Guest;
import com.ems.model.Event;
import com.ems.service.GuestManager; 
import com.ems.service.EventManager; // Needed to fetch event details

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for processing public RSVP responses submitted via rsvp.jsp.
 * This does NOT require a session/login, as it handles responses from external links.
 */
@WebServlet("/rsvpServlet") 
public class RsvpServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RsvpServlet.class.getName());
    private static final long serialVersionUID = 1L;
    
    private GuestManager guestManager;
    private EventManager eventManager; // Added EventManager

    @Override
    public void init() throws ServletException {
        super.init();
        guestManager = new GuestManager();
        eventManager = new EventManager(); // Initialize EventManager
    }

    /**
     * Handles GET requests when the guest clicks the invitation link.
     * Fetches event and guest data and forwards to rsvp.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String eventIdStr = request.getParameter("eventID");
        String guestIdStr = request.getParameter("guestID");

        if (eventIdStr == null || guestIdStr == null) {
            // Handle missing parameters - redirect to a generic error page or show a friendly message
            request.setAttribute("errorMessage", "Invalid invitation link.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            int guestId = Integer.parseInt(guestIdStr);
            
            // 1. Fetch Guest and Event objects
            Guest guest = guestManager.getGuestById(guestId);
            Event event = eventManager.getEventById(eventId);
            
            if (guest == null || event == null) {
                request.setAttribute("errorMessage", "The event or guest record could not be found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // 2. Attach data to the request for rsvp.jsp
            request.setAttribute("guest", guest);
            request.setAttribute("event", event);
            
            // 3. Forward to the display page (rsvp.jsp)
            // The JSP will use the attributes to pre-populate the form and display event details.
            request.getRequestDispatcher("/rsvp.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid ID format in RSVP link: " + e.getMessage());
            request.setAttribute("errorMessage", "The IDs in the link are in an incorrect format.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching data for RSVP page.", e);
            request.setAttribute("errorMessage", "A server error occurred while loading the RSVP page.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Handles POST requests from the rsvp.jsp form to record the guest's response.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // --- (EXISTING doPost CODE REMAINS HERE) ---
        
        String eventIdStr = request.getParameter("eventID");
        String guestIdStr = request.getParameter("guestID");
        String rsvpStatus = request.getParameter("rsvp_status"); // "Confirmed" or "Declined"
        String comment = request.getParameter("comment"); // Optional message
        
        // Note: The following parameters are not needed for a clean forward/redirect. 
        // We will just fetch the Guest and Event again to set attributes for the forward.
        // String eventType = request.getParameter("eventType"); // REMOVED/UNUSED
        // String guestName = request.getParameter("name");       // REMOVED/UNUSED
        
        String messageType = "error";
        String messageText = "An error occurred while submitting your RSVP.";

        // 1. Basic Validation
        if (eventIdStr == null || guestIdStr == null || rsvpStatus == null || rsvpStatus.isEmpty()) {
            messageText = "Missing required information (Event or Guest ID). Please check your link.";
        } else {
            try {
                int guestId = Integer.parseInt(guestIdStr);
                
                // 2. Process RSVP Update
                boolean updateSuccess = guestManager.updateRsvpStatus(guestId, rsvpStatus);
                
                if (updateSuccess) {
                    messageType = "success";
                    messageText = "Thank you, your attendance status (" + rsvpStatus + ") has been recorded! We look forward to seeing you!";
                    
                    // TODO: Implement guestManager.updateGuestComment(guestId, comment); if needed

                } else {
                    messageText = "We could not record your RSVP. Please ensure your invitation link is correct or contact the host.";
                }
                
            } catch (NumberFormatException e) {
                messageText = "Invalid ID format in the invitation link.";
                LOGGER.log(Level.WARNING, "Invalid ID format in RSVP submission: " + e.getMessage());
            } catch (Exception e) {
                messageText = "A server error prevented the RSVP update.";
                LOGGER.log(Level.SEVERE, "Unexpected error during RSVP processing.", e);
            }
        }
        
        // 3. Re-fetch data and Forward back to rsvp.jsp
        // The doPost must re-execute the doGet logic to properly display the rsvp.jsp
        // along with the success/error message.
        
        // Fetch event and guest again to ensure JSP has up-to-date model data (especially the new rsvpStatus)
        try {
            int eventId = Integer.parseInt(eventIdStr);
            int guestId = Integer.parseInt(guestIdStr);
            
            request.setAttribute("guest", guestManager.getGuestById(guestId));
            request.setAttribute("event", eventManager.getEventById(eventId));
        } catch (NumberFormatException e) {
            // If IDs are bad, we'll just forward without proper models, relying on the error message.
        }
        
        // Set attributes for the rsvp.jsp to display the status message
        request.setAttribute("messageType", messageType);
        request.setAttribute("messageText", messageText);
        
        // Use request dispatcher to send attributes and stay on the same visual page
        request.getRequestDispatcher("/rsvp.jsp").forward(request, response);
    }
}