<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Services - EMS CMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'primary': '#1e3a8a',
                        'primary-hover': '#64748b',
                        'secondary': '#4b5563',
                        'secondary-hover': '#374151',
                        'accent': '#0d9488',
                        'accent-hover': '#087f73',
                        'success': '#10b981',
                        'success-hover': '#059669',
                        'danger': '#ef4444',
                        'danger-hover': '#dc2626',
                        'info': '#3b82f6',
                        'info-hover': '#2563eb',
                        'body-bg': '#f9fafb',
                        'card-bg': '#ffffff',
                        'sidebar-bg': '#1f2937',
                    }
                }
            }
        }
    </script>
    
    <style>
        /* Admin Dashboard CSS Styles */
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

        /* Buttons */
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

        .btn-info {
            background-color: var(--info-color);
            color: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .btn-info:hover {
            background-color: var(--info-color-hover);
            box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
        }

        .btn-sm {
            padding: 0.3rem 0.6rem;
            font-size: 0.8rem;
            border-radius: 0.3rem;
        }

        /* Forms */
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

        /* Dashboard Sections */
        .dashboard-section {
            background-color: var(--card-bg);
            padding: 2rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            margin-bottom: 2rem;
            overflow: hidden;
            width: 100%;
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
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 1rem;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background-color: var(--card-bg);
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            text-align: center;
            border: 1px solid #e2e8f0;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-card h4 {
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .stat-card p {
            font-size: 1rem;
            color: var(--secondary-color);
        }

        .stat-card.secondary {
            border-color: #ffedd5;
        }

        .stat-card.secondary h4 {
            color: #f97316;
        }

        .stat-card.accent {
            border-color: #dcfce7;
        }

        .stat-card.accent h4 {
            color: #10b981;
        }

        /* Tables */
        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
            white-space: nowrap;
            font-size: 0.875rem;
        }

        th {
            background-color: #f9fafb;
            font-weight: 600;
            color: #374151;
            text-transform: uppercase;
            font-size: 0.75rem;
        }

        tr:hover {
            background-color: #f3f4f6;
        }

        /* Modals */
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

        .modal.show {
            display: flex;
        }

        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 2rem;
            border-radius: 0.75rem;
            width: 90%;
            max-width: 800px;
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

        /* Service Specific Styles */
        .feature-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: all 0.2s ease;
            background-color: #f9fafb;
        }

        .feature-item:hover {
            border-color: #3b82f6;
            background: #f8fafc;
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .loading-spinner {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        /* Back Button */
        .back-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
        }

        /* Responsive */
        @media (max-width: 768px) {
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

<body class="font-sans bg-body-bg text-gray-800 min-h-screen antialiased">

    <!-- Header with Back Button -->
    <div class="bg-white shadow-sm border-b">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-4">
                <div class="flex items-center">
                    <span class="text-2xl font-bold text-accent mr-2">EMS</span>
                    <span class="text-xl font-semibold text-gray-800">CMS</span>
                </div>
                <button onclick="goBackToCMS()" class="back-button flex items-center gap-2">
                    <i class="fas fa-arrow-left"></i>
                    Back to CMS Dashboard
                </button>
            </div>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <main class="w-full">
            
            <header class="mb-8">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-extrabold text-primary">
                            <i class="fas fa-concierge-bell mr-3"></i>Service Management
                        </h1>
                        <p class="text-secondary">Create, edit, and manage your services and features</p>
                    </div>
                </div>
            </header>

            <hr class="mb-8"/>

            <!-- Quick Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <p class="text-sm font-medium text-gray-500">Total Services</p>
                    <h4 class="text-primary" id="totalServices">0</h4>
                </div>
                <div class="stat-card secondary">
                    <p class="text-sm font-medium text-gray-500">Active Services</p>
                    <h4 class="text-primary" id="activeServices">0</h4>
                </div>
                <div class="stat-card accent">
                    <p class="text-sm font-medium text-gray-500">Total Features</p>
                    <h4 class="text-primary" id="totalFeatures">0</h4>
                </div>
                <div class="stat-card">
                    <p class="text-sm font-medium text-gray-500">Process Steps</p>
                    <h4 class="text-primary" id="processSteps">4</h4>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="dashboard-section">
                <div class="flex flex-wrap gap-4 justify-between items-center">
                    <div>
                        <h2 class="text-xl font-bold text-primary">Services</h2>
                        <p class="text-secondary">Manage your service offerings</p>
                    </div>
                    <div class="flex gap-3">
                        <button onclick="openServiceModal()" 
                                class="btn btn-primary">
                            <i class="fas fa-plus mr-2"></i> New Service
                        </button>
                        <button onclick="loadServices()" 
                                class="btn btn-secondary">
                            <i class="fas fa-sync-alt mr-2"></i> Refresh
                        </button>
                    </div>
                </div>
            </div>

            <!-- Services Table -->
            <div class="dashboard-section">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Service</th>
                                <th>Price</th>
                                <th>Features</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="servicesTableBody">
                            <tr>
                                <td colspan="5" class="text-center text-gray-500 py-8">
                                    <i class="fas fa-spinner fa-spin text-2xl mb-2"></i>
                                    <p>Loading services...</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Process Steps Management -->
            <div class="dashboard-section">
                <div class="border-b border-gray-200 pb-4 mb-4">
                    <h3 class="text-xl font-bold text-primary">
                        <i class="fas fa-list-ol mr-2"></i>Process Steps Management
                    </h3>
                    <p class="text-secondary">Manage your 4-step process displayed on the services page</p>
                </div>
                <div id="processStepsContainer">
                    <!-- Process steps will be loaded here -->
                </div>
            </div>

        </main>
    </div>

    <!-- Service Editor Modal -->
    <div class="modal" id="serviceModal">
        <div class="modal-content">
            <span class="close-button" onclick="closeServiceModal()">&times;</span>
            <h3 class="text-2xl font-bold text-primary mb-4" id="modalTitle">Create New Service</h3>

            <form id="serviceForm" class="space-y-6">
                <input type="hidden" id="serviceId" name="id">
                
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <!-- Left Column -->
                    <div class="space-y-4">
                        <div class="form-group">
                            <label for="serviceName">Service Name *</label>
                            <input type="text" id="serviceName" name="name" required>
                        </div>

                        <div class="form-group">
                            <label for="shortDescription">Short Description *</label>
                            <textarea id="shortDescription" name="short_description" rows="2" required></textarea>
                        </div>

                        <div class="form-group">
                            <label for="description">Full Description *</label>
                            <textarea id="description" name="description" rows="4" required></textarea>
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div class="form-group">
                                <label for="basePrice">Base Price *</label>
                                <input type="number" id="basePrice" name="base_price" min="0" step="0.01" required>
                            </div>
                            <div class="form-group">
                                <label for="currency">Currency *</label>
                                <select id="currency" name="currency" required>
                                    <option value="NPR">NPR (Nepalese Rupee)</option>
                                    <option value="USD">USD (US Dollar)</option>
                                    <option value="EUR">EUR (Euro)</option>
                                    <option value="GBP">GBP (British Pound)</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="status">Status</label>
                                <select id="status" name="status">
                                    <option value="active">Active</option>
                                    <option value="inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div class="space-y-4">
                        <div class="form-group">
                            <label for="iconClass">Icon Class *</label>
                            <input type="text" id="iconClass" name="icon_class" required placeholder="fas fa-ring">
                            <p class="text-sm text-gray-500 mt-1">Font Awesome icon class (e.g., fas fa-ring, fas fa-building)</p>
                        </div>

                        <div class="form-group">
                            <label for="imageUrl">Image URL</label>
                            <input type="url" id="imageUrl" name="image_url" placeholder="https://example.com/image.jpg">
                        </div>

                        <div class="form-group">
                            <label for="newFeature">Service Features</label>
                            <div id="featuresContainer" class="space-y-2 mb-4">
                                <!-- Features will be added here dynamically -->
                            </div>
                            <div class="flex gap-2">
                                <input type="text" id="newFeature" placeholder="New feature description" class="flex-1">
                                <button type="button" onclick="addFeature()" class="btn btn-primary">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="flex gap-4 pt-6 border-t border-gray-200">
                    <button type="submit" class="btn btn-success flex-1">
                        <i class="fas fa-save mr-2"></i> Save Service
                    </button>
                    <button type="button" onclick="closeServiceModal()" class="btn btn-secondary flex-1">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

   <script>
    let currentServices = [];
    let currentProcessSteps = [];
    let currentFeatures = [];

    // Back to CMS function
    function goBackToCMS() {
        window.location.href = '<%= request.getContextPath() %>/admin/dashboard';
    }

    // Initialize when page loads
    document.addEventListener('DOMContentLoaded', function() {
        loadAllData();
        setupFormHandlers();
        
        // Add keyboard shortcut for back button (Esc key)
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                goBackToCMS();
            }
        });
    });

    function setupFormHandlers() {
        // Form submission
        document.getElementById('serviceForm').addEventListener('submit', function(e) {
            e.preventDefault();
            saveService();
        });

        // Allow pressing Enter in feature input to add feature
        document.getElementById('newFeature').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                addFeature();
            }
        });

        // Close modal when clicking outside
        document.getElementById('serviceModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeServiceModal();
            }
        });
    }

    function loadAllData() {
        fetch('<%= request.getContextPath() %>/admin/services')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    currentServices = data.services;
                    currentProcessSteps = data.processSteps;
                    updateServicesTable(currentServices);
                    updateStats(currentServices);
                    renderProcessSteps(currentProcessSteps);
                } else {
                    throw new Error(data.error || 'Failed to load data');
                }
            })
            .catch(error => {
                console.error('Error loading data:', error);
                showError('servicesTableBody', 'Error loading services data');
            });
    }

    function loadServices() {
        fetch('<%= request.getContextPath() %>/admin/services?action=list')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    currentServices = data.services;
                    updateServicesTable(currentServices);
                    updateStats(currentServices);
                } else {
                    throw new Error(data.error || 'Failed to load services');
                }
            })
            .catch(error => {
                console.error('Error loading services:', error);
                showError('servicesTableBody', 'Error loading services');
            });
    }

    function updateServicesTable(services) {
        const tbody = document.getElementById('servicesTableBody');
        
        if (!services || services.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="5" class="text-center text-gray-500 py-8">
                        <i class="fas fa-concierge-bell text-2xl mb-2"></i>
                        <p>No services found</p>
                        <button onclick="openServiceModal()" class="mt-2 text-primary hover:underline">
                            Create your first service
                        </button>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = services.map(service => {
            const statusClass = service.active ? 
                'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800';
            const statusText = service.active ? 'Active' : 'Inactive';
            const featureCount = service.features ? service.features.length : 0;
            
            return `
                <tr>
                    <td>
                        <div class="flex items-center">
                            <div class="flex-shrink-0 h-10 w-10 bg-blue-100 rounded-lg flex items-center justify-center">
                                <i class="${service.iconClass} text-blue-600 text-lg"></i>
                            </div>
                            <div class="ml-4">
                                <div class="text-sm font-medium text-gray-900">${service.name}</div>
                                <div class="text-sm text-gray-500 truncate max-w-xs">${service.shortDescription}</div>
                            </div>
                        </div>
                    </td>
                    <td class="text-sm text-gray-900">
                        NPR ${service.basePrice.toLocaleString()}
                    </td>
                    <td class="text-sm text-gray-500">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                            ${featureCount} features
                        </span>
                    </td>
                    <td>
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${statusClass}">
                            ${statusText}
                        </span>
                    </td>
                    <td>
                        <div class="flex gap-2">
                            <button onclick="editService(${service.id})" 
                                    class="btn btn-primary btn-sm"
                                    title="Edit Service">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button onclick="toggleServiceStatus(${service.id})" 
                                    class="btn btn-info btn-sm"
                                    title="${service.active ? 'Deactivate' : 'Activate'} Service">
                                <i class="fas fa-toggle-${service.active ? 'on' : 'off'}"></i>
                            </button>
                            <button onclick="deleteService(${service.id})" 
                                    class="btn btn-danger btn-sm"
                                    title="Delete Service">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `;
        }).join('');
    }

    function updateStats(services) {
        const total = services.length;
        const active = services.filter(service => service.active).length;
        const totalFeatures = services.reduce((sum, service) => sum + (service.features ? service.features.length : 0), 0);
        const processStepsCount = currentProcessSteps.length;

        document.getElementById('totalServices').textContent = total;
        document.getElementById('activeServices').textContent = active;
        document.getElementById('totalFeatures').textContent = totalFeatures;
        document.getElementById('processSteps').textContent = processStepsCount;
    }

    function renderProcessSteps(steps) {
        const container = document.getElementById('processStepsContainer');
        
        if (!steps || steps.length === 0) {
            container.innerHTML = `
                <div class="text-center text-gray-500 py-8">
                    <i class="fas fa-list-ol text-3xl mb-2"></i>
                    <p>No process steps configured</p>
                </div>
            `;
            return;
        }
        
        container.innerHTML = steps.map(step => `
            <div class="border border-gray-200 rounded-lg p-4 mb-4 hover:border-blue-300 transition duration-150">
                <div class="flex items-center justify-between mb-3">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                            ${step.stepNumber}
                        </div>
                        <h4 class="text-lg font-semibold text-gray-800">${step.title}</h4>
                    </div>
                    <button onclick="editProcessStep(${step.id})" 
                            class="btn btn-primary btn-sm">
                        <i class="fas fa-edit mr-1"></i> Edit
                    </button>
                </div>
                <p class="text-gray-600 pl-11">${step.description}</p>
            </div>
        `).join('');
    }

    function openServiceModal() {
        document.getElementById('serviceModal').style.display = 'flex';
        document.getElementById('modalTitle').textContent = 'Create New Service';
        document.getElementById('serviceForm').reset();
        document.getElementById('featuresContainer').innerHTML = '';
        document.getElementById('serviceId').value = '';
        currentFeatures = [];
        
        // Reset form fields
        document.getElementById('status').value = 'active';
        document.getElementById('currency').value = 'NPR';
    }

    function closeServiceModal() {
        document.getElementById('serviceModal').style.display = 'none';
    }

    // Feature Management
    function addFeature() {
        const featureInput = document.getElementById('newFeature');
        const featureText = featureInput.value.trim();
        
        if (featureText) {
            const featureId = Date.now(); // Temporary ID
            currentFeatures.push({
                id: featureId,
                featureText: featureText,
                iconClass: 'fas fa-check',
                displayOrder: currentFeatures.length
            });
            
            renderFeatures();
            featureInput.value = '';
            featureInput.focus();
        }
    }

    function removeFeature(featureId) {
        currentFeatures = currentFeatures.filter(f => f.id !== featureId);
        renderFeatures();
    }

    function renderFeatures() {
        const container = document.getElementById('featuresContainer');
        
        if (currentFeatures.length === 0) {
            container.innerHTML = '<p class="text-gray-500 text-sm">No features added yet</p>';
            return;
        }
        
        container.innerHTML = currentFeatures.map((feature, index) => `
            <div class="feature-item">
                <i class="${feature.iconClass} text-green-500 flex-shrink-0"></i>
                <span class="flex-1 text-sm">${feature.featureText}</span>
                <div class="flex gap-1">
                    <span class="text-xs text-gray-400 bg-white px-2 py-1 rounded">${index + 1}</span>
                    <button onclick="removeFeature(${feature.id})" 
                            class="text-red-500 hover:text-red-700 transition duration-150 p-1 rounded hover:bg-red-50">
                        <i class="fas fa-times text-sm"></i>
                    </button>
                </div>
            </div>
        `).join('');
    }

    // Service CRUD Operations
    function saveService() {
        const serviceId = document.getElementById('serviceId').value;
        const formData = new FormData();
        
        // Collect form data
        formData.append('id', serviceId);
        formData.append('name', document.getElementById('serviceName').value);
        formData.append('description', document.getElementById('description').value);
        formData.append('short_description', document.getElementById('shortDescription').value);
        formData.append('base_price', document.getElementById('basePrice').value);
        formData.append('currency', document.getElementById('currency').value);
        formData.append('image_url', document.getElementById('imageUrl').value);
        formData.append('icon_class', document.getElementById('iconClass').value);
        formData.append('status', document.getElementById('status').value);
        
        // Add features
        currentFeatures.forEach((feature, index) => {
            formData.append('features[]', feature.featureText);
            formData.append('feature_icons[]', feature.iconClass);
        });
        
        const action = serviceId ? 'update' : 'add';
        const url = `<%= request.getContextPath() %>/admin/services?action=${action}`;
        
        showLoading('Saving service...');
        
        fetch(url, {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showSuccess(data.message || 'Service saved successfully!');
                closeServiceModal();
                loadAllData();
            } else {
                throw new Error(data.error || 'Failed to save service');
            }
        })
        .catch(error => {
            console.error('Error saving service:', error);
            showError('modal', 'Error saving service: ' + error.message);
        })
        .finally(() => {
            hideLoading();
        });
    }

    function editService(id) {
        const service = currentServices.find(s => s.id === id);
        if (service) {
            document.getElementById('modalTitle').textContent = 'Edit Service';
            document.getElementById('serviceId').value = service.id;
            document.getElementById('serviceName').value = service.name;
            document.getElementById('shortDescription').value = service.shortDescription;
            document.getElementById('description').value = service.description;
            document.getElementById('basePrice').value = service.basePrice;
            document.getElementById('currency').value = service.currency;
            document.getElementById('status').value = service.active ? 'active' : 'inactive';
            document.getElementById('iconClass').value = service.iconClass;
            document.getElementById('imageUrl').value = service.imageUrl || '';
            
            currentFeatures = service.features ? [...service.features] : [];
            renderFeatures();
            
            document.getElementById('serviceModal').style.display = 'flex';
        } else {
            showError('servicesTableBody', 'Service not found');
        }
    }

    function toggleServiceStatus(id) {
        const service = currentServices.find(s => s.id === id);
        const action = service.active ? 'deactivate' : 'activate';
        
        if (confirm(`Are you sure you want to ${action} this service?`)) {
            showLoading(`${action == 'activate' ? 'Activating' : 'Deactivating'} service...`);
            
            fetch(`<%= request.getContextPath() %>/admin/services?action=toggle&id=${id}`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccess(`Service ${action}d successfully!`);
                    loadAllData();
                } else {
                    throw new Error(data.error || `Failed to ${action} service`);
                }
            })
            .catch(error => {
                console.error(`Error ${action}ing service:`, error);
                showError('servicesTableBody', `Error ${action}ing service: ` + error.message);
            })
            .finally(() => {
                hideLoading();
            });
        }
    }

       function deleteService(id) {
        const service = currentServices.find(s => s.id === id);
        
        if (confirm(`Are you sure you want to delete "${service.name}"? This action cannot be undone.`)) {
            showLoading('Deleting service...');
            
            fetch(`<%= request.getContextPath() %>/admin/services?action=delete&id=${id}`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showSuccess('Service deleted successfully!');
                    loadAllData();
                } else {
                    throw new Error(data.error || 'Failed to delete service');
                }
            })
            .catch(error => {
                console.error('Error deleting service:', error);
                showError('servicesTableBody', 'Error deleting service: ' + error.message);
            })
            .finally(() => {
                hideLoading();
            });
        }
    }

    function editProcessStep(id) {
        const step = currentProcessSteps.find(s => s.id === id);
        if (step) {
            const newTitle = prompt('Enter new title for step ' + step.stepNumber + ':', step.title);
            if (newTitle !== null) {
                const newDescription = prompt('Enter new description:', step.description);
                if (newDescription !== null) {
                    updateProcessStep(id, newTitle, newDescription);
                }
            }
        }
    }

    function updateProcessStep(id, title, description) {
        showLoading('Updating process step...');
        
        const formData = new FormData();
        formData.append('id', id);
        formData.append('title', title);
        formData.append('description', description);
        
        fetch('<%= request.getContextPath() %>/admin/services?action=updateProcessStep', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showSuccess('Process step updated successfully!');
                loadAllData();
            } else {
                throw new Error(data.error || 'Failed to update process step');
            }
        })
        .catch(error => {
            console.error('Error updating process step:', error);
            showError('processStepsContainer', 'Error updating process step: ' + error.message);
        })
        .finally(() => {
            hideLoading();
        });
    }

    // Utility Functions
    function showLoading(message = 'Loading...') {
        // Remove existing loading overlay if any
        hideLoading();
        
        const overlay = document.createElement('div');
        overlay.className = 'loading-overlay';
        overlay.id = 'loadingOverlay';
        overlay.innerHTML = `
            <div class="loading-spinner">
                <i class="fas fa-spinner fa-spin text-2xl text-primary"></i>
                <span class="text-lg font-medium">${message}</span>
            </div>
        `;
        document.body.appendChild(overlay);
    }

    function hideLoading() {
        const existingOverlay = document.getElementById('loadingOverlay');
        if (existingOverlay) {
            existingOverlay.remove();
        }
    }

    function showSuccess(message) {
        showMessage(message, 'success');
    }

    function showError(elementId, message) {
        if (elementId === 'modal') {
            // Show error in modal context
            const modalContent = document.querySelector('.modal-content');
            const existingError = modalContent.querySelector('.message-box.error');
            if (existingError) existingError.remove();
            
            const errorDiv = document.createElement('div');
            errorDiv.className = 'message-box error';
            errorDiv.innerHTML = `<i class="fas fa-exclamation-circle mr-2"></i>${message}`;
            modalContent.insertBefore(errorDiv, modalContent.firstChild);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                if (errorDiv.parentNode) {
                    errorDiv.remove();
                }
            }, 5000);
        } else {
            showMessage(message, 'error', elementId);
        }
    }

    function showMessage(message, type, containerId = null) {
        // Remove existing messages
        const existingMessages = document.querySelectorAll('.message-box');
        existingMessages.forEach(msg => msg.remove());
        
        const messageDiv = document.createElement('div');
        messageDiv.className = `message-box ${type}`;
        messageDiv.innerHTML = `
            <i class="fas fa-${type == 'success' ? 'check-circle' : 'exclamation-circle'} mr-2"></i>
            ${message}
        `;
        
        if (containerId) {
            const container = document.getElementById(containerId);
            if (container) {
                container.insertBefore(messageDiv, container.firstChild);
            } else {
                document.querySelector('main').insertBefore(messageDiv, document.querySelector('main').firstChild);
            }
        } else {
            document.querySelector('main').insertBefore(messageDiv, document.querySelector('main').firstChild);
        }
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.remove();
            }
        }, 5000);
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl + N for new service
        if (e.ctrlKey && e.key === 'n') {
            e.preventDefault();
            openServiceModal();
        }
        
        // Escape to close modal
        if (e.key === 'Escape') {
            if (document.getElementById('serviceModal').style.display === 'flex') {
                closeServiceModal();
            }
        }
    });

    // Auto-refresh data every 30 seconds
    setInterval(() => {
        if (!document.getElementById('serviceModal').style.display === 'flex') {
            loadServices();
        }
    }, 30000);

    // Export functions for global access
    window.goBackToCMS = goBackToCMS;
    window.openServiceModal = openServiceModal;
    window.closeServiceModal = closeServiceModal;
    window.loadServices = loadServices;
    window.editService = editService;
    window.toggleServiceStatus = toggleServiceStatus;
    window.deleteService = deleteService;
    window.addFeature = addFeature;
    window.removeFeature = removeFeature;
    window.editProcessStep = editProcessStep;
    // Function to add features to services lacking them
function populateMissingFeatures() {
    const featureTemplates = {
        3: [ // Private Parties
            "Theme customization",
            "Entertainment coordination", 
            "Catering arrangements",
            "Guest list management",
            "Party favors & gifts"
        ],
        4: [ // Vendor Management
            "Curated vendor selection",
            "Contract negotiation",
            "Quality assurance",
            "Payment processing",
            "Vendor coordination"
        ],
        5: [ // Venue Booking
            "Venue scouting & selection",
            "Contract management", 
            "Layout planning",
            "Capacity assessment",
            "Special rate access"
        ],
        6: [ // Event Decor
            "Custom theme design",
            "Floral arrangements",
            "Lighting design",
            "Furniture rental",
            "Setup & teardown"
        ]
    };

    // This would be called from your admin interface
    Object.keys(featureTemplates).forEach(serviceId => {
        const service = currentServices.find(s => s.id == serviceId);
        if (service && (!service.features || service.features.length === 0)) {
            console.log(`Adding features to ${service.name}:`, featureTemplates[serviceId]);
            // Here you would make API calls to add these features
        }
    });
}
</script>
</body>
</html>