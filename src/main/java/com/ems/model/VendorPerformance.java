// src/main/java/com/ems/model/VendorPerformance.java
package com.ems.model;

public class VendorPerformance {
    private int vendorId;
    private String vendorName;
    private long totalEvents;
    private double totalRevenue;
    private double averageRating; // Optional: if you have a rating system

    // Constructors (you can have a no-arg constructor and a parameterized one)
    public VendorPerformance() {
    }

    public VendorPerformance(int vendorId, String vendorName, long totalEvents, double totalRevenue, double averageRating) {
        this.vendorId = vendorId;
        this.vendorName = vendorName;
        this.totalEvents = totalEvents;
        this.totalRevenue = totalRevenue;
        this.averageRating = averageRating;
    }

    // Getters and Setters for all fields
    public int getVendorId() {
        return vendorId;
    }

    public void setVendorId(int vendorId) {
        this.vendorId = vendorId;
    }

    public String getVendorName() {
        return vendorName;
    }

    public void setVendorName(String vendorName) {
        this.vendorName = vendorName;
    }

    public long getTotalEvents() {
        return totalEvents;
    }

    public void setTotalEvents(long totalEvents) {
        this.totalEvents = totalEvents;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    // Optional: toString() for easy debugging
    @Override
    public String toString() {
        return "VendorPerformance{" +
               "vendorId=" + vendorId +
               ", vendorName='" + vendorName + '\'' +
               ", totalEvents=" + totalEvents +
               ", totalRevenue=" + totalRevenue +
               ", averageRating=" + averageRating +
               '}';
    }
}
