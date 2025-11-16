<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Details - EMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-grey);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }
        .event-details-container {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        .event-details-card {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            max-width: 800px;
            width: 100%;
            text-align: left;
        }
        .event-details-card h2 {
            font-size: 2.2em;
            color: var(--secondary-color);
            margin-bottom: 30px;
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 10px;
        }
        .detail-item {
            margin-bottom: 15px;
            font-size: 1.1em;
            color: var(--text-color);
        }
        .detail-item strong {
            color: var(--secondary-color);
            margin-right: 10px;
            min-width: 150px; /* Align labels */
            display: inline-block;
        }
        .btn-back {
            background-color: var(--primary-color);
            color: #fff;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 30px;
            display: inline-block;
            text-decoration: none;
        }
        .btn-back:hover {
            background-color: var(--secondary-color);
        }
    </style>
</head>
<body>
    <!-- Header Section -->
    <header>
        <nav class="navbar">
            <div class="logo">
                <img src="images/logo.png" alt="EMS">
            </div>
            <ul class="nav-links">
                <li><a href="<%= request.getContextPath() %>/admin/dashboard-display">Admin Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/logout">Logout</a></li>
            </ul>
        </nav>
    </header>

    <div class="event-details-container">
        <div class="event-details-card">
            <h2>Event Details (ID: <c:out value="${event.eventId}" />)</h2>

            <c:if test="${empty event}">
                <p>Event not found.</p>
                <a href="<%= request.getContextPath() %>/admin/dashboard-display#events" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Event Management</a>
            </c:if>

            <c:if test="${not empty event}">
                <div class="detail-item">
                    <strong>Client:</strong> <c:out value="${event.clientName}" /> (ID: <c:out value="${event.clientId}" />)
                </div>
                <div class="detail-item">
                    <strong>Event Type:</strong> <c:out value="${event.type}" />
                </div>
                <div class="detail-item">
                    <strong>Event Date:</strong> <c:out value="${event.date}" />
                </div>
                <div class="detail-item">
                    <strong>Budget:</strong> NPR <c:out value="${event.budget}" />
                </div>
                <div class="detail-item">
                    <strong>Status:</strong> <c:out value="${event.status}" />
                </div>
                <div class="detail-item">
                    <strong>Guest Count:</strong>
                    <c:choose>
                        <c:when test="${not empty event.guestCount}">
                            <c:out value="${event.guestCount}" />
                        </c:when>
                        <c:otherwise>
                            N/A
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="detail-item">
                    <strong>Location Preference:</strong>
                    <c:choose>
                        <c:when test="${not empty event.locationPreference}">
                            <c:out value="${event.locationPreference}" />
                        </c:when>
                        <c:otherwise>
                            N/A
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="detail-item">
                    <strong>Description:</strong>
                    <c:choose>
                        <c:when test="${not empty event.description}">
                            <c:out value="${event.description}" />
                        </c:when>
                        <c:otherwise>
                            No description provided.
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="detail-item">
                    <strong>Assigned Vendor:</strong>
                    <c:choose>
                        <c:when test="${not empty event.assignedVendorName}">
                            <c:out value="${event.assignedVendorName}" /> (ID: <c:out value="${event.assignedVendorId}" />)
                        </c:when>
                        <c:otherwise>
                            None
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="detail-item">
                    <strong>Creation Date:</strong> <c:out value="${event.creationDate}" />
                </div>

                <a href="<%= request.getContextPath() %>/admin/dashboard-display#events" class="btn-back"><i class="fas fa-arrow-left"></i> Back to Event Management</a>
            </c:if>
        </div>
    </div>

    <!-- Footer Section -->
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
