<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - EMS</title>
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

        html, body {
            max-width: 100%;
            overflow-x: hidden;
        }

        body {
            font-family: var(--font-family);
            line-height: 1.6;
            color: var(--text-color);
            background-color: var(--light-grey);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            width: 100%;
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

        .nav-links a:hover {
            color: var(--primary-color);
        }

        .nav-links a.active {
            color: var(--primary-color);
        }

        .nav-links a.active:after {
            width: 100%;
        }

        .hamburger {
            display: none;
            cursor: pointer;
            font-size: 1.5rem;
        }

        /* Buttons */
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
            font-size: 1rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), #0056b3);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
        }

        .btn-secondary {
            background: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            background: #545b62;
            transform: translateY(-2px);
        }

        /* Main Content */
        .section {
            padding: 120px 5% 60px;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }

        .section-title {
            font-size: 2.8rem;
            text-align: center;
            margin-bottom: 3rem;
            color: var(--dark-color);
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .section-title:after {
            content: '';
            position: absolute;
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), #00c6ff);
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }

        /* Contact Container */
        .contact-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 50px;
            margin-top: 30px;
            width: 100%;
        }

        /* Contact Info */
        .contact-info {
            background: white;
            padding: 40px 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            height: fit-content;
        }

        .contact-info h3 {
            font-size: 1.8rem;
            color: var(--dark-color);
            margin-bottom: 30px;
            position: relative;
            display: inline-block;
        }

        .contact-info h3:after {
            content: '';
            position: absolute;
            width: 40px;
            height: 3px;
            background: var(--primary-color);
            bottom: -8px;
            left: 0;
            border-radius: 2px;
        }

        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 25px;
            padding-bottom: 25px;
            border-bottom: 1px solid #eee;
        }

        .info-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .info-item i {
            font-size: 1.2rem;
            color: var(--primary-color);
            margin-top: 3px;
            min-width: 20px;
        }

        .info-item p {
            color: #555;
            line-height: 1.6;
            font-size: 1rem;
        }

        /* Contact Form */
        .contact-form {
            background: white;
            padding: 40px 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        }

        .contact-form h3 {
            font-size: 1.8rem;
            color: var(--dark-color);
            margin-bottom: 30px;
            position: relative;
            display: inline-block;
        }

        .contact-form h3:after {
            content: '';
            position: absolute;
            width: 40px;
            height: 3px;
            background: var(--primary-color);
            bottom: -8px;
            left: 0;
            border-radius: 2px;
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

        .form-group input,
        .form-group textarea {
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

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--primary-color);
            outline: none;
            background: white;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }

        .form-group textarea {
            height: 150px;
            resize: vertical;
            min-height: 120px;
        }

        .contact-form .btn {
            width: 100%;
            padding: 15px;
            font-size: 1.1em;
            margin-top: 10px;
            border-radius: 8px;
        }

        /* Status Messages */
        .status-message {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-weight: 500;
        }

        .status-message.success {
            background: #d1edff;
            color: #155724;
            border-left: 4px solid var(--success-color);
        }

        .status-message.error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 5px;
            display: block;
        }

        .form-group input.invalid,
        .form-group textarea.invalid {
            border-color: #dc3545;
            background: #f8d7da;
        }

        /* Social Icons */
        .social-icons {
            display: flex;
            gap: 1rem;
        }

        .social-icons a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 45px;
            height: 45px;
            background: #f8f9fa;
            border-radius: 50%;
            transition: all 0.3s;
            color: var(--primary-color);
            font-size: 1.2rem;
            border: 2px solid #e9ecef;
        }

        .social-icons a:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-3px);
            border-color: var(--primary-color);
        }

        /* Footer */
        footer {
            background: #2c3e50;
            color: white;
            padding: 4rem 5% 1rem;
            margin-top: auto;
            width: 100%;
        }

        .footer-columns {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2.5rem;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
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

        .footer-bottom {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #34495e;
            color: #bdc3c7;
            font-size: 0.9rem;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            width: 100%;
        }

        /* Animations */
        .animate-fadeInDown {
            opacity: 0;
            transform: translateY(-30px);
            animation: fadeInDown 0.8s ease-out forwards;
        }

        .animate-slideInLeft {
            opacity: 0;
            transform: translateX(-50px);
            animation: slideInLeft 0.8s ease-out forwards;
        }

        .animate-slideInRight {
            opacity: 0;
            transform: translateX(50px);
            animation: slideInRight 0.8s ease-out forwards;
        }

        .section-animated {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.8s ease-out;
        }

        .section-animated.visible {
            opacity: 1;
            transform: translateY(0);
        }

        @keyframes fadeInDown {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes slideInLeft {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideInRight {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .contact-container {
                grid-template-columns: 1fr;
                gap: 40px;
            }
            
            .contact-info,
            .contact-form {
                padding: 30px 25px;
            }
        }

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

            .section {
                padding: 100px 4% 40px;
            }

            .section-title {
                font-size: 2.2rem;
            }

            .contact-info h3,
            .contact-form h3 {
                font-size: 1.6rem;
            }
            
            footer {
                padding: 4rem 4% 1rem;
            }
        }

        @media (max-width: 576px) {
            .section {
                padding: 100px 3% 30px;
            }
            
            .section-title {
                font-size: 2rem;
                padding: 0 10px;
            }

            .contact-info,
            .contact-form {
                padding: 25px 20px;
            }

            .contact-info h3,
            .contact-form h3 {
                font-size: 1.4rem;
            }

            .info-item {
                flex-direction: column;
                gap: 10px;
            }

            .social-icons {
                justify-content: center;
            }
            
            footer {
                padding: 3rem 3% 1rem;
            }
        }

        @media (max-width: 375px) {
            .section {
                padding: 100px 2% 25px;
            }
            
            .contact-info,
            .contact-form {
                padding: 20px 15px;
            }
            
            .section-title {
                font-size: 1.8rem;
            }
            
            footer {
                padding: 2rem 2% 1rem;
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
                    <li><a href="contact.jsp" class="active">Contact Us</a></li>
                    <li><a href="login.jsp"> <button class="btn btn-primary"><i class="fas fa-user-circle"></i>Login</button></a></li>
                </ul>                 
            </div>
        </nav>
    </header>

    <!-- Main Content Area -->
    <main>
        <section class="section section-animated">
            <h2 class="section-title animate-fadeInDown">Get in Touch with EMS</h2>
            <div class="contact-container">
                <div class="contact-info animate-slideInLeft">
                    <h3>Our Contact Details</h3>
                    <div class="info-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <p>EMS Headquarters, Kathmandu, Nepal</p>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-phone"></i>
                        <p>+977 9876543210 (General Inquiries)</p>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <p>info@ems.com.np (Support)</p>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-clock"></i>
                        <p>Mon - Fri: 9:00 AM - 5:00 PM (NPT)</p>
                    </div>
                    <div class="social-icons" style="justify-content: flex-start; margin-top: 30px;">
                        <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                        <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                        <a href="#" aria-label="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="contact-form animate-slideInRight">
                    <h3>Send Us a Message</h3>

                    <%-- Display server-side messages --%>
                    <c:if test="${not empty param.successMessage}">
                        <div class="status-message success">
                            <c:out value="${param.successMessage}" />
                        </div>
                    </c:if>
                    <c:if test="${not empty param.errorMessage}">
                        <div class="status-message error">
                            <c:out value="${param.errorMessage}" escapeXml="false" />
                        </div>
                    </c:if>

                    <form id="contactForm" action="<%= request.getContextPath() %>/contact-submit" method="POST" novalidate>
                        <div class="form-group">
                            <label for="name">Your Name</label>
                            <input type="text" id="name" name="name" value="<c:out value="${name}" />" required>
                            <span class="error-message" id="nameError"></span>
                        </div>
                        <div class="form-group">
                            <label for="email">Your Email</label>
                            <input type="email" id="email" name="email" value="<c:out value="${email}" />" required>
                            <span class="error-message" id="emailError"></span>
                        </div>
                        <div class="form-group">
                            <label for="subject">Subject</label>
                            <input type="text" id="subject" name="subject" value="<c:out value="${subject}" />" required>
                            <span class="error-message" id="subjectError"></span>
                        </div>
                        <div class="form-group">
                            <label for="message">Your Message</label>
                            <textarea id="message" name="message" required><c:out value="${message}" /></textarea>
                            <span class="error-message" id="messageError"></span>
                        </div>
                        <button type="submit" class="btn btn-primary">Send Message</button>
                    </form>
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

            // Client-side form validation
            const form = document.getElementById('contactForm');
            if (form) {
                const nameInput = document.getElementById('name');
                const emailInput = document.getElementById('email');
                const subjectInput = document.getElementById('subject');
                const messageInput = document.getElementById('message');

                const nameError = document.getElementById('nameError');
                const emailError = document.getElementById('emailError');
                const subjectError = document.getElementById('subjectError');
                const messageError = document.getElementById('messageError');

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

                form.addEventListener('submit', function(event) {
                    let isValid = true;

                    // Clear all previous errors
                    document.querySelectorAll('.error-message').forEach(span => span.textContent = '');
                    document.querySelectorAll('input, textarea').forEach(input => input.classList.remove('invalid'));

                    // Validate Name
                    if (nameInput.value.trim() === '') {
                        showError(nameInput, 'Your Name is required.', nameError);
                        isValid = false;
                    }

                    // Validate Email
                    if (emailInput.value.trim() === '') {
                        showError(emailInput, 'Your Email is required.', emailError);
                        isValid = false;
                    } else if (!isValidEmail(emailInput.value.trim())) {
                        showError(emailInput, 'Please enter a valid email address.', emailError);
                        isValid = false;
                    }

                    // Validate Subject
                    if (subjectInput.value.trim() === '') {
                        showError(subjectInput, 'Subject is required.', subjectError);
                        isValid = false;
                    }

                    // Validate Message
                    if (messageInput.value.trim() === '') {
                        showError(messageInput, 'Message is required.', messageError);
                        isValid = false;
                    }

                    if (!isValid) {
                        event.preventDefault();
                    }
                });

                // Real-time validation feedback
                nameInput.addEventListener('input', () => { if (nameInput.value.trim() !== '') clearError(nameInput, nameError); });
                emailInput.addEventListener('input', () => {
                    if (emailInput.value.trim() !== '' && isValidEmail(emailInput.value.trim())) clearError(emailInput, emailError);
                });
                subjectInput.addEventListener('input', () => { if (subjectInput.value.trim() !== '') clearError(subjectInput, subjectError); });
                messageInput.addEventListener('input', () => { if (messageInput.value.trim() !== '') clearError(messageInput, messageError); });
            }

            // Intersection Observer for scroll animations
            const observerOptions = {
                root: null,
                rootMargin: '0px',
                threshold: 0.1
            };

            const observer = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('visible');
                        observer.unobserve(entry.target);
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.section-animated').forEach(section => {
                observer.observe(section);
            });
        });
    </script>
</body>
</html>