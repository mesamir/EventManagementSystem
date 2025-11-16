<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Event Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Set default font */
        body {
            font-family: 'Inter', sans-serif;
        }
        .admin-login-bg {
            background: linear-gradient(135deg, #1e3a8a 0%, #3730a3 100%);
            min-height: 100vh;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .input-focus:focus {
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            border-color: #3b82f6;
        }
        .shake {
            animation: shake 0.5s ease-in-out;
        }
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        .fade-in {
            animation: fadeIn 0.6s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .pulse {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        /* Custom styling for the JSP alerts to ensure they look good before JS can remove them */
        .alert-message {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
        }
    </style>
</head>
<body class="admin-login-bg min-h-screen flex items-center justify-center p-4">
    <div class="max-w-md w-full fade-in">
        <!-- Header Section -->
        <div class="text-center mb-8">
            <div class="w-20 h-20 bg-white/10 rounded-2xl flex items-center justify-center mx-auto mb-4 backdrop-blur-sm border border-white/20">
                <i class="fas fa-shield-alt text-white text-3xl"></i>
            </div>
            <h1 class="text-4xl font-bold text-white mb-2">Admin Portal</h1>
            <p class="text-blue-100 text-lg">Event Management System</p>
            <div class="w-24 h-1 bg-blue-300 rounded-full mx-auto mt-4"></div>
        </div>

        <!-- Login Card -->
        <div class="login-card rounded-2xl shadow-2xl p-8">
            <div class="text-center mb-8">
                <div class="w-16 h-16 bg-gradient-to-r from-blue-600 to-blue-700 rounded-2xl flex items-center justify-center mx-auto mb-4 shadow-lg">
                    <i class="fas fa-lock text-white text-2xl"></i>
                </div>
                <h2 class="text-2xl font-bold text-gray-800">Admin Sign In</h2>
                <p class="text-gray-600 mt-2">Access the administration dashboard</p>
            </div>

            <!-- Messages Section (JSP-rendered alerts) -->
            <div id="messagesContainer">
                <% 
                    // Error message handler
                    String error = request.getParameter("error");
                    if (error != null) { 
                %>
                    <div class="alert-message bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-6 fade-in shake" role="alert">
                        <div class="flex items-center">
                            <i class="fas fa-exclamation-circle mr-3 text-red-500"></i>
                            <div>
                                <span class="font-medium">Authentication Error</span>
                                <p class="text-sm mt-1"><%= error %></p>
                            </div>
                        </div>
                        <!-- Close button uses inline JS to remove the element -->
                        <button onclick="this.closest('.alert-message').remove()" class="text-red-400 hover:text-red-600 focus:outline-none">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                <% } %>

                <% 
                    // Logout success message handler
                    String logoutSuccess = request.getParameter("logoutSuccess");
                    if (logoutSuccess != null) { 
                %>
                    <div class="alert-message bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg mb-6 fade-in" role="alert">
                        <div class="flex items-center">
                            <i class="fas fa-check-circle mr-3 text-green-500"></i>
                            <div>
                                <span class="font-medium">Success</span>
                                <p class="text-sm mt-1">You have been successfully logged out.</p>
                            </div>
                        </div>
                        <button onclick="this.closest('.alert-message').remove()" class="text-green-400 hover:text-green-600 focus:outline-none">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                <% } %>
            </div>

            <!-- Login Form -->
            <form id="adminLoginForm" action="${pageContext.request.contextPath}/admin" method="post" class="space-y-6" novalidate>
                <!-- Email Field -->
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-envelope mr-2 text-blue-500"></i>
                        Admin Email
                    </label>
                    <div class="relative">
                        <input type="email" id="email" name="email" required
                               class="w-full px-4 py-3 pl-11 border border-gray-300 rounded-lg input-focus transition duration-200"
                               placeholder="admin@example.com"
                               autocomplete="username">
                        <i class="fas fa-envelope absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <div id="emailError" class="error-message hidden text-red-600 text-xs mt-1 ml-1"></div>
                    </div>
                </div>

                <!-- Password Field -->
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-key mr-2 text-blue-500"></i>
                        Password
                    </label>
                    <div class="relative">
                        <input type="password" id="password" name="password" required
                               class="w-full px-4 py-3 pl-11 border border-gray-300 rounded-lg input-focus transition duration-200"
                               placeholder="Enter your password"
                               autocomplete="current-password">
                        <i class="fas fa-lock absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <button type="button" id="togglePassword" class="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600" aria-label="Toggle password visibility">
                            <i class="fas fa-eye"></i>
                        </button>
                        <div id="passwordError" class="error-message hidden text-red-600 text-xs mt-1 ml-1"></div>
                    </div>
                </div>

                <!-- Remember Me & Forgot Password -->
                <div class="flex items-center justify-between">
                    <label class="flex items-center">
                        <input type="checkbox" id="rememberMe" name="rememberMe" class="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                        <span class="ml-2 text-sm text-gray-600">Remember me</span>
                    </label>
                    <a href="#" class="text-sm text-blue-600 hover:text-blue-800 transition duration-200">
                        Forgot password?
                    </a>
                </div>

                <!-- Submit Button -->
                <button type="submit" id="submitButton"
                        class="w-full bg-gradient-to-r from-blue-600 to-blue-700 text-white py-3 px-4 rounded-lg hover:from-blue-700 hover:to-blue-800 focus:ring-4 focus:ring-blue-200 font-medium transition duration-200 shadow-lg relative overflow-hidden group">
                    <span id="buttonText" class="relative z-10">
                        <i class="fas fa-sign-in-alt mr-2"></i>
                        Sign In to Admin Panel
                    </span>
                    <div id="loadingSpinner" class="hidden absolute inset-0 bg-blue-600 flex items-center justify-center">
                        <i class="fas fa-spinner fa-spin text-white text-lg"></i>
                    </div>
                    <div class="absolute inset-0 bg-gradient-to-r from-blue-700 to-blue-800 opacity-0 group-hover:opacity-100 transition-opacity duration-200"></div>
                </button>
            </form>

            <!-- Demo Credentials Link (NEW ADDITION) -->
            <div class="mt-4 text-center">
                <button type="button" id="fillDemoCredentials"
                        class="text-sm text-blue-600 hover:text-blue-800 transition duration-200 focus:outline-none focus:ring-2 focus:ring-blue-200 rounded-lg p-2">
                    <i class="fas fa-magic mr-1"></i> Quick Fill Demo Credentials (admin@ems.com / admin123)
                </button>
            </div>

            <!-- Footer Links -->
            <div class="mt-6 text-center space-y-3 pt-4 border-t border-gray-200">
                <a href="${pageContext.request.contextPath}/login" 
                   class="block text-blue-600 hover:text-blue-800 text-sm transition duration-200 group">
                    <i class="fas fa-arrow-left mr-2 group-hover:translate-x-[-2px] transition-transform"></i>
                    Back to User Login
                </a>
                <a href="${pageContext.request.contextPath}/" 
                   class="block text-gray-500 hover:text-gray-700 text-sm transition duration-200 group">
                    <i class="fas fa-home mr-2 group-hover:scale-110 transition-transform"></i>
                    Back to Homepage
                </a>
            </div>

            <!-- Security Notice -->
            <div class="mt-6 p-3 bg-yellow-50 border border-yellow-200 rounded-lg text-center">
                <i class="fas fa-shield-alt text-yellow-500 text-sm mr-2"></i>
                <span class="text-xs text-yellow-700">Secure admin access only. Unauthorized access prohibited.</span>
            </div>
        </div>

        <!-- Toast Container (for JavaScript notifications) -->
        <div id="toastContainer" class="fixed top-4 right-4 space-y-2 z-50"></div>
    </div>

<script>
    /**
     * Admin Login JavaScript
     * Handles form validation, animations, and user experience enhancements
     */

    // Toast Notifications
    function showToast(message, type) {
        if (!type) type = 'info';
        
        const toastContainer = document.getElementById('toastContainer');
        if (!toastContainer) return;

        // Get icon based on type
        const icon = getToastIcon(type);
        const bgColor = getToastBgColor(type);

        const toast = document.createElement('div');
        toast.className = bgColor + ' text-white px-6 py-3 rounded-lg shadow-xl transform transition-all duration-300 translate-x-full min-w-[200px] flex items-center justify-between';
        toast.setAttribute('role', 'status');

        toast.innerHTML = 
            '<div class="flex items-center">' +
            '<i class="fas fa-' + icon + ' mr-3"></i>' +
            '<span>' + message + '</span>' +
            '</div>' +
            '<button class="ml-4 text-white hover:text-gray-200 close-toast focus:outline-none">' +
            '<i class="fas fa-times"></i>' +
            '</button>';

        toastContainer.appendChild(toast);

        // Add event listener for close button
        const closeBtn = toast.querySelector('.close-toast');
        closeBtn.addEventListener('click', function() {
            hideToast(toast);
        });

        // Animate in
        setTimeout(function() { toast.classList.remove('translate-x-full'); }, 100);

        // Auto remove after 5 seconds
        setTimeout(function() {
            hideToast(toast);
        }, 5000);
    }
    
    function hideToast(toastElement) {
        if (toastElement.parentElement) {
            toastElement.classList.add('translate-x-full', 'opacity-0');
            // Wait for transition to end before removing from DOM
            setTimeout(function() { toastElement.remove(); }, 300);
        }
    }

    function getToastIcon(type) {
        switch(type) {
            case 'success': return 'check-circle';
            case 'error': return 'exclamation-triangle';
            case 'warning': return 'exclamation-circle';
            case 'info': return 'info-circle';
            default: return 'info-circle';
        }
    }

    function getToastBgColor(type) {
        switch(type) {
            case 'success': return 'bg-green-500';
            case 'error': return 'bg-red-600';
            case 'warning': return 'bg-yellow-500';
            case 'info': return 'bg-blue-500';
            default: return 'bg-blue-500';
        }
    }

    // UI Helper Functions
    function showError(fieldName, message) {
        const input = document.getElementById(fieldName);
        const errorElement = document.getElementById(fieldName + 'Error');
        
        if (input && errorElement) {
            input.classList.add('shake', 'border-red-500');
            input.classList.remove('border-gray-300'); // Ensure border changes color
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
            
            setTimeout(function() { input.classList.remove('shake'); }, 500);
        }
    }

    function clearError(fieldName) {
        const input = document.getElementById(fieldName);
        const errorElement = document.getElementById(fieldName + 'Error');
        
        if (input && errorElement) {
            input.classList.remove('border-red-500', 'shake');
            input.classList.add('border-gray-300'); // Restore default border
            errorElement.classList.add('hidden');
        }
    }

    function setButtonLoading(loading) {
        const button = document.getElementById('submitButton');
        const buttonText = document.getElementById('buttonText');
        const spinner = document.getElementById('loadingSpinner');
        
        if (button && buttonText && spinner) {
            if (loading) {
                button.disabled = true;
                buttonText.classList.add('hidden');
                spinner.classList.remove('hidden');
                button.classList.add('cursor-wait');
                button.classList.remove('hover:from-blue-700', 'hover:to-blue-800');
            } else {
                button.disabled = false;
                buttonText.classList.remove('hidden');
                spinner.classList.add('hidden');
                button.classList.remove('cursor-wait');
                button.classList.add('hover:from-blue-700', 'hover:to-blue-800');
            }
        }
    }

    function isButtonLoading() {
        const spinner = document.getElementById('loadingSpinner');
        return spinner && !spinner.classList.contains('hidden');
    }

    // Validation Functions
    function validateEmail() {
        const emailInput = document.getElementById('email');
        const email = emailInput ? emailInput.value.trim() : '';
        
        if (!email) {
            showError('email', 'Email is required');
            return false;
        }

        if (!isValidEmail(email)) {
            showError('email', 'Please enter a valid email address');
            return false;
        }

        clearError('email');
        return true;
    }

    function validatePassword() {
        const passwordInput = document.getElementById('password');
        const password = passwordInput ? passwordInput.value : '';
        
        if (!password) {
            showError('password', 'Password is required');
            return false;
        }

        if (password.length < 6) {
            showError('password', 'Password must be at least 6 characters');
            return false;
        }

        clearError('password');
        return true;
    }

    function isValidEmail(email) {
        // Basic RFC 5322 compliant regex for validation
        const emailRegex = new RegExp(
            /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        );
        return emailRegex.test(email);
    }

    // Password Visibility Toggle
    function initPasswordToggle() {
        const toggleButton = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');

        if (toggleButton && passwordInput) {
            toggleButton.addEventListener('click', function() {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                
                const icon = this.querySelector('i');
                if (icon) {
                    icon.className = type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
                }
            });
        }
    }

    // Demo Credentials Auto-fill
    function initDemoCredentials() {
        const fillButton = document.getElementById('fillDemoCredentials');
        if (fillButton) {
            fillButton.addEventListener('click', function() {
                const emailInput = document.getElementById('email');
                const passwordInput = document.getElementById('password');
                const rememberMe = document.getElementById('rememberMe');
                
                if (emailInput) {
                    emailInput.value = 'admin@ems.com';
                    clearError('email'); // Clear error on successful fill
                }
                if (passwordInput) {
                    passwordInput.value = 'admin123';
                    clearError('password'); // Clear error on successful fill
                }
                if (rememberMe) rememberMe.checked = true;
                
                showToast('Demo credentials filled: admin@ems.com / admin123', 'success');
                
                // Animate the inputs
                ['email', 'password'].forEach(function(id) {
                    const input = document.getElementById(id);
                    if (input) {
                        input.classList.add('pulse');
                        setTimeout(function() { input.classList.remove('pulse'); }, 2000);
                    }
                });
            });
        }
    }

    // Form Validation and Submission
    function initFormValidation() {
        const form = document.getElementById('adminLoginForm');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');

        if (form) {
            form.addEventListener('submit', handleLoginSubmit);
        }

        // Real-time validation listeners
        if (emailInput) {
            emailInput.addEventListener('blur', validateEmail);
            emailInput.addEventListener('input', function() { clearError('email'); });
        }

        if (passwordInput) {
            passwordInput.addEventListener('blur', validatePassword);
            passwordInput.addEventListener('input', function() { clearError('password'); });
        }

        // Enter key support
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !isButtonLoading()) {
                if (form) {
                    // Prevent default form submission and trigger the custom handler
                    e.preventDefault(); 
                    handleLoginSubmit({ target: form, preventDefault: function(){} });
                }
            }
        });
    }

    function handleLoginSubmit(e) {
        e.preventDefault(); // Stop default submission initially

        if (isButtonLoading()) return;

        const isEmailValid = validateEmail();
        const isPasswordValid = validatePassword();

        if (!isEmailValid || !isPasswordValid) {
            showToast('Please correct the validation errors before signing in.', 'error');
            return;
        }

        // Show loading state
        setButtonLoading(true);

        // Simulate network delay for better UX before actual submission
        setTimeout(function() {
            // Re-submit the form programmatically (this bypasses the preventDefault above)
            // In a real JSP environment, this submits to the servlet defined in the action attribute.
            e.target.submit(); 
        }, 1000);
    }

    // Main initialization function
    function initAdminLogin() {
        // Initialize all components
        initDemoCredentials();
        initPasswordToggle();
        initFormValidation();
        
        // No need for initAlertCloseButtons as JSP alerts use inline handler and Toasts manage themselves.
        
        console.log('Admin login initialized successfully');
    }

    document.addEventListener('DOMContentLoaded', function() {
        initAdminLogin();
        // Check for JSP error messages on load and apply shake effect
        const errorAlert = document.querySelector('.alert-message.bg-red-50');
        if (errorAlert) {
            const loginCard = document.querySelector('.login-card');
            if (loginCard) {
                loginCard.classList.add('shake');
                setTimeout(() => loginCard.classList.remove('shake'), 500);
            }
        }
    });
</script>
</body>
</html>
