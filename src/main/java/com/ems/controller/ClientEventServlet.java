// src/main/java/com/ems/controller/ClientEventServlet.java
package com.ems.controller;

import com.ems.dao.EventDAO;
import com.ems.model.User;
import com.ems.model.Event;
import com.ems.model.Vendor;
import com.ems.service.EventManager;
import com.ems.dao.VendorDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import java.util.logging.Logger;

/**
 * Complete servlet for handling ALL customer event operations including
 * dashboard display, event creation, editing, cancellation, and vendor selection.
 */
@WebServlet("/client/event-action")
public class ClientEventServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ClientEventServlet.class.getName());
    
    private EventManager eventManager;
    private VendorDAO vendorDAO;
    private EventDAO eventDAO;
    
    
    // Validation patterns
    private static final Pattern EVENT_TYPE_PATTERN = Pattern.compile("^[a-zA-Z0-9\\s-]{1,50}$");
    private static final Pattern LOCATION_PATTERN = Pattern.compile("^[a-zA-Z0-9\\s,.-]{1,100}$");
    private static final Pattern DESCRIPTION_PATTERN = Pattern.compile("^[a-zA-Z0-9\\s,.-]{0,500}$");

    @Override
    public void init() throws ServletException {
        super.init();
        eventManager = new EventManager();
        vendorDAO = new VendorDAO();
        eventDAO = new EventDAO();
        LOGGER.info("ClientEventServlet initialized successfully");
    }

    /**
     * Handles GET requests to display event forms and dashboard
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // --- Authorization Check ---
        if (!isCustomerAuthenticated(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                // Default to dashboard if no action specified
                handleDashboardView(request, response, (User) session.getAttribute("loggedInUser"));
                return;
            }

            switch (action) {
                case "dashboard":
                    handleDashboardView(request, response, (User) session.getAttribute("loggedInUser"));
                    break;
                case "create":
                    handleCreateFormView(request, response);
                    break;
                case "edit":
                    handleEditFormView(request, response, (User) session.getAttribute("loggedInUser"));
                    break;
                default:
                    // Default to dashboard for unknown actions
                    handleDashboardView(request, response, (User) session.getAttribute("loggedInUser"));
                    break;
            }
        } catch (NumberFormatException e) {
            sendErrorRedirect(response, request, "Invalid Event ID format.");
        } catch (Exception e) {
            LOGGER.severe("Error in doGet: " + e.getMessage());
            sendErrorRedirect(response, request, "An unexpected server error occurred: " + e.getMessage());
        }
    }

    /**
     * Handles POST requests for event management actions including creation, editing, and cancellation.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String messageType = "errorMessage";
        String messageText = "An unknown error occurred.";

        // --- Authorization Check ---
        if (!isCustomerAuthenticated(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");

        if (action == null) {
            sendErrorRedirect(response, request, "Action parameter is required.");
            return;
        }

        try {
            boolean success = false;

            switch (action) {
                case "create":
                    success = handleEventCreation(request, loggedInUser);
                    messageText = success ? "Event created successfully! The event is pending approval." : "Failed to create event.";
                    break;
                case "cancel":
                    success = handleEventCancellation(request, loggedInUser);
                    messageText = success ? "Event cancelled successfully!" : "Failed to cancel event. It might already be completed or cancelled.";
                    break;
                case "edit":
                    success = handleEventUpdate(request, loggedInUser);
                    messageText = success ? "Event updated successfully!" : "Failed to update event.";
                    break;
                default:
                    messageText = "Invalid action specified.";
                    break;
            }

            if (success) {
                messageType = "successMessage";
                LOGGER.info(String.format("Action '%s' completed successfully for user: %d", action, loggedInUser.getUserId()));
            } else {
                LOGGER.warning(String.format("Action '%s' failed for user: %d", action, loggedInUser.getUserId()));
            }

        } catch (NumberFormatException e) {
            messageText = "Invalid number format for event ID, budget, or guest count.";
            LOGGER.warning("Number format exception: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            messageText = e.getMessage();
            LOGGER.warning("Validation error: " + e.getMessage());
        } catch (Exception e) {
            messageText = "Server error processing your request: " + e.getMessage();
            LOGGER.severe("Unexpected error: " + e.getMessage());
        }

        sendRedirectWithMessage(response, request, messageType, messageText);
    }

    // === VIEW HANDLING METHODS ===

    private void handleDashboardView(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws ServletException, IOException {
        try {
            // Use the method that includes vendor data
            List<Event> events = eventDAO.getEventsByClientIdWithVendors(loggedInUser.getUserId());
            List<Vendor> approvedVendors = vendorDAO.getApprovedVendors();
            
            request.setAttribute("events", events);
            request.setAttribute("approvedVendors", approvedVendors);
            request.getRequestDispatcher("/client_dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.severe("Error loading client dashboard: " + e.getMessage());
            throw new ServletException("Failed to load dashboard data", e);
        }
    }

    private void handleCreateFormView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Vendor> approvedVendors = vendorDAO.getApprovedVendors();
            request.setAttribute("approvedVendors", approvedVendors);
            request.getRequestDispatcher("/create_event.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error loading create event form: " + e.getMessage());
            sendErrorRedirect(response, request, "Error loading event creation form.");
        }
    }

    private void handleEditFormView(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            sendErrorRedirect(response, request, "Event ID is required for editing.");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event eventToEdit = eventManager.getEventWithVendors(eventId); // Use method that includes vendors

            // Security check: Verify event ownership
            if (eventToEdit == null || eventToEdit.getClientId() != loggedInUser.getUserId()) {
                sendErrorRedirect(response, request, "Event not found or you don't have permission to edit it.");
                return;
            }

            // Check if event is already cancelled or completed
            if ("Cancelled".equalsIgnoreCase(eventToEdit.getStatus()) || 
                "Completed".equalsIgnoreCase(eventToEdit.getStatus())) {
                sendErrorRedirect(response, request, "Cannot edit event that is already " + eventToEdit.getStatus() + ".");
                return;
            }

            List<Vendor> approvedVendors = vendorDAO.getApprovedVendors();
            request.setAttribute("approvedVendors", approvedVendors);
            request.setAttribute("event", eventToEdit);
            request.getRequestDispatcher("/edit-event.jsp").forward(request, response); // Fixed JSP name
            
        } catch (NumberFormatException e) {
            sendErrorRedirect(response, request, "Invalid Event ID format.");
        } catch (Exception e) {
            LOGGER.severe("Error loading edit form: " + e.getMessage());
            sendErrorRedirect(response, request, "Error loading event edit form.");
        }
    }

    // === ACTION HANDLING METHODS ===

    private boolean handleEventCreation(HttpServletRequest request, User loggedInUser) {
    try {
        // Validate and extract event parameters
        String type = request.getParameter("type");
        String dateStr = request.getParameter("date");
        String budgetStr = request.getParameter("budget");
        String description = request.getParameter("description");
        String guestCountStr = request.getParameter("guestCount");
        String locationPreference = request.getParameter("locationPreference");
        String location = request.getParameter("location");

        // Validate required fields
        validateRequiredFields(type, dateStr, budgetStr);

        // Validate field formats
        validateFieldFormats(type, description, locationPreference, location);

        // Parse and validate data
        Date date = validateAndParseDate(dateStr.trim());
        BigDecimal budget = validateAndParseBudget(budgetStr.trim());
        Integer guestCount = parseGuestCount(guestCountStr);

        // Process vendor selections
        List<Integer> selectedVendorIds = processVendorSelections(request);
        
        LOGGER.info("Creating event for user " + loggedInUser.getUserId() + 
                   " with " + (selectedVendorIds != null ? selectedVendorIds.size() : 0) + " vendors");

        // Create event using individual parameters (current EventManager signature)
        boolean success = eventManager.addEvent(
            loggedInUser.getUserId(), 
            type.trim(), 
            date, 
            budget, 
            description != null ? description.trim() : "",
            guestCount, 
            locationPreference != null ? locationPreference.trim() : "",
            location != null ? location.trim() : "",
            selectedVendorIds
        );
        
        if (success) {
            LOGGER.info("Event created successfully for user: " + loggedInUser.getUserId());
        } else {
            LOGGER.warning("Failed to create event for user: " + loggedInUser.getUserId());
        }
        
        return success;
        
    } catch (Exception e) {
        LOGGER.severe("Error in handleEventCreation: " + e.getMessage());
        throw e; // Re-throw to be handled by the main method
    }
}

    private boolean handleEventCancellation(HttpServletRequest request, User loggedInUser) {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            throw new IllegalArgumentException("Event ID is required for cancellation.");
        }

        int eventId = Integer.parseInt(eventIdStr);
        
        // Verify event ownership and status
        Event event = eventManager.getEventById(eventId);
        if (event == null || event.getClientId() != loggedInUser.getUserId()) {
            throw new IllegalArgumentException("Event not found or you don't have permission to cancel it.");
        }

        if ("Cancelled".equalsIgnoreCase(event.getStatus()) || "Completed".equalsIgnoreCase(event.getStatus())) {
            throw new IllegalArgumentException("Cannot cancel event that is already " + event.getStatus() + ".");
        }

        return eventManager.cancelEvent(eventId);
    }

    private boolean handleEventUpdate(HttpServletRequest request, User loggedInUser) {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            throw new IllegalArgumentException("Event ID is required for editing.");
        }

        int eventId = Integer.parseInt(eventIdStr);
        
        // Fetch existing event and verify ownership
        Event eventToUpdate = eventManager.getEventById(eventId);
        if (eventToUpdate == null || eventToUpdate.getClientId() != loggedInUser.getUserId()) {
            throw new IllegalArgumentException("Event not found or you don't have permission to edit it.");
        }

        // Check if event is already cancelled or completed
        if ("Cancelled".equalsIgnoreCase(eventToUpdate.getStatus()) || "Completed".equalsIgnoreCase(eventToUpdate.getStatus())) {
            throw new IllegalArgumentException("Cannot edit event that is already " + eventToUpdate.getStatus() + ".");
        }

        // Update event fields from request parameters
        updateEventFromRequest(eventToUpdate, request);

        // Process vendor selections for update
        List<Integer> selectedVendorIds = processVendorSelections(request);
        
        // Update event with vendors
        return eventManager.updateEventWithVendors(eventToUpdate, selectedVendorIds);
    }

    // === VENDOR MANAGEMENT ===

    private List<Integer> processVendorSelections(HttpServletRequest request) {
        List<Integer> vendorIds = new ArrayList<>();
        String[] vendorIdArray = request.getParameterValues("vendorIds"); // FIXED: Use correct parameter name
        
        if (vendorIdArray != null) {
            for (String vendorIdStr : vendorIdArray) {
                if (vendorIdStr != null && !vendorIdStr.trim().isEmpty()) {
                    try {
                        int vendorId = Integer.parseInt(vendorIdStr.trim());
                        if (vendorId > 0) {
                            vendorIds.add(vendorId);
                        }
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid vendor ID: " + vendorIdStr);
                    }
                }
            }
        }
        
        LOGGER.info("Processed " + vendorIds.size() + " vendor selections");
        return vendorIds;
    }

    // === VALIDATION METHODS ===

    private void validateRequiredFields(String type, String dateStr, String budgetStr) {
        if (type == null || type.trim().isEmpty()) {
            throw new IllegalArgumentException("Event Type is required.");
        }
        if (dateStr == null || dateStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Event Date is required.");
        }
        if (budgetStr == null || budgetStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Event Budget is required.");
        }
    }

    private void validateFieldFormats(String type, String description, String locationPreference, String location) {
        if (!isValidEventType(type.trim())) {
            throw new IllegalArgumentException("Invalid event type format. Only letters, numbers, spaces, and hyphens are allowed (max 50 characters).");
        }
        
        if (description != null && !description.trim().isEmpty() && !isValidDescription(description.trim())) {
            throw new IllegalArgumentException("Description contains invalid characters or is too long (max 500 characters).");
        }
        
        if (locationPreference != null && !locationPreference.trim().isEmpty() && !isValidLocation(locationPreference.trim())) {
            throw new IllegalArgumentException("Invalid location preference format.");
        }
        
        if (location != null && !location.trim().isEmpty() && !isValidLocation(location.trim())) {
            throw new IllegalArgumentException("Invalid location format.");
        }
    }

    private void updateEventFromRequest(Event event, HttpServletRequest request) {
        String newType = request.getParameter("type");
        String newDateStr = request.getParameter("date");
        String newBudgetStr = request.getParameter("budget");
        String newDescription = request.getParameter("description");
        String newGuestCountStr = request.getParameter("guestCount");
        String newLocationPreference = request.getParameter("locationPreference");
        String newLocation = request.getParameter("location");

        if (newType != null && !newType.trim().isEmpty()) {
            if (!isValidEventType(newType.trim())) {
                throw new IllegalArgumentException("Invalid event type format.");
            }
            event.setType(newType.trim());
        }

        if (newDateStr != null && !newDateStr.trim().isEmpty()) {
            event.setDate(validateAndParseDate(newDateStr.trim()));
        }

        if (newBudgetStr != null && !newBudgetStr.trim().isEmpty()) {
            event.setBudget(validateAndParseBudget(newBudgetStr.trim()));
        }

        if (newDescription != null) {
            if (!newDescription.trim().isEmpty() && !isValidDescription(newDescription.trim())) {
                throw new IllegalArgumentException("Description contains invalid characters or is too long.");
            }
            event.setDescription(newDescription.trim());
        }

        if (newGuestCountStr != null && !newGuestCountStr.trim().isEmpty()) {
            event.setGuestCount(validateAndParseGuestCount(newGuestCountStr.trim()));
        }

        if (newLocationPreference != null) {
            if (!newLocationPreference.trim().isEmpty() && !isValidLocation(newLocationPreference.trim())) {
                throw new IllegalArgumentException("Invalid location preference format.");
            }
            event.setLocationPreference(newLocationPreference.trim());
        }

        if (newLocation != null) {
            if (!newLocation.trim().isEmpty() && !isValidLocation(newLocation.trim())) {
                throw new IllegalArgumentException("Invalid location format.");
            }
            event.setLocation(newLocation.trim());
        }
    }

    private Date validateAndParseDate(String dateStr) {
        try {
            LocalDate localDate = LocalDate.parse(dateStr);
            LocalDate today = LocalDate.now();
            
            if (localDate.isBefore(today)) {
                throw new IllegalArgumentException("Event date cannot be in the past.");
            }
            
            LocalDate maxDate = today.plusYears(2);
            if (localDate.isAfter(maxDate)) {
                throw new IllegalArgumentException("Event date cannot be more than 2 years in the future.");
            }
            
            return Date.valueOf(localDate);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid date format. Please use YYYY-MM-DD and ensure it's a valid date.");
        }
    }

    private BigDecimal validateAndParseBudget(String budgetStr) {
        try {
            BigDecimal budget = new BigDecimal(budgetStr);
            
            if (budget.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Budget must be greater than zero.");
            }
            
            if (budget.compareTo(new BigDecimal("1000000")) > 0) {
                throw new IllegalArgumentException("Budget cannot exceed $1,000,000.");
            }
            
            return budget;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid budget format. Please enter a valid number.");
        }
    }

    private Integer parseGuestCount(String guestCountStr) {
        if (guestCountStr == null || guestCountStr.trim().isEmpty()) {
            return null;
        }
        return validateAndParseGuestCount(guestCountStr.trim());
    }

    private Integer validateAndParseGuestCount(String guestCountStr) {
        try {
            int guestCount = Integer.parseInt(guestCountStr);
            
            if (guestCount <= 0) {
                throw new IllegalArgumentException("Guest count must be greater than zero.");
            }
            
            if (guestCount > 10000) {
                throw new IllegalArgumentException("Guest count cannot exceed 10,000.");
            }
            
            return guestCount;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid guest count format. Please enter a valid number.");
        }
    }

    private boolean isValidEventType(String eventType) {
        return EVENT_TYPE_PATTERN.matcher(eventType).matches();
    }

    private boolean isValidLocation(String location) {
        return LOCATION_PATTERN.matcher(location).matches();
    }

    private boolean isValidDescription(String description) {
        return DESCRIPTION_PATTERN.matcher(description).matches();
    }

    // === UTILITY METHODS ===

    private boolean isCustomerAuthenticated(HttpSession session) {
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }
        User user = (User) session.getAttribute("loggedInUser");
        return "customer".equalsIgnoreCase(user.getRole()) || "client".equalsIgnoreCase(user.getRole());
    }

    private void sendErrorRedirect(HttpServletResponse response, HttpServletRequest request, String errorMessage) throws IOException {
        String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
        response.sendRedirect(request.getContextPath() + "/client/dashboard?errorMessage=" + encodedMessage);
    }

    private void sendRedirectWithMessage(HttpServletResponse response, HttpServletRequest request, String messageType, String messageText) throws IOException {
        String encodedMessage = URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString());
        String redirectUrl = request.getContextPath() + "/client/dashboard?" + messageType + "=" + encodedMessage;
        response.sendRedirect(redirectUrl);
    }
}