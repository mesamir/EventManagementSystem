package com.ems.model;

import java.time.LocalDateTime;

public class User {
    private int userId;
    private String name;
    private String email;
    private String phone; // This is the field that setPhone will update
    private String address;
    private String passwordHash; // Stores the hashed password
    private String role; // e.g., "admin", "customer", "vendor"
    private LocalDateTime registrationDate; // As per your DB schema

    /**
     * Default constructor for the User class.
     */
    public User() {
        // Default constructor is often needed by frameworks (e.g., for deserialization)
    }

    /**
     * Parameterized constructor for creating a new User object.
     *
     * @param name The full name of the user.
     * @param email The email address of the user (should be unique).
     * @param passwordHash The hashed password of the user.
     * @param phone The user's phone number.
     * @param address The user's address.
     * @param role The role of the user (e.g., "customer", "vendor", "admin").
     * @param registrationDate The date and time the user registered.
     */
    public User(String name, String email, String passwordHash, String phone, String address, String role, LocalDateTime registrationDate) {
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.address = address;
        this.role = role;
        this.registrationDate = registrationDate;
    }

    // --- Getters and Setters ---

    /**
     * Retrieves the unique ID of the user.
     * @return The user's ID.
     */
    public int getUserId() {
        return userId;
    }

    /**
     * Sets the unique ID of the user.
     * @param userId The user's ID.
     */
    public void setUserId(int userId) {
        this.userId = userId;
    }

    /**
     * Retrieves the full name of the user.
     * @return The user's name.
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the full name of the user.
     * @param name The user's name.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Retrieves the email address of the user.
     * @return The user's email.
     */
    public String getEmail() {
        return email;
    }

    /**
     * Sets the email address of the user.
     * @param email The user's email.
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Retrieves the hashed password of the user.
     * This should not be exposed directly to the frontend.
     * @return The user's hashed password.
     */
    public String getPasswordHash() {
        return passwordHash;
    }

    /**
     * Sets the hashed password of the user.
     * @param passwordHash The user's hashed password.
     */
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    /**
     * Retrieves the role of the user.
     * @return The user's role.
     */
    public String getRole() {
        return role;
    }

    /**
     * Sets the role of the user.
     * @param role The user's role (e.g., "customer", "vendor", "admin").
     */
    public void setRole(String role) {
        this.role = role;
    }

    /**
     * Retrieves the phone number of the user.
     * @return The user's phone number.
     */
    public String getPhone() {
        return phone;
    }

    /**
     * Sets the phone number of the user.
     * @param phone The user's phone number.
     */
    public void setPhone(String phone) {
        this.phone = phone;
    }

    /**
     * Retrieves the address of the user.
     * @return The user's address.
     */
    public String getAddress() {
        return address;
    }

    /**
     * Sets the address of the user.
     * @param address The user's address.
     */
    public void setAddress(String address) {
        this.address = address;
    }

    /**
     * Retrieves the registration date of the user.
     * @return The user's registration date.
     */
    public LocalDateTime getRegistrationDate() {
        return registrationDate;
    }
    
    /**
     * Sets the registration date of the user.
     * @param registrationDate The user's registration date.
     */
    public void setRegistrationDate(LocalDateTime registrationDate) {
        this.registrationDate = registrationDate;
    }
}
