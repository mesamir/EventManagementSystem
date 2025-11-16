package com.ems.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * A data model class representing a Vendor in the Event Management System.
 * This class holds information about a vendor, including their contact details,
 * services, and pricing.
 */
public class Vendor {
    private int vendorId;
    private int userId; // Foreign Key to the Users table
    private String companyName;
    private String serviceType;
    private String contactPerson;
    private String phone;
    private String email;
    private String address;
    private String description;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private String portfolioLink;
    private String status; // e.g., 'Pending Approval', 'Approved', 'Rejected', 'Inactive'
    private LocalDateTime registrationDate;

    // Default constructor
    public Vendor() {}

    /**
     * Parameterized constructor for creating a new Vendor object.
     * @param userId The ID of the associated user.
     * @param companyName The name of the vendor's company.
     * @param serviceType The type of service offered.
     * @param contactPerson The primary contact person.
     * @param phone The contact phone number.
     * @param email The contact email address.
     * @param address The physical address of the company.
     * @param description A brief description of the company/services.
     * @param minPrice The minimum price for services.
     * @param maxPrice The maximum price for services.
     * @param portfolioLink A link to the vendor's portfolio.
     * @param status The current status of the vendor.
     */
    public Vendor(int userId, String companyName, String serviceType, String contactPerson,
                  String phone, String email, String address, String description,
                  BigDecimal minPrice, BigDecimal maxPrice, String portfolioLink, String status) {
        this.userId = userId;
        this.companyName = companyName;
        this.serviceType = serviceType;
        this.contactPerson = contactPerson;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.description = description;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.portfolioLink = portfolioLink;
        this.status = status;
        this.registrationDate = LocalDateTime.now(); // Automatically set registration date
    }

    /**
     * Parameterized constructor for retrieving a Vendor object from the database.
     * @param vendorId The unique ID of the vendor.
     * @param userId The ID of the associated user.
     * @param companyName The name of the vendor's company.
     * @param serviceType The type of service offered.
     * @param contactPerson The primary contact person.
     * @param phone The contact phone number.
     * @param email The contact email address.
     * @param address The physical address of the company.
     * @param description A brief description of the company/services.
     * @param minPrice The minimum price for services.
     * @param maxPrice The maximum price for services.
     * @param portfolioLink A link to the vendor's portfolio.
     * @param status The current status of the vendor.
     * @param registrationDate The date and time the vendor registered.
     */
    public Vendor(int vendorId, int userId, String companyName, String serviceType, String contactPerson,
                  String phone, String email, String address, String description,
                  BigDecimal minPrice, BigDecimal maxPrice, String portfolioLink, String status, LocalDateTime registrationDate) {
        this.vendorId = vendorId;
        this.userId = userId;
        this.companyName = companyName;
        this.serviceType = serviceType;
        this.contactPerson = contactPerson;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.description = description;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.portfolioLink = portfolioLink;
        this.status = status;
        this.registrationDate = registrationDate;
    }

    // Getters and Setters for all fields

    public int getVendorId() {
        return vendorId;
    }

    public void setVendorId(int vendorId) {
        this.vendorId = vendorId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }

    public BigDecimal getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(BigDecimal maxPrice) {
        this.maxPrice = maxPrice;
    }

    public String getPortfolioLink() {
        return portfolioLink;
    }

    public void setPortfolioLink(String portfolioLink) {
        this.portfolioLink = portfolioLink;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(LocalDateTime registrationDate) {
        this.registrationDate = registrationDate;
    }

    @Override
    public String toString() {
        return "Vendor{" +
               "vendorId=" + vendorId +
               ", userId=" + userId +
               ", companyName='" + companyName + '\'' +
               ", serviceType='" + serviceType + '\'' +
               ", contactPerson='" + contactPerson + '\'' +
               ", phone='" + phone + '\'' +
               ", email='" + email + '\'' +
               ", address='" + address + '\'' +
               ", description='" + description + '\'' +
               ", minPrice=" + minPrice +
               ", maxPrice=" + maxPrice +
               ", portfolioLink='" + portfolioLink + '\'' +
               ", status='" + status + '\'' +
               ", registrationDate=" + registrationDate +
               '}';
    }


}
