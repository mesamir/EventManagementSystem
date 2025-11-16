package com.ems.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Service {
    private int id;
    private String name;
    private String description;
    private String shortDescription;
    private BigDecimal basePrice;
    private String currency;
    private String imageUrl;
    private String iconClass;
    private boolean active;
    private List<ServiceFeature> features;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructors
    public Service() {
        this.features = new ArrayList<>();
        this.active = true;
        this.currency = "NPR";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public Service(int id, String name, String description, String shortDescription, 
                  BigDecimal basePrice, String currency, String imageUrl, String iconClass, boolean active) {
        this();
        this.id = id;
        this.name = name;
        this.description = description;
        this.shortDescription = shortDescription;
        this.basePrice = basePrice;
        this.currency = currency != null ? currency : "NPR";
        this.imageUrl = imageUrl;
        this.iconClass = iconClass != null ? iconClass : "fas fa-cog";
        this.active = active;
    }
    
    // Full constructor with all fields
    public Service(int id, String name, String description, String shortDescription, 
                  BigDecimal basePrice, String currency, String imageUrl, String iconClass, 
                  boolean active, List<ServiceFeature> features, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.shortDescription = shortDescription;
        this.basePrice = basePrice;
        this.currency = currency != null ? currency : "NPR";
        this.imageUrl = imageUrl;
        this.iconClass = iconClass != null ? iconClass : "fas fa-cog";
        this.active = active;
        this.features = features != null ? features : new ArrayList<>();
        this.createdAt = createdAt != null ? createdAt : LocalDateTime.now();
        this.updatedAt = updatedAt != null ? updatedAt : LocalDateTime.now();
    }
    
    // Business Logic Methods
    
    /**
     * Check if service has features
     */
    public boolean hasFeatures() {
        return features != null && !features.isEmpty();
    }
    
    /**
     * Get the number of features
     */
    public int getFeatureCount() {
        return features != null ? features.size() : 0;
    }
    
    /**
     * Add a feature to the service
     */
    public void addFeature(ServiceFeature feature) {
        if (features == null) {
            features = new ArrayList<>();
        }
        if (feature != null) {
            feature.setServiceId(this.id);
            features.add(feature);
        }
    }
    
    /**
     * Remove a feature by ID
     */
    public boolean removeFeature(int featureId) {
        if (features != null) {
            return features.removeIf(feature -> feature.getId() == featureId);
        }
        return false;
    }
    
    /**
     * Get feature by ID
     */
    public ServiceFeature getFeatureById(int featureId) {
        if (features != null) {
            return features.stream()
                .filter(feature -> feature.getId() == featureId)
                .findFirst()
                .orElse(null);
        }
        return null;
    }
    
    /**
     * Format price with currency symbol
     */
    public String getFormattedPrice() {
        if (basePrice == null) {
            return "N/A";
        }
        
        String symbol = getCurrencySymbol();
        return symbol + basePrice.toPlainString();
    }
    
    /**
     * Get currency symbol
     */
    public String getCurrencySymbol() {
        switch (currency != null ? currency.toUpperCase() : "NPR") {
            case "USD": return "$";
            case "EUR": return "€";
            case "GBP": return "£";
            case "NPR": return "Rs. ";
            default: return currency + " ";
        }
    }
    
    /**
     * Check if service has an image
     */
    public boolean hasImage() {
        return imageUrl != null && !imageUrl.trim().isEmpty();
    }
    
    /**
     * Get a truncated description for display
     */
    public String getTruncatedDescription(int maxLength) {
        if (description == null) {
            return "";
        }
        if (description.length() <= maxLength) {
            return description;
        }
        return description.substring(0, maxLength) + "...";
    }
    
    /**
     * Get a truncated short description for display
     */
    public String getTruncatedShortDescription(int maxLength) {
        if (shortDescription == null) {
            return "";
        }
        if (shortDescription.length() <= maxLength) {
            return shortDescription;
        }
        return shortDescription.substring(0, maxLength) + "...";
    }
    
    /**
     * Validate service data
     */
    public boolean isValid() {
        return name != null && !name.trim().isEmpty() &&
               description != null && !description.trim().isEmpty() &&
               basePrice != null && basePrice.compareTo(BigDecimal.ZERO) >= 0 &&
               iconClass != null && !iconClass.trim().isEmpty();
    }
    
    /**
     * Get validation errors
     */
    public List<String> getValidationErrors() {
        List<String> errors = new ArrayList<>();
        
        if (name == null || name.trim().isEmpty()) {
            errors.add("Service name is required");
        }
        
        if (description == null || description.trim().isEmpty()) {
            errors.add("Service description is required");
        }
        
        if (basePrice == null) {
            errors.add("Base price is required");
        } else if (basePrice.compareTo(BigDecimal.ZERO) < 0) {
            errors.add("Base price cannot be negative");
        }
        
        if (iconClass == null || iconClass.trim().isEmpty()) {
            errors.add("Icon class is required");
        }
        
        return errors;
    }
    
    // Getters and Setters
    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }
    
    public String getName() { 
        return name; 
    }
    
    public void setName(String name) { 
        this.name = name != null ? name.trim() : null; 
    }
    
    public String getDescription() { 
        return description; 
    }
    
    public void setDescription(String description) { 
        this.description = description != null ? description.trim() : null; 
    }
    
    public String getShortDescription() { 
        return shortDescription; 
    }
    
    public void setShortDescription(String shortDescription) { 
        this.shortDescription = shortDescription != null ? shortDescription.trim() : null; 
    }
    
    public BigDecimal getBasePrice() { 
        return basePrice; 
    }
    
    public void setBasePrice(BigDecimal basePrice) { 
        this.basePrice = basePrice; 
    }
    
    public String getCurrency() { 
        return currency; 
    }
    
    public void setCurrency(String currency) { 
        this.currency = currency != null ? currency.toUpperCase() : "NPR"; 
    }
    
    public String getImageUrl() { 
        return imageUrl; 
    }
    
    public void setImageUrl(String imageUrl) { 
        this.imageUrl = imageUrl != null ? imageUrl.trim() : null; 
    }
    
    public String getIconClass() { 
        return iconClass; 
    }
    
    public void setIconClass(String iconClass) { 
        this.iconClass = iconClass != null ? iconClass.trim() : "fas fa-cog"; 
    }
    
    public boolean isActive() { 
        return active; 
    }
    
    public void setActive(boolean active) { 
        this.active = active; 
        this.updatedAt = LocalDateTime.now();
    }
    
    public List<ServiceFeature> getFeatures() { 
        return features != null ? features : new ArrayList<>(); 
    }
    
    public void setFeatures(List<ServiceFeature> features) { 
        this.features = features != null ? features : new ArrayList<>(); 
    }
    
    public LocalDateTime getCreatedAt() { 
        return createdAt; 
    }
    
    public void setCreatedAt(LocalDateTime createdAt) { 
        this.createdAt = createdAt; 
    }
    
    public LocalDateTime getUpdatedAt() { 
        return updatedAt; 
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) { 
        this.updatedAt = updatedAt; 
    }
    
    /**
     * Update this service with data from another service
     */
    public void updateFrom(Service other) {
        if (other == null) return;
        
        this.name = other.name;
        this.description = other.description;
        this.shortDescription = other.shortDescription;
        this.basePrice = other.basePrice;
        this.currency = other.currency;
        this.imageUrl = other.imageUrl;
        this.iconClass = other.iconClass;
        this.active = other.active;
        this.updatedAt = LocalDateTime.now();
        
        // Update features if provided
        if (other.features != null) {
            this.features = other.features;
        }
    }
    
    // Equals and HashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Service service = (Service) o;
        return id == service.id &&
               active == service.active &&
               Objects.equals(name, service.name) &&
               Objects.equals(description, service.description) &&
               Objects.equals(basePrice, service.basePrice);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id, name, description, basePrice, active);
    }
    
    // toString method
    @Override
    public String toString() {
        return "Service{" +
               "id=" + id +
               ", name='" + name + '\'' +
               ", description='" + (description != null ? getTruncatedDescription(50) : "null") + '\'' +
               ", basePrice=" + (basePrice != null ? getFormattedPrice() : "null") +
               ", active=" + active +
               ", featureCount=" + getFeatureCount() +
               ", createdAt=" + createdAt +
               '}';
    }
    
    // Builder pattern for fluent creation
    public static Builder builder() {
        return new Builder();
    }
    
    public static class Builder {
        private Service service;
        
        public Builder() {
            service = new Service();
        }
        
        public Builder id(int id) {
            service.id = id;
            return this;
        }
        
        public Builder name(String name) {
            service.name = name;
            return this;
        }
        
        public Builder description(String description) {
            service.description = description;
            return this;
        }
        
        public Builder shortDescription(String shortDescription) {
            service.shortDescription = shortDescription;
            return this;
        }
        
        public Builder basePrice(BigDecimal basePrice) {
            service.basePrice = basePrice;
            return this;
        }
        
        public Builder currency(String currency) {
            service.currency = currency;
            return this;
        }
        
        public Builder imageUrl(String imageUrl) {
            service.imageUrl = imageUrl;
            return this;
        }
        
        public Builder iconClass(String iconClass) {
            service.iconClass = iconClass;
            return this;
        }
        
        public Builder active(boolean active) {
            service.active = active;
            return this;
        }
        
        public Builder features(List<ServiceFeature> features) {
            service.features = features;
            return this;
        }
        
        public Builder createdAt(LocalDateTime createdAt) {
            service.createdAt = createdAt;
            return this;
        }
        
        public Builder updatedAt(LocalDateTime updatedAt) {
            service.updatedAt = updatedAt;
            return this;
        }
        
        public Service build() {
            return service;
        }
    }
}