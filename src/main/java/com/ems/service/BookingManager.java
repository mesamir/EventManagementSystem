package com.ems.service;

import com.ems.dao.*;
import com.ems.model.*;
import com.ems.util.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Logger;

/**
 * Service layer for managing booking-related operations.
 * Updated to align with new workflow: no vendor assignment during event creation
 */
public class BookingManager {
    private static final Logger LOGGER = Logger.getLogger(BookingManager.class.getName());

    private final BookingDAO bookingDAO;
    private final PaymentDAO paymentDAO;
    private final EventDAO eventDAO;
    private final UserDAO userDAO;
    private final VendorDAO vendorDAO;

    // Booking Status Constants (Updated for new workflow)
    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_CONFIRMED = "Confirmed";
    public static final String STATUS_CANCELLED = "Cancelled";
    public static final String STATUS_VENDOR_ASSIGNED = "Vendor Assigned";
    public static final String STATUS_ADVANCE_PAYMENT_DUE = "Advance Payment Due";
    public static final String STATUS_ADVANCE_PAID = "Advance Paid";
    public static final String STATUS_COMPLETED = "Completed";
    public static final String STATUS_PARTIALLY_PAID = "Partially Paid";

    public BookingManager() {
        this.bookingDAO = new BookingDAO();
        this.paymentDAO = new PaymentDAO();
        this.eventDAO = new EventDAO();
        this.userDAO = new UserDAO();
        this.vendorDAO = new VendorDAO();
    }

    // ─────────────────────────────────────────────────────────────────────────────
    // Booking Lifecycle Methods (Updated for new workflow)
    // ─────────────────────────────────────────────────────────────────────────────

    /**
     * Creates a booking without vendor assignment (new workflow)
     * @param eventId The event ID
     * @param userId The user ID
     * @param serviceBooked The service type
     * @param amount The total amount
     * @param notes Additional notes
     * @return Booking object if successful, null otherwise
     */
    public Booking createBookingWithoutVendor(int eventId, int userId, String serviceBooked, 
                                            BigDecimal amount, String notes) throws SQLException {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            LOGGER.warning("Invalid amount for booking creation: " + amount);
            return null;
        }

        // Verify event exists and is approved
        Event event = eventDAO.getEventById(eventId);
        if (event == null) {
            LOGGER.warning("Event not found for ID: " + eventId);
            return null;
        }
        
        if (!event.isApproved()) {
            LOGGER.warning("Cannot create booking for non-approved event: " + eventId);
            return null;
        }

        // Create booking without vendor
        int bookingId = bookingDAO.createBookingWithoutVendor(eventId, userId, serviceBooked, amount);
        if (bookingId != -1) {
            Booking booking = new Booking();
            booking.setBookingId(bookingId);
            booking.setEventId(eventId);
            booking.setUserId(userId);
            booking.setServiceBooked(serviceBooked);
            booking.setBookingDate(LocalDateTime.now());
            booking.setAmount(amount);
            booking.setStatus(STATUS_PENDING);
            booking.setNotes(notes != null ? notes : "");
            
            // Calculate default advance (30%)
            BigDecimal advancePercentage = new BigDecimal("30");
            BigDecimal advanceAmountDue = amount.multiply(advancePercentage).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            
            booking.setAdvanceRequiredPercentage(advancePercentage);
            booking.setAdvanceAmountDue(advanceAmountDue);
            booking.setAmountPaid(BigDecimal.ZERO);

            LOGGER.info("✅ Booking created without vendor, ID: " + bookingId);
            return booking;
        }
        
        LOGGER.severe("❌ Failed to create booking without vendor for event: " + eventId);
        return null;
    }

    /**
     * Assigns vendor to an existing booking (separate process)
     * @param bookingId The booking ID
     * @param vendorId The vendor ID to assign
     * @return true if successful, false otherwise
     */
    public boolean assignVendorToBooking(int bookingId, int vendorId) {
        LOGGER.info("Assigning vendor " + vendorId + " to booking " + bookingId);
        
        // Verify booking exists
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            LOGGER.warning("Booking not found for ID: " + bookingId);
            return false;
        }

        // Verify vendor exists and is approved
        Vendor vendor = vendorDAO.getVendorById(vendorId);
        if (vendor == null || !"approved".equalsIgnoreCase(vendor.getStatus())) {
            LOGGER.warning("Vendor not found or not approved: " + vendorId);
            return false;
        }

        // Assign vendor
        boolean success = bookingDAO.assignVendorToBooking(bookingId, vendorId);
        if (success) {
            LOGGER.info("✅ Vendor " + vendorId + " assigned to booking " + bookingId);
            
            // Update booking service type based on vendor service type
            booking.setServiceBooked(vendor.getServiceType());
            bookingDAO.updateBooking(booking);
        } else {
            LOGGER.severe("❌ Failed to assign vendor to booking");
        }
        
        return success;
    }

    /**
     * Removes vendor assignment from booking
     * @param bookingId The booking ID
     * @return true if successful, false otherwise
     */
    public boolean removeVendorAssignment(int bookingId) {
        LOGGER.info("Removing vendor assignment from booking " + bookingId);
        return bookingDAO.removeVendorAssignment(bookingId);
    }

    /**
     * Admin sets advance payment requirements for a booking
     * Updated to work with vendor-assigned bookings
     */
    public boolean adminSetAdvancePayment(int bookingId, BigDecimal advancePercentage) {
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null || advancePercentage == null ||
            advancePercentage.compareTo(BigDecimal.ZERO) < 0 ||
            advancePercentage.compareTo(BigDecimal.valueOf(100)) > 0) {
            LOGGER.warning("Invalid parameters for advance payment setup");
            return false;
        }

        // Calculate advance amount
        BigDecimal advanceAmountDue = booking.getAmount()
            .multiply(advancePercentage)
            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

        // Update status based on whether vendor is assigned
        String newStatus = booking.getVendorId() != null ? 
            STATUS_ADVANCE_PAYMENT_DUE : STATUS_PENDING;

        boolean success = bookingDAO.updateBookingAdvanceDetails(bookingId, advancePercentage, advanceAmountDue, newStatus);
        
        if (success) {
            LOGGER.info("✅ Advance payment set for booking " + bookingId + ": " + advancePercentage + "%");
        } else {
            LOGGER.severe("❌ Failed to set advance payment for booking " + bookingId);
        }
        
        return success;
    }

    /**
     * Records payment for a booking
     * Updated for new workflow
     */
    public boolean recordPayment(int bookingId, BigDecimal paymentAmount, String paymentMethod, String transactionId) {
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null || paymentAmount == null || paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
            LOGGER.warning("Invalid payment parameters for booking " + bookingId);
            return false;
        }

        // Create payment record
        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setAmount(paymentAmount);
        payment.setPaymentDate(LocalDateTime.now());
        payment.setStatus("completed");
        payment.setTransactionId(transactionId);
        payment.setPaymentMethod(paymentMethod);

        int paymentId = paymentDAO.addPayment(payment);
        if (paymentId == -1) {
            LOGGER.severe("❌ Failed to create payment record for booking " + bookingId);
            return false;
        }

        // Update booking amount paid and status
        BigDecimal updatedAmountPaid = booking.getAmountPaid().add(paymentAmount);
        String updatedStatus = determineUpdatedStatus(booking, updatedAmountPaid);

        boolean success = bookingDAO.updateBookingAmountPaidAndStatus(bookingId, updatedAmountPaid, updatedStatus);
        
        if (success) {
            LOGGER.info("✅ Payment recorded for booking " + bookingId + ", new status: " + updatedStatus);
            // Update event status
            updateEventStatusFromBooking(bookingId, updatedStatus);
        } else {
            LOGGER.severe("❌ Failed to update booking payment for booking " + bookingId);
        }
        
        return success;
    }

    /**
     * Determines updated booking status after payment
     */
    private String determineUpdatedStatus(Booking booking, BigDecimal updatedAmountPaid) {
        final BigDecimal TOLERANCE = new BigDecimal("0.01");
        
        // Check if fully paid
        if (updatedAmountPaid.compareTo(booking.getAmount().subtract(TOLERANCE)) >= 0) {
            return STATUS_CONFIRMED;
        }
        
        // Check if advance is paid
        if (booking.getAdvanceAmountDue() != null &&
            updatedAmountPaid.compareTo(booking.getAdvanceAmountDue().subtract(TOLERANCE)) >= 0) {
            return STATUS_ADVANCE_PAID;
        }
        
        // Partial payment
        if (updatedAmountPaid.compareTo(BigDecimal.ZERO) > 0) {
            return STATUS_PARTIALLY_PAID;
        }
        
        return booking.getStatus();
    }

    // ─────────────────────────────────────────────────────────────────────────────
    // Status Management Methods
    // ─────────────────────────────────────────────────────────────────────────────

    public boolean adminConfirmBooking(int bookingId) {
        LOGGER.info("Admin confirming booking " + bookingId);
        boolean success = bookingDAO.updateBookingStatus(bookingId, STATUS_CONFIRMED);
        if (success) {
            updateEventStatusFromBooking(bookingId, STATUS_CONFIRMED);
        }
        return success;
    }

    public boolean adminCancelBooking(int bookingId) {
        LOGGER.info("Admin cancelling booking " + bookingId);
        boolean success = bookingDAO.updateBookingStatus(bookingId, STATUS_CANCELLED);
        if (success) {
            updateEventStatusFromBooking(bookingId, STATUS_CANCELLED);
        }
        return success;
    }

    /**
     * Vendor accepts booking (only for assigned vendors)
     */
    public boolean vendorAcceptBooking(int bookingId, int vendorId) {
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking != null && booking.getVendorId() != null && 
            booking.getVendorId() == vendorId &&
            (STATUS_PENDING.equals(booking.getStatus()) || STATUS_VENDOR_ASSIGNED.equals(booking.getStatus()))) {
            
            LOGGER.info("Vendor " + vendorId + " accepting booking " + bookingId);
            return bookingDAO.updateBookingStatus(bookingId, STATUS_ADVANCE_PAYMENT_DUE);
        }
        LOGGER.warning("Vendor " + vendorId + " cannot accept booking " + bookingId);
        return false;
    }

    /**
     * Vendor declines booking (only for assigned vendors)
     */
    public boolean vendorDeclineBooking(int bookingId, int vendorId) {
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking != null && booking.getVendorId() != null && 
            booking.getVendorId() == vendorId) {
            
            LOGGER.info("Vendor " + vendorId + " declining booking " + bookingId);
            // Remove vendor assignment and reset status
            boolean success = bookingDAO.removeVendorAssignment(bookingId);
            if (success) {
                bookingDAO.updateBookingStatus(bookingId, STATUS_PENDING);
            }
            return success;
        }
        LOGGER.warning("Vendor " + vendorId + " cannot decline booking " + bookingId);
        return false;
    }

    // ─────────────────────────────────────────────────────────────────────────────
    // Retrieval Methods (Updated for new workflow)
    // ─────────────────────────────────────────────────────────────────────────────

    public List<Booking> getAllBookingsForAdmin() {
        List<Booking> bookings = bookingDAO.getAllBookings();
        bookings.forEach(this::populateBookingDetails);
        return bookings;
    }

    public List<Booking> getCustomerBookings(int clientId) {
        List<Booking> bookings = bookingDAO.getBookingsByClientId(clientId);
        bookings.forEach(this::populateBookingDetails);
        return bookings;
    }

    public List<Booking> getVendorsBookings(int vendorId) {
        try {
            LOGGER.info("Getting bookings for vendor ID: " + vendorId);
            List<Booking> bookings = bookingDAO.getBookingsByVendorId(vendorId);
            LOGGER.info("Found " + bookings.size() + " bookings for vendor ID: " + vendorId);
            bookings.forEach(this::populateBookingDetails);
            return bookings;
        } catch (Exception e) {
            LOGGER.severe("Error getting vendor bookings for vendor ID " + vendorId + ": " + e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Gets bookings without vendor assignment
     */
    public List<Booking> getBookingsWithoutVendor() {
        List<Booking> bookings = bookingDAO.getBookingsWithoutVendor();
        bookings.forEach(this::populateBookingDetails);
        return bookings;
    }

    public Booking getBookingDetails(int bookingId) {
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking != null) populateBookingDetails(booking);
        return booking;
    }

    private void populateBookingDetails(Booking booking) {
        Event event = eventDAO.getEventById(booking.getEventId());
        if (event != null) {
            booking.setEventName(event.getType());
            User client = userDAO.getUserById(event.getClientId());
            if (client != null) booking.setClientName(client.getName());
        }
        if (booking.getVendorId() != null) {
            Vendor vendor = vendorDAO.getVendorById(booking.getVendorId());
            if (vendor != null) booking.setVendorCompanyName(vendor.getCompanyName());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────────
    // Payment Processing Methods (Webhook integration)
    // ─────────────────────────────────────────────────────────────────────────────

    /**
     * Updates booking status and amount paid after successful payment
     */
    public boolean markBookingAsPaid(int bookingId, BigDecimal amount, String paymentType) {
        LOGGER.info("Processing payment for booking " + bookingId + ", amount: " + amount + ", type: " + paymentType);
        
        // Input validation
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            LOGGER.severe("Invalid payment amount for booking ID: " + bookingId);
            return false;
        }

        // Get booking from database
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            LOGGER.severe("Booking not found for ID: " + bookingId);
            return false;
        }

        // Calculate new total amount paid
        BigDecimal currentAmountPaid = booking.getAmountPaid() != null ? booking.getAmountPaid() : BigDecimal.ZERO;
        BigDecimal newAmountPaid = currentAmountPaid.add(amount);

        // Determine new status
        String newStatus = determineBookingStatus(booking, newAmountPaid, paymentType);

        // Update booking in database
        boolean success = bookingDAO.updateBookingAmountPaidAndStatus(bookingId, newAmountPaid, newStatus);
        
        if (success) {
            LOGGER.info("✅ Successfully updated booking " + bookingId + " - New status: " + newStatus + ", Total paid: " + newAmountPaid);
            
            // Update event status
            updateEventStatusFromBooking(bookingId, newStatus);
            
            // Create payment record
            createPaymentFromWebhook(bookingId, amount, "stripe_payment_id", paymentType);
        } else {
            LOGGER.severe("❌ Failed to update booking " + bookingId + " in database");
        }

        return success;
    }

    /**
     * Overloaded method to handle webhook data format
     */
    public boolean markBookingAsPaid(String bookingIdStr, long amountPaidCents, String paymentType) {
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            BigDecimal amount = BigDecimal.valueOf(amountPaidCents)
                    .divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
            
            return markBookingAsPaid(bookingId, amount, paymentType);
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid booking ID format: " + bookingIdStr);
            return false;
        }
    }

    /**
     * Updates event status based on booking status
     */
    public boolean updateEventStatusFromBooking(int bookingId, String bookingStatus) {
        try {
            Booking booking = bookingDAO.getBookingById(bookingId);
            if (booking == null) {
                LOGGER.warning("Booking not found for ID: " + bookingId);
                return false;
            }

            String eventStatus = mapBookingStatusToEventStatus(bookingStatus);
            if (eventStatus != null) {
                boolean updated = eventDAO.updateEventStatus(booking.getEventId(), eventStatus);
                if (updated) {
                    LOGGER.info("Updated event " + booking.getEventId() + " status to: " + eventStatus);
                }
                return updated;
            }
            
            return true; // No status change needed
        } catch (Exception e) {
            LOGGER.severe("Error updating event status from booking: " + e.getMessage());
            return false;
        }
    }

    /**
     * Updates booking status
     */
    public boolean updateBookingStatus(int bookingId, String status) {
        try {
            boolean success = bookingDAO.updateBookingStatus(bookingId, status);
            if (success) {
                LOGGER.info("Updated booking " + bookingId + " status to: " + status);
                // Also update event status
                updateEventStatusFromBooking(bookingId, status);
            }
            return success;
        } catch (Exception e) {
            LOGGER.severe("Error updating booking status: " + e.getMessage());
            return false;
        }
    }

    /**
     * Creates a payment record from webhook data
     */
    public boolean createPaymentFromWebhook(int bookingId, BigDecimal amount, String paymentIntentId, String paymentType) {
        try {
            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setAmount(amount);
            payment.setPaymentDate(LocalDateTime.now());
            payment.setStatus("completed");
            payment.setPaymentMethod("Stripe");
            payment.setTransactionId(paymentIntentId);
            payment.setPaymentType(paymentType);

            int paymentId = paymentDAO.addPayment(payment);
            boolean success = paymentId != -1;
            
            if (success) {
                LOGGER.info("Created payment record for booking " + bookingId + ", Payment ID: " + paymentId);
            } else {
                LOGGER.severe("Failed to create payment record for booking " + bookingId);
            }
            
            return success;
        } catch (Exception e) {
            LOGGER.severe("Error creating payment from webhook: " + e.getMessage());
            return false;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────────
    // Helper Methods
    // ─────────────────────────────────────────────────────────────────────────────

    /**
     * Determines the new booking status after payment
     */
    private String determineBookingStatus(Booking booking, BigDecimal newAmountPaid, String paymentType) {
        final BigDecimal TOLERANCE = new BigDecimal("0.01");
        
        // Check if fully paid
        if (newAmountPaid.compareTo(booking.getAmount().subtract(TOLERANCE)) >= 0) {
            return STATUS_CONFIRMED;
        }
        
        // Check if advance is paid
        if ("advance".equalsIgnoreCase(paymentType)) {
            BigDecimal advanceDue = booking.getAdvanceAmountDue() != null ? 
                booking.getAdvanceAmountDue() : BigDecimal.ZERO;
            if (newAmountPaid.compareTo(advanceDue.subtract(TOLERANCE)) >= 0) {
                return STATUS_ADVANCE_PAID;
            }
        }
        
        // Partial payment
        if (newAmountPaid.compareTo(BigDecimal.ZERO) > 0) {
            return STATUS_PARTIALLY_PAID;
        }
        
        return booking.getStatus();
    }

    /**
     * Maps booking status to event status
     */
    private String mapBookingStatusToEventStatus(String bookingStatus) {
        if (bookingStatus == null) return null;
        
        switch (bookingStatus) {
            case STATUS_CONFIRMED:
                return "Confirmed";
                
            case STATUS_ADVANCE_PAID:
                return "In Progress";
                
            case STATUS_CANCELLED:
                return "Cancelled";
                
            case STATUS_PARTIALLY_PAID:
                return "Pending Payment";
                
            default:
                return null;
        }
    }

    // ─────────────────────────────────────────────────────────────────────────────
    // Payment Retrieval Methods
    // ─────────────────────────────────────────────────────────────────────────────

    public List<Payment> getCustomerPayments(int clientId) {
        return paymentDAO.getPaymentsByClientId(clientId);
    }

    public List<Payment> getVendorPayments(int vendorId) {
        return paymentDAO.getPaymentsByVendorId(vendorId);
    }

    public boolean adminRecordPayment(int bookingId, BigDecimal amount, LocalDateTime paymentDate,
                                  String paymentMethod, String transactionId, String statusOverride) {
        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null || amount == null || amount.signum() <= 0) return false;

        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setAmount(amount);
        payment.setPaymentDate(paymentDate != null ? paymentDate : LocalDateTime.now());
        payment.setStatus("completed");
        payment.setTransactionId(transactionId);
        payment.setPaymentMethod(paymentMethod);

        int paymentId = paymentDAO.addPayment(payment);
        if (paymentId == -1) return false;

        BigDecimal updatedAmountPaid = booking.getAmountPaid().add(amount);
        String updatedStatus = statusOverride != null ? statusOverride : determineUpdatedStatus(booking, updatedAmountPaid);

        return bookingDAO.updateBookingAmountPaidAndStatus(bookingId, updatedAmountPaid, updatedStatus);
    }
    // In BookingManager.java

/**
 * Vendor accepts a booking - updates booking status to "Confirmed"
 */
public boolean vendorAcceptBooking(int bookingId) {
    try {
        return bookingDAO.updateBookingStatus(bookingId, "Confirmed");
    } catch (Exception e) {
        System.err.println("Error accepting booking: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

/**
 * Vendor declines a booking - updates booking status to "Declined"
 */
public boolean vendorDeclineBooking(int bookingId) {
    try {
        return bookingDAO.updateBookingStatus(bookingId, "Declined");
    } catch (Exception e) {
        System.err.println("Error declining booking: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}


}