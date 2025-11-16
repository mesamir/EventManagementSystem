package com.ems.service;

import com.ems.dao.BookingDAO;
import com.ems.dao.PaymentDAO;
import com.ems.model.Booking;
import com.ems.model.Payment;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Logger;
/**
 * Manages business logic for Payment-related operations.
 * This class acts as a service layer between the DAOs and the application,
 * and handles payment recording, manual edits, and webhook processing.
 */
public class PaymentManager {
private static final Logger LOGGER = Logger.getLogger(PaymentManager.class.getName());
    private final PaymentDAO paymentDAO;
    private final BookingDAO bookingDAO;
    
    // Field to hold the last occurred error message for servlet consumption
    private String lastError; 
    
    // Fixed commission rate for administrative share calculation (10%)
    private static final BigDecimal COMMISSION_RATE = new BigDecimal("0.10");
    
    // Status constants
    private static final String STATUS_CONFIRMED = "Confirmed";
    private static final String STATUS_ADVANCE_PAID = "Advance Paid";
    private static final String STATUS_COMPLETED = "Completed";
    
    public PaymentManager() {
        this.paymentDAO = new PaymentDAO();
        this.bookingDAO = new BookingDAO();
    }

    /**
     * Returns the error message from the last failed operation.
     * @return The last recorded error message.
     */
    public String getLastError() {
        return lastError;
    }

    // === Admin Manual Payment Recording ===

    /**
 * Records an administrative payment using Booking ID, calculates shares (10% admin commission), 
 * and updates the associated booking status and amount paid.
 * @param bookingId The ID of the booking for which the payment is being processed.
 * @param amount The amount of the current payment.
 * @param paymentMethod The method used (e.g., "Cash", "Bank Transfer").
 * @param paymentType The type of payment ("Full" or "Advance").
 * @param adminUserId The ID of the admin performing the transaction.
 * @return true if the transaction was successful, false otherwise.
 */
public boolean processAdminPayment(int bookingId, BigDecimal amount, String paymentMethod, String paymentType, int adminUserId) {
    this.lastError = null; // Reset error message

    try {
        // 1. Retrieve Booking using Booking ID (NOT Event ID)
        Booking booking = bookingDAO.getBookingById(bookingId);
        
        if (booking == null) {
            this.lastError = "No booking found for Booking ID " + bookingId + ".";
            return false;
        }

        // 2. Calculate Shares (10% Admin Commission)
        BigDecimal adminShare = amount.multiply(COMMISSION_RATE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal vendorShare = amount.subtract(adminShare);

        // 3. Create Payment Record
        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setAmount(amount);
        payment.setVendorShare(vendorShare);
        payment.setAdminShare(adminShare);
        payment.setPaymentMethod(paymentMethod);
        payment.setPaymentType(paymentType);
        payment.setStatus(STATUS_COMPLETED);
        // paymentDate will be automatically set by database

        // 4. Add Payment to database
        int paymentId = paymentDAO.addPayment(payment);
        if (paymentId == -1) {
            this.lastError = "Failed to add payment record to the database.";
            return false;
        }

        // 5. Update Booking Amount Paid
        BigDecimal currentAmountPaid = booking.getAmountPaid() != null ? booking.getAmountPaid() : BigDecimal.ZERO;
        BigDecimal newAmountPaid = currentAmountPaid.add(amount);

        // 6. Determine and Update Booking Status
        String newStatus = determineUpdatedStatus(booking, newAmountPaid);
        
        // Update booking status and amount paid
        boolean bookingUpdated = bookingDAO.updateBookingAmountPaidAndStatus(
            booking.getBookingId(), newAmountPaid, newStatus
        );

        if (!bookingUpdated) {
            this.lastError = "Successfully recorded payment but failed to update booking status/amount paid.";
            return false;
        }

        LOGGER.info("Admin payment processed successfully for Booking ID: " + bookingId);
        return true;

    } catch (Exception e) {
        LOGGER.severe("Unexpected Exception during admin payment processing: " + e.getMessage());
        this.lastError = "System error during transaction: " + e.getMessage();
        return false;
    }
}
    // === Standard Retrieval Methods ===

    /**
     * Retrieves all payments.
     * @return A list of all Payment objects.
     */
    public List<Payment> getAllPayments() {
        return paymentDAO.getAllPayments();
    }

    /**
     * Retrieves all payments for events created by a specific client.
     * @param clientId The ID of the client (user) whose payments are to be retrieved.
     * @return A list of Payment objects for the given client.
     */
    public List<Payment> getCustomersPayments(int clientId) {
        return paymentDAO.getPaymentsByClientId(clientId);
    }

    /**
     * Get payments for a specific vendor
     */
    public List<Payment> getPaymentsByVendorId(int vendorId) {
        try {
            return paymentDAO.getPaymentsByVendorId(vendorId);
        } catch (Exception e) {
            LOGGER.severe("Error getting payments for vendor ID " + vendorId + ": " + e.getMessage());
            return List.of();
        }
    }

    /**
     * Get recent payments for vendor (last 30 days)
     */
    public List<Payment> getRecentPaymentsByVendorId(int vendorId, int days) {
        try {
            return paymentDAO.getRecentPaymentsByVendorId(vendorId, days);
        } catch (Exception e) {
            LOGGER.severe("Error getting recent payments for vendor ID " + vendorId + ": " + e.getMessage());
            return List.of();
        }
    }

    /**
     * Get total payment amount for vendor in a date range
     */
    public BigDecimal getVendorPaymentTotal(int vendorId, LocalDateTime startDate, LocalDateTime endDate) {
        try {
            return paymentDAO.getVendorPaymentTotal(vendorId, startDate, endDate);
        } catch (Exception e) {
            LOGGER.severe("Error getting payment total for vendor ID " + vendorId + ": " + e.getMessage());
            return BigDecimal.ZERO;
        }
    }

    /**
     * Get payments by status for vendor
     */
    public List<Payment> getVendorPaymentsByStatus(int vendorId, String status) {
        try {
            return paymentDAO.getVendorPaymentsByStatus(vendorId, status);
        } catch (Exception e) {
            LOGGER.severe("Error getting payments by status for vendor ID " + vendorId + ": " + e.getMessage());
            return List.of();
        }
    }

    // === Manual Payment Recording (Non-Admin, legacy method) ===

    /**
     * Records a new payment in the system (typically for manual or offline payments).
     *
     * @param bookingId The ID of the booking this payment is for.
     * @param amount The amount of the payment.
     * @param paymentDate The date/time the payment was made.
     * @param status The status of the payment (e.g., "Advance Paid", "Full Paid", "Refunded").
     * @param transactionId The transaction ID from the payment gateway/method.
     * @param paymentMethod The method of payment (e.g., "Bank Transfer", "Cash", "Card").
     * @return The generated payment ID if the payment was successfully recorded, -1 otherwise.
     */
    public int recordPayment(int bookingId, BigDecimal amount, LocalDateTime paymentDate,
                             String status, String transactionId, String paymentMethod) {

        if (bookingId <= 0 || amount == null || amount.signum() <= 0 || paymentDate == null ||
            status == null || status.trim().isEmpty() || paymentMethod == null || paymentMethod.trim().isEmpty()) {
            System.err.println("PaymentManager: Invalid data provided for recording payment.");
            return -1;
        }

        // Calculate 80/20 split (assuming the business rule for this specific method)
        BigDecimal vendorShare = amount.multiply(BigDecimal.valueOf(0.80)).setScale(2, RoundingMode.HALF_UP);
        BigDecimal adminShare = amount.subtract(vendorShare);

        Payment newPayment = new Payment();
        newPayment.setBookingId(bookingId);
        newPayment.setAmount(amount);
        newPayment.setVendorShare(vendorShare);
        newPayment.setAdminShare(adminShare);
        newPayment.setPaymentDate(paymentDate);
        newPayment.setStatus(status);
        newPayment.setTransactionId(transactionId);
        newPayment.setPaymentMethod(paymentMethod);

        return paymentDAO.addPayment(newPayment);
    }

    // === Stripe Webhook Methods ===

    /**
     * Creates a new payment record from a Stripe webhook event (e.g., payment intent success).
     * This is used when a payment succeeds but the record doesn't exist yet.
     *
     * @param eventId The ID of the EMS event the payment is for.
     * @param amount The amount paid.
     * @param status The payment status (e.g., 'succeeded').
     * @param stripePaymentIntentId The unique Stripe Payment Intent ID.
     * @return true if the payment was successfully recorded.
     */
    public boolean createPaymentFromWebhook(int eventId, BigDecimal amount, String status, String stripePaymentIntentId) {
        try {
            // Convert Stripe status to our status enum
            String paymentStatus = convertStripeStatusToPaymentStatus(status);
            return paymentDAO.addPaymentRecord(eventId, amount, paymentStatus, stripePaymentIntentId);
        } catch (Exception e) {
            System.err.println("Error creating payment from webhook: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates the status and amount of an existing payment record 
     * identified by the Stripe Payment Intent ID.
     *
     * @param stripePaymentIntentId The unique Stripe Payment Intent ID.
     * @param newStatus The new status to set.
     * @param eventId The event ID associated with the payment.
     * @param amount The final amount associated with the payment (useful for refunds/partial payments).
     * @return true if the status was successfully updated.
     */
    public boolean updatePaymentStatus(String stripePaymentIntentId, String newStatus, String eventId, BigDecimal amount) {
        try {
            String paymentStatus = convertStripeStatusToPaymentStatus(newStatus);
            return paymentDAO.updatePaymentStatusWithAmount(stripePaymentIntentId, eventId, paymentStatus, amount);
        } catch (Exception e) {
            System.err.println("Error updating payment status with amount: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates only the status of an existing payment record.
     *
     * @param stripePaymentIntentId The unique Stripe Payment Intent ID.
     * @param newStatus The new status to set.
     * @param eventId The event ID associated with the payment.
     * @return true if the status was successfully updated.
     */
    public boolean updatePaymentStatus(String stripePaymentIntentId, String newStatus, String eventId) {
        try {
            String paymentStatus = convertStripeStatusToPaymentStatus(newStatus);
            return paymentDAO.updatePaymentStatus(stripePaymentIntentId, eventId, paymentStatus);
        } catch (Exception e) {
            System.err.println("Error updating payment status (status only): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // === Admin Manual Edit Logic ===

    /**
     * Determines the new booking status based on the total amount paid.
     * @param booking The current booking object.
     * @param updatedAmountPaid The revised total amount paid for the booking.
     * @return The determined new status string.
     */
    private String determineUpdatedStatus(Booking booking, BigDecimal updatedAmountPaid) {
        if (updatedAmountPaid.compareTo(booking.getAmount()) >= 0) {
            return STATUS_CONFIRMED;
        } else if (booking.getAdvanceAmountDue() != null &&
                    updatedAmountPaid.compareTo(booking.getAdvanceAmountDue()) >= 0) {
            return STATUS_ADVANCE_PAID;
        } else {
            return booking.getStatus();
        }
    }

    /**
     * Allows an Admin to manually edit a payment record and updates the associated booking status.
     * @param updatedPayment The payment object with updated details.
     * @return true if both the payment and the linked booking status/amountPaid were updated successfully.
     */
    public boolean adminEditPayment(Payment updatedPayment) {
        Payment existing = paymentDAO.getPaymentById(updatedPayment.getPaymentId());
        if (existing == null) {
            System.err.println("PaymentManager: Admin edit failed, payment ID not found: " + updatedPayment.getPaymentId());
            return false;
        }

        Booking booking = bookingDAO.getBookingById(existing.getBookingId());
        if (booking == null) {
            System.err.println("PaymentManager: Admin edit failed, linked booking not found for payment ID: " + existing.getBookingId());
            return false;
        }

        // Prevent status downgrade if booking is already Advance Paid or Confirmed
        if (STATUS_ADVANCE_PAID.equals(booking.getStatus()) || STATUS_CONFIRMED.equals(booking.getStatus())) {
            // Only update the payment details, do not change booking status
            return paymentDAO.updatePayment(updatedPayment); 
        }

        // Recalculate booking amountPaid by subtracting the old payment amount 
        // and adding the new payment amount (necessary for manual edits).
        BigDecimal currentAmountPaid = booking.getAmountPaid() != null ? booking.getAmountPaid() : BigDecimal.ZERO;
        BigDecimal revisedAmountPaid = currentAmountPaid
            .subtract(existing.getAmount())
            .add(updatedPayment.getAmount());

        String newStatus = determineUpdatedStatus(booking, revisedAmountPaid);

        boolean paymentUpdated = paymentDAO.updatePayment(updatedPayment);
        boolean bookingUpdated = bookingDAO.updateBookingAmountPaidAndStatus(
            booking.getBookingId(), revisedAmountPaid, newStatus
        );

        return paymentUpdated && bookingUpdated;
    }

    /**
     * Converts Stripe status to our payment status enum
     */
    private String convertStripeStatusToPaymentStatus(String stripeStatus) {
        if (stripeStatus == null) {
            return PaymentDAO.STATUS_PENDING;
        }
        
        switch (stripeStatus.toLowerCase()) {
            case "succeeded":
            case "completed":
                return PaymentDAO.STATUS_COMPLETED;
            case "failed":
            case "canceled":
                return PaymentDAO.STATUS_FAILED;
            case "refunded":
                return PaymentDAO.STATUS_REFUNDED;
            case "pending":
            case "processing":
            default:
                return PaymentDAO.STATUS_PENDING;
        }
    }

    /**
     * Gets payment by Stripe Payment Intent ID
     */
    public Payment getPaymentByStripeIntentId(String stripePaymentIntentId) {
        return paymentDAO.getPaymentByStripeIntentId(stripePaymentIntentId);
    }

    /**
     * Gets payments by booking ID
     */
    public List<Payment> getPaymentsByBookingId(int bookingId) {
        return paymentDAO.getPaymentsByBookingId(bookingId);
    }
}