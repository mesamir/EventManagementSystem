// src/main/java/com/ems/controller/ContactServlet.java
package com.ems.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/contact-submit") // Maps this servlet to /contact-submit
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // --- Server-Side Validation ---
        StringBuilder errorMessage = new StringBuilder();

        if (name == null || name.trim().isEmpty()) {
            errorMessage.append("Your Name is required.<br>");
        }
        if (email == null || email.trim().isEmpty()) {
            errorMessage.append("Your Email is required.<br>");
        } else if (!isValidEmail(email)) {
            errorMessage.append("Please enter a valid email address.<br>");
        }
        if (subject == null || subject.trim().isEmpty()) {
            errorMessage.append("Subject is required.<br>");
        }
        if (message == null || message.trim().isEmpty()) {
            errorMessage.append("Message is required.<br>");
        }

        String redirectUrl;
        if (errorMessage.length() > 0) {
            // If there are errors, redirect back to contact.html with error message
            redirectUrl = request.getContextPath() + "/contact.jsp?errorMessage=" +
                          URLEncoder.encode(errorMessage.toString(), StandardCharsets.UTF_8.toString());

            // Also, pass back the user's input to re-populate the form
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        // --- If validation passes, process the message ---
        // In a real application, you would:
        // 1. Save to database
        // 2. Send an email
        // 3. Log the inquiry
        System.out.println("New Contact Inquiry:");
        System.out.println("Name: " + name);
        System.out.println("Email: " + email);
        System.out.println("Subject: " + subject);
        System.out.println("Message: " + message);
        System.out.println("--- End Contact Inquiry ---");

        // Redirect to contact.html with a success message
        redirectUrl = request.getContextPath() + "/contact.jsp?successMessage=" +
                      URLEncoder.encode("Your message has been sent successfully!", StandardCharsets.UTF_8.toString());
        response.sendRedirect(redirectUrl);
    }

    // Helper method for email validation
    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

    // For GET requests, just forward to the contact page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }
}

