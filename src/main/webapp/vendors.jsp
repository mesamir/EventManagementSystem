<%-- 
    Document   : vendors
    Created on : Jul 26, 2025, 10:11:42 AM
    Author     : samir
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Vendors - EMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style.css">
    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --accent-color: #ff6b6b;
            --light-grey: #f8f9fa;
            --dark-color: #343a40;
            --success-color: #28a745;
            --warning-color: #ffc107;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-grey);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            color: #333;
            line-height: 1.6;
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

        .btn-small {
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
        }

        .btn-outline {
            background: transparent;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-outline:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Main Content */
        .main-content {
            flex-grow: 1;
            padding: 120px 20px 40px;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }

        .page-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .page-header h1 {
            font-size: 2.8rem;
            color: var(--dark-color);
            margin-bottom: 15px;
            position: relative;
            display: inline-block;
        }

        .page-header h1:after {
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

        .page-header p {
            font-size: 1.2rem;
            color: var(--secondary-color);
            max-width: 700px;
            margin: 0 auto;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            margin-bottom: 40px;
        }

        .filter-title {
            font-size: 1.3rem;
            color: var(--dark-color);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-options {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .filter-group label {
            font-weight: 500;
            color: var(--secondary-color);
            font-size: 0.9rem;
        }

        .filter-select, .filter-input {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            background: white;
            transition: all 0.3s;
        }

        .filter-select:focus, .filter-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }

        .search-box {
            position: relative;
            flex-grow: 1;
            max-width: 400px;
        }

        .search-box input {
            width: 100%;
            padding-left: 45px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
        }

        /* Vendor Grid */
        .vendor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }

        .vendor-card {
            background-color: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: transform 0.4s, box-shadow 0.4s;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .vendor-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .vendor-image {
            height: 200px;
            width: 100%;
            background: linear-gradient(135deg, var(--primary-color), #00c6ff);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .vendor-content {
            padding: 25px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .vendor-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .vendor-card h3 {
            color: var(--dark-color);
            font-size: 1.5rem;
            margin: 0;
            line-height: 1.3;
        }

        .vendor-rating {
            background: var(--warning-color);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .service-type {
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .vendor-details {
            margin-bottom: 20px;
            flex-grow: 1;
        }

        .vendor-details p {
            font-size: 0.95rem;
            color: #555;
            margin-bottom: 10px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .vendor-details i {
            color: var(--primary-color);
            width: 16px;
            margin-top: 3px;
        }

        .vendor-description {
            margin: 15px 0;
            color: #666;
            line-height: 1.6;
            font-size: 0.95rem;
        }

        .price-range {
            font-weight: 600;
            color: var(--success-color);
            margin-bottom: 15px;
            font-size: 1.1rem;
        }

        .vendor-actions {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }

        .vendor-actions .btn {
            flex: 1;
            justify-content: center;
        }

        .portfolio-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s;
        }

        .portfolio-link a:hover {
            color: #0056b3;
        }

        /* No vendors message */
        .no-vendors {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
        }

        .no-vendors i {
            font-size: 4rem;
            color: var(--secondary-color);
            margin-bottom: 20px;
        }

        .no-vendors h3 {
            font-size: 1.8rem;
            color: var(--dark-color);
            margin-bottom: 15px;
        }

        .no-vendors p {
            font-size: 1.1rem;
            color: var(--secondary-color);
            max-width: 600px;
            margin: 0 auto 30px;
        }

        /* Footer */
        footer {
            background: #2c3e50;
            color: white;
            padding: 4rem 1rem 1rem;
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

        /* Responsive Design */
        @media (max-width: 992px) {
            .vendor-grid {
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
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

            .main-content {
                padding: 100px 15px 30px;
            }

            .page-header h1 {
                font-size: 2.2rem;
            }

            .filter-options {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                max-width: 100%;
            }

            .vendor-grid {
                grid-template-columns: 1fr;
            }

            .vendor-actions {
                flex-direction: column;
            }
        }

        @media (max-width: 576px) {
            .page-header h1 {
                font-size: 1.8rem;
            }

            .vendor-card {
                padding: 20px;
            }

            .vendor-header {
                flex-direction: column;
                gap: 10px;
            }

            .vendor-rating {
                align-self: flex-start;
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
                    <li><a href="vendors"class="active">Our Vendors</a></li>
                    <li><a href="gallery.html">Gallery</a></li>
                    <li><a href="blog.jsp">Blog</a></li>
                    <li><a href="contact.jsp">Contact Us</a></li>
                    <li><a href="login.jsp"> <button class="btn btn-primary"><i class="fas fa-user-circle"></i>Login</button></a>
                </ul>      
        </nav>
    </header>

    <div class="main-content">
        <div class="page-header">
            <h1>Our Trusted Vendors</h1>
            <p>Discover our curated network of professional vendors ready to make your event unforgettable</p>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <h3 class="filter-title"><i class="fas fa-filter"></i> Filter Vendors</h3>
            <div class="filter-options">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="vendor-search" class="filter-input" placeholder="Search vendors...">
                </div>
                <div class="filter-group">
                    <label for="service-filter">Service Type</label>
                    <select id="service-filter" class="filter-select">
                        <option value="all">All Services</option>
                        <option value="catering">Catering</option>
                        <option value="photography">Photography</option>
                        <option value="venue">Venue</option>
                        <option value="decoration">Decoration</option>
                        <option value="music">Music & Entertainment</option>
                        <option value="florist">Florist</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="price-filter">Price Range</label>
                    <select id="price-filter" class="filter-select">
                        <option value="all">Any Price</option>
                        <option value="budget">Budget (Under NPR 50,000)</option>
                        <option value="medium">Medium (NPR 50,000 - 200,000)</option>
                        <option value="premium">Premium (Over NPR 200,000)</option>
                    </select>
                </div>
                <button class="btn btn-primary" id="apply-filters">Apply Filters</button>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty vendors}">
                <div class="vendor-grid" id="vendor-container">
                    <c:forEach var="vendor" items="${vendors}">
                        <div class="vendor-card" data-service="${vendor.serviceType.toLowerCase()}" data-price="${vendor.minPrice}">
                            <div class="vendor-image">
                                <i class="fas fa-<c:choose>
                                    <c:when test="${vendor.serviceType eq 'Catering'}">utensils</c:when>
                                    <c:when test="${vendor.serviceType eq 'Photography'}">camera</c:when>
                                    <c:when test="${vendor.serviceType eq 'Venue'}">building</c:when>
                                    <c:when test="${vendor.serviceType eq 'Decoration'}">palette</c:when>
                                    <c:when test="${vendor.serviceType eq 'Music'}">music</c:when>
                                    <c:when test="${vendor.serviceType eq 'Florist'}">seedling</c:when>
                                    <c:otherwise>store</c:otherwise>
                                </c:choose>"></i>
                            </div>
                            <div class="vendor-content">
                                <div class="vendor-header">
                                    <h3><c:out value="${vendor.companyName}" /></h3>
                                    <div class="vendor-rating">
                                        <i class="fas fa-star"></i>
                                        <span>4.8</span>
                                    </div>
                                </div>
                                <p class="service-type"><i class="fas fa-tag"></i> <c:out value="${vendor.serviceType}" /></p>
                                
                                <div class="vendor-details">
                                    <p><i class="fas fa-user"></i> <strong>Contact:</strong> <c:out value="${vendor.contactPerson}" /></p>
                                    <p><i class="fas fa-phone"></i> <c:out value="${vendor.phone}" /></p>
                                    <p><i class="fas fa-envelope"></i> <c:out value="${vendor.email}" /></p>
                                    <p><i class="fas fa-map-marker-alt"></i> <c:out value="${vendor.address}" /></p>
                                </div>
                                
                                <div class="vendor-description">
                                    <p><c:out value="${vendor.description}" /></p>
                                </div>
                                
                                <p class="price-range"><i class="fas fa-tag"></i> NPR <c:out value="${vendor.minPrice}" /> - NPR <c:out value="${vendor.maxPrice}" /></p>
                                
                                <div class="vendor-actions">
                                    <a href="<%= request.getContextPath() %>/contact?vendorId=${vendor.vendorId}" class="btn btn-primary btn-small">
                                        <i class="fas fa-envelope"></i> Contact
                                    </a>
                                    <c:if test="${not empty vendor.portfolioLink}">
                                        <a href="<c:url value="${vendor.portfolioLink}" />" target="_blank" class="btn btn-outline btn-small">
                                            <i class="fas fa-external-link-alt"></i> Portfolio
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-vendors">
                    <i class="fas fa-users-slash"></i>
                    <h3>No Approved Vendors Available</h3>
                    <p>We're currently updating our vendor network. Please check back later to discover our trusted partners who can help make your event unforgettable.</p>
                    <a href="contact.jsp" class="btn btn-primary">Contact Us for Recommendations</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

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
        // Hamburger menu functionality
        document.addEventListener('DOMContentLoaded', function() {
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

            // Vendor filtering functionality
            const vendorCards = document.querySelectorAll('.vendor-card');
            const searchInput = document.getElementById('vendor-search');
            const serviceFilter = document.getElementById('service-filter');
            const priceFilter = document.getElementById('price-filter');
            const applyFiltersBtn = document.getElementById('apply-filters');

            function filterVendors() {
                const searchTerm = searchInput.value.toLowerCase();
                const serviceValue = serviceFilter.value;
                const priceValue = priceFilter.value;
                
                vendorCards.forEach(card => {
                    const vendorName = card.querySelector('h3').textContent.toLowerCase();
                    const vendorService = card.dataset.service;
                    const vendorPrice = parseInt(card.dataset.price);
                    
                    let matchesSearch = vendorName.includes(searchTerm);
                    let matchesService = serviceValue === 'all' || vendorService.includes(serviceValue);
                    let matchesPrice = true;
                    
                    if (priceValue !== 'all') {
                        if (priceValue === 'budget') {
                            matchesPrice = vendorPrice < 50000;
                        } else if (priceValue === 'medium') {
                            matchesPrice = vendorPrice >= 50000 && vendorPrice <= 200000;
                        } else if (priceValue === 'premium') {
                            matchesPrice = vendorPrice > 200000;
                        }
                    }
                    
                    if (matchesSearch && matchesService && matchesPrice) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }

            // Event listeners for filtering
            searchInput.addEventListener('input', filterVendors);
            applyFiltersBtn.addEventListener('click', filterVendors);
            
            // Also filter when select values change
            serviceFilter.addEventListener('change', filterVendors);
            priceFilter.addEventListener('change', filterVendors);
        });
    </script>
</body>
</html>