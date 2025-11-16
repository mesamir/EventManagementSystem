<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Guests - EMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary: #4a6baf;
            --primary-hover: #3a5699;
            --secondary: #e9edf5;
            --success: #10b981;
            --success-hover: #059669;
            --danger: #ef4444;
            --danger-hover: #dc2626;
            --warning: #f59e0b;
            --warning-hover: #d97706;
            --info: #3b82f6;
            --info-hover: #2563eb;
            --sidebar: #1e293b;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }

        .guest-management-container {
            flex-grow: 1;
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }

        /* Status badges */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            line-height: 1;
        }

        .status-badge.pending {
            background-color: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            border: 1px solid rgba(59, 130, 246, 0.2);
        }

        .status-badge.confirmed {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .status-badge.declined {
            background-color: rgba(239, 68, 68, 0.1);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Button styles */
        .btn {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
        }

        .btn-success {
            background-color: var(--success);
            color: white;
        }

        .btn-success:hover {
            background-color: var(--success-hover);
            transform: translateY(-1px);
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: var(--danger-hover);
            transform: translateY(-1px);
        }

        .btn-info {
            background-color: var(--info);
            color: white;
        }

        .btn-info:hover {
            background-color: var(--info-hover);
            transform: translateY(-1px);
        }

        .btn-sm {
            padding: 0.3rem 0.6rem;
            font-size: 0.8rem;
            border-radius: 0.3rem;
        }

        /* Card styles */
        .dashboard-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--info));
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
        }

        /* Form styles */
        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #374151;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.875rem;
            transition: border-color 0.2s ease;
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(74, 107, 175, 0.1);
        }

        /* Table styles */
        .table-responsive {
            overflow-x: auto;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background-color: #f8fafc;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        th, td {
            padding: 0.75rem 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        tbody tr {
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background-color: #f8fafc;
        }

        /* Grid layouts */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        /* Alert styles */
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            border-left: 4px solid;
        }

        .alert-success {
            background-color: #f0fdf4;
            border-color: #10b981;
            color: #065f46;
        }

        .alert-error {
            background-color: #fef2f2;
            border-color: #ef4444;
            color: #7f1d1d;
        }

        /* Message box styles */
        .message-box {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
            border: 1px solid;
            position: relative;
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

        .close-message {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            font-size: 1.2em;
            cursor: pointer;
            color: inherit;
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 30px;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
            position: relative;
            box-shadow: 0 5px 20px rgba(0,0,0,0.3);
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            position: absolute;
            right: 15px;
            top: 15px;
        }

        .close:hover {
            color: #000;
        }

        /* Checkbox styles */
        input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        input[type="checkbox"]:checked {
            background-color: var(--primary);
            border-color: var(--primary);
        }

        /* Selected row highlighting */
        .selected-row {
            background-color: #f0f9ff !important;
            border-left: 3px solid var(--primary);
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .guest-management-container {
                padding: 15px;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 1rem;
            }

            .table-responsive {
                font-size: 0.875rem;
            }

            th, td {
                padding: 0.5rem 0.75rem;
            }
        }

        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Header Section -->
    <header class="bg-white shadow-lg sticky top-0 z-50">
        <nav class="flex justify-between items-center px-4 py-3 md:px-6 md:py-3 max-w-7xl mx-auto w-full">
            <div class="flex items-center">
                <div class="text-xl md:text-2xl font-bold text-primary">EMS</div>
            </div>
            <div class="hidden md:flex items-center space-x-4">
                <a href="<%= request.getContextPath() %>/client/dashboard" class="text-gray-700 hover:text-primary font-medium transition-colors text-sm">Customer Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 hover:text-primary font-medium transition-colors text-sm">Logout</a>
            </div>
        </nav>
    </header>

    <div class="guest-management-container">
        <!-- Main Content Card -->
        <div class="dashboard-section">
            <h2 class="text-xl font-bold text-gray-800 mb-3 pb-2 border-b-2 border-primary inline-block">
                Guest Management for Event: <span class="text-primary"><c:out value="${event.type}" /></span> (ID: <c:out value="${event.eventId}" />)
            </h2>
            <p class="text-gray-600 mb-6">Event Date: <c:out value="${event.date}" /></p>

            <!-- Guest Statistics -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mr-4">
                            <i class="fas fa-users text-blue-600 text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800"><c:out value="${totalGuests}" /></h3>
                            <p class="text-gray-600 text-sm">Total Guests</p>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-yellow-100 rounded-full flex items-center justify-center mr-4">
                            <i class="fas fa-clock text-yellow-600 text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800"><c:out value="${pendingGuests}" /></h3>
                            <p class="text-gray-600 text-sm">Pending RSVP</p>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mr-4">
                            <i class="fas fa-check-circle text-green-600 text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800"><c:out value="${confirmedGuests}" /></h3>
                            <p class="text-gray-600 text-sm">Confirmed</p>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="flex items-center">
                        <div class="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center mr-4">
                            <i class="fas fa-times-circle text-red-600 text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gray-800"><c:out value="${declinedGuests}" /></h3>
                            <p class="text-gray-600 text-sm">Declined</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Display server-side messages -->
            <c:if test="${not empty messageText}">
                <div class="alert ${messageType eq 'success' ? 'alert-success' : 'alert-error'}">
                    <div class="flex items-center">
                        <i class="fas ${messageType eq 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'} mr-3"></i>
                        <span><c:out value="${messageText}" /></span>
                    </div>
                </div>
            </c:if>

            <!-- Add Guest Form -->
            <div class="dashboard-section mb-6">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Add New Guest</h3>
                <form action="<%= request.getContextPath() %>/client/guests" method="POST" onsubmit="return validateGuestForm()" class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <input type="hidden" name="action" value="addGuest">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    
                    <div class="form-group">
                        <label for="name">Guest Name: *</label>
                        <input type="text" id="name" name="name" required class="w-full">
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email (Optional):</label>
                        <input type="email" id="email" name="email" class="w-full">
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Phone (Optional):</label>
                        <input type="tel" id="phone" name="phone" class="w-full">
                    </div>
                    
                    <div class="md:col-span-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-user-plus mr-2"></i> Add Guest
                        </button>
                    </div>
                </form>
            </div>

            <!-- Guest List -->
            <div class="dashboard-section">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-lg font-bold text-gray-800">Guest List (<c:out value="${fn:length(guests)}" /> Total)</h3>
                </div>

                <!-- Main Guest Actions Form -->
                <form id="guestActionsForm" action="<%= request.getContextPath() %>/client/guests" method="POST">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <input type="hidden" name="action" value="sendInvitations">
                    
                    <!-- Action buttons -->
                    <div class="flex justify-end gap-2 mb-4">
                        <button type="submit" class="btn btn-success" id="sendInvitationsBtn">
                            <i class="fas fa-envelope mr-2"></i> Send Invitations (<span id="selectedCount">0</span> Selected)
                        </button>
                        <button type="button" class="btn btn-info" onclick="showImportModal()">
                            <i class="fas fa-file-import mr-2"></i> Import Guests
                        </button>
                    </div>

                    <div class="table-responsive">
                        <table class="min-w-full">
                            <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" id="selectAllGuests" aria-label="Select all guests">
                                    </th>
                                    <th>Guest ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>RSVP Status</th>
                                    <th>Invited On</th>
                                    <th>Responded On</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty guests}">
                                        <c:forEach var="guest" items="${guests}">
                                            <tr id="guest-row-${guest.guestId}">
                                                <td>
                                                    <input type="checkbox" name="selectedGuests" value="${guest.guestId}" 
                                                           aria-label="Select guest ${guest.name}" class="guest-checkbox">
                                                </td>
                                                <td><c:out value="${guest.guestId}" /></td>
                                                <td><c:out value="${guest.name}" /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty guest.email}">
                                                            <a href="mailto:${guest.email}" class="text-primary hover:underline">
                                                                <c:out value="${guest.email}" />
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>Not provided</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty guest.phone}">
                                                            <c:out value="${guest.phone}" />
                                                        </c:when>
                                                        <c:otherwise>Not provided</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <form action="<%= request.getContextPath() %>/client/guests" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="updateRsvp">
                                                        <input type="hidden" name="eventId" value="${event.eventId}">
                                                        <input type="hidden" name="guestId" value="${guest.guestId}">
                                                        <select name="rsvpStatus" onchange="this.form.submit()" 
                                                                class="text-sm border rounded px-2 py-1"
                                                                aria-label="Update RSVP status for ${guest.name}">
                                                            <option value="Pending" <c:if test="${guest.rsvpStatus eq 'Pending'}">selected</c:if>>Pending</option>
                                                            <option value="Confirmed" <c:if test="${guest.rsvpStatus eq 'Confirmed'}">selected</c:if>>Confirmed</option>
                                                            <option value="Declined" <c:if test="${guest.rsvpStatus eq 'Declined'}">selected</c:if>>Declined</option>
                                                        </select>
                                                    </form>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty guest.invitationSentDate}">
                                                            <c:out value="${guest.invitationSentDate}" />
                                                        </c:when>
                                                        <c:otherwise>Not sent</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty guest.rsvpResponseDate}">
                                                            <c:out value="${guest.rsvpResponseDate}" />
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="flex gap-1">
                                                        <button type="button" class="btn btn-info btn-sm"
                                                                onclick="editGuest(${guest.guestId}, '${guest.name}', '${guest.email}', '${guest.phone}')">
                                                            <i class="fas fa-edit"></i> Edit
                                                        </button>
                                                        <form action="<%= request.getContextPath() %>/client/guests" method="POST" 
                                                              style="display:inline;" 
                                                              onsubmit="return confirm('Are you sure you want to delete guest ${guest.name}?');">
                                                            <input type="hidden" name="action" value="deleteGuest">
                                                            <input type="hidden" name="eventId" value="${event.eventId}">
                                                            <input type="hidden" name="guestId" value="${guest.guestId}">
                                                            <button type="submit" class="btn btn-danger btn-sm">
                                                                <i class="fas fa-trash-alt"></i> Delete
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="9" class="text-center py-8 text-gray-500">
                                                <i class="fas fa-users fa-3x mb-4 text-gray-300"></i>
                                                <p class="text-lg">No guests added for this event yet.</p>
                                                <p class="text-sm">Add your first guest using the form above.</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </form>
            </div>

            <!-- Back Button -->
            <div class="mt-6">
                <a href="<%= request.getContextPath() %>/client/dashboard" class="btn bg-gray-600 text-white hover:bg-gray-700">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                </a>
            </div>
        </div>
    </div>

    <!-- Footer Section -->
    <footer class="bg-sidebar text-white py-4 mt-auto">
        <div class="max-w-7xl mx-auto px-4 text-center text-sm">
            &copy; 2025 EMS. All Rights Reserved.
        </div>
    </footer>

    <!-- Edit Guest Modal -->
    <div id="editGuestModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h3 class="text-lg font-bold text-gray-800 mb-4">Edit Guest</h3>
            <form id="editGuestForm" action="<%= request.getContextPath() %>/client/guests" method="POST">
                <input type="hidden" name="action" value="updateGuest">
                <input type="hidden" name="eventId" value="${event.eventId}">
                <input type="hidden" id="editGuestId" name="guestId">
                
                <div class="form-group">
                    <label for="editName">Guest Name: *</label>
                    <input type="text" id="editName" name="name" required class="w-full">
                </div>
                
                <div class="form-group">
                    <label for="editEmail">Email:</label>
                    <input type="email" id="editEmail" name="email" class="w-full">
                </div>
                
                <div class="form-group">
                    <label for="editPhone">Phone:</label>
                    <input type="tel" id="editPhone" name="phone" class="w-full">
                </div>
                
                <div class="flex justify-end gap-2 mt-4">
                    <button type="button" class="btn bg-gray-500 text-white hover:bg-gray-600" onclick="closeEditModal()">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-2"></i> Update Guest
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Select All Guests Checkbox functionality
            const selectAllGuestsCheckbox = document.getElementById('selectAllGuests');
            if (selectAllGuestsCheckbox) {
                selectAllGuestsCheckbox.addEventListener('change', function() {
                    const checkboxes = document.querySelectorAll('input[name="selectedGuests"]');
                    checkboxes.forEach(checkbox => {
                        checkbox.checked = this.checked;
                        updateRowHighlighting(checkbox);
                    });
                    updateSelectedCount();
                });
            }

            // Update selected count
            updateSelectedCount();

            // Add change listeners to all guest checkboxes
            document.querySelectorAll('input[name="selectedGuests"]').forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    updateSelectedCount();
                    updateRowHighlighting(this);
                });
            });

            // Form submission validation
            document.getElementById('guestActionsForm').addEventListener('submit', function(e) {
                const selectedGuests = document.querySelectorAll('input[name="selectedGuests"]:checked');

                if (selectedGuests.length === 0) {
                    e.preventDefault();
                    showMessage('Please select at least one guest to send invitations.', 'error');
                    return false;
                }

                // Show confirmation
                const confirmed = confirm(`Are you sure you want to send invitations to ${selectedGuests.length} guest(s)?`);
                if (!confirmed) {
                    e.preventDefault();
                    return false;
                }

                return true;
            });
        });

        function updateSelectedCount() {
            const selectedCount = document.querySelectorAll('input[name="selectedGuests"]:checked').length;
            const sendBtn = document.getElementById('sendInvitationsBtn');
            const selectedCountSpan = document.getElementById('selectedCount');
            
            if (selectedCountSpan) {
                selectedCountSpan.textContent = selectedCount;
            }
            
            if (sendBtn) {
                sendBtn.disabled = selectedCount === 0;
                if (selectedCount === 0) {
                    sendBtn.title = 'Please select at least one guest to send invitations';
                } else {
                    sendBtn.title = `Send invitations to ${selectedCount} selected guest(s)`;
                }
            }
        }

        function updateRowHighlighting(checkbox) {
            const row = checkbox.closest('tr');
            if (checkbox.checked) {
                row.classList.add('selected-row');
            } else {
                row.classList.remove('selected-row');
            }
        }

        function validateGuestForm() {
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            
            if (name.length === 0) {
                showMessage('Guest name is required', 'error');
                return false;
            }
            
            if (email && !isValidEmail(email)) {
                showMessage('Please enter a valid email address', 'error');
                return false;
            }
            
            return true;
        }

        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function showMessage(message, type) {
            // Remove existing messages
            const existingMessages = document.querySelectorAll('.message-box');
            existingMessages.forEach(msg => msg.remove());

            const messageDiv = document.createElement('div');
            messageDiv.className = `message-box ${type}`;
            messageDiv.innerHTML = `
                ${message}
                <button class="close-message" onclick="this.parentElement.remove()">×</button>
            `;
            
            const container = document.querySelector('.guest-management-container');
            const guestStats = document.querySelector('.guest-statistics');
            container.insertBefore(messageDiv, guestStats.nextElementSibling);
            
            // Auto-remove after 5 seconds
            setTimeout(() => {
                if (messageDiv.parentElement) {
                    messageDiv.remove();
                }
            }, 5000);
        }

        function editGuest(guestId, name, email, phone) {
            document.getElementById('editGuestId').value = guestId;
            document.getElementById('editName').value = name || '';
            document.getElementById('editEmail').value = email || '';
            document.getElementById('editPhone').value = phone || '';
            document.getElementById('editGuestModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editGuestModal').style.display = 'none';
        }

        function showImportModal() {
            showMessage('Import Guest functionality coming soon!', 'error');
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('editGuestModal');
            if (event.target === modal) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>