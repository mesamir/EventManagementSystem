package com.ems.util;

import java.math.BigDecimal;

public class ValidationUtil {
    
    public static void validateNotEmpty(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(fieldName + " cannot be empty");
        }
    }
    
    public static void validatePositive(BigDecimal value, String fieldName) {
        if (value == null || value.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException(fieldName + " must be positive");
        }
    }
    
    public static void validatePositive(int value, String fieldName) {
        if (value <= 0) {
            throw new IllegalArgumentException(fieldName + " must be positive");
        }
    }
    
    public static void validateMaxLength(String value, int maxLength, String fieldName) {
        if (value != null && value.length() > maxLength) {
            throw new IllegalArgumentException(fieldName + " cannot exceed " + maxLength + " characters");
        }
    }
    
    public static void validateMinLength(String value, int minLength, String fieldName) {
        if (value != null && value.length() < minLength) {
            throw new IllegalArgumentException(fieldName + " must be at least " + minLength + " characters");
        }
    }
    
    public static boolean isValidUrl(String url) {
        if (url == null || url.trim().isEmpty()) {
            return true; // Empty URL is acceptable
        }
        try {
            new java.net.URL(url);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    public static void validateEmail(String email, String fieldName) {
        if (email != null && !email.trim().isEmpty()) {
            String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
            if (!email.matches(emailRegex)) {
                throw new IllegalArgumentException(fieldName + " must be a valid email address");
            }
        }
    }
    
    public static void validatePhoneNumber(String phone, String fieldName) {
        if (phone != null && !phone.trim().isEmpty()) {
            // Basic phone validation - adjust regex as needed
            String phoneRegex = "^[+]?[0-9]{10,15}$";
            if (!phone.matches(phoneRegex)) {
                throw new IllegalArgumentException(fieldName + " must be a valid phone number");
            }
        }
    }
    
    public static void validateInRange(int value, int min, int max, String fieldName) {
        if (value < min || value > max) {
            throw new IllegalArgumentException(fieldName + " must be between " + min + " and " + max);
        }
    }
    
    public static void validateInRange(BigDecimal value, BigDecimal min, BigDecimal max, String fieldName) {
        if (value == null || value.compareTo(min) < 0 || value.compareTo(max) > 0) {
            throw new IllegalArgumentException(fieldName + " must be between " + min + " and " + max);
        }
    }
}