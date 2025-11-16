<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard - EMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://js.stripe.com/v3/"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#4a6baf',
                        'primary-hover': '#3a5699',
                        secondary: '#e9edf5',
                        success: '#10b981',
                        'success-hover': '#059669',
                        danger: '#ef4444',
                        'danger-hover': '#dc2626',
                        warning: '#f59e0b',
                        'warning-hover': '#d97706',
                        info: '#3b82f6',
                        'info-hover': '#2563eb',
                        sidebar: '#1e293b',
                    },
                    fontFamily: {
                        'poppins': ['Poppins', 'sans-serif'],
                    },
                    boxShadow: {
                        'custom': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
                        'custom-hover': '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
                    }
                }
            }
        }
    </script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            background-color: #f8f9fa;
            line-height: 1.6;
        }

        .sidebar-scroll {
            scrollbar-width: thin;
            scrollbar-color: rgba(255, 255, 255, 0.3) transparent;
        }

        .sidebar-scroll::-webkit-scrollbar {
            width: 4px;
        }

        .sidebar-scroll::-webkit-scrollbar-track {
            background: transparent;
        }

        .sidebar-scroll::-webkit-scrollbar-thumb {
            background-color: rgba(255, 255, 255, 0.3);
            border-radius: 20px;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: capitalize;
        }

        .status-badge.pending {
            background-color: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.2);
        }

        .status-badge.success {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .status-badge.info {
            background-color: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            border: 1px solid rgba(59, 130, 246, 0.2);
        }

        .status-badge.paid {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .status-badge.unpaid {
            background-color: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.2);
        }

        .status-badge.advance {
            background-color: rgba(139, 92, 246, 0.1);
            color: #8b5cf6;
            border: 1px solid rgba(139, 92, 246, 0.2);
        }

        .status-badge.danger {
            background-color: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .vendor-status-pending {
            background-color: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            border: 1px solid rgba(59, 130, 246, 0.2);
        }

        .vendor-status-confirmed {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .vendor-status-declined {
            background-color: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .vendor-status-completed {
            background-color: rgba(139, 92, 246, 0.1);
            color: #8b5cf6;
            border: 1px solid rgba(139, 92, 246, 0.2);
        }

        @media (max-width: 767px) {
            .table-responsive table {
                display: block;
                width: 100%;
            }
            
            .table-responsive thead {
                display: none;
            }
            
            .table-responsive tbody,
            .table-responsive tr,
            .table-responsive td {
                display: block;
                width: 100%;
            }
            
            .table-responsive tr {
                margin-bottom: 1rem;
                border: 1px solid #e5e7eb;
                border-radius: 0.5rem;
                padding: 1rem;
            }
            
            .table-responsive td {
                padding: 0.5rem 0;
                border: none;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .table-responsive td::before {
                content: attr(data-label);
                font-weight: 600;
                color: #374151;
                margin-right: 1rem;
            }
        }
    </style>
</head>
<body class="font-poppins bg-gray-50 flex flex-col min-h-screen">
    <!-- Header Section -->
    <header class="bg-white shadow-custom sticky top-0 z-50">
        <nav class="flex justify-between items-center px-4 py-3 md:px-6 md:py-3 max-w-7xl mx-auto w-full">
            <div class="flex items-center">
                <div class="text-xl md:text-2xl font-bold text-primary">EMS</div>
                <!-- Mobile menu button -->
                <button id="mobile-menu-button" class="md:hidden ml-4 text-gray-600 hover:text-primary focus:outline-none">
                    <i class="fas fa-bars text-lg"></i>
                </button>
            </div>
            <div class="hidden md:flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/client/event-action?action=dashboard" class="text-gray-700 hover:text-primary font-medium transition-colors text-sm">Customer Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout" class="text-gray-700 hover:text-primary font-medium transition-colors text-sm">Logout</a>
            </div>
        </nav>
    </header>

    <!-- Main Content Area -->
    <main class="flex flex-1 max-w-9xl mx-auto w-full">
        <!-- Sidebar Navigation -->
        <aside id="sidebar" class="bg-sidebar text-white w-64 flex-shrink-0 hidden md:block h-[calc(100vh-64px)] sticky top-16 overflow-y-auto sidebar-scroll">
            <div class="p-5">
                <h3 class="text-lg font-semibold text-center mb-6">Customer Panel</h3>
                <ul class="space-y-1">
                    <li>
                        <a href="#overview" class="sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors bg-opacity-10 bg-white border-l-4 border-primary">
                            <i class="fas fa-tachometer-alt mr-3 text-base"></i>
                            <span class="text-sm">Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="#my-profile" class="sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-user-circle mr-3 text-base"></i>
                            <span class="text-sm">My Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="#my-events" class="sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-calendar-alt mr-3 text-base"></i>
                            <span class="text-sm">My Events</span>
                        </a>
                    </li>
                    <li>
                        <a href="#my-bookings" class="sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-book-open mr-3 text-base"></i>
                            <span class="text-sm">My Bookings</span>
                        </a>
                    </li>
                    <li>
                        <a href="#payment-history" class="sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-money-bill-wave mr-3 text-base"></i>
                            <span class="text-sm">Payment History</span>
                        </a>
                    </li>
                    <li>
                        <a href="#guest" class="sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-users mr-3 text-base"></i>
                            <span class="text-sm">Guest Management</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/logout" class="sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-sign-out-alt mr-3 text-base"></i>
                            <span class="text-sm">Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </aside>

        <!-- Mobile Sidebar Overlay -->
        <div id="mobile-sidebar-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-40 md:hidden hidden"></div>

        <!-- Mobile Sidebar -->
        <div id="mobile-sidebar" class="fixed inset-y-0 left-0 z-50 w-64 bg-sidebar text-white transform -translate-x-full md:hidden transition-transform duration-300 ease-in-out h-full overflow-y-auto sidebar-scroll">
            <div class="p-5">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-lg font-semibold">Customer Panel</h3>
                    <button id="close-mobile-menu" class="text-white hover:text-gray-300 focus:outline-none">
                        <i class="fas fa-times text-lg"></i>
                    </button>
                </div>
                <ul class="space-y-1">
                    <li>
                        <a href="#overview" class="mobile-sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors bg-opacity-10 bg-white border-l-4 border-primary">
                            <i class="fas fa-tachometer-alt mr-3 text-base"></i>
                            <span class="text-sm">Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="#my-profile" class="mobile-sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-user-circle mr-3 text-base"></i>
                            <span class="text-sm">My Profile</span>
                        </a>
                    </li>
                    <li>
                        <a href="#my-events" class="mobile-sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-calendar-alt mr-3 text-base"></i>
                            <span class="text-sm">My Events</span>
                        </a>
                    </li>
                    <li>
                        <a href="#my-bookings" class="mobile-sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-book-open mr-3 text-base"></i>
                            <span class="text-sm">My Bookings</span>
                        </a>
                    </li>
                    <li>
                        <a href="#payment-history" class="mobile-sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-money-bill-wave mr-3 text-base"></i>
                            <span class="text-sm">Payment History</span>
                        </a>
                    </li>
                    <li>
                        <a href="#guest" class="mobile-sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-users mr-3 text-base"></i>
                            <span class="text-sm">Guest Management</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/logout" class="mobile-sidebar-link flex items-center px-4 py-3 rounded-lg transition-colors hover:bg-white hover:bg-opacity-10 border-l-4 border-transparent">
                            <i class="fas fa-sign-out-alt mr-3 text-base"></i>
                            <span class="text-sm">Logout</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <section class="flex-1 p-4 md:p-5 bg-gray-50 w-full overflow-hidden">
            <%-- Display server-side messages from URL parameters --%>
            <c:if test="${not empty param.successMessage}">
                <div class="bg-green-50 border-l-4 border-green-500 p-3 mb-4 rounded">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <i class="fas fa-check-circle text-green-500"></i>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-green-700"><c:out value="${param.successMessage}" /></p>
                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty param.errorMessage}">
                <div class="bg-red-50 border-l-4 border-red-500 p-3 mb-4 rounded">
                    <div class="flex">
                        <div class="flex-shrink-0">
                            <i class="fas fa-exclamation-circle text-red-500"></i>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm text-red-700"><c:out value="${param.errorMessage}" /></p>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Dashboard Overview Section -->
            <div id="overview" class="dashboard-section bg-white rounded-lg shadow-custom p-5 mb-5">
                <h2 class="text-xl font-bold text-gray-800 mb-3 pb-2 border-b-2 border-primary inline-block">Dashboard Overview</h2>
                <p class="text-gray-600 mb-5">Welcome, <span class="font-semibold text-primary"><c:out value="${loggedInUser.name}" /></span>!</p>
                
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="bg-white rounded-lg shadow-custom p-9 border border-gray-200 transition-all duration-300 hover:shadow-custom-hover hover:-translate-y-1 relative overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary to-info"></div>
                        <h4 class="text-2xl font-bold text-primary mb-1"><c:out value="${fn:length(customerEvents)}" /></h4>
                        <p class="text-gray-600 text-sm">Total Events</p>
                    </div>
                    <div class="bg-white rounded-lg shadow-custom p-9 border border-gray-200 transition-all duration-300 hover:shadow-custom-hover hover:-translate-y-1 relative overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary to-info"></div>
                        <h4 class="text-2xl font-bold text-primary mb-1"><c:out value="${fn:length(customerBookings)}" /></h4>
                        <p class="text-gray-600 text-sm">Total Bookings</p>
                    </div>
                    <div class="bg-white rounded-lg shadow-custom p-9 border border-gray-200 transition-all duration-300 hover:shadow-custom-hover hover:-translate-y-1 relative overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary to-info"></div>
                        <h4 class="text-2xl font-bold text-primary mb-1">
                            NPR 
                            <c:set var="totalSpend" value="${0}" />
                            <c:if test="${not empty customerPayments}">
                                <c:forEach var="payment" items="${customerPayments}">
                                    <c:if test="${payment.status eq 'Completed'}">
                                        <c:set var="totalSpend" value="${totalSpend + payment.amount}" />
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            <fmt:formatNumber value="${totalSpend}" minFractionDigits="2" maxFractionDigits="2" />
                        </h4>
                        <p class="text-gray-600 text-sm">Total Payments Made</p>
                    </div>
                    <div class="bg-white rounded-lg shadow-custom p-9 border border-gray-200 transition-all duration-300 hover:shadow-custom-hover hover:-translate-y-1 relative overflow-hidden">
                        <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary to-info"></div>
                        <c:set var="pendingPaymentsCount" value="${0}" />
                        <c:if test="${not empty customerBookings}">
                            <c:forEach var="booking" items="${customerBookings}">
                                <c:if test="${booking.amountPaid lt booking.amount}">
                                    <c:set var="pendingPaymentsCount" value="${pendingPaymentsCount + 1}" />
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <h4 class="text-2xl font-bold text-primary mb-1"><c:out value="${pendingPaymentsCount}" /></h4>
                        <p class="text-gray-600 text-sm">Pending Payments</p>
                    </div>
                </div>
            </div>

            <!-- My Profile Section -->
            <div id="my-profile" class="dashboard-section bg-white rounded-lg shadow-custom p-5 mb-5 hidden">
                <h2 class="text-xl font-bold text-gray-800 mb-4 pb-2 border-b-2 border-primary inline-block">My Profile</h2>
                <div class="bg-secondary rounded-lg p-4 mb-4">
                    <c:if test="${not empty clientProfile}">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                            <p class="text-sm"><strong class="text-primary">Name:</strong> <c:out value="${loggedInUser.name}" /></p>
                            <p class="text-sm"><strong class="text-primary">Email:</strong> <c:out value="${loggedInUser.email}" /></p>
                            <p class="text-sm"><strong class="text-primary">Phone:</strong> <c:out value="${clientProfile.phone}" /></p>
                            <p class="text-sm"><strong class="text-primary">Address:</strong> <c:out value="${clientProfile.address}" /></p>
                        </div>
                    </c:if>
                    <c:if test="${empty clientProfile}">
                        <p class="text-gray-600 text-sm">No Client profile found. Please ensure your profile is complete or contact support.</p>
                    </c:if>
                </div>
                <a href="${pageContext.request.contextPath}/client/profile" class="inline-flex items-center px-4 py-2 bg-info text-white rounded-lg hover:bg-info-hover transition-colors text-sm">
                    <i class="fas fa-edit mr-2"></i> Edit Profile
                </a>
            </div>

            <!-- My Events Section -->
            <div id="my-events" class="dashboard-section bg-white rounded-lg shadow-custom p-5 mb-5 hidden">
                <h2 class="text-xl font-bold text-gray-800 mb-4 pb-2 border-b-2 border-primary inline-block">My Events</h2>
                
                <c:if test="${not empty param.errorMessage}">
                    <div class="bg-red-50 border-l-4 border-red-500 p-3 mb-4 rounded">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-exclamation-circle text-red-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm text-red-700"><c:out value="${param.errorMessage}" /></p>
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty param.successMessage}">
                    <div class="bg-green-50 border-l-4 border-green-500 p-3 mb-4 rounded">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-check-circle text-green-500"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm text-green-700"><c:out value="${param.successMessage}" /></p>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <div class="mb-4">
                    <a href="${pageContext.request.contextPath}/client/event-action?action=create" class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-hover transition-colors text-sm">
                        <i class="fas fa-plus-circle mr-2"></i> Create New Event
                    </a>
                </div>
                
                <div class="table-responsive rounded-lg shadow">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Event ID</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Budget</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Event Status</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Payment Status</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Selected Vendors</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${not empty customerEvents}">
                                    <c:forEach var="event" items="${customerEvents}">
                                        <tr class="hover:bg-gray-50 transition-colors">
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Event ID"><c:out value="${event.eventId}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Type"><c:out value="${event.type}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Date">
                                                <c:choose>
                                                    <c:when test="${not empty event.date}">
                                                        <fmt:formatDate value="${event.date}" pattern="yyyy-MM-dd"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Not Set
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Budget">NPR <fmt:formatNumber value="${event.budget}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Event Status">
                                                <c:choose>
                                                    <c:when test="${event.status eq 'Pending Approval'}">
                                                        <span class="status-badge pending">Pending Approval</span>
                                                    </c:when>
                                                    <c:when test="${event.status eq 'Approved'}">
                                                        <span class="status-badge success">Approved</span>
                                                    </c:when>
                                                    <c:when test="${event.status eq 'In Progress'}">
                                                        <span class="status-badge info">In Progress</span>
                                                    </c:when>
                                                    <c:when test="${event.status eq 'Completed'}">
                                                        <span class="status-badge paid">Completed</span>
                                                    </c:when>
                                                    <c:when test="${event.status eq 'Cancelled'}">
                                                        <span class="status-badge unpaid">Cancelled</span>
                                                    </c:when>
                                                    <c:when test="${event.status eq 'Rejected'}">
                                                        <span class="status-badge danger">Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge pending"><c:out value="${event.status}" /></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm" data-label="Payment Status">
                                                <c:choose>
                                                    <c:when test="${event.paymentStatus eq 'fully_paid'}">
                                                        <span class="status-badge paid">Fully Paid</span>
                                                    </c:when>
                                                    <c:when test="${event.paymentStatus eq 'advance_paid'}">
                                                        <span class="status-badge advance">Advance Paid</span>
                                                    </c:when>
                                                    <c:when test="${event.paymentStatus eq 'pending'}">
                                                        <span class="status-badge pending">Payment Pending</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge unpaid"><c:out value="${event.paymentStatus}" /></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Selected Vendors">
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
                                            <td class="px-4 py-3 whitespace-nowrap text-sm font-medium" data-label="Actions">
                                                <div class="flex flex-wrap gap-1">
                                                    <!-- Edit Button - Only for pending events -->
                                                    <c:if test="${event.status eq 'Pending Approval'}">
                                                        <a href="${pageContext.request.contextPath}/client/event-action?action=edit&eventId=<c:out value="${event.eventId}"/>" 
                                                           class="inline-flex items-center px-2 py-1 bg-info text-white rounded text-xs hover:bg-info-hover transition-colors">
                                                            <i class="fas fa-edit mr-1"></i> Edit
                                                        </a>
                                                    </c:if>
                                                    
                                                    <!-- View Details Button -->
                                                    <button onclick="showEventDetails(${event.eventId})" 
                                                            class="inline-flex items-center px-2 py-1 bg-primary text-white rounded text-xs hover:bg-primary-hover transition-colors">
                                                        <i class="fas fa-eye mr-1"></i> Details
                                                    </button>

                                                    <!-- Guests Management -->
                                                    <a href="${pageContext.request.contextPath}/client/guests?eventId=<c:out value="${event.eventId}"/>" 
                                                       class="inline-flex items-center px-2 py-1 bg-warning text-white rounded text-xs hover:bg-warning-hover transition-colors">
                                                        <i class="fas fa-users mr-1"></i> Guests
                                                    </a>

                                                    <!-- Payment Options -->
                                                    <c:choose>
                                                        <c:when test="${event.paymentStatus eq 'fully_paid'}">
                                                            <span class="inline-flex items-center px-2 py-1 bg-success text-white rounded text-xs opacity-75 cursor-not-allowed">
                                                                <i class="fas fa-check mr-1"></i> Paid
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${event.paymentStatus eq 'advance_paid'}">
                                                            <button onclick="showPaymentModal(${event.eventId}, 'balance', ${event.budget - event.paidAmount})" 
                                                                    class="inline-flex items-center px-2 py-1 bg-warning text-white rounded text-xs hover:bg-warning-hover transition-colors">
                                                                <i class="fas fa-credit-card mr-1"></i> Pay Balance
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${event.paymentStatus eq 'pending'}">
                                                            <div class="flex flex-col gap-1">
                                                                <button onclick="showPaymentModal(${event.eventId}, 'advance', ${event.budget * 0.3})" 
                                                                        class="inline-flex items-center px-2 py-1 bg-primary text-white rounded text-xs hover:bg-primary-hover transition-colors">
                                                                    <i class="fas fa-credit-card mr-1"></i> Pay Advance
                                                                </button>
                                                                <button onclick="showPaymentModal(${event.eventId}, 'full', ${event.budget})" 
                                                                        class="inline-flex items-center px-2 py-1 bg-success text-white rounded text-xs hover:bg-success-hover transition-colors">
                                                                    <i class="fas fa-credit-card mr-1"></i> Pay Full
                                                                </button>
                                                            </div>
                                                        </c:when>
                                                    </c:choose>

                                                    <!-- Cancel button - only show for pending events -->
                                                    <c:if test="${event.status eq 'Pending Approval'}">
                                                        <form action="${pageContext.request.contextPath}/client/event-action" method="POST" 
                                                              onsubmit="return confirm('Are you sure you want to cancel this event?');" class="inline">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <input type="hidden" name="eventId" value="<c:out value="${event.eventId}"/>">
                                                            <button type="submit" class="inline-flex items-center px-2 py-1 bg-danger text-white rounded text-xs hover:bg-danger-hover transition-colors">
                                                                <i class="fas fa-times mr-1"></i> Cancel
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
                                        <td colspan="8" class="px-4 py-3 text-center text-sm text-gray-500">
                                            No events found. <a href="${pageContext.request.contextPath}/client/event-action?action=create" class="text-primary hover:underline">Create your first event</a>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- My Bookings Section -->
            <div id="my-bookings" class="dashboard-section bg-white rounded-lg shadow-custom p-5 mb-5 hidden">
                <h2 class="text-xl font-bold text-gray-800 mb-4 pb-2 border-b-2 border-primary inline-block">My Bookings</h2>
                
                <div class="table-responsive rounded-lg shadow">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking ID</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Event Type</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vendor</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Service Booked</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking Date</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Event Date</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Amount</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Amount Paid</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${not empty customerBookings}">
                                    <c:forEach var="booking" items="${customerBookings}">
                                        <tr class="hover:bg-gray-50 transition-colors">
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Booking ID"><c:out value="${booking.bookingId}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Event Type"><c:out value="${booking.eventName}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Vendor"><c:out value="${booking.vendorCompanyName != null ? booking.vendorCompanyName : 'N/A'}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Service Booked"><c:out value="${booking.serviceBooked}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Booking Date"><c:out value="${booking.bookingDate}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Event Date">
                                                <c:choose>
                                                    <c:when test="${not empty booking.eventDate}">
                                                        <fmt:formatDate value="${booking.eventDate}" pattern="yyyy-MM-dd"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Total Amount">NPR <fmt:formatNumber value="${booking.amount}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Amount Paid">NPR <fmt:formatNumber value="${booking.amountPaid}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm" data-label="Status">
                                                <c:choose>
                                                    <c:when test="${booking.amountPaid ge booking.amount}">
                                                        <span class="status-badge paid">Fully Paid</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge pending">Payment Pending</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm font-medium" data-label="Actions">
                                                <div class="flex flex-wrap gap-1">
                                                    <button class="inline-flex items-center px-2 py-1 bg-primary text-white rounded text-xs hover:bg-primary-hover transition-colors">
                                                        <i class="fas fa-eye mr-1"></i> Details
                                                    </button>
                                                    
                                                    <%-- Allow cancellation only for Pending/Advance Payment Due/Advance Paid bookings --%>
                                                    <c:if test="${booking.status eq 'Pending' || booking.status eq 'Advance Payment Due' || booking.status eq 'Advance Paid'}">
                                                        <form action="<%= request.getContextPath() %>/customer/booking-action" method="POST" onsubmit="return confirm('Are you sure you want to cancel booking ${booking.bookingId}?');" class="inline">
                                                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <button type="submit" class="inline-flex items-center px-2 py-1 bg-danger text-white rounded text-xs hover:bg-danger-hover transition-colors">
                                                                <i class="fas fa-times mr-1"></i> Cancel
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    
                                                    <%-- Payment button --%>
                                                    <c:if test="${booking.amountPaid lt booking.amount}">
                                                        <a href="<%= request.getContextPath() %>/client/process-payment?bookingId=${booking.bookingId}" 
                                                           class="inline-flex items-center px-2 py-1 bg-success text-white rounded text-xs hover:bg-success-hover transition-colors">
                                                            <i class="fas fa-money-bill-wave mr-1"></i> Pay Now
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="10" class="px-4 py-3 text-center text-sm text-gray-500">No bookings found.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Payment History Section -->
            <div id="payment-history" class="dashboard-section bg-white rounded-lg shadow-custom p-5 mb-5 hidden">
                <h2 class="text-xl font-bold text-gray-800 mb-4 pb-2 border-b-2 border-primary inline-block">Payment History</h2>
                
                <div class="table-responsive rounded-lg shadow">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Payment ID</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booking ID</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Amount</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Transaction ID</th>
                                <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Method</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <c:choose>
                                <c:when test="${not empty customerPayments}">
                                    <c:forEach var="payment" items="${customerPayments}">
                                        <tr class="hover:bg-gray-50 transition-colors">
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Payment ID"><c:out value="${payment.paymentId}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Booking ID"><c:out value="${payment.bookingId}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Amount">NPR <fmt:formatNumber value="${payment.amount}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Date"><c:out value="${payment.paymentDate}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm" data-label="Status">
    <c:choose>
        <c:when test="${not empty payment.status}">
            <c:choose>
                <c:when test="${payment.status eq 'Completed'}">
                    <span class="status-badge paid">Completed</span>
                </c:when>
                <c:when test="${payment.status eq 'Pending'}">
                    <span class="status-badge pending">Pending</span>
                </c:when>
                <c:otherwise>
                    <span class="status-badge unpaid">${payment.status}</span>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
            <span class="status-badge danger">Unknown</span>
        </c:otherwise>
    </c:choose>
</td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Transaction ID"><c:out value="${payment.transactionId != null ? payment.transactionId : 'N/A'}" /></td>
                                            <td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900" data-label="Method"><c:out value="${payment.paymentMethod}" /></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="px-4 py-3 text-center text-sm text-gray-500">No payments found.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Guest Management Section -->
            <div id="guest" class="dashboard-section bg-white rounded-lg shadow-custom p-5 mb-5 hidden">
                <h2 class="text-xl font-bold text-gray-800 mb-4 pb-2 border-b-2 border-primary inline-block">Guest Management</h2>
                <p class="text-gray-600 mb-4">Manage your event guests and invitations.</p>
                
                <div class="bg-secondary rounded-lg p-4 mb-4">
                    <p class="text-sm text-gray-600">Select an event from "My Events" section to manage guests, or click the "Guests" button next to any event to manage its guest list.</p>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="bg-white rounded-lg border border-gray-200 p-4 text-center">
                        <i class="fas fa-user-plus text-3xl text-primary mb-2"></i>
                        <h3 class="font-semibold text-gray-800">Add Guests</h3>
                        <p class="text-sm text-gray-600 mt-1">Add individual guests to your events</p>
                    </div>
                    <div class="bg-white rounded-lg border border-gray-200 p-4 text-center">
                        <i class="fas fa-file-import text-3xl text-primary mb-2"></i>
                        <h3 class="font-semibold text-gray-800">Bulk Import</h3>
                        <p class="text-sm text-gray-600 mt-1">Upload guest lists via CSV files</p>
                    </div>
                    <div class="bg-white rounded-lg border border-gray-200 p-4 text-center">
                        <i class="fas fa-envelope text-3xl text-primary mb-2"></i>
                        <h3 class="font-semibold text-gray-800">Send Invitations</h3>
                        <p class="text-sm text-gray-600 mt-1">Send invitations to your guests</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Payment Modal -->
    <div id="paymentModal" class="fixed inset-0 bg-black bg-opacity-50 z-[9998] hidden flex items-center justify-center p-4">
        <div class="bg-white rounded-xl shadow-2xl max-w-md w-full mx-auto transform transition-all duration-300 scale-95 opacity-0" id="paymentModalContent">
            <div class="p-6">
                <div class="flex justify-between items-center pb-3 border-b border-gray-100">
                    <h3 class="text-xl font-semibold text-primary">Secure Payment</h3>
                    <button id="closeModal" onclick="closePaymentModal()" class="text-gray-400 hover:text-gray-600">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
                
                <div id="paymentDetails" class="my-4 space-y-3">
                    <!-- Payment summary will be inserted here -->
                </div>
                
                <div id="paymentMessageContainer" class="hidden my-4">
                    <!-- Payment messages will be displayed here -->
                </div>
                
                <form id="payment-form">
                    <div id="stripe-payment-element" class="my-6">
                        <!-- Stripe Payment Element will be mounted here -->
                    </div>
                    
                    <button id="submit-payment" type="submit" disabled
                        class="w-full bg-primary text-white py-3 rounded-lg hover:bg-primary/90 transition-colors font-semibold disabled:opacity-50 disabled:cursor-not-allowed shadow-lg">
                        <i class="fas fa-lock mr-2"></i> Pay Now
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Vendors Modal -->
    <div id="vendorsModal" class="fixed inset-0 bg-black bg-opacity-50 z-[9998] hidden flex items-center justify-center p-4">
        <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full mx-auto max-h-[90vh] overflow-hidden flex flex-col">
            <div class="p-6 border-b border-gray-200 flex-shrink-0">
                <div class="flex justify-between items-center">
                    <div>
                        <h3 class="text-xl font-semibold text-primary">Event Vendors</h3>
                        <p id="vendorsModalSubtitle" class="text-sm text-gray-600 mt-1">Vendors assigned to this event</p>
                    </div>
                    <button id="closeVendorsModal" class="text-gray-400 hover:text-gray-600">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
            </div>
            <div class="p-6 overflow-y-auto flex-1">
                <div id="vendorsList" class="space-y-4">
                    <!-- Vendors will be loaded here -->
                </div>
            </div>
            <div class="p-4 border-t border-gray-200 flex-shrink-0 flex justify-end">
                <button id="closeVendorsModalBtn" onclick="closeVendorsModal()" 
                        class="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors">
                    Close
                </button>
            </div>
        </div>
    </div>

    <!-- Footer Section -->
    <footer class="bg-gray-800 text-white py-4 mt-auto">
        <div class="max-w-7xl mx-auto px-4 text-center text-sm">
            &copy; 2025 EMS. All Rights Reserved.
        </div>
    </footer>

    <!-- Global Message Container -->
    <div id="global-message-container" class="fixed top-4 right-4 z-[9999] max-w-sm"></div>

    <script>
    // --- Configuration & Initialization ---
    const contextPath = '<%= request.getContextPath() %>';
    let stripe;
    let elements;
    let currentPaymentData = {};

    // Currency conversion
    const NPR_TO_USD_RATE = 0.0075;

    // Load Stripe on DOMContentLoaded
    document.addEventListener('DOMContentLoaded', () => {
        console.log('=== STRIPE LOADING DEBUG ===');
    console.log('1. Stripe script loaded:', typeof Stripe !== 'undefined');
        if (typeof Stripe !== 'undefined') {
            stripe = Stripe('pk_test_51SQeDo3XNejXnGwrwQTdtg8NDbq9Dzjp0WNYbELg2VlijbPSciCnA0Jr3F3Wf2uSaXg30u2IxmF9Q5sEq3WyOTUS00n5TaEUNp');
            console.log('Stripe initialized successfully');
            checkRedirectStatus();
        } else {
            console.error("Stripe.js failed to load. Check script tag.");
            loadStripeManually();
        }

        const paymentForm = document.getElementById('payment-form');
        if (paymentForm) {
            paymentForm.addEventListener('submit', handlePaymentSubmit);
        }

        initializeMobileMenu();
        initializeSectionNavigation();
        initializeModalAnimations();
    });
    // Add this function to manually load Stripe if needed
function loadStripeManually() {
    console.log('Attempting to load Stripe manually...');
    
    const script = document.createElement('script');
    script.src = 'https://js.stripe.com/v3/';
    script.onload = function() {
        console.log('✅ Stripe loaded manually successfully');
        stripe = Stripe('pk_test_51SQeDo3XNejXnGwrwQTdtg8NDbq9Dzjp0WNYbELg2VlijbPSciCnA0Jr3F3Wf2uSaXg30u2IxmF9Q5sEq3WyOTUS00n5TaEUNp');
        console.log('Stripe instance after manual load:', !!stripe);
    };
    script.onerror = function() {
        console.error('❌ Failed to load Stripe manually');
    };
    document.head.appendChild(script);
}

    // Mobile menu functions
    function initializeMobileMenu() {
        const mobileMenuButton = document.getElementById('mobile-menu-button');
        const closeMobileMenu = document.getElementById('close-mobile-menu');
        const mobileSidebar = document.getElementById('mobile-sidebar');
        const mobileSidebarOverlay = document.getElementById('mobile-sidebar-overlay');
        
        if (mobileMenuButton && closeMobileMenu && mobileSidebar && mobileSidebarOverlay) {
            mobileMenuButton.addEventListener('click', openMobileMenu);
            closeMobileMenu.addEventListener('click', closeMobileMenuHandler);
            mobileSidebarOverlay.addEventListener('click', closeMobileMenuHandler);
        }
    }

    function openMobileMenu() {
        const mobileSidebar = document.getElementById('mobile-sidebar');
        const mobileSidebarOverlay = document.getElementById('mobile-sidebar-overlay');
        
        if (mobileSidebar && mobileSidebarOverlay) {
            mobileSidebar.classList.remove('-translate-x-full');
            mobileSidebarOverlay.classList.remove('hidden');
            document.body.style.overflow = 'hidden';
        }
    }
    
    function closeMobileMenuHandler() {
        const mobileSidebar = document.getElementById('mobile-sidebar');
        const mobileSidebarOverlay = document.getElementById('mobile-sidebar-overlay');
        
        if (mobileSidebar && mobileSidebarOverlay) {
            mobileSidebar.classList.add('-translate-x-full');
            mobileSidebarOverlay.classList.add('hidden');
            document.body.style.overflow = 'auto';
        }
    }

    // Section navigation
    function initializeSectionNavigation() {
        const sidebarLinks = document.querySelectorAll('.sidebar-link, .mobile-sidebar-link');
        const sections = document.querySelectorAll('.dashboard-section');
        
        function showSection(hash) {
            sections.forEach(section => {
                if ('#' + section.id === hash) {
                    section.classList.remove('hidden');
                } else {
                    section.classList.add('hidden');
                }
            });
        }
        
        function updateActiveLink(hash) {
            sidebarLinks.forEach(link => {
                const isActive = link.getAttribute('href') === hash;
                link.classList.toggle('bg-opacity-10', isActive);
                link.classList.toggle('bg-white', isActive);
                link.classList.toggle('border-primary', isActive);
                link.classList.toggle('border-transparent', !isActive);
            });
        }
        
        function handleHashChange(hash) {
            showSection(hash);
            updateActiveLink(hash);
        }
        
        const initialHash = window.location.hash || '#overview';
        handleHashChange(initialHash);
        
        sidebarLinks.forEach(link => {
            link.addEventListener('click', e => {
                e.preventDefault();
                const targetHash = link.getAttribute('href');
                handleHashChange(targetHash);
                history.pushState(null, '', targetHash);
                
                if (window.innerWidth < 768) {
                    closeMobileMenuHandler();
                }
            });
        });
        
        window.addEventListener('popstate', () => {
            const currentHash = window.location.hash || '#overview';
            handleHashChange(currentHash);
        });
    }

    // Modal animations
    function initializeModalAnimations() {
        const paymentModal = document.getElementById('paymentModal');
        const paymentModalContent = document.getElementById('paymentModalContent');
        
        if (paymentModal && paymentModalContent) {
            const observer = new MutationObserver((mutations) => {
                mutations.forEach((mutation) => {
                    if (mutation.attributeName === 'class') {
                        if (!paymentModal.classList.contains('hidden')) {
                            setTimeout(() => {
                                paymentModalContent.classList.remove('scale-95', 'opacity-0');
                                paymentModalContent.classList.add('scale-100', 'opacity-100');
                            }, 50);
                        } else {
                            paymentModalContent.classList.remove('scale-100', 'opacity-100');
                            paymentModalContent.classList.add('scale-95', 'opacity-0');
                        }
                    }
                });
            });
            
            observer.observe(paymentModal, { attributes: true });
        }
    }

    // Check redirect status
    function checkRedirectStatus() {
        const urlParams = new URLSearchParams(window.location.search);
        const paymentIntent = urlParams.get('payment_intent');
        const paymentIntentClientSecret = urlParams.get('payment_intent_client_secret');

        if (paymentIntent && paymentIntentClientSecret) {
            handleRedirectReturn(paymentIntent, paymentIntentClientSecret);
        }
    }
    
    async function handleRedirectReturn(paymentIntentId, clientSecret) {
        showGlobalMessage('info', 'Processing your payment...');

        try {
            const { paymentIntent } = await stripe.retrievePaymentIntent(clientSecret);

            if (paymentIntent.status === 'succeeded') {
                await confirmPaymentWithBackend(paymentIntent.id);
                showGlobalMessage('success', 'Payment completed successfully! Redirecting to dashboard...');
                setTimeout(() => {
                    window.location.href = contextPath + '/client/dashboard';
                }, 2000);
            } else {
                showGlobalMessage('error', `Payment status: ${paymentIntent.status}. Please contact support if this persists.`);
            }
        } catch (error) {
            console.error('Error handling redirect return:', error);
            showGlobalMessage('error', 'Error processing payment return. Please check your payment status.');
        }
    }

    // Utility functions
    function showPaymentMessage(type, message) {
        const messageContainer = document.getElementById('paymentMessageContainer');
        let className = 'p-3 rounded-xl text-sm font-medium ';
        if (type === 'error') {
            className += 'bg-red-100 text-red-800 border border-red-300';
        } else if (type === 'success') {
            className += 'bg-green-100 text-green-800 border border-green-300';
        } else {
            className += 'bg-blue-100 text-blue-800 border border-blue-300';
        }
        messageContainer.className = className + ' mt-4';
        messageContainer.innerHTML = message;
        messageContainer.classList.remove('hidden');
    }

    function closePaymentModal() {
        const paymentModal = document.getElementById('paymentModal');
        if (!paymentModal) return;
        
        paymentModal.classList.add('hidden');
        document.body.style.overflow = 'auto';
        
        if (elements) {
            const paymentElementContainer = document.getElementById('stripe-payment-element');
            if (paymentElementContainer) {
                paymentElementContainer.innerHTML = '';
            }
        }
    }

    // Currency conversion
    function convertNPRtoUSD(nprAmount) {
        const usdAmount = parseFloat(nprAmount) * NPR_TO_USD_RATE;
        return Math.max(usdAmount, 0.50).toFixed(2);
    }

    function getPaymentTypeDisplay(paymentType) {
        switch(paymentType) {
            case 'advance': return 'Advance Payment (30%)';
            case 'balance': return 'Balance Payment';
            case 'full': return 'Full Payment';
            default: return paymentType;
        }
    }

    // Show payment modal
    function showPaymentModal(eventId, paymentType, nprAmount) {
          // Reset current payment data
    currentPaymentData = {};
        const amountInUSD = convertNPRtoUSD(nprAmount);
        
        currentPaymentData = {
            eventId: eventId,
            paymentType: paymentType,
            amount: amountInUSD,
            originalAmountNPR: nprAmount
        };
        
        const paymentDetails = document.getElementById('paymentDetails');
        const submitButton = document.getElementById('submit-payment');
        const messageContainer = document.getElementById('paymentMessageContainer');
        
        if (paymentDetails) {
            paymentDetails.innerHTML = 
                '<div class="bg-secondary/50 rounded-lg p-3 border border-gray-200">' +
                    '<h4 class="font-semibold text-primary mb-2">Payment Summary</h4>' +
                    '<p class="text-sm flex justify-between">' +
                        '<span class="font-medium">Event ID:</span>' +
                        '<span>' + eventId + '</span>' +
                    '</p>' +
                    '<p class="text-sm flex justify-between">' +
                        '<span class="font-medium">Payment Type:</span>' +
                        '<span>' + getPaymentTypeDisplay(paymentType) + '</span>' +
                    '</p>' +
                    '<p class="text-sm flex justify-between text-lg pt-2 border-t mt-2 border-gray-200">' +
                        '<span class="font-bold">Amount (NPR):</span>' +
                        '<span class="font-bold text-primary">NPR ' + parseFloat(nprAmount).toFixed(2) + '</span>' +
                    '</p>' +
                    '<p class="text-sm flex justify-between text-lg">' +
                        '<span class="font-bold">Amount (USD):</span>' +
                        '<span class="font-bold text-primary">$' + amountInUSD + '</span>' +
                    '</p>' +
                    '<p class="text-xs text-gray-500 mt-2">* Converted to USD for international payment processing</p>' +
                '</div>';
        }
        
        if (messageContainer) {
            messageContainer.classList.add('hidden');
        }
        
        if (submitButton) {
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Initializing Payment...';
        }

        const paymentModal = document.getElementById('paymentModal');
        paymentModal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';

    // Check Stripe availability before proceeding
    if (!stripe) {
        console.error('Stripe not available when creating payment intent');
        showPaymentMessage('error', 'Payment service is not ready. Please refresh the page and try again.');
        if (submitButton) {
            submitButton.disabled = false;
            submitButton.innerHTML = '<i class="fas fa-lock mr-2"></i> Try Again';
        }
        return;
    }

        createPaymentIntent(eventId, paymentType, amountInUSD)
            .then(clientSecret => {
                if (clientSecret) {
                    initializeStripeElements(clientSecret);
                } else {
                    showPaymentMessage('error', 'Could not initialize payment. Missing client secret.');
                    if (submitButton) {
                        submitButton.disabled = false;
                        submitButton.innerHTML = '<i class="fas fa-lock mr-2"></i> Pay Now';
                    }
                }
            })
            .catch(err => {
                console.error('Error creating payment intent:', err);
                showPaymentMessage('error', 'Payment service error: ' + err.message);
                if (submitButton) {
                    submitButton.disabled = false;
                    submitButton.innerHTML = '<i class="fas fa-lock mr-2"></i> Pay Now';
                }
            });
    }
    // Add this diagnostic function
async function diagnosePaymentIssue() {
    console.log('=== PAYMENT DIAGNOSIS ===');
    
    // Check Stripe
    console.log('1. Stripe loaded:', typeof Stripe !== 'undefined');
    console.log('2. Stripe instance:', !!stripe);
    
    // Check network connectivity
    try {
        const networkTest = await fetch('https://js.stripe.com/v3/', { method: 'HEAD' });
        console.log('3. Stripe CDN accessible:', networkTest.ok);
    } catch (e) {
        console.log('3. Stripe CDN accessible: false -', e.message);
    }
    
    // Check backend connectivity
    try {
        const backendTest = await fetch(contextPath + '/client/stripe-payment', { method: 'HEAD' });
        console.log('4. Backend accessible:', backendTest.ok);
    } catch (e) {
        console.log('4. Backend accessible: false -', e.message);
    }
    
    // Check if Stripe Elements can be created
    if (stripe) {
        try {
            // Test with a minimal client secret format
            const testElements = stripe.elements({ 
                clientSecret: 'pi_test_123_secret_123',
                appearance: { theme: 'stripe' }
            });
            console.log('5. Stripe Elements test:', !!testElements);
        } catch (e) {
            console.log('5. Stripe Elements test: false -', e.message);
        }
    }
    
    console.log('6. Current payment data:', currentPaymentData);
    console.log('7. Context path:', contextPath);
}

// Run this in browser console: diagnosePaymentIssue()

    // Create payment intent
    async function createPaymentIntent(eventId, paymentType, amountInUSD) {
        let attempts = 0;
        const maxRetries = 3;
        const initialDelay = 1000;
         // Check Stripe availability first
    if (!stripe) {
        throw new Error('Stripe payment service is not available. Please refresh the page and try again.');
    }
        
        while (attempts < maxRetries) {
            try {
                console.log('Creating payment intent with USD amount:', amountInUSD);

                const formData = new URLSearchParams();
                formData.append('action', 'createIntent');
                formData.append('eventId', eventId);
                formData.append('paymentType', paymentType);
                formData.append('amount', amountInUSD);
                formData.append('currency', 'usd');
                
                const response = await fetch(contextPath + '/client/stripe-payment', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const data = await response.json();
                
                console.log('Payment intent response:', data);
                
                if (!data.success) {
                    throw new Error(data.error || 'Failed to create payment intent');
                }
                
                if (data.clientSecret) {
                    currentPaymentData.paymentId = data.paymentId;
                    currentPaymentData.paymentIntentId = data.paymentIntentId;
                    currentPaymentData.bookingId = data.bookingId;
                    currentPaymentData.clientSecret = data.clientSecret;
                    
                    console.log('Payment intent created successfully:', {
                        paymentId: data.paymentId,
                        paymentIntentId: data.paymentIntentId
                    });
                    
                    return data.clientSecret;
                } else {
                    throw new Error('No client secret received from server');
                }
                
            } catch (error) {
                console.error(`Attempt ${attempts + 1} failed:`, error.message);
                attempts++;
                if (attempts < maxRetries) {
                    await new Promise(resolve => setTimeout(resolve, initialDelay * Math.pow(2, attempts - 1)));
                } else {
                    throw new Error(`Payment initialization failed: ${error.message}`);
                }
            }
        }
    }

    // Initialize Stripe Elements
    function initializeStripeElements(clientSecret) {
        if (!stripe) {
            showPaymentMessage('error', 'Payment service is not available. Please refresh the page.');
            return;
        }
        
        console.log('Initializing Stripe Elements with client secret');
        
        const appearance = {
            theme: 'stripe',
            variables: {
                colorPrimary: '#4a6baf',
                colorBackground: '#ffffff',
                colorText: '#1e293b',
                colorDanger: '#ef4444',
                fontFamily: 'Poppins, system-ui, sans-serif',
                spacingUnit: '4px',
                borderRadius: '8px'
            }
        };
        
        elements = stripe.elements({ 
            clientSecret,
            appearance,
            loader: 'auto'
        });
        
        const paymentElement = elements.create('payment', {
            layout: {
                type: 'tabs',
                defaultCollapsed: false
            },
            fields: {
                billingDetails: {
                    name: 'auto',
                    email: 'auto',
                    phone: 'auto'
                }
            }
        });
        
        paymentElement.mount('#stripe-payment-element');
        
        paymentElement.on('ready', () => {
            console.log('Payment Element is ready');
            const submitButton = document.getElementById('submit-payment');
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.innerHTML = '<i class="fas fa-lock mr-2"></i> Pay Now';
            }
        });
        
        paymentElement.on('change', (event) => {
            const submitButton = document.getElementById('submit-payment');
            if (submitButton) {
                submitButton.disabled = event.empty || !event.complete;
            }
        });
        
        paymentElement.on('loaderror', (event) => {
            console.error('Payment Element load error:', event.error);
            showPaymentMessage('error', 'Failed to load payment form. Please refresh the page.');
        });
    }
    
    // Handle payment submission
    async function handlePaymentSubmit(e) {
        e.preventDefault();
        
        console.log('=== PAYMENT SUBMISSION STARTED ===');
        
        const submitButton = document.getElementById('submit-payment');
        const messageContainer = document.getElementById('paymentMessageContainer');
        
        if (submitButton) {
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Processing...';
        }
        
        if (messageContainer) {
            messageContainer.classList.add('hidden');
        }
        
        if (!currentPaymentData.clientSecret) {
            console.error('No client secret available');
            showPaymentMessage('error', 'Payment session expired. Please try again.');
            return;
        }
        
        try {
            console.log('Confirming payment with Stripe...');
            
            const { error, paymentIntent } = await stripe.confirmPayment({
                elements,
                confirmParams: {
                    return_url: `${window.location.origin}${contextPath}/client/dashboard`,
                },
                redirect: 'if_required'
            });
            
            console.log('Stripe confirmation result:', { error, paymentIntent });
            
            if (error) {
                handlePaymentError(error);
            } else if (paymentIntent) {
                switch (paymentIntent.status) {
                    case 'succeeded':
                        await handlePaymentSuccess(paymentIntent);
                        break;
                    case 'processing':
                        await handlePendingPayment(paymentIntent);
                        break;
                    case 'requires_action':
                        showPaymentMessage('info', 'Additional authentication required. Please follow the instructions.');
                        break;
                    default:
                        await handlePendingPayment(paymentIntent);
                }
            } else {
                throw new Error('No payment intent returned from Stripe');
            }
            
        } catch (error) {
            console.error('Payment processing error:', error);
            handlePaymentError({ 
                type: 'api_error', 
                message: 'An unexpected error occurred: ' + error.message 
            });
        }
    }

    // Handle payment errors
    function handlePaymentError(error) {
        console.error('Payment error details:', error);
        
        let userFriendlyMessage = 'Payment failed. Please try again.';
        
        if (error && error.message) {
            switch (error.type) {
                case 'card_error':
                    userFriendlyMessage = `Card error: ${error.message}`;
                    break;
                case 'validation_error':
                    userFriendlyMessage = `Invalid payment details: ${error.message}`;
                    break;
                case 'invalid_request_error':
                    userFriendlyMessage = 'Invalid payment request. Please check your details and try again.';
                    break;
                case 'api_error':
                    userFriendlyMessage = 'Payment service temporarily unavailable. Please try again in a few moments.';
                    break;
                default:
                    userFriendlyMessage = error.message;
            }
        }
        
        showPaymentMessage('error', userFriendlyMessage);
        
        const submitButton = document.getElementById('submit-payment');
        if (submitButton) {
            submitButton.disabled = false;
            submitButton.innerHTML = '<i class="fas fa-lock mr-2"></i> Pay Now';
        }
    }

    // Handle successful payment
    async function handlePaymentSuccess(paymentIntent) {
        try {
            console.log('Payment succeeded, confirming with backend...');
            
            const result = await confirmPaymentWithBackend(paymentIntent.id);
            console.log('Backend confirmation result:', result);
            
            if (result && result.success) {
                showPaymentSuccess();
            } else {
                throw new Error('Backend confirmation failed');
            }
        } catch (error) {
            console.error('Error confirming payment with backend:', error);
            showPaymentMessage('error', 'Payment processed but we encountered an issue updating your records. Please contact support.');
            
            const submitButton = document.getElementById('submit-payment');
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.innerHTML = '<i class="fas fa-lock mr-2"></i> Try Again';
            }
        }
    }

    // Handle pending payment
    async function handlePendingPayment(paymentIntent) {
        let status = 'Unknown';
        if (paymentIntent && paymentIntent.status) {
            status = paymentIntent.status;
        }
        
        if (status === 'processing') {
            showPaymentMessage('info', 'Payment is processing. We will notify you when complete.');
            await checkPaymentStatusPeriodically();
        } else {
            showPaymentMessage('info', 'Payment status: ' + status + '. Please wait for confirmation.');
            
            const submitButton = document.getElementById('submit-payment');
            if (submitButton) {
                submitButton.disabled = false;
                submitButton.innerHTML = '<i class="fas fa-lock mr-2"></i> Pay Now';
            }
        }
    }

    // Confirm payment with backend
    async function confirmPaymentWithBackend(paymentIntentId) {
        let attempts = 0;
        const maxRetries = 3;
        const initialDelay = 1000;

        while (attempts < maxRetries) {
            try {
                const intentId = paymentIntentId || currentPaymentData.paymentIntentId;
                if (!intentId) throw new Error("Missing Payment Intent ID for confirmation.");

                const formData = new URLSearchParams();
                formData.append('action', 'confirmPayment');
                formData.append('paymentIntentId', intentId);
                formData.append('paymentId', currentPaymentData.paymentId);
                
                const response = await fetch(contextPath + '/client/stripe-payment', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: formData
                });
                
                const data = await response.json();
                
                if (!response.ok || !data.success) {
                    throw new Error(data.error || 'Failed to confirm payment with server');
                }
                
                return data;
                
            } catch (error) {
                console.error(`Confirmation attempt ${attempts + 1} failed:`, error.message);
                attempts++;
                if (attempts < maxRetries) {
                    await new Promise(resolve => setTimeout(resolve, initialDelay * Math.pow(2, attempts - 1)));
                } else {
                    throw error;
                }
            }
        }
    }

    // Check payment status periodically
    async function checkPaymentStatusPeriodically() {
        let attempts = 0;
        const maxAttempts = 10;
        
        const checkStatus = async () => {
            if (attempts >= maxAttempts) {
                showPaymentMessage('warning', 'Payment is taking longer than expected. Please check your dashboard for updates.');
                return;
            }
            
            attempts++;
            
            try {
                const status = await checkPaymentStatus();
                
                if (status === 'Completed') {
                    showPaymentSuccess();
                } else if (status === 'Failed') {
                    handlePaymentError({ message: 'The payment failed during processing.' });
                } else {
                    setTimeout(checkStatus, 2000);
                }
            } catch (error) {
                console.error('Error checking payment status:', error);
                setTimeout(checkStatus, 2000);
            }
        };
        
        await checkStatus();
    }

    // Check payment status with backend
    async function checkPaymentStatus() {
        const formData = new URLSearchParams();
        formData.append('action', 'getPaymentStatus');
        formData.append('paymentId', currentPaymentData.paymentId);
        
        const response = await fetch(contextPath + '/client/stripe-payment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        });
        
        const data = await response.json();
        
        if (data.success) {
            return data.status;
        } else {
            throw new Error(data.error || 'Failed to check payment status');
        }
    }

    // Show payment success message
    function showPaymentSuccess() {
        const paymentModal = document.getElementById('paymentModal');
        if (!paymentModal) return;

        const modalContent = paymentModal.querySelector('.bg-white');
        if (!modalContent) return;

        modalContent.innerHTML = 
            '<div class="p-6 text-center">' +
                '<div class="text-green-500 text-6xl mb-4 animate-bounce">' +
                    '<i class="fas fa-check-circle"></i>' +
                '</div>' +
                '<h3 class="text-2xl font-bold text-gray-800 mb-2">Payment Successful!</h3>' +
                '<p class="text-gray-600 mb-4">' +
                    'Thank you for your payment. Your booking has been confirmed.' +
                '</p>' +
                '<div class="bg-green-50 border border-green-200 rounded-lg p-4 mb-6 text-left">' +
                    '<p class="text-sm text-green-800">' +
                        '<strong>Payment ID:</strong> ' + currentPaymentData.paymentId + '<br>' +
                        '<strong>Amount:</strong> NPR ' + currentPaymentData.originalAmountNPR + '<br>' +
                        '<strong>Type:</strong> ' + getPaymentTypeDisplay(currentPaymentData.paymentType) +
                    '</p>' +
                '</div>' +
                '<button onclick="closePaymentModalAndRefresh()" ' +
                        'class="w-full bg-primary text-white py-3 rounded-lg hover:bg-primary/90 transition-colors font-semibold shadow-lg">' +
                    'Continue to Dashboard' +
                '</button>' +
            '</div>';
    }

    // Global message function
    function showGlobalMessage(type, message) {
        let messageContainer = document.getElementById('global-message-container');
        if (!messageContainer) {
            messageContainer = document.createElement('div');
            messageContainer.id = 'global-message-container';
            messageContainer.className = 'fixed top-4 right-4 z-[9999] max-w-sm';
            document.body.appendChild(messageContainer);
        }
        
        const messageId = 'msg-' + Date.now();
        
        let messageClass = 'p-4 rounded-xl shadow-lg border mb-2 transition-opacity duration-300 transform ';
        if (type === 'error') {
            messageClass += 'bg-red-50 border-red-200 text-red-800';
        } else if (type === 'success') {
            messageClass += 'bg-green-50 border-green-200 text-green-800';
        } else {
            messageClass += 'bg-blue-50 border-blue-200 text-blue-800';
        }
        
        let iconClass = 'fas ';
        if (type === 'error') {
            iconClass += 'fa-exclamation-triangle';
        } else if (type === 'success') {
            iconClass += 'fa-check-circle';
        } else {
            iconClass += 'fa-info-circle';
        }
        
        const messageHtml = 
            '<div id="' + messageId + '" class="' + messageClass + '">' +
                '<div class="flex items-center justify-between">' +
                    '<div class="flex items-center">' +
                        '<i class="' + iconClass + ' mr-3"></i>' +
                        '<span class="font-medium">' + message + '</span>' +
                    '</div>' +
                    '<button onclick="document.getElementById(\'' + messageId + '\').remove()" class="ml-4 text-gray-500 hover:text-gray-700">' +
                        '<i class="fas fa-times"></i>' +
                    '</button>' +
                '</div>' +
            '</div>';
        
        messageContainer.insertAdjacentHTML('afterbegin', messageHtml);
        
        if (type === 'success') {
            setTimeout(() => {
                const msgElement = document.getElementById(messageId);
                if (msgElement) {
                    msgElement.classList.add('opacity-0');
                    setTimeout(() => msgElement.remove(), 300);
                }
            }, 5000);
        }
    }

    // Close payment modal and refresh
    function closePaymentModalAndRefresh() {
        closePaymentModal();
        setTimeout(() => {
            window.location.reload();
        }, 1000);
    }

    // Vendor modal functions
    async function showVendorsModal(eventId) {
        const modal = document.getElementById('vendorsModal');
        const vendorsList = document.getElementById('vendorsList');
        const subtitle = document.getElementById('vendorsModalSubtitle');
        
        if (!modal || !vendorsList) return;
        
        vendorsList.innerHTML = `
            <div class="flex justify-center items-center py-8">
                <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
                <span class="ml-3 text-gray-600">Loading vendors...</span>
            </div>
        `;
        
        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        
        try {
            const response = await fetch(`${contextPath}/client/event-vendors?eventId=${eventId}`);
            const vendors = await response.json();
            
            if (vendors && vendors.length > 0) {
                subtitle.textContent = `${vendors.length} vendor(s) assigned to this event`;
                
                vendorsList.innerHTML = vendors.map(vendor => {
                    const companyName = vendor.companyName || 'Vendor';
                    const serviceType = vendor.serviceType || 'Service Provider';
                    const status = vendor.status || 'Pending';
                    const statusClass = 'vendor-status-' + (status || 'pending').toLowerCase();
                    const contactPerson = vendor.contactPerson || 'Not specified';
                    const phone = vendor.phone || 'Not specified';
                    const email = vendor.email || 'Not specified';
                    const notes = vendor.notes || '';
                    
                    let notesHtml = '';
                    if (notes) {
                        notesHtml = '<div class="mt-3 p-3 bg-blue-50 rounded-lg border border-blue-200">' +
                                   '<p class="text-sm text-blue-800"><strong>Notes:</strong> ' + notes + '</p>' +
                                   '</div>';
                    }
                    
                    return '<div class="bg-white border border-gray-200 rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow">' +
                           '<div class="flex justify-between items-start mb-3">' +
                           '<div>' +
                           '<h4 class="font-semibold text-gray-800 text-lg">' + companyName + '</h4>' +
                           '<p class="text-gray-600 text-sm">' + serviceType + '</p>' +
                           '</div>' +
                           '<span class="' + statusClass + ' status-badge text-xs">' + status + '</span>' +
                           '</div>' +
                           '<div class="grid grid-cols-1 md:grid-cols-2 gap-2 text-sm">' +
                           '<div class="flex items-center text-gray-600">' +
                           '<i class="fas fa-user mr-2 text-primary"></i>' +
                           '<span>' + contactPerson + '</span>' +
                           '</div>' +
                           '<div class="flex items-center text-gray-600">' +
                           '<i class="fas fa-phone mr-2 text-primary"></i>' +
                           '<span>' + phone + '</span>' +
                           '</div>' +
                           '<div class="flex items-center text-gray-600 md:col-span-2">' +
                           '<i class="fas fa-envelope mr-2 text-primary"></i>' +
                           '<span>' + email + '</span>' +
                           '</div>' +
                           '</div>' +
                           notesHtml +
                           '</div>';
                }).join('');
            } else {
                vendorsList.innerHTML = `
                    <div class="text-center py-8">
                        <i class="fas fa-users text-4xl text-gray-300 mb-3"></i>
                        <p class="text-gray-500">No vendors assigned to this event yet.</p>
                    </div>
                `;
            }
            
        } catch (error) {
            console.error('Error loading vendors:', error);
            vendorsList.innerHTML = `
                <div class="text-center py-8">
                    <i class="fas fa-exclamation-triangle text-4xl text-red-300 mb-3"></i>
                    <p class="text-red-500">Error loading vendors. Please try again.</p>
                </div>
            `;
        }
    }

    // Close vendors modal
    function closeVendorsModal() {
        const modal = document.getElementById('vendorsModal');
        if (modal) {
            modal.classList.add('hidden');
            document.body.style.overflow = 'auto';
        }
    }

    // Show event details
    function showEventDetails(eventId) {
        alert('Event ID: ' + eventId + '\nImplement detailed view modal here.');
    }

    // Add event listeners for vendors modal
    document.addEventListener('DOMContentLoaded', () => {
        const closeVendorsModalBtn = document.getElementById('closeVendorsModal');
        const closeVendorsModalBtn2 = document.getElementById('closeVendorsModalBtn');
        const vendorsModal = document.getElementById('vendorsModal');
        
        if (closeVendorsModalBtn) {
            closeVendorsModalBtn.addEventListener('click', closeVendorsModal);
        }
        
        if (closeVendorsModalBtn2) {
            closeVendorsModalBtn2.addEventListener('click', closeVendorsModal);
        }
        
        if (vendorsModal) {
            vendorsModal.addEventListener('click', (e) => {
                if (e.target === vendorsModal) {
                    closeVendorsModal();
                }
            });
        }
    });
</script>
</body>
</html>