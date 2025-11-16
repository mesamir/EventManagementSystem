<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event - EMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
        .form-input { width: 100%; padding: 0.75rem; border: 1px solid #d1d5db; border-radius: 6px; }
        .form-input:focus { outline: none; border-color: #4a6baf; box-shadow: 0 0 0 3px rgba(74, 107, 175, 0.1); }
        .btn { display: inline-flex; align-items: center; padding: 0.5rem 1rem; border-radius: 6px; font-weight: 500; border: none; cursor: pointer; }
        .btn-primary { background-color: #4a6baf; color: white; }
        .btn-secondary { background-color: #6b7280; color: white; }
        .alert { padding: 1rem; border-radius: 8px; margin-bottom: 1rem; border-left: 4px solid; }
        .alert-success { background-color: #f0fdf4; border-color: #10b981; color: #065f46; }
        .alert-error { background-color: #fef2f2; border-color: #ef4444; color: #7f1d1d; }
        .shadow-custom { box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06); }
        .border-red-500 { border-color: #ef4444 !important; }
        .bg-red-50 { background-color: #fef2f2 !important; }
        .error-message { color: #dc2626; font-size: 0.75rem; margin-top: 0.25rem; }
    </style>
</head>
<body class="font-poppins bg-gray-50 flex flex-col min-h-screen">
    <!-- Header Section -->
    <header class="bg-white shadow-custom sticky top-0 z-50">
        <nav class="flex justify-between items-center px-4 py-3 md:px-6 md:py-3 max-w-7xl mx-auto w-full">
            <div class="flex items-center">
                <div class="text-xl md:text-2xl font-bold text-primary">EMS</div>
            </div>
            <div class="flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/client/event-action?action=dashboard" class="text-gray-700 hover:text-primary font-medium transition-colors text-sm">Customer Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout" class="text-gray-700 hover:text-primary font-medium transition-colors text-sm">Logout</a>
            </div>
        </nav>
    </header>

    <!-- Main Content -->
    <main class="flex-1 max-w-6xl mx-auto w-full py-8 px-4">
        <div class="bg-white rounded-lg shadow-custom p-6 md:p-8">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 pb-4 border-b border-gray-200">
                <div>
                    <h1 class="text-2xl md:text-3xl font-bold text-gray-800">Edit Event</h1>
                    <p class="text-gray-600 mt-2">Update your event details and vendor selections</p>
                </div>
                <a href="${pageContext.request.contextPath}/client/event-action?action=dashboard" class="btn btn-secondary mt-4 md:mt-0">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                </a>
            </div>

            <!-- Display Messages -->
            <c:if test="${not empty param.error}">
                <div class="alert alert-error mb-6">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-circle mr-3"></i>
                        <div><c:out value="${param.error}" /></div>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success mb-6">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle mr-3"></i>
                        <div><c:out value="${param.success}" /></div>
                    </div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/client/event-action" method="POST" class="space-y-6" id="editEventForm">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="eventId" value="${event.eventId}">

                <!-- Event Details -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="form-group">
                        <label for="type" class="block text-sm font-medium text-gray-700 mb-2">Event Type *</label>
                        <input type="text" id="type" name="type" 
                               class="form-input" placeholder="e.g., Wedding, Birthday, Corporate Event" 
                               required maxlength="50" value="<c:out value='${event.type}'/>">
                        <p class="text-xs text-gray-500 mt-1">Letters, numbers, spaces, and hyphens only</p>
                    </div>

                    <div class="form-group">
                        <label for="date" class="block text-sm font-medium text-gray-700 mb-2">Event Date *</label>
                        <input type="date" id="date" name="date" 
                               class="form-input" required value="${event.date}">
                    </div>

                    <div class="form-group">
                        <label for="budget" class="block text-sm font-medium text-gray-700 mb-2">Budget (NPR) *</label>
                        <input type="number" id="budget" name="budget" step="0.01" min="0" max="1000000"
                               class="form-input" placeholder="Enter your budget" required value="${event.budget}">
                        <p class="text-xs text-gray-500 mt-1">Maximum budget: NPR 1,000,000</p>
                    </div>

                    <div class="form-group">
                        <label for="guestCount" class="block text-sm font-medium text-gray-700 mb-2">Estimated Guest Count</label>
                        <input type="number" id="guestCount" name="guestCount" min="0" max="10000"
                               class="form-input" placeholder="Number of guests" 
                               value="<c:out value='${event.guestCount}'/>">
                        <p class="text-xs text-gray-500 mt-1">Maximum: 10,000 guests</p>
                    </div>
                </div>

                <div class="form-group">
                    <label for="location" class="block text-sm font-medium text-gray-700 mb-2">Location</label>
                    <input type="text" id="location" name="location" 
                           class="form-input" placeholder="Event venue or location"
                           maxlength="100" value="<c:out value='${event.location}'/>">
                    <p class="text-xs text-gray-500 mt-1">Maximum 100 characters</p>
                </div>

                <div class="form-group">
                    <label for="locationPreference" class="block text-sm font-medium text-gray-700 mb-2">Location Preference</label>
                    <input type="text" id="locationPreference" name="locationPreference" 
                           class="form-input" placeholder="e.g., Indoor, Outdoor, Garden, Hall"
                           maxlength="100" value="<c:out value='${event.locationPreference}'/>">
                    <p class="text-xs text-gray-500 mt-1">Maximum 100 characters</p>
                </div>

                <div class="form-group">
                    <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                    <textarea id="description" name="description" rows="4" 
                              class="form-input" placeholder="Describe your event requirements and preferences"
                              maxlength="500"><c:out value="${event.description}"/></textarea>
                    <p class="text-xs text-gray-500 mt-1">Maximum 500 characters</p>
                </div>

                <!-- Vendor Selection Section -->
                <div class="form-group">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Update Vendor Selections</label>
                    
                    <div class="alert alert-info mb-4">
                        <div class="flex items-center">
                            <i class="fas fa-info-circle mr-3"></i>
                            <div>Update your vendor selections for this event.</div>
                        </div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty approvedVendors}">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <c:forEach var="vendor" items="${approvedVendors}">
                                    <div class="flex items-center p-4 bg-white border border-gray-200 rounded-lg hover:border-primary transition-colors shadow-custom">
                                        <input type="checkbox" 
                                               id="vendor_${vendor.vendorId}" 
                                               name="selectedVendors" 
                                               value="${vendor.vendorId}"
                                               class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded vendor-checkbox"
                                               <c:forEach var="selectedVendor" items="${event.selectedVendors}">
                                                   <c:if test="${selectedVendor.vendorId == vendor.vendorId}">checked</c:if>
                                               </c:forEach>
                                        >
                                        <label for="vendor_${vendor.vendorId}" class="ml-3 flex-1 cursor-pointer">
                                            <span class="block text-sm font-medium text-gray-900"><c:out value="${vendor.companyName}" /></span>
                                            <span class="block text-xs text-gray-500"><c:out value="${vendor.serviceType}" /></span>
                                            <span class="block text-xs text-gray-400 mt-1">
                                                <i class="fas fa-user mr-1"></i><c:out value="${vendor.contactPerson}" />
                                                <i class="fas fa-envelope ml-2 mr-1"></i><c:out value="${vendor.email}" />
                                                <c:if test="${not empty vendor.phone}">
                                                    <i class="fas fa-phone ml-2 mr-1"></i><c:out value="${vendor.phone}" />
                                                </c:if>
                                            </span>
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8 bg-gray-50 rounded-lg border border-gray-200">
                                <i class="fas fa-building text-gray-300 text-4xl mb-3"></i>
                                <p class="text-gray-500">No vendors available for selection at the moment.</p>
                                <p class="text-gray-400 text-sm mt-2">Please contact support for assistance.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div><!-- In your edit_event.jsp - Vendor Selection Section -->
<div class="mb-6">
    <label class="block text-gray-700 text-sm font-bold mb-3">Select Vendors</label>
    <div class="max-h-60 overflow-y-auto border border-gray-300 rounded-lg p-4 bg-gray-50">
        <c:forEach var="vendor" items="${approvedVendors}">
            <div class="flex items-center mb-3 p-3 hover:bg-white rounded-lg border border-gray-200">
                <input type="checkbox" 
                       name="vendorIds" 
                       value="${vendor.vendorId}" 
                       id="vendor_${vendor.vendorId}" 
                       class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                       <c:if test="${not empty event.selectedVendors}">
                           <c:forEach var="selectedVendor" items="${event.selectedVendors}">
                               <c:if test="${selectedVendor.vendorId == vendor.vendorId}">checked</c:if>
                           </c:forEach>
                       </c:if>
                >
                <label for="vendor_${vendor.vendorId}" class="flex-1 cursor-pointer ml-3">
                    <div class="font-medium text-gray-900">
                        <c:out value="${vendor.companyName}"/>
                        <c:if test="${not empty event.selectedVendors}">
                            <c:forEach var="selectedVendor" items="${event.selectedVendors}">
                                <c:if test="${selectedVendor.vendorId == vendor.vendorId}">
                                    <span class="ml-2 text-xs px-2 py-1 rounded 
                                        <c:choose>
                                            <c:when test="${selectedVendor.status eq 'Confirmed'}">bg-green-100 text-green-800</c:when>
                                            <c:when test="${selectedVendor.status eq 'Rejected'}">bg-red-100 text-red-800</c:when>
                                            <c:otherwise>bg-yellow-100 text-yellow-800</c:otherwise>
                                        </c:choose>">
                                        <c:out value="${selectedVendor.status}"/>
                                    </span>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </div>
                    <div class="text-sm text-gray-600 mt-1">
                        <span class="font-semibold"><c:out value="${vendor.serviceType}"/></span> • 
                        <c:out value="${vendor.contactPerson}"/> • 
                        <c:out value="${vendor.phone}"/>
                    </div>
                    <c:if test="${not empty vendor.email}">
                        <div class="text-xs text-gray-500 mt-1">
                            <i class="fas fa-envelope mr-1"></i><c:out value="${vendor.email}"/>
                        </div>
                    </c:if>
                </label>
            </div>
        </c:forEach>
        
        <c:if test="${empty approvedVendors}">
            <div class="text-center py-4">
                <i class="fas fa-users text-3xl text-gray-300 mb-2"></i>
                <p class="text-gray-500">No vendors available for selection.</p>
            </div>
        </c:if>
    </div>
    <p class="text-xs text-gray-500 mt-2">
        <i class="fas fa-info-circle mr-1"></i>
        Select the vendors you want to work with for this event. Previously selected vendors are marked with their current status.
    </p>
</div>

                <!-- Current Status Display -->
                <div class="bg-gray-50 p-4 rounded-lg">
                    <h3 class="text-sm font-medium text-gray-700 mb-2">Current Event Status</h3>
                    <div class="flex items-center">
                        <span class="px-3 py-1 rounded-full text-sm font-medium
                            <c:choose>
                                <c:when test="${event.status == 'Pending Approval'}">bg-yellow-100 text-yellow-800</c:when>
                                <c:when test="${event.status == 'Approved'}">bg-green-100 text-green-800</c:when>
                                <c:when test="${event.status == 'Rejected'}">bg-red-100 text-red-800</c:when>
                                <c:when test="${event.status == 'In Progress'}">bg-blue-100 text-blue-800</c:when>
                                <c:when test="${event.status == 'Completed'}">bg-gray-100 text-gray-800</c:when>
                                <c:when test="${event.status == 'Cancelled'}">bg-red-100 text-red-800</c:when>
                                <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                            </c:choose>">
                            ${event.status}
                        </span>
                    </div>
                    <p class="text-xs text-gray-500 mt-2">
                        <c:choose>
                            <c:when test="${event.status == 'Pending Approval'}">Your event is waiting for admin approval.</c:when>
                            <c:when test="${event.status == 'Approved'}">Your event has been approved and is ready for planning.</c:when>
                            <c:when test="${event.status == 'Rejected'}">Your event request was not approved.</c:when>
                            <c:when test="${event.status == 'In Progress'}">Your event is currently being prepared.</c:when>
                            <c:when test="${event.status == 'Completed'}">Your event has been completed.</c:when>
                            <c:when test="${event.status == 'Cancelled'}">This event has been cancelled.</c:when>
                        </c:choose>
                    </p>
                </div>

                <!-- Action Buttons -->
                <div class="flex flex-col sm:flex-row justify-end space-y-3 sm:space-y-0 sm:space-x-4 pt-6 border-t border-gray-200">
                    <a href="${pageContext.request.contextPath}/client/event-action?action=dashboard" 
                       class="btn btn-secondary order-2 sm:order-1">
                        <i class="fas fa-times mr-2"></i> Cancel
                    </a>
                    <button type="submit" 
                            class="btn btn-primary order-1 sm:order-2" id="submitBtn">
                        <i class="fas fa-save mr-2"></i> Update Event
                    </button>
                </div>
            </form>
        </div>
    </main>

    <!-- Footer Section -->
    <footer class="bg-gray-800 text-white py-4 mt-auto">
        <div class="max-w-7xl mx-auto px-4 text-center text-sm">
            &copy; 2025 EMS. All Rights Reserved.
        </div>
    </footer>

    <!-- JavaScript for Form Validation -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set minimum date to today
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('date').min = today;

            const form = document.getElementById('editEventForm');
            
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                // Validate required fields
                const typeInput = document.getElementById('type');
                const dateInput = document.getElementById('date');
                const budgetInput = document.getElementById('budget');
                
                // Event Type validation
                if (!typeInput.value.trim()) {
                    showError(typeInput, 'Event Type is required.');
                    isValid = false;
                } else if (!/^[a-zA-Z0-9\s-]{1,50}$/.test(typeInput.value.trim())) {
                    showError(typeInput, 'Event Type can only contain letters, numbers, spaces, and hyphens (max 50 characters).');
                    isValid = false;
                } else {
                    clearError(typeInput);
                }
                
                // Date validation
                if (!dateInput.value) {
                    showError(dateInput, 'Event Date is required.');
                    isValid = false;
                } else {
                    const selectedDate = new Date(dateInput.value);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (selectedDate < today) {
                        showError(dateInput, 'Event date cannot be in the past.');
                        isValid = false;
                    } else {
                        clearError(dateInput);
                    }
                }
                
                // Budget validation
                if (!budgetInput.value || parseFloat(budgetInput.value) <= 0) {
                    showError(budgetInput, 'Please enter a valid budget greater than 0.');
                    isValid = false;
                } else if (parseFloat(budgetInput.value) > 1000000) {
                    showError(budgetInput, 'Budget cannot exceed NPR 1,000,000.');
                    isValid = false;
                } else {
                    clearError(budgetInput);
                }
                
                // Guest count validation
                const guestCountInput = document.getElementById('guestCount');
                if (guestCountInput.value && parseInt(guestCountInput.value) > 10000) {
                    showError(guestCountInput, 'Guest count cannot exceed 10,000.');
                    isValid = false;
                } else if (guestCountInput.value && parseInt(guestCountInput.value) < 0) {
                    showError(guestCountInput, 'Guest count cannot be negative.');
                    isValid = false;
                } else {
                    clearError(guestCountInput);
                }
                
                if (!isValid) {
                    e.preventDefault();
                    // Scroll to first error
                    const firstError = document.querySelector('.error-message');
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
            });
            
            function showError(input, message) {
                // Remove any existing error message
                clearError(input);
                
                // Add error styling to input
                input.classList.add('border-red-500', 'bg-red-50');
                
                // Create and insert error message
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message text-red-500 text-xs mt-1';
                errorDiv.textContent = message;
                input.parentNode.appendChild(errorDiv);
            }
            
            function clearError(input) {
                // Remove error styling
                input.classList.remove('border-red-500', 'bg-red-50');
                
                // Remove error message
                const errorMessage = input.parentNode.querySelector('.error-message');
                if (errorMessage) {
                    errorMessage.remove();
                }
            }
        });
    </script>
</body>
</html>