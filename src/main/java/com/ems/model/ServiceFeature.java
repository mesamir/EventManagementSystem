package com.ems.model;

import java.time.LocalDateTime;
import java.util.Objects;

public class ServiceFeature {
    private int id;
    private int serviceId;
    private String featureText;
    private String iconClass;
    private int displayOrder;
    private LocalDateTime createdAt;
    
    // Constructors
    public ServiceFeature() {
        this.iconClass = "fas fa-check";
        this.displayOrder = 0;
        this.createdAt = LocalDateTime.now();
    }
    
    public ServiceFeature(int id, int serviceId, String featureText, String iconClass, int displayOrder) {
        this();
        this.id = id;
        this.serviceId = serviceId;
        this.featureText = featureText;
        this.iconClass = iconClass != null ? iconClass : "fas fa-check";
        this.displayOrder = displayOrder;
    }
    
    // Full constructor
    public ServiceFeature(int id, int serviceId, String featureText, String iconClass, 
                         int displayOrder, LocalDateTime createdAt) {
        this.id = id;
        this.serviceId = serviceId;
        this.featureText = featureText;
        this.iconClass = iconClass != null ? iconClass : "fas fa-check";
        this.displayOrder = displayOrder;
        this.createdAt = createdAt != null ? createdAt : LocalDateTime.now();
    }
    
    // Business Logic Methods
    
    /**
     * Check if feature has valid data
     */
    public boolean isValid() {
        return featureText != null && !featureText.trim().isEmpty() &&
               iconClass != null && !iconClass.trim().isEmpty();
    }
    
    /**
     * Get validation errors
     */
    public String getValidationErrors() {
        if (featureText == null || featureText.trim().isEmpty()) {
            return "Feature text is required";
        }
        if (iconClass == null || iconClass.trim().isEmpty()) {
            return "Icon class is required";
        }
        return null;
    }
    
    // Getters and Setters
    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }
    
    public int getServiceId() { 
        return serviceId; 
    }
    
    public void setServiceId(int serviceId) { 
        this.serviceId = serviceId; 
    }
    
    public String getFeatureText() { 
        return featureText; 
    }
    
    public void setFeatureText(String featureText) { 
        this.featureText = featureText != null ? featureText.trim() : null; 
    }
    
    public String getIconClass() { 
        return iconClass; 
    }
    
    public void setIconClass(String iconClass) { 
        this.iconClass = iconClass != null ? iconClass.trim() : "fas fa-check"; 
    }
    
    public int getDisplayOrder() { 
        return displayOrder; 
    }
    
    public void setDisplayOrder(int displayOrder) { 
        this.displayOrder = displayOrder; 
    }
    
    public LocalDateTime getCreatedAt() { 
        return createdAt; 
    }
    
    public void setCreatedAt(LocalDateTime createdAt) { 
        this.createdAt = createdAt; 
    }
    
    // Equals and HashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ServiceFeature that = (ServiceFeature) o;
        return id == that.id &&
               serviceId == that.serviceId &&
               displayOrder == that.displayOrder &&
               Objects.equals(featureText, that.featureText);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id, serviceId, featureText, displayOrder);
    }
    
    // toString method
    @Override
    public String toString() {
        return "ServiceFeature{" +
               "id=" + id +
               ", serviceId=" + serviceId +
               ", featureText='" + featureText + '\'' +
               ", iconClass='" + iconClass + '\'' +
               ", displayOrder=" + displayOrder +
               ", createdAt=" + createdAt +
               '}';
    }
    
    // Builder pattern
    public static Builder builder() {
        return new Builder();
    }
    
    public static class Builder {
        private ServiceFeature feature;
        
        public Builder() {
            feature = new ServiceFeature();
        }
        
        public Builder id(int id) {
            feature.id = id;
            return this;
        }
        
        public Builder serviceId(int serviceId) {
            feature.serviceId = serviceId;
            return this;
        }
        
        public Builder featureText(String featureText) {
            feature.featureText = featureText;
            return this;
        }
        
        public Builder iconClass(String iconClass) {
            feature.iconClass = iconClass;
            return this;
        }
        
        public Builder displayOrder(int displayOrder) {
            feature.displayOrder = displayOrder;
            return this;
        }
        
        public Builder createdAt(LocalDateTime createdAt) {
            feature.createdAt = createdAt;
            return this;
        }
        
        public ServiceFeature build() {
            return feature;
        }
    }
}