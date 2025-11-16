package com.ems.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Booking {
    private Integer bookingId;
    private Integer eventId;
    private int userId;
    private Integer vendorId; // Nullable if not assigned
    private String serviceBooked;
    private LocalDateTime bookingDate;
    private BigDecimal amount;
    private String status;
    private String notes;
    private BigDecimal advanceRequiredPercentage;
    private BigDecimal advanceAmountDue;
    private BigDecimal amountPaid;

    // Display-only fields (populated by service layer)
    private String clientName;
    private String vendorCompanyName;
    private String eventName;
    private LocalDateTime eventDate;

    // Constructors
    public Booking() {}

    public Booking(Integer eventId, Integer userId, Integer vendorId, String serviceBooked,
                   BigDecimal amount, String notes, BigDecimal advanceRequiredPercentage,
                   BigDecimal advanceAmountDue, LocalDateTime eventDate) {
        this.eventId = eventId;
        this.userId = userId;
        this.vendorId = vendorId;
        this.serviceBooked = serviceBooked;
        this.bookingDate = LocalDateTime.now();
        this.amount = amount;
        this.status = "Pending";
        this.notes = notes;
        this.advanceRequiredPercentage = advanceRequiredPercentage;
        this.advanceAmountDue = advanceAmountDue;
        this.amountPaid = BigDecimal.ZERO;
        this.eventDate = eventDate;
    }

    // Getters and Setters
    public Integer getBookingId() { return bookingId; }
    public void setBookingId(Integer bookingId) { this.bookingId = bookingId; }

    public Integer getEventId() { return eventId; }
    public void setEventId(Integer eventId) { this.eventId = eventId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getVendorId() { return vendorId; }
    public void setVendorId(Integer vendorId) { this.vendorId = vendorId; }

    public String getServiceBooked() { return serviceBooked; }
    public void setServiceBooked(String serviceBooked) { this.serviceBooked = serviceBooked; }

    public LocalDateTime getBookingDate() { return bookingDate; }
    public void setBookingDate(LocalDateTime bookingDate) { this.bookingDate = bookingDate; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public BigDecimal getAdvanceRequiredPercentage() { return advanceRequiredPercentage; }
    public void setAdvanceRequiredPercentage(BigDecimal advanceRequiredPercentage) { this.advanceRequiredPercentage = advanceRequiredPercentage; }

    public BigDecimal getAdvanceAmountDue() { return advanceAmountDue; }
    public void setAdvanceAmountDue(BigDecimal advanceAmountDue) { this.advanceAmountDue = advanceAmountDue; }

    public BigDecimal getAmountPaid() { return amountPaid; }
    public void setAmountPaid(BigDecimal amountPaid) { this.amountPaid = amountPaid; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getVendorCompanyName() { return vendorCompanyName; }
    public void setVendorCompanyName(String vendorCompanyName) { this.vendorCompanyName = vendorCompanyName; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public LocalDateTime getEventDate() { return eventDate; }
    public void setEventDate(LocalDateTime eventDate) { this.eventDate = eventDate; }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingId=" + bookingId +
                ", eventId=" + eventId +
                ", userId=" + userId +
                ", vendorId=" + vendorId +
                ", serviceBooked='" + serviceBooked + '\'' +
                ", bookingDate=" + bookingDate +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                ", notes='" + notes + '\'' +
                ", advanceRequiredPercentage=" + advanceRequiredPercentage +
                ", advanceAmountDue=" + advanceAmountDue +
                ", amountPaid=" + amountPaid +
                ", eventDate=" + eventDate +
                '}';
    }

    
}