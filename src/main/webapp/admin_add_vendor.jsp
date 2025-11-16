<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Vendor - EMS Admin</title>
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
            max-width: 700px;
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
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"],
        .form-group input[type="tel"],
        .form-group input[type="number"],
        .form-group input[type="url"],
        .form-group textarea,
        .form-group select {
            width: calc(100% - 20px);
            padding: 12px 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            transition: border-color 0.3s ease;
        }
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: var(--primary-color);
            outline: none;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
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
        .status-message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
        }
        .status-message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .form-section-title {
            font-size: 1.5em;
            color: var(--primary-color);
            margin-top: 30px;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .error-message {
            color: #dc3545; /* Red */
            font-size: 0.85em;
            margin-top: 5px;
            display: block;
            text-align: left;
        }
        input.invalid, select.invalid, textarea.invalid {
            border-color: #dc3545;
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
            <h2>Add New Vendor Account</h2>

            <c:if test="${not empty errorMessage}">
                <div class="status-message error">
                    <c:out value="${errorMessage}" escapeXml="false" /> <%-- escapeXml="false" to allow <br> tags --%>
                </div>
            </c:if>

            <form id="addVendorForm" action="<%= request.getContextPath() %>/admin/add-vendor" method="POST" novalidate>
                <h3 class="form-section-title">Vendor User Account Details</h3>
                <div class="form-group">
                    <label for="name">Full Name:</label>
                    <input type="text" id="name" name="name" value="<c:out value="${name}" />" required>
                    <span class="error-message" id="nameError"></span>
                </div>
                <div class="form-group">
                    <label for="email">Email Address:</label>
                    <input type="email" id="email" name="email" value="<c:out value="${email}" />" required>
                    <span class="error-message" id="emailError"></span>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                    <span class="error-message" id="passwordError"></span>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                    <span class="error-message" id="confirmPasswordError"></span>
                </div>

                <h3 class="form-section-title">Vendor Profile Details</h3>
                <div class="form-group">
                    <label for="companyName">Company Name:</label>
                    <input type="text" id="companyName" name="companyName" value="<c:out value="${companyName}" />" required>
                    <span class="error-message" id="companyNameError"></span>
                </div>
                <div class="form-group">
                    <label for="serviceType">Service Type:</label>
                    <input type="text" id="serviceType" name="serviceType" value="<c:out value="${serviceType}" />" placeholder="e.g., Catering, Decoration, Photography" required>
                    <span class="error-message" id="serviceTypeError"></span>
                </div>
                <div class="form-group">
                    <label for="contactPerson">Contact Person:</label>
                    <input type="text" id="contactPerson" name="contactPerson" value="<c:out value="${contactPerson}" />" required>
                    <span class="error-message" id="contactPersonError"></span>
                </div>
                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="tel" id="phone" name="phone" value="<c:out value="${phone}" />" required>
                    <span class="error-message" id="phoneError"></span>
                </div>
                <div class="form-group">
                    <label for="address">Address:</label>
                    <textarea id="address" name="address" required><c:out value="${address}" /></textarea>
                    <span class="error-message" id="addressError"></span>
                </div>
                <div class="form-group">
                    <label for="description">Description of Services:</label>
                    <textarea id="description" name="description"><c:out value="${description}" /></textarea>
                    <span class="error-message" id="descriptionError"></span>
                </div>
                <div class="form-group">
                    <label for="minPrice">Minimum Price (NPR):</label>
                    <input type="number" id="minPrice" name="minPrice" step="0.01" min="0" value="<c:out value="${minPrice}" />">
                    <span class="error-message" id="minPriceError"></span>
                </div>
                <div class="form-group">
                    <label for="maxPrice">Maximum Price (NPR):</label>
                    <input type="number" id="maxPrice" name="maxPrice" step="0.01" min="0" value="<c:out value="${maxPrice}" />">
                    <span class="error-message" id="maxPriceError"></span>
                </div>
                <div class="form-group">
                    <label for="portfolioLink">Portfolio Link (URL):</label>
                    <input type="url" id="portfolioLink" name="portfolioLink" value="<c:out value="${portfolioLink}" />">
                    <span class="error-message" id="portfolioLinkError"></span>
                </div>

                <button type="submit" class="btn-submit"><i class="fas fa-user-plus"></i> Add Vendor</button>
            </form>
            <a href="<%= request.getContextPath() %>/admin/dashboard-display#vendors" class="back-link"><i class="fas fa-arrow-left"></i> Back to Vendor Management</a>
        </div>
    </div>

    <!-- Footer Section -->
    <footer>
        
        <div class="footer-bottom">
            &copy; 2025 EMS. All Rights Reserved.
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('addVendorForm');
            const nameInput = document.getElementById('name');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const companyNameInput = document.getElementById('companyName');
            const serviceTypeInput = document.getElementById('serviceType');
            const contactPersonInput = document.getElementById('contactPerson');
            const phoneInput = document.getElementById('phone');
            const addressInput = document.getElementById('address');
            const descriptionInput = document.getElementById('description');
            const minPriceInput = document.getElementById('minPrice');
            const maxPriceInput = document.getElementById('maxPrice');
            const portfolioLinkInput = document.getElementById('portfolioLink');

            const nameError = document.getElementById('nameError');
            const emailError = document.getElementById('emailError');
            const passwordError = document.getElementById('passwordError');
            const confirmPasswordError = document.getElementById('confirmPasswordError');
            const companyNameError = document.getElementById('companyNameError');
            const serviceTypeError = document.getElementById('serviceTypeError');
            const contactPersonError = document.getElementById('contactPersonError');
            const phoneError = document.getElementById('phoneError');
            const addressError = document.getElementById('addressError');
            const descriptionError = document.getElementById('descriptionError');
            const minPriceError = document.getElementById('minPriceError');
            const maxPriceError = document.getElementById('maxPriceError');
            const portfolioLinkError = document.getElementById('portfolioLinkError');


            function showError(element, message, errorSpan) {
                errorSpan.textContent = message;
                element.classList.add('invalid');
            }

            function clearError(element, errorSpan) {
                errorSpan.textContent = '';
                element.classList.remove('invalid');
            }

            function isValidEmail(email) {
                const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return re.test(String(email).toLowerCase());
            }

            function isValidPassword(password) {
                // At least 8 characters, one uppercase, one lowercase, one number, one special character
                const re = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                return re.test(password);
            }

            form.addEventListener('submit', function(event) {
                let isValid = true;

                // Clear all previous errors
                document.querySelectorAll('.error-message').forEach(span => span.textContent = '');
                document.querySelectorAll('input, select, textarea').forEach(input => input.classList.remove('invalid'));

                // Validate User Account Details
                if (nameInput.value.trim() === '') {
                    showError(nameInput, 'Full Name is required.', nameError);
                    isValid = false;
                }
                if (emailInput.value.trim() === '') {
                    showError(emailInput, 'Email Address is required.', emailError);
                    isValid = false;
                } else if (!isValidEmail(emailInput.value.trim())) {
                    showError(emailInput, 'Please enter a valid email address.', emailError);
                    isValid = false;
                }
                if (passwordInput.value.trim() === '') {
                    showError(passwordInput, 'Password is required.', passwordError);
                    isValid = false;
                } else if (!isValidPassword(passwordInput.value.trim())) {
                    showError(passwordInput, 'Password must be at least 8 characters, including uppercase, lowercase, number, and special character.', passwordError);
                    isValid = false;
                }
                if (confirmPasswordInput.value.trim() === '') {
                    showError(confirmPasswordInput, 'Confirm Password is required.', confirmPasswordError);
                    isValid = false;
                } else if (passwordInput.value.trim() !== confirmPasswordInput.value.trim()) {
                    showError(confirmPasswordInput, 'Passwords do not match.', confirmPasswordError);
                    isValid = false;
                }

                // Validate Vendor Profile Details
                if (companyNameInput.value.trim() === '') {
                    showError(companyNameInput, 'Company Name is required.', companyNameError);
                    isValid = false;
                }
                if (serviceTypeInput.value.trim() === '') {
                    showError(serviceTypeInput, 'Service Type is required.', serviceTypeError);
                    isValid = false;
                }
                if (contactPersonInput.value.trim() === '') {
                    showError(contactPersonInput, 'Contact Person is required.', contactPersonError);
                    isValid = false;
                }
                if (phoneInput.value.trim() === '') {
                    showError(phoneInput, 'Phone number is required.', phoneError);
                    isValid = false;
                }
                if (addressInput.value.trim() === '') {
                    showError(addressInput, 'Address is required.', addressError);
                    isValid = false;
                }

                const minPrice = parseFloat(minPriceInput.value);
                const maxPrice = parseFloat(maxPriceInput.value);

                if (minPriceInput.value !== '' && isNaN(minPrice)) {
                    showError(minPriceInput, 'Invalid number for min price.', minPriceError);
                    isValid = false;
                }
                if (maxPriceInput.value !== '' && isNaN(maxPrice)) {
                    showError(maxPriceInput, 'Invalid number for max price.', maxPriceError);
                    isValid = false;
                }
                if (!isNaN(minPrice) && !isNaN(maxPrice) && minPrice > maxPrice) {
                    showError(minPriceInput, 'Min price cannot be greater than max price.', minPriceError);
                    showError(maxPriceInput, 'Max price cannot be less than min price.', maxPriceError);
                    isValid = false;
                }

                if (!isValid) {
                    event.preventDefault(); // Stop form submission if validation fails
                }
            });

            // Real-time validation feedback (optional)
            const inputs = [nameInput, emailInput, passwordInput, confirmPasswordInput, companyNameInput,
                            serviceTypeInput, contactPersonInput, phoneInput, addressInput,
                            descriptionInput, minPriceInput, maxPriceInput, portfolioLinkInput];
            const errorSpans = {
                name: nameError, email: emailError, password: passwordError, confirmPassword: confirmPasswordError,
                companyName: companyNameError, serviceType: serviceTypeError, contactPerson: contactPersonError,
                phone: phoneError, address: addressError, description: descriptionError,
                minPrice: minPriceError, maxPrice: maxPriceError, portfolioLink: portfolioLinkError
            };

            inputs.forEach(input => {
                input.addEventListener('input', function() {
                    clearError(this, errorSpans[this.id]);
                    // Specific checks for password matching
                    if (this.id === 'password' || this.id === 'confirmPassword') {
                        if (passwordInput.value.trim() !== '' && confirmPasswordInput.value.trim() !== '' &&
                            passwordInput.value.trim() === confirmPasswordInput.value.trim()) {
                            clearError(passwordInput, passwordError);
                            clearError(confirmPasswordInput, confirmPasswordError);
                        }
                    }
                    // Specific checks for price range
                    if (this.id === 'minPrice' || this.id === 'maxPrice') {
                        const minPrice = parseFloat(minPriceInput.value);
                        const maxPrice = parseFloat(maxPriceInput.value);
                        if (!isNaN(minPrice) && !isNaN(maxPrice) && minPrice <= maxPrice) {
                            clearError(minPriceInput, minPriceError);
                            clearError(maxPriceInput, maxPriceError);
                        }
                    }
                });
            });
        });
    </script>
</body>
</html>

