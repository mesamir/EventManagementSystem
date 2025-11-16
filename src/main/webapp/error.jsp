<%-- 
    Document   : error
    Created on : Jul 19, 2025, 6:14:39 PM
    Author     : samir
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Event Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f7f6;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .error-container {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            text-align: center;
        }
        .error-content {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            max-width: 600px;
            width: 100%;
        }
        .error-content h1 {
            font-size: 3em;
            color: #dc3545; /* Red color for error */
            margin-bottom: 20px;
        }
        .error-content h2 {
            font-size: 1.8em;
            color: #555;
            margin-bottom: 15px;
        }
        .error-content p {
            font-size: 1.1em;
            line-height: 1.6;
            margin-bottom: 25px;
        }
        .error-content .btn {
            display: inline-block;
            padding: 12px 25px;
            background-color: #007bff; /* Blue for primary action */
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .error-content .btn:hover {
            background-color: #0056b3;
        }
        /* Message styling (reused from dashboards) */
        .status-message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
        }
        .status-message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <!-- Header Section (optional, can be included for consistent navigation) -->
    <header>
        <nav class="navbar">
            <div class="logo">
                <img src="images/logo.png" alt="EMS">
            </div>
            <ul class="nav-links">
                <li><a href="<%= request.getContextPath() %>/index.html">Home</a></li>
                <li><a href="<%= request.getContextPath() %>/about.html">About Us</a></li>
                <li><a href="<%= request.getContextPath() %>/gallery.html">Gallery</a></li>
                <li><a href="<%= request.getContextPath() %>/login.jsp">Login</a></li> <%-- Corrected: Points to LoginServlet --%>
                <li><a href="<%= request.getContextPath() %>/registration.jsp">Registration</a></li> <%-- Corrected: Points to RegistrationServlet --%>
                <li><a href="<%= request.getContextPath() %>/contact.jsp">Contact Us</a></li>
            </ul>
        </nav>
    </header>

    <div class="error-container">
        <div class="error-content">
            <h1>Oops!</h1>
            <h2>Something went wrong.</h2>
            <p>We apologize for the inconvenience. An unexpected error occurred.</p>

            <%-- Display message from URL parameter if available --%>
            <c:if test="${not empty param.message}">
                <div class="status-message error">
                    <p><c:out value="${param.message}" /></p>
                </div>
            </c:if>

            <%-- Display exception details if this is an error page --%>
            <c:if test="${not empty pageContext.exception}">
                <div class="status-message error" style="text-align: left;">
                    <p><strong>Error Details:</strong></p>
                    <p>Type: <c:out value="${pageContext.exception['class'].name}" /></p>
                    <p>Message: <c:out value="${pageContext.exception.message}" /></p>
                    <%-- For debugging, you might show stack trace: --%>
                    <%-- <pre><c:out value="${pageContext.exception.printStackTrace()}" /></pre> --%>
                </div>
            </c:if>

            <p>Please try again later or contact support if the problem persists.</p>
            <a href="<%= request.getContextPath() %>/index.html" class="btn"><i class="fas fa-home"></i> Go to Homepage</a>
            <a href="javascript:history.back()" class="btn" style="background-color: #6c757d;"><i class="fas fa-arrow-left"></i> Go Back</a>
        </div>
    </div>

    <!-- Footer Section (optional, can be included for consistent navigation) -->
    <footer>
        <div class="footer-columns">
            <div class="footer-column">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/index.html">Home</a></li>
                    <li><a href="<%= request.getContextPath() %>/about.html">About Us</a></li>
                    <li><a href="<%= request.getContextPath() %>/gallery.html">Gallery</a></li>
                    <li><a href="<%= request.getContextPath() %>/contact.jsp">Contact Us</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4>Our Services</h4>
                <ul>
                    <li><a href="#">Wedding Planning</a></li>
                    <li><a href="#">Corporate Events</a></li>
                    <li><a href="#">Private Parties</a></li>
                    <li><a href="#">Vendor Management</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4>Contact Info</h4>
                <p><i class="fas fa-map-marker-alt"></i> Kathmandu, Nepal</p>
                <p><i class="fas fa-phone"></i> +977 9876543210</p>
                <p><i class="fas fa-envelope"></i> info@ems.com.np</p>
            </div>
            <div class="footer-column">
                <h4>Follow Us</h4>
                <p>Stay connected with us on social media for updates and event inspirations.</p>
                <div class="social-icons">
                    <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            &copy; 2025 EMS. All Rights Reserved.
        </div>
    </footer>
</body>
</html>

