<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Manage Content Blocks</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLMD/CD/TftD/eT8E3/07xN2Vb/6v+x0zR4jD/8bM1Xn3Xh3/gH6f/R4g2s3rQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="/assets/css/style.css">
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
        <h1 class="text-3xl font-extrabold text-primary">Content Blocks Manager 🧩</h1>
        <button id="toggleFormBtn" class="btn btn-success">
            <svg class="w-5 h-5 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
            Create New Block
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

    <div id="blockFormContainer" class="form-container bg-card-bg p-6 rounded-xl shadow-lg mb-8">
        <h3 class="text-2xl font-semibold mb-4 text-secondary">
            <span id="formTitle">Create New Block</span>
        </h3>
        
        <form method="post" action="${request.getContextPath()}/admin/cms/blocks" class="space-y-4">
            <input type="hidden" name="id" id="blockId">
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="form-group md:col-span-2">
                    <label for="blockTitle">Title (Internal Name):</label>
                    <input type="text" name="title" id="blockTitle" placeholder="Homepage Feature 1" required>
                </div>
                <div class="form-group">
                    <label for="blockIcon">Icon (FontAwesome class):</label>
                    <input type="text" name="icon" id="blockIcon" placeholder="fas fa-lightbulb">
                </div>
            </div>

            <div class="form-group">
                <label for="blockDescription">Description / Content:</label>
                <textarea name="description" id="blockDescription" rows="5" placeholder="Enter the content for this reusable block..."></textarea>
            </div>
            
            <div class="grid grid-cols-3 gap-4">
                <div class="form-group">
                    <label for="blockPosition">Position (Sort Order):</label>
                    <input type="number" name="position" id="blockPosition" value="0" min="0">
                </div>

                <div class="form-group flex items-center pt-8">
                    <input type="checkbox" name="active" id="blockActive" checked
                           class="w-5 h-5 text-primary border-gray-300 rounded focus:ring-primary">
                    <label for="blockActive" class="ml-3 mb-0 inline-block font-normal">Active</label>
                </div>
            </div>

            <div class="flex space-x-4 pt-4">
                <button type="submit" class="btn btn-primary">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3-3m0 0L8 14m3-3v6"></path></svg>
                    <span id="submitBtnText">Save Block</span>
                </button>
                <button type="button" id="cancelFormBtn" class="btn btn-secondary">Cancel</button>
            </div>
        </form>
    </div>

    <hr class="mt-8 mb-6"/>

    <div class="bg-card-bg p-6 rounded-xl shadow-lg">
        <h3 class="text-2xl font-semibold mb-6 text-secondary">Existing Content Blocks</h3>
        
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
            <c:choose>
                <c:when test="${not empty blocks}">
                    <c:forEach var="block" items="${blocks}">
                        
                        <div class="block-card p-5 border rounded-lg shadow-md hover:shadow-xl transition duration-300">
                            
                            <div class="flex items-center space-x-4 mb-3 pb-3 border-b">
                                <i class="${block.icon} text-3xl <c:choose><c:when test="${block.active}">text-accent</c:when><c:otherwise>text-gray-400</c:otherwise></c:choose>"></i>
                                <h4 class="text-lg font-bold">${block.title}</h4>
                            </div>

                            <p class="text-sm text-gray-700 mb-3 line-clamp-3">${block.description}</p>
                                
                            <div class="flex justify-between items-center pt-2 border-t mt-2">
                                <div class="flex items-center space-x-3">
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                                        <c:choose>
                                            <c:when test="${block.active}">bg-success/10 text-success</c:when>
                                            <c:otherwise>bg-danger/10 text-danger</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${block.active}">Active</c:when>
                                            <c:otherwise>Inactive</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="text-xs text-gray-500">Pos: ${block.position}</span>
                                </div>
                                
                                <div class="space-x-1">
                                    <button class="btn btn-sm btn-info" onclick="editBlock(${block.id})">Edit</button>
                                    <button class="btn btn-sm btn-danger" onclick="deleteBlock(${block.id})">Delete</button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="col-span-full text-center py-6 text-gray-500">No content blocks have been defined yet.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <script>
        const formContainer = document.getElementById('blockFormContainer');
        const toggleBtn = document.getElementById('toggleFormBtn');
        const cancelBtn = document.getElementById('cancelFormBtn');
        const formTitle = document.getElementById('formTitle');
        const submitBtnText = document.getElementById('submitBtnText');

        // Initial state: hide the form
        formContainer.style.display = 'none';

        // Toggle Form Visibility
        toggleBtn.addEventListener('click', () => {
            // Reset form for new block creation
            document.querySelector('form').reset(); 
            document.getElementById('blockId').value = '';
            formTitle.textContent = 'Create New Block';
            submitBtnText.textContent = 'Save Block';
            toggleBtn.style.display = 'none'; // Hide the 'Add' button
            formContainer.style.display = 'block'; // Show the form
        });

        // Cancel Form Visibility
        cancelBtn.addEventListener('click', () => {
            formContainer.style.display = 'none';
            toggleBtn.style.display = 'block'; // Show the 'Add' button again
        });

        // Function to simulate 'Edit' action 
        function editBlock(blockId) {
            // In a real app, fetch data by ID and populate fields
            document.getElementById('blockId').value = blockId;
            document.getElementById('blockTitle').value = 'Fetched Title: Feature ' + blockId;
            document.getElementById('blockIcon').value = 'fas fa-rocket'; // Example icon
            document.getElementById('blockDescription').value = 'This is the content for the block with ID ' + blockId + ' being edited.';
            document.getElementById('blockPosition').value = 1;
            document.getElementById('blockActive').checked = true;

            formTitle.textContent = 'Edit Content Block (ID: ' + blockId + ')';
            submitBtnText.textContent = 'Update Block';
            toggleBtn.style.display = 'none';
            formContainer.style.display = 'block';
            
            formContainer.scrollIntoView({ behavior: 'smooth' });
        }
        
        // Function to simulate 'Delete' action 
        function deleteBlock(blockId) {
            if (confirm('Are you sure you want to delete block ID: ' + blockId + '?')) {
                alert('Delete action simulated for block ID: ' + blockId);
            }
        }

    </script>
</div>
</html>