package com.ems.model;

import java.time.LocalDateTime;
import java.util.Objects;

public class ProcessStep {
    private int id;
    private int stepNumber;
    private String title;
    private String description;
    private int displayOrder;
    private boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructors
    public ProcessStep() {
        this.active = true;
        this.displayOrder = 0;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public ProcessStep(int id, int stepNumber, String title, String description, int displayOrder, boolean active) {
        this();
        this.id = id;
        this.stepNumber = stepNumber;
        this.title = title;
        this.description = description;
        this.displayOrder = displayOrder;
        this.active = active;
    }
    
    // Full constructor
    public ProcessStep(int id, int stepNumber, String title, String description, 
                      int displayOrder, boolean active, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.stepNumber = stepNumber;
        this.title = title;
        this.description = description;
        this.displayOrder = displayOrder;
        this.active = active;
        this.createdAt = createdAt != null ? createdAt : LocalDateTime.now();
        this.updatedAt = updatedAt != null ? updatedAt : LocalDateTime.now();
    }
    
    // Business Logic Methods
    
    /**
     * Check if process step has valid data
     */
    public boolean isValid() {
        return stepNumber > 0 &&
               title != null && !title.trim().isEmpty() &&
               description != null && !description.trim().isEmpty();
    }
    
    /**
     * Get validation errors
     */
    public String getValidationErrors() {
        if (stepNumber <= 0) {
            return "Step number must be positive";
        }
        if (title == null || title.trim().isEmpty()) {
            return "Title is required";
        }
        if (description == null || description.trim().isEmpty()) {
            return "Description is required";
        }
        return null;
    }
    
    /**
     * Get truncated description for display
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
    
    // Getters and Setters
    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }
    
    public int getStepNumber() { 
        return stepNumber; 
    }
    
    public void setStepNumber(int stepNumber) { 
        this.stepNumber = stepNumber; 
    }
    
    public String getTitle() { 
        return title; 
    }
    
    public void setTitle(String title) { 
        this.title = title != null ? title.trim() : null; 
    }
    
    public String getDescription() { 
        return description; 
    }
    
    public void setDescription(String description) { 
        this.description = description != null ? description.trim() : null; 
    }
    
    public int getDisplayOrder() { 
        return displayOrder; 
    }
    
    public void setDisplayOrder(int displayOrder) { 
        this.displayOrder = displayOrder; 
    }
    
    public boolean isActive() { 
        return active; 
    }
    
    public void setActive(boolean active) { 
        this.active = active; 
        this.updatedAt = LocalDateTime.now();
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
    
    // Equals and HashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProcessStep that = (ProcessStep) o;
        return id == that.id &&
               stepNumber == that.stepNumber &&
               active == that.active &&
               Objects.equals(title, that.title);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id, stepNumber, title, active);
    }
    
    // toString method
    @Override
    public String toString() {
        return "ProcessStep{" +
               "id=" + id +
               ", stepNumber=" + stepNumber +
               ", title='" + title + '\'' +
               ", description='" + (description != null ? getTruncatedDescription(30) : "null") + '\'' +
               ", displayOrder=" + displayOrder +
               ", active=" + active +
               ", createdAt=" + createdAt +
               '}';
    }
    
    // Builder pattern
    public static Builder builder() {
        return new Builder();
    }
    
    public static class Builder {
        private ProcessStep step;
        
        public Builder() {
            step = new ProcessStep();
        }
        
        public Builder id(int id) {
            step.id = id;
            return this;
        }
        
        public Builder stepNumber(int stepNumber) {
            step.stepNumber = stepNumber;
            return this;
        }
        
        public Builder title(String title) {
            step.title = title;
            return this;
        }
        
        public Builder description(String description) {
            step.description = description;
            return this;
        }
        
        public Builder displayOrder(int displayOrder) {
            step.displayOrder = displayOrder;
            return this;
        }
        
        public Builder active(boolean active) {
            step.active = active;
            return this;
        }
        
        public Builder createdAt(LocalDateTime createdAt) {
            step.createdAt = createdAt;
            return this;
        }
        
        public Builder updatedAt(LocalDateTime updatedAt) {
            step.updatedAt = updatedAt;
            return this;
        }
        
        public ProcessStep build() {
            return step;
        }
    }
}