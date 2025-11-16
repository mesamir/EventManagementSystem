package com.ems.model;

public class EventVendorAssignment {
    private int id;
    private int eventId;
    private int vendorId;
    private String vendorName;
    private String vendorType;
    private String status; // Pending, Confirmed, Rejected
    private String notes;
    
    public EventVendorAssignment() {
        this.status = "Pending";
    }
    
    public EventVendorAssignment(int eventId, int vendorId, String status) {
        this();
        this.eventId = eventId;
        this.vendorId = vendorId;
        this.status = status;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public int getVendorId() { return vendorId; }
    public void setVendorId(int vendorId) { this.vendorId = vendorId; }

    public String getVendorName() { return vendorName; }
    public void setVendorName(String vendorName) { this.vendorName = vendorName; }

    public String getVendorType() { return vendorType; }
    public void setVendorType(String vendorType) { this.vendorType = vendorType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    // Status helper methods
    public boolean isPending() { return "Pending".equals(status); }
    public boolean isConfirmed() { return "Confirmed".equals(status); }
    public boolean isRejected() { return "Rejected".equals(status); }
}