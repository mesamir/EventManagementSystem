// src/main/java/com/ems/dao/ClientDAO.java
package com.ems.dao;

import com.ems.model.Client;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientDAO {

    /**
     * Inserts a new customer profile into the Customers table.
     * @param customer The Client object to insert.
     * @return true if the customer was inserted successfully, false otherwise.
     */
    public boolean addCustomer(Client customer) {
        String sql = "INSERT INTO customers  (userID, name, email, phone, address) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, customer.getUserId());
            pstmt.setString(2, customer.getName());
            pstmt.setString(3, customer.getEmail());
            pstmt.setString(4, customer.getPhone());
            pstmt.setString(5, customer.getAddress());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves a customer by their User ID.
     * @param userId The User ID associated with the customer.
     * @return The Client object if found, null otherwise.
     */
    public Client getCustomerByUserId(int userId) {
        String sql = "SELECT * FROM customers WHERE userID= ?";
       
        try (Connection conn = DBConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {

        pstmt.setInt(1, userId);

        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                Client customer = new Client();
                customer.setCustomerId(rs.getInt("customerID"));
                customer.setUserId(rs.getInt("userID"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setName(rs.getString("name"));
                customer.setEmail(rs.getString("email"));
                return customer;
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

    /**
     * Retrieves all customers from the database.
     * @return A list of all Client objects.
     */
    public List<Client> getAllCustomers() {
    List<Client> customers = new ArrayList<>();

    String sql = "SELECT c.customerID, c.userID, c.phone, c.address, u.name, u.email " +
                 "FROM Customers c " +
                 "JOIN Users u ON c.userID = u.userID";

    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {

        while (rs.next()) {
            Client customer = new Client();
            customer.setCustomerId(rs.getInt("customerID"));
            customer.setUserId(rs.getInt("userID"));
            customer.setPhone(rs.getString("phone"));
            customer.setAddress(rs.getString("address"));
            customer.setName(rs.getString("name"));
            customer.setEmail(rs.getString("email"));
            customers.add(customer);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return customers;
}

    // You can add update and delete methods for Client here
    public boolean updateCustomer(Client customer) {
        String sql = "UPDATE customers SET phone = ?, address = ? WHERE customerID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, customer.getPhone());
            pstmt.setString(2, customer.getAddress());
            pstmt.setInt(3, customer.getCustomerId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCustomer(int customerId) {
        String sql = "DELETE FROM Customers WHERE customerID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, customerId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
   public Client getCustomerByCustomerId(int customerId) {
    String sql = "SELECT c.customerID, c.userID, c.phone, c.address, u.name, u.email " +
                 "FROM Customers c " +
                 "JOIN Users u ON c.userID = u.userID " +
                 "WHERE c.customerID = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {

        pstmt.setInt(1, customerId);

        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                Client customer = new Client();
                customer.setCustomerId(rs.getInt("customerID"));
                customer.setUserId(rs.getInt("userID"));
                customer.setPhone(rs.getString("phone"));
                customer.setAddress(rs.getString("address"));
                customer.setName(rs.getString("name"));
                customer.setEmail(rs.getString("email"));
                return customer;
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return null;
}

public boolean existsByUserId(int userId) {
    String sql = "SELECT 1 FROM Customers WHERE userID = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, userId);
        try (ResultSet rs = pstmt.executeQuery()) {
            return rs.next();
        }
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
public int getCustomerCount() {
    String sql = "SELECT COUNT(*) FROM customers";
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
        return rs.next() ? rs.getInt(1) : 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return 0;
    }
}

    
}

