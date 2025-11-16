<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin: Edit Event - EMS</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            :root {
                --primary-color: #5a67d8;
                --secondary-color: #434190;
                --text-color: #333;
                --light-grey: #f4f7f9;
                --medium-grey: #e2e8f0;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background-color: var(--light-grey);
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                margin: 0;
            }
            .navbar {
                background-color: #fff;
                padding: 1rem 2rem;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .logo img {
                height: 40px;
            }
            .nav-links {
                list-style: none;
                display: flex;
                gap: 20px;
                margin: 0;
            }
            .nav-links a {
                text-decoration: none;
                color: var(--text-color);
                font-weight: 500;
                transition: color 0.3s ease;
            }
            .nav-links a:hover {
                color: var(--primary-color);
            }
            .event-form-container {
                flex-grow: 1;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                padding: 40px 20px;
            }
            .event-form-card {
                background-color: #fff;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                max-width: 800px;
                width: 100%;
            }
            .event-form-card h2 {
                font-size: 2.2em;
                color: var(--secondary-color);
                margin-bottom: 30px;
                text-align: center;
            }
            .form-group {
                margin-bottom: 20px;
                text-align: left;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #555;
            }
            .form-group input[type="text"],
            .form-group input[type="date"],
            .form-group input[type="number"],
            .form-group textarea,
            .form-group select {
                width: 100%;
                padding: 12px 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 1em;
                transition: border-color 0.3s ease;
                box-sizing: border-box;
            }
            .form-group input:focus,
            .form-group textarea:focus,
            .form-group select:focus {
                border-color: var(--primary-color);
                outline: none;
            }
            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }
            .btn-submit {
                background-color: var(--primary-color);
                color: #fff;
                padding: 15px 30px;
                border: none;
                border-radius: 5px;
                font-size: 1.1em;
                cursor: pointer;
                transition: background-color 0.3s ease;
                width: 100%;
                margin-top: 10px;
            }
            .btn-submit:hover {
                background-color: var(--secondary-color);
            }
            .back-link {
                display: block;
                margin-top: 20px;
                color: var(--primary-color);
                text-decoration: none;
                font-weight: 600;
                text-align: center;
            }
            .back-link:hover {
                text-decoration: underline;
            }
            .error-message {
                color: #dc3545;
                margin-bottom: 15px;
                font-weight: 500;
                text-align: center;
            }
            .success-message {
                color: #28a745;
                margin-bottom: 15px;
                font-weight: 500;
                text-align: center;
            }
            .vendor-checkbox-group {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 10px;
                margin-top: 10px;
            }
            .vendor-checkbox-item {
                display: flex;
                align-items: center;
                padding: 10px;
                border: 1px solid #e2e8f0;
                border-radius: 5px;
                transition: all 0.3s ease;
            }
            .vendor-checkbox-item:hover {
                border-color: var(--primary-color);
                background-color: #f8f9ff;
            }
            .vendor-checkbox-item input[type="checkbox"] {
                margin-right: 10px;
            }
            .vendor-info {
                flex: 1;
            }
            .vendor-name {
                font-weight: 500;
                color: #333;
            }
            .vendor-type {
                font-size: 0.875em;
                color: #666;
            }
            .vendor-contact {
                font-size: 0.75em;
                color: #888;
                margin-top: 2px;
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header>
            <nav class="navbar">
                <div class="logo">
                    <img src="<%= request.getContextPath()%>/images/logo.png" alt="EMS">
                </div>
                <ul class="nav-links">
                    <li><a href="<%= request.getContextPath()%>/admin/dashboard">Admin Dashboard</a></li>
                    <li><a href="<%= request.getContextPath()%>/logout">Logout</a></li>
                </ul>
            </nav>
        </header>

        <div class="event-form-container">
            <div class="event-form-card">
                <h2>Admin: Edit Event #<c:out value="${event.eventId}" /></h2>
                
                <!-- Display Messages -->
                <c:if test="${not empty param.error}">
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i> <c:out value="${param.error}" />
                    </div>
                </c:if>
                
                <c:if test="${not empty param.success}">
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i> <c:out value="${param.success}" />
                    </div>
                </c:if>

               <form action="<%= request.getContextPath()%>/admin/event-action" method="POST">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="eventId" value="<c:out value="${event.eventId}" />">

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div class="form-group">
            <label for="clientId">Client ID:</label>
            <input type="number" id="clientId" name="clientId" value="<c:out value="${event.clientId}" />" required>
        </div>
        
        <div class="form-group">
            <label for="type">Event Type:</label>
            <input type="text" id="type" name="type" value="<c:out value="${event.type}" />" required>
        </div>
        
        <div class="form-group">
            <label for="date">Event Date:</label>
            <fmt:formatDate value="${event.date}" pattern="yyyy-MM-dd" var="formattedDate"/>
            <input type="date" id="date" name="date" value="${formattedDate}" required>
        </div>
        
        <div class="form-group">
            <label for="budget">Budget (NPR):</label>
            <input type="number" id="budget" name="budget" step="0.01" min="0" value="<c:out value="${event.budget}" />" required>
        </div>
    </div>

    <div class="form-group">
        <label for="guestCount">Estimated Guest Count:</label>
        <input type="number" id="guestCount" name="guestCount" min="0" value="<c:out value="${event.guestCount}" />">
    </div>
    
    <div class="form-group">
        <label for="location">Location:</label>
        <input type="text" id="location" name="location" value="<c:out value="${event.location}" />">
    </div>
    
    <div class="form-group">
        <label for="description">Description:</label>
        <textarea id="description" name="description"><c:out value="${event.description}" /></textarea>
    </div>

    <div class="form-group">
        <label for="status">Event Status:</label>
        <select id="status" name="status" class="form-control">
            <option value="Pending Approval" <c:if test="${event.status == 'Pending Approval'}">selected</c:if>>Pending Approval</option>
            <option value="Approved" <c:if test="${event.status == 'Approved'}">selected</c:if>>Approved</option>
            <option value="Rejected" <c:if test="${event.status == 'Rejected'}">selected</c:if>>Rejected</option>
            <option value="In Progress" <c:if test="${event.status == 'In Progress'}">selected</c:if>>In Progress</option>
            <option value="Completed" <c:if test="${event.status == 'Completed'}">selected</c:if>>Completed</option>
            <option value="Cancelled" <c:if test="${event.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
        </select>
    </div>

    <!-- Vendor Selection -->
    <div class="form-group">
        <label>Assign Vendors:</label>
        <div class="vendor-checkbox-group">
            <c:forEach var="vendor" items="${vendors}">
                <div class="vendor-checkbox-item">
                    <input type="checkbox" 
                           id="vendor_${vendor.vendorId}" 
                           name="vendorIds" 
                           value="${vendor.vendorId}"
                           <c:forEach var="selectedVendor" items="${event.selectedVendors}">
                               <c:if test="${selectedVendor.vendorId == vendor.vendorId}">checked</c:if>
                           </c:forEach>
                    >
                    <label for="vendor_${vendor.vendorId}" class="vendor-info">
                        <div class="vendor-name"><c:out value="${vendor.companyName}" /></div>
                        <div class="vendor-type"><c:out value="${vendor.serviceType}" /></div>
                    </label>
                </div>
            </c:forEach>
        </div>
    </div>

    <button type="submit" class="btn-submit">
        <i class="fas fa-save"></i> Update Event
    </button>
</form>
                
                <a href="<%= request.getContextPath()%>/admin/dashboard" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Footer Section -->
        <footer style="background-color: #fff; padding: 1rem 2rem; text-align: center; border-top: 1px solid var(--medium-grey);">
            <div class="footer-bottom">
                &copy; 2025 EMS. All Rights Reserved.
            </div>
        </footer>
    </body>
</html>