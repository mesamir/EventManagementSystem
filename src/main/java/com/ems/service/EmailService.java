// src/main/java/com/ems/service/EmailService.java
package com.ems.service; 

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.AddressException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger; // Added logging for better visibility

public class EmailService {
    
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    
    // --- LOCAL DEVELOPMENT CONFIGURATION (MailHog) ---
    private static final String SMTP_HOST = "localhost"; // Local machine
    private static final String SMTP_PORT = "1025";      // MailHog's SMTP port
    private static final String FROM_EMAIL = "noreply@ems.com";
    private static final String FROM_NAME = "Event Management System";
    
    // No credentials needed for MailHog
    private static final String USERNAME = "";  
    private static final String PASSWORD = "";  

    public static void sendEmail(String recipientEmail, String subject, String body) throws MessagingException {
        
        // 1. Setup Mail Properties
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.transport.protocol", "smtp");
        // Add properties for reliable non-authenticated local transport
        props.put("mail.smtp.auth", "false"); 
        props.put("mail.smtp.starttls.enable", "false"); 
            
        Session session;
        
        // 2. Get the Session instance (No Auth needed for MailHog)
        if (USERNAME.isEmpty() || PASSWORD.isEmpty()) {
            session = Session.getInstance(props);
        } else {
            // This block is for authenticated services (e.g., Gmail), included for future proofing
            session = Session.getInstance(props, new jakarta.mail.Authenticator() {
                @Override // Use @Override for clarity
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(USERNAME, PASSWORD);
                }
            });
        }
        
        // 3. Construct and Send Message
        try {
            Message message = new MimeMessage(session);
            
            // Set the sender, including the friendly name
            message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME));
            
            // Set the recipient
           message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            
            message.setSubject(subject);
            
            // Set message body
            message.setText(body); 

            Transport.send(message);
            
            LOGGER.log(Level.INFO, "Invitation email sent successfully to: {0}", recipientEmail);
            
        } catch (AddressException e) {
            LOGGER.log(Level.WARNING, "Invalid email address format for recipient: " + recipientEmail, e);
            throw new MessagingException("Invalid email address format.", e);
        } catch (MessagingException e) {
            // Log the transport failure clearly
            LOGGER.log(Level.SEVERE, "Failed to send email to " + recipientEmail + ". Check MailHog connection (localhost:1025).", e);
            throw e; 
        } catch (Exception e) {
            // Catching general exceptions from new InternetAddress(FROM_EMAIL, FROM_NAME)
            LOGGER.log(Level.SEVERE, "General error during email creation.", e);
            throw new MessagingException("General error during email creation.", e);
        }
    }
}