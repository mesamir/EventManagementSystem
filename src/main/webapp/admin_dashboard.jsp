<%@page import="com.google.gson.Gson"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ems.model.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.math.BigDecimal" %>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Event Management System</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Use the Inter font from Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="${pageContext.request.contextPath}/admin.js"></script> 
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/adminDashboard.css">
    <style>
    :root {
    /* --- Main Palette --- */
    --primary-color: #1e3a8a; /* A deep, professional blue */
    --primary-color-hover: #64748b;
    --secondary-color: #4b5563; /* A warm, dark charcoal gray */
    --secondary-color-hover: #374151;
    --accent-color: #0d9488; /* A modern, vibrant teal for highlights */
    --accent-color-hover: #087f73;

    /* --- Status & Alerts --- */
    --success-color: #10b981; /* Green for success messages */
    --success-color-hover: #059669;
    --danger-color: #ef4444; /* Red for errors and danger */
    --danger-color-hover: #dc2626;
    --info-color: #3b82f6; /* Blue for informational messages and buttons */
    --info-color-hover: #2563eb;
    
    /* --- Backgrounds & Text --- */
    --body-bg: #f9fafb; /* A very light gray for the page background */
    --card-bg: #ffffff; /* Pure white for content cards */
    --sidebar-bg: #1f2937; /* A very dark gray for the sidebar */
    --text-color: #1f2937; /* A dark gray for most text */
    --text-color-light: #e5e7eb; /* A light gray for text on dark backgrounds */
}

/* --- General Styles --- */
body {
    font-family: 'Inter', sans-serif;
    background-color: var(--body-bg);
    color: var(--text-color);
}
.section-header {
    border-bottom: 2px solid #e5e7eb;
    padding-bottom: 0.75rem;
    margin-bottom: 1.5rem;
}
.message-box {
    padding: 1rem;
    border-radius: 0.5rem;
    margin-bottom: 1.5rem;
    font-weight: 600;
    border: 1px solid;
}
.message-box.success {
    background-color: #d1fae5;
    color: #065f46;
    border-color: #34d399;
}
.message-box.error {
    background-color: #fee2e2;
    color: #991b1b;
    border-color: #ef4444;
}
.form-container {
    display: none; /* Hidden by default */
}
.form-container.active {
    display: block; /* Show when active */
}
.alert-message {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 1rem 1.5rem;
    border-radius: 0.5rem;
    color: white;
    font-weight: 600;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    z-index: 1000;
    transition: opacity 0.5s ease-in-out, transform 0.5s ease-in-out;
}
.alert-success {
    background-color: #4CAF50;
}
.alert-error {
    background-color: #F44336;
}

/* --- Buttons --- */
.btn {
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.2s;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
}
.btn-primary {
    background-color: var(--primary-color);
    color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.btn-primary:hover {
    background-color: var(--primary-color-hover);
    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
}
.btn-secondary {
    background-color: var(--secondary-color);
    color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.btn-secondary:hover {
    background-color: var(--secondary-color-hover);
    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
}
.btn-danger {
    background-color: var(--danger-color);
    color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.btn-danger:hover {
    background-color: var(--danger-color-hover);
    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
}
.btn-success {
    background-color: var(--success-color);
    color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.btn-success:hover {
    background-color: var(--success-color-hover);
    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
}
/* New styles for small action buttons */
.btn-sm {
    padding: 0.3rem 0.6rem;
    font-size: 0.8rem;
    border-radius: 0.3rem;
}
/* New style for the view button */
.btn-info {
    background-color: var(--info-color);
    color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.btn-info:hover {
    background-color: var(--info-color-hover);
    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
}

/* --- Forms --- */
.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #4b5563;
}
.form-group input, .form-group select, .form-group textarea {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #d1d5db;
    border-radius: 0.5rem;
    font-size: 1rem;
    color: #374151;
    background-color: #ffffff;
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
    outline: none;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.25);
}

/* --- Modals --- */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4);
    justify-content: center;
    align-items: center;
}
.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 2rem;
    border-radius: 0.75rem;
    width: 90%;
    max-width: 500px;
    box-shadow: 0 10px 15px rgba(0,0,0,0.2);
    position: relative;
}
.close-button {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}
.close-button:hover, .close-button:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
.delete-modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4);
    align-items: center;
    justify-content: center;
}
/* --- Dashboard Layout --- */
.dashboard-container {
    display: flex;
    align-items: flex-start;
    min-height: calc(100vh - 64px);
}
.sidebar {
    width: 250px;
    background-color: var(--sidebar-bg);
    color: var(--text-color-light);
    padding: 1.5rem;
    overflow-y: auto;
    box-shadow: 2px 0 5px rgba(0,0,0,0.1);
    flex-shrink: 0;
    position: sticky;
    top: 0;
}
.sidebar h3 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    color: #cbd5e0;
}
.sidebar-menu li {
    margin-bottom: 1rem;
}
.sidebar-menu a {
    display: flex;
    align-items: center;
    padding: 0.75rem 1rem;
    border-radius: 0.5rem;
    color: var(--text-color-light);
    text-decoration: none;
    transition: background-color 0.2s, color 0.2s;
}
.sidebar-menu a:hover,
.sidebar-menu a.active {
    background-color: #4a5568;
    color: #fff;
}
.sidebar-menu a i {
    margin-right: 0.75rem;
    font-size: 1.1rem;
}
.main-content {
    flex-grow: 1;
    width: 100%;
    display: flex;
    flex-direction: column;
    padding: 2rem;
    gap: 2rem;
    background-color: #f7fafc;
    overflow: auto;
}
/* --- Dashboard Sections (Redesigned) --- */
.dashboard-section {
    background-color: var(--card-bg);
    padding: 2rem;
    border-radius: 0.75rem;
    /* Layered, more pronounced shadow for a 'floating' effect */
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    margin-bottom: 2rem;
    overflow: hidden; /* Changed to hidden to contain child elements */
    width: 100%;
    /* Subtle transition for a smooth hover effect */
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
}
.dashboard-section:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}
.dashboard-section h2 {
    font-size: 1.75rem;
    font-weight: 700;
    color: var(--text-color);
    margin-bottom: 1.5rem;
    border-bottom: 2px solid #e2e8f0; /* Softer border color */
    padding-bottom: 1rem;
}

/* --- Stats Grid (Redesigned) --- */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); /* Slightly larger cards */
    gap: 2rem; /* Increased gap for more breathing room */
    margin-bottom: 2rem;
}
.stat-card {
    background-color: var(--card-bg);
    padding: 1.5rem;
    border-radius: 0.75rem;
    /* Layered shadow, same as section for consistency */
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    text-align: center;
    border: 1px solid #e2e8f0; /* Subtle border for better definition */
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
}
.stat-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
}
.stat-card h4 {
    font-size: 2.25rem;
    font-weight: 700;
    color: var(--primary-color);
    margin-bottom: 0.5rem;
}
.stat-card p {
    font-size: 1rem;
    color: var(--secondary-color);
}
/* Updated stat card color schemes for a softer, more modern palette */
.stat-card.secondary {
    border-color: #ffedd5;
}
.stat-card.secondary h4 {
    color: #f97316;
}
.stat-card.accent {
    border-color: #dcfce7;
}
.stat-card.accent h4 {
    color: #10b981;
}

/* --- Tables --- */
.table-container {
    /* Ensures no horizontal overflow */
    overflow-x: auto;
}
table {
    width: 100%;
    border-collapse: collapse;
}
th, td {
    padding: 0.75rem;
    text-align: left;
    border-bottom: 1px solid #e5e7eb;
    /* Prevents content from wrapping in cells */
    white-space: nowrap;
    /* Reduced font size for a cleaner look */
    font-size: 0.875rem; 
}
th {
    background-color: #f9fafb;
    font-weight: 600;
    color: #374151;
    text-transform: uppercase;
    font-size: 0.75rem;
}
tr:hover {
    background-color: #f3f4f6;
}
.report-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 1rem;
}
.report-table th, .report-table td {
    padding: 1rem;
    text-align: left;
    border-bottom: 1px solid #e5e7eb;
}
.report-table th {
    background-color: #f9fafb;
    font-weight: 600;
    color: #4b5563;
}
.report-table tr:hover {
    background-color: #f1f5f9;
}
/* --- Responsive Adjustments --- */
@media (max-width: 992px) {
    .dashboard-container {
        flex-direction: column;
    }
    .sidebar {
        width: 100%;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px 0;
        position: static;
        height: auto;
    }
    .sidebar h3 {
        margin-bottom: 20px;
    }
    .sidebar-menu {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
    }
    .sidebar-menu li a {
        padding: 10px 15px;
        margin: 5px;
        border-radius: 5px;
    }
    .sidebar-menu li a i {
        margin-right: 8px;
    }
    .main-content {
        padding: 30px 20px;
    }
    .dashboard-section {
        padding: 20px;
    }
}
@media (max-width: 576px) {
    .main-content {
        padding: 20px 15px;
    }
    .dashboard-section h2 {
        font-size: 1.8em;
    }
    table, thead, tbody, th, td, tr {
        display: block;
    }
    thead tr {
        position: absolute;
        top: -9999px;
        left: -9999px;
    }
    tr { border: 1px solid #eee; margin-bottom: 15px; border-radius: 5px; overflow: hidden;}
    td {
        border: none;
        border-bottom: 1px solid #eee;
        position: relative;
        padding-left: 50%;
        text-align: right;
    }
    td:before {
        position: absolute;
        top: 0;
        left: 6px;
        width: 45%;
        padding-right: 10px;
        white-space: nowrap;
        text-align: left;
        font-weight: 600;
        color: var(--secondary-color);
    }
}
/* Removing @apply directives as they require a build process */
.btn-report {
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    font-weight: 600;
    transition: all 0.2s ease-in-out;
    background-color: #e0e7ff;
    color: #4338ca;
}
.btn-report:hover {
    background-color: #c7d2fe;
}
.btn-report.active {
    background-color: #4338ca;
    color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}
.btn-primary {
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    font-weight: 600;
    background-color: #3b82f6;
    color: white;
    transition-property: background-color, border-color, color, fill, stroke, opacity, box-shadow, transform;
    transition-duration: 200ms;
}
.btn-primary:hover {
    background-color: #2563eb;
}
.btn-success {
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    font-weight: 600;
    background-color: #22c55e;
    color: white;
    transition-property: background-color, border-color, color, fill, stroke, opacity, box-shadow, transform;
    transition-duration: 200ms;
}
.btn-success:hover {
    background-color: #16a34a;
}
.filter-select {
    border: 1px solid #d1d5db;
    border-radius: 0.5rem;
    padding: 0.5rem 1rem;
    color: #4b5563;
    outline: none;
    font-size: 1rem;
}
.filter-select:focus {
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
    border-color: #3b82f6;
}
 /* Custom styles for buttons based on your previous examples */
        .btn-report, .btn-small {
            @apply px-4 py-2 font-semibold text-white rounded-lg transition-all duration-300 ease-in-out;
        }
       #reportChart {
    /* Sets the height of the canvas element */
    height: 400px; 
    /* Ensures the chart fills the container's width */
    width: 100%; 
}
/* --- Pagination Styles --- */
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 0.5rem;
    margin-top: 1.5rem;
    padding: 1rem 0;
}

.pagination-btn {
    padding: 0.5rem 1rem;
    border: 1px solid #d1d5db;
    background-color: white;
    color: #374151;
    border-radius: 0.375rem;
    cursor: pointer;
    transition: all 0.2s;
    font-weight: 500;
}

.pagination-btn:hover:not(:disabled) {
    background-color: #3b82f6;
    color: white;
    border-color: #3b82f6;
}

.pagination-btn.active {
    background-color: #3b82f6;
    color: white;
    border-color: #3b82f6;
}

.pagination-btn:disabled {
    background-color: #f3f4f6;
    color: #9ca3af;
    cursor: not-allowed;
}

.pagination-info {
    margin: 0 1rem;
    color: #6b7280;
    font-size: 0.875rem;
}

.page-size-selector {
    margin-left: auto;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.page-size-selector select {
    padding: 0.5rem;
    border: 1px solid #d1d5db;
    border-radius: 0.375rem;
    background-color: white;
}
/* Add to your existing CSS */
.dashboard-section {
    transition: all 0.3s ease-in-out;
}

/* Loading animation */
.fa-spinner {
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}


        
</style>
</head>
<body class="bg-gray-100">
    
    <%!
        // Utility function to escape single quotes and backslashes for JavaScript string literals
        private String escapeJsString(String s) {
            if (s == null) {
                return ""; // Return empty string for null to avoid NullPointerException
            }
            // Escape backslashes first, then single quotes
            return s.replace("\\", "\\\\").replace("'", "\\'");
        }

        // Declare a static DateTimeFormatter for efficiency and consistency
        private static final DateTimeFormatter JAVASCRIPT_DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    %>
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
        <header class="bg-white shadow p-4 flex justify-between items-center">
    <h1 class="text-2xl font-bold text-gray-800">Admin Dashboard</h1>
    <nav>
        <%-- CORRECTED: Link to the Admin Profile Servlet/Page --%>
        <a href="<%= request.getContextPath() %>/admin/profile">
            <button class="btn btn-secondary">
                <i class="fas fa-user-circle"></i>
                My Profile
            </button>
        </a>
        
        <a href="<%= request.getContextPath() %>/admin/logout" class="btn btn-secondary">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
</header>
                    

        <main class="dashboard-container">
            <!-- Sidebar Navigation -->
            <aside class="sidebar">
                <h3>Admin Panel</h3>
                <ul class="sidebar-menu">
                    <li><a href="#overview" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                  
                    <li><a href="#users"><i class="fas fa-users"></i> User Management</a></li>
                    <li><a href="#events"><i class="fas fa-calendar-alt"></i> Event Management</a></li>
                    <li><a href="#vendors"><i class="fas fa-store"></i> Vendor Management</a></li>
                    <li><a href="#bookings"><i class="fas fa-book-open"></i> Booking Management</a></li>
                    <li><a href="#payments"><i class="fas fa-money-bill-wave"></i> Payment Tracking</a></li>
                    <li><a href="#reports"><i class="fas fa-chart-bar"></i> Reports</a></li>
                    <li>
                        <a href="#" data-target="cms" id="loadCMS">
                            <i class="fas fa-cog mr-3"></i> CMS
                        </a>
                    </li>
                    
                    <li><a href="<%= request.getContextPath()%>/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </aside>

            <!-- Main Content -->
            <section class="main-content">
                <!-- Message Display -->
                
                                <%
                                    String successMessage = request.getParameter("successMessage");
                                    String errorMessage = request.getParameter("errorMessage");
                                    if (successMessage != null && !successMessage.isEmpty()) {
                                %>
                    <div class="message-box success">
                        <%= successMessage %>
                    </div>
                <%
                    }
                    if (errorMessage != null && !errorMessage.isEmpty()) {
                %>
                    <div class="message-box error">
                        <%= errorMessage %>
                    </div>
                <%
                    }
                %>

                <div id="overview" class="dashboard-section">
                <h2>Dashboard Overview</h2>
                <p class="text-gray-700 mb-4">Welcome, <c:out value="${loggedInUser.name}" />!</p>

                <div class="stats-grid">
                    <div class="stat-card">
                        <h4><c:out value="${fn:length(users)}" /></h4>
                        <p>Total Users</p>
                    </div>
                    <div class="stat-card secondary">
                        <h4><c:out value="${fn:length(events)}" /></h4>
                        <p>Total Events</p>
                    </div>
                    <div class="stat-card accent">
                        <h4><c:out value="${fn:length(bookings)}" /></h4>
                        <p>Total Bookings</p>
                    </div>
                   <div class="stat-card">
                            <c:set var="pendingBookingsCount" value="${0}" />
                            <c:forEach var="booking" items="${bookings}">
                                <c:if test="${(booking.status eq 'Pending' || booking.status eq 'Advance Payment Due')}">
                                    <c:set var="pendingBookingsCount" value="${pendingBookingsCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <h4><c:out value="${pendingBookingsCount}" /></h4>
                            <p>Pending Bookings</p>
                        </div>
                    <div class="stat-card">
                        <h4>NPR <fmt:formatNumber value="${totalRevenue}" minFractionDigits="2" maxFractionDigits="2" /></h4>
                        <p>Total Revenue (Paid)</p>
                    </div>
                    <div class="stat-card secondary">
                        <h4>NPR <fmt:formatNumber value="${adminShare}" minFractionDigits="2" maxFractionDigits="2" /></h4>
                        <p>My Share Revenue</p>
                    </div>
                    <div class="stat-card accent">
                        <h4><c:out value="${fn:length(vendors)}" /></h4>
                        <p>Total Vendors</p>
                    </div>
                    <div class="stat-card">
                        <h4><c:out value="${fn:length(customers)}" /></h4>
                        <p>Total Clients</p>
                    </div>
                </div>

                <!-- Chart Data -->
            <script type="application/json" id="revenueChartData">
            {
                "Total Revenue": ${totalRevenue},
                "Admin Share": ${adminShare}
            }
            </script>

            <script type="application/json" id="userStatsChartData">
            {
                "Total Vendors": ${fn:length(vendors)},
                "Total Clients": ${fn:length(customers)},
                "Total Users": ${fn:length(users)}
            }
            </script>

            <script type="application/json" id="eventStatsChartData">
            {
                "Total Events": ${fn:length(events)},
                "Total Bookings": ${fn:length(bookings)},
                "Pending Bookings": ${pendingBookingsCount}
            }
            </script>


        
             <!-- Three Charts Container -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-8">
                <!-- Revenue Chart -->
                <div class="bg-white p-6 rounded-xl shadow-lg">
                    <h3 class="text-lg font-semibold text-gray-800 mb-4">Revenue Overview</h3>
                    <div style="height: 300px;">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <!-- User Statistics Chart -->
                <div class="bg-white p-6 rounded-xl shadow-lg">
                    <h3 class="text-lg font-semibold text-gray-800 mb-4">User Statistics</h3>
                    <div style="height: 300px;">
                        <canvas id="userStatsChart"></canvas>
                    </div>
                </div>

                <!-- Event Statistics Chart -->
                <div class="bg-white p-6 rounded-xl shadow-lg">
                    <h3 class="text-lg font-semibold text-gray-800 mb-4">Event & Booking Stats</h3>
                    <div style="height: 300px;">
                        <canvas id="eventStatsChart"></canvas>
                    </div>
                </div>

        </div>
            </div>



                
                <!-- User Management Section -->
                <section id="users" class="dashboard-section">
                    <h2 class="text-xl font-semibold text-gray-700 section-header">
                        <i class="fas fa-users mr-2"></i>User Management
                    </h2>
                    <div class="flex justify-end mb-4">
                        <button class="btn btn-primary" onclick="showForm('userForm', 'add', 'Add User')">
                            <i class="fas fa-plus-circle"></i> Add New User
                        </button>
                    </div>

                    <!-- Add/Edit User Form -->
                    <div id="userForm" class="form-container bg-gray-50 p-6 rounded-lg shadow-inner mb-6">
                        <h3 id="userFormTitle" class="text-lg font-semibold text-gray-700 mb-4">Add User</h3>
                        <form id="userCrudForm" action="<%= request.getContextPath() %>/admin/users" method="POST">
                            <input type="hidden" name="action" id="userFormAction" value="add">
                            <input type="hidden" name="userId" id="userId">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                                <div class="form-group">
                                    <label for="userName">Name:</label>
                                    <input type="text" id="userName" name="name" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="userEmail">Email:</label>
                                    <input type="email" id="userEmail" name="email" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="userPassword">Password:</label>
                                    <input type="password" id="userPassword" name="password" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="userPhone">Phone:</label>
                                    <input type="tel" id="userPhone" name="phone" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="userAddress">Address:</label>
                                    <input type="text" id="userAddress" name="address" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="userRole">Role:</label>
                                    <select id="userRole" name="role" required class="w-full">
                                        <option value="customer">Client</option>
                                        <option value="vendor">Vendor</option>
                                        <option value="admin">Admin</option>
                                    </select>
                                    <!-- Add this after the role select field in userForm -->
                                    <div id="roleInfoAlert" class="hidden mb-4 p-3 rounded-lg border">
                                        <div id="roleInfoText"></div>
                                    </div>
                                </div>
                                
                                <!-- Vendor-specific fields (shown only when role is vendor) -->
                                <div id="vendorFields" class="hidden grid grid-cols-1 md:grid-cols-2 gap-4 mb-4 p-4 bg-blue-50 rounded-lg">
                                    <div class="form-group">
                                        <label for="vendorCompanyName">Company Name:</label>
                                        <input type="text" id="vendorCompanyName" name="companyName" class="w-full" 
                                               placeholder="Optional - will use user name + 'Company' if empty">
                                    </div>
                                    <div class="form-group">
                                        <label for="vendorServiceType">Service Type:</label>
                                        <select id="vendorServiceType" name="serviceType" class="w-full">
                                            <option value="">Select Service Type (Optional)</option>
                                            <option value="Venue">Venue</option>
                                            <option value="Catering">Catering</option>
                                            <option value="Photography">Photography</option>
                                            <option value="Entertainment">Entertainment</option>
                                            <option value="Decoration">Decoration</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                </div>

                            </div>
                            <div class="flex justify-end gap-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save"></i> Save User
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="hideForm('userForm')">
                                    <i class="fas fa-times-circle"></i> Cancel
                                </button>
                            </div>
                        </form>
                    </div>
                            <!-- Add this container to your body, perhaps near the top, to display messages -->
                    <div id="messageContainer"></div>
                    <!-- Delete Confirmation Modal (Add this to your HTML body) -->
                    <div id="deleteUserModal" class="delete-modal">
                        <div class="modal-content">
                            <h3 class="text-lg font-semibold mb-4">Confirm Deletion</h3>
                            <p>Are you sure you want to delete user: <span id="deleteUserName" class="font-bold"></span>?</p>
                            <form id="deleteUserForm" action="<%= request.getContextPath() %>/admin/users" method="POST" class="mt-4">
                              <input type="hidden" name="idToDelete" id="idToDelete">
                                <input type="hidden" name="action" value="delete">

                                <div class="flex justify-end gap-2">
                                    <button type="submit" class="btn btn-danger">Yes, Delete</button>
                                    <button type="button" class="btn btn-secondary" onclick="hideDeleteModal()">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- User List Table -->
                    <div class="table-container bg-white rounded-lg shadow">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty users}">
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                 <td><c:out value="${user.userId}" /></td>
                                                <td><c:out value="${user.name}" /></td>
                                                <td><c:out value="${user.email}" /></td>
                                                <td><c:out value="${user.phone != null ? user.phone : '-'}" /></td>
                                                <td><c:out value="${user.address != null ? user.address : '-'}" /></td>
                                                <td><c:out value="${user.role}" /></td>
                                                <td class="flex gap-2">
                                                    <button class="btn btn-primary btn-sm"
                                                            onclick="editUserFromTable(
                                                                ${user.userId},
                                                                '<c:out value="${user.name}" escapeXml="true"/>',
                                                                '<c:out value="${user.email}" escapeXml="true"/>',
                                                                '<c:out value="${user.phone != null ? fn:escapeXml(user.phone) : ''}" />',
                                                                '<c:out value="${user.address != null ? fn:escapeXml(user.address) : ''}" />',
                                                                '<c:out value="${user.role}" escapeXml="true"/>'
                                                            )">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </button>
                                                    <button class="btn btn-danger btn-sm"
                                                            onclick="confirmDelete('user', <c:out value="${user.userId}" />)">
                                                        <i class="fas fa-trash-alt"></i> Delete
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center text-gray-500 py-4">No users found.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>
                <!-- Vendor Assignment Modal -->
                <!-- Vendor Assignment Modal -->

                <!-- Event Management Section -->
                <section id="events" class="dashboard-section">
                    <h2 class="text-xl font-semibold text-gray-700 section-header">
                        <i class="fas fa-calendar-alt mr-2"></i>Event Management
                    </h2>
                    <div class="flex justify-end mb-4">
                        <button class="btn btn-primary" onclick="showForm('eventForm', 'add', 'Add Event')">
                            <i class="fas fa-plus-circle"></i> Add New Event
                        </button>
                    </div>

                    <!-- Add/Edit Event Form -->
                    <div id="eventForm" class="form-container bg-gray-50 p-6 rounded-lg shadow-inner mb-6">
                        <h3 id="eventFormTitle" class="text-lg font-semibold text-gray-700 mb-4">Add Event</h3>
                        <form id="eventCrudForm" action="<%= request.getContextPath() %>/admin/event-action" method="POST">
                            <input type="hidden" name="action" id="eventFormAction" value="create">
                            <input type="hidden" name="eventId" id="eventId">
                             
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                                <div class="form-group">
                                    <label for="eventClientId">Client ID:</label>
                                    <input type="number" id="eventClientId" name="clientId" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="eventType">Type:</label>
                                    <input type="text" id="eventType" name="type" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="eventDescription">Description:</label>
                                    <textarea id="eventDescription" name="description" rows="3" class="w-full"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="eventDate">Date:</label>
                                    <input type="Date" id="eventDate" name="date" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="eventLocation">Location:</label>
                                    <input type="text" id="eventLocation" name="location" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="eventBudget">Budget:</label>
                                    <input type="number" step="0.01" id="eventBudget" name="budget" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="eventStatus">Status:</label>
                                    <select id="eventStatus" name="status" required class="w-full">
                                        <option value="Pending Approval">Pending Approval</option>
                                                <option value="Approved">Approved</option>
                                                <option value="Vendor Confirmed">Vendor Confirmed</option>
                                                <option value="Advance Paid">Advance Paid</option>
                                                <option value="Confirmed">Confirmed</option>
                                                <option value="In Progress">In Progress</option>
                                                <option value="Completed">Completed</option>
                                                <option value="Rejected">Rejected</option>
                                                <option value="Cancelled">Cancelled</option>
                                    </select>
                                </div>
                                <!-- Add this section to your event form after the status field -->
<div class="form-group md:col-span-2">
    <label for="eventVendors">Select Vendors:</label>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3 max-h-48 overflow-y-auto border border-gray-200 rounded-lg p-3">
        <c:forEach var="vendor" items="${vendors}">
            <div class="flex items-center">
                <input type="checkbox" id="vendor-${vendor.vendorId}" 
                       name="vendorIds" value="${vendor.vendorId}" 
                       class="mr-2 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
                <label for="vendor-${vendor.vendorId}" class="text-sm text-gray-700">
                    <c:out value="${vendor.companyName}"/> 
                    <span class="text-gray-500 text-xs">(<c:out value="${vendor.serviceType}"/>)</span>
                </label>
            </div>
        </c:forEach>
        <c:if test="${empty vendors}">
            <p class="text-gray-500 text-sm col-span-3">No vendors available</p>
        </c:if>
    </div>
</div>
                            </div>
                             
                            <div class="flex justify-end gap-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save"></i> Save Event
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="hideForm('eventForm')">
                                    <i class="fas fa-times-circle"></i> Cancel
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Event List Table -->
                    <!-- Event List Table -->
    <div class="table-container bg-white rounded-lg shadow">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Client ID</th>
                    <th>Type</th>
                    <th>Description</th>
                    <th>Date</th>
                    <th>Location</th>
                    <th>Budget</th>
                    <th>Status</th>
                    <th>Vendors</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty events}">
                        <c:forEach var="event" items="${events}">
                           <tr>
                                <td><c:out value="${event.eventId}" /></td>
                                <td><c:out value="${event.clientId}" /></td>
                                <td>
                                    <span class="inline-flex items-center px-2 py-1 bg-purple-100 text-purple-800 text-xs rounded font-medium">
                                        <c:out value="${event.type}" />
                                    </span>
                                </td>
                                <td class="max-w-xs">
                                    <c:choose>
                                        <c:when test="${not empty event.description}">
                                            <div class="truncate" title="<c:out value='${event.description}'/>">
                                                <c:out value="${event.description}" />
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty event.date}">
                                            <fmt:formatDate value="${event.date}" pattern="MMM dd, yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty event.location}">
                                            <div class="truncate max-w-xs" title="<c:out value='${event.location}'/>">
                                                <c:out value="${event.location}" />
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty event.budget}">
                                            <span class="font-medium text-green-600">
                                                NPR <fmt:formatNumber value="${event.budget}" type="number" maxFractionDigits="2"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${event.status == 'Completed'}">
                                            <span class="inline-flex items-center px-2 py-1 bg-green-100 text-green-800 text-xs rounded-full font-medium">
                                                <i class="fas fa-check-circle mr-1"></i>
                                                <c:out value="${event.status}"/>
                                            </span>
                                        </c:when>
                                        <c:when test="${event.status == 'In Progress'}">
                                            <span class="inline-flex items-center px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full font-medium">
                                                <i class="fas fa-spinner mr-1"></i>
                                                <c:out value="${event.status}"/>
                                            </span>
                                        </c:when>
                                        <c:when test="${event.status == 'Pending Approval'}">
                                            <span class="inline-flex items-center px-2 py-1 bg-yellow-100 text-yellow-800 text-xs rounded-full font-medium">
                                                <i class="fas fa-clock mr-1"></i>
                                                <c:out value="${event.status}"/>
                                            </span>
                                        </c:when>
                                        <c:when test="${event.status == 'Cancelled'}">
                                            <span class="inline-flex items-center px-2 py-1 bg-red-100 text-red-800 text-xs rounded-full font-medium">
                                                <i class="fas fa-times-circle mr-1"></i>
                                                <c:out value="${event.status}"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded-full font-medium">
                                                <c:out value="${event.status}"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">
                                    <c:choose>
                                        <c:when test="${not empty event.selectedVendors && fn:length(event.selectedVendors) > 0}">
                                            <div class="flex flex-col gap-1">
                                                <c:forEach var="vendor" items="${event.selectedVendors}" varStatus="status">
                                                    <c:if test="${status.index < 2}">
                                                        <span class="inline-flex items-center px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded">
                                                            <i class="fas fa-building mr-1"></i>
                                                            <c:out value="${vendor.companyName}"/>
                                                        </span>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${fn:length(event.selectedVendors) > 2}">
                                                    <span class="text-xs text-gray-500">+${fn:length(event.selectedVendors) - 2} more</span>
                                                </c:if>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400">No vendors selected</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="flex gap-2">
                                    <!-- View Event Details -->
                                    <button class="btn btn-info btn-sm"
                                            onclick="viewEventDetails(${event.eventId})">
                                        <i class="fas fa-eye"></i> View
                                    </button>

                                    <!-- Edit Event -->
                                    <button class="btn btn-primary btn-sm"
                                            onclick="editEventFromTable(
                                                ${event.eventId},
                                                ${event.clientId},
                                                '<c:out value="${event.type}" escapeXml="true"/>',
                                                '<c:out value="${event.description != null ? fn:escapeXml(event.description) : ''}" />',
                                                '<fmt:formatDate value="${event.date}" pattern="yyyy-MM-dd"/>',
                                                '<c:out value="${event.location}" escapeXml="true"/>',
                                                ${event.budget != null ? event.budget : 'null'},
                                                '<c:out value="${event.status}" escapeXml="true"/>'
                                            )">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>

                                    <!-- Delete Event -->
                                    <button class="btn btn-danger btn-sm"
                                            onclick="confirmDelete('event', <c:out value="${event.eventId}" />)">
                                        <i class="fas fa-trash-alt"></i> Delete
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="10" class="text-center text-gray-500 py-4">
                                <div class="flex flex-col items-center justify-center py-8">
                                    <i class="fas fa-calendar-times text-4xl text-gray-300 mb-2"></i>
                                    <p class="text-lg font-medium text-gray-500">No events found</p>
                                    <p class="text-sm text-gray-400 mt-1">Create your first event to get started</p>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
                </section>

                <!-- Vendor Management Section -->
                <section id="vendors" class="dashboard-section">
                    <h2 class="text-xl font-semibold text-gray-700 section-header">
                        <i class="fas fa-store mr-2"></i>Vendor Management
                    </h2>
                    <div class="flex justify-end mb-4">
                        <button class="btn btn-primary" onclick="showForm('vendorForm', 'add', 'Add Vendor')">
                            <i class="fas fa-plus-circle"></i> Add New Vendor
                        </button>
                    </div>

                    <!-- Add/Edit Vendor Form -->
                    <div id="vendorForm" class="form-container bg-gray-50 p-6 rounded-lg shadow-inner mb-6">
                        <h3 id="vendorFormTitle" class="text-lg font-semibold text-gray-700 mb-4">Add Vendor</h3>
                        <form id="vendorCrudForm" action="<%= request.getContextPath() %>/admin/vendors" method="POST">
                            <input type="hidden" name="action" id="vendorFormAction" value="add">
                            <input type="hidden" name="vendorId" id="vendorId">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                                <div class="form-group">
                                    <label for="vendorUserId">User ID:</label>
                                    <input type="number" id="vendorUserId" name="userId" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorCompanyName">Company Name:</label>
                                    <input type="text" id="vendorCompanyName" name="companyName" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorServiceType">Service Type:</label>
                                    <input type="text" id="vendorServiceType" name="serviceType" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorContactPerson">Contact Person:</label>
                                    <input type="text" id="vendorContactPerson" name="contactPerson" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorPhone">Phone:</label>
                                    <input type="tel" id="vendorPhone" name="phone" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorEmail">Email:</label>
                                    <input type="email" id="vendorEmail" name="email" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorAddress">Address:</label>
                                    <input type="text" id="vendorAddress" name="address" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorDescription">Description:</label>
                                    <textarea id="vendorDescription" name="description" rows="3" class="w-full"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="vendorMinPrice">Min Price:</label>
                                    <input type="number" step="0.01" id="vendorMinPrice" name="minPrice" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorMaxPrice">Max Price:</label>
                                    <input type="number" step="0.01" id="vendorMaxPrice" name="maxPrice" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorPortfolioLink">Portfolio Link:</label>
                                    <input type="url" id="vendorPortfolioLink" name="portfolioLink" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="vendorStatus">Status:</label>
                                    <select id="vendorStatus" name="status" required class="w-full">
                                        <option value="Pending Approval">Pending Approval</option>
                                        <option value="Approved">Approved</option>
                                        <option value="Rejected">Rejected</option>
                                        <option value="Inactive">Inactive</option>
                                    </select>
                                </div>
                               
                            </div>
                            <div class="flex justify-end gap-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save"></i> Save Vendor
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="hideForm('vendorForm')">
                                    <i class="fas fa-times-circle"></i> Cancel
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Vendor List Table -->
                    <div class="table-container bg-white rounded-lg shadow">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>User ID</th>
                                    <th>Company Name</th>
                                    <th>Service Type</th>
                                    <th>Contact Person</th>
                                    <th>Phone</th>
                                    <th>Email</th>
                                    <th>Address</th>
                                     <!-- <th>Min Price</th>-->
                                    <!--<th>Max Price</th>-->
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty vendors}">
                                       <c:forEach var="vendor" items="${vendors}">
                                            <tr>
                                                <td><c:out value="${vendor.vendorId}" /></td>
                                                <td><c:out value="${vendor.userId}" /></td>
                                                <td><c:out value="${vendor.companyName}" /></td>
                                                <td><c:out value="${vendor.serviceType}" /></td>
                                                <td><c:out value="${vendor.contactPerson != null ? vendor.contactPerson : '-'}" /></td>
                                                <td><c:out value="${vendor.phone != null ? vendor.phone : '-'}" /></td>
                                                <td><c:out value="${vendor.email != null ? vendor.email : '-'}" /></td>
                                                <td><c:out value="${vendor.address != null ? vendor.address : '-'}" /></td>
                                                <td><c:out value="${vendor.status}" /></td>
                                                <td class="flex gap-2">
                                                    <button class="btn btn-primary btn-sm"
                                                        onclick="editVendor(
                                                            <c:out value="${vendor.vendorId}" />,
                                                            <c:out value="${vendor.userId}" />,
                                                            '<c:out value="${vendor.companyName}" escapeXml="true"/>',
                                                            '<c:out value="${vendor.serviceType}" escapeXml="true"/>',
                                                            '<c:out value="${vendor.contactPerson != null ? fn:escapeXml(vendor.contactPerson) : ''}" />',
                                                            '<c:out value="${vendor.phone != null ? fn:escapeXml(vendor.phone) : ''}" />',
                                                            '<c:out value="${vendor.email != null ? fn:escapeXml(vendor.email) : ''}" />',
                                                            '<c:out value="${vendor.address != null ? fn:escapeXml(vendor.address) : ''}" />',
                                                            '<c:out value="${vendor.description != null ? fn:escapeXml(vendor.description) : ''}" />',
                                                            <c:out value="${vendor.minPrice != null ? vendor.minPrice : 0}" />,
                                                            <c:out value="${vendor.maxPrice != null ? vendor.maxPrice : 0}" />,
                                                            '<c:out value="${vendor.portfolioLink != null ? fn:escapeXml(vendor.portfolioLink) : ''}" />',
                                                            '<c:out value="${vendor.status}" escapeXml="true"/>'
                                                        )">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </button>
                                                    <button class="btn btn-primary btn-sm"
                                                            onclick='console.log("Vendor params:", ${vendor.vendorId}, ${vendor.userId}, "<c:out value='${vendor.companyName}'/>", "<c:out value='${vendor.serviceType}'/>"); viewVendor(
                                                                ${vendor.vendorId},
                                                                ${vendor.userId},
                                                                "<c:out value='${vendor.companyName}' escapeXml='true'/>",
                                                                "<c:out value='${vendor.serviceType}' escapeXml='true'/>",
                                                                "<c:choose><c:when test='${not empty vendor.contactPerson}'><c:out value='${vendor.contactPerson}' escapeXml='true'/></c:when><c:otherwise></c:otherwise></c:choose>",
                                                                "<c:choose><c:when test='${not empty vendor.phone}'><c:out value='${vendor.phone}' escapeXml='true'/></c:when><c:otherwise></c:otherwise></c:choose>",
                                                                "<c:choose><c:when test='${not empty vendor.email}'><c:out value='${vendor.email}' escapeXml='true'/></c:when><c:otherwise></c:otherwise></c:choose>",
                                                                "<c:choose><c:when test='${not empty vendor.address}'><c:out value='${vendor.address}' escapeXml='true'/></c:when><c:otherwise></c:otherwise></c:choose>",
                                                                "<c:choose><c:when test='${not empty vendor.description}'><c:out value='${vendor.description}' escapeXml='true'/></c:when><c:otherwise></c:otherwise></c:choose>",
                                                                ${vendor.minPrice != null ? vendor.minPrice : 0},
                                                                ${vendor.maxPrice != null ? vendor.maxPrice : 0},
                                                                "<c:choose><c:when test='${not empty vendor.portfolioLink}'><c:out value='${vendor.portfolioLink}' escapeXml='true'/></c:when><c:otherwise></c:otherwise></c:choose>",
                                                                "<c:out value='${vendor.status}' escapeXml='true'/>"
                                                            )'>
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
                                                    <button class="btn btn-danger btn-sm"
                                                        onclick="confirmDelete('vendor', <c:out value="${vendor.vendorId}" />)">
                                                        <i class="fas fa-trash-alt"></i> Delete
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="12" class="text-center text-gray-500 py-4">No vendors found.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Booking Management Section -->
                <section id="bookings" class="dashboard-section">
                    <h2 class="text-xl font-semibold text-gray-700 section-header">
                        <i class="fas fa-book mr-2"></i>Booking Management
                    </h2>
                    <div class="flex justify-end mb-4">
                        <button class="btn btn-primary" onclick="showForm('bookingForm', 'add', 'Add Booking')">
                            <i class="fas fa-plus-circle"></i> Add New Booking
                        </button>
                    </div>

                    <!-- Add/Edit Booking Form -->
                    <div id="bookingForm" class="form-container bg-gray-50 p-6 rounded-lg shadow-inner mb-6">
                        <h3 id="bookingFormTitle" class="text-lg font-semibold text-gray-700 mb-4">Add Booking</h3>
                        <form id="bookingCrudForm" action="<%= request.getContextPath() %>/admin/bookings" method="POST">
                            <input type="hidden" name="action" id="bookingFormAction" value="add">
                            <input type="hidden" name="bookingId" id="bookingId">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                                <div class="form-group">
                                    <label for="bookingEventId">Event ID:</label>
                                    <input type="number" id="bookingEventId" name="eventId" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="bookingVendorId">Vendor ID (Optional):</label>
                                    <input type="number" id="bookingVendorId" name="vendorId" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="bookingServiceBooked">Service Booked:</label>
                                    <input type="text" id="bookingServiceBooked" name="serviceBooked" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="bookingAmount">Amount:</label>
                                    <input type="number" step="0.01" id="bookingAmount" name="amount" required class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="bookingStatus">Status:</label>
                                    <select id="bookingStatus" name="status" required class="w-full">
                                        <option value="Pending">Pending</option>
                                        <option value="Advance Payment Due">Advance Payment Due</option>
                                        <option value="Advance Paid">Advance Paid</option>
                                        <option value="Confirmed">Confirmed</option>
                                        <option value="Completed">Completed</option>
                                        <option value="Cancelled">Cancelled</option>
                                        <option value="Declined by Vendor">Declined by Vendor</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="bookingNotes">Notes:</label>
                                    <textarea id="bookingNotes" name="notes" rows="2" class="w-full"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="bookingAdvanceRequiredPercentage">Advance %:</label>
                                    <input type="number" step="0.01" id="bookingAdvanceRequiredPercentage" name="advanceRequiredPercentage" class="w-full">
                                </div>
                                <div class="form-group">
                                    <label for="bookingAdvanceAmountDue">Advance Due:</label>
                                    <input type="number" step="0.01" id="bookingAdvanceAmountDue" name="advanceAmountDue" readonly class="w-full bg-gray-200">
                                </div>
                                <div class="form-group">
                                    <label for="bookingAmountPaid">Amount Paid:</label>
                                    <input type="number" step="0.01" id="bookingAmountPaid" name="amountPaid" readonly class="w-full bg-gray-200">
                                </div>
                            </div>
                            <div class="flex justify-end gap-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save"></i> Save Booking
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="hideForm('bookingForm')">
                                    <i class="fas fa-times-circle"></i> Cancel
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Booking List Table -->
                    <div class="table-container bg-white rounded-lg shadow">
                        <table>
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                   
                                    <th>Event</th>
                                    <th>Client</th>
                                    <th>Vendor</th>
                                    <th>Service</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Adv. %</th>
                                    <th>Adv. Due</th>
                                    <th>Paid</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty bookings}">
                                        <c:forEach var="booking" items="${bookings}">
                                            <tr>
                                                <td><c:out value="${booking.bookingId}" /></td>
                                                <td><c:out value="${booking.eventName != null ? booking.eventName : 'N/A'}" /> (ID: <c:out value="${booking.eventId}" />)</td>
                                                
                                                <td><c:out value="${booking.clientName != null ? booking.clientName : 'N/A'}" /></td>
                                                <td><c:out value="${booking.vendorCompanyName != null ? booking.vendorCompanyName : 'N/A'}" /> (ID: <c:out value="${booking.vendorId != null ? booking.vendorId : '-'}" />)</td>
                                                <td><c:out value="${booking.serviceBooked}" /></td>
                                                <td><c:out value="${booking.bookingDate}" /></td>
                                                <td><c:out value="${booking.amount}" /></td>
                                                <td><c:out value="${booking.advanceRequiredPercentage != null ? booking.advanceRequiredPercentage : '0'}" />%</td>
                                                <td><c:out value="${booking.advanceAmountDue != null ? booking.advanceAmountDue : '0.00'}" /></td>
                                                <td><c:out value="${booking.amountPaid != null ? booking.amountPaid : '0.00'}" /></td>
                                                <td><c:out value="${booking.status}" /></td>
                                                <td class="flex gap-2">
                                                    <button class="btn btn-primary btn-sm"
                                                            onclick="editBooking(
                                                                <c:out value="${booking.bookingId}" />,
                                                                <c:out value="${booking.eventId}" />,
                                                                <c:out value="${booking.vendorId}" />,
                                                                '${booking.serviceBooked}',
                                                                <c:out value="${booking.amount}" />,
                                                                '${booking.status}',
                                                                '${booking.notes}',
                                                                <c:out value="${booking.advanceRequiredPercentage}" />,
                                                                <c:out value="${booking.advanceAmountDue}" />,
                                                                <c:out value="${booking.amountPaid}" />
                                                            )">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </button>
                                                    <button class="btn btn-danger btn-sm"
                                                            onclick="confirmDelete('booking', <c:out value="${booking.bookingId}" />)">
                                                        <i class="fas fa-trash-alt"></i> Delete
                                                    </button>
                                                    <button class="btn btn-success btn-sm"
                                                            onclick="showPaymentForm(
                                                                <c:out value="${booking.bookingId}" />,
                                                                <c:out value="${booking.amount}" />,
                                                                <c:out value="${booking.amountPaid}" />
                                                            )">
                                                        <i class="fas fa-dollar-sign"></i> Add Payment
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="12" class="text-center text-gray-500 py-4">No bookings found.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Payment Management Section -->
                <section id="payments" class="dashboard-section">
                    <h2 class="text-xl font-semibold text-gray-700 section-header">
                        <i class="fas fa-money-bill-wave mr-2"></i>Payment Management
                    </h2>
                    <div class="flex justify-end mb-4">
                        <!-- Add Payment button is now primarily in Booking section, but you could add a standalone one here too -->
                    </div>

                    <!-- Payment List Table -->
                    <div class="table-container bg-white rounded-lg shadow">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Booking ID</th>
                                    <th>Amount</th>
                                    <th>Vendor Share</th>
                                    <th>Admin Share</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                   <th>Transaction ID</th> 
                                    <th>Method</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty payments}">
                                        <c:forEach var="payment" items="${payments}">
                                            <tr>
                                                <td><c:out value="${payment.paymentId}" /></td>
                                                <td><c:out value="${payment.bookingId}" /></td>
                                                <td><c:out value="${payment.amount}" /></td>
                                                <td>NPR <fmt:formatNumber value="${payment.vendorShare}" /></td>
                                                <td>NPR <fmt:formatNumber value="${payment.adminShare}" /></td>
                                                <td><c:out value="${payment.paymentDate}" /></td>
                                                <td><c:out value="${payment.status}" /></td>
                                                <td><c:out value="${payment.transactionId != null ? payment.transactionId : '-'}" /></td>
                                                <td><c:out value="${payment.paymentMethod}" /></td>
                                               <td class="flex gap-2">
                                                <button class="btn btn-primary btn-sm"
                                                    onclick="editPayment(
                                                        <c:out value="${payment.paymentId}" />,
                                                        <c:out value="${payment.bookingId}" />,
                                                        <c:out value="${payment.amount}" />,
                                                        '<c:out value="${payment.paymentDate != null ? fn:escapeXml(payment.paymentDate) : ''}" />',
                                                        '<c:out value="${payment.status != null ? fn:escapeXml(payment.status) : ''}" />',
                                                        '<c:out value="${payment.transactionId != null ? fn:escapeXml(payment.transactionId) : ''}" />',
                                                        '<c:out value="${payment.paymentMethod != null ? fn:escapeXml(payment.paymentMethod) : ''}" />'
                                                    )">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button class="btn btn-danger btn-sm"
                                                    onclick="confirmDelete('payment', <c:out value="${payment.paymentId}" />)">
                                                    <i class="fas fa-trash-alt"></i> Delete
                                                </button>
                                            </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center text-gray-500 py-4">No payments found.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- Add/Edit Payment Modal -->
                     <!-- Modals for Add Payment and Delete Confirmation -->

 

    <!-- Delete Confirmation Modal -->
    <div id="deleteConfirmModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="hideModal('deleteConfirmModal')">&times;</span>
            <h3 class="text-lg font-semibold text-gray-700 mb-4">Confirm Deletion</h3>
            <p class="mb-4">Are you sure you want to delete this <span id="deleteEntityType" class="font-bold"></span> entry?</p>
            <form id="deleteForm" method="POST">
                <input type="hidden" name="idToDelete" id="idToDelete">
                <input type="hidden" name="action" value="delete">

                <div class="flex justify-end gap-2">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash-alt"></i> Confirm Delete
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="hideModal('deleteConfirmModal')">
                        <i class="fas fa-times-circle"></i> Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>
  </section>
                  <!-- Payment Modal -->
<div id="paymentModal" class="modal">
    <div class="modal-content">
        <span class="close-button" onclick="hideModal('paymentModal')">&times;</span>
        <h3 id="paymentModalTitle" class="text-lg font-semibold text-gray-700 mb-4">Record Payment</h3>
        <form id="paymentCrudForm" action="<%= request.getContextPath() %>/admin/processPayment" method="POST">
            <input type="hidden" name="action" value="recordPayment">
            
            <div class="grid grid-cols-1 gap-4 mb-4">
                <div class="form-group">
                    <label for="paymentBookingId">Booking ID:</label>
                    <input type="number" id="paymentBookingId" name="bookingId" required class="w-full" 
                           min="1" oninput="validateBookingId(this)">
                    <small class="text-gray-500">Enter the Booking ID for this payment</small>
                </div>
                
                <div class="form-group">
                    <label for="paymentAmount">Amount (NPR):</label>
                    <input type="number" step="0.01" id="paymentAmount" name="amount" required 
                           class="w-full" min="0.01" placeholder="0.00">
                </div>
                
                <div class="form-group">
                    <label for="paymentMethod">Payment Method:</label>
                    <select id="paymentMethod" name="paymentMethod" required class="w-full">
                        <option value="">Select Method</option>
                        <option value="Cash">Cash</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                        <option value="Card">Card</option>
                        <option value="Check">Check</option>
                        <option value="Digital Wallet">Digital Wallet</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="paymentType">Payment Type:</label>
                    <select id="paymentType" name="paymentType" required class="w-full">
                        <option value="">Select Type</option>
                        <option value="Advance">Advance Payment</option>
                        <option value="Full">Full Payment</option>
                        <option value="Partial">Partial Payment</option>
                    </select>
                </div>
            </div>
            
            <div class="flex justify-end gap-2">
                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Record Payment
                </button>
                <button type="button" class="btn btn-secondary" onclick="hideModal('paymentModal')">
                    <i class="fas fa-times-circle"></i> Cancel
                </button>
            </div>
        </form>
    </div>
</div>

  <section id="reports" class="dashboard-section bg-white rounded-xl shadow-lg p-6">
            <h2 class="text-4xl font-extrabold text-gray-900 section-header mb-2 flex items-center">
                <i class="fas fa-chart-line mr-3 text-indigo-600"></i> Reports & Analytics
            </h2>
            <p class="text-gray-600 mb-6 border-b pb-4">
                Generate various performance and financial reports for deeper insights.
            </p>

            <div id="report-form-container">
                <div class="flex flex-wrap items-center justify-between gap-4 filter-bar bg-gray-100 p-4 rounded-lg shadow-inner mb-6">
                    <div class="flex flex-wrap items-center gap-2">
                        <h3 class="font-semibold text-gray-700">Generate Report:</h3>
                        
                        <button type="button" class="btn-report" data-report-type="financial_report">
                            <i class="fas fa-file-invoice-dollar mr-2"></i> Financial
                        </button>
                        <button type="button" class="btn-report" data-report-type="event_summary_report">
                            <i class="fas fa-calendar-check mr-2"></i> Event Summary
                        </button>
                        <button type="button" class="btn-report" data-report-type="vendor_performance_report">
                            <i class="fas fa-user-tie mr-2"></i> Vendor Performance
                        </button>
                        <button type="button" class="btn-report" data-report-type="full_vendor_report">
                            <i class="fas fa-users mr-2"></i> Full Vendor Report
                        </button>
                        <button type="button" class="btn-report" data-report-type="full_payments_report">
                            <i class="fas fa-credit-card mr-2"></i> Payments Report
                        </button>
                    </div>
                </div>
                
                <div class="flex flex-wrap items-center justify-between gap-4 filter-bar bg-gray-100 p-4 rounded-lg shadow-inner mb-6">
                    <div class="flex flex-wrap items-center gap-4">
                        <h3 class="font-semibold text-gray-700">Filter:</h3>
                        <select id="time-filter" class="filter-select">
                            <option value="all_time">All Time</option>
                            <option value="last_7_days">Last 7 Days</option>
                            <option value="last_30_days">Last 30 Days</option>
                            <option value="last_quarter">Last Quarter</option>
                            <option value="last_year">Last Year</option>
                        </select>
                        <select id="status-filter" class="filter-select">
                            <option value="all_statuses">All Statuses</option>
                            <option value="active">Active</option>
                            <option value="completed">Completed</option>
                            <option value="pending">Pending</option>
                            <option value="cancelled">Cancelled</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <div id="report-results" class="mt-4 p-6 bg-gray-50 border border-gray-200 rounded-lg min-h-[400px] overflow-x-auto">
                <c:choose>
                    <c:when test="${not empty requestScope.reportData}">
                        <div class="report-controls flex justify-end gap-3 mb-4">
                            <button id="print-button" class="btn-small bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg shadow-md transition-all">
                                <i class="fas fa-print mr-2"></i> Print Report
                            </button>
                            <button id="download-button" class="btn-small bg-green-500 hover:bg-green-600 text-white font-semibold py-2 px-4 rounded-lg shadow-md transition-all">
                                <i class="fas fa-download mr-2"></i> Download PDF
                            </button>
                        </div>
                        
                        <div id="report-content">
                            <h3 class="text-2xl font-bold mb-4 capitalize">
                                <c:out value="${fn:replace(requestScope.reportType, '_', ' ')}" /> Report
                            </h3>
                            
                            <table class='min-w-full divide-y divide-gray-200 shadow-sm rounded-lg'>
                                <thead class='bg-gray-50'>
                                    <tr>
                                        <c:choose>
                                            <c:when test="${requestScope.reportType eq 'event_summary_report'}">
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Event ID</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Client ID</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Event Date</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Status</th>
                                            </c:when>
                                            <c:when test="${requestScope.reportType eq 'full_vendor_report'}">
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Vendor ID</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Vendor Name</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Contact Person</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Registration Date</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Status</th>
                                            </c:when>
                                            <c:when test="${requestScope.reportType eq 'vendor_performance_report'}">
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Vendor Name</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Total Events</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Total Revenue</th>
                                            </c:when>
                                            <c:when test="${requestScope.reportType eq 'full_payments_report'}">
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Payment ID</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Booking ID</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Amount</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Payment Date</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Status</th>
                                            </c:when>
                                            <c:otherwise>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Metric</th>
                                                <th class='px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'>Value</th>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                </thead>
                                <tbody class='bg-white divide-y divide-gray-200'>
                                    <c:forEach var="item" items="${requestScope.reportData}">
                                        <tr>
                                            <c:choose>
                                                <c:when test="${requestScope.reportType eq 'event_summary_report'}">
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.eventId}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.clientId}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.eventDate}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.status}" /></td>
                                                </c:when>
                                                <c:when test="${requestScope.reportType eq 'full_vendor_report'}">
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.vendorId}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.companyName}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.contactPerson}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.registrationDate}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.status}" /></td>
                                                </c:when>
                                                <c:when test="${requestScope.reportType eq 'vendor_performance_report'}">
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.companyName}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.totalEvents}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'>$<c:out value="${item.totalRevenue}" /></td>
                                                </c:when>
                                                <c:when test="${requestScope.reportType eq 'full_payments_report'}">
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.paymentId}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.bookingId}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'>$<c:out value="${item.amount}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.paymentDate}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.status}" /></td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.metric}" /></td>
                                                    <td class='px-6 py-4 whitespace-nowrap'><c:out value="${item.value}" /></td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <div id="initial-message" class="flex flex-col items-center justify-center h-full text-gray-500">
                            <i class="fas fa-file-alt text-5xl mb-3 text-gray-300"></i>
                            <p class="text-center text-lg font-medium">Select a report type to generate and view data.</p>
                            <p class="text-center text-sm mt-2">Use the filters above to refine your results.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
       <!-- Add this in your main-content section, after the Reports section -->
<section id="cms-section" class="dashboard-section" style="display: none;">
   
    <div id="cms-content" class="mt-4">
        <!-- CMS content will be loaded here via AJAX -->
    </div>
</section>
        </main>

        <!-- Footer -->
        <footer class="bg-white shadow p-4 text-center text-gray-600 mt-auto">
            &copy; 2025 Event Management System. All rights reserved.
        </footer>
    </div>
  <script>
// ─────────────────────────────────────────────────────────────
// Global Variables and Constants
// ─────────────────────────────────────────────────────────────
const paginationState = {
    user: { currentPage: 1, pageSize: 10, totalItems: ${fn:length(users)} },
    event: { currentPage: 1, pageSize: 10, totalItems: ${fn:length(events)} },
    vendor: { currentPage: 1, pageSize: 10, totalItems: ${fn:length(vendors)} },
    booking: { currentPage: 1, pageSize: 10, totalItems: ${fn:length(bookings)} },
    payment: { currentPage: 1, pageSize: 10, totalItems: ${fn:length(payments)} }
};

let currentActiveSection = 'overview';

// ─────────────────────────────────────────────────────────────
// Main Initialization
// ─────────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
    initializeDashboard();
});

function initializeDashboard() {
    initializeSidebarNavigation();
    initializeMessageDisplay();
    initializeCharts();
    initializeUserManagement();
    initializeFormHandlers();
    initializePagination();
    initializeBookingFormHandlers();
     initializeEventFormHandlers(); // Add this line
}

// ─────────────────────────────────────────────────────────────
// Dashboard Initialization Functions
// ─────────────────────────────────────────────────────────────
function initializeSidebarNavigation() {
    const currentHash = window.location.hash.replace('#', '') || 'overview';
    
    // Set active menu item based on current hash
    document.querySelectorAll('.sidebar-menu a').forEach(link => {
        link.classList.remove('active');
        const href = link.getAttribute('href');
        if (href === '#' + currentHash || (href === '#overview' && !currentHash)) {
            link.classList.add('active');
        }
    });

    // Show the correct section based on URL hash
    let sectionToShow = currentHash;
    if (currentHash === 'cms') {
        sectionToShow = 'cms-section';
    }
    showSection(sectionToShow);

    // Add click listeners to sidebar links
    document.querySelectorAll('.sidebar-menu a').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            
            const href = this.getAttribute('href');
            let sectionId = 'overview';
            
            if (href && href.startsWith('#')) {
                sectionId = href.replace('#', '');
            }
            
            // Handle CMS separately
            if (this.id === 'loadCMS' || sectionId === 'cms') {
                sectionId = 'cms-section';
            }
            
            showSection(sectionId);
            
            // Update active menu item
            document.querySelectorAll('.sidebar-menu a').forEach(link => {
                link.classList.remove('active');
            });
            this.classList.add('active');
            
            // Update URL
            const urlHash = (sectionId === 'cms-section') ? 'cms' : sectionId;
            history.pushState(null, null, '#' + urlHash);
        });
    });
    
    // Handle browser back/forward buttons
    window.addEventListener('popstate', function() {
        const hash = window.location.hash.replace('#', '') || 'overview';
        let sectionToShow = hash;
        if (hash === 'cms') {
            sectionToShow = 'cms-section';
        }
        showSection(sectionToShow);
        
        // Update active menu
        document.querySelectorAll('.sidebar-menu a').forEach(link => {
            link.classList.remove('active');
            const href = link.getAttribute('href');
            if (href === '#' + hash || (href === '#overview' && !hash)) {
                link.classList.add('active');
            }
        });
    });
}

function showSection(sectionId) {
    // Hide all sections
    document.querySelectorAll('.dashboard-section').forEach(section => {
        section.style.display = 'none';
    });
    
    // Show the target section
    const targetSection = document.getElementById(sectionId);
    if (targetSection) {
        targetSection.style.display = 'block';
        currentActiveSection = sectionId;
        
        // If it's CMS section, load CMS content
        if (sectionId === 'cms-section') {
            loadCMSContent();
        }
    } else {
        // Fallback to overview
        document.getElementById('overview').style.display = 'block';
        currentActiveSection = 'overview';
    }
}

function loadCMSContent() {
    const cmsContent = document.getElementById('cms-content');
    if (!cmsContent) {
        console.error('CMS content container not found');
        return;
    }
    
    // Show loading state
    cmsContent.innerHTML = `
        <div class="text-center p-8 bg-gray-50 rounded-lg">
            <i class="fas fa-spinner fa-spin text-3xl text-blue-500 mb-4"></i>
            <p class="text-lg text-gray-600">Loading Content Management System...</p>
            <p class="text-sm text-gray-500 mt-2">Please wait while we load the CMS interface</p>
        </div>
    `;
    
    // Load CMS content via AJAX
    fetch('<%= request.getContextPath() %>/admin/cms')
        .then(response => {
            if (!response.ok) {
                throw new Error(`Failed to load CMS: ${response.status} ${response.statusText}`);
            }
            return response.text();
        })
        .then(html => {
            cmsContent.innerHTML = html;
            console.log('CMS content loaded successfully');
        })
        .catch(error => {
            console.error('Error loading CMS:', error);
            cmsContent.innerHTML = `
                <div class="alert alert-error max-w-2xl mx-auto">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-triangle text-xl mr-3"></i>
                        <div>
                            <h3 class="font-bold text-lg">Unable to Load CMS</h3>
                            <p class="mt-1">Error: ${error.message}</p>
                        </div>
                    </div>
                    <div class="mt-4 flex gap-2">
                        <button onclick="loadCMSContent()" class="btn btn-primary">
                            <i class="fas fa-redo mr-2"></i>Try Again
                        </button>
                        <button onclick="showSection('overview')" class="btn btn-secondary">
                            <i class="fas fa-arrow-left mr-2"></i>Return to Dashboard
                        </button>
                    </div>
                </div>
            `;
    renderBasicCMSInterface();
        });
}
function renderBasicCMSInterface() {
    const cmsContent = document.getElementById('cms-content');
    
    cmsContent.innerHTML = `
        <div class="cms-basic-interface">
            <div class="cms-header mb-6">
                <h2 class="text-2xl font-bold text-gray-800">
                    <i class="fas fa-cog mr-2"></i>Content Management System
                </h2>
                <p class="text-gray-600">Manage your website content and services</p>
            </div>

            <!-- Quick Actions -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
                <a href="<%= request.getContextPath() %>/admin/services" 
                   class="p-4 bg-white rounded-lg shadow hover:shadow-md transition-shadow border-l-4 border-blue-500">
                    <div class="flex items-center">
                        <i class="fas fa-concierge-bell text-blue-500 text-xl mr-3"></i>
                        <div>
                            <h3 class="font-semibold text-gray-800">Manage Services</h3>
                            <p class="text-sm text-gray-600">Edit services & features</p>
                        </div>
                    </div>
                </a>
                
                <a href="<%= request.getContextPath() %>/admin/cms/pages" 
                   class="p-4 bg-white rounded-lg shadow hover:shadow-md transition-shadow border-l-4 border-green-500">
                    <div class="flex items-center">
                        <i class="fas fa-file text-green-500 text-xl mr-3"></i>
                        <div>
                            <h3 class="font-semibold text-gray-800">Manage Pages</h3>
                            <p class="text-sm text-gray-600">Edit website pages</p>
                        </div>
                    </div>
                </a>
                
                <a href="<%= request.getContextPath() %>/blog-management.jsp" 
                   class="p-4 bg-white rounded-lg shadow hover:shadow-md transition-shadow border-l-4 border-purple-500">
                    <div class="flex items-center">
                        <i class="fas fa-blog text-purple-500 text-xl mr-3"></i>
                        <div>
                            <h3 class="font-semibold text-gray-800">Manage Blog</h3>
                            <p class="text-sm text-gray-600">Edit blog posts</p>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Direct Links -->
            <div class="bg-white rounded-lg shadow p-6">
                <h3 class="text-lg font-semibold mb-4">Quick Access</h3>
                <div class="space-y-2">
                    <a href="<%= request.getContextPath() %>/admin/services" 
                       class="block p-3 hover:bg-gray-50 rounded-lg transition-colors">
                        <i class="fas fa-arrow-right mr-2 text-blue-500"></i>
                        Service Management
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/cms/pages" 
                       class="block p-3 hover:bg-gray-50 rounded-lg transition-colors">
                        <i class="fas fa-arrow-right mr-2 text-green-500"></i>
                        Page Management
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/cms/banners" 
                       class="block p-3 hover:bg-gray-50 rounded-lg transition-colors">
                        <i class="fas fa-arrow-right mr-2 text-yellow-500"></i>
                        Banner Management
                    </a>
                </div>
            </div>
        </div>
    `;
}

function initializeEmbeddedCMS() {
    // Re-initialize any CMS-specific functionality
    // This would handle any JavaScript that needs to run after CMS content is loaded
    
    // Example: Re-attach event listeners to CMS buttons
    setTimeout(() => {
        const cmsButtons = document.querySelectorAll('#cms-content .btn, #cms-content a');
        cmsButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                // Handle internal CMS navigation
                if (this.getAttribute('href') && this.getAttribute('href').startsWith('<%= request.getContextPath() %>/admin/')) {
                    e.preventDefault();
                    const href = this.getAttribute('href');
                    loadSpecificCMSContent(href);
                }
            });
        });
    }, 100);
}

function loadSpecificCMSContent(url) {
    const cmsContent = document.getElementById('cms-content');
    
    cmsContent.innerHTML = `
        <div class="text-center p-8">
            <i class="fas fa-spinner fa-spin text-2xl text-blue-500"></i>
            <p>Loading...</p>
        </div>
    `;
    
    fetch(url)
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const mainContent = doc.querySelector('main');
            
            if (mainContent) {
                cmsContent.innerHTML = mainContent.innerHTML;
                initializeEmbeddedCMS();
            }
        })
        .catch(error => {
            console.error('Error loading CMS content:', error);
            cmsContent.innerHTML = `
                <div class="alert alert-error">
                    Error loading content. <a href="${url}" target="_blank">Open in new tab</a>
                </div>
            `;
        });
}
function initializeMessageDisplay() {
    const urlParams = new URLSearchParams(window.location.search);
    const successMessage = urlParams.get('successMessage');
    const errorMessage = urlParams.get('errorMessage');
    
    if (successMessage) showMessage(successMessage, 'success');
    else if (errorMessage) showMessage(errorMessage, 'error');
    
    if (successMessage || errorMessage) {
        history.replaceState({}, document.title, window.location.pathname);
    }
}

// ─────────────────────────────────────────────────────────────
// Chart.js - Three Separate Charts
// ─────────────────────────────────────────────────────────────
function initializeCharts() {
    createRevenueChart();
    createUserStatsChart();
    createEventStatsChart();
}

function createRevenueChart() {
    const chartDataElement = document.getElementById('revenueChartData');
    const canvas = document.getElementById('revenueChart');
    
    if (!chartDataElement || !canvas) {
        console.warn('Missing revenue chart data or canvas');
        return;
    }

    try {
        const rawData = JSON.parse(chartDataElement.textContent);
        const labels = Object.keys(rawData);
        const values = Object.values(rawData);

        const ctx = canvas.getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: ['#3b82f6', '#10b981'],
                    borderWidth: 2,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Revenue Distribution',
                        font: { size: 16, weight: 'bold' },
                        color: '#1f2937'
                    },
                    legend: {
                        position: 'bottom',
                        labels: { padding: 20, usePointStyle: true }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.raw || 0;
                                return `${label}: NPR ${value.toLocaleString()}`;
                            }
                        }
                    }
                },
                cutout: '60%'
            }
        });
    } catch (err) {
        console.error('Revenue chart error:', err);
    }
}

function createUserStatsChart() {
    const chartDataElement = document.getElementById('userStatsChartData');
    const canvas = document.getElementById('userStatsChart');
    
    if (!chartDataElement || !canvas) {
        console.warn('Missing user stats chart data or canvas');
        return;
    }

    try {
        const rawData = JSON.parse(chartDataElement.textContent);
        const labels = Object.keys(rawData);
        const values = Object.values(rawData);

        const ctx = canvas.getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Count',
                    data: values,
                    backgroundColor: ['#8b5cf6', '#f59e0b', '#ef4444'],
                    borderRadius: 6,
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'User Distribution',
                        font: { size: 16, weight: 'bold' },
                        color: '#1f2937'
                    },
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { color: '#6b7280', precision: 0 },
                        grid: { color: '#e5e7eb' }
                    },
                    x: {
                        ticks: { color: '#6b7280' },
                        grid: { display: false }
                    }
                }
            }
        });
    } catch (err) {
        console.error('User stats chart error:', err);
    }
}

function createEventStatsChart() {
    const chartDataElement = document.getElementById('eventStatsChartData');
    const canvas = document.getElementById('eventStatsChart');
    
    if (!chartDataElement || !canvas) {
        console.warn('Missing event stats chart data or canvas');
        return;
    }

    try {
        const rawData = JSON.parse(chartDataElement.textContent);
        const labels = Object.keys(rawData);
        const values = Object.values(rawData);

        const ctx = canvas.getContext('2d');
        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: ['#3b82f6', '#10b981', '#f59e0b'],
                    borderWidth: 2,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Event & Booking Stats',
                        font: { size: 16, weight: 'bold' },
                        color: '#1f2937'
                    },
                    legend: {
                        position: 'bottom',
                        labels: { padding: 20, usePointStyle: true }
                    }
                }
            }
        });
    } catch (err) {
        console.error('Event stats chart error:', err);
    }
}

// ─────────────────────────────────────────────────────────────
// User Management with Vendor Auto-Creation
// ─────────────────────────────────────────────────────────────
function initializeUserManagement() {
    initializeRoleBasedUI();
    initializeUserFormHandlers();
}

function initializeRoleBasedUI() {
    const roleSelect = document.getElementById('userRole');
    if (roleSelect) {
        roleSelect.addEventListener('change', function() {
            showRoleInfo(this.value);
            toggleVendorFields(this.value);
        });
        
        // Initialize on page load
        showRoleInfo(roleSelect.value);
        toggleVendorFields(roleSelect.value);
    }
}

function showRoleInfo(role) {
    const roleInfoAlert = document.getElementById('roleInfoAlert');
    const roleInfoText = document.getElementById('roleInfoText');
    
    if (!roleInfoAlert || !roleInfoText) return;
    
    roleInfoAlert.className = 'mb-4 p-3 rounded-lg border';
    roleInfoAlert.classList.remove('hidden');
    
    switch(role) {
        case 'vendor':
            roleInfoAlert.classList.add('bg-blue-100', 'text-blue-800', 'border-blue-200');
            roleInfoText.innerHTML = `
                <i class="fas fa-info-circle mr-2"></i>
                <strong>Vendor Account:</strong> This will create both a user account AND a vendor profile. 
                The vendor will start with "Pending Approval" status.
            `;
            break;
        case 'admin':
            roleInfoAlert.classList.add('bg-yellow-100', 'text-yellow-800', 'border-yellow-200');
            roleInfoText.innerHTML = `
                <i class="fas fa-shield-alt mr-2"></i>
                <strong>Admin Account:</strong> This user will have full administrative access.
            `;
            break;
        case 'customer':
            roleInfoAlert.classList.add('bg-green-100', 'text-green-800', 'border-green-200');
            roleInfoText.innerHTML = `
                <i class="fas fa-user mr-2"></i>
                <strong>Client Account:</strong> This user will be able to book events.
            `;
            break;
        default:
            roleInfoAlert.classList.add('hidden');
    }
}

function toggleVendorFields(role) {
    const vendorFields = document.getElementById('vendorFields');
    if (!vendorFields) return;
    
    if (role === 'vendor') {
        vendorFields.classList.remove('hidden');
        syncVendorCompanyName();
    } else {
        vendorFields.classList.add('hidden');
    }
}

function syncVendorCompanyName() {
    const userName = document.getElementById('userName')?.value;
    const companyNameField = document.getElementById('vendorCompanyName');
    const roleSelect = document.getElementById('userRole');
    
    if (companyNameField && roleSelect?.value === 'vendor' && !companyNameField.value) {
        companyNameField.placeholder = `${userName || 'User'} Company`;
    }
}

function initializeUserFormHandlers() {
    const userForm = document.getElementById('userCrudForm');
    if (userForm) {
        userForm.addEventListener('submit', handleUserFormSubmit);
    }
    
    const userNameField = document.getElementById('userName');
    if (userNameField) {
        userNameField.addEventListener('input', syncVendorCompanyName);
    }
}

function handleUserFormSubmit(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    const role = formData.get('role');
    
    if (!validateUserForm(formData)) {
        return;
    }
    
    if (!confirmUserCreation(role, formData)) {
        return;
    }
    
    this.submit();
}

function validateUserForm(formData) {
    const name = formData.get('name');
    const email = formData.get('email');
    const password = formData.get('password');
    const role = formData.get('role');
    
    if (!name || !name.trim()) {
        showMessage('Please enter a name for the user.', 'error');
        return false;
    }
    
    if (!email || !email.trim()) {
        showMessage('Please enter an email address.', 'error');
        return false;
    }
    
    if (!validateEmail(email)) {
        showMessage('Please enter a valid email address.', 'error');
        return false;
    }
    
    if (!password) {
        showMessage('Please enter a password.', 'error');
        return false;
    }
    
    if (password.length < 6) {
        showMessage('Password must be at least 6 characters long.', 'error');
        return false;
    }
    
    if (!role) {
        showMessage('Please select a role for the user.', 'error');
        return false;
    }
    
    return true;
}

function confirmUserCreation(role, formData) {
    let message = 'Are you sure you want to create this user account?';
    
    if (role === 'vendor') {
        const companyName = formData.get('companyName') || `${formData.get('name')} Company`;
        message = `This will create a user account AND a vendor profile (${companyName}). Continue?`;
    } else if (role === 'admin') {
        message = 'This will create a user with administrator privileges. Continue?';
    }
    
    return confirm(message);
}

function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// ─────────────────────────────────────────────────────────────
// Form and Modal Utilities
// ─────────────────────────────────────────────────────────────
function showForm(formId, actionType, title) {
    const formContainer = document.getElementById(formId);
    if (!formContainer) return;
    
    const form = formContainer.querySelector('form');
    form.reset();
    form.querySelector('input[name="action"]').value = actionType;
    document.getElementById(formId + 'Title').innerText = title;
    formContainer.style.display = 'block';

    if (formId == 'userForm') {
        document.getElementById('userId').value = '';
        document.getElementById('userPassword').required = (actionType === 'add');
        
        // Initialize role-based UI
        const roleSelect = document.getElementById('userRole');
        if (roleSelect) {
            showRoleInfo(roleSelect.value);
            toggleVendorFields(roleSelect.value);
        }
    } else if (formId == 'eventForm') {
        document.getElementById('eventId').value = '';
        
        // Set default date to today for new events
        if (actionType === 'add') {
            const today = new Date();
            const year = today.getFullYear();
            const month = String(today.getMonth() + 1).padStart(2, '0');
            const day = String(today.getDate()).padStart(2, '0');
            const formattedDate = `${year}-${month}-${day}`;
            document.getElementById('eventDate').value = formattedDate;
        }
    } else if (formId == 'vendorForm') {
        document.getElementById('vendorId').value = '';
    } else if (formId == 'bookingForm') {
        document.getElementById('bookingId').value = '';
        document.getElementById('bookingAdvanceAmountDue').value = '0.00';
        document.getElementById('bookingAmountPaid').value = '0.00';
    }
}
function hideForm(formId) {
    const formContainer = document.getElementById(formId);
    if (formContainer) {
        formContainer.style.display = 'none';
    }
}

function showModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'flex';
    }
}

function hideModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'none';
    }
}

// ─────────────────────────────────────────────────────────────
// Entity Edit Functions
// ─────────────────────────────────────────────────────────────
function editUser(userId) {
    // Fetch user data from server using the userId
    fetch(`<%= request.getContextPath() %>/admin/users?action=getUser&userId=${userId}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch user data');
            }
            return response.json();
        })
        .then(user => {
            // Populate the form with the fetched user data
            showForm('userForm', 'edit', 'Edit User');
            document.getElementById('userId').value = user.userId;
            document.getElementById('userName').value = user.name;
            document.getElementById('userEmail').value = user.email;
            document.getElementById('userPhone').value = user.phone || '';
            document.getElementById('userAddress').value = user.address || '';
            document.getElementById('userRole').value = user.role;
            
            // Initialize role-based UI for edit
            showRoleInfo(user.role);
            toggleVendorFields(user.role);
            
            // Make password optional for edits
            document.getElementById('userPassword').required = false;
            document.getElementById('userPassword').placeholder = 'Leave blank to keep current password';
        })
        .catch(error => {
            console.error('Error fetching user data:', error);
            showMessage('Error loading user data: ' + error.message, 'error');
        });
}

// Alternative approach if you want to pass data directly from JSP:
function editUserFromTable(userId, name, email, phone, address, role) {
    showForm('userForm', 'edit', 'Edit User');
    document.getElementById('userId').value = userId;
    document.getElementById('userName').value = name;
    document.getElementById('userEmail').value = email;
    document.getElementById('userPhone').value = phone || '';
    document.getElementById('userAddress').value = address || '';
    document.getElementById('userRole').value = role;
    
    // Initialize role-based UI for edit
    showRoleInfo(role);
    toggleVendorFields(role);
    
    // Make password optional for edits
    document.getElementById('userPassword').required = false;
    document.getElementById('userPassword').placeholder = 'Leave blank to keep current password';
}

// ─────────────────────────────────────────────────────────────
// Entity Edit Functions
// ─────────────────────────────────────────────────────────────
// Update the editEventFromTable function


// Add this to your JavaScript section
function initializeEventFormHandlers() {
    const eventForm = document.getElementById('eventCrudForm');
    if (eventForm) {
        eventForm.addEventListener('submit', function(e) {
            e.preventDefault();
            handleEventFormSubmit(this);
        });
    }
    
    // Set default date for new events
    const eventDateField = document.getElementById('eventDate');
    if (eventDateField && !eventDateField.value) {
        const today = new Date().toISOString().split('T')[0];
        eventDateField.value = today;
    }
}

function handleEventFormSubmit(form) {
    const formData = new FormData(form);
    
    if (!validateEventForm(formData)) {
        return;
    }
    
    // Submit the form normally
    form.submit();
}

function validateEventForm(formData) {
    const clientId = formData.get('clientId');
    const type = formData.get('type');
    const date = formData.get('date');
    const location = formData.get('location');
    
    // Basic validation
    if (!clientId || clientId.trim() === '' || parseInt(clientId) <= 0) {
        showMessage('Please enter a valid Client ID.', 'error');
        return false;
    }
    
    if (!type || !type.trim()) {
        showMessage('Event type is required.', 'error');
        return false;
    }
    
    if (type.trim().length < 2) {
        showMessage('Event type must be at least 2 characters long.', 'error');
        return false;
    }
    
    if (!date || !date.trim()) {
        showMessage('Event date is required.', 'error');
        return false;
    }
    
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(date)) {
        showMessage('Please use YYYY-MM-DD format for the date.', 'error');
        return false;
    }
    
    const eventDate = new Date(date);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    if (eventDate < today) {
        if (!confirm('Event date is in the past. Are you sure you want to proceed?')) {
            return false;
        }
    }
    
    if (!location || !location.trim()) {
        showMessage('Event location is required.', 'error');
        return false;
    }
    
    if (location.trim().length < 3) {
        showMessage('Event location must be at least 3 characters long.', 'error');
        return false;
    }
    
    return true;
}

function editEventFromTable(eventId, clientId, type, description, date, location, budget, status) {
    console.log("Editing event with direct parameters:", { 
        eventId, clientId, type, description, date, location, budget, status 
    });
    
    showForm('eventForm', 'edit', 'Edit Event');
    
    // Set form values
    document.getElementById('eventId').value = eventId;
    document.getElementById('eventClientId').value = clientId;
    document.getElementById('eventType').value = type || '';
    document.getElementById('eventDescription').value = description || '';
    document.getElementById('eventLocation').value = location || '';
    document.getElementById('eventBudget').value = budget || '';
    document.getElementById('eventStatus').value = status || 'Pending Approval';
    
    // Format date for date input (YYYY-MM-DD)
    if (date && date !== 'null' && date !== 'undefined') {
        try {
            const eventDate = new Date(date);
            if (!isNaN(eventDate.getTime())) {
                const year = eventDate.getFullYear();
                const month = String(eventDate.getMonth() + 1).padStart(2, '0');
                const day = String(eventDate.getDate()).padStart(2, '0');
                const formattedDate = `${year}-${month}-${day}`;
                document.getElementById('eventDate').value = formattedDate;
            }
        } catch (e) {
            console.error('Error formatting date:', e);
            // Set today's date as fallback
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('eventDate').value = today;
        }
    } else {
        // Set today's date if no date provided
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('eventDate').value = today;
    }
}

function handleEventFormSubmit(form) {
    const formData = new FormData(form);
    const action = document.getElementById('eventFormAction').value;
    
    console.log("Submitting event form with action:", action);
    console.log("Form data:", Object.fromEntries(formData.entries()));
    
    if (!validateEventForm(formData, action)) {
        return false;
    }
    
    // Show loading state
    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Saving...';
    submitBtn.disabled = true;
    
    // Let the form submit normally
    return true;
}
// Update the editEvent function
function editEvent(eventId) {
    fetch(`<%= request.getContextPath() %>/admin/events?action=getEvent&eventId=${eventId}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch event data');
            }
            return response.json();
        })
        .then(event => {
            showForm('eventForm', 'edit', 'Edit Event');
            document.getElementById('eventId').value = event.eventId;
            document.getElementById('eventClientId').value = event.clientId;
            document.getElementById('eventType').value = event.type;
            document.getElementById('eventDescription').value = event.description || '';
            
            // Format date for date input (YYYY-MM-DD)
            if (event.date) {
                const eventDate = new Date(event.date);
                const year = eventDate.getFullYear();
                const month = String(eventDate.getMonth() + 1).padStart(2, '0');
                const day = String(eventDate.getDate()).padStart(2, '0');
                const formattedDate = `${year}-${month}-${day}`;
                document.getElementById('eventDate').value = formattedDate;
            }
            
            document.getElementById('eventLocation').value = event.location;
            document.getElementById('eventBudget').value = event.budget || '';
            document.getElementById('eventStatus').value = event.status;
        })
        .catch(error => {
            console.error('Error fetching event data:', error);
            showMessage('Error loading event data: ' + error.message, 'error');
        });
}


function editVendor(id, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status) {
    showForm('vendorForm', 'edit', 'Edit Vendor');
    document.getElementById('vendorId').value = id;
    document.getElementById('vendorUserId').value = userId;
    document.getElementById('vendorCompanyName').value = companyName;
    document.getElementById('vendorServiceType').value = serviceType;
    document.getElementById('vendorContactPerson').value = contactPerson;
    document.getElementById('vendorPhone').value = phone;
    document.getElementById('vendorEmail').value = email;
    document.getElementById('vendorAddress').value = address;
    document.getElementById('vendorDescription').value = description;
    document.getElementById('vendorMinPrice').value = minPrice;
    document.getElementById('vendorMaxPrice').value = maxPrice;
    document.getElementById('vendorPortfolioLink').value = portfolioLink;
    document.getElementById('vendorStatus').value = status;
}
function viewVendor(vendorId, userId, companyName, serviceType, contactPerson, phone, email, address, description, minPrice, maxPrice, portfolioLink, status) {
    console.log('Received parameters:', {
        vendorId, userId, companyName, serviceType, contactPerson, 
        phone, email, address, description, minPrice, maxPrice, portfolioLink, status
    });
    
    // Handle null/undefined values with better debugging
    companyName = companyName || 'N/A';
    serviceType = serviceType || 'N/A';
    contactPerson = contactPerson || 'N/A';
    phone = phone || 'N/A';
    email = email || 'N/A';
    address = address || 'N/A';
    description = description || 'No description provided.';
    minPrice = minPrice || 0;
    maxPrice = maxPrice || 0;
    portfolioLink = portfolioLink || '';
    status = status || 'Unknown';
    
    console.log('Processed parameters:', {
        vendorId, userId, companyName, serviceType, contactPerson, 
        phone, email, address, description, minPrice, maxPrice, portfolioLink, status
    });
    
    const portfolioHtml = portfolioLink ? 
        `<a href="${portfolioLink}" target="_blank" class="text-blue-600 hover:text-blue-800 underline">View Portfolio</a>` : 
        'N/A';
    
    const modalContent = `
        <div class="modal" id="vendorViewModal">
            <div class="modal-content" style="max-width: 600px;">
                <span class="close-button" onclick="hideModal('vendorViewModal')">&times;</span>
                <h3 class="text-xl font-bold mb-4 text-gray-800">Vendor Details</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
                    <div class="bg-gray-50 p-3 rounded border"><strong>Vendor ID:</strong> ${vendorId}</div>
                    <div class="bg-gray-50 p-3 rounded border"><strong>User ID:</strong> ${userId}</div>
                    <div class="bg-gray-50 p-3 rounded border"><strong>Company:</strong> ${companyName}</div>
                    <div class="bg-gray-50 p-3 rounded border"><strong>Service Type:</strong> ${serviceType}</div>
                    <div class="bg-gray-50 p-3 rounded border"><strong>Contact Person:</strong> ${contactPerson}</div>
                    <div class="bg-gray-50 p-3 rounded border"><strong>Phone:</strong> ${phone}</div>
                    <div class="bg-gray-50 p-3 rounded border"><strong>Email:</strong> ${email}</div>
                    <div class="bg-gray-50 p-3 rounded border">
                        <strong>Status:</strong> 
                        <span class="px-2 py-1 rounded text-xs ${
                            status == 'Approved' ? 'bg-green-100 text-green-800' :
                            status == 'Pending Approval' ? 'bg-yellow-100 text-yellow-800' :
                            status == 'Rejected' ? 'bg-red-100 text-red-800' :
                            'bg-gray-100 text-gray-800'
                        }">${status}</span>
                    </div>
                    <div class="md:col-span-2 bg-gray-50 p-3 rounded border"><strong>Address:</strong> ${address}</div>
                    <div class="md:col-span-2 bg-gray-50 p-3 rounded border">
                        <strong>Description:</strong> 
                        <p class="mt-1 text-gray-600">${description}</p>
                    </div>
                    <div class="bg-gray-50 p-3 rounded border">
                        <strong>Price Range:</strong> 
                        NPR ${minPrice} - NPR ${maxPrice}
                    </div>
                    <div class="bg-gray-50 p-3 rounded border"><strong>Portfolio:</strong> ${portfolioHtml}</div>
                </div>
                <div class="mt-6 flex justify-end gap-2">
                    <button onclick="editVendor(${vendorId})" class="btn btn-primary">
                        <i class="fas fa-edit mr-2"></i>Edit Vendor
                    </button>
                    <button onclick="hideModal('vendorViewModal')" class="btn btn-secondary">Close</button>
                </div>
            </div>
        </div>
    `;
    
    // Remove existing modal if any
    const existingModal = document.getElementById('vendorViewModal');
    if (existingModal) {
        existingModal.remove();
    }
    
    // Add modal to body and show it
    document.body.insertAdjacentHTML('beforeend', modalContent);
    showModal('vendorViewModal');
}

function editBooking(id, eventId, vendorId, serviceBooked, amount, status, notes, advanceRequiredPercentage, advanceAmountDue, amountPaid) {
    showForm('bookingForm', 'edit', 'Edit Booking');
    document.getElementById('bookingId').value = id;
    document.getElementById('bookingEventId').value = eventId;
    document.getElementById('bookingVendorId').value = vendorId || '';
    document.getElementById('bookingServiceBooked').value = serviceBooked;
    document.getElementById('bookingAmount').value = amount;
    document.getElementById('bookingStatus').value = status;
    document.getElementById('bookingNotes').value = notes;
    document.getElementById('bookingAdvanceRequiredPercentage').value = advanceRequiredPercentage;
    document.getElementById('bookingAdvanceAmountDue').value = advanceAmountDue;
    document.getElementById('bookingAmountPaid').value = amountPaid;
}

function showPaymentForm(bookingId) {
    showModal('paymentModal');
    document.getElementById('paymentModalTitle').innerText = 'Add Payment for Booking ID: ' + bookingId;
    document.getElementById('paymentFormAction').value = 'recordPayment';
    document.getElementById('paymentId').value = '';
    document.getElementById('paymentBookingId').value = bookingId;
    document.getElementById('paymentAmount').value = '';
    document.getElementById('paymentTransactionId').value = '';

    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    document.getElementById('paymentDate').value = `${year}-${month}-${day}T${hours}:${minutes}`;
    document.getElementById('paymentStatus').value = 'Completed';
}

function editPayment(id, bookingId, amount, paymentDate, status, transactionId, paymentMethod) {
    showModal('paymentModal');
    document.getElementById('paymentModalTitle').innerText = 'Edit Payment ID: ' + id;
    document.getElementById('paymentFormAction').value = 'edit';
    document.getElementById('paymentId').value = id;
    document.getElementById('paymentBookingId').value = bookingId;
    document.getElementById('paymentAmount').value = amount;
    document.getElementById('paymentDate').value = paymentDate.substring(0, 10) + 'T' + paymentDate.substring(11, 16);
    document.getElementById('paymentStatus').value = status;
    document.getElementById('paymentTransactionId').value = transactionId;
    document.getElementById('paymentMethod').value = paymentMethod;
}

function confirmDelete(entityType, id) {
    showModal('deleteConfirmModal');
    document.getElementById('deleteEntityType').innerText = entityType;
    document.getElementById('idToDelete').value = id;
    
    const deleteForm = document.getElementById('deleteForm');
    const basePath = '<%= request.getContextPath() %>/admin/';
    
    if (['user', 'event', 'vendor', 'booking', 'payment'].includes(entityType)) {
        deleteForm.action = basePath + entityType + 's';
    }
}

// ─────────────────────────────────────────────────────────────
// Utility Functions
// ─────────────────────────────────────────────────────────────
function showMessage(message, type) {
    const box = document.createElement('div');
    box.className = `message-box ${type}`;
    box.textContent = message;
    document.querySelector('.main-content').prepend(box);
    setTimeout(() => box.remove(), 5000);
}

function initializeFormHandlers() {
    // Hide all forms initially
    ['userForm', 'eventForm', 'vendorForm', 'bookingForm'].forEach(hideForm);
}

function initializePagination() {
    // Initialize pagination for all sections
    Object.keys(paginationState).forEach(section => {
        initializeSectionPagination(section, paginationState[section].totalItems);
    });
}

function initializeSectionPagination(section, totalItems) {
    paginationState[section].totalItems = totalItems;
    // renderTable(section);
    // renderPagination(section);
}

// Debug function to check section states
function debugSections() {
    console.log('== Section Debug Info ==');
    document.querySelectorAll('.dashboard-section').forEach(section => {
        console.log(`Section: ${section.id}, Display: ${section.style.display}`);
    });
    console.log('Current Active Section:', currentActiveSection);
    console.log('URL Hash:', window.location.hash);
}

function viewEventDetails(eventId) {
    console.log('Fetching details for event ID:', eventId);
    
    // Show loading state
    const loadingModal = showLoadingModal('Loading event details...');
    
    fetch(`<%= request.getContextPath() %>/admin/events?action=getEventDetails&eventId=${eventId}`, {
        headers: {
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        console.log('Response status:', response.status, 'Content-Type:', response.headers.get('content-type'));
        
        // Check if response is JSON
        const contentType = response.headers.get('content-type');
        if (!contentType || !contentType.includes('application/json')) {
            return response.text().then(text => {
                console.error('Expected JSON but got:', text.substring(0, 200));
                throw new Error('Server returned HTML instead of JSON. Check server logs for errors.');
            });
        }
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(event => {
        console.log('Event data received:', event);
        hideLoadingModal(loadingModal);
        showEventDetailsModal(event);
    })
    .catch(error => {
        console.error('Error fetching event details:', error);
        hideLoadingModal(loadingModal);
        showMessage('Error loading event details: ' + error.message, 'error');
        
        // Fallback: Show basic event info from the table data
        showBasicEventDetails(eventId);
    });
}

// Helper function to show loading modal
function showLoadingModal(message = 'Loading...') {
    const modalId = 'loadingModal';
    const modalContent = `
        <div class="modal active" id="${modalId}">
            <div class="modal-content" style="max-width: 300px; text-align: center;">
                <div class="p-6">
                    <i class="fas fa-spinner fa-spin text-2xl text-blue-500 mb-4"></i>
                    <p class="text-gray-700">${message}</p>
                </div>
            </div>
        </div>
    `;
    
    // Remove existing modal if any
    const existingModal = document.getElementById(modalId);
    if (existingModal) {
        existingModal.remove();
    }
    
    document.body.insertAdjacentHTML('beforeend', modalContent);
    return modalId;
}

function hideLoadingModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.remove();
    }
}

// Fallback function to show basic event details from table data
function showBasicEventDetails(eventId) {
    // Try to find the event in the current table
    const eventRow = document.querySelector(`tr:has(td:contains("${eventId}"))`);
    if (eventRow) {
        const cells = eventRow.querySelectorAll('td');
        const event = {
            eventId: eventId,
            type: cells[2]?.textContent || 'Unknown',
            clientId: cells[1]?.textContent || 'Unknown',
            date: cells[4]?.textContent || 'Unknown',
            location: cells[5]?.textContent || 'Unknown',
            budget: cells[6]?.textContent || 'Not set',
            status: cells[7]?.textContent || 'Unknown',
            selectedVendors: cells[8]?.textContent || 'Not assigned'
        };
        
        showEventDetailsModal(event);
    } else {
        showMessage('Could not load event details. Please try again.', 'error');
    }
}
function showEventDetailsModal(event) {
    const vendorList = event.selectedVendors && event.selectedVendors.length > 0 
        ? event.selectedVendors.map(v => v.companyName).join(', ')
        : 'No vendors selected';

    const modalContent = `
        <div class="modal" id="eventDetailsModal">
            <div class="modal-content" style="max-width: 700px;">
                <span class="close-button" onclick="hideModal('eventDetailsModal')">&times;</span>
                <h3 class="text-xl font-bold mb-4 text-gray-800">Event Details - ID: ${event.eventId}</h3>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                    <div class="bg-gray-50 p-4 rounded-lg">
                        <h4 class="font-semibold text-gray-700 mb-2">Basic Information</h4>
                        <div class="space-y-2 text-sm">
                            <div><strong>Type:</strong> ${event.type}</div>
                            <div><strong>Client ID:</strong> ${event.clientId}</div>
                            <div><strong>Date:</strong> ${event.date}</div>
                            <div><strong>Location:</strong> ${event.location || 'Not specified'}</div>
                            <div><strong>Budget:</strong> ${event.budget ? 'NPR ' + parseFloat(event.budget).toLocaleString() : 'Not set'}</div>
                        </div>
                    </div>
                    
                    <div class="bg-gray-50 p-4 rounded-lg">
                        <h4 class="font-semibold text-gray-700 mb-2">Status & Vendors</h4>
                        <div class="space-y-2 text-sm">
                            <div>
                                <strong>Status:</strong> 
                                <span class="px-2 py-1 rounded text-xs ${
                                    event.status == 'Approved' ? 'bg-green-100 text-green-800' :
                                    event.status == 'Pending Approval' ? 'bg-yellow-100 text-yellow-800' :
                                    event.status == 'Rejected' ? 'bg-red-100 text-red-800' :
                                    'bg-gray-100 text-gray-800'
                                }">${event.status}</span>
                            </div>
                            <div>
                                <strong>Selected Vendors:</strong> 
                                <div class="mt-1">${vendorList}</div>
                            </div>
                            <div><strong>Guest Count:</strong> ${event.guestCount || 'Not specified'}</div>
                        </div>
                    </div>
                </div>
                
           
                <div class="flex justify-end gap-2 mt-6">
                    <button onclick="editEventFromTable(${event.eventId})" class="btn btn-primary">
                        <i class="fas fa-edit mr-2"></i>Edit Event
                    </button>
                    <button onclick="hideModal('eventDetailsModal')" class="btn btn-secondary">Close</button>
                </div>
            </div>
        </div>
    `;
    
    // Remove existing modal if any
    const existingModal = document.getElementById('eventDetailsModal');
    if (existingModal) existingModal.remove();
    
    document.body.insertAdjacentHTML('beforeend', modalContent);
    showModal('eventDetailsModal');
}


</script>

</body>
</html>
