/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ems.util;
import org.mindrot.jbcrypt.BCrypt;


/**
 * Utility class to generate BCrypt hashes for passwords.
 * Run the main method to get hashes for your sample data.
 */
public class PasswordHasher {

    public static void main(String[] args) {
        // Define the plain-text passwords you want to hash
        String adminPassword = "2081400@Samir"; // Use a strong password for admin
        String alicePassword = "alicepassword";
        String bobPassword = "bobpassword";
        String charliePassword = "charliepassword";
        String dianaPassword = "dianapassword";

        // Generate hashes
        String hashedAdminPassword = BCrypt.hashpw(adminPassword, BCrypt.gensalt());
        String hashedAlicePassword = BCrypt.hashpw(alicePassword, BCrypt.gensalt());
        String hashedBobPassword = BCrypt.hashpw(bobPassword, BCrypt.gensalt());
        String hashedCharliePassword = BCrypt.hashpw(charliePassword, BCrypt.gensalt());
        String hashedDianaPassword = BCrypt.hashpw(dianaPassword, BCrypt.gensalt());

        // Print the hashes
        System.out.println("Hashed Password for 'adminpassword': " + hashedAdminPassword);
        System.out.println("Hashed Password for 'alicepassword': " + hashedAlicePassword);
        System.out.println("Hashed Password for 'bobpassword': " + hashedBobPassword);
        System.out.println("Hashed Password for 'charliepassword': " + hashedCharliePassword);
        System.out.println("Hashed Password for 'dianapassword': " + hashedDianaPassword);

        // You can then copy these generated hashes and paste them into your SQL INSERT statements.
        // Make sure your Users table 'password' column is VARCHAR(255) to accommodate the hash length.
    }
}

