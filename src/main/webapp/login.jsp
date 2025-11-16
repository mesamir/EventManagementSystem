<%-- 
    Document   : login
    Created on : Jul 18, 2025, 5:01:45 PM
    Author     : samir
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - EMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --accent-color: #ff6b6b;
            --light-grey: #f8f9fa;
            --dark-color: #343a40;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --text-color: #333;
            --font-family: 'Poppins', sans-serif;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: var(--font-family);
            line-height: 1.6;
            color: var(--text-color);
            background-color: var(--light-grey);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Header & Navigation */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 5%;
            background: #fff;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            padding: 0.7rem 5%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
        }

        .logo-img {
            height: 50px;
            width: auto;
            transition: all 0.3s;
        }

        .nav-menu {
            display: flex;
        }

        .nav-links {
            display: flex;
            list-style: none;
            align-items: center;
            gap: 2rem;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
            position: relative;
        }

        .nav-links a:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -5px;
            left: 0;
            background-color: var(--primary-color);
            transition: width 0.3s;
        }

        .nav-links a:hover:after {
            width: 100%;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-links a:hover, .nav-links a.active {
            color: var(--primary-color);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 5px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s;
            cursor: pointer;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }

        .hamburger {
            display: none;
            cursor: pointer;
            font-size: 1.5rem;
        }

        



        .btn-secondary {
            background: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            background: #545b62;
            transform: translateY(-2px);
        }

        /* Login Container */
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: calc(100vh - 180px);
            padding: 120px 20px 40px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        }

        .login-box {
            background-color: #fff;
            padding: 50px 40px;
            border-radius: 15px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .login-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
        }

        .login-box h2 {
            font-size: 2.2rem;
            color: var(--dark-color);
            margin-bottom: 10px;
            position: relative;
            display: inline-block;
        }

        .login-box h2:after {
            content: '';
            position: absolute;
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), #00c6ff);
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }

        .login-subtitle {
            color: var(--secondary-color);
            margin-bottom: 35px;
            font-size: 1.1rem;
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

        .form-group input[type="email"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 14px 18px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: var(--font-family);
            font-size: 1em;
            box-sizing: border-box;
            transition: all 0.3s ease;
            background: #f9f9f9;
        }

        .form-group input[type="email"]:focus,
        .form-group input[type="password"]:focus {
            border-color: var(--primary-color);
            outline: none;
            background: white;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }

        .login-box .btn {
            width: 100%;
            padding: 15px;
            font-size: 1.1em;
            margin-top: 10px;
            border-radius: 8px;
        }

        .links-container {
            margin-top: 25px;
            font-size: 0.95em;
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .links-container a {
            color: var(--primary-color);
            text-decoration: none;
            transition: color 0.3s ease;
            font-weight: 500;
        }

        .links-container a:hover {
            color: #0056b3;
            text-decoration: underline;
        }

        /* Messages */
        .server-error {
            background: #f8d7da;
            color: #721c24;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
        }

        .success-message {
            background: #d1edff;
            color: #155724;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid var(--primary-color);
        }

        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 5px;
            display: block;
        }

        .form-group input.invalid {
            border-color: #dc3545;
            background: #f8d7da;
        }

        /* Footer */
        footer {
            background: #2c3e50;
            color: white;
            padding: 4rem 1rem 1rem;
            margin-top: auto;
        }

        .footer-columns {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2.5rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-column h4 {
            margin-bottom: 1.5rem;
            color: #fff;
            font-size: 1.3rem;
            position: relative;
            padding-bottom: 0.5rem;
        }

        .footer-column h4:after {
            content: '';
            position: absolute;
            width: 40px;
            height: 3px;
            background: var(--primary-color);
            bottom: 0;
            left: 0;
        }

        .footer-column ul {
            list-style: none;
        }

        .footer-column ul li {
            margin-bottom: 0.8rem;
        }

        .footer-column a {
            color: #bdc3c7;
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-column a:hover {
            color: var(--primary-color);
            padding-left: 5px;
        }

        .footer-column p {
            color: #bdc3c7;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .social-icons {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .social-icons a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            background: #34495e;
            border-radius: 50%;
            transition: all 0.3s;
            color: white;
            font-size: 1.2rem;
        }

        .social-icons a:hover {
            background: var(--primary-color);
            transform: translateY(-5px);
        }

        .footer-bottom {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #34495e;
            color: #bdc3c7;
            font-size: 0.9rem;
        }

        /* Animations */
        .animate-fadeIn {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.6s ease-out;
        }

        .animate-fadeIn.visible {
            opacity: 1;
            transform: translateY(0);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hamburger {
                display: block;
            }

            .nav-menu {
                position: fixed;
                top: 70px;
                left: -100%;
                width: 100%;
                background: white;
                transition: left 0.3s;
                box-shadow: 0 5px 10px rgba(0,0,0,0.1);
                z-index: 999;
            }

            .nav-menu.active {
                left: 0;
            }

            .nav-links {
                flex-direction: column;
                padding: 2rem;
                gap: 1.5rem;
                width: 100%;
            }

            .login-container {
                padding: 100px 15px 30px;
            }

            .login-box {
                padding: 40px 30px;
            }

            .login-box h2 {
                font-size: 1.8rem;
            }

            .links-container {
                flex-direction: column;
                gap: 10px;
            }
        }

        @media (max-width: 576px) {
            .login-box {
                padding: 30px 20px;
            }

            .login-box h2 {
                font-size: 1.6rem;
            }

            .footer-columns {
                grid-template-columns: 1fr;
            }
        }
        
    </style>
</head>
<body>

    <!-- Header Section -->
    <header>
        <nav class="navbar">
            <div class="logo">
                <a href="index.html"><img class="logo-img" src="images/logo.jpg" alt="EMS-Logo"></a>
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
                    <li><a href="login.jsp" class="active"> <button class="btn btn-primary"><i class="fas fa-user-circle"></i>Login</button></a></li>
                </ul>                 
            </div>
        </nav>
    </header>

    <!-- Main Content Area -->
    <main>
        <section class="login-container">
            <div class="login-box animate-fadeIn">
                <h2>Welcome Back</h2>
                <p class="login-subtitle">Sign in to your EMS account</p>

                <%-- Display server-side error message if present --%>
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="server-error">
                        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                <% if (request.getParameter("registrationSuccess") != null) { %>
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i> Registration successful! Please log in.
                    </div>
                <% } %>

                <form id="loginForm" action="login" method="POST" novalidate>
                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
                        <input type="email" id="email" name="email" required autocomplete="username" placeholder="Enter your email">
                        <span class="error-message" id="emailError"></span>
                    </div>
                    <div class="form-group">
                        <label for="password"><i class="fas fa-lock"></i> Password</label>
                        <input type="password" id="password" name="password" required autocomplete="current-password" placeholder="Enter your password">
                        <span class="error-message" id="passwordError"></span>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i> Login to Your Account
                    </button>
                </form>
                <div class="links-container">
                    <a href="forgot-password.jsp"><i class="fas fa-key"></i> Forgot Password?</a>
                    <a href="registration.jsp"><i class="fas fa-user-plus"></i> Create New Account</a>
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
            &copy; 2025 EMS - Event Management System. All Rights Reserved.
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Hamburger menu functionality
            const hamburger = document.getElementById('hamburger-menu');
            const navMenu = document.getElementById('nav-menu');

            hamburger.addEventListener('click', function() {
                navMenu.classList.toggle('active');
                hamburger.innerHTML = navMenu.classList.contains('active') 
                    ? '<i class="fas fa-times"></i>' 
                    : '<i class="fas fa-bars"></i>';
            });

            // Navbar scroll effect
            window.addEventListener('scroll', function() {
                const navbar = document.querySelector('.navbar');
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            });

            // Form validation
            const form = document.getElementById('loginForm');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const emailError = document.getElementById('emailError');
            const passwordError = document.getElementById('passwordError');

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

            form.addEventListener('submit', function(event) {
                let isValid = true;

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
                } else {
                    clearError(passwordInput, passwordError);
                }

                if (!isValid) {
                    event.preventDefault();
                }
            });

            // Real-time validation feedback
            emailInput.addEventListener('input', () => {
                if (emailInput.value.trim() !== '' && validateEmail(emailInput.value.trim())) {
                    clearError(emailInput, emailError);
                }
            });
            
            passwordInput.addEventListener('input', () => {
                if (passwordInput.value.trim() !== '') {
                    clearError(passwordInput, passwordError);
                }
            });

            // Animation on load
            const loginBox = document.querySelector('.login-box');
            setTimeout(() => {
                loginBox.classList.add('visible');
            }, 100);
        });
    </script>

</body>
</html>