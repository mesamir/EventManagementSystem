package com.ems.model;

/**
 * Represents the profile data specific to a 'Client' (Customer).
 * This class combines data from the 'Users' table (name, email) and 
 * the 'Customers' table (customerId, phone, address).
 */
public class Client {
    // Data from the 'Customers' table
    private int customerId;
    private int userId; // Foreign Key to Users table
    private String phone;
    private String address;
    
    // Augmented data from the 'Users' table (Crucial for ProfileServlet display)
    private String name;
    private String email;

    // Default constructor
    public Client() {}

    /**
     * Parameterized constructor for new customer profile creation.
     * @param userId The ID of the associated user.
     * @param name
     * @param email
     * @param phone The client's phone number.
     * @param address The client's address.
     */
    public Client(int userId, String name, String email, String phone, String address)  {
       this.userId = userId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

    // --- Getters & Setters ---

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
