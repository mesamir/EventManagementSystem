// src/main/java/com/ems/service/UserService.java
package com.ems.service;

import com.ems.dao.UserDAO;
import com.ems.model.User;
import com.ems.model.Client; // Needed for client profile creation
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;
import java.util.List;
import java.math.BigDecimal; // Needed for simplified VendorManager call
import jakarta.servlet.http.HttpServletRequest;
// Assuming these Manager classes are available for profile creation
import com.ems.service.VendorManager;
import com.ems.service.ClientManager;
import com.ems.service.AdminManager;

/**
 * Service layer for managing user-related operations,
 * including registration and authentication.
 */
public class UserService {
    private UserDAO userDAO;
    private ClientManager clientManager;
    private VendorManager vendorManager;
    private AdminManager adminManager;

    public UserService() {
        this.userDAO = new UserDAO();
        // Managers are needed here to enable transactional registration logic
        this.clientManager = new ClientManager();
        this.vendorManager = new VendorManager();
        this.adminManager = new AdminManager();
    }

    /**
     * Registers a new user in the system.
     * Hashes the password before storing it.
     *
     * @param name The user's full name.
     * @param email The user's email address (unique identifier).
     * @param password The user's plain text password.
     * @param phone The user's phone number.
     * @param address The user's address.
     * @param role The user's role (e.g., "admin", "customer").
     * @return true if registration is successful, false otherwise.
     */
    public boolean registerUser(String name, String email, String password, String phone, String address, String role) {
        // Input Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.isEmpty() ||
            role == null || role.trim().isEmpty()) {
            System.err.println("UserService: Invalid input for registration.");
            return false;
        }
        
        // 1. Hash Password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // 2. Create User Model
        User newUser = new User();
        newUser.setName(name);
        newUser.setEmail(email);
        newUser.setPasswordHash(hashedPassword); // Set the hashed password
        newUser.setPhone(phone); // Set phone
        newUser.setAddress(address); // Set address
        newUser.setRole(role);

        // 3. Register User in core table
        // 3. Register User in core table
        int newUserId;
        try {
            // Assuming userDAO.addUser(User) attempts to insert the user and returns the generated primary key (ID).
            // NOTE: I'm using 'newUser' here, which matches the variable declared above in the UserService.
            newUserId = userDAO.registerUser(newUser); 
        } catch (SQLException e) {
            System.err.println("UserService: Database error during user creation: " + e.getMessage());
            return false; // Registration failed (e.g., email duplicate)
        }

        // 4. Create Role-Specific Profile (Transactionality)
        if (newUserId > 0) {
            // Set the generated ID back into the 'newUser' object for use in profile creation
            newUser.setUserId(newUserId); 
            
            // In a real transactional system, this profile creation would be part of the same transaction.
            boolean profileCreated = createRoleSpecificProfile(newUser);

            if (!profileCreated) {
                // Critical failure: Attempt to clean up the newly created User record
                // to prevent data integrity issues (orphaned records).
                System.err.println("UserService: Failed to create role profile. Attempting user deletion.");
                // This method requires the UserDAO to be accessible, which it is.
                userDAO.deleteUser(newUserId); 
                return false;
            }
            return true;
        }
        return false;
    }
    
    /**
     * Internal method to delegate profile creation to the appropriate manager.
     */
    private boolean createRoleSpecificProfile(User newUser) {
        String role = newUser.getRole().toLowerCase();

        // NOTE: This logic assumes the Managers can successfully create a profile
        // using just the data available in the core User object.
        try {
            if ("client".equals(role) || "customer".equals(role)) {
                Client client = new Client(
                    newUser.getUserId(), newUser.getName(), newUser.getEmail(), newUser.getPhone(), newUser.getAddress()
                );
                return clientManager.addCustomerProfile(client);
            } else if ("vendor".equals(role)) {
                // This is a simplified call; in a real app, Vendor data would come from the Controller
                return vendorManager.addVendorProfile(
                        newUser.getUserId(),
                        "Default Company",
                        "Unspecified Service",
                        newUser.getName(),
                        newUser.getPhone(),
                        newUser.getEmail(),
                        newUser.getAddress(),
                        "Default vendor profile.",
                        new BigDecimal(0), new BigDecimal(1000000), null // MinPrice, MaxPrice, Portfolio
                );
            } else if ("admin".equals(role)) {
                return adminManager.addAdminProfile(newUser.getUserId(), "Standard");
            }
        } catch (Exception e) {
            System.err.println("UserService: Error during role-specific profile creation for role " + role + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
        return false;
    }


    /**

     * Authenticates a user based on email and password.

     *

     * @param email The user's email.

     * @param password The plain text password provided by the user.

     * @return The User object if authentication is successful, null otherwise.

     */

    public User authenticateUser(String email, String password) {

        User user = userDAO.getUserByEmail(email);

        // Ensure getPasswordHash() is used for comparison with BCrypt

        if (user != null && BCrypt.checkpw(password, user.getPasswordHash())) {

            return user;

        }

        return null;

    }


    /**
     * Retrieves a user by their email address.
     * @param email The email of the user to retrieve.
     * @return The User object if found, null otherwise.
     */
    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }
    
    // NOTE: Removed the getUserByEmail() overload that returned List<User> to fix compilation errors.


    /**
     * Retrieves a user by their User ID.
     * @param userId The ID of the user to retrieve.
     * @return The User object if found, null otherwise.
     */
    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    /**
     * Retrieves all users.
     * @return A list of all User objects.
     */
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }


    /**
     * Updates an existing user's information.
     * @param user The User object with updated information.
     * @return true if the user was updated successfully, false otherwise.
     */
    public boolean updateUser(User user) {
        // Add business validation if needed
        if (user == null || user.getUserId() <= 0 || user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            System.err.println("UserService: Invalid user data for update.");
            return false;
        }
        // Hash the password only if it's new and not already hashed
        if (user.getPasswordHash() != null && !user.getPasswordHash().isEmpty() && !user.getPasswordHash().startsWith("$2a$")) {
            user.setPasswordHash(BCrypt.hashpw(user.getPasswordHash(), BCrypt.gensalt()));
        }
        return userDAO.updateUser(user);
    }

    /**
     * Deletes a user from the database by their User ID.
     * @param userId The ID of the user to delete.
     * @return true if the user was deleted successfully, false otherwise.
     */
    public boolean deleteUser(int userId) {
        if (userId <= 0) {
            System.err.println("UserService: Invalid user ID for delete.");
            return false;
        }
        return userDAO.deleteUser(userId);
    }
    
    /**
     * Gets the total number of users in the system.
     * @return The total number of users, or -1 on error.
     */
    public int getTotalUsersCount() {
        try {
            return userDAO.getTotalUsersCount();
        } catch (SQLException e) {
            System.err.println("Error getting total users count: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }
    
    public int getTotalVendorsCount() {
        return getTotalUsersCountByRole("vendor");
    }
    
    /**
     * Gets the total number of users with a specific role.
     * @param role The role to count (e.g., "vendor", "customer").
     * @return The number of users with that role, or -1 on error.
     */
    public int getTotalUsersCountByRole(String role) {
        try {
            return userDAO.getTotalUsersCountByRole(role);
        } catch (SQLException e) {
            System.err.println("Error getting total users count by role: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }

    // This method needs to be implemented completely for proper password change functionality
    public boolean changePassword(int userId, String currentPassword, String newPassword) {
        throw new UnsupportedOperationException("Password change feature is not yet fully implemented.");
    }
    
    /**
 * Registers a new user in the system, handles password hashing, inserts the core
 * user record, and then creates the role-specific profile (Client/Vendor/Admin).
 * This method also orchestrates the transaction rollback if profile creation fails.
 *
 * NOTE: This method replaces the basic registerUser and centralizes the logic 
 * previously spread between the Servlet and the old registerUser method.
 *
 * @param request The HttpServletRequest to extract role-specific data (like companyName).
 * @param name The user's full name.
 * @param email The user's email address.
 * @param password The user's plain text password.
 * @param phone The user's phone number.
 * @param address The user's address.
 * @param role The user's role.
 * @return true if registration and profile creation are successful, false otherwise.
 */
public boolean registerUserAndProfile(HttpServletRequest request, String name, String email, 
                                      String password, String phone, String address, String role) {
    
    // 0. Initial Setup and Validation
    if (userDAO.getUserByEmail(email) != null) {
        request.setAttribute("errorMessage", "Registration failed. The email is already in use.");
        return false;
    }
    
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    User newUser = new User();
    newUser.setName(name);
    newUser.setEmail(email);
    newUser.setPasswordHash(hashedPassword);
    newUser.setPhone(phone != null ? phone : "");
    newUser.setAddress(address != null ? address : "");
    newUser.setRole(role);

    // 1. Insert core user and retrieve new ID
    int newUserId = -1;
    try {
        newUserId = userDAO.registerUser(newUser);
    } catch (SQLException e) {
        System.err.println("UserService: Database error during user creation: " + e.getMessage());
        request.setAttribute("errorMessage", "Database error during core user creation.");
        return false;
    }

    // 2. Check for successful core user creation
    if (newUserId > 0) {
        newUser.setUserId(newUserId);
        
        // 3. Create Role-Specific Profile (passing necessary Request data)
        boolean profileCreated = createRoleSpecificProfile(request, newUser);

        if (profileCreated) {
            return true;
        } else {
            // 4. Critical failure: Handle rollback (delete user)
            System.err.println("UserService: Failed to create role profile. Attempting user deletion: " + email);
            userDAO.deleteUser(newUserId);
            request.setAttribute("errorMessage", "Registration failed due to a profile setup error.");
            return false;
        }
    }
    
    request.setAttribute("errorMessage", "Registration failed. Could not retrieve new User ID.");
    return false;
}

/**
 * Helper method to delegate profile creation to the appropriate manager,
 * extracting specific fields from the request for complex profiles (like Vendor).
 */
private boolean createRoleSpecificProfile(HttpServletRequest request, User newUser) {
    String role = newUser.getRole().toLowerCase();

    try {
        if ("client".equals(role) || "customer".equals(role)) {
            com.ems.model.Client client = new com.ems.model.Client(
                newUser.getUserId(), newUser.getName(), newUser.getEmail(), newUser.getPhone(), newUser.getAddress()
            );
            return clientManager.addCustomerProfile(client);

        } else if ("vendor".equals(role)) {
            // Extract vendor-specific data from the request object
            String companyName = request.getParameter("companyName");
            String serviceType = request.getParameter("serviceType");
            String description = request.getParameter("description");
            String portfolioLink = request.getParameter("portfolioLink");
            String contactPerson = request.getParameter("contactPerson");
            
            BigDecimal minPrice = null;
            String minPriceStr = request.getParameter("minPrice");
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                minPrice = new BigDecimal(minPriceStr);
            }

            BigDecimal maxPrice = null;
            String maxPriceStr = request.getParameter("maxPrice");
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                maxPrice = new BigDecimal(maxPriceStr);
            }
            
            // Input validation for mandatory vendor fields
            if (companyName == null || companyName.trim().isEmpty() || serviceType == null || serviceType.trim().isEmpty()) {
                System.err.println("Vendor mandatory fields missing during profile creation.");
                return false; 
            }

            return vendorManager.addVendorProfile(
                newUser.getUserId(), companyName, serviceType, 
                contactPerson != null ? contactPerson : newUser.getName(),
                newUser.getPhone(), newUser.getEmail(), newUser.getAddress(),
                description, minPrice, maxPrice, portfolioLink
            );
        } else if ("admin".equals(role)) {
            return adminManager.addAdminProfile(newUser.getUserId(), "Standard");
        }
        
    } catch (NumberFormatException e) {
        System.err.println("Invalid price format for Vendor profile: " + e.getMessage());
        request.setAttribute("errorMessage", "Invalid format for minimum/maximum price fields.");
        return false;
    } catch (Exception e) {
        System.err.println("An unexpected error occurred during profile creation: " + e.getMessage());
        e.printStackTrace();
        return false;
    }

    return false;
}
}

