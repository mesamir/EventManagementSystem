// src/main/java/com/ems/model/VendorSelection.java
package com.ems.model;

public class VendorSelection {
    private int vendorId;
    private String companyName;  // Use companyName instead of vendorName
    private String serviceType;  // Use serviceType instead of vendorType
    private String contactPerson;
    private String phone;
    private String email;
    private String status;       // Use status instead of vendorStatus
    private String notes;
    private boolean selected;    // Helper field for UI
    
    // Constructors
    public VendorSelection() {}
    
    public VendorSelection(int vendorId, String companyName, String serviceType, 
                          String contactPerson, String phone, String email, String status) {
        this.vendorId = vendorId;
        this.companyName = companyName;
        this.serviceType = serviceType;
        this.contactPerson = contactPerson;
        this.phone = phone;
        this.email = email;
        this.status = status;
        this.selected = "Rejected".equals(status) ? false : true;
    }
    
    // Getters and Setters
    public int getVendorId() { return vendorId; }
    public void setVendorId(int vendorId) { this.vendorId = vendorId; }
    
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    
    public String getServiceType() { return serviceType; }
    public void setServiceType(String serviceType) { this.serviceType = serviceType; }
    
    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { 
        this.status = status; 
        this.selected = !"Rejected".equals(status);
    }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public boolean isSelected() { return selected; }
    public void setSelected(boolean selected) { this.selected = selected; }
    
    // Status helper methods
    public boolean isPending() { return "Pending".equals(status); }
    public boolean isConfirmed() { return "Confirmed".equals(status); }
    public boolean isRejected() { return "Rejected".equals(status); }
    
    // For JSP compatibility - map status to vendorStatus
    public String getVendorStatus() { return status; }
    public void setVendorStatus(String vendorStatus) { 
        this.status = vendorStatus; 
        this.selected = !"Rejected".equals(vendorStatus);
    }
}