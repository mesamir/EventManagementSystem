// src/main/java/com/ems/controller/AdminEventActionServlet.java
package com.ems.controller;

import com.ems.dao.EventDAO;
import com.ems.model.User;
import com.ems.model.Event;
import com.ems.model.Vendor;
import com.ems.service.EventManager;
import com.ems.service.VendorManager;
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
 * Complete servlet for handling ALL admin event operations
 */
@WebServlet("/admin/event-action")
public class AdminEventActionServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminEventActionServlet.class.getName());
    
    private EventManager eventManager;
    private VendorManager vendorManager;
    private EventDAO eventDAO;
    
    // Validation patterns
    private static final Pattern EVENT_TYPE_PATTERN = Pattern.compile("^[a-zA-Z0-9\\s-]{1,50}$");
    private static final Pattern LOCATION_PATTERN = Pattern.compile("^[a-zA-Z0-9\\s,.-]{1,100}$");
    private static final Pattern DESCRIPTION_PATTERN = Pattern.compile("^[a-zA-Z0-9\\s,.-]{0,500}$");

    @Override
    public void init() throws ServletException {
        super.init();
        eventManager = new EventManager();
        vendorManager = new VendorManager();
        eventDAO = new EventDAO();
        LOGGER.info("AdminEventServlet initialized successfully");
    }

    /**
     * Handles GET requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (!isAdminAuthenticated(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                handleDashboardView(request, response);
                return;
            }

            switch (action) {
                case "dashboard":
                    handleDashboardView(request, response);
                    break;
                case "createForm":
                    handleCreateFormView(request, response);
                    break;
                case "editForm":
                    handleEditFormView(request, response);
                    break;
                case "viewDetails":
                    handleEventDetailsView(request, response);
                    break;
                case "getEvent":
                    handleGetEventJson(request, response);
                    break;
                default:
                    handleDashboardView(request, response);
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
     * Handles POST requests
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String messageType = "error";
        String messageText = "An unknown error occurred.";

        if (!isAdminAuthenticated(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            sendErrorRedirect(response, request, "Action parameter is required.");
            return;
        }

        try {
            boolean success = false;

            switch (action) {
                case "create":
                    success = handleEventCreation(request);
                    messageText = success ? "Event created successfully!" : "Failed to create event.";
                    break;
                case "update":
                    success = handleEventUpdate(request);
                    messageText = success ? "Event updated successfully!" : "Failed to update event.";
                    break;
                case "approve":
                    success = handleEventApproval(request);
                    messageText = success ? "Event approved successfully!" : "Failed to approve event.";
                    break;
                case "reject":
                    success = handleEventRejection(request);
                    messageText = success ? "Event rejected successfully!" : "Failed to reject event.";
                    break;
                case "cancel":
                    success = handleEventCancellation(request);
                    messageText = success ? "Event cancelled successfully!" : "Failed to cancel event.";
                    break;
                case "delete":
                    success = handleEventDeletion(request);
                    messageText = success ? "Event deleted successfully!" : "Failed to delete event.";
                    break;
                default:
                    messageText = "Invalid action specified.";
                    break;
            }

            if (success) {
                messageType = "success";
                LOGGER.info(String.format("Admin action '%s' completed successfully", action));
            } else {
                LOGGER.warning(String.format("Admin action '%s' failed", action));
            }

        } catch (NumberFormatException e) {
            messageText = "Invalid number format for event ID, client ID, budget, or guest count.";
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

    private void handleDashboardView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Event> events = eventManager.getAllEventsWithVendors();
            List<Vendor> vendors = vendorManager.getAllVendors();
            
            request.setAttribute("events", events);
            request.setAttribute("vendors", vendors);
            request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.severe("Error loading admin dashboard: " + e.getMessage());
            throw new ServletException("Failed to load dashboard data", e);
        }
    }

    private void handleCreateFormView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Vendor> vendors = vendorManager.getAllVendors();
            request.setAttribute("vendors", vendors);
            request.getRequestDispatcher("/admin/create_event.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error loading create event form: " + e.getMessage());
            sendErrorRedirect(response, request, "Error loading event creation form.");
        }
    }

    private void handleEditFormView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            sendErrorRedirect(response, request, "Event ID is required for editing.");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event eventToEdit = eventManager.getEventWithVendors(eventId);

            if (eventToEdit == null) {
                sendErrorRedirect(response, request, "Event not found.");
                return;
            }

            List<Vendor> vendors = vendorManager.getAllVendors();
            request.setAttribute("vendors", vendors);
            request.setAttribute("event", eventToEdit);
            request.getRequestDispatcher("/admin/edit_event.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            sendErrorRedirect(response, request, "Invalid Event ID format.");
        } catch (Exception e) {
            LOGGER.severe("Error loading edit form: " + e.getMessage());
            sendErrorRedirect(response, request, "Error loading event edit form.");
        }
    }

    private void handleEventDetailsView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            sendErrorRedirect(response, request, "Event ID is required.");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventManager.getEventWithVendors(eventId);

            if (event == null) {
                sendErrorRedirect(response, request, "Event not found.");
                return;
            }

            List<Vendor> vendors = vendorManager.getAllVendors();
            request.setAttribute("event", event);
            request.setAttribute("vendors", vendors);
            request.getRequestDispatcher("/admin/event_details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            sendErrorRedirect(response, request, "Invalid Event ID format.");
        } catch (Exception e) {
            LOGGER.severe("Error loading event details: " + e.getMessage());
            sendErrorRedirect(response, request, "Error loading event details.");
        }
    }

    private void handleGetEventJson(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String eventIdStr = request.getParameter("eventId");
        
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Event ID is required\"}");
            return;
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventManager.getEventWithVendors(eventId);

            if (event == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\": \"Event not found\"}");
                return;
            }

            String json = convertEventToJson(event);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid Event ID format\"}");
        } catch (Exception e) {
            LOGGER.severe("Error generating event JSON: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Server error: " + e.getMessage() + "\"}");
        }
    }

    // === ACTION HANDLING METHODS ===

    private boolean handleEventCreation(HttpServletRequest request) {
        try {
            // Extract parameters
            String clientIdStr = request.getParameter("clientId");
            String type = request.getParameter("type");
            String dateStr = request.getParameter("date");
            String budgetStr = request.getParameter("budget");
            String description = request.getParameter("description");
            String guestCountStr = request.getParameter("guestCount");
            String locationPreference = request.getParameter("locationPreference");
            String location = request.getParameter("location");
            String status = request.getParameter("status");
            String advancePaidStr = request.getParameter("advancePaid");

            // Validate required fields
            validateRequiredFields(clientIdStr, type, dateStr, budgetStr);

            // Validate field formats
            validateFieldFormats(type, description, locationPreference, location);

            // Parse and validate data
            int clientId = Integer.parseInt(clientIdStr.trim());
            Date date = validateAndParseDate(dateStr.trim());
            BigDecimal budget = validateAndParseBudget(budgetStr.trim());
            String finalStatus = (status == null || status.trim().isEmpty()) ? "Pending Approval" : status.trim();
            BigDecimal advancePaid = (advancePaidStr != null && !advancePaidStr.trim().isEmpty()) ? 
                new BigDecimal(advancePaidStr.trim()) : BigDecimal.ZERO;
            Integer guestCount = parseGuestCount(guestCountStr);

            // Process vendor selections
            List<Integer> selectedVendorIds = processVendorSelections(request);
            
            LOGGER.info("Admin creating event for client " + clientId + " with " + 
                       selectedVendorIds.size() + " vendors");

            // Create event using EventManager - FIXED: Use the correct method signature
            boolean success = eventManager.addEventByAdmin(
                clientId, 
                type.trim(), 
                date, 
                budget, 
                description != null ? description.trim() : "",
                guestCount, 
                locationPreference != null ? locationPreference.trim() : "",
                location != null ? location.trim() : "",
                finalStatus,
                advancePaid,
                selectedVendorIds
            );
            
            if (success) {
                LOGGER.info("Event created successfully by admin for client: " + clientId);
            } else {
                LOGGER.warning("Failed to create event for client: " + clientId);
            }
            
            return success;
            
        } catch (Exception e) {
            LOGGER.severe("Error in handleEventCreation: " + e.getMessage());
            throw e;
        }
    }

    private boolean handleEventUpdate(HttpServletRequest request) {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            throw new IllegalArgumentException("Event ID is required for updating.");
        }

        try {
            int eventId = Integer.parseInt(eventIdStr);
            
            // Fetch existing event with vendors
            Event eventToUpdate = eventManager.getEventWithVendors(eventId);
            if (eventToUpdate == null) {
                throw new IllegalArgumentException("Event not found with ID: " + eventId);
            }

            System.out.println("=== ADMIN UPDATING EVENT ID: " + eventId + " ===");
            
            // Log all parameters for debugging
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("Parameter: " + paramName + " = " + paramValue);
            }

            // Update event fields from request parameters
            updateEventFromRequest(eventToUpdate, request);

            // Process vendor selections for update
            List<Integer> selectedVendorIds = processVendorSelections(request);
            System.out.println("Selected vendor IDs for update: " + selectedVendorIds);

            // Update event with vendors
            boolean success = eventManager.updateEventWithVendors(eventToUpdate, selectedVendorIds);
            
            if (success) {
                System.out.println("✅ Event updated successfully: " + eventId);
            } else {
                System.out.println("❌ Failed to update event: " + eventId);
            }
            
            return success;
            
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid Event ID format: " + eventIdStr);
        } catch (Exception e) {
            System.err.println("Error in handleEventUpdate: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to update event: " + e.getMessage(), e);
        }
    }

    private boolean handleEventApproval(HttpServletRequest request) {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            throw new IllegalArgumentException("Event ID is required for approval.");
        }

        int eventId = Integer.parseInt(eventIdStr);
        Event event = eventManager.getEventById(eventId);
        
        if (event == null) {
            throw new IllegalArgumentException("Event not found.");
        }

        if (!"Pending Approval".equalsIgnoreCase(event.getStatus())) {
            throw new IllegalArgumentException("Only events with 'Pending Approval' status can be approved.");
        }

        return eventManager.approveEvent(eventId);
    }

    private boolean handleEventRejection(HttpServletRequest request) {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            throw new IllegalArgumentException("Event ID is required for rejection.");
        }

        int eventId = Integer.parseInt(eventIdStr);
        Event event = eventManager.getEventById(eventId);
        
        if (event == null) {
            throw new IllegalArgumentException("Event not found.");
        }

        if (!"Pending Approval".equalsIgnoreCase(event.getStatus())) {
            throw new IllegalArgumentException("Only events with 'Pending Approval' status can be rejected.");
        }

        return eventManager.rejectEvent(eventId);
    }

    private boolean handleEventCancellation(HttpServletRequest request) {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            throw new IllegalArgumentException("Event ID is required for cancellation.");
        }

        int eventId = Integer.parseInt(eventIdStr);
        Event event = eventManager.getEventById(eventId);
        
        if (event == null) {
            throw new IllegalArgumentException("Event not found.");
        }

        if ("Cancelled".equalsIgnoreCase(event.getStatus()) || "Completed".equalsIgnoreCase(event.getStatus())) {
            throw new IllegalArgumentException("Cannot cancel event that is already " + event.getStatus() + ".");
        }

        return eventManager.cancelEvent(eventId);
    }

    private boolean handleEventDeletion(HttpServletRequest request) {
        String eventIdStr = request.getParameter("eventId");
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            throw new IllegalArgumentException("Event ID is required for deletion.");
        }

        int eventId = Integer.parseInt(eventIdStr);
        
        return eventManager.deleteEvent(eventId);
    }

    // === VENDOR MANAGEMENT ===

    private List<Integer> processVendorSelections(HttpServletRequest request) {
        List<Integer> vendorIds = new ArrayList<>();
        String[] vendorIdArray = request.getParameterValues("vendorIds");
        
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

    private void validateRequiredFields(String clientIdStr, String type, String dateStr, String budgetStr) {
        if (clientIdStr == null || clientIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Client ID is required.");
        }
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
        System.out.println("=== UPDATING EVENT FIELDS ===");
        
        String clientIdStr = request.getParameter("clientId");
        String newType = request.getParameter("type");
        String newDateStr = request.getParameter("date");
        String newBudgetStr = request.getParameter("budget");
        String newDescription = request.getParameter("description");
        String newGuestCountStr = request.getParameter("guestCount");
        String newLocationPreference = request.getParameter("locationPreference");
        String newLocation = request.getParameter("location");
        String newStatus = request.getParameter("status");
        String newAdvancePaidStr = request.getParameter("advancePaid");

        System.out.println("Current event status: " + event.getStatus());
        System.out.println("New status from form: " + newStatus);

        // Update client ID if provided
        if (clientIdStr != null && !clientIdStr.trim().isEmpty()) {
            try {
                event.setClientId(Integer.parseInt(clientIdStr.trim()));
                System.out.println("Updated client ID: " + event.getClientId());
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid Client ID format: " + clientIdStr);
            }
        }

        // Update event type
        if (newType != null && !newType.trim().isEmpty()) {
            if (!isValidEventType(newType.trim())) {
                throw new IllegalArgumentException("Invalid event type format: " + newType);
            }
            event.setType(newType.trim());
            System.out.println("Updated type: " + event.getType());
        }

        // Update date
        if (newDateStr != null && !newDateStr.trim().isEmpty()) {
            try {
                java.sql.Date date = validateAndParseDate(newDateStr.trim());
                event.setDate(date);
                System.out.println("Updated date: " + date);
            } catch (Exception e) {
                throw new IllegalArgumentException("Invalid date: " + e.getMessage());
            }
        }

        // Update budget
        if (newBudgetStr != null && !newBudgetStr.trim().isEmpty()) {
            try {
                BigDecimal budget = validateAndParseBudget(newBudgetStr.trim());
                event.setBudget(budget);
                System.out.println("Updated budget: " + budget);
            } catch (Exception e) {
                throw new IllegalArgumentException("Invalid budget: " + e.getMessage());
            }
        }

        // Update description
        if (newDescription != null) {
            if (!newDescription.trim().isEmpty() && !isValidDescription(newDescription.trim())) {
                throw new IllegalArgumentException("Description contains invalid characters or is too long.");
            }
            event.setDescription(newDescription.trim());
            System.out.println("Updated description: " + (event.getDescription() != null ? "provided" : "null"));
        }

        // Update guest count
        if (newGuestCountStr != null && !newGuestCountStr.trim().isEmpty()) {
            try {
                Integer guestCount = validateAndParseGuestCount(newGuestCountStr.trim());
                event.setGuestCount(guestCount);
                System.out.println("Updated guest count: " + guestCount);
            } catch (Exception e) {
                throw new IllegalArgumentException("Invalid guest count: " + e.getMessage());
            }
        }

        // Update location preference
        if (newLocationPreference != null) {
            if (!newLocationPreference.trim().isEmpty() && !isValidLocation(newLocationPreference.trim())) {
                throw new IllegalArgumentException("Invalid location preference format.");
            }
            event.setLocationPreference(newLocationPreference.trim());
            System.out.println("Updated location preference: " + event.getLocationPreference());
        }

        // Update location
        if (newLocation != null) {
            if (!newLocation.trim().isEmpty() && !isValidLocation(newLocation.trim())) {
                throw new IllegalArgumentException("Invalid location format.");
            }
            event.setLocation(newLocation.trim());
            System.out.println("Updated location: " + event.getLocation());
        }

        // Update status - IMPORTANT: Validate status transition
        if (newStatus != null && !newStatus.trim().isEmpty()) {
            String currentStatus = event.getStatus();
            String requestedStatus = newStatus.trim();
            
            // Validate status transition
            if (!isValidStatusTransition(currentStatus, requestedStatus)) {
                throw new IllegalArgumentException("Invalid status transition: " + currentStatus + " → " + requestedStatus);
            }
            
            event.setStatus(requestedStatus);
            System.out.println("Updated status: " + currentStatus + " → " + requestedStatus);
        }

        // Update advance paid
        if (newAdvancePaidStr != null && !newAdvancePaidStr.trim().isEmpty()) {
            try {
                BigDecimal advancePaid = new BigDecimal(newAdvancePaidStr.trim());
                if (advancePaid.compareTo(BigDecimal.ZERO) < 0) {
                    throw new IllegalArgumentException("Advance paid cannot be negative.");
                }
                event.setAdvancePaid(advancePaid);
                System.out.println("Updated advance paid: " + advancePaid);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid advance paid amount format.");
            }
        }
        
        System.out.println("=== EVENT UPDATE COMPLETE ===");
    }

    /**
     * Validates if the status transition is allowed
     */
    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) {
            return false;
        }

        // Define allowed status transitions
        switch (currentStatus) {
            case "Pending Approval":
                return "Approved".equals(newStatus) || 
                       "Rejected".equals(newStatus) ||
                       "Cancelled".equals(newStatus);

            case "Approved":
                return "In Progress".equals(newStatus) || 
                       "Completed".equals(newStatus) ||
                       "Cancelled".equals(newStatus);

            case "In Progress":
                return "Completed".equals(newStatus) || 
                       "Cancelled".equals(newStatus);

            case "Completed":
                // Completed events are typically final
                return false;

            case "Rejected":
                // Rejected events cannot be reactivated
                return false;

            case "Cancelled":
                // Cancelled events cannot be reactivated
                return false;

            default:
                // Allow transitions for other statuses
                return true;
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

    private String convertEventToJson(Event event) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"eventId\":").append(event.getEventId()).append(",");
        json.append("\"clientId\":").append(event.getClientId()).append(",");
        json.append("\"type\":\"").append(escapeJson(event.getType())).append("\",");
        json.append("\"description\":").append(event.getDescription() != null ? 
            "\"" + escapeJson(event.getDescription()) + "\"" : "null").append(",");
        json.append("\"date\":\"").append(event.getDate() != null ? event.getDate().toString() : "").append("\",");
        json.append("\"location\":\"").append(event.getLocation() != null ? escapeJson(event.getLocation()) : "").append("\",");
        json.append("\"budget\":").append(event.getBudget() != null ? event.getBudget() : "null").append(",");
        json.append("\"status\":\"").append(escapeJson(event.getStatus())).append("\",");
        json.append("\"guestCount\":").append(event.getGuestCount() != null ? event.getGuestCount() : "null").append(",");
        json.append("\"locationPreference\":").append(event.getLocationPreference() != null ? 
            "\"" + escapeJson(event.getLocationPreference()) + "\"" : "null").append(",");
        json.append("\"advancePaid\":").append(event.getAdvancePaid() != null ? event.getAdvancePaid() : "null");
        json.append("}");
        return json.toString();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    private boolean isAdminAuthenticated(HttpSession session) {
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }
        User user = (User) session.getAttribute("loggedInUser");
        return "admin".equalsIgnoreCase(user.getRole());
    }

    private void sendErrorRedirect(HttpServletResponse response, HttpServletRequest request, String errorMessage) throws IOException {
        String encodedMessage = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8.toString());
        response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=" + encodedMessage);
    }

    private void sendRedirectWithMessage(HttpServletResponse response, HttpServletRequest request, String messageType, String messageText) throws IOException {
        String encodedMessage = URLEncoder.encode(messageText, StandardCharsets.UTF_8.toString());
        String redirectUrl = request.getContextPath() + "/admin/dashboard?" + messageType + "=" + encodedMessage;
        response.sendRedirect(redirectUrl);
    }
}