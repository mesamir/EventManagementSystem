<%-- 
    Document   : registration
    Created on : Jul 18, 2025, 4:54:14 PM
    Author     : samir
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%><!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - EMS</title>
        <!-- Link to Google Fonts for 'Poppins' -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Link to Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- Link to your custom CSS file -->
        <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
        <style>
            .registration-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: calc(100vh - 180px); /* Adjust based on header/footer height */
                padding: 40px 20px;
                background-color: var(--light-grey); /* Light background for the section */
            }

            .registration-box {
                background-color: #fff;
                padding: 50px 40px;
                border-radius: 10px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 550px; /* Slightly wider for more fields */
                text-align: center;
            }

            .registration-box h2 {
                font-size: 2em;
                color: var(--secondary-color);
                margin-bottom: 30px;
            }

            /* Style for the new dynamic section headers */
            .registration-box h3 {
                font-size: 1.5em;
                color: var(--primary-color);
                margin-top: 30px;
                margin-bottom: 20px;
                border-bottom: 2px solid var(--primary-color);
                padding-bottom: 10px;
                text-align: center;
            }

            .form-group {
                margin-bottom: 25px;
                text-align: left;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: var(--text-color);
            }

            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="password"],
            .form-group input[type="tel"],
            .form-group input[type="url"],
            .form-group input[type="number"],
            .form-group textarea,
            .form-group select {
                width: 100%;
                padding: 14px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-family: var(--font-family);
                font-size: 1em;
                box-sizing: border-box;
                transition: border-color 0.3s ease;
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                border-color: var(--primary-color);
                outline: none;
            }

            /* Style for the textarea field */
            .form-group textarea {
                min-height: 100px;
                resize: vertical;
            }

            .registration-box .btn {
                width: 100%;
                padding: 15px;
                font-size: 1.1em;
                margin-top: 10px;
            }

            /* Style for client-side validation error messages */
            .error-message {
                color: #e74c3c;
                font-size: 0.9em;
                display: block;
                margin-top: 5px;
            }

            /* Style for server-side error messages */
            .server-error {
                color: #e74c3c;
                background-color: #fce4e4;
                border: 1px solid #e74c3c;
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 20px;
                font-weight: 600;
            }

            .links-container {
                margin-top: 25px;
                font-size: 0.95em;
            }

            .links-container a {
                color: var(--primary-color);
                margin: 0 10px;
                transition: color 0.3s ease;
            }

            .links-container a:hover {
                color: var(--secondary-color);
                text-decoration: underline;
            }

            /* Style for the new input types */
            .form-group input[type="tel"],
            .form-group input[type="url"],
            .form-group input[type="number"] {
                /* These inherit from the general input styles, but you can add specific overrides here if needed */
            }

            /* General style for the dynamic sections to add some spacing */
            .dynamic-fields {
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #e0e0e0;
            }
            
            

        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header>
            <nav class="navbar">
                <div class="logo">
                    <a href="index.html"><img class="logo-img" src="images/logo.jpg"" alt="EMS-Logo" ></a>
                </div>
                <div class="hamburger" id="hamburger-menu">
                    <i class="fas fa-bars"></i>
                </div>
                <div class="nav-menu" id="nav-menu"> 
                <ul class="nav-links">
                    <li><a href="index.html">Home</a></li>
                    <li><a href="about.html">About Us</a></li>
                    <li><a href="services.jsp">Our Services</a></li>
                    <li><a href="vendors">Our Vendors</a></li>
                    <li><a href="gallery.html">Gallery</a></li>
                    <li><a href="blog.jsp">Blog</a></li>
                    <li><a href="contact.jsp">Contact Us</a></li>
                    <li><a href="login.jsp" class="active"> <button class="btn btn-primary"><i class="fas fa-user-circle"></i>Login</button></a>
                </ul>                 
            </div>
            </nav>
        </header>

        <!-- Main Content Area -->
        <main>
            <section class="registration-container">
                <div class="registration-box animate-fadeIn">
                    <h2>Create Your EMS Account</h2>

                    <%-- Display server-side error message if present --%>
                    <% if (request.getAttribute("errorMessage") != null) {%>
                    <p class="server-error"><%= request.getAttribute("errorMessage")%></p>
                    <% }%>

                    <form id="registrationForm" action="register" method="POST" novalidate>
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" required autocomplete="name">
                            <span class="error-message" id="nameError"></span>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" required autocomplete="email">
                            <span class="error-message" id="emailError"></span>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required autocomplete="new-password">
                            <span class="error-message" id="passwordError"></span>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required autocomplete="new-password">
                            <span class="error-message" id="confirmPasswordError"></span>
                        </div>

                        <div class="form-group">
                            <label for="role">Register As</label>
                            <select id="role" name="role" required>
                                <option value="">-- Select Role --</option>
                                <option value="customer">Customer</option>
                                <option value="vendor">Vendor</option>
                            </select>
                            <span class="error-message" id="roleError"></span>
                        </div>

                        <!-- Dynamic fields for Customer registration -->
                        <div id="customerFields" class="dynamic-fields" style="display: none;">
                            <h3>Contact Details</h3>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" id="phone" name="phone">
                            </div>
                            <div class="form-group">
                                <label for="address">Address</label>
                                <input type="text" id="address" name="address">
                            </div>
                        </div>

                        <!-- Dynamic fields for Vendor registration -->
                        <div id="vendorFields" class="dynamic-fields" style="display: none;">
                            <h3>Vendor Profile Details</h3>
                            <div class="form-group">
                                <label for="companyName">Company Name</label>
                                <input type="text" id="companyName" name="companyName">
                                <span class="error-message" id="companyNameError"></span>
                            </div>
                            <div class="form-group">
                                <label for="serviceType">Service Type</label>
                                <input type="text" id="serviceType" name="serviceType">
                                <span class="error-message" id="serviceTypeError"></span>
                            </div>
                            <div class="form-group">
                                <label for="contactPerson">Contact Person</label>
                                <input type="text" id="contactPerson" name="contactPerson">
                            </div>
                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea id="description" name="description"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="portfolioLink">Portfolio Link</label>
                                <input type="url" id="portfolioLink" name="portfolioLink">
                            </div>
                            <div class="form-group">
                                <label for="minPrice">Minimum Price</label>
                                <input type="number" id="minPrice" name="minPrice" step="0.01">
                            </div>
                            <div class="form-group">
                                <label for="maxPrice">Maximum Price</label>
                                <input type="number" id="maxPrice" name="maxPrice" step="0.01">
                            </div>
                        </div>

                        <button type="submit" class="btn">Register Account</button>
                    </form>
                    <div class="links-container">
                        Already have an account? <a href="login.jsp">Login Here</a>
                    </div>
                </div>
            </section>
        </main>

        <!-- Footer Section -->
        <footer>
            <div class="footer-columns">
                <div class="footer-column">
                     <h4>Quick Links</h4>
                <ul>
                    <li><a href="index.html">Home</a></li>
                    <li><a href="about.html">About Us</a></li>
                    <li><a href="services.jsp">Our Services</a></li>
                    <li><a href="gallery.html">Gallery</a></li>
                    <li><a href="contact.jsp">Contact Us</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4>Our Services</h4>
                <ul>
                    <li><a href="services.jsp">Wedding Planning</a></li>
                    <li><a href="services.jsp">Corporate Events</a></li>
                    <li><a href="services.jsp">Private Parties</a></li>
                    <li><a href="services.jsp">Vendor Management</a></li>
                </ul>
            </div>
                <div class="footer-column">
                    <h4>Contact Info</h4>
                    <p><i class="fas fa-map-marker-alt"></i> Kathmandu, Nepal</p>
                    <p><i class="fas fa-phone"></i> +977 9876543210</p>
                    <p><i class="fas fa-envelope"></i> info@ems.com.np</p>
                </div>
                <div class="footer-column">
                    <h4>Follow Us</h4>
                    <p>Stay connected with us on social media for updates and event inspirations.</p>
                    <div class="social-icons">
                        <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                &copy; 2025 EMS. All Rights Reserved.
            </div>
        </footer>

        <script>
            document.addEventListener('DOMContentLoaded', function () {

                const hamburger = document.getElementById('hamburger-menu');
                const navMenu = document.getElementById('nav-menu');

                hamburger.addEventListener('click', function () {
                    navMenu.classList.toggle('active');
                });

                const form = document.getElementById('registrationForm');
                const nameInput = document.getElementById('name');
                const emailInput = document.getElementById('email');
                const passwordInput = document.getElementById('password');
                const confirmPasswordInput = document.getElementById('confirmPassword');
                const roleSelect = document.getElementById('role');

                // Dynamic field containers
                const customerFieldsDiv = document.getElementById('customerFields');
                const vendorFieldsDiv = document.getElementById('vendorFields');

                // Vendor fields for validation
                const companyNameInput = document.getElementById('companyName');
                const serviceTypeInput = document.getElementById('serviceType');

                const nameError = document.getElementById('nameError');
                const emailError = document.getElementById('emailError');
                const passwordError = document.getElementById('passwordError');
                const confirmPasswordError = document.getElementById('confirmPasswordError');
                const roleError = document.getElementById('roleError');
                const companyNameError = document.getElementById('companyNameError');
                const serviceTypeError = document.getElementById('serviceTypeError');

                function showError(element, message, errorSpan) {
                    errorSpan.textContent = message;
                    element.classList.add('invalid');
                }

                function clearError(element, errorSpan) {
                    errorSpan.textContent = '';
                    element.classList.remove('invalid');
                }

                function validateEmail(email) {
                    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    return re.test(String(email).toLowerCase());
                }

                function validatePassword(password) {
                    const re = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                    return re.test(password);
                }

                // Function to toggle role-specific fields visibility and required attributes
                function toggleRoleFields() {
                    // Hide all dynamic fields first
                    customerFieldsDiv.style.display = 'none';
                    vendorFieldsDiv.style.display = 'none';

                    // Remove required attribute from all dynamic fields to avoid validation issues
                    companyNameInput.removeAttribute('required');
                    serviceTypeInput.removeAttribute('required');

                    // Clear any existing errors from the hidden fields
                    clearError(companyNameInput, companyNameError);
                    clearError(serviceTypeInput, serviceTypeError);

                    // Show the relevant fields based on the selected role
                    if (roleSelect.value === 'vendor') {
                        vendorFieldsDiv.style.display = 'block';
                        companyNameInput.setAttribute('required', 'true');
                        serviceTypeInput.setAttribute('required', 'true');
                    } else if (roleSelect.value === 'customer') {
                        customerFieldsDiv.style.display = 'block';
                        // Customer fields don't have special validation here, but you can add it if needed
                    }
                }

                roleSelect.addEventListener('change', toggleRoleFields);
                toggleRoleFields(); // Call on page load to set initial state

                form.addEventListener('submit', function (event) {
                    let isValid = true;

                    // Validate Name
                    if (nameInput.value.trim() === '') {
                        showError(nameInput, 'Full Name is required.', nameError);
                        isValid = false;
                    } else {
                        clearError(nameInput, nameError);
                    }

                    // Validate Email
                    if (emailInput.value.trim() === '') {
                        showError(emailInput, 'Email Address is required.', emailError);
                        isValid = false;
                    } else if (!validateEmail(emailInput.value.trim())) {
                        showError(emailInput, 'Please enter a valid email address.', emailError);
                        isValid = false;
                    } else {
                        clearError(emailInput, emailError);
                    }

                    // Validate Password
                    if (passwordInput.value.trim() === '') {
                        showError(passwordInput, 'Password is required.', passwordError);
                        isValid = false;
                    } else if (!validatePassword(passwordInput.value.trim())) {
                        showError(passwordInput, 'Password must be at least 8 characters, including uppercase, lowercase, number, and special character.', passwordError);
                        isValid = false;
                    } else {
                        clearError(passwordInput, passwordError);
                    }

                    // Validate Confirm Password
                    if (confirmPasswordInput.value.trim() === '') {
                        showError(confirmPasswordInput, 'Confirm Password is required.', confirmPasswordError);
                        isValid = false;
                    } else if (passwordInput.value.trim() !== confirmPasswordInput.value.trim()) {
                        showError(confirmPasswordInput, 'Passwords do not match.', confirmPasswordError);
                        isValid = false;
                    } else {
                        clearError(confirmPasswordInput, confirmPasswordError);
                    }

                    // Validate Role
                    if (roleSelect.value === '') {
                        showError(roleSelect, 'Please select a role.', roleError);
                        isValid = false;
                    } else {
                        clearError(roleSelect, roleError);
                    }

                    // Validate Vendor-specific fields only if role is 'vendor'
                    if (roleSelect.value === 'vendor') {
                        if (companyNameInput.value.trim() === '') {
                            showError(companyNameInput, 'Company Name is required.', companyNameError);
                            isValid = false;
                        } else {
                            clearError(companyNameInput, companyNameError);
                        }
                        if (serviceTypeInput.value.trim() === '') {
                            showError(serviceTypeInput, 'Service Type is required.', serviceTypeError);
                            isValid = false;
                        } else {
                            clearError(serviceTypeInput, serviceTypeError);
                        }
                    }

                    if (!isValid) {
                        event.preventDefault(); // Stop form submission if validation fails
                    }
                });

                // Real-time validation feedback (optional, but good UX)
                nameInput.addEventListener('input', () => {
                    if (nameInput.value.trim() !== '')
                        clearError(nameInput, nameError);
                });
                emailInput.addEventListener('input', () => {
                    if (emailInput.value.trim() !== '' && validateEmail(emailInput.value.trim()))
                        clearError(emailInput, emailError);
                });
                passwordInput.addEventListener('input', () => {
                    if (passwordInput.value.trim() !== '' && validatePassword(passwordInput.value.trim()))
                        clearError(passwordInput, passwordError);
                    if (confirmPasswordInput.value.trim() !== '' && passwordInput.value.trim() === confirmPasswordInput.value.trim())
                        clearError(confirmPasswordInput, confirmPasswordError);
                });
                confirmPasswordInput.addEventListener('input', () => {
                    if (confirmPasswordInput.value.trim() !== '' && passwordInput.value.trim() === confirmPasswordInput.value.trim())
                        clearError(confirmPasswordInput, confirmPasswordError);
                });
                roleSelect.addEventListener('change', () => {
                    if (roleSelect.value !== '')
                        clearError(roleSelect, roleError);
                });
                companyNameInput.addEventListener('input', () => {
                    if (companyNameInput.value.trim() !== '')
                        clearError(companyNameInput, companyNameError);
                });
                serviceTypeInput.addEventListener('input', () => {
                    if (serviceTypeInput.value.trim() !== '')
                        clearError(serviceTypeInput, serviceTypeError);
                });
            });
        </script>
    </body>
</html>