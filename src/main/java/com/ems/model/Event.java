package com.ems.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Event {
    private int eventId;
    private int clientId;
    private String clientName;
    private String type;
    private Date date;
    private BigDecimal budget;
    private String status;
    private Integer venueId;
    private String description;
    private Integer guestCount;
    private String locationPreference;
    private Date creationDate;
    private String location;
    private String paymentStatus;
    private BigDecimal paidAmount;
    private BigDecimal advancePaid;
    
    // For vendor selections (when querying with vendor data)
    private List<VendorSelection> selectedVendors = new ArrayList<>();
    
    // For vendor assignments (when querying from event_vendors table)
    private List<EventVendorAssignment> vendorAssignments = new ArrayList<>();

    // Constructors
    public Event() {
        this.paidAmount = BigDecimal.ZERO;
        this.advancePaid = BigDecimal.ZERO;
        this.paymentStatus = "pending";
        this.status = "Pending Approval";
        this.selectedVendors = new ArrayList<>();
        this.vendorAssignments = new ArrayList<>();
    }

    public Event(int clientId, String type, Date date, BigDecimal budget,
                String description, Integer guestCount, String locationPreference,
                String location) {
        this();
        this.clientId = clientId;
        this.type = type;
        this.date = date;
        this.budget = budget;
        this.description = description;
        this.guestCount = guestCount;
        this.locationPreference = locationPreference;
        this.location = location;
    }

    // Getters and Setters
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public String getClientName() { return clientName; }
    public void setClientName(String clientName) { this.clientName = clientName; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public LocalDate getLocalDate() {
        return date != null ? date.toLocalDate() : null;
    }

    public BigDecimal getBudget() { return budget; }
    public void setBudget(BigDecimal budget) { this.budget = budget; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getVenueId() { return venueId; }
    public void setVenueId(Integer venueId) { this.venueId = venueId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getGuestCount() { return guestCount; }
    public void setGuestCount(Integer guestCount) { this.guestCount = guestCount; }

    public String getLocationPreference() { return locationPreference; }
    public void setLocationPreference(String locationPreference) { this.locationPreference = locationPreference; }

    public Date getCreationDate() { return creationDate; }
    public void setCreationDate(Date creationDate) { this.creationDate = creationDate; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public BigDecimal getPaidAmount() { return paidAmount; }
    public void setPaidAmount(BigDecimal paidAmount) { this.paidAmount = paidAmount; }

    public BigDecimal getAdvancePaid() { return advancePaid; }
    public void setAdvancePaid(BigDecimal advancePaid) { this.advancePaid = advancePaid; }

    public List<VendorSelection> getSelectedVendors() { return selectedVendors; }
    public void setSelectedVendors(List<VendorSelection> selectedVendors) { this.selectedVendors = selectedVendors; }

    public List<EventVendorAssignment> getVendorAssignments() { return vendorAssignments; }
    public void setVendorAssignments(List<EventVendorAssignment> vendorAssignments) { this.vendorAssignments = vendorAssignments; }

    // Status helper methods
    public boolean isPendingApproval() { return "Pending Approval".equals(status); }
    public boolean isApproved() { return "Approved".equals(status); }
    public boolean isRejected() { return "Rejected".equals(status); }
    public boolean isCompleted() { return "Completed".equals(status); }
    public boolean isCancelled() { return "Cancelled".equals(status); }

    // Vendor management methods
    public void addVendorSelection(VendorSelection vendorSelection) {
        if (this.selectedVendors == null) {
            this.selectedVendors = new ArrayList<>();
        }
        this.selectedVendors.add(vendorSelection);
    }

    public void addVendorAssignment(EventVendorAssignment assignment) {
        if (this.vendorAssignments == null) {
            this.vendorAssignments = new ArrayList<>();
        }
        this.vendorAssignments.add(assignment);
    }

    public boolean hasVendorSelections() {
        return selectedVendors != null && !selectedVendors.isEmpty();
    }

    public boolean hasVendorAssignments() {
        return vendorAssignments != null && !vendorAssignments.isEmpty();
    }

    public int getConfirmedVendorCount() {
    if (vendorAssignments == null) return 0;
    return (int) vendorAssignments.stream()
            .filter(assignment -> "Confirmed".equalsIgnoreCase(assignment.getStatus()))
            .count();
}

    // Payment helper methods
    public BigDecimal getRemainingAmount() {
        if (budget == null) return BigDecimal.ZERO;
        return budget.subtract(paidAmount != null ? paidAmount : BigDecimal.ZERO);
    }

    public boolean isAdvancePaid() {
        return advancePaid != null && advancePaid.compareTo(BigDecimal.ZERO) > 0;
    }

    public boolean isFullyPaid() {
        return paidAmount != null && budget != null && paidAmount.compareTo(budget) >= 0;
    }

    @Override
    public String toString() {
        return "Event{" +
                "eventId=" + eventId +
                ", clientId=" + clientId +
                ", type='" + type + '\'' +
                ", date=" + date +
                ", status='" + status + '\'' +
                ", vendorAssignments=" + (vendorAssignments != null ? vendorAssignments.size() : 0) +
                '}';
    }
    private List<Integer> selectedVendorIds;

public List<Integer> getSelectedVendorIds() {
    return selectedVendorIds;
}

public void setSelectedVendorIds(List<Integer> selectedVendorIds) {
    this.selectedVendorIds = selectedVendorIds;
}
}