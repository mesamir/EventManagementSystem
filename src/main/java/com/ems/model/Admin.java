// src/main/java/com/ems/model/Admin.java
package com.ems.model;

import java.sql.Timestamp;

public class Admin {
    private int adminId;
    private int userId; // Foreign Key to Users table
    private String adminLevel;
    private Timestamp lastLogin;

    // Default constructor
    public Admin() {}

    // Parameterized constructor for new admin
    public Admin(int userId, String adminLevel) {
        this.userId = userId;
        this.adminLevel = adminLevel;
    }

    // Getters and Setters
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getAdminLevel() { return adminLevel; }
    public void setAdminLevel(String adminLevel) { this.adminLevel = adminLevel; }

    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }

    // ************************************************************
    // NOTE: Removed the following methods:
    // setPhone(), setAddress(), setEmail().
    // These properties should be updated on the 'User' object
    // (loggedInUser) in the AdminProfileServlet.
    // ************************************************************
}