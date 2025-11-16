<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Manage Banners</title>
    <link rel="stylesheet" href="/assets/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
    :root {
    /* --- Main Palette --- */
    --primary-color: #1e3a8a; /* A deep, professional blue */
    --primary-color-hover: #64748b;
    --secondary-color: #4b5563; /* A warm, dark charcoal gray */
    --secondary-color-hover: #374151;
    --accent-color: #0d9488; /* A modern, vibrant teal for highlights */
    --accent-color-hover: #087f73;

    /* --- Status & Alerts --- */
    --success-color: #10b981; /* Green for success messages */
    --success-color-hover: #059669;
    --danger-color: #ef4444; /* Red for errors and danger */
    --danger-color-hover: #dc2626;
    --info-color: #3b82f6; /* Blue for informational messages and buttons */
    --info-color-hover: #2563eb;
    
    /* --- Backgrounds & Text --- */
    --body-bg: #f9fafb; /* A very light gray for the page background */
    --card-bg: #ffffff; /* Pure white for content cards */
    --sidebar-bg: #1f2937; /* A very dark gray for the sidebar */
    --text-color: #1f2937; /* A dark gray for most text */
    --text-color-light: #e5e7eb; /* A light gray for text on dark backgrounds */
}

/* --- General Styles --- */
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
.form-container {
    display: none; /* Hidden by default */
}
.form-container.active {
    display: block; /* Show when active */
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
.alert-success {
    background-color: #4CAF50;
}
.alert-error {
    background-color: #F44336;
}

/* --- Buttons --- */
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
/* New styles for small action buttons */
.btn-sm {
    padding: 0.3rem 0.6rem;
    font-size: 0.8rem;
    border-radius: 0.3rem;
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
    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.25);
}

/* --- Modals --- */
.modal {
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
    margin: auto;
    padding: 2rem;
    border-radius: 0.75rem;
    width: 90%;
    max-width: 500px;
    box-shadow: 0 10px 15px rgba(0,0,0,0.2);
    position: relative;
}
.close-button {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}
.close-button:hover, .close-button:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}
.delete-modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4);
    align-items: center;
    justify-content: center;
}
/* --- Dashboard Layout --- */
.dashboard-container {
    display: flex;
    align-items: flex-start;
    min-height: calc(100vh - 64px);
}
.sidebar {
    width: 250px;
    background-color: var(--sidebar-bg);
    color: var(--text-color-light);
    padding: 1.5rem;
    overflow-y: auto;
    box-shadow: 2px 0 5px rgba(0,0,0,0.1);
    flex-shrink: 0;
    position: sticky;
    top: 0;
}
.sidebar h3 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    color: #cbd5e0;
}
.sidebar-menu li {
    margin-bottom: 1rem;
}
.sidebar-menu a {
    display: flex;
    align-items: center;
    padding: 0.75rem 1rem;
    border-radius: 0.5rem;
    color: var(--text-color-light);
    text-decoration: none;
    transition: background-color 0.2s, color 0.2s;
}
.sidebar-menu a:hover,
.sidebar-menu a.active {
    background-color: #4a5568;
    color: #fff;
}
.sidebar-menu a i {
    margin-right: 0.75rem;
    font-size: 1.1rem;
}
.main-content {
    flex-grow: 1;
    width: 100%;
    display: flex;
    flex-direction: column;
    padding: 2rem;
    gap: 2rem;
    background-color: #f7fafc;
    overflow: auto;
}
/* --- Dashboard Sections (Redesigned) --- */
.dashboard-section {
    background-color: var(--card-bg);
    padding: 2rem;
    border-radius: 0.75rem;
    /* Layered, more pronounced shadow for a 'floating' effect */
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    margin-bottom: 2rem;
    overflow: hidden; /* Changed to hidden to contain child elements */
    width: 100%;
    /* Subtle transition for a smooth hover effect */
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
}
.dashboard-section:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}
.dashboard-section h2 {
    font-size: 1.75rem;
    font-weight: 700;
    color: var(--text-color);
    margin-bottom: 1.5rem;
    border-bottom: 2px solid #e2e8f0; /* Softer border color */
    padding-bottom: 1rem;
}
</style>
</head>

<div class="p-8">

    <header class="section-header flex justify-between items-center mb-6">
        <h1 class="text-3xl font-extrabold text-primary">Banner Manager 📸</h1>
    </header>

    <c:if test="${not empty successMessage}">
        <div class="message-box success" role="alert">
            ${successMessage}
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="message-box error" role="alert">
            ${errorMessage}
        </div>
    </c:if>

    <div class="bg-card-bg p-6 rounded-xl shadow-lg mb-8">
        <h3 class="text-2xl font-semibold mb-6 text-secondary border-b pb-3">Upload New Banner</h3>
        
        <form method="post" enctype="multipart/form-data" action="banners" class="space-y-4">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                
                <div class="form-group">
                    <label for="bannerImage">Banner Image:</label>
                    <input type="file" name="bannerImage" id="bannerImage" accept="image/*" required 
                           class="w-full text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-primary/10 file:text-primary hover:file:bg-primary/20">
                    <p class="text-xs text-gray-500 mt-1">Accepted formats: JPG, PNG, GIF.</p>
                </div>
                
                <div class="form-group">
                    <label for="altText">Alt Text (SEO/Accessibility):</label>
                    <input type="text" name="altText" id="altText" placeholder="A brief description of the banner content">
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-2">
                
                <div class="form-group">
                    <label for="position">Banner Position:</label>
                    <select name="position" id="position">
                        <option value="homepage">Homepage Slider</option>
                        <option value="event_sidebar">Event Sidebar</option>
                        <option value="footer_ad">Footer Ad</option>
                        <option value="mobile_top">Mobile Top</option>
                        </select>
                </div>
                
                <div class="form-group flex items-center pt-8">
                    <input type="checkbox" name="active" id="active" checked 
                           class="w-5 h-5 text-primary border-gray-300 rounded focus:ring-primary">
                    <label for="active" class="ml-3 mb-0 inline-block font-normal">Active / Live</label>
                </div>
                
                <div class="md:col-span-1 pt-8">
                    <button type="submit" class="btn btn-primary w-full">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path></svg>
                        Upload Banner
                    </button>
                </div>
            </div>
        </form>
    </div>

    <hr class="mt-8 mb-6"/>

    <div class="bg-card-bg p-6 rounded-xl shadow-lg">
        <h3 class="text-2xl font-semibold mb-6 text-secondary">Existing Banners</h3>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            <c:choose>
                <c:when test="${not empty banners}">
                    <c:forEach var="banner" items="${banners}">
                        
                        <div class="banner-card border rounded-lg overflow-hidden shadow-md hover:shadow-xl transition duration-300">
                            
                            <div class="w-full h-32 bg-gray-100 flex items-center justify-center overflow-hidden">
                                <img src="/${banner.imageUrl}" alt="${banner.altText}" 
                                     class="w-full h-full object-cover">
                            </div>

                            <div class="p-4">
                                <p class="text-sm font-semibold mb-2">${banner.position}</p>
                                <p class="text-xs text-gray-600 truncate mb-2" title="${banner.altText}">${banner.altText}</p>
                                
                                <div class="flex justify-between items-center pt-2 border-t mt-2">
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                                        <c:choose>
                                            <c:when test="${banner.active}">bg-success/10 text-success</c:when>
                                            <c:otherwise>bg-danger/10 text-danger</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${banner.active}">Active</c:when>
                                            <c:otherwise>Inactive</c:otherwise>
                                        </c:choose>
                                    </span>
                                    
                                    <div class="space-x-1">
                                        <button class="btn btn-sm btn-info" onclick="editBanner(${banner.id})">Edit</button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteBanner(${banner.id})">Delete</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="col-span-full text-center py-6 text-gray-500">No banners have been uploaded yet.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script>
        function editBanner(id) {
            // Placeholder: Logic to load banner data into the form for editing
            alert('Edit banner ID: ' + id);
        }
        function deleteBanner(id) {
            // Placeholder: Logic to confirm deletion and submit the request
            if (confirm('Are you sure you want to delete this banner?')) {
                 alert('Delete action simulated for ID: ' + id);
            }
        }
    </script>
</div>
</html>