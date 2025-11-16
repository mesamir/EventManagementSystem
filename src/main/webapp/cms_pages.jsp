<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage CMS Pages</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    
    <style>
        :root {
            --primary-color: #1e3a8a;
            --primary-color-hover: #64748b;
            --secondary-color: #4b5563;
            --secondary-color-hover: #374151;
            --accent-color: #0d9488;
            --accent-color-hover: #087f73;
            --success-color: #10b981;
            --success-color-hover: #059669;
            --danger-color: #ef4444;
            --danger-color-hover: #dc2626;
            --info-color: #3b82f6;
            --info-color-hover: #2563eb;
            --body-bg: #f9fafb;
            --card-bg: #ffffff;
            --sidebar-bg: #1f2937;
            --text-color: #1f2937;
            --text-color-light: #e5e7eb;
        }

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
            display: none;
        }
        
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
            border: none;
            text-decoration: none;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-color-hover);
        }
        
        .btn-secondary {
            background-color: var(--secondary-color);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: var(--secondary-color-hover);
        }
        
        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }
        
        .btn-danger:hover {
            background-color: var(--danger-color-hover);
        }
        
        .btn-success {
            background-color: var(--success-color);
            color: white;
        }
        
        .btn-success:hover {
            background-color: var(--success-color-hover);
        }
        
        .btn-sm {
            padding: 0.3rem 0.6rem;
            font-size: 0.8rem;
            border-radius: 0.3rem;
        }
        
        .btn-info {
            background-color: var(--info-color);
            color: white;
        }
        
        .btn-info:hover {
            background-color: var(--info-color-hover);
        }
        
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
            box-sizing: border-box;
        }
        
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }
        
        .status-published {
            background-color: #d1fae5;
            color: #065f46;
        }
        
        .status-draft {
            background-color: #bfdbfe;
            color: #1e40af;
        }
        
        .status-archived {
            background-color: #e5e7eb;
            color: #374151;
        }
        
        .loading {
            opacity: 0.6;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="p-8">
        <header class="section-header flex justify-between items-center mb-6">
            <h1 class="text-3xl font-extrabold text-gray-800">Manage CMS Pages 📝</h1>
            <button id="toggleFormBtn" class="btn btn-success">
                <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
                Add New Page
            </button>
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

        <div id="pageFormContainer" class="form-container bg-white p-6 rounded-xl shadow-lg mb-8">
            <h3 class="text-2xl font-semibold mb-4 text-gray-700">
                <span id="formTitle">Create New Page</span>
            </h3>
            
            <form id="pageForm" method="post" action="${pageContext.request.contextPath}/admin/cms/pages" class="space-y-4">
                <input type="hidden" name="id" id="pageId"> 
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="form-group">
                        <label for="pageSlug">Slug (URL Path):</label>
                        <input type="text" name="slug" id="pageSlug" placeholder="/about-us" required>
                    </div>
                    <div class="form-group">
                        <label for="pageTitle">Page Title:</label>
                        <input type="text" name="title" id="pageTitle" placeholder="About Us" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="pageContent">Content:</label>
                    <textarea name="content" id="pageContent" rows="10" placeholder="Enter the main content of the page..."></textarea>
                </div>
                
                <div class="form-group w-full md:w-1/3">
                    <label for="pageStatus">Status:</label>
                    <select name="status" id="pageStatus">
                        <option value="DRAFT">Draft</option>
                        <option value="PUBLISHED">Published</option>
                        <option value="ARCHIVED">Archived</option>
                    </select>
                </div>

                <div class="flex space-x-4 pt-4">
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3-3m0 0L8 14m3-3v6"></path>
                        </svg>
                        <span id="submitBtnText">Save New Page</span>
                    </button>
                    <button type="button" id="cancelFormBtn" class="btn btn-secondary">Cancel</button>
                </div>
            </form>
        </div>

        <div class="bg-white p-6 rounded-xl shadow-lg">
            <h3 class="text-2xl font-semibold mb-6 text-gray-700">Existing CMS Pages</h3>
            
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Page Title</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Slug / URL</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Last Updated</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:choose>
                            <c:when test="${not empty pages}">
                                <c:forEach var="page" items="${pages}">
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${page.title}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <c:choose>
                                                <c:when test="${page.status == 'PUBLISHED'}">
                                                    <a href="${pageContext.request.contextPath}/pages/${page.slug}" 
                                                       target="_blank" 
                                                       class="text-blue-600 hover:text-blue-800 underline font-mono text-sm">
                                                        /${page.slug}
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <code class="bg-gray-100 px-2 py-1 rounded font-mono text-sm">/${page.slug}</code>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                                                <c:choose>
                                                    <c:when test="${page.status == 'PUBLISHED'}">status-published</c:when>
                                                    <c:when test="${page.status == 'DRAFT'}">status-draft</c:when>
                                                    <c:when test="${page.status == 'ARCHIVED'}">status-archived</c:when>
                                                    <c:otherwise>bg-gray-200 text-gray-700</c:otherwise>
                                                </c:choose>">
                                                ${page.status}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <fmt:formatDate value="${page.updatedAt}" pattern="MMM dd, yyyy HH:mm"/>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                                            <button onclick="editPage(${page.id})" class="btn btn-sm btn-info">Edit</button>
                                            <form action="${pageContext.request.contextPath}/admin/cms/pages" method="post" style="display: inline;">
                                                <input type="hidden" name="id" value="${page.id}">
                                                <input type="hidden" name="action" value="delete">
                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete \"${page.title}\"?')">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="px-6 py-4 text-center text-gray-500">No CMS pages found. Start by adding one above!</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <script>
            const formContainer = document.getElementById('pageFormContainer');
            const toggleBtn = document.getElementById('toggleFormBtn');
            const cancelBtn = document.getElementById('cancelFormBtn');
            const formTitle = document.getElementById('formTitle');
            const submitBtnText = document.getElementById('submitBtnText');
            const submitBtn = document.getElementById('submitBtn');
            const pageForm = document.getElementById('pageForm');

            // Hide form by default
            formContainer.style.display = 'none';

            toggleBtn.addEventListener('click', () => {
                resetForm();
                formTitle.textContent = 'Create New Page';
                submitBtnText.textContent = 'Save New Page';
                toggleBtn.style.display = 'none';
                formContainer.style.display = 'block';
                // Scroll to form
                formContainer.scrollIntoView({ behavior: 'smooth' });
            });

            cancelBtn.addEventListener('click', () => {
                formContainer.style.display = 'none';
                toggleBtn.style.display = 'block';
                resetForm();
            });

            function resetForm() {
                pageForm.reset();
                document.getElementById('pageId').value = '';
                document.getElementById('pageStatus').value = 'DRAFT';
            }

            // Working edit function with AJAX
            function editPage(pageId) {
                // Show loading state
                submitBtn.disabled = true;
                submitBtn.classList.add('loading');
                submitBtnText.textContent = 'Loading...';

                // Fetch page data from server
                fetch('${pageContext.request.contextPath}/admin/cms/pages?action=fetch&id=' + pageId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok: ' + response.statusText);
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.error) {
                            throw new Error(data.error);
                        }
                        
                        // Populate form with data
                        document.getElementById('pageId').value = data.id;
                        document.getElementById('pageTitle').value = data.title;
                        document.getElementById('pageSlug').value = data.slug;
                        document.getElementById('pageContent').value = data.content;
                        document.getElementById('pageStatus').value = data.status;

                        formTitle.textContent = 'Edit Page: ' + data.title;
                        submitBtnText.textContent = 'Update Page';
                        toggleBtn.style.display = 'none';
                        formContainer.style.display = 'block';
                        
                        // Scroll to form
                        formContainer.scrollIntoView({ behavior: 'smooth' });
                    })
                    .catch(err => {
                        alert('Failed to load page data: ' + err.message);
                        console.error('Error loading page:', err);
                    })
                    .finally(() => {
                        // Remove loading state
                        submitBtn.disabled = false;
                        submitBtn.classList.remove('loading');
                        submitBtnText.textContent = document.getElementById('pageId').value ? 'Update Page' : 'Save New Page';
                    });
            }

            // Form validation
            pageForm.addEventListener('submit', function(e) {
                const slug = document.getElementById('pageSlug').value.trim();
                const title = document.getElementById('pageTitle').value.trim();
                
                if (!slug || !title) {
                    e.preventDefault();
                    alert('Please fill in all required fields.');
                    return;
                }
                
                // Validate slug format (optional)
                if (!slug.startsWith('/')) {
                    if (!confirm('Slug should usually start with "/". Continue anyway?')) {
                        e.preventDefault();
                        return;
                    }
                }
            });
        </script>
    </div>
</body>
</html>