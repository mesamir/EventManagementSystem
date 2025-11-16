<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Assume the User model object is available in the session --%>
<c:set var="user" value="${sessionScope.loggedInUser}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Profile</title>
    <%-- Link your main stylesheet and Font Awesome icons --%>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/all.min.css'/>">
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <%-- Add specific styles for modals if needed (or put in style.css) --%>
    <style>
/* --- Global Variables --- */
:root {
    /* --- Main Palette --- */
    --primary-color: #1e3a8a; /* Deep blue */
    --primary-color-hover: #1e40af; /* Slightly darker blue */
    --secondary-color: #4b5563; /* Dark charcoal gray */
    --secondary-color-hover: #374151;
    --accent-color: #0d9488; /* Vibrant teal */
    --accent-color-hover: #087f73;

    /* --- Status & Alerts --- */
    --success-color: #10b981; /* Green */
    --success-color-hover: #059669;
    --danger-color: #ef4444; /* Red */
    --danger-color-hover: #dc2626;
    --info-color: #3b82f6; /* Blue for info */
    --info-color-hover: #2563eb;
    
    /* --- Backgrounds & Text --- */
    --body-bg: #f9fafb;
    --card-bg: #ffffff;
    --sidebar-bg: #1f2937;
    --text-color: #1f2937;
    --text-color-light: #e5e7eb;
}

/* --- General & Body --- */
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

/* --- Alert Messages (Non-Tailwind) --- */
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
.alert-success { background-color: var(--success-color); }
.alert-error { background-color: var(--danger-color); }

/* --- Buttons (Custom Classes using Variables) --- */
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
    border: none; /* Ensure buttons don't have default borders */
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
/* Small action buttons */
.btn-sm {
    padding: 0.3rem 0.6rem;
    font-size: 0.8rem;
    border-radius: 0.3rem;
}
/* Special Report Button (Used in Dashboard) */
.btn-report {
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    font-weight: 600;
    transition: all 0.2s ease-in-out;
    background-color: #e0e7ff; /* Lighter color */
    color: #4338ca; /* Primary text color */
}
.btn-report:hover {
    background-color: #c7d2fe;
}
.btn-report.active {
    background-color: #4338ca;
    color: white;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
    box-shadow: 0 0 0 3px rgba(30, 58, 138, 0.25); /* Adjusted to primary-color variable */
}

/* --- Modals (Consolidated) --- */
.modal-wrapper { /* Renamed for consistency with your JS */
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
    padding: 2rem;
    border-radius: 0.75rem;
    width: 90%;
    max-width: 500px;
    box-shadow: 0 10px 15px rgba(0,0,0,0.2);
    position: relative;
}
.close-modal-btn { /* Renamed for consistency with your JS */
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
    border: none;
    background: none;
}
.close-modal-btn:hover, .close-modal-btn:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
/* Removed redundant .delete-modal and simplified to use .modal-wrapper */


/* --- Profile Card Specific Styles (from previous step) --- */
.profile-card {
    background-color: var(--card-bg);
    padding: 2rem;
    border-radius: 0.75rem;
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    max-width: 800px;
    margin: 2rem auto;
    border: 1px solid #e2e8f0;
}
.profile-card h2 {
    font-size: 1.75rem;
    font-weight: 700;
    color: var(--primary-color);
    margin-bottom: 1.5rem;
    border-bottom: 2px solid #e2e8f0;
    padding-bottom: 0.75rem;
}
.profile-detail {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 0;
    border-bottom: 1px dashed #e5e7eb;
    font-size: 1.1rem;
}
.profile-detail:last-child {
    border-bottom: none;
    margin-bottom: 1.5rem;
}
.profile-detail strong {
    font-weight: 600;
    color: var(--secondary-color);
    flex-basis: 30%;
}
.profile-actions {
    display: flex;
    gap: 1rem;
    margin-top: 2rem;
    padding-top: 1rem;
    border-top: 1px solid #e2e8f0;
    justify-content: flex-end;
}
/* Form refinement for modals */
.modal-content form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}
.modal-content label {
    font-weight: 500;
    color: #4b5563;
    margin-top: 0.5rem;
}
.modal-content input[type="text"],
.modal-content input[type="email"],
.modal-content input[type="password"] {
    padding: 0.75rem;
    border: 1px solid #d1d5db;
    border-radius: 0.5rem;
    font-size: 1rem;
}
.modal-content .btn {
    align-self: flex-end;
    margin-top: 1.5rem;
}
    </style>
</head>
<body>

    <div class="main-content">
        <h1 class="text-2xl font-bold text-gray-800">Admin Profile</h1>

        <div class="profile-card">
            <h2 class="text-gray-700">Account Details</h2>
            
            <div class="profile-detail">
                <strong>Name:</strong> <c:out value="${user.name}" />
            </div>
            <div class="profile-detail">
                <strong>Email:</strong> <c:out value="${user.email}" />
            </div>
            <div class="profile-detail">
                <strong>Phone:</strong> <c:out value="${user.phone}" />
            </div>
            <div class="profile-detail">
                <strong>Address:</strong> <c:out value="${user.address}" />
            </div>
            <div class="profile-detail">
                <strong>Role:</strong> <c:out value="${user.role}" />
            </div>

            <div class="profile-actions">
                <button id="editProfileBtn" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Edit Profile
                </button>
                <button id="changePasswordBtn" class="btn btn-secondary">
                    <i class="fas fa-lock"></i> Change Password
                </button>
            </div>
        </div>
    </div>

    <%-- ================================================ --%>
    <%-- 1. MODAL: Edit Profile --%>
    <%-- ================================================ --%>
    <div id="profileModal" class="modal-wrapper">
        <div class="modal-content">
            <button class="close-modal-btn">&times;</button>
            <h3>Edit Profile Details</h3>
            <form id="profileForm" method="POST" action="<c:url value='/admin/profile'/>">
                <input type="hidden" name="action" value="updateProfile">

                <input type="hidden" name="userId" value="<c:out value='${user.userId}' />">
                
                
                <label for="userName">Name</label>
                <input type="text" id="userName" name="name" value="<c:out value='${user.name}' />" required>

                <label for="userEmail">Email</label>
                <input type="email" id="userEmail" name="email" value="<c:out value='${user.email}' />" required>
                
                <label for="userPhone">Phone</label>
                <input type="text" id="userPhone" name="phone" value="<c:out value='${user.phone}' />">
                
                <label for="userAddress">Address</label>
                <input type="text" id="userAddress" name="address" value="<c:out value='${user.address}' />">

                <button type="submit" class="btn btn-success">Save Changes</button>
            </form>
        </div>
    </div>

    <%-- ================================================ --%>
    <%-- 2. MODAL: Change Password --%>
    <%-- ================================================ --%>
    <div id="passwordModal" class="modal-wrapper">
        <div class="modal-content">
            <button class="close-modal-btn">&times;</button>
            <h3>Change Password</h3>
            <form id="passwordForm" method="POST" action="<c:url value='/admin/profile'/>">
                <input type="hidden" name="action" value="changePassword">

                <input type="hidden" name="userId" value="<c:out value='${user.userId}' />">
                
                
                <label for="currentPassword">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword" required>

                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword" required>

                <label for="confirmPassword">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>

                <button type="submit" class="btn btn-success">Update Password</button>
            </form>
        </div>
    </div>
<script>
    <%-- Include the Admin Profile JavaScript (ensure this file exists or paste the content) --%>
   
    document.addEventListener('DOMContentLoaded', () => {
    // -----------------------------------------------------
    // Utility Functions: Modal Management
    // -----------------------------------------------------

    /**
     * Shows a modal.
     * @param {string} modalId - The ID of the modal wrapper element.
     */
    function showModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'flex'; // Use flex for centering/overlay
        }
    }

    /**
     * Hides a modal.
     * @param {string} modalId - The ID of the modal wrapper element.
     */
    function hideModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'none';
        }
    }

    // -----------------------------------------------------
    // Event Listeners: Button Clicks
    // -----------------------------------------------------

    // 1. "Edit Profile" Button Listener
    const editProfileBtn = document.getElementById('editProfileBtn');
    if (editProfileBtn) {
        editProfileBtn.addEventListener('click', () => {
            showModal('profileModal');
        });
    }

    // 2. "Change Password" Button Listener
    const changePasswordBtn = document.getElementById('changePasswordBtn');
    if (changePasswordBtn) {
        changePasswordBtn.addEventListener('click', () => {
            showModal('passwordModal');
            // Clear input fields when opening the password form
            const passwordForm = document.getElementById('passwordForm');
            if (passwordForm) {
                passwordForm.reset();
            }
        });
    }

    // 3. Close Buttons Listener (Applies to all modals with this class)
    document.querySelectorAll('.close-modal-btn').forEach(button => {
        button.addEventListener('click', function() {
            // Find the closest parent with the class 'modal-wrapper'
            const modalWrapper = this.closest('.modal-wrapper');
            if (modalWrapper) {
                hideModal(modalWrapper.id);
            }
        });
    });

    // -----------------------------------------------------
    // Form Validation: Password Confirmation
    // -----------------------------------------------------

    const passwordForm = document.getElementById('passwordForm');
    if (passwordForm) {
        passwordForm.addEventListener('submit', function(e) {
            const newPasswordInput = document.getElementById('newPassword');
            const confirmPasswordInput = document.getElementById('confirmPassword');

            // Simple client-side check to ensure passwords match
            if (newPasswordInput && confirmPasswordInput && newPasswordInput.value !== confirmPasswordInput.value) {
                e.preventDefault(); // Stop form submission
                
                // In a production app, use a styled notification, not 'alert'
                alert('Error: New password and confirmation password do not match.'); 
            }
        });
    }

    // -----------------------------------------------------
    // Message Handling (Displays success/error from Servlet Redirect)
    // -----------------------------------------------------
    
    // NOTE: This assumes the showMessage(message, type) utility function is available 
    // (either defined in the JSP or imported from another common script).
    
    if (typeof showMessage === 'function') {
        const urlParams = new URLSearchParams(window.location.search);
        const successMessage = urlParams.get('successMessage');
        const errorMessage = urlParams.get('errorMessage');

        if (successMessage) showMessage(successMessage, 'success');
        else if (errorMessage) showMessage(errorMessage, 'error');

        // Clean up the URL by removing the query parameters
        if (successMessage || errorMessage) {
            history.replaceState({}, document.title, window.location.pathname);
        }
    }
});
</script>
</body>
</html>