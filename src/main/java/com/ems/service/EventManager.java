package com.ems.service;

import com.ems.dao.EventDAO;
import com.ems.model.Event;
import com.ems.model.VendorSelection;
import com.ems.model.EventVendorAssignment;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Collections;
import java.util.logging.Logger;

public class EventManager {
  private static final Logger LOGGER = Logger.getLogger(EventManager.class.getName());
    private EventDAO eventDAO;

    public EventManager() {
        this.eventDAO = new EventDAO();
    }
// In your EventManager class - add this method
public boolean addEvent(Event event, List<Integer> selectedVendorIds) {
    try {
        // Use your existing EventDAO method that accepts Event object
        return eventDAO.addEvent(event, selectedVendorIds);
    } catch (Exception e) {
        LOGGER.severe("Error adding event: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}


    /**
     * Creates a new event for a client with selected vendors.
     * Clients select vendors during event creation.
     */
    public boolean addEvent(int clientId, String type, Date date, BigDecimal budget,  
                 String description, Integer guestCount, String locationPreference, 
                 String location, List<Integer> selectedVendorIds) {

        // Validate inputs
        if (clientId <= 0 || type == null || type.trim().isEmpty() || 
            date == null || budget == null || budget.compareTo(BigDecimal.ZERO) < 0) {
            System.err.println("EventManager: Invalid data for adding new event.");
            return false;
        }

        // Default status for customer-created events
        String status = "Pending Approval";

        // Create event with vendor selection
        return createEvent(clientId, type, date, budget, description, guestCount, 
                         locationPreference, location, status, selectedVendorIds);
    }

    /**
     * Adds a new event (used by Admin to create events for any client).
     * With vendor selection during creation.
     */
    public boolean addEventByAdmin(int clientId, String type, Date date, BigDecimal budget,
                                   String description, Integer guestCount, String locationPreference,
                                   String location, String status, BigDecimal advancePaid,
                                   List<Integer> selectedVendorIds) {
        // Basic validation
        if (clientId <= 0 || type == null || type.trim().isEmpty() ||
            date == null || budget == null || budget.compareTo(BigDecimal.ZERO) < 0) {
            System.err.println("EventManager (Admin): Invalid data for adding event.");
            return false;
        }

        // Set defaults if null
        String finalStatus = (status == null || status.trim().isEmpty()) ? "Pending Approval" : status;
        BigDecimal finalAdvancePaid = (advancePaid == null) ? BigDecimal.ZERO : advancePaid;

        // Create event with vendor selection
        Event event = new Event();
        event.setClientId(clientId);
        event.setType(type.trim());
        event.setDate(date);
        event.setBudget(budget);
        event.setDescription(description != null ? description.trim() : null);
        event.setGuestCount(guestCount);
        event.setLocationPreference(locationPreference != null ? locationPreference.trim() : null);
        event.setLocation(location);
        event.setStatus(finalStatus);
        event.setAdvancePaid(finalAdvancePaid);
        event.setPaidAmount(BigDecimal.ZERO);
        event.setPaymentStatus("pending");

        // Call DAO with vendor selection
        return eventDAO.addEvent(event, selectedVendorIds);
    }

    /**
     * Universal method to create and save a new Event object with vendor selection.
     */
    private boolean createEvent(Integer clientId, String type, Date date, BigDecimal budget,
                                String description, Integer guestCount, String locationPreference,
                                String location, String status, List<Integer> selectedVendorIds) {

        Event event = new Event();
        event.setClientId(clientId);
        event.setType(type.trim());
        event.setDate(date);
        event.setBudget(budget);
        event.setDescription(description != null ? description.trim() : null);
        event.setGuestCount(guestCount);
        event.setLocationPreference(locationPreference != null ? locationPreference.trim() : null);
        event.setLocation(location);
        event.setStatus(status);
        event.setAdvancePaid(BigDecimal.ZERO);
        event.setPaidAmount(BigDecimal.ZERO);
        event.setPaymentStatus("pending");

        // Call DAO with vendor selection
        return eventDAO.addEvent(event, selectedVendorIds);
    }

    /**
     * Update event with vendor assignments
     */
 // In your EventManager class
public boolean updateEventWithVendors(Event event, List<Integer> selectedVendorIds) {
    try {
        // Get current vendor assignments to preserve status
        List<VendorSelection> currentVendors = eventDAO.getSelectedVendorsForEvent(event.getEventId());
        
        // Update the event details first
        boolean eventUpdated = updateEvent(event);
        if (!eventUpdated) {
            return false;
        }
        
        // Update vendor assignments while preserving status
        return eventDAO.updateEventVendorsWithStatus(event.getEventId(), selectedVendorIds, currentVendors);
        
    } catch (Exception e) {
        LOGGER.severe("Error updating event with vendors: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

    // ✅ VENDOR MANAGEMENT
    
    /**
     * Get selected vendors for an event
     */
    public List<VendorSelection> getSelectedVendorsForEvent(int eventId) {
        if (eventId <= 0) {
            return Collections.emptyList();
        }
        
        try {
            return eventDAO.getSelectedVendorsForEvent(eventId);
        } catch (Exception e) {
            System.err.println("Error getting selected vendors for event: " + e.getMessage());
            return Collections.emptyList();
        }
    }

   /**
 * Get vendor assignments for an event
 */
public List<EventVendorAssignment> getVendorAssignmentsForEvent(int eventId) {
    if (eventId <= 0) {
        return Collections.emptyList();
    }
    
    try {
        return eventDAO.getVendorsByEventId(eventId);
    } catch (Exception e) {
        System.err.println("Error getting vendor assignments for event: " + e.getMessage());
        return Collections.emptyList();
    }
}
    /**
     * Update vendor selection status for an event
     */
    public boolean updateVendorSelectionStatus(int eventId, int vendorId, String status) {
        if (eventId <= 0 || vendorId <= 0 || status == null || status.trim().isEmpty()) {
            System.err.println("Invalid parameters for vendor status update.");
            return false;
        }

        try {
            return eventDAO.updateEventVendorStatus(eventId, vendorId, status);
        } catch (Exception e) {
            System.err.println("Error updating vendor selection status: " + e.getMessage());
            return false;
        }
    }

    /**
     * Update vendor assignment status using assignment ID
     */
    public boolean updateVendorAssignmentStatus(int assignmentId, String vendorStatus) {
        if (assignmentId <= 0 || vendorStatus == null || vendorStatus.trim().isEmpty()) {
            System.err.println("Invalid parameters for vendor status update.");
            return false;
        }

        try {
            return eventDAO.updateVendorAssignmentStatus(assignmentId, vendorStatus);
        } catch (Exception e) {
            System.err.println("Error updating vendor assignment status: " + e.getMessage());
            return false;
        }
    }

    /**
     * Remove vendor assignment using assignment ID
     */
    public boolean removeVendorAssignment(int assignmentId) {
        if (assignmentId <= 0) {
            System.err.println("Invalid Assignment ID for vendor removal.");
            return false;
        }

        try {
            return eventDAO.removeVendorAssignment(assignmentId);
        } catch (Exception e) {
            System.err.println("Error removing vendor assignment: " + e.getMessage());
            return false;
        }
    }

    /**
     * Invite vendor to event
     */
    public boolean inviteVendorToEvent(int eventId, int vendorId, String status) {
        if (eventId <= 0 || vendorId <= 0) {
            System.err.println("Invalid parameters for vendor invitation.");
            return false;
        }

        try {
            String finalStatus = (status != null && !status.trim().isEmpty()) ? status : "Pending";
            return eventDAO.inviteVendorToEvent(eventId, vendorId, finalStatus);
        } catch (Exception e) {
            System.err.println("Error inviting vendor to event: " + e.getMessage());
            return false;
        }
    }

    // ✅ STATUS MANAGEMENT (Admin only changes status)
    
    /**
     * Update event status with validation (Admin only)
     */
    public boolean updateEventStatus(int eventId, String newStatus) {
        if (eventId <= 0 || newStatus == null || newStatus.trim().isEmpty()) {
            System.err.println("Invalid parameters for status update.");
            return false;
        }

        Event event = eventDAO.getEventById(eventId);
        if (event == null) {
            System.err.println("Event not found for status change.");
            return false;
        }

        if (!isValidStatusTransition(event.getStatus(), newStatus)) {
            System.err.println("Invalid transition: " + event.getStatus() + " -> " + newStatus);
            return false;
        }

        return eventDAO.updateEventStatus(eventId, newStatus);
    }

    // ✅ Approve event (Admin only)
    public boolean approveEvent(int eventId) {
        return updateEventStatus(eventId, "Approved");
    }

    // ✅ Reject event (Admin only)
    public boolean rejectEvent(int eventId) {
        return updateEventStatus(eventId, "Rejected");
    }

    // ✅ Cancel event
    public boolean cancelEvent(int eventId) {
        return updateEventStatus(eventId, "Cancelled");
    }

    // ✅ Complete event
    public boolean completeEvent(int eventId) {
        return updateEventStatus(eventId, "Completed");
    }

    // ✅ Valid Status Transition Logic - FIXED VERSION
    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) {
            return false;
        }

        switch (currentStatus) {
            case "Pending Approval":
                return "Approved".equals(newStatus) || "Rejected".equals(newStatus);

            case "Approved":
                return "In Progress".equals(newStatus) || 
                       "Completed".equals(newStatus) ||
                       "Cancelled".equals(newStatus);

            case "In Progress":
                return "Completed".equals(newStatus) || "Cancelled".equals(newStatus);

            case "Completed":
                // Completed events are final
                return false;

            case "Rejected":
            case "Cancelled":
                // Rejected/Cancelled events cannot transition to any active state
                return false;

            default:
                return false;
        }
    }

    // ✅ PAYMENT MANAGEMENT
    
    /**
     * Records a payment against an existing event and updates the payment status.
     */
    public boolean addPaymentToEvent(int eventId, BigDecimal paymentAmount, String transactionRef) {
        // 1. Basic validation
        if (eventId <= 0 || paymentAmount == null || paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
            System.err.println("EventManager: Invalid event ID or payment amount.");
            return false;
        }

        // 2. Retrieve Event
        Event event = eventDAO.getEventById(eventId);
        if (event == null) {
            System.err.println("EventManager: Event not found for payment processing.");
            return false;
        }

        // 3. Calculate new paid amount
        BigDecimal currentPaid = event.getPaidAmount() != null ? event.getPaidAmount() : BigDecimal.ZERO;
        BigDecimal newTotalPaid = currentPaid.add(paymentAmount);
        BigDecimal budget = event.getBudget() != null ? event.getBudget() : BigDecimal.ZERO;

        // Prevent overpaying significantly (e.g., 10% tolerance)
        if (newTotalPaid.compareTo(budget.multiply(new BigDecimal("1.1"))) > 0) {
            System.err.println("EventManager: Payment amount potentially too high (over 110% of budget).");
            return false;
        }

        String newStatus = event.getStatus();

        // 4. Determine new status based on payment progress
        // Transition from "Approved" to "In Progress" when payment is made
        if (newTotalPaid.compareTo(BigDecimal.ZERO) > 0 && "Approved".equals(newStatus)) {
            newStatus = "In Progress";
        }

        // Transition to "Completed" if fully paid and was in progress
        if (newTotalPaid.compareTo(budget) >= 0 && "In Progress".equals(newStatus)) {
            newStatus = "Completed";
        }

        // Ensure the new status is a valid transition
        if (!isValidStatusTransition(event.getStatus(), newStatus)) {
            System.err.println("Payment recorded but invalid status transition: " + event.getStatus() + " -> " + newStatus);
            newStatus = event.getStatus(); // Keep original status if transition invalid
        }

        // 5. Update Event in DB
        if (!eventDAO.updateEventPayment(eventId, newTotalPaid, newStatus, transactionRef)) {
            System.err.println("EventManager: Failed to update event payment status in DAO.");
            return false;
        }

        System.out.println("Payment recorded successfully for Event ID: " + eventId + ". New Status: " + newStatus);
        return true;
    }

    // ✅ GETTER METHODS
    
    public Event getEventById(int eventId) {
        Event event = eventDAO.getEventById(eventId);
        if (event != null) {
            // Load selected vendors for the event
            List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(eventId);
            event.setSelectedVendors(selectedVendors);
            
            // Load vendor assignments
            List<EventVendorAssignment> vendorAssignments = getVendorAssignmentsForEvent(eventId);
            event.setVendorAssignments(vendorAssignments);
        }
        return event;
    }

    public List<Event> getAllEvents() {
        List<Event> events = eventDAO.getAllEvents();
        // Load selected vendors for each event
        for (Event event : events) {
            List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(event.getEventId());
            event.setSelectedVendors(selectedVendors);
        }
        return events;
    }

    public List<Event> getEventsByClientId(int clientId) {
        List<Event> events = eventDAO.getEventsByClientId(clientId);
        // Load selected vendors for each event
        for (Event event : events) {
            List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(event.getEventId());
            event.setSelectedVendors(selectedVendors);
        }
        return events;
    }

    // ✅ UPDATE EVENT (all fields)
    public boolean updateEvent(Event event) {
        if (event == null || event.getEventId() <= 0 ||
                event.getType() == null || event.getDate() == null ||
                event.getBudget() == null) {

            System.err.println("EventManager: Invalid data for event update.");
            return false;
        }

        return eventDAO.updateEvent(event);
    }

    // ✅ PAYMENT STATUS HELPERS
    
    public List<Event> getEventsWithPaymentStatus(int clientId) {
        List<Event> events = getEventsByClientId(clientId);
        for (Event event : events) {
            event.setPaymentStatus(determinePaymentStatus(event));
        }
        return events;
    }

    private String determinePaymentStatus(Event event) {
        BigDecimal paid = event.getPaidAmount();
        BigDecimal total = event.getBudget();

        if (paid == null || total == null || total.compareTo(BigDecimal.ZERO) <= 0)
            return "pending";

        if (paid.compareTo(BigDecimal.ZERO) == 0)
            return "pending";

        if (paid.compareTo(total) >= 0)
            return "fully_paid";

        if (paid.compareTo(total) < 0)
            return "advance_paid";

        return "pending";
    }

    /**
     * Update event payment status and general status
     */
    public boolean updateEventPaymentStatus(int eventId, String eventStatus, String paymentStatus) {
        try {
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                System.err.println("Event not found with ID: " + eventId);
                return false;
            }

            event.setStatus(eventStatus);
            event.setPaymentStatus(paymentStatus);

            boolean success = eventDAO.updateEvent(event);
            
            if (success) {
                System.out.println("Successfully updated event " + eventId + 
                    " with status: " + eventStatus + " and payment status: " + paymentStatus);
            } else {
                System.err.println("Failed to update event " + eventId + " in database");
            }
            
            return success;
            
        } catch (Exception e) {
            System.err.println("Error updating event payment status for event " + eventId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get events with vendor details
     */
    public Event getEventWithVendors(int eventId) {
        try {
            Event event = eventDAO.getEventById(eventId);
            if (event != null) {
                List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(eventId);
                event.setSelectedVendors(selectedVendors);
                
                List<EventVendorAssignment> vendorAssignments = getVendorAssignmentsForEvent(eventId);
                event.setVendorAssignments(vendorAssignments);
            }
            return event;
        } catch (Exception e) {
            System.err.println("Error getting event with vendors: " + e.getMessage());
            return null;
        }
    }

    /**
     * Update only the payment status without changing event status
     */
    public boolean updatePaymentStatus(int eventId, String paymentStatus) {
        try {
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                return false;
            }

            event.setPaymentStatus(paymentStatus);
            return eventDAO.updateEvent(event);
            
        } catch (Exception e) {
            System.err.println("Error updating payment status for event " + eventId + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * Update paid amount for an event
     */
    public boolean updatePaidAmount(int eventId, BigDecimal paidAmount) {
        try {
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                return false;
            }

            BigDecimal currentPaidAmount = event.getPaidAmount() != null ? event.getPaidAmount() : BigDecimal.ZERO;
            BigDecimal newPaidAmount = currentPaidAmount.add(paidAmount);
            event.setPaidAmount(newPaidAmount);

            // Auto-update payment status based on amount paid
            if (newPaidAmount.compareTo(event.getBudget()) >= 0) {
                event.setPaymentStatus("fully_paid");
            } else if (newPaidAmount.compareTo(BigDecimal.ZERO) > 0) {
                event.setPaymentStatus("advance_paid");
            }

            return eventDAO.updateEvent(event);
            
        } catch (Exception e) {
            System.err.println("Error updating paid amount for event " + eventId + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * Get events with selected vendors for dashboard display
     */
    public List<Event> getAllEventsWithVendors() {
        try {
            List<Event> events = eventDAO.getAllEvents();
            for (Event event : events) {
                List<VendorSelection> selectedVendors = getSelectedVendorsForEvent(event.getEventId());
                event.setSelectedVendors(selectedVendors);
            }
            return events;
        } catch (Exception e) {
            System.err.println("Error getting all events with vendors: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Delete an event
     */
    public boolean deleteEvent(int eventId) {
        try {
            return eventDAO.deleteEvent(eventId);
        } catch (Exception e) {
            System.err.println("Error deleting event: " + e.getMessage());
            return false;
        }
    }
}