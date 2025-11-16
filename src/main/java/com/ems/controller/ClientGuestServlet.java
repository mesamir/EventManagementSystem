package com.ems.controller;

import com.ems.model.User;
import com.ems.model.Event;
import com.ems.model.Guest;
import com.ems.service.EventManager;
import com.ems.service.GuestManager;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Servlet for managing the guest list for a specific event.
 * This servlet handles both GET requests (to display the guest list) and
 * POST requests (to add, update, or delete guests) for a customer's event.
 * It ensures that only the event owner can modify the guest list.
 */
@WebServlet("/client/guests")
public class ClientGuestServlet extends HttpServlet {
    private EventManager eventManager;
    private GuestManager guestManager;

    @Override
    public void init() throws ServletException {
        super.init();
        eventManager = new EventManager();
        guestManager = new GuestManager();
    }

    /**
     * Handles GET requests to display the guest list for a given event.
     * It fetches the event and its associated guests, and forwards to the
     * manage_guests.jsp page.
     *
     * @param request The HttpServletRequest object, expecting an "eventId" parameter.
     * @param response The HttpServletResponse object.
     * @throws ServletException if a servlet-specific error occurs.
     * @throws IOException if an I/O error occurs.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // --- Authorization Check ---
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"customer".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Only Customers can manage guests.");
            return;
        }

        String eventIdStr = request.getParameter("eventId");
        String messageType = request.getParameter("messageType");
        String messageText = request.getParameter("messageText");

        if (eventIdStr == null || eventIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard?errorMessage=" +
                                 URLEncoder.encode("Event ID is required to manage guests.", StandardCharsets.UTF_8.toString()) + "#my-events");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventManager.getEventById(eventId);

            if (event == null || event.getClientId() != loggedInUser.getUserId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Event not found or you do not own this event.");
                return;
            }

            List<Guest> guests = guestManager.getGuestsForEvent(eventId);
            Map<String, Integer> stats = guestManager.getGuestStatistics(eventId);

            request.setAttribute("event", event);
            request.setAttribute("guests", guests);
            request.setAttribute("messageType", messageType);
            request.setAttribute("messageText", messageText);
             request.setAttribute("totalGuests", stats.get("totalGuests"));
            request.setAttribute("pendingGuests", stats.get("pendingGuests"));
            request.setAttribute("confirmedGuests", stats.get("confirmedGuests"));
            request.setAttribute("declinedGuests", stats.get("declinedGuests"));

            request.getRequestDispatcher("/manage_guests.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/client/dashboard?errorMessage=" +
                                 URLEncoder.encode("Invalid Event ID format.", StandardCharsets.UTF_8.toString()) + "#my-events");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/client/dashboard?errorMessage=" +
                                 URLEncoder.encode("An error occurred while loading guest list: " + e.getMessage(), StandardCharsets.UTF_8.toString()) + "#my-events");
        }
    }

    /**
     * Handles POST requests for various guest management actions (add, update, delete, send invitations).
     *
     * @param request The HttpServletRequest object containing action and guest data.
     * @param response The HttpServletResponse object for redirecting.
     * @throws ServletException if a servlet-specific error occurs.
     * @throws IOException if an I/O error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

    String action = request.getParameter("action");
        String eventIdParam = request.getParameter("eventId");
        
        if (eventIdParam == null || eventIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Event ID is required");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdParam);
            String redirectUrl = request.getContextPath() + "/client/guests?eventId=" + eventId;

            switch (action) {
                case "addGuest":
                    handleAddGuest(request, response, eventId, redirectUrl);
                    break;
                case "updateGuest":
                    handleUpdateGuest(request, response, eventId, redirectUrl);
                    break;
                case "updateRsvp":
                    handleUpdateRsvp(request, response, eventId, redirectUrl);
                    break;
                case "deleteGuest":
                    handleDeleteGuest(request, response, eventId, redirectUrl);
                    break;
                case "sendInvitations":
                    handleSendInvitations(request, response, eventId, redirectUrl);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Event ID format");
        }
    }

    private void handleAddGuest(HttpServletRequest request, HttpServletResponse response, int eventId, String redirectUrl) 
            throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (guestManager.createGuest(eventId, name, email, phone)) {
            response.sendRedirect(redirectUrl + "&messageType=success&messageText=Guest added successfully");
        } else {
            response.sendRedirect(redirectUrl + "&messageType=error&messageText=Failed to add guest");
        }
    }

    private void handleUpdateGuest(HttpServletRequest request, HttpServletResponse response, int eventId, String redirectUrl) 
            throws IOException {
        String guestIdParam = request.getParameter("guestId");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        try {
            int guestId = Integer.parseInt(guestIdParam);
            Guest guest = guestManager.getGuestById(guestId);
            if (guest != null) {
                guest.setName(name);
                guest.setEmail(email);
                guest.setPhone(phone);
                
                if (guestManager.updateGuest(guest)) {
                    response.sendRedirect(redirectUrl + "&messageType=success&messageText=Guest updated successfully");
                } else {
                    response.sendRedirect(redirectUrl + "&messageType=error&messageText=Failed to update guest");
                }
            } else {
                response.sendRedirect(redirectUrl + "&messageType=error&messageText=Guest not found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectUrl + "&messageType=error&messageText=Invalid guest ID");
        }
    }

    private void handleUpdateRsvp(HttpServletRequest request, HttpServletResponse response, int eventId, String redirectUrl) 
            throws IOException {
        String guestIdParam = request.getParameter("guestId");
        String rsvpStatus = request.getParameter("rsvpStatus");

        try {
            int guestId = Integer.parseInt(guestIdParam);
            if (guestManager.updateRsvpStatus(guestId, rsvpStatus)) {
                response.sendRedirect(redirectUrl + "&messageType=success&messageText=RSVP status updated");
            } else {
                response.sendRedirect(redirectUrl + "&messageType=error&messageText=Failed to update RSVP status");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectUrl + "&messageType=error&messageText=Invalid guest ID");
        }
    }

    private void handleDeleteGuest(HttpServletRequest request, HttpServletResponse response, int eventId, String redirectUrl) 
            throws IOException {
        String guestIdParam = request.getParameter("guestId");

        try {
            int guestId = Integer.parseInt(guestIdParam);
            if (guestManager.deleteGuest(guestId)) {
                response.sendRedirect(redirectUrl + "&messageType=success&messageText=Guest deleted successfully");
            } else {
                response.sendRedirect(redirectUrl + "&messageType=error&messageText=Failed to delete guest");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectUrl + "&messageType=error&messageText=Invalid guest ID");
        }
    }

    private void handleSendInvitations(HttpServletRequest request, HttpServletResponse response, int eventId, String redirectUrl) 
            throws IOException {
        String[] selectedGuests = request.getParameterValues("selectedGuests");
        
        if (selectedGuests == null || selectedGuests.length == 0) {
            response.sendRedirect(redirectUrl + "&messageType=error&messageText=No guests selected");
            return;
        }

        try {
            List<Integer> guestIds = new ArrayList<>();
            for (String guestId : selectedGuests) {
                guestIds.add(Integer.parseInt(guestId));
            }

            if (guestManager.sendInvitations(guestIds, eventId)) {
                response.sendRedirect(redirectUrl + "&messageType=success&messageText=Invitations sent successfully");
            } else {
                response.sendRedirect(redirectUrl + "&messageType=error&messageText=Failed to send some invitations");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectUrl + "&messageType=error&messageText=Invalid guest ID in selection");
        }
    }
}