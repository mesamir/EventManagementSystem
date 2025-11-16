// src/main/java/com/ems/service/CustomerManager.java
package com.ems.service;

import com.ems.dao.ClientDAO;
import com.ems.model.Client;
import com.ems.dao.UserDAO;
import com.ems.model.User;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ClientManager {
    private ClientDAO ClientDAO;
    private UserDAO userDAO;
    private static final Logger LOGGER = Logger.getLogger(ClientManager.class.getName());
    
    private final ClientDAO clientDAO;
    
        public ClientManager() {
        this.clientDAO = new ClientDAO();
        this.userDAO = new UserDAO();
    }

   


    /**
     * Retrieves the complete client profile, combining data from 'users' and 'clients' tables.
     * @param userId The ID of the core user.
     * @return The complete Client object if found, or null otherwise.
     */
    public Client getCustomerProfileByUserId(int userId) {
        // 1. Get client-specific data (phone, address, customerId)
        Client clientProfile = this.clientDAO.getCustomerByUserId(userId);
        // If the client profile is not found, return null (as expected by the Servlet's corrected logic)
        if (clientProfile == null) {
            return null;
        }
        // 2. Augment with core User data (name, email)
        User coreUser = userDAO.getUserById(userId);
        if (coreUser != null) {
            // Populate the Client object with immutable User data
            clientProfile.setName(coreUser.getName());
            clientProfile.setEmail(coreUser.getEmail());
        } else {
            LOGGER.log(Level.WARNING, "Core user data not found for Client ID: {0}", userId);
        }
        return clientProfile;
    }
  
    /**
     *
     * @return
    */ 
   public List<Client> getAllCustomers() {
    return  clientDAO.getAllCustomers();
}
  

    /**
     * Adds a new client profile record to the 'clients' table.
     * @param client The Client object containing the profile data.
     * @return true if the profile was created successfully.
     */
    public boolean addCustomerProfile(Client client) {
        // NOTE: The core User record should already exist when this is called.
        return clientDAO.addCustomer(client);
    }

    public boolean deleteCustomerProfile(int customerId) {
        if (customerId <= 0) {
            System.err.println("CustomerManager: Invalid customer ID for delete.");
            return false;
        }
        return clientDAO.deleteCustomer(customerId);
    }
    /**
     * Updates an existing client profile record (phone and address) in the 'clients' table.
     * @param client The Client object with updated phone/address and the existing customerId.
     * @return true if the profile was updated successfully.
     */
    public boolean updateCustomerProfile(Client client) {
        return clientDAO.updateCustomer(client);
    }
}

