// src/main/java/com/ems/dao/UserDAO.java
 //pstmt.setString(3, user.getPasswordHash());
// user.setPasswordHash(rs.getString("password")); // Note: This is the hash, not plain password
//registerUser
package com.ems.dao;

import com.ems.model.User;
import com.ems.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

   /**
     * Retrieves a User by their email.Used for login/authentication.
     * @param email
     * @return 
     */
    public User getUserByEmail(String email) {
        User user = null;
        String sql = "SELECT userID, name, email, password, phone, address, role FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("userID"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                   user.setPasswordHash(rs.getString("password")); // Note: This is the hash, not plain password
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in UserDAO.getUserByEmail(): " + e.getMessage());
            e.printStackTrace();
        }
        return user;
}

    // NEW METHOD: Method to retrieve a user by their ID
    public User getUserById(int userId) {
        User user = null;
        String sql = "SELECT userID, name, email, password, phone, address, role FROM users WHERE userID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("userID"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                   user.setPasswordHash(rs.getString("password")); // Note: This is the hash, not plain password
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in UserDAO.getUserById(): " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }

    // Method to retrieve all users from the database

    /**
     *
     * @return
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT userID, name, email, password, phone, address, role FROM users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("userID"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPasswordHash(rs.getString("password")); // // Note: This is the hash, not plain password
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in UserDAO.getAllUsers(): " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    // RENAMED METHOD: Formerly addUser, now registerUser to match calls in UserService
   
    /**
     * Inserts a new user record and returns the auto-generated User ID.* @param user The User object containing data (name, email, passwordHash, etc.).
     * @param user
     * @return The generated userId (int) on success, or -1 on failure.
     * @throws SQLException if a database error occurs.
     */
    public int registerUser(User user) throws SQLException {
        // Use the method name expected by the Service layer
        String sql = "INSERT INTO users (name, email, password, phone, address, role) VALUES (?, ?, ?, ?, ?, ?)";
        int newUserId = -1;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // Set the registration date if not already set (Service should handle this, but for safety)
            if (user.getRegistrationDate() == null) {
                user.setRegistrationDate(LocalDateTime.now());
            }

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            // Assuming the column name is 'passwordHash' as per standard SQL naming
            stmt.setString(3, user.getPasswordHash()); 
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getRole());
            //stmt.setObject(7, user.getRegistrationDate()); // Use setObject for LocalDateTime

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        newUserId = rs.getInt(1);
                    }
                }
            }
        }
        return newUserId;
    }


    // Example: updateUser
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name=?, email=?, password=?, phone=?, address=?, role=? WHERE userID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPasswordHash());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());
            pstmt.setInt(7, user.getUserId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in UserDAO.updateUser(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a user record by ID. Used for transactional rollback in UserService.
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE userId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SQL Error in UserDAO.deleteUser(): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gets the total count of users in the system.
     */
    public int getTotalUsersCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Gets the total count of users by role.
     */
    public int getTotalUsersCountByRole(String role) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
 
    
    
     private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("userId"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("passwordHash")); // Note: This is the hash, not plain password
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        
        // Handle LocalDateTime mapping
        if (rs.getTimestamp("registrationDate") != null) {
            user.setRegistrationDate(rs.getTimestamp("registrationDate").toLocalDateTime());
        }
        return user;
    }
     // NOTE: getAllUsers(), getUserById(), and updateUser() methods would also be included here 
    // to complete the DAO, but are omitted for conciseness unless requested.

   
    
}
