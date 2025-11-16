// src/main/java/com/ems/controller/StripePaymentServlet.java
package com.ems.controller;

import com.ems.dao.BookingDAO;
import com.ems.model.User;
import com.ems.model.Event;
import com.ems.service.EventManager;
import com.ems.service.StripePaymentService;
import com.ems.dao.PaymentDAO;
import com.ems.model.Booking;
import com.ems.model.Payment;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import org.json.JSONObject;
import java.util.logging.Logger;

@WebServlet("/client/stripe-payment")
public class StripePaymentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StripePaymentServlet.class.getName());
    private StripePaymentService stripeService;
    private EventManager eventManager;
    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO; 
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.stripeService = new StripePaymentService();
            this.eventManager = new EventManager();
            this.paymentDAO = new PaymentDAO();
            this.bookingDAO = new BookingDAO();
            LOGGER.info("StripePaymentServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.severe("Failed to initialize StripePaymentServlet: " + e.getMessage());
            throw new ServletException("Failed to initialize payment servlet", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
         LOGGER.info("Received payment request");
        
        HttpSession session = request.getSession(false);
        
        // Authorization check
        if (session == null || session.getAttribute("loggedInUser") == null) {
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }
        
        User user = (User) session.getAttribute("loggedInUser");
        String action = request.getParameter("action");
        
        if (action == null || action.trim().isEmpty()) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Action parameter is required");
            return;
        }
        
        try {
            switch (action) {
                case "createIntent":
                    createPaymentIntent(request, response, user);
                    break;
                case "confirmPayment":
                    confirmPayment(request, response, user);
                    break;
                case "getPaymentStatus":
                    getPaymentStatus(request, response, user);
                    break;
                default:
                     LOGGER.warning("Invalid action requested: " + action);
                    sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Payment processing failed: " + e.getMessage());
        }
    }
    
    private void createPaymentIntent(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            // Validate parameters
            String eventIdParam = request.getParameter("eventId");
            String paymentType = request.getParameter("paymentType");
            String amountParam = request.getParameter("amount");
            String currencyParam = request.getParameter("currency"); // Add currency parameter
            
              LOGGER.info("Creating payment intent - Event: " + eventIdParam + ", Type: " + paymentType + 
                   ", Amount: " + amountParam + ", Currency: " + currencyParam);
            
            if (eventIdParam == null || paymentType == null || amountParam == null) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
                return;
            }
            
            int eventId = Integer.parseInt(eventIdParam);
            BigDecimal amount = new BigDecimal(amountParam);
             String currency = currencyParam != null ? currencyParam : "usd"; // Default to USD
            // Validate amount
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid amount");
                return;
            }
            
            // Get event details and verify ownership
            LOGGER.info("Fetching event: " + eventId);
            
            Event event = eventManager.getEventById(eventId);
            if (event == null) {
                 LOGGER.warning("Event not found: " + eventId);
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Event not found");
                return;
            }
            
            // Verify event ownership - FIXED: Added proper null check
            if (event.getClientId() != user.getUserId()) {
                 LOGGER.warning("User " + user.getUserId() + " not authorized for event " + eventId);
                sendErrorResponse(response, HttpServletResponse.SC_FORBIDDEN, "Access denied to this event");
                return;
            }
            
            // Get or create booking for this event
            LOGGER.info("Getting booking for event: " + eventId);
            Booking booking = bookingDAO.getBookingByEventId(eventId);
            if (booking == null) {
                // Create a new booking if none exists
                 LOGGER.info("No existing booking found, creating new booking");
                booking = createBookingForEvent(event, user);
            }
            
            // Verify booking ownership
            if (booking.getUserId() != user.getUserId()) {
                 LOGGER.warning("Booking ownership mismatch for booking: " + booking.getBookingId());
                sendErrorResponse(response, HttpServletResponse.SC_FORBIDDEN, "Access denied to this booking");
                return;
            }
            
            // Create payment intent with Stripe
             LOGGER.info("Creating Stripe payment intent for amount: " + amount);
            Map<String, String> paymentIntent = stripeService.createPaymentIntent(
                amount, 
                currency, // FIXED: Use "usd" instead of "npr" for testing
                user.getEmail(), 
                Map.of(
                    "event_id", String.valueOf(eventId),
                    "payment_type", paymentType,
                    "user_id", String.valueOf(user.getUserId()),
                    "description", "Event Payment - " + event.getType()
                )
            );

            // Validate Stripe response
            if (paymentIntent == null) {
                LOGGER.severe("Stripe returned null payment intent");
                throw new Exception("Failed to create payment intent with Stripe - null response");
            }
            
            if (!paymentIntent.containsKey("clientSecret")) {
                LOGGER.severe("Stripe response missing clientSecret: " + paymentIntent);
                throw new Exception("Failed to create payment intent with Stripe - missing client secret");
            }

            LOGGER.info("Stripe payment intent created successfully: " + paymentIntent.get("paymentIntentId"));

             // Create pending payment record
            Payment payment = new Payment();
            payment.setBookingId(booking.getBookingId());
            payment.setAmount(amount);
            payment.setPaymentDate(LocalDateTime.now());
            payment.setStatus("Pending");
            payment.setPaymentMethod("Stripe");
            payment.setTransactionId("TXN_" + System.currentTimeMillis());
            payment.setStripePaymentIntentId(paymentIntent.get("paymentIntentId"));
            payment.setStripeClientSecret(paymentIntent.get("clientSecret"));
            payment.setPaymentType(paymentType);

            LOGGER.info("Saving payment record to database");
            int paymentId = paymentDAO.addStripePayment(payment);
            
            if (paymentId <= 0) {
                LOGGER.severe("Failed to save payment record to database");
                throw new Exception("Failed to save payment record in database");
            }

            LOGGER.info("Payment record saved with ID: " + paymentId);
            
            // Return success response
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", true);
            jsonResponse.put("clientSecret", paymentIntent.get("clientSecret"));
            jsonResponse.put("paymentIntentId", paymentIntent.get("paymentIntentId"));
            jsonResponse.put("paymentId", paymentId);
            jsonResponse.put("bookingId", booking.getBookingId());
            
            LOGGER.info("Sending success response for payment intent creation");
            response.getWriter().write(jsonResponse.toString());
            
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid numeric parameter: " + e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid numeric parameter");
        } catch (Exception e) {
            LOGGER.severe("Error creating payment intent: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Failed to create payment intent: " + e.getMessage());
        }
    }
    
    private Booking createBookingForEvent(Event event, User user) throws Exception {
        Booking booking = new Booking();
        booking.setEventId(event.getEventId());
        booking.setUserId(user.getUserId()); // FIXED: removed extra "user"
        booking.setEventName(event.getType());
        booking.setServiceBooked(event.getType() + " Event");
        booking.setBookingDate(LocalDateTime.now());
        
        // FIXED: Proper date conversion from java.sql.Date to LocalDateTime
        if (event.getDate() != null) {
            LocalDateTime eventDateTime = event.getDate().toLocalDate().atStartOfDay();
            booking.setEventDate(eventDateTime);
        } else {
            booking.setEventDate(LocalDateTime.now().plusDays(30)); // Default to 30 days from now
        }

        booking.setAmount(event.getBudget());
        booking.setAmountPaid(BigDecimal.ZERO);
        booking.setStatus("Pending");

        // Set advance payment details
        booking.setAdvanceRequiredPercentage(new BigDecimal("30")); // 30% advance
        if (event.getBudget() != null) {
            BigDecimal advanceAmount = event.getBudget().multiply(new BigDecimal("0.30"));
            booking.setAdvanceAmountDue(advanceAmount);
        } else {
            booking.setAdvanceAmountDue(BigDecimal.ZERO);
        }

        int bookingId = bookingDAO.createBooking(booking);
        if (bookingId <= 0) {
            throw new Exception("Failed to create booking record");
        }

        booking.setBookingId(bookingId);
        return booking;
    }
    
    private void confirmPayment(HttpServletRequest request, HttpServletResponse response, User user)
    throws IOException {
    try {
        String paymentIntentId = request.getParameter("paymentIntentId");
        String paymentIdParam = request.getParameter("paymentId");
        
        if (paymentIntentId == null || paymentIdParam == null) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Missing payment parameters");
            return;
        }
        
        int paymentId = Integer.parseInt(paymentIdParam);

        // Fetch the payment from DB first to verify ownership
        Payment payment = paymentDAO.getPaymentById(paymentId);
        if (payment == null) {
            sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Payment not found");
            return;
        }

        // Verify payment belongs to user
        if (!isPaymentOwnedByUser(payment, user.getUserId())) {
            sendErrorResponse(response, HttpServletResponse.SC_FORBIDDEN, "Payment access denied");
            return;
        }

        // Confirm payment with Stripe
        LOGGER.info("Confirming payment with Stripe: " + paymentIntentId);
        com.stripe.model.PaymentIntent stripeIntent = stripeService.confirmPaymentIntent(paymentIntentId);

        // Update payment status based on Stripe status
        String stripeStatus = stripeIntent.getStatus();
        String paymentStatus = mapStripeStatusToPaymentStatus(stripeStatus);
        
        LOGGER.info("Stripe status: " + stripeStatus + ", Mapped status: " + paymentStatus);
        
        // Update payment record
        payment.setStatus(paymentStatus);
        payment.setTransactionId(stripeIntent.getId());
        
        if ("succeeded".equals(stripeStatus)) {
            payment.setPaymentDate(LocalDateTime.now());
            LOGGER.info("Payment succeeded, updating payment date");
        }
        
        boolean paymentUpdated = paymentDAO.updatePayment(payment);
        
        if (!paymentUpdated) {
            LOGGER.severe("Failed to update payment record in database");
            throw new Exception("Failed to update payment record");
        }

        LOGGER.info("Payment record updated successfully with status: " + paymentStatus);

        // If payment succeeded, update booking and event
        if ("Completed".equals(paymentStatus)) {
            LOGGER.info("Payment completed, updating booking and event");
            updateBookingAndEvent(payment);
        }

        // Send success response
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("success", true);
        jsonResponse.put("status", paymentStatus);
        jsonResponse.put("stripeStatus", stripeStatus);
        jsonResponse.put("message", "Payment processed successfully");
        jsonResponse.put("paymentId", paymentId);
        
        LOGGER.info("Sending success response for payment confirmation");
        response.getWriter().write(jsonResponse.toString());

    } catch (NumberFormatException e) {
        LOGGER.severe("Invalid payment ID format: " + e.getMessage());
        sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid payment ID");
    } catch (Exception e) {
        LOGGER.severe("Error confirming payment: " + e.getMessage());
        
        // Mark payment as failed in case of error
        try {
            String paymentIdParam = request.getParameter("paymentId");
            if (paymentIdParam != null) {
                int paymentId = Integer.parseInt(paymentIdParam);
                Payment failedPayment = paymentDAO.getPaymentById(paymentId);
                if (failedPayment != null) {
                    failedPayment.setStatus("Failed");
                    paymentDAO.updatePayment(failedPayment);
                    LOGGER.info("Marked payment as failed due to error");
                }
            }
        } catch (Exception ex) {
            LOGGER.severe("Error marking payment as failed: " + ex.getMessage());
        }
        
        sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
            "Payment confirmation failed: " + e.getMessage());
    }
}
    
    private void getPaymentStatus(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            String paymentIdParam = request.getParameter("paymentId");
            if (paymentIdParam == null) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Missing payment ID");
                return;
            }
            
            int paymentId = Integer.parseInt(paymentIdParam);
            Payment payment = paymentDAO.getPaymentById(paymentId);
            
            if (payment == null) {
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Payment not found");
                return;
            }
            
            // Verify ownership
            if (!isPaymentOwnedByUser(payment, user.getUserId())) {
                sendErrorResponse(response, HttpServletResponse.SC_FORBIDDEN, "Payment access denied");
                return;
            }
            
            // If payment is pending, check with Stripe for updates
            if ("Pending".equals(payment.getStatus()) && payment.getStripePaymentIntentId() != null) {
                try {
                    com.stripe.model.PaymentIntent stripeIntent = 
                        stripeService.retrievePaymentIntent(payment.getStripePaymentIntentId());
                    
                    String stripeStatus = stripeIntent.getStatus();
                    String newStatus = mapStripeStatusToPaymentStatus(stripeStatus);
                    
                    if (!newStatus.equals(payment.getStatus())) {
                        payment.setStatus(newStatus);
                        if ("succeeded".equals(stripeStatus)) {
                            payment.setPaymentDate(LocalDateTime.now());
                            updateBookingAndEvent(payment);
                        }
                        paymentDAO.updatePayment(payment);
                    }
                } catch (Exception e) {
                    // Log but continue - we'll return the current status from DB
                    System.err.println("Error checking Stripe status: " + e.getMessage());
                }
            }
            
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", true);
            jsonResponse.put("paymentId", payment.getPaymentId());
            jsonResponse.put("status", payment.getStatus());
            jsonResponse.put("amount", payment.getAmount());
            jsonResponse.put("bookingId", payment.getBookingId());
            
            response.getWriter().write(jsonResponse.toString());
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid payment ID");
        } catch (Exception e) {
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Failed to get payment status: " + e.getMessage());
        }
    }
    
    private boolean isPaymentOwnedByUser(Payment payment, int userId) {
        try {
            Booking booking = bookingDAO.getBookingById(payment.getBookingId());
            return booking != null && booking.getUserId() == userId; // FIXED: removed extra "("
        } catch (Exception e) {
            System.err.println("Error checking payment ownership: " + e.getMessage());
            return false;
        }
    }
    
    private String mapStripeStatusToPaymentStatus(String stripeStatus) {
        if (stripeStatus == null) return "Pending";
        
        switch (stripeStatus) {
            case "succeeded":
                return "Completed";
            case "processing":
            case "requires_action":
            case "requires_confirmation":
                return "Pending";
            case "requires_payment_method":
            case "canceled":
                return "Failed";
            default:
                return "Pending";
        }
    }
    
    private void updateBookingAndEvent(Payment payment) {
        try {
            Booking booking = bookingDAO.getBookingById(payment.getBookingId());
            if (booking != null) {
                BigDecimal newAmountPaid = booking.getAmountPaid().add(payment.getAmount());
                booking.setAmountPaid(newAmountPaid);

                // Determine new status
                String newBookingStatus;
                if (newAmountPaid.compareTo(booking.getAmount()) >= 0) {
                    newBookingStatus = "Fully Paid";
                } else if (newAmountPaid.compareTo(BigDecimal.ZERO) > 0) {
                    newBookingStatus = "Advance Paid";
                } else {
                    newBookingStatus = booking.getStatus();
                }

                booking.setStatus(newBookingStatus);
                bookingDAO.updateBooking(booking);

                // Update event status accordingly
                updateEventStatus(booking.getEventId(), newBookingStatus, payment.getPaymentType());
            }
        } catch (Exception e) {
            System.err.println("Error updating booking and event: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void updateEventStatus(int eventId, String bookingStatus, String paymentType) {
        try {
            String newEventStatus;
            switch (bookingStatus) {
                case "Fully Paid":
                    newEventStatus = "Confirmed";
                    break;
                case "Advance Paid":
                    newEventStatus = "Advance Paid";
                    break;
                default:
                    newEventStatus = "Pending";
            }

            // Also update payment status in event
            String paymentStatus = "full".equals(paymentType) ? "fully_paid" : 
                                 "advance".equals(paymentType) ? "advance_paid" : "pending";
                                 
            boolean updated = eventManager.updateEventPaymentStatus(eventId, newEventStatus, paymentStatus);
            if (!updated) {
                System.err.println("Failed to update Event status for: " + eventId);
            }
        } catch (Exception e) {
            System.err.println("Error updating event status: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void sendErrorResponse(HttpServletResponse response, int statusCode, String message) 
            throws IOException {
        LOGGER.info("Sending error response: " + statusCode + " - " + message);
        response.setStatus(statusCode);
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("success", false);
        errorResponse.put("error", message);
        response.getWriter().write(errorResponse.toString());
    }
}