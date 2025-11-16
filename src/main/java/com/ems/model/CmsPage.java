package com.ems.model;

import java.sql.Timestamp;

public class CmsPage {
    // Changed ID type to long for better compatibility with database primary keys
    private long id; 
    
    private String slug;
    private String title;
    private String content;
    
    // 🆕 New field to store the status (e.g., "DRAFT", "PUBLISHED")
    private String status; 
    
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // --- Getters and setters ---

    public long getId() {
        return id;
    }

    public void setId(long id) { // Updated parameter type to long
        this.id = id;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    // 🆕 New Getter for Status
    public String getStatus() {
        return status;
    }

    // 🆕 New Setter for Status
    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}