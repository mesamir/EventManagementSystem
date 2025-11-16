%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Services - EMS</title>
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
            margin-bottom: 1rem;
            color: var(--dark-color);
            position: relative;
            display: block;
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

        .section-subtitle {
            text-align: center;
            color: var(--secondary-color);
            margin-bottom: 60px;
            font-size: 1.1rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.7;
        }

        /* Services Grid */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 40px;
            margin-bottom: 80px;
            width: 100%;
        }

        .service-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: all 0.4s ease;
            position: relative;
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .service-image {
            height: 250px;
            width: 100%;
            background: linear-gradient(135deg, var(--primary-color), #00c6ff);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 4rem;
            position: relative;
            overflow: hidden;
        }

        .service-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .service-card:hover .service-image img {
            transform: scale(1.1);
        }

        .service-content {
            padding: 30px;
        }

        .service-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary-color), #00c6ff);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.8rem;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }

        .service-content h3 {
            font-size: 1.6rem;
            color: var(--dark-color);
            margin-bottom: 15px;
            font-weight: 600;
        }

        .service-content p {
            color: #666;
            line-height: 1.7;
            margin-bottom: 20px;
            font-size: 1rem;
        }

        .service-features {
            list-style: none;
            margin-bottom: 25px;
        }

        .service-features li {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: #555;
            font-size: 0.95rem;
        }

        .service-features li i {
            color: var(--success-color);
            font-size: 0.9rem;
        }

        .service-price {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .service-price span {
            font-size: 0.9rem;
            color: var(--secondary-color);
            font-weight: 400;
        }

        /* Process Section */
        .process-section {
            background: linear-gradient(135deg, var(--primary-color), #00c6ff);
            padding: 80px 5%;
            margin: 80px 0;
            border-radius: 15px;
            color: white;
            text-align: center;
            width: 100%;
        }

        .process-title {
            font-size: 2.2rem;
            margin-bottom: 50px;
            font-weight: 600;
        }

        .process-steps {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            max-width: 1000px;
            margin: 0 auto;
            width: 100%;
        }

        .process-step {
            text-align: center;
        }

        .step-number {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 700;
            margin: 0 auto 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }

        .process-step h4 {
            font-size: 1.3rem;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .process-step p {
            opacity: 0.9;
            line-height: 1.6;
        }

        /* CTA Section */
        .cta-section {
            text-align: center;
            padding: 60px 5%;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            margin-bottom: 80px;
        }

        .cta-section h2 {
            font-size: 2.2rem;
            color: var(--dark-color);
            margin-bottom: 20px;
        }

        .cta-section p {
            color: var(--secondary-color);
            margin-bottom: 30px;
            font-size: 1.1rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.7;
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

        .animate-fadeInUp {
            opacity: 0;
            transform: translateY(30px);
            animation: fadeInUp 0.8s ease-out forwards;
        }

        .animate-zoomIn {
            opacity: 0;
            transform: scale(0.9);
            animation: zoomIn 0.6s ease-out forwards;
        }

        .delay-1 { animation-delay: 0.2s; }
        .delay-2 { animation-delay: 0.4s; }
        .delay-3 { animation-delay: 0.6s; }

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

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes zoomIn {
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .section {
                padding: 120px 4% 60px;
            }
            
            .services-grid {
                grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            }
        }

        @media (max-width: 992px) {
            .services-grid {
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 30px;
            }
            
            .process-steps {
                grid-template-columns: repeat(2, 1fr);
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

            .section-subtitle {
                font-size: 1rem;
                padding: 0 10px;
            }

            .services-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }

            .service-content {
                padding: 25px;
            }

            .process-section {
                padding: 60px 4%;
                margin: 60px 0;
            }

            .process-title {
                font-size: 1.8rem;
            }

            .process-steps {
                grid-template-columns: 1fr;
                gap: 30px;
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

            .service-image {
                height: 200px;
            }

            .service-content {
                padding: 20px;
            }

            .service-content h3 {
                font-size: 1.4rem;
            }

            .cta-section {
                padding: 40px 20px;
            }

            .cta-section h2 {
                font-size: 1.8rem;
            }
            
            .footer-columns {
                grid-template-columns: 1fr;
            }
            
            footer {
                padding: 3rem 3% 1rem;
            }
        }

        @media (max-width: 375px) {
            .section {
                padding: 100px 2% 25px;
            }
            
            .section-title {
                font-size: 1.8rem;
            }
            
            .services-grid {
                gap: 25px;
            }
            
            .service-card {
                margin: 0 5px;
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
                    <li><a href="services.jsp" class="active">Our Services</a></li>
                    <li><a href="vendors">Our Vendors</a></li>
                    <li><a href="gallery.html">Gallery</a></li>
                    <li><a href="blog.jsp">Blog</a></li>
                    <li><a href="contact.jsp">Contact Us</a></li>
                    <li><a href="login.jsp"> <button class="btn btn-primary"><i class="fas fa-user-circle"></i>Login</button></a></li>
                </ul>                 
            </div>
        </nav>
    </header>

    <main>
        <section class="section section-animated">
            <h2 class="section-title animate-fadeInDown">Our Premium Services</h2>
            <p class="section-subtitle animate-fadeInUp">
                Discover our comprehensive range of event management services designed to make your special occasions truly memorable and stress-free
            </p>

            <!-- Services Grid - Dynamic -->
            <div class="services-grid">
                <c:forEach var="service" items="${services}" varStatus="loop">
                    <div class="service-card animate-zoomIn <c:if test="${loop.index >= 3}">delay-1</c:if>">
                        <div class="service-image">
                            <c:choose>
                                <c:when test="${not empty service.imageUrl}">
                                    <img src="${service.imageUrl}" alt="${service.name}">
                                </c:when>
                                <c:otherwise>
                                    <i class="${service.iconClass}"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="service-content">
                            <div class="service-icon">
                                <i class="${service.iconClass}"></i>
                            </div>
                            <h3>${service.name}</h3>
                            <p>${service.description}</p>
                            
                            <ul class="service-features">
                                <c:forEach var="feature" items="${service.features}">
                                    <li>
                                        <i class="${feature.iconClass}"></i> 
                                        ${feature.featureText}
                                    </li>
                                </c:forEach>
                            </ul>
                            
                            <div class="service-price">
                                Starting from 
                                <span>
                                    <c:choose>
                                        <c:when test="${service.currency == 'USD'}">$${service.basePrice}</c:when>
                                        <c:otherwise>NPR <fmt:formatNumber value="${service.basePrice}" type="number" maxFractionDigits="2"/></c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            
                            <c:choose>
                                <c:when test="${service.name == 'Vendor Management'}">
                                    <a href="vendors" class="btn btn-primary">
                                        <i class="fas fa-handshake"></i> Explore Vendors
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="contact.jsp?service=${service.name}" class="btn btn-primary">
                                        <i class="fas fa-calendar-check"></i> Plan ${service.name}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Process Section - Dynamic -->
            <div class="process-section animate-fadeInUp">
                <h3 class="process-title">Our Simple ${processSteps.size()}-Step Process</h3>
                <div class="process-steps">
                    <c:forEach var="step" items="${processSteps}">
                        <div class="process-step">
                            <div class="step-number">${step.stepNumber}</div>
                            <h4>${step.title}</h4>
                            <p>${step.description}</p>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- CTA Section -->
            <div class="cta-section animate-fadeInUp">
                <h2>Ready to Plan Your Perfect Event?</h2>
                <p>Let us handle the details while you enjoy the moments that matter. Contact us today for a free consultation and personalized quote.</p>
                <a href="contact.jsp" class="btn btn-primary" style="font-size: 1.1rem; padding: 15px 30px;">
                    <i class="fas fa-calendar-plus"></i> Get Free Consultation
                </a>
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
                    <c:forEach var="service" items="${services}" end="3">
                        <li><a href="services.jsp#service-${service.id}">${service.name}</a></li>
                    </c:forEach>
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
        // Your existing JavaScript remains the same
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