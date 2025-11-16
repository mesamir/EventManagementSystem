<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>EMS CMS Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    
    <style>
        :root {
            /* --- Main Palette --- */
            --primary-color: #1e3a8a;
            --primary-color-hover: #64748b;
            --secondary-color: #4b5563;
            --secondary-color-hover: #374151;
            --accent-color: #0d9488;
            --accent-color-hover: #087f73;

            /* --- Status & Alerts --- */
            --success-color: #10b981;
            --success-color-hover: #059669;
            --danger-color: #ef4444;
            --danger-color-hover: #dc2626;
            --info-color: #3b82f6;
            --info-color-hover: #2563eb;
            --warning-color: #f59e0b;
            --warning-color-hover: #d97706;
            
            /* --- Backgrounds & Text --- */
            --body-bg: #f9fafb;
            --card-bg: #ffffff;
            --sidebar-bg: #1f2937;
            --text-color: #1f2937;
            --text-color-light: #e5e7eb;
            --border-color: #e5e7eb;
            --border-color-light: #f3f4f6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--body-bg);
            color: var(--text-color);
            line-height: 1.6;
        }

        /* --- Layout --- */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background-color: var(--sidebar-bg);
            color: var(--text-color-light);
            padding: 1.5rem;
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
            flex-shrink: 0;
        }

        .sidebar h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            color: #cbd5e0;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            color: var(--text-color-light);
            text-decoration: none;
            transition: background-color 0.2s, color 0.2s;
            font-size: 0.875rem;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background-color: #4a5568;
            color: #fff;
        }

        .sidebar-menu a i {
            margin-right: 0.75rem;
            font-size: 1.1rem;
            width: 1rem;
            text-align: center;
        }

        .main-content {
            flex-grow: 1;
            padding: 2rem;
            background-color: var(--body-bg);
            overflow-y: auto;
        }

        /* --- Cards & Sections --- */
        .dashboard-section {
            background-color: var(--card-bg);
            padding: 2rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            margin-bottom: 2rem;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }

        .dashboard-section:hover {
            transform: translateY(-2px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        /* --- Stats Grid --- */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background-color: var(--card-bg);
            padding: 1.5rem;
            border-radius: 0.75rem;
            border: 1px solid var(--border-color);
            text-align: center;
            transition: all 0.3s ease-in-out;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-card h4 {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-card p {
            color: var(--secondary-color);
            font-size: 0.875rem;
        }

        /* --- Buttons --- */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-color-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .btn-secondary {
            background-color: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            background-color: var(--secondary-color-hover);
            transform: translateY(-1px);
        }

        .btn-info {
            background-color: var(--info-color);
            color: white;
        }

        .btn-info:hover {
            background-color: var(--info-color-hover);
            transform: translateY(-1px);
        }

        /* --- Typography --- */
        h1, h2, h3, h4, h5, h6 {
            font-weight: 600;
            line-height: 1.3;
            margin-bottom: 0.5rem;
        }

        h1 { font-size: 2.25rem; }
        h2 { font-size: 1.875rem; }
        h3 { font-size: 1.5rem; }

        .section-header {
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 0.75rem;
            margin-bottom: 1.5rem;
        }

        /* --- CMS Content Styles --- */
        .cms-loaded-content {
            animation: fadeIn 0.3s ease-in-out;
        }

        .cms-content-header {
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 1rem;
            margin-bottom: 2rem;
        }

        .cms-content-body {
            min-height: 400px;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .loading-overlay.show {
            display: flex;
        }

        .loading-spinner {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 1rem;
            font-weight: 500;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* --- Responsive --- */
        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                height: auto;
                position: static;
            }
            
            .main-content {
                padding: 1rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 640px) {
            .dashboard-section {
                padding: 1rem;
            }
        }
    </style>
</head>

<body>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <i class="fas fa-spinner fa-spin text-primary text-xl"></i>
            <span>Loading Content...</span>
        </div>
    </div>

    <div class="dashboard-container">
    
        <aside class="sidebar">
            <h3>
                <span style="color: var(--accent-color);">EMS</span> CMS
            </h3>

            <ul class="sidebar-menu">
                <li>
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="active" id="dashboardLink">
                        <i class="fas fa-tachometer-alt"></i>
                        Dashboard Home
                    </a>
                </li>
                <li style="padding-top: 1rem; font-size: 0.75rem; font-weight: 600; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em;">
                    CMS Modules
                </li>
                
                <li>
                    <a href="<%= request.getContextPath() %>/admin/cms/pages" class="cms-nav-link" data-module="pages">
                        <i class="fas fa-file"></i>
                        Manage Pages
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/blog-management.jsp" class="cms-nav-link" data-module="blog">
                        <i class="fas fa-blog"></i>
                        Manage Blog
                    </a>
                </li>   
                <li>
                    <a href="<%= request.getContextPath() %>/admin/services" class="cms-nav-link" data-module="services">
                        <i class="fas fa-concierge-bell"></i>
                        Manage Services
                    </a>
                </li> 
                <li>
                    <a href="<%= request.getContextPath() %>/admin/cms/banners" class="cms-nav-link" data-module="banners">
                        <i class="fas fa-images"></i>
                        Manage Banners
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/cms/blocks" class="cms-nav-link" data-module="blocks">
                        <i class="fas fa-cube"></i>
                        Manage Content Blocks
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/cms/templates" class="cms-nav-link" data-module="templates">
                        <i class="fas fa-layer-group"></i>
                        Event Templates
                    </a>
                </li>
                
                <li style="padding-top: 1rem; font-size: 0.75rem; font-weight: 600; color: #9ca3af; text-transform: uppercase; letter-spacing: 0.05em;">
                    Tools & Settings
                </li>
                
                <li>
                    <a href="<%= request.getContextPath() %>/admin/cms/seo" class="cms-nav-link" data-module="seo">
                        <i class="fas fa-search"></i>
                        SEO Manager
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/cms/social" class="cms-nav-link" data-module="social">
                        <i class="fas fa-share-alt"></i>
                        Social Links
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/settings/users" class="cms-nav-link" data-module="users">
                        <i class="fas fa-users"></i>
                        User Management
                    </a>
                </li>
            </ul>
        </aside>

        <main class="main-content">
            <!-- CMS Section - This will show when CMS is selected -->
            <section id="cms-section" class="dashboard-section" style="display: none;">
                <div id="cms-content">
                    <!-- CMS content will be loaded here dynamically -->
                </div>
            </section>

            <!-- Default Dashboard Section - This shows by default -->
            <section id="overview" class="dashboard-section">
                <header style="margin-bottom: 2rem;">
                    <h1 class="text-primary">👋 Welcome Back!</h1>
                    <p class="text-secondary">Dashboard Overview & Quick Links</p>
                </header>

                <hr style="margin-bottom: 2rem; border: none; border-top: 1px solid var(--border-color);">

                <div class="stats-grid">
                    <div class="stat-card" style="border-top: 4px solid var(--primary-color);">
                        <p style="font-size: 0.875rem; font-weight: 500; color: var(--secondary-color);">Total Published Pages</p>
                        <h4 class="text-primary" id="totalPages">0</h4>
                    </div>
                    <div class="stat-card" style="border-top: 4px solid var(--accent-color);">
                        <p style="font-size: 0.875rem; font-weight: 500; color: var(--secondary-color);">Blog Posts</p>
                        <h4 class="text-primary" id="totalBlogs">0</h4>
                    </div>
                    <div class="stat-card" style="border-top: 4px solid var(--info-color);">
                        <p style="font-size: 0.875rem; font-weight: 500; color: var(--secondary-color);">Active Services</p>
                        <h4 class="text-primary" id="totalServices">0</h4>
                    </div>
                    <div class="stat-card" style="border-top: 4px solid var(--success-color);">
                        <p style="font-size: 0.875rem; font-weight: 500; color: var(--secondary-color);">Active Banners</p>
                        <h4 class="text-primary" id="totalBanners">0</h4>
                    </div>
                </div>

                <div class="dashboard-section">
                    <h2 class="text-primary">Quick Actions</h2>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-top: 1rem;">
                        <a href="<%= request.getContextPath() %>/admin/cms/pages" class="btn btn-primary cms-nav-link" data-module="pages">
                            <i class="fas fa-file"></i>
                            Manage Pages
                        </a>
                        <a href="<%= request.getContextPath() %>/blog-management.jsp" class="btn btn-info cms-nav-link" data-module="blog">
                            <i class="fas fa-blog"></i>
                            Manage Blog
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/services" class="btn btn-secondary cms-nav-link" data-module="services">
                            <i class="fas fa-concierge-bell"></i>
                            Manage Services
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/cms/banners" class="btn btn-success cms-nav-link" data-module="banners">
                            <i class="fas fa-images"></i>
                            Manage Banners
                        </a>
                    </div>
                </div>
                
                <hr style="margin: 2rem 0; border: none; border-top: 1px solid var(--border-color);">
                
                <div>
                    <h2 class="text-primary">Recent Activity</h2>
                    <div class="dashboard-section">
                        <div id="recentActivity">
                            <div class="activity-item" style="padding: 1rem; border-left: 4px solid var(--success-color); background-color: #d1fae5; border-radius: 0.5rem; margin-bottom: 0.75rem;">
                                <p style="font-size: 0.875rem; color: #065f46;">
                                    <strong>Welcome to EMS CMS!</strong> Your content management system is ready.
                                </p>
                                <span style="font-size: 0.75rem; color: var(--secondary-color);">Just now</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </div>

<script>
// Enhanced CMS Navigation System
document.addEventListener('DOMContentLoaded', function() {
    initializeCMSNavigation();
    loadDashboardStats();
});

function initializeCMSNavigation() {
    // Add click event listeners to all CMS navigation links
    document.querySelectorAll('.cms-nav-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const href = this.getAttribute('href');
            const module = this.getAttribute('data-module');
            loadCMSContent(href, module, this);
        });
    });

    // Dashboard link
    document.getElementById('dashboardLink').addEventListener('click', function(e) {
        e.preventDefault();
        showOverview();
        updateActiveMenuItem(this);
        history.pushState(null, null, '<%= request.getContextPath() %>/admin/dashboard');
    });
}

function loadDashboardStats() {
    // Simulate loading stats - in real app, fetch from API
    setTimeout(() => {
        document.getElementById('totalPages').textContent = '12';
        document.getElementById('totalBlogs').textContent = '8';
        document.getElementById('totalServices').textContent = '6';
        document.getElementById('totalBanners').textContent = '4';
    }, 1000);
}

function loadCMSContent(url, module, clickedLink) {
    showLoading(true);
    
    // Show CMS section and hide overview
    document.getElementById('cms-section').style.display = 'block';
    document.getElementById('overview').style.display = 'none';
    
    const cmsContent = document.getElementById('cms-content');
    if (!cmsContent) return;

    // Update active menu item
    updateActiveMenuItem(clickedLink);

    // Load content via AJAX
    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.text();
        })
        .then(html => {
            // Parse the HTML response
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            
            // Extract main content - try different selectors
            let mainContent = doc.querySelector('main') || 
                            doc.querySelector('.main-content') || 
                            doc.querySelector('.dashboard-section') || 
                            doc.querySelector('.p-8') || 
                            doc.body;
            
            if (mainContent) {
                // Clean up the content - remove headers, sidebars, etc.
                const contentToLoad = cleanExtractedContent(mainContent, url);
                
                // Create a container for the loaded content
                cmsContent.innerHTML = `
                    <div class="cms-loaded-content">
                        <div class="cms-content-header">
                            <h2 class="text-2xl font-bold text-primary">
                                <i class="${getIconForModule(module)} mr-2"></i>${getTitleForModule(module)}
                            </h2>
                            <p class="text-secondary">${getDescriptionForModule(module)}</p>
                        </div>
                        <div class="cms-content-body">
                            ${contentToLoad}
                        </div>
                    </div>
                `;

                // Re-initialize the loaded content
                reinitializeCMSContent(cmsContent);
                
                // Update browser history
                history.pushState({module: module, url: url}, null, url);
                
                console.log('CMS content loaded successfully:', module, url);
            } else {
                throw new Error('No content found in response');
            }
        })
        .catch(error => {
            console.error('Error loading CMS content:', error);
            cmsContent.innerHTML = `
                <div class="alert alert-error" style="background-color: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 0.5rem; border: 1px solid #ef4444;">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-triangle text-xl mr-3"></i>
                        <div>
                            <h3 class="font-bold text-lg">Unable to Load Content</h3>
                            <p class="mt-1">Error: ${error.message}</p>
                        </div>
                    </div>
                    <div class="mt-4 flex gap-2">
                        <button onclick="loadCMSContent('${url}', '${module}')" class="btn btn-primary">
                            <i class="fas fa-redo mr-2"></i>Try Again
                        </button>
                        <a href="${url}" target="_blank" class="btn btn-secondary">
                            <i class="fas fa-external-link-alt mr-2"></i>Open in New Tab
                        </a>
                    </div>
                </div>
            `;
        })
        .finally(() => {
            showLoading(false);
        });
}

function cleanExtractedContent(contentElement, url) {
    // Clone the element to avoid modifying the original
    const content = contentElement.cloneNode(true);
    
    // Remove elements that shouldn't be in the CMS container
    const elementsToRemove = [
        'header', 'nav', 'footer', 'aside', '.sidebar',
        '.dashboard-container', '.dashboard-header',
        'h1', 'h2:first-of-type' // Remove main headers as we have our own
    ];
    
    elementsToRemove.forEach(selector => {
        const elements = content.querySelectorAll(selector);
        elements.forEach(el => el.remove());
    });
    
    // Remove any existing active classes from navigation
    const navItems = content.querySelectorAll('.active, .nav-item.active');
    navItems.forEach(item => item.classList.remove('active'));
    
    return content.innerHTML;
}

function reinitializeCMSContent(container) {
    // 1. Intercept ALL links inside the CMS content
    interceptAllLinks(container);
    
    // 2. Re-initialize forms to prevent page reload
    interceptForms(container);
    
    // 3. Re-initialize scripts
    reinitializeScripts(container);
    
    // 4. Re-initialize interactive elements
    reinitializeInteractiveElements(container);
}

function interceptAllLinks(container) {
    const allLinks = container.querySelectorAll('a[href]');
    
    allLinks.forEach(link => {
        const href = link.getAttribute('href');
        
        // Skip external links, anchors, javascript links, and links with specific targets
        if (href.startsWith('http') || 
            href.startsWith('#') || 
            href.startsWith('javascript:') ||
            link.getAttribute('target') === '_blank' ||
            link.classList.contains('no-ajax')) {
            return;
        }
        
        // Check if it's an internal CMS/admin link
        if (isCMSLink(href)) {
            // Replace the link with a new one to avoid duplicate listeners
            const newLink = link.cloneNode(true);
            link.parentNode.replaceChild(newLink, link);
            
            // Add click listener for AJAX loading
            newLink.addEventListener('click', function(e) {
                e.preventDefault();
                const module = getModuleFromUrl(href);
                loadCMSContent(href, module, this);
            });
            
            newLink.classList.add('ajax-link');
        }
    });
}

function interceptForms(container) {
    const forms = container.querySelectorAll('form');
    
    forms.forEach(form => {
        // Remove any existing submit listeners
        const newForm = form.cloneNode(true);
        form.parentNode.replaceChild(newForm, form);
        
        newForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Show loading
            showLoading(true);
            
            // Submit form via AJAX
            const formData = new FormData(this);
            const action = this.getAttribute('action') || window.location.href;
            const method = this.getAttribute('method') || 'POST';
            
            fetch(action, {
                method: method,
                body: formData
            })
            .then(response => response.text())
            .then(html => {
                // For now, just reload the current module
                const currentUrl = window.location.pathname;
                const currentModule = getModuleFromUrl(currentUrl);
                loadCMSContent(currentUrl, currentModule);
                
                // Show success message
                showNotification('Changes saved successfully!', 'success');
            })
            .catch(error => {
                console.error('Form submission error:', error);
                showNotification('Error saving changes: ' + error.message, 'error');
            })
            .finally(() => {
                showLoading(false);
            });
        });
    });
}

function reinitializeScripts(container) {
    const scripts = container.querySelectorAll('script');
    
    scripts.forEach(script => {
        if (script.src) {
            // External script
            const newScript = document.createElement('script');
            newScript.src = script.src;
            if (script.async) newScript.async = true;
            if (script.defer) newScript.defer = true;
            document.head.appendChild(newScript);
        } else {
            // Inline script - execute carefully
            try {
                const scriptContent = script.innerHTML;
                // Avoid executing scripts that might cause page reloads
                if (!scriptContent.includes('location.href') && 
                    !scriptContent.includes('window.location') &&
                    !scriptContent.includes('document.location')) {
                    eval(scriptContent);
                }
            } catch (e) {
                console.warn('Script execution warning:', e);
            }
        }
    });
}

function reinitializeInteractiveElements(container) {
    // Re-initialize buttons that navigate
    const buttons = container.querySelectorAll('button, .btn');
    
    buttons.forEach(button => {
        const onclick = button.getAttribute('onclick');
        if (onclick && onclick.includes('location.href')) {
            const urlMatch = onclick.match(/location\.href\s*=\s*['"]([^'"]+)['"]/);
            if (urlMatch && urlMatch[1] && isCMSLink(urlMatch[1])) {
                button.setAttribute('onclick', '');
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const module = getModuleFromUrl(urlMatch[1]);
                    loadCMSContent(urlMatch[1], module, this);
                });
            }
        }
    });
}

function isCMSLink(url) {
    return url.includes('/admin/') || 
           url.includes('/cms/') || 
           url.includes('-management.jsp') ||
           (url.includes('.jsp') && !url.includes('/logout'));
}

function getModuleFromUrl(url) {
    const moduleMap = {
        '/admin/cms/pages': 'pages',
        '/blog-management.jsp': 'blog',
        '/admin/services': 'services',
        '/admin/cms/banners': 'banners',
        '/admin/cms/blocks': 'blocks',
        '/admin/cms/templates': 'templates',
        '/admin/cms/seo': 'seo',
        '/admin/cms/social': 'social',
        '/admin/settings/users': 'users'
    };
    
    for (const [key, module] of Object.entries(moduleMap)) {
        if (url.includes(key)) {
            return module;
        }
    }
    
    return 'unknown';
}

function updateActiveMenuItem(clickedLink) {
    document.querySelectorAll('.sidebar-menu a').forEach(link => {
        link.classList.remove('active');
    });
    
    if (clickedLink) {
        clickedLink.classList.add('active');
    }
}

function getIconForModule(module) {
    const iconMap = {
        'pages': 'fas fa-file',
        'blog': 'fas fa-blog',
        'services': 'fas fa-concierge-bell',
        'banners': 'fas fa-images',
        'blocks': 'fas fa-cube',
        'templates': 'fas fa-layer-group',
        'seo': 'fas fa-search',
        'social': 'fas fa-share-alt',
        'users': 'fas fa-users'
    };
    
    return iconMap[module] || 'fas fa-cog';
}

function getTitleForModule(module) {
    const titleMap = {
        'pages': 'Manage Pages',
        'blog': 'Manage Blog',
        'services': 'Manage Services',
        'banners': 'Manage Banners',
        'blocks': 'Manage Content Blocks',
        'templates': 'Event Templates',
        'seo': 'SEO Manager',
        'social': 'Social Links',
        'users': 'User Management'
    };
    
    return titleMap[module] || 'Content Management';
}

function getDescriptionForModule(module) {
    const descMap = {
        'pages': 'Manage your website pages and content',
        'blog': 'Create and manage blog posts',
        'services': 'Manage your event services and features',
        'banners': 'Manage website banners and hero sections',
        'blocks': 'Manage reusable content blocks',
        'templates': 'Manage event templates and packages',
        'seo': 'Optimize your website for search engines',
        'social': 'Manage social media links and integration',
        'users': 'Manage user accounts and permissions'
    };
    
    return descMap[module] || 'Content management interface';
}

function showOverview() {
    document.getElementById('cms-section').style.display = 'none';
    document.getElementById('overview').style.display = 'block';
    document.querySelectorAll('.sidebar-menu a').forEach(link => link.classList.remove('active'));
    document.getElementById('dashboardLink').classList.add('active');
}

function showLoading(show) {
    const overlay = document.getElementById('loadingOverlay');
    if (show) {
        overlay.classList.add('show');
    } else {
        overlay.classList.remove('show');
    }
}

function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 1rem 1.5rem;
        border-radius: 0.5rem;
        color: white;
        font-weight: 500;
        z-index: 10000;
        animation: slideIn 0.3s ease-out;
        ${type == 'success' ? 'background-color: var(--success-color);' : ''}
        ${type == 'error' ? 'background-color: var(--danger-color);' : ''}
        ${type == 'info' ? 'background-color: var(--info-color);' : ''}
    `;
    
    notification.innerHTML = `
        <i class="fas fa-${type == 'success' ? 'check' : type == 'error' ? 'exclamation-triangle' : 'info'} mr-2"></i>
        ${message}
    `;
    
    document.body.appendChild(notification);
    
    // Remove after 5 seconds
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-in';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 5000);
}

// Handle browser back/forward buttons
window.addEventListener('popstate', function(event) {
    const currentUrl = window.location.pathname + window.location.search;
    
    if (currentUrl.includes('/admin/dashboard')) {
        showOverview();
    } else if (isCMSLink(currentUrl)) {
        const module = getModuleFromUrl(currentUrl);
        const matchingLink = document.querySelector(`.cms-nav-link[href="${currentUrl}"]`);
        if (matchingLink) {
            loadCMSContent(currentUrl, module, matchingLink);
        }
    }
});

// Add CSS for animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
    
    .ajax-link {
        transition: all 0.2s ease;
    }
    
    .ajax-link:hover {
        transform: translateY(-1px);
    }
    
    .notification {
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
    }
`;
document.head.appendChild(style);
</script>
</body>
</html>