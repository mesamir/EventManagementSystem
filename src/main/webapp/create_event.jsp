<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - EMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.875rem;
            transition: border-color 0.2s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #4a6baf;
            box-shadow: 0 0 0 3px rgba(74, 107, 175, 0.1);
        }

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
            background-color: #4a6baf;
            color: white;
        }

        .btn-primary:hover {
            background-color: #3a5699;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: #6b7280;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #374151;
            transform: translateY(-1px);
        }

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

        .alert-warning {
            background-color: #fffbeb;
            border-color: #f59e0b;
            color: #78350f;
        }

        .alert-info {
            background-color: #eff6ff;
            border-color: #3b82f6;
            color: #1e40af;
        }

        .shadow-custom {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }

        .shadow-custom-hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        /* Custom styles for form validation */
        .border-red-500 {
            border-color: #ef4444 !important;
        }

        .bg-red-50 {
            background-color: #fef2f2 !important;
        }

        .error-message {
            color: #dc2626;
            font-size: 0.75rem;
            margin-top: 0.25rem;
        }
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
                    <h1 class="text-2xl md:text-3xl font-bold text-gray-800">Create New Event</h1>
                    <p class="text-gray-600 mt-2">Fill in the event details and select your preferred vendors</p>
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

            <form action="${pageContext.request.contextPath}/client/event-action" method="POST" class="space-y-6" id="createEventForm">
                <input type="hidden" name="action" value="create">

                <!-- Event Details -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="form-group">
                        <label for="type" class="block text-sm font-medium text-gray-700 mb-2">Event Type *</label>
                        <input type="text" id="type" name="type" 
                               class="form-input" placeholder="e.g., Wedding, Birthday, Corporate Event" 
                               required maxlength="50">
                        <p class="text-xs text-gray-500 mt-1">Letters, numbers, spaces, and hyphens only</p>
                    </div>

                    <div class="form-group">
                        <label for="date" class="block text-sm font-medium text-gray-700 mb-2">Event Date *</label>
                        <input type="date" id="date" name="date" 
                               class="form-input" required min="">
                    </div>

                    <div class="form-group">
                        <label for="budget" class="block text-sm font-medium text-gray-700 mb-2">Budget (NPR) *</label>
                        <input type="number" id="budget" name="budget" step="0.01" min="0" max="1000000"
                               class="form-input" placeholder="Enter your budget" required>
                        <p class="text-xs text-gray-500 mt-1">Maximum budget: NPR 1,000,000</p>
                    </div>

                    <div class="form-group">
                        <label for="guestCount" class="block text-sm font-medium text-gray-700 mb-2">Estimated Guest Count</label>
                        <input type="number" id="guestCount" name="guestCount" min="0" max="10000"
                               class="form-input" placeholder="Number of guests">
                        <p class="text-xs text-gray-500 mt-1">Maximum: 10,000 guests</p>
                    </div>
                </div>

                <div class="form-group">
                    <label for="location" class="block text-sm font-medium text-gray-700 mb-2">Location</label>
                    <input type="text" id="location" name="location" 
                           class="form-input" placeholder="Event venue or location"
                           maxlength="100">
                    <p class="text-xs text-gray-500 mt-1">Maximum 100 characters</p>
                </div>

                <div class="form-group">
                    <label for="locationPreference" class="block text-sm font-medium text-gray-700 mb-2">Location Preference</label>
                    <input type="text" id="locationPreference" name="locationPreference" 
                           class="form-input" placeholder="e.g., Indoor, Outdoor, Garden, Hall"
                           maxlength="100">
                    <p class="text-xs text-gray-500 mt-1">Maximum 100 characters</p>
                </div>

                <div class="form-group">
                    <label for="description" class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                    <textarea id="description" name="description" rows="4" 
                              class="form-input" placeholder="Describe your event requirements and preferences"
                              maxlength="500"></textarea>
                    <p class="text-xs text-gray-500 mt-1">Maximum 500 characters</p>
                </div>

                <!-- Vendor Selection Section -->
                <div class="form-group">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Select Vendors</label>
                    
                    <div class="alert alert-info mb-4">
                        <div class="flex items-center">
                            <i class="fas fa-info-circle mr-3"></i>
                            <div>Select one or more vendors for your event. You can modify this selection later until payment is made.</div>
                        </div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty approvedVendors}">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <c:forEach var="vendor" items="${approvedVendors}">
                                    <div class="flex items-center p-4 bg-white border border-gray-200 rounded-lg hover:border-primary transition-colors shadow-custom hover:shadow-custom-hover">
                                        <input type="checkbox" 
                                               id="vendor_${vendor.vendorId}" 
                                               name="selectedVendors" 
                                               value="${vendor.vendorId}"
                                               class="h-4 w-4 text-primary focus:ring-primary border-gray-300 rounded vendor-checkbox">
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
                            <p id="vendorError" class="text-red-500 text-xs mt-2 hidden">Please select at least one vendor</p>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8 bg-gray-50 rounded-lg border border-gray-200">
                                <i class="fas fa-building text-gray-300 text-4xl mb-3"></i>
                                <p class="text-gray-500">No vendors available for selection at the moment.</p>
                                <p class="text-gray-400 text-sm mt-2">Please contact support for assistance.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Action Buttons -->
                <div class="flex flex-col sm:flex-row justify-end space-y-3 sm:space-y-0 sm:space-x-4 pt-6 border-t border-gray-200">
                    <a href="${pageContext.request.contextPath}/client/event-action?action=dashboard" 
                       class="btn btn-secondary order-2 sm:order-1">
                        <i class="fas fa-times mr-2"></i> Cancel
                    </a>
                    <button type="submit" 
                            class="btn btn-primary order-1 sm:order-2" id="submitBtn">
                        <i class="fas fa-plus-circle mr-2"></i> Create Event
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

            const form = document.getElementById('createEventForm');
            const vendorCheckboxes = document.querySelectorAll('.vendor-checkbox');
            const vendorError = document.getElementById('vendorError');
            
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
                
                // Vendor selection validation
                let vendorSelected = false;
                vendorCheckboxes.forEach(checkbox => {
                    if (checkbox.checked) {
                        vendorSelected = true;
                    }
                });
                
                if (!vendorSelected && vendorCheckboxes.length > 0) {
                    vendorError.classList.remove('hidden');
                    isValid = false;
                } else {
                    vendorError.classList.add('hidden');
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
            
            // Real-time validation for vendor selection
            vendorCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    let vendorSelected = false;
                    vendorCheckboxes.forEach(cb => {
                        if (cb.checked) {
                            vendorSelected = true;
                        }
                    });
                    
                    if (vendorSelected) {
                        vendorError.classList.add('hidden');
                    }
                });
            });
        });
    </script>
</body>
</html>