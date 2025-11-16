package com.ems.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Payment {
    private int paymentId;
    private int bookingId;
    private BigDecimal amount;
    private BigDecimal vendorShare;
    private BigDecimal adminShare;
    private LocalDateTime paymentDate;
    private String status;
    private String transactionId;
    private String paymentMethod;

    // Additional fields for display
    private String clientName;
    private String eventName;
    private int vendorId;
    
    // Stripe-specific fields
    private String stripePaymentIntentId;
    private String stripeCustomerId;
    private String stripeClientSecret;
    private String currency = "NPR"; // Default currency
    
    // Payment type for booking
    private String paymentType; // "advance", "full", "balance"

    // Constants for status values
    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_COMPLETED = "Completed";
    public static final String STATUS_FAILED = "Failed";
    public static final String STATUS_REFUNDED = "Refunded";
    
    // Constants for payment types
    public static final String TYPE_ADVANCE = "advance";
    public static final String TYPE_FULL = "full";
    public static final String TYPE_BALANCE = "balance";
    
    // Constants for payment methods
    public static final String METHOD_STRIPE = "Stripe";
    public static final String METHOD_CASH = "Cash";
    public static final String METHOD_BANK_TRANSFER = "Bank Transfer";

    // Constructors
    public Payment() {
        this.paymentDate = LocalDateTime.now();
        this.status = STATUS_PENDING;
        this.currency = "NPR";
    }
    
    public Payment(int bookingId, BigDecimal amount, String paymentType) {
        this();
        this.bookingId = bookingId;
        this.amount = amount;
        this.paymentType = paymentType;
        this.paymentMethod = METHOD_STRIPE; // Default to Stripe
    }
    
    public Payment(int bookingId, BigDecimal amount, String paymentType, String paymentMethod) {
        this(bookingId, amount, paymentType);
        this.paymentMethod = paymentMethod;
    }

    // Getters and Setters
    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public BigDecimal getVendorShare() { return vendorShare; }
    public void setVendorShare(BigDecimal vendorShare) { this.vendorShare = vendorShare; }

    public BigDecimal getAdminShare() { return adminShare; }
    public void setAdminShare(BigDecimal adminShare) { this.adminShare = adminShare; }

    public LocalDateTime getPaymentDate() { return paymentDate; }
    public void setPaymentDate(LocalDateTime paymentDate) { this.paymentDate = paymentDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public int getVendorId() { return vendorId; }
    public void setVendorId(int vendorId) { this.vendorId = vendorId; }
    
    public String getStripePaymentIntentId() { return stripePaymentIntentId; }
    public void setStripePaymentIntentId(String stripePaymentIntentId) { this.stripePaymentIntentId = stripePaymentIntentId; }
    
    public String getStripeCustomerId() { return stripeCustomerId; }
    public void setStripeCustomerId(String stripeCustomerId) { this.stripeCustomerId = stripeCustomerId; }
    
    public String getStripeClientSecret() { return stripeClientSecret; }
    public void setStripeClientSecret(String stripeClientSecret) { this.stripeClientSecret = stripeClientSecret; }
    
    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }
    
    public String getPaymentType() { return paymentType; }
    public void setPaymentType(String paymentType) { this.paymentType = paymentType; }

    // Utility Methods
    
    /**
     * Check if payment is completed successfully
     */
    public boolean isCompleted() {
        return STATUS_COMPLETED.equals(this.status);
    }
    
    /**
     * Check if payment is pending
     */
    public boolean isPending() {
        return STATUS_PENDING.equals(this.status);
    }
    
    /**
     * Check if payment failed
     */
    public boolean isFailed() {
        return STATUS_FAILED.equals(this.status);
    }
    
    /**
     * Check if payment was refunded
     */
    public boolean isRefunded() {
        return STATUS_REFUNDED.equals(this.status);
    }
    
    /**
     * Check if this is an advance payment
     */
    public boolean isAdvancePayment() {
        return TYPE_ADVANCE.equals(this.paymentType);
    }
    
    /**
     * Check if this is a full payment
     */
    public boolean isFullPayment() {
        return TYPE_FULL.equals(this.paymentType);
    }
    
    /**
     * Check if this is a balance payment
     */
    public boolean isBalancePayment() {
        return TYPE_BALANCE.equals(this.paymentType);
    }
    
    /**
     * Check if payment was made via Stripe
     */
    public boolean isStripePayment() {
        return METHOD_STRIPE.equals(this.paymentMethod);
    }
    
    /**
     * Get formatted payment date
     */
    public String getFormattedPaymentDate() {
        if (this.paymentDate == null) return "N/A";
        return this.paymentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
    
    /**
     * Get formatted amount with currency
     */
    public String getFormattedAmount() {
        if (this.amount == null) return "N/A";
        return this.currency + " " + this.amount.setScale(2, BigDecimal.ROUND_HALF_UP);
    }
    
    /**
     * Calculate vendor share based on commission rate
     */
    public void calculateShares(BigDecimal commissionRate) {
        if (this.amount != null && commissionRate != null) {
            BigDecimal commissionAmount = this.amount.multiply(commissionRate)
                                                    .divide(new BigDecimal("100"), 2, BigDecimal.ROUND_HALF_UP);
            this.adminShare = commissionAmount;
            this.vendorShare = this.amount.subtract(commissionAmount);
        }
    }
    
    /**
     * Validate payment data
     */
    public boolean isValid() {
        return this.bookingId > 0 && 
               this.amount != null && 
               this.amount.compareTo(BigDecimal.ZERO) > 0 &&
               this.paymentType != null && 
               !this.paymentType.trim().isEmpty();
    }
    
    /**
     * Get payment type display name
     */
    public String getPaymentTypeDisplayName() {
        if (TYPE_ADVANCE.equals(this.paymentType)) return "Advance Payment";
        if (TYPE_FULL.equals(this.paymentType)) return "Full Payment";
        if (TYPE_BALANCE.equals(this.paymentType)) return "Balance Payment";
        return this.paymentType;
    }
    
    /**
     * Get status badge CSS class for UI
     */
    public String getStatusBadgeClass() {
        switch (this.status) {
            case STATUS_COMPLETED: return "badge-success";
            case STATUS_PENDING: return "badge-warning";
            case STATUS_FAILED: return "badge-danger";
            case STATUS_REFUNDED: return "badge-info";
            default: return "badge-secondary";
        }
    }
    
    /**
     * Create a copy of this payment
     */
    public Payment copy() {
        Payment copy = new Payment();
        copy.paymentId = this.paymentId;
        copy.bookingId = this.bookingId;
        copy.amount = this.amount;
        copy.vendorShare = this.vendorShare;
        copy.adminShare = this.adminShare;
        copy.paymentDate = this.paymentDate;
        copy.status = this.status;
        copy.transactionId = this.transactionId;
        copy.paymentMethod = this.paymentMethod;
        copy.clientName = this.clientName;
        copy.eventName = this.eventName;
        copy.vendorId = this.vendorId;
        copy.stripePaymentIntentId = this.stripePaymentIntentId;
        copy.stripeCustomerId = this.stripeCustomerId;
        copy.stripeClientSecret = this.stripeClientSecret;
        copy.currency = this.currency;
        copy.paymentType = this.paymentType;
        return copy;
    }
    
    @Override
    public String toString() {
        return "Payment{" +
                "paymentId=" + paymentId +
                ", bookingId=" + bookingId +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                ", paymentType='" + paymentType + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentDate=" + getFormattedPaymentDate() +
                '}';
    }
}