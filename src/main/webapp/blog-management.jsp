<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Manage Blog - EMS CMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              'primary': '#3b82f6',
              'primary-hover': '#2563eb',
              'secondary': '#6b7280',
              'accent': '#f59e0b',
              'body-bg': '#f8fafc',
              'card-bg': '#ffffff',
              'sidebar-bg': '#1f2937',
              'success': '#10b981',
              'danger': '#ef4444',
              'info': '#06b6d4',
            }
          }
        }
      }
    </script>
    
    <style>
        .rich-text-editor {
            min-height: 300px;
            border: 1px solid #d1d5db;
            border-radius: 0.5rem;
            padding: 1rem;
        }
        .editor-toolbar {
            background: #f9fafb;
            border: 1px solid #d1d5db;
            border-bottom: none;
            border-radius: 0.5rem 0.5rem 0 0;
            padding: 0.5rem;
            display: flex;
            gap: 0.25rem;
            flex-wrap: wrap;
        }
        .editor-btn {
            padding: 0.5rem;
            border: 1px solid #d1d5db;
            border-radius: 0.25rem;
            background: white;
            cursor: pointer;
            transition: all 0.2s;
        }
        .editor-btn:hover {
            background: #f3f4f6;
        }
        .image-preview {
            max-width: 200px;
            max-height: 150px;
            border-radius: 0.5rem;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .modal.show {
            display: flex;
        }
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
                            <i class="fas fa-blog mr-3"></i>Blog Management
                        </h1>
                        <p class="text-secondary">Create, edit, and manage your blog posts</p>
                    </div>
                </div>
            </header>

            <hr class="mb-8"/>

            <!-- Quick Stats -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <div class="bg-card-bg p-6 rounded-xl shadow-lg border-t-4 border-primary">
                    <p class="text-sm font-medium text-gray-500">Total Posts</p>
                    <p class="text-4xl font-bold mt-1 text-primary" id="totalPosts">0</p>
                </div>
                <div class="bg-card-bg p-6 rounded-xl shadow-lg border-t-4 border-success">
                    <p class="text-sm font-medium text-gray-500">Published</p>
                    <p class="text-4xl font-bold mt-1 text-success" id="publishedPosts">0</p>
                </div>
                <div class="bg-card-bg p-6 rounded-xl shadow-lg border-t-4 border-accent">
                    <p class="text-sm font-medium text-gray-500">Drafts</p>
                    <p class="text-4xl font-bold mt-1 text-accent" id="draftPosts">0</p>
                </div>
                <div class="bg-card-bg p-6 rounded-xl shadow-lg border-t-4 border-info">
                    <p class="text-sm font-medium text-gray-500">This Month</p>
                    <p class="text-4xl font-bold mt-1 text-info" id="monthPosts">0</p>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="bg-card-bg p-6 rounded-xl shadow-lg mb-8">
                <div class="flex flex-wrap gap-4 justify-between items-center">
                    <div>
                        <h2 class="text-xl font-bold text-primary">Blog Posts</h2>
                        <p class="text-secondary">Manage your blog content</p>
                    </div>
                    <div class="flex gap-3">
                        <button onclick="openBlogModal()" 
                                class="bg-primary hover:bg-primary-hover text-white px-6 py-3 rounded-lg font-semibold transition duration-200 flex items-center">
                            <i class="fas fa-plus mr-2"></i> New Post
                        </button>
                        <button onclick="refreshBlogs()" 
                                class="bg-secondary hover:bg-gray-600 text-white px-6 py-3 rounded-lg font-semibold transition duration-200 flex items-center">
                            <i class="fas fa-sync-alt mr-2"></i> Refresh
                        </button>
                    </div>
                </div>
            </div>

            <!-- Blog Posts Table -->
            <div class="bg-card-bg rounded-xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Post</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Author</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200" id="blogTableBody">
                            <!-- Blog posts will be loaded here dynamically -->
                            <tr>
                                <td colspan="6" class="px-6 py-8 text-center text-gray-500">
                                    <i class="fas fa-spinner fa-spin text-2xl mb-2"></i>
                                    <p>Loading blog posts...</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination -->
            <div class="flex justify-between items-center mt-6" id="paginationContainer">
                <!-- Pagination will be loaded here -->
            </div>

        </main>
    </div>

    <!-- Blog Editor Modal -->
    <div class="modal" id="blogModal">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-4xl max-h-[90vh] overflow-y-auto m-4">
            <div class="p-6 border-b border-gray-200">
                <div class="flex justify-between items-center">
                    <h3 class="text-2xl font-bold text-primary" id="modalTitle">Create New Blog Post</h3>
                    <button onclick="closeBlogModal()" class="text-gray-400 hover:text-gray-600 text-2xl">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>

            <form id="blogForm" enctype="multipart/form-data" class="p-6 space-y-6">
                <input type="hidden" id="blogId" name="id">
                
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <!-- Left Column -->
                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Title *</label>
                            <input type="text" id="title" name="title" required 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Slug *</label>
                            <input type="text" id="slug" name="slug" required 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                            <p class="text-sm text-gray-500 mt-1">URL-friendly version of the title</p>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Excerpt *</label>
                            <textarea id="excerpt" name="excerpt" rows="3" required 
                                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Category *</label>
                                <select id="category" name="category" required 
                                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                                    <option value="">Select Category</option>
                                    <option value="Wedding">Wedding</option>
                                    <option value="Corporate">Corporate</option>
                                    <option value="Private Parties">Private Parties</option>
                                    <option value="Event Tips">Event Tips</option>
                                    <option value="Vendor Spotlight">Vendor Spotlight</option>
                                </select>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Status *</label>
                                <select id="status" name="status" required 
                                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                                    <option value="draft">Draft</option>
                                    <option value="published">Published</option>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Tags</label>
                            <input type="text" id="tags" name="tags" 
                                   placeholder="wedding, corporate, tips" 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Author *</label>
                            <input type="text" id="author" name="author" required 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div class="space-y-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Featured Image</label>
                            <div class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center cursor-pointer hover:border-primary transition duration-200"
                                 onclick="document.getElementById('featuredImage').click()">
                                <i class="fas fa-cloud-upload-alt text-3xl text-gray-400 mb-2"></i>
                                <p class="text-sm text-gray-600">Click to upload featured image</p>
                                <p class="text-xs text-gray-500 mt-1">PNG, JPG, GIF up to 10MB</p>
                                <img id="imagePreview" class="image-preview mt-4 mx-auto hidden" alt="Preview">
                            </div>
                            <input type="file" id="featuredImage" name="featuredImage" accept="image/*" 
                                   class="hidden" onchange="previewImage(this)">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Content *</label>
                            <div class="editor-toolbar">
                                <button type="button" class="editor-btn" onclick="formatText('bold')"><i class="fas fa-bold"></i></button>
                                <button type="button" class="editor-btn" onclick="formatText('italic')"><i class="fas fa-italic"></i></button>
                                <button type="button" class="editor-btn" onclick="formatText('underline')"><i class="fas fa-underline"></i></button>
                                <button type="button" class="editor-btn" onclick="insertImage()"><i class="fas fa-image"></i></button>
                                <button type="button" class="editor-btn" onclick="createLink()"><i class="fas fa-link"></i></button>
                                <button type="button" class="editor-btn" onclick="formatText('insertUnorderedList')"><i class="fas fa-list-ul"></i></button>
                                <button type="button" class="editor-btn" onclick="formatText('insertOrderedList')"><i class="fas fa-list-ol"></i></button>
                            </div>
                            <textarea id="content" name="content" required 
                                      class="rich-text-editor w-full border border-gray-300 rounded-b-lg focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
                        </div>
                    </div>
                </div>

                <div class="flex gap-4 pt-6 border-t border-gray-200">
                    <button type="submit" 
                            class="flex-1 bg-primary hover:bg-primary-hover text-white py-3 px-6 rounded-lg font-semibold transition duration-200 flex items-center justify-center">
                        <i class="fas fa-save mr-2"></i> Save Post
                    </button>
                    <button type="button" onclick="closeBlogModal()" 
                            class="flex-1 bg-gray-500 hover:bg-gray-600 text-white py-3 px-6 rounded-lg font-semibold transition duration-200">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
    // Back to CMS function
    function goBackToCMS() {
        window.location.href = '<%= request.getContextPath() %>/admin/dashboard';
    }

    // Initialize when page loads
    document.addEventListener('DOMContentLoaded', function() {
        loadBlogs();
        setupFormHandlers();
        
        // Add keyboard shortcut for back button (Esc key)
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                goBackToCMS();
            }
        });
    });

    function setupFormHandlers() {
        // Auto-generate slug from title
        document.getElementById('title').addEventListener('input', function() {
            const slug = document.getElementById('slug');
            if (!slug.value) {
                slug.value = this.value
                    .toLowerCase()
                    .replace(/[^a-z0-9 -]/g, '')
                    .replace(/\s+/g, '-')
                    .replace(/-+/g, '-');
            }
        });

        // Form submission
        document.getElementById('blogForm').addEventListener('submit', function(e) {
            e.preventDefault();
            saveBlog();
        });
    }

    function loadBlogs() {
        console.log('Loading blogs...');
        fetch('<%= request.getContextPath() %>/Blog?action=list')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Blogs data received:', data);
                
                // Handle different response formats
                let blogs = [];
                if (Array.isArray(data)) {
                    blogs = data;
                } else if (data.data && Array.isArray(data.data)) {
                    blogs = data.data;
                } else if (data.success && Array.isArray(data)) {
                    blogs = data;
                }
                
                updateBlogTable(blogs);
                updateStats(blogs);
                formatTableDates();
            })
            .catch(error => {
                console.error('Error loading blogs:', error);
                document.getElementById('blogTableBody').innerHTML = 
                    '<tr>' +
                    '<td colspan="6" class="px-6 py-8 text-center text-red-500">' +
                    '<i class="fas fa-exclamation-triangle text-2xl mb-2"></i>' +
                    '<p>Error loading blog posts: ' + error.message + '</p>' +
                    '<button onclick="loadBlogs()" class="mt-2 text-primary hover:underline">Retry</button>' +
                    '</td>' +
                    '</tr>';
            });
    }

    function updateBlogTable(blogs) {
        const tbody = document.getElementById('blogTableBody');
        
        if (!blogs || blogs.length === 0) {
            tbody.innerHTML = 
                '<tr>' +
                '<td colspan="6" class="px-6 py-8 text-center text-gray-500">' +
                '<i class="fas fa-blog text-2xl mb-2"></i>' +
                '<p>No blog posts found</p>' +
                '<button onclick="openBlogModal()" class="mt-2 text-primary hover:underline">' +
                'Create your first blog post' +
                '</button>' +
                '</td>' +
                '</tr>';
            return;
        }

        tbody.innerHTML = blogs.map(blog => {
            // Safe property access with fallbacks
            const id = blog.id || '';
            const title = blog.title || 'No Title';
            const excerpt = blog.excerpt || 'No excerpt available';
            const category = blog.category || 'Uncategorized';
            const status = blog.status || 'draft';
            const author = blog.author || 'Unknown';
            const createdAt = blog.createdAt || '';
            const featuredImage = blog.featuredImage || 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=80';
            
            const statusClass = status === 'published' ? 
                'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800';
            const statusText = status === 'published' ? 'Published' : 'Draft';
            
            return '<tr class="hover:bg-gray-50 transition duration-150">' +
                   '<td class="px-6 py-4 whitespace-nowrap">' +
                   '<div class="flex items-center">' +
                   '<div class="flex-shrink-0 h-10 w-10">' +
                   '<img class="h-10 w-10 rounded-lg object-cover" ' +
                   'src="' + featuredImage + '" ' +
                   'alt="' + title + '">' +
                   '</div>' +
                   '<div class="ml-4">' +
                   '<div class="text-sm font-medium text-gray-900">' + title + '</div>' +
                   '<div class="text-sm text-gray-500 truncate max-w-xs">' + excerpt + '</div>' +
                   '</div>' +
                   '</div>' +
                   '</td>' +
                   '<td class="px-6 py-4 whitespace-nowrap">' +
                   '<span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">' +
                   category +
                   '</span>' +
                   '</td>' +
                   '<td class="px-6 py-4 whitespace-nowrap">' +
                   '<span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full ' + statusClass + '">' +
                   statusText +
                   '</span>' +
                   '</td>' +
                   '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">' +
                   author +
                   '</td>' +
                   '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500" data-date="' + createdAt + '">' +
                   formatBlogDate(createdAt) +
                   '</td>' +
                   '<td class="px-6 py-4 whitespace-nowrap text-sm font-medium">' +
                   '<div class="flex gap-2">' +
                   '<button onclick="editBlog(' + id + ')" ' +
                   'class="text-blue-500 hover:text-blue-700 transition duration-150 p-2 rounded hover:bg-blue-50">' +
                   '<i class="fas fa-edit"></i>' +
                   '</button>' +
                   '<button onclick="deleteBlog(' + id + ')" ' +
                   'class="text-red-500 hover:text-red-700 transition duration-150 p-2 rounded hover:bg-red-50">' +
                   '<i class="fas fa-trash"></i>' +
                   '</button>' +
                   '<button onclick="previewBlog(' + id + ')" ' +
                   'class="text-green-500 hover:text-green-700 transition duration-150 p-2 rounded hover:bg-green-50">' +
                   '<i class="fas fa-eye"></i>' +
                   '</button>' +
                   '</div>' +
                   '</td>' +
                   '</tr>';
        }).join('');
    }

    function formatTableDates() {
        const dateCells = document.querySelectorAll('td[data-date]');
        dateCells.forEach(cell => {
            const dateString = cell.getAttribute('data-date');
            cell.textContent = formatBlogDate(dateString);
        });
    }

    function formatBlogDate(dateString) {
        if (!dateString) return 'Not set';
        
        try {
            const date = new Date(dateString);
            
            if (isNaN(date.getTime())) {
                return 'Invalid date';
            }
            
            return date.toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric'
            });
        } catch (error) {
            console.warn('Date formatting error for:', dateString, error);
            return 'Date error';
        }
    }

    function updateStats(blogs) {
        if (!blogs || !Array.isArray(blogs)) {
            console.error('Invalid blogs data for stats:', blogs);
            return;
        }

        const total = blogs.length;
        const published = blogs.filter(blog => blog.status === 'published').length;
        const drafts = blogs.filter(blog => blog.status === 'draft').length;
        
        // Safe date handling for monthly count
        const thisMonth = blogs.filter(blog => {
            try {
                if (!blog.createdAt) return false;
                const blogDate = new Date(blog.createdAt);
                if (isNaN(blogDate.getTime())) return false;
                
                const now = new Date();
                return blogDate.getMonth() === now.getMonth() && 
                       blogDate.getFullYear() === now.getFullYear();
            } catch (error) {
                return false;
            }
        }).length;

        document.getElementById('totalPosts').textContent = total;
        document.getElementById('publishedPosts').textContent = published;
        document.getElementById('draftPosts').textContent = drafts;
        document.getElementById('monthPosts').textContent = thisMonth;
    }

    function openBlogModal() {
        document.getElementById('blogModal').classList.add('show');
        document.getElementById('modalTitle').textContent = 'Create New Blog Post';
        document.getElementById('blogForm').reset();
        document.getElementById('imagePreview').classList.add('hidden');
        document.getElementById('blogId').value = '';
    }

    function closeBlogModal() {
        document.getElementById('blogModal').classList.remove('show');
    }

    function previewImage(input) {
        const preview = document.getElementById('imagePreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.classList.remove('hidden');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    function formatText(command) {
        document.getElementById('content').focus();
        document.execCommand(command, false, null);
    }

    function insertImage() {
        const url = prompt('Enter image URL:');
        if (url) {
            document.execCommand('insertImage', false, url);
        }
    }

    function createLink() {
        const url = prompt('Enter URL:');
        if (url) {
            document.execCommand('createLink', false, url);
        }
    }

    function saveBlog() {
        const formData = new FormData(document.getElementById('blogForm'));
        
        console.log('Saving blog post...');
        
        fetch('<%= request.getContextPath() %>/Blog', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            console.log('Save response:', data);
            if (data.success) {
                alert('Blog saved successfully!');
                closeBlogModal();
                loadBlogs();
            } else {
                alert('Error saving blog: ' + (data.message || 'Unknown error'));
            }
        })
        .catch(error => {
            console.error('Error saving blog:', error);
            alert('Error saving blog: ' + error.message);
        });
    }

    function editBlog(id) {
        console.log('Editing blog with ID:', id);
        fetch('<%= request.getContextPath() %>/Blog?action=get&id=' + id)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Edit response:', data);
                
                let blog = data;
                if (data.data) {
                    blog = data.data;
                }
                
                document.getElementById('modalTitle').textContent = 'Edit Blog Post';
                document.getElementById('blogId').value = blog.id || '';
                document.getElementById('title').value = blog.title || '';
                document.getElementById('slug').value = blog.slug || '';
                document.getElementById('excerpt').value = blog.excerpt || '';
                document.getElementById('content').value = blog.content || '';
                document.getElementById('category').value = blog.category || '';
                document.getElementById('tags').value = blog.tags || '';
                document.getElementById('author').value = blog.author || '';
                document.getElementById('status').value = blog.status || 'draft';
                
                if (blog.featuredImage) {
                    document.getElementById('imagePreview').src = blog.featuredImage;
                    document.getElementById('imagePreview').classList.remove('hidden');
                } else {
                    document.getElementById('imagePreview').classList.add('hidden');
                }
                
                document.getElementById('blogModal').classList.add('show');
            })
            .catch(error => {
                console.error('Error loading blog for edit:', error);
                alert('Error loading blog: ' + error.message);
            });
    }

    function deleteBlog(id) {
        if (confirm('Are you sure you want to delete this blog post?')) {
            console.log('Deleting blog with ID:', id);
            fetch('<%= request.getContextPath() %>/Blog?id=' + id, {
                method: 'DELETE'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Delete response:', data);
                if (data.success) {
                    alert('Blog deleted successfully!');
                    loadBlogs();
                } else {
                    alert('Error deleting blog: ' + (data.message || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error deleting blog:', error);
                alert('Error deleting blog: ' + error.message);
            });
        }
    }

    function previewBlog(id) {
        window.open('<%= request.getContextPath() %>/blog-detail.jsp?id=' + id, '_blank');
    }

    function refreshBlogs() {
        document.getElementById('blogTableBody').innerHTML = 
            '<tr>' +
            '<td colspan="6" class="px-6 py-8 text-center text-gray-500">' +
            '<i class="fas fa-spinner fa-spin text-2xl mb-2"></i>' +
            '<p>Refreshing blog posts...</p>' +
            '</td>' +
            '</tr>';
        loadBlogs();
    }

    // Close modal when clicking outside
    document.getElementById('blogModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeBlogModal();
        }
    });
</script>

</body>
</html>