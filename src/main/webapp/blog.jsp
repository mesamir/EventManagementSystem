<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blog - Event Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --accent-color: #ff6b6b;
            --light-grey: #f8f9fa;
            --dark-color: #343a40;
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
        }

        .logo-img {
            height: 50px;
            width: auto;
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

        /* Main Content */
     .section {
            padding: 120px 5% 80px;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }

        .section-title {
            font-size: 3rem;
            text-align: center;
            margin-bottom: 1.5rem;
            color: var(--dark-color);
            font-weight: 700;
            line-height: 1.2;
            letter-spacing: -0.5px;
        }

        .section-subtitle {
            text-align: center;
            color: var(--secondary-color);
            margin-bottom: 4rem;
            font-size: 1.2rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.7;
            font-weight: 400;
        }

/* Blog Layout */
.blog-container {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 40px;
    margin-bottom: 60px;
    align-items: start;
}

/* Blog Posts */
.blog-posts {
    display: flex;
    flex-direction: column;
    gap: 30px;
}

.blog-post {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;
    border: 1px solid #f0f0f0;
    margin: 0  0 20px 20px;
}

.blog-post:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.post-image {
    height: 250px;
    width: 100%;
    position: relative;
    overflow: hidden;
}

.post-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.4s ease;
}

.blog-post:hover .post-image img {
    transform: scale(1.03);
}

.post-category {
    position: absolute;
    top: 15px;
    left: 15px;
    background: var(--primary-color);
    color: white;
    padding: 6px 12px;
    border-radius: 16px;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.post-content {
    padding: 25px;
}

.post-meta {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-bottom: 12px;
    font-size: 0.85rem;
    color: var(--secondary-color);
    flex-wrap: wrap;
}

.post-meta span {
    display: flex;
    align-items: center;
    gap: 5px;
}

.post-meta i {
    font-size: 0.8rem;
    opacity: 0.7;
}

.post-title {
    font-size: 1.4rem;
    color: var(--dark-color);
    margin-bottom: 12px;
    font-weight: 600;
    line-height: 1.3;
}

.post-excerpt {
    color: #666;
    line-height: 1.6;
    margin-bottom: 18px;
    font-size: 0.95rem;
}

.read-more {
    color: var(--primary-color);
    text-decoration: none;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 0.9rem;
    transition: all 0.2s ease;
}

.read-more:hover {
    color: var(--primary-hover);
    gap: 8px;
}

        /* Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        .sidebar-widget {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        }

        .widget-title {
            font-size: 1.3rem;
            color: var(--dark-color);
            margin-bottom: 20px;
            font-weight: 600;
        }

        /* Search Widget */
        .search-form {
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 12px 50px 12px 20px;
            border: 1px solid #e9ecef;
            border-radius: 30px;
            font-family: var(--font-family);
            font-size: 1rem;
        }

        .search-button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }

        /* Categories Widget */
        .categories-list {
            list-style: none;
        }

        .categories-list li {
            margin-bottom: 12px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f1f1f1;
        }

        .categories-list a {
            color: #555;
            text-decoration: none;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: color 0.3s;
        }

        .categories-list a:hover {
            color: var(--primary-color);
        }

        .category-count {
            background: var(--light-grey);
            color: var(--secondary-color);
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
        }

        /* Recent Posts Widget */
        .recent-posts {
            list-style: none;
        }

        .recent-post {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #f1f1f1;
        }

        .recent-post-image {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            overflow: hidden;
            flex-shrink: 0;
        }

        .recent-post-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .recent-post-content h4 {
            font-size: 0.95rem;
            margin-bottom: 5px;
            line-height: 1.4;
        }

        .recent-post-content span {
            font-size: 0.8rem;
            color: var(--secondary-color);
        }

        /* Tags Widget */
        .tags-cloud {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .tag {
            background: var(--light-grey);
            color: var(--secondary-color);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            text-decoration: none;
            transition: all 0.3s;
        }

        .tag:hover {
            background: var(--primary-color);
            color: white;
        }

        /* Loading States */
        .loading-container {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--secondary-color);
        }

        .loading-spinner {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
        }

        .error-container {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--secondary-color);
        }

        .no-content {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--secondary-color);
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 50px;
        }

        .page-number {
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: white;
            color: var(--dark-color);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        .page-number:hover, .page-number.active {
            background: var(--primary-color);
            color: white;
        }

        /* Footer */
        footer {
            background: #2c3e50;
            color: white;
            padding: 4rem 5% 1rem;
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
        }

        .social-icons a:hover {
            background: var(--primary-color);
        }

        .footer-bottom {
            text-align: center;
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #34495e;
            color: #bdc3c7;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .blog-container {
                grid-template-columns: 1fr;
            }
            
            .nav-links {
                display: none;
            }
            
            .section {
                padding: 100px 4% 40px;
            }
            
            .section-title {
                font-size: 2.2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <nav class="navbar">
            <div class="logo">
                <a href="index.html"><img class="logo-img" src="images/logo.jpg" alt="EMS-Logo" onerror="this.onerror=null;this.src='https://placehold.co/100x50/007bff/ffffff?text=EMS'"></a>
            </div>
            <ul class="nav-links">
                <li><a href="index.html">Home</a></li>
                <li><a href="about.html">About Us</a></li>
                <li><a href="services.jsp">Our Services</a></li>
                <li><a href="vendors">Our Vendors</a></li>
                <li><a href="gallery.html">Gallery</a></li>
                <li><a href="blog.jsp" class="active">Blog</a></li>
                <li><a href="contact.jsp">Contact Us</a></li>
                <li><a href="login.jsp"><button class="btn btn-primary"><i class="fas fa-user-circle"></i>Login</button></a></li>
            </ul>
        </nav>
    </header>

    <!-- Main Content -->
    <main>
        <section class="section">
            <h2 class="section-title">Event Planning Blog</h2>
            <p class="section-subtitle">
                Discover expert tips, latest trends, and inspiring ideas for your next event.
            </p>

            <div class="blog-container">
                <!-- Main Blog Content -->
                <div class="blog-posts">
                    <div id="blogPostsContainer">
                        <div class="loading-container">
                            <i class="fas fa-spinner fa-spin loading-spinner"></i>
                            <p>Loading blog posts...</p>
                        </div>
                    </div>
                </div>

                <!-- Sidebar -->
                <aside class="sidebar">
                    <!-- Search Widget -->
                    <div class="sidebar-widget">
                        <h3 class="widget-title">Search</h3>
                        <form class="search-form" onsubmit="return searchBlogs(event)">
                            <input type="text" class="search-input" placeholder="Search articles..." id="search-input">
                            <button type="submit" class="search-button">
                                <i class="fas fa-search"></i>
                            </button>
                        </form>
                    </div>

                    <!-- Categories Widget -->
                    <div class="sidebar-widget">
                        <h3 class="widget-title">Categories</h3>
                        <ul class="categories-list" id="categories-list">
                            <li>Loading categories...</li>
                        </ul>
                    </div>

                    <!-- Recent Posts Widget -->
                    <div class="sidebar-widget">
                        <h3 class="widget-title">Recent Posts</h3>
                        <ul class="recent-posts" id="recent-posts">
                            <li>Loading recent posts...</li>
                        </ul>
                    </div>

                    <!-- Tags Widget -->
                    <div class="sidebar-widget">
                        <h3 class="widget-title">Popular Tags 
                            <span id="filter-reset-btn" style="color:var(--accent-color); font-size: 0.9rem; margin-left:10px; cursor:pointer; display:none;">(Reset Filter)</span>
                        </h3>
                        <div class="tags-cloud" id="tags-cloud">
                            <span>Loading tags...</span>
                        </div>
                    </div>
                </aside>
            </div>

            <!-- Pagination -->
            <div class="pagination" id="pagination"></div>
        </section>
    </main>

    <!-- Footer -->
    <footer>
        <div class="footer-columns">
            <div class="footer-column">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="index.html">Home</a></li>
                    <li><a href="about.html">About Us</a></li>
                    <li><a href="services.jsp">Our Services</a></li>
                    <li><a href="gallery.html">Gallery</a></li>
                    <li><a href="blog.jsp">Blog</a></li>
                    <li><a href="contact.jsp">Contact Us</a></li>
                </ul>
            </div>
            <div class="footer-column">
                <h4>Our Services</h4>
                <ul>
                    <li><a href="services.jsp">Wedding Planning</a></li>
                    <li><a href="services.jsp">Corporate Events</a></li>
                    <li><a href="services.jsp">Private Parties</a></li>
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
                <div class="social-icons">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            &copy; 2025 EMS - Event Management System. All Rights Reserved.
        </div>
    </footer>

  <script>
// --- STATE VARIABLES ---
let currentPosts = [];
let currentPage = 1;
const postsPerPage = 4;
let currentFilter = { type: 'all', value: null };

// --- DOM ELEMENTS ---
const postsContainer = document.getElementById('blogPostsContainer');
const paginationContainer = document.getElementById('pagination');
const categoriesList = document.getElementById('categories-list');
const recentPostsList = document.getElementById('recent-posts');
const tagsCloud = document.getElementById('tags-cloud');
const filterResetBtn = document.getElementById('filter-reset-btn');
const searchForm = document.getElementById('search-form');
const searchInput = document.getElementById('search-input');

// --- API ENDPOINTS ---
const API_BASE = 'Blog';
const API_ENDPOINTS = {
    BLOGS: API_BASE,
    CATEGORIES: API_BASE + '?action=categories',
    RECENT_POSTS: API_BASE + '?action=recent',
    TAGS: API_BASE + '?action=tags'
};

// --- UTILITY FUNCTIONS ---

/**
 * Fetches data from the server with proper error handling
 */
const fetchData = async (url) => {
    try {
        console.log('Fetching data from:', url);
        const response = await fetch(url);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        console.log('API Response:', data);
        
        // Handle different response formats
        if (data.success === false) {
            throw new Error(data.message || 'API returned error');
        }
        
        return data;
    } catch (error) {
        console.error('Error fetching data from', url, ':', error);
        throw error;
    }
};

/**
 * Converts date string to a readable format
 */
const formatDate = (dateString) => {
    if (!dateString) return 'Recently';
    
    try {
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return 'Recently';
        
        return date.toLocaleDateString('en-US', {
            year: 'numeric', 
            month: 'short', 
            day: 'numeric'
        });
    } catch (error) {
        console.warn('Date formatting error:', error);
        return 'Recently';
    }
};

/**
 * Safely escapes HTML to prevent XSS
 */
const escapeHtml = (text) => {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
};

/**
 * URL encodes a string for use in URLs
 */
const encodeUriComponent = (str) => {
    if (!str) return '';
    return encodeURIComponent(str);
};

/**
 * Gets the correct image URL with context path
 */
const getImageUrl = (imagePath) => {
    if (!imagePath || imagePath.trim() === '') {
        return null;
    }

    // If it's already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return imagePath;
    }

    // Get context path from current URL
    const currentUrl = window.location.pathname;
    const contextPath = currentUrl.split('/')[1] || 'ems';

    // Build the correct URL
    let finalUrl;
    if (imagePath.startsWith('/')) {
        // Absolute path
        finalUrl = '/' + contextPath + imagePath;
    } else if (imagePath.startsWith('uploads/')) {
        // Relative uploads path
        finalUrl = '/' + contextPath + '/' + imagePath;
    } else {
        // Other relative paths
        finalUrl = '/' + contextPath + '/' + imagePath;
    }

    return finalUrl;
};

/**
 * Tests if an image exists
 */
const testImage = (url) => {
    return new Promise((resolve) => {
        if (!url) {
            resolve(false);
            return;
        }
        
        const img = new Image();
        img.onload = () => {
            console.log('Image loaded successfully:', url);
            resolve(true);
        };
        img.onerror = () => {
            console.log('Image failed to load:', url);
            resolve(false);
        };
        img.src = url;
        
        // Timeout after 2 seconds
        setTimeout(() => {
            console.log('Image load timeout:', url);
            resolve(false);
        }, 2000);
    });
};

/**
 * Generates the HTML for a single blog post card
 */
const generatePostCard = async (post) => {
    // Default fallback image based on category
    const category = post.category || 'Blog';
    const encodedCategory = encodeUriComponent(category);
    const fallbackImg = 'https://placehold.co/800x400/3498db/ffffff?text=' + encodedCategory;
    
    let imageUrl = getImageUrl(post.featuredImage);
    let finalImageUrl = fallbackImg;
    
    // Test if the actual image exists
    if (imageUrl) {
        try {
            const imageExists = await testImage(imageUrl);
            if (imageExists) {
                finalImageUrl = imageUrl;
            }
        } catch (error) {
            console.log('Image test failed for:', imageUrl, error);
        }
    }
    
    const formattedDate = formatDate(post.publishedAt);
    const author = post.author || 'Admin';
    const excerpt = post.excerpt || 'No excerpt available. Click to read more...';
    
    // Escape all user content
    const escapedTitle = escapeHtml(post.title);
    const escapedCategory = escapeHtml(category);
    const escapedFormattedDate = escapeHtml(formattedDate);
    const escapedAuthor = escapeHtml(author);
    const escapedExcerpt = escapeHtml(excerpt.length > 150 ? excerpt.substring(0, 150) + '...' : excerpt);
    const escapedSlug = escapeHtml(post.slug || '');
    
    return '<div class="blog-post bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">' +
           '<div class="post-image relative">' +
           '<img src="' + finalImageUrl + '" ' +
           'alt="' + escapedTitle + '" ' +
           'class="w-full h-48 object-cover" ' +
           'onerror="this.onerror=null; this.src=\'' + fallbackImg + '\'">' +
           '<span class="post-category absolute top-3 left-3 bg-primary text-white px-3 py-1 rounded-full text-sm font-medium cursor-pointer hover:bg-primary-hover transition-colors" ' +
           'onclick="filterBlogs(\'category\', \'' + escapedCategory + '\')">' +
           escapedCategory +
           '</span>' +
           '</div>' +
           '<div class="post-content p-6">' +
           '<div class="post-meta flex items-center text-sm text-gray-600 mb-3 space-x-4">' +
           '<span class="flex items-center">' +
           '<i class="fas fa-calendar-alt mr-1"></i>' +
           escapedFormattedDate +
           '</span>' +
           '<span class="flex items-center">' +
           '<i class="fas fa-user mr-1"></i>' +
           escapedAuthor +
           '</span>' +
           '</div>' +
           '<h3 class="post-title text-xl font-bold text-gray-900 mb-3 hover:text-primary transition-colors duration-200">' +
           escapedTitle +
           '</h3>' +
           '<p class="post-excerpt text-gray-600 mb-4 leading-relaxed">' +
           escapedExcerpt +
           '</p>' +
           '<a href="blog-post.jsp?id=' + post.id + '&slug=' + escapedSlug + '" ' +
           'class="read-more inline-flex items-center text-primary font-semibold hover:text-primary-hover transition-colors duration-200">' +
           'Read More' +
           '<i class="fas fa-arrow-right ml-2 text-sm"></i>' +
           '</a>' +
           '</div>' +
           '</div>';
};

// --- MAIN RENDERING FUNCTIONS ---

/**
 * Renders the current subset of blog posts based on pagination
 */
const renderBlogPosts = async (postsToRender, page = 1) => {
    if (!postsContainer) {
        console.error('Posts container not found');
        return;
    }

    currentPage = page;
    
    // Show/hide reset filter button
    if (filterResetBtn) {
        filterResetBtn.style.display = (currentFilter.type !== 'all' || currentFilter.value) ? 'inline-flex' : 'none';
    }

    if (!postsToRender || postsToRender.length === 0) {
        postsContainer.innerHTML = '<div class="no-content text-center py-12">' +
            '<i class="fas fa-exclamation-circle text-4xl text-gray-400 mb-4"></i>' +
            '<p class="text-gray-600 text-lg">No articles found for the current search/filter criteria.</p>' +
            '<p class="text-gray-500 mt-2">Try a different term or reset the filter.</p>' +
            '</div>';
        renderPagination(0);
        return;
    }

    const start = (currentPage - 1) * postsPerPage;
    const end = start + postsPerPage;
    const paginatedPosts = postsToRender.slice(start, end);

    // Show loading state
    postsContainer.innerHTML = '<div class="loading-container text-center py-8">' +
        '<i class="fas fa-spinner fa-spin text-3xl text-primary mb-3"></i>' +
        '<p class="text-gray-600">Loading posts...</p>' +
        '</div>';

    try {
        // Render posts one by one with proper image handling
        let postsHtml = '';
        for (const post of paginatedPosts) {
            const postHtml = await generatePostCard(post);
            postsHtml += postHtml;
        }
        
        postsContainer.innerHTML = postsHtml;
        renderPagination(postsToRender.length);
        
        // Smooth scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });
    } catch (error) {
        console.error('Error rendering blog posts:', error);
        postsContainer.innerHTML = '<div class="error-container text-center py-12">' +
            '<i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>' +
            '<p class="text-red-600 text-lg">Error loading posts. Please try again.</p>' +
            '</div>';
    }
};

/**
 * Renders the pagination links
 */
const renderPagination = (totalItems) => {
    if (!paginationContainer) return;
    
    paginationContainer.innerHTML = '';
    const totalPages = Math.ceil(totalItems / postsPerPage);

    if (totalPages <= 1) return;

    // Create pagination container
    const paginationDiv = document.createElement('div');
    paginationDiv.className = 'flex justify-center items-center space-x-2 mt-8';

    // Previous button
    if (currentPage > 1) {
        const prevLink = document.createElement('button');
        prevLink.innerHTML = '<i class="fas fa-chevron-left"></i>';
        prevLink.className = 'px-3 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 transition-colors duration-200';
        prevLink.onclick = () => renderBlogPosts(currentPosts, currentPage - 1);
        paginationDiv.appendChild(prevLink);
    }

    // Page numbers
    for (let i = 1; i <= totalPages; i++) {
        const pageLink = document.createElement('button');
        pageLink.textContent = i;
        pageLink.className = 'px-4 py-2 rounded-lg font-medium transition-colors duration-200 ' +
                            (i === currentPage ? 'bg-primary text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300');
        pageLink.onclick = () => renderBlogPosts(currentPosts, i);
        paginationDiv.appendChild(pageLink);
    }

    // Next button
    if (currentPage < totalPages) {
        const nextLink = document.createElement('button');
        nextLink.innerHTML = '<i class="fas fa-chevron-right"></i>';
        nextLink.className = 'px-3 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 transition-colors duration-200';
        nextLink.onclick = () => renderBlogPosts(currentPosts, currentPage + 1);
        paginationDiv.appendChild(nextLink);
    }

    paginationContainer.appendChild(paginationDiv);
};

// --- SIDEBAR RENDERING FUNCTIONS ---

/**
 * Renders all sidebar widgets (categories, recent posts, tags)
 */
const renderSidebar = async () => {
    try {
        await renderCategories();
        await renderRecentPosts();
        await renderTags();
    } catch (error) {
        console.error('Error rendering sidebar:', error);
    }
};

/**
 * Renders categories widget
 */
const renderCategories = async () => {
    if (!categoriesList) return;
    
    try {
        categoriesList.innerHTML = '<li class="text-gray-500">' +
            '<i class="fas fa-spinner fa-spin mr-2"></i>' +
            'Loading categories...' +
            '</li>';

        const categoriesData = await fetchData(API_ENDPOINTS.CATEGORIES);
        const categories = categoriesData.data || categoriesData || [];

        if (categories.length === 0) {
            categoriesList.innerHTML = '<li class="text-gray-500">No categories found</li>';
            return;
        }

        let categoriesHtml = '';
        categories.forEach(category => {
            const categoryName = category.name || 'Uncategorized';
            const categoryCount = category.count || 0;
            const escapedCategoryName = escapeHtml(categoryName);
            
            const activeClass = (currentFilter.type === 'category' && currentFilter.value === categoryName) 
                ? ' bg-primary text-white' 
                : ' text-gray-700 hover:bg-gray-100';
            
            categoriesHtml += '<li class="mb-2">' +
                '<a href="javascript:void(0)" ' +
                'class="flex justify-between items-center p-3 rounded-lg transition-colors duration-200' + activeClass + '" ' +
                'onclick="filterBlogs(\'category\', \'' + escapedCategoryName + '\')">' +
                '<span class="font-medium">' + escapedCategoryName + '</span>' +
                '<span class="category-count bg-gray-200 text-gray-700 px-2 py-1 rounded-full text-xs font-bold">' +
                categoryCount +
                '</span>' +
                '</a>' +
                '</li>';
        });
        
        categoriesList.innerHTML = categoriesHtml;
    } catch (error) {
        console.error('Error loading categories:', error);
        categoriesList.innerHTML = '<li class="text-red-500">' +
            '<i class="fas fa-exclamation-triangle mr-2"></i>' +
            'Error loading categories' +
            '</li>';
    }
};

/**
 * Renders recent posts widget
 */
const renderRecentPosts = async () => {
    if (!recentPostsList) return;
    
    try {
        recentPostsList.innerHTML = '<li class="text-gray-500 py-4">' +
            '<i class="fas fa-spinner fa-spin mr-2"></i>' +
            'Loading recent posts...' +
            '</li>';

        const recentPostsData = await fetchData(API_ENDPOINTS.RECENT_POSTS);
        const recentPosts = recentPostsData.data || recentPostsData || [];

        console.log('Recent posts loaded:', recentPosts);

        if (recentPosts.length === 0) {
            recentPostsList.innerHTML = '<li class="text-gray-500 py-4 text-center">' +
                '<i class="fas fa-newspaper mr-2"></i>' +
                'No recent posts' +
                '</li>';
            return;
        }

        let recentPostsHtml = '';
        for (const post of recentPosts) {
            const fallbackImg = 'https://placehold.co/80x80/2980b9/ffffff?text=Post';
            let imageUrl = getImageUrl(post.featuredImage);
            let finalImageUrl = fallbackImg;
            
            if (imageUrl) {
                try {
                    const imageExists = await testImage(imageUrl);
                    if (imageExists) {
                        finalImageUrl = imageUrl;
                    }
                } catch (error) {
                    console.log('Recent post image test failed:', imageUrl);
                }
            }
            
            const formattedDate = formatDate(post.publishedAt);
            const escapedTitle = escapeHtml(post.title);
            const escapedFormattedDate = escapeHtml(formattedDate);
            const escapedSlug = escapeHtml(post.slug || '');
            
            recentPostsHtml += '<li class="recent-post mb-4 pb-4 border-b border-gray-200 last:border-b-0 last:mb-0 last:pb-0">' +
                '<div class="flex items-start space-x-3 cursor-pointer group" ' +
                'onclick="window.location.href=\'blog-post.jsp?id=' + post.id + '&slug=' + escapedSlug + '\'">' +
                '<div class="recent-post-image flex-shrink-0">' +
                '<img src="' + finalImageUrl + '" ' +
                'alt="' + escapedTitle + '" ' +
                'class="w-16 h-16 object-cover rounded-lg transition-transform duration-200 group-hover:scale-105" ' +
                'onerror="this.onerror=null; this.src=\'' + fallbackImg + '\'">' +
                '</div>' +
                '<div class="recent-post-content flex-1 min-w-0">' +
                '<h4 class="font-medium text-gray-900 group-hover:text-primary transition-colors duration-200 line-clamp-2 leading-tight">' +
                escapedTitle +
                '</h4>' +
                '<span class="text-sm text-gray-500 mt-1 block">' +
                '<i class="fas fa-clock mr-1"></i>' + escapedFormattedDate +
                '</span>' +
                '</div>' +
                '</div>' +
                '</li>';
        }
        
        recentPostsList.innerHTML = recentPostsHtml;
    } catch (error) {
        console.error('Error loading recent posts:', error);
        recentPostsList.innerHTML = '<li class="text-red-500 py-4">' +
            '<i class="fas fa-exclamation-triangle mr-2"></i>' +
            'Error loading posts' +
            '</li>';
    }
};

/**
 * Renders tags cloud widget
 */
const renderTags = async () => {
    if (!tagsCloud) return;
    
    try {
        tagsCloud.innerHTML = '<span class="text-gray-500">Loading tags...</span>';

        const tagsData = await fetchData(API_ENDPOINTS.TAGS);
        const tags = tagsData.data || tagsData || [];

        if (tags.length === 0) {
            tagsCloud.innerHTML = '<span class="text-gray-500">No tags available</span>';
            return;
        }

        let tagsHtml = '';
        tags.forEach(tag => {
            const tagName = tag.name || tag;
            if (!tagName || tagName.trim() === '') return;
            
            const escapedTagName = escapeHtml(tagName.trim());
            const activeClass = (currentFilter.type === 'tag' && currentFilter.value === tagName) 
                ? ' bg-primary text-white border-primary' 
                : ' bg-gray-100 text-gray-700 border-gray-200 hover:bg-gray-200';
            
            tagsHtml += '<a href="javascript:void(0)" ' +
                'class="tag inline-block px-3 py-1 m-1 rounded-full border text-sm font-medium transition-colors duration-200' + activeClass + '" ' +
                'onclick="filterBlogs(\'tag\', \'' + escapedTagName + '\')">' +
                '#' + escapedTagName +
                '</a>';
        });
        
        tagsCloud.innerHTML = tagsHtml || '<span class="text-gray-500">No tags available</span>';
    } catch (error) {
        console.error('Error loading tags:', error);
        tagsCloud.innerHTML = '<span class="text-red-500">Error loading tags</span>';
    }
};

// --- INTERACTION LOGIC ---

/**
 * Filters the blog posts by category, tag, or resets the filter
 */
const filterBlogs = async (type, value = null) => {
    currentFilter = { type: type, value: value };
    
    try {
        let url = API_ENDPOINTS.BLOGS;
        const params = new URLSearchParams();
        
        if (type === 'category' && value) {
            params.append('category', value);
        } else if (type === 'tag' && value) {
            params.append('tag', value);
        } else if (type === 'search' && value) {
            params.append('search', value);
        }
        
        params.append('page', '1');
        params.append('limit', '100');
        
        if (params.toString()) {
            url += '?' + params.toString();
        }
        
        console.log('Filtering blogs with URL:', url);
        const data = await fetchData(url);
        currentPosts = data.data || data || [];
        
        // Clear search input if filtering by category/tag
        if (type !== 'search' && searchInput) {
            searchInput.value = '';
        }
        
        await renderSidebar();
        await renderBlogPosts(currentPosts, 1);
    } catch (error) {
        console.error('Error filtering blogs:', error);
        if (postsContainer) {
            postsContainer.innerHTML = '<div class="error-container text-center py-12">' +
                '<i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>' +
                '<p class="text-red-600 text-lg">Error loading blog posts.</p>' +
                '<p class="text-gray-600 mt-2">Please try again later.</p>' +
                '</div>';
        }
    }
};

/**
 * Handles the search form submission to filter posts by title or excerpt
 */
const searchBlogs = async (event) => {
    if (event) {
        event.preventDefault();
    }
    
    const searchTerm = searchInput ? searchInput.value.trim() : '';
    
    if (!searchTerm) {
        filterBlogs('all');
        return;
    }

    await filterBlogs('search', searchTerm);
};

/**
 * Resets all filters and shows all posts
 */
const resetFilters = () => {
    if (searchInput) {
        searchInput.value = '';
    }
    filterBlogs('all');
};

// --- EVENT LISTENERS ---

/**
 * Initialize all event listeners
 */
const initializeEventListeners = () => {
    // Search form
    if (searchForm) {
        searchForm.addEventListener('submit', searchBlogs);
    }
    
    // Reset filter button
    if (filterResetBtn) {
        filterResetBtn.addEventListener('click', resetFilters);
    }
    
    // Search input clear functionality
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            if (e.target.value.trim() === '') {
                resetFilters();
            }
        });
    }
    
    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && searchInput) {
            searchInput.value = '';
            resetFilters();
        }
    });
};

// --- INITIALIZATION ---

/**
 * Main initialization function
 */
const initializeBlog = async () => {
    console.log('Initializing blog system...');
    
    try {
        // Initialize event listeners first
        initializeEventListeners();
        
        // Load main blog posts
        const data = await fetchData(API_ENDPOINTS.BLOGS + '?page=1&limit=100');
        currentPosts = data.data || data || [];
        
        console.log('Loaded posts:', currentPosts.length);
        
        // Render everything
        await renderBlogPosts(currentPosts, 1);
        await renderSidebar();
        
        console.log('Blog system initialized successfully!');
        
    } catch (error) {
        console.error('Error initializing blog:', error);
        if (postsContainer) {
            postsContainer.innerHTML = '<div class="error-container text-center py-12">' +
                '<i class="fas fa-exclamation-triangle text-4xl text-red-500 mb-4"></i>' +
                '<p class="text-red-600 text-lg">Error loading blog posts.</p>' +
                '<p class="text-gray-600 mt-2">Please check your connection and try again.</p>' +
                '<button onclick="initializeBlog()" ' +
                'class="mt-4 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-hover transition-colors duration-200">' +
                '<i class="fas fa-redo mr-2"></i>Retry' +
                '</button>' +
                '</div>';
        }
    }
};

// --- GLOBAL EXPORTS ---
// Make functions available globally for HTML onclick attributes
window.filterBlogs = filterBlogs;
window.searchBlogs = searchBlogs;
window.resetFilters = resetFilters;
window.initializeBlog = initializeBlog;

// Start the application when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, starting blog initialization...');
    initializeBlog();
});

// Also initialize if DOM is already loaded
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeBlog);
} else {
    initializeBlog();
}
</script>
</body>
</html>