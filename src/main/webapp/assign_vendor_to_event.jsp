<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Vendor to Event - EMS</title>
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
        .form-container {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        .form-card {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            max-width: 600px;
            width: 100%;
            text-align: center;
        }
        .form-card h2 {
            font-size: 2.2em;
            color: var(--secondary-color);
            margin-bottom: 30px;
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
        .form-group select {
            width: calc(100% - 20px);
            padding: 12px 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }
        .form-group select:focus {
            border-color: var(--primary-color);
            outline: none;
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
        }
        .back-link:hover {
            text-decoration: underline;
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

    <div class="form-container">
        <div class="form-card">
            <h2>Assign Vendor to Event (ID: <c:out value="${event.eventId}" />)</h2>
            <p><strong>Event Type:</strong> <c:out value="${event.type}" /></p>
            <p><strong>Event Date:</strong> <c:out value="${event.date}" /></p>
            <p><strong>Current Assigned Vendor:</strong>
                <c:choose>
                    <c:when test="${not empty event.assignedVendorName}">
                        <c:out value="${event.assignedVendorName}" /> (ID: <c:out value="${event.assignedVendorId}" />)
                    </c:when>
                    <c:otherwise>
                        None
                    </c:otherwise>
                </c:choose>
            </p>

            <form action="<%= request.getContextPath() %>/admin/event-action" method="POST">
                <input type="hidden" name="action" value="assign">
                <input type="hidden" name="eventId" value="${event.eventId}">

                <div class="form-group">
                    <label for="vendorId">Select Vendor:</label>
                    <select id="vendorId" name="vendorId">
                        <option value="">-- Select a Vendor (Unassign) --</option>
                        <c:forEach var="vendor" items="${vendors}">
                            <option value="${vendor.vendorId}"
                                <c:if test="${event.assignedVendorId != null && event.assignedVendorId == vendor.vendorId}">selected</c:if>>
                                <c:out value="${vendor.companyName}" /> (<c:out value="${vendor.serviceType}" />)
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit" class="btn-submit"><i class="fas fa-link"></i> Assign Vendor</button>
            </form>

            <a href="<%= request.getContextPath() %>/admin/dashboard-display#events" class="back-link"><i class="fas fa-arrow-left"></i> Back to Event Management</a>
        </div>
    </div>

    <!-- Footer Section -->
    <footer>
        
        <div class="footer-bottom">
            &copy; 2025 EMS. All Rights Reserved.
        </div>
    </footer>
</body>
</html>
