<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Dashboard - Event Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            /* Modern Color Palette */
            --primary: #4361ee;
            --primary-dark: #3a56d4;
            --primary-light: #4895ef;
            --secondary: #7209b7;
            --success: #4cc9f0;
            --success-dark: #3a9fc7;
            --warning: #f72585;
            --danger: #e63946;
            --info: #560bad;
            
            /* Neutral Colors */
            --dark: #1a1d29;
            --dark-light: #2d3045;
            --gray-1: #f8f9fa;
            --gray-2: #e9ecef;
            --gray-3: #dee2e6;
            --gray-4: #6c757d;
            --gray-5: #495057;
            --white: #ffffff;
            
            /* Shadows */
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.07);
            --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
            --shadow-xl: 0 20px 25px rgba(0,0,0,0.15);
            
            /* Border Radius */
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --radius-xl: 20px;
            
            /* Transitions */
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--dark);
            line-height: 1.6;
        }

        /* Layout */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, var(--dark) 0%, var(--dark-light) 100%);
            color: var(--white);
            padding: 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
            box-shadow: var(--shadow-xl);
        }

        .sidebar-header {
            padding: 30px 25px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            background: rgba(255,255,255,0.05);
        }

        .sidebar-header h3 {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary-light), var(--success));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            font-size: 0.875rem;
            color: var(--gray-3);
            opacity: 0.8;
        }

        .sidebar-menu {
            padding: 20px 0;
        }

        .sidebar-menu li {
            list-style: none;
            margin-bottom: 5px;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            color: var(--gray-3);
            text-decoration: none;
            transition: var(--transition);
            border-left: 4px solid transparent;
            font-weight: 500;
        }

        .sidebar-menu li a i {
            width: 20px;
            margin-right: 15px;
            font-size: 1.1rem;
            transition: var(--transition);
        }

        .sidebar-menu li a:hover {
            background: rgba(255,255,255,0.05);
            color: var(--white);
            border-left-color: var(--primary-light);
        }

        .sidebar-menu li a:hover i {
            transform: translateX(3px);
        }

        .sidebar-menu li a.active {
            background: linear-gradient(90deg, rgba(67, 97, 238, 0.2), transparent);
            color: var(--white);
            border-left-color: var(--primary);
        }

        .sidebar-menu li a.active i {
            color: var(--primary-light);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 0;
            background: var(--gray-1);
        }

        /* Top Navigation */
        .top-nav {
            background: var(--white);
            padding: 20px 40px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .nav-user {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .user-info h4 {
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 2px;
        }

        .user-info p {
            font-size: 0.875rem;
            color: var(--gray-4);
        }

        .logout-btn {
            background: linear-gradient(135deg, var(--warning), var(--danger));
            color: var(--white);
            border: none;
            padding: 10px 20px;
            border-radius: var(--radius-sm);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Content Area */
        .content-area {
            padding: 40px;
        }

        /* Dashboard Sections */
        .dashboard-section {
            background: var(--white);
            border-radius: var(--radius-lg);
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--gray-2);
        }

        .section-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--gray-2);
        }

        .section-header h2 {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--dark);
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Financial Cards */
        .financial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .financial-card {
            background: linear-gradient(135deg, var(--white), var(--gray-1));
            padding: 25px;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            border: 1px solid var(--gray-2);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .financial-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--success));
        }

        .financial-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .financial-card.success::before { background: linear-gradient(90deg, var(--success), var(--primary-light)); }
        .financial-card.warning::before { background: linear-gradient(90deg, var(--warning), var(--danger)); }
        .financial-card.info::before { background: linear-gradient(90deg, var(--info), var(--secondary)); }

        .card-icon {
            width: 60px;
            height: 60px;
            border-radius: var(--radius-md);
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.5rem;
            margin-bottom: 20px;
        }

        .financial-card.success .card-icon { background: linear-gradient(135deg, var(--success), var(--success-dark)); }
        .financial-card.warning .card-icon { background: linear-gradient(135deg, var(--warning), var(--danger)); }
        .financial-card.info .card-icon { background: linear-gradient(135deg, var(--info), var(--secondary)); }

        .card-content h3 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 5px;
        }

        .card-content .label {
            font-size: 0.9rem;
            color: var(--gray-4);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
        }

        .card-content .description {
            font-size: 0.875rem;
            color: var(--gray-5);
            margin-top: 8px;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--white);
            padding: 20px;
            border-radius: var(--radius-md);
            text-align: center;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-2);
            transition: var(--transition);
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .stat-card h4 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 8px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-card p {
            font-size: 0.9rem;
            color: var(--gray-5);
            font-weight: 500;
        }

        /* Tables */
        .table-container {
            background: var(--white);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            padding: 15px 20px;
            text-align: left;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        table td {
            padding: 15px 20px;
            border-bottom: 1px solid var(--gray-2);
            color: var(--gray-5);
        }

        table tbody tr {
            transition: var(--transition);
        }

        table tbody tr:hover {
            background: var(--gray-1);
            transform: scale(1.01);
        }

        table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Buttons */
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: var(--radius-sm);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 0.875rem;
        }

        .btn-small {
            padding: 8px 16px;
            font-size: 0.8rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success), var(--success-dark));
            color: var(--white);
        }

        .btn-warning {
            background: linear-gradient(135deg, var(--warning), var(--danger));
            color: var(--white);
        }

        .btn-info {
            background: linear-gradient(135deg, var(--info), var(--secondary));
            color: var(--white);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        /* Status Messages */
        .status-message {
            padding: 15px 20px;
            border-radius: var(--radius-md);
            margin-bottom: 25px;
            font-weight: 500;
            border-left: 4px solid;
        }

        .status-message.success {
            background: rgba(76, 201, 240, 0.1);
            color: var(--success-dark);
            border-left-color: var(--success);
        }

        .status-message.error {
            background: rgba(230, 57, 70, 0.1);
            color: var(--danger);
            border-left-color: var(--danger);
        }

        /* Profile Info */
        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .profile-item {
            background: var(--gray-1);
            padding: 15px;
            border-radius: var(--radius-md);
            border-left: 4px solid var(--primary);
        }

        .profile-item strong {
            color: var(--primary);
            display: block;
            margin-bottom: 5px;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .sidebar {
                width: 250px;
            }
            .main-content {
                margin-left: 250px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: var(--transition);
            }
            .sidebar.active {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
            }
            .content-area {
                padding: 20px;
            }
            .financial-grid {
                grid-template-columns: 1fr;
            }
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .top-nav {
                padding: 15px 20px;
            }
            .dashboard-section {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h3>Vendor Dashboard</h3>
                <p>Event Management System</p>
            </div>
            <ul class="sidebar-menu">
                <li><a href="#overview" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard Overview</a></li>
                <li><a href="#my-profile"><i class="fas fa-user-tie"></i> My Profile</a></li>
                <li><a href="#my-bookings"><i class="fas fa-calendar-check"></i> My Bookings</a></li>
                <li><a href="#payment-history"><i class="fas fa-credit-card"></i> Payment History</a></li>
                <li><a href="#my-services"><i class="fas fa-concierge-bell"></i> My Services</a></li>
                <li><a href="<%= request.getContextPath()%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Top Navigation -->
            <nav class="top-nav">
                <div class="nav-user">
                    <div class="user-avatar">
                        <c:out value="${fn:substring(loggedInUser.name, 0, 1)}" />
                    </div>
                    <div class="user-info">
                        <h4><c:out value="${loggedInUser.name}" /></h4>
                        <p>Vendor Account</p>
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </nav>

            <!-- Content Area -->
            <div class="content-area">
                <!-- Status Messages -->
                <c:if test="${not empty param.successMessage}">
                    <div class="status-message success">
                        <i class="fas fa-check-circle"></i> <c:out value="${param.successMessage}" />
                    </div>
                </c:if>
                <c:if test="${not empty param.errorMessage}">
                    <div class="status-message error">
                        <i class="fas fa-exclamation-circle"></i> <c:out value="${param.errorMessage}" />
                    </div>
                </c:if>

                <!-- Overview Section -->
                <section id="overview" class="dashboard-section">
                    <div class="section-header">
                        <h2>Dashboard Overview</h2>
                    </div>
                    
                    <!-- Welcome Message -->
                    <div style="background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; padding: 25px; border-radius: var(--radius-lg); margin-bottom: 30px;">
                        <h3 style="color: white; margin-bottom: 10px;">Welcome back, <c:out value="${loggedInUser.name}" />! 👋</h3>
                        <p style="color: rgba(255,255,255,0.9); margin: 0;">Here's your business overview for today.</p>
                    </div>

                    <!-- Financial Summary -->
                    <div class="financial-grid">
                        <div class="financial-card success">
                            <div class="card-icon">
                                <i class="fas fa-wallet"></i>
                            </div>
                            <div class="card-content">
                                <h3>NPR <fmt:formatNumber value="${financialSummary.totalEarnings}" minFractionDigits="2" maxFractionDigits="2" /></h3>
                                <div class="label">Total Earnings</div>
                                <p class="description">Your actual revenue received</p>
                            </div>
                        </div>
                        
                        <div class="financial-card">
                            <div class="card-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="card-content">
                                <h3>NPR <fmt:formatNumber value="${financialSummary.totalRevenue}" minFractionDigits="2" maxFractionDigits="2" /></h3>
                                <div class="label">Total Revenue</div>
                                <p class="description">Value of confirmed bookings</p>
                            </div>
                        </div>
                        
                        <div class="financial-card warning">
                            <div class="card-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="card-content">
                                <h3>NPR <fmt:formatNumber value="${financialSummary.pendingAmount}" minFractionDigits="2" maxFractionDigits="2" /></h3>
                                <div class="label">Pending Amount</div>
                                <p class="description">Awaiting payment clearance</p>
                            </div>
                        </div>
                        
                        <div class="financial-card info">
                            <div class="card-icon">
                                <i class="fas fa-calendar-day"></i>
                            </div>
                            <div class="card-content">
                                <h3>NPR <fmt:formatNumber value="${financialSummary.recentPayments}" minFractionDigits="2" maxFractionDigits="2" /></h3>
                                <div class="label">Recent Payments</div>
                                <p class="description">Last 30 days activity</p>
                            </div>
                        </div>
                    </div>

                    <!-- Statistics -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <h4><c:out value="${financialSummary.totalBookings}" /></h4>
                            <p>Total Bookings</p>
                        </div>
                        <div class="stat-card">
                            <h4><c:out value="${financialSummary.completedBookings}" /></h4>
                            <p>Completed</p>
                        </div>
                        <div class="stat-card">
                            <h4><c:out value="${financialSummary.pendingBookings}" /></h4>
                            <p>Pending</p>
                        </div>
                        <div class="stat-card">
                            <h4><c:out value="${fn:length(vendorPayments)}" /></h4>
                            <p>Total Payments</p>
                        </div>
                    </div>

                    <!-- Additional Metrics -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin-top: 20px;">
                        <div style="background: linear-gradient(135deg, #fff3cd, #ffeaa7); padding: 20px; border-radius: var(--radius-md); border-left: 4px solid #fdcb6e;">
                            <strong style="color: #e17055;">Advance Due</strong><br>
                            <span style="font-size: 1.5rem; font-weight: 700; color: #2d3436;">NPR <fmt:formatNumber value="${financialSummary.advanceDue}" minFractionDigits="2" maxFractionDigits="2" /></span>
                        </div>
                        <div style="background: linear-gradient(135deg, #ffcdd2, #ef9a9a); padding: 20px; border-radius: var(--radius-md); border-left: 4px solid #e57373;">
                            <strong style="color: #c62828;">Balance Due</strong><br>
                            <span style="font-size: 1.5rem; font-weight: 700; color: #2d3436;">NPR <fmt:formatNumber value="${financialSummary.balanceDue}" minFractionDigits="2" maxFractionDigits="2" /></span>
                        </div>
                    </div>
                </section>

                <!-- Other sections remain the same but with updated styling -->
                <!-- My Profile Section -->
                <section id="my-profile" class="dashboard-section" style="display: none;">
                    <div class="section-header">
                        <h2>My Profile</h2>
                    </div>
                    <div class="profile-grid">
                        <c:if test="${not empty vendorProfile}">
                            <div class="profile-item">
                                <strong>Company Name</strong>
                                <c:out value="${vendorProfile.companyName}" />
                            </div>
                            <div class="profile-item">
                                <strong>Service Type</strong>
                                <c:out value="${vendorProfile.serviceType}" />
                            </div>
                            <div class="profile-item">
                                <strong>Contact Person</strong>
                                <c:out value="${vendorProfile.contactPerson}" />
                            </div>
                            <div class="profile-item">
                                <strong>Phone</strong>
                                <c:out value="${vendorProfile.phone}" />
                            </div>
                            <div class="profile-item">
                                <strong>Email</strong>
                                <c:out value="${vendorProfile.email}" />
                            </div>
                            <div class="profile-item">
                                <strong>Address</strong>
                                <c:out value="${vendorProfile.address}" />
                            </div>
                            <div class="profile-item">
                                <strong>Description</strong>
                                <c:out value="${vendorProfile.description}" />
                            </div>
                            <div class="profile-item">
                                <strong>Price Range</strong>
                                NPR <c:out value="${vendorProfile.minPrice}" /> - NPR <c:out value="${vendorProfile.maxPrice}" />
                            </div>
                            <div class="profile-item">
                                <strong>Portfolio</strong>
                                <a href="<c:out value="${vendorProfile.portfolioLink}" />" target="_blank" style="color: var(--primary); text-decoration: none;">
                                    <c:out value="${vendorProfile.portfolioLink}" />
                                </a>
                            </div>
                            <div class="profile-item">
                                <strong>Status</strong>
                                <span style="color: var(--success); font-weight: 600;"><c:out value="${vendorProfile.status}" /></span>
                            </div>
                            <div class="profile-item">
                                <strong>Registered On</strong>
                                <c:out value="${vendorProfile.registrationDate}" />
                            </div>
                        </c:if>
                        <c:if test="${empty vendorProfile}">
                            <div class="profile-item" style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                                <i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: var(--warning); margin-bottom: 15px;"></i>
                                <h3 style="color: var(--dark); margin-bottom: 10px;">Profile Not Found</h3>
                                <p style="color: var(--gray-5);">Your vendor profile is not complete. Please contact support.</p>
                            </div>
                        </c:if>
                    </div>
                    <a href="<%= request.getContextPath() %>/vendor/profile" class="btn btn-primary" style="margin-top: 25px;">
                        <i class="fas fa-edit"></i> Edit Profile
                    </a>
                </section>

                <!-- My Bookings Section -->
                <section id="my-bookings" class="dashboard-section" style="display: none;">
                    <div class="section-header">
                        <h2>My Bookings</h2>
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Event Type</th>
                                    <th>Client Name</th>
                                    <th>Service</th>
                                    <th>Booking Date</th>
                                    <th>Total Amount</th>
                                    <th>Advance Due</th>
                                    <th>Amount Paid</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty vendorBookings}">
                                        <c:forEach var="booking" items="${vendorBookings}">
                                            <tr>
                                                <td><strong>#<c:out value="${booking.bookingId}" /></strong></td>
                                                <td><c:out value="${booking.eventName}" /></td>
                                                <td><c:out value="${booking.clientName}" /></td>
                                                <td><c:out value="${booking.serviceBooked}" /></td>
                                                <td><c:out value="${booking.bookingDate}" /></td>
                                                <td><strong>NPR <fmt:formatNumber value="${booking.amount}" minFractionDigits="2" maxFractionDigits="2" /></strong></td>
                                                <td>NPR <fmt:formatNumber value="${booking.advanceAmountDue}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                                <td>NPR <fmt:formatNumber value="${booking.amountPaid}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                                <td>
                                                    <span style="padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; 
                                                          background: ${booking.status eq 'Confirmed' ? 'var(--success)' : 
                                                                       booking.status eq 'Pending' ? 'var(--warning)' : 
                                                                       booking.status eq 'Completed' ? 'var(--primary)' : 'var(--gray-4)'}; 
                                                          color: white;">
                                                        <c:out value="${booking.status}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                                                        <button class="btn btn-primary btn-small">
                                                            <i class="fas fa-eye"></i> Details
                                                        </button>
                                                        <c:if test="${booking.status eq 'Pending' || booking.status eq 'Advance Payment Due' || booking.status eq 'Advance Paid'}">
                                                            <form action="<%= request.getContextPath() %>/vendor/booking-action" method="POST" style="display:inline;">
                                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                                <input type="hidden" name="action" value="acceptBooking">
                                                                <button type="submit" class="btn btn-success btn-small" onclick="return confirm('Accept booking #${booking.bookingId}?')">
                                                                    <i class="fas fa-check"></i> Accept
                                                                </button>
                                                            </form>
                                                            <form action="<%= request.getContextPath() %>/vendor/booking-action" method="POST" style="display:inline;">
                                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                                <input type="hidden" name="action" value="declineBooking">
                                                                <button type="submit" class="btn btn-warning btn-small" onclick="return confirm('Decline booking #${booking.bookingId}?')">
                                                                    <i class="fas fa-times"></i> Decline
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="10" style="text-align: center; padding: 40px; color: var(--gray-4);">
                                                <i class="fas fa-inbox" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.5;"></i>
                                                <h4>No Bookings Found</h4>
                                                <p>You don't have any bookings yet.</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- Payment History Section -->
                <section id="payment-history" class="dashboard-section" style="display: none;">
                    <div class="section-header">
                        <h2>Payment History</h2>
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Payment ID</th>
                                    <th>Booking ID</th>
                                    <th>Amount</th>
                                    <th>Payment Date</th>
                                    <th>Status</th>
                                    <th>Transaction ID</th>
                                    <th>Method</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty vendorPayments}">
                                        <c:forEach var="payment" items="${vendorPayments}">
                                            <tr>
                                                <td><strong>#<c:out value="${payment.paymentId}" /></strong></td>
                                                <td>#<c:out value="${payment.bookingId}" /></td>
                                                <td><strong>NPR <fmt:formatNumber value="${payment.amount}" minFractionDigits="2" maxFractionDigits="2" /></strong></td>
                                                <td><c:out value="${payment.paymentDate}" /></td>
                                                <td>
                                                    <span style="padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; 
                                                          background: ${payment.status eq 'Completed' ? 'var(--success)' : 
                                                                       payment.status eq 'Pending' ? 'var(--warning)' : 'var(--gray-4)'}; 
                                                          color: white;">
                                                        <c:out value="${payment.status}" />
                                                    </span>
                                                </td>
                                                <td><code style="background: var(--gray-1); padding: 3px 6px; border-radius: 4px; font-size: 0.8rem;">
                                                    <c:out value="${payment.transactionId != null ? payment.transactionId : 'N/A'}" />
                                                </code></td>
                                                <td><c:out value="${payment.paymentMethod}" /></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 40px; color: var(--gray-4);">
                                                <i class="fas fa-credit-card" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.5;"></i>
                                                <h4>No Payments Found</h4>
                                                <p>You don't have any payment records yet.</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- My Services Section -->
                <section id="my-services" class="dashboard-section" style="display: none;">
                    <div class="section-header">
                        <h2>My Services</h2>
                    </div>
                    <div style="background: linear-gradient(135deg, var(--gray-1), var(--white)); padding: 25px; border-radius: var(--radius-lg); margin-bottom: 25px;">
                        <p style="color: var(--gray-5); margin: 0;">This section displays your primary service offerings and business details.</p>
                    </div>
                    <div class="profile-grid">
                        <c:if test="${not empty vendorProfile}">
                            <div class="profile-item">
                                <strong>Main Service Type</strong>
                                <c:out value="${vendorProfile.serviceType}" />
                            </div>
                            <div class="profile-item" style="grid-column: span 2;">
                                <strong>Service Description</strong>
                                <c:out value="${vendorProfile.description}" />
                            </div>
                            <div class="profile-item" style="grid-column: span 2;">
                                <strong>Price Range</strong>
                                NPR <fmt:formatNumber value="${vendorProfile.minPrice}" minFractionDigits="2" maxFractionDigits="2" /> - 
                                NPR <fmt:formatNumber value="${vendorProfile.maxPrice}" minFractionDigits="2" maxFractionDigits="2" />
                            </div>
                            <div class="profile-item" style="grid-column: span 2;">
                                <strong>Portfolio</strong>
                                <a href="<c:out value="${vendorProfile.portfolioLink}" />" target="_blank" style="color: var(--primary); text-decoration: none; font-weight: 500;">
                                    <i class="fas fa-external-link-alt"></i> View Portfolio
                                </a>
                            </div>
                        </c:if>
                    </div>
                    <button class="btn btn-primary" style="margin-top: 25px;" onclick="alert('Service management features are coming soon! Use the Edit Profile option for now.')">
                        <i class="fas fa-cog"></i> Manage Services
                    </button>
                </section>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarLinks = document.querySelectorAll('.sidebar-menu a');
            const sections = document.querySelectorAll('.dashboard-section');

            function showSection(hash) {
                sections.forEach(section => {
                    if ('#' + section.id === hash) {
                        section.style.display = 'block';
                    } else {
                        section.style.display = 'none';
                    }
                });
            }

            const initialHash = window.location.hash || '#overview';
            showSection(initialHash);
            sidebarLinks.forEach(link => {
                if (link.getAttribute('href') === initialHash) {
                    link.classList.add('active');
                } else {
                    link.classList.remove('active');
                }
            });

            sidebarLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const targetHash = this.getAttribute('href');
                    sidebarLinks.forEach(l => l.classList.remove('active'));
                    this.classList.add('active');
                    showSection(targetHash);
                    history.pushState(null, '', targetHash);
                });
            });

            window.addEventListener('popstate', function() {
                const currentHash = window.location.hash || '#overview';
                showSection(currentHash);
                sidebarLinks.forEach(link => {
                    if (link.getAttribute('href') === currentHash) {
                        link.classList.add('active');
                    } else {
                        link.classList.remove('active');
                    }
                });
            });

            // Handle URL parameters for messages
            const urlParams = new URLSearchParams(window.location.search);
            const successMessage = urlParams.get('successMessage');
            const errorMessage = urlParams.get('errorMessage');

            if (successMessage || errorMessage) {
                history.replaceState(null, '', window.location.pathname + window.location.hash);
            }
        });
    </script>
</body>
</html>