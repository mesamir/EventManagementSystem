/**
 * blog.js
 * Handles all client-side logic for the blog.jsp page,
 * interacting with the BlogServlet via AJAX (fetch API).
 */

document.addEventListener('DOMContentLoaded', () => {
    // Initial data load when the page is ready
    loadAllBlogComponents();
    
    // Set up the form submission handler
    const blogForm = document.getElementById('blogForm');
    if (blogForm) {
        blogForm.addEventListener('submit', handleBlogSubmit);
    }
});

/**
 * Main function to load all blog components concurrently.
 */
function loadAllBlogComponents() {
    // Start with a clean slate
    const container = document.getElementById('blogPostsContainer');
    if (container) {
        container.innerHTML = `<div class="loading-container">
                                    <i class="fas fa-spinner fa-spin loading-spinner"></i>
                                    <p>Loading blog posts...</p>
                                </div>`;
    }
    
    // Load all necessary data simultaneously
    loadBlogs();
    loadCategories();
    loadRecentPosts();
    loadPopularTags();
}

// --- DATA FETCHING FUNCTIONS ---

/**
 * Fetches and displays the main list of published blog posts.
 * @param {string} query Optional search query string.
 */
function loadBlogs(query = '') {
    const container = document.getElementById('blogPostsContainer');
    let url = '/EMS/Blog';
    if (query) {
        url += `?action=list&search=${encodeURIComponent(query)}`; // Assuming the servlet supports a 'search' parameter on the 'list' action
    }
    
    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            renderBlogPosts(data);
        })
        .catch(error => {
            console.error('Error loading blogs:', error);
            if (container) {
                container.innerHTML = '<p class="error-message">Failed to load blog posts. Please try again later.</p>';
            }
        });
}

/**
 * Fetches and displays the list of blog categories.
 */
function loadCategories() {
    const list = document.getElementById('categories-list');
    
    fetch('/EMS/Blog?action=categories')
        .then(response => response.json())
        .then(data => {
            if (list) {
                list.innerHTML = ''; // Clear loading message
                if (data.length === 0) {
                    list.innerHTML = '<li>No categories found.</li>';
                } else {
                    data.forEach(category => {
                        const li = document.createElement('li');
                        // Linking to a hypothetical category filter endpoint
                        li.innerHTML = `<a href="blog.jsp?category=${category.slug}">${category.name} <span class="count">(${category.count})</span></a>`;
                        list.appendChild(li);
                    });
                }
            }
        })
        .catch(error => {
            console.error('Error loading categories:', error);
            if (list) list.innerHTML = '<li>Error loading categories.</li>';
        });
}

/**
 * Fetches and displays the 5 most recent posts.
 */
function loadRecentPosts() {
    const list = document.getElementById('recent-posts');
    
    fetch('/EMS/Blog?action=recent')
        .then(response => response.json())
        .then(data => {
            if (list) {
                list.innerHTML = ''; // Clear loading message
                if (data.length === 0) {
                    list.innerHTML = '<li>No recent posts found.</li>';
                } else {
                    data.forEach(post => {
                        const li = document.createElement('li');
                        li.className = 'recent-post-item';
                        li.innerHTML = `
                            <a href="blog.jsp?action=get&id=${post.id}" class="post-link">
                                <img src="${post.featuredImage || 'images/default-blog-thumb.jpg'}" alt="${post.title}" class="post-thumbnail">
                                <div class="post-details">
                                    <h4 class="post-title">${post.title}</h4>
                                    <span class="post-date">${new Date(post.publishedAt).toLocaleDateString()}</span>
                                </div>
                            </a>
                        `;
                        list.appendChild(li);
                    });
                }
            }
        })
        .catch(error => {
            console.error('Error loading recent posts:', error);
            if (list) list.innerHTML = '<li>Error loading recent posts.</li>';
        });
}

/**
 * Fetches and displays the popular tags in a tag cloud.
 */
function loadPopularTags() {
    const cloud = document.getElementById('tags-cloud');
    
    fetch('/EMS/Blog?action=tags')
        .then(response => response.json())
        .then(data => {
            if (cloud) {
                cloud.innerHTML = ''; // Clear loading message
                if (data.length === 0) {
                    cloud.innerHTML = '<span>No tags yet.</span>';
                } else {
                    data.forEach(tagObj => {
                        const tag = tagObj.name;
                        const a = document.createElement('a');
                        a.href = `blog.jsp?tag=${encodeURIComponent(tag)}`; // Hypothetical tag filter URL
                        a.textContent = tag;
                        a.className = 'tag-item';
                        cloud.appendChild(a);
                    });
                }
            }
        })
        .catch(error => {
            console.error('Error loading tags:', error);
            if (cloud) cloud.innerHTML = '<span>Error loading tags.</span>';
        });
}

// --- RENDERING FUNCTIONS ---

/**
 * Renders the fetched blog posts into the main container.
 * @param {Array<Object>} blogs - Array of blog post objects.
 */
function renderBlogPosts(blogs) {
    const container = document.getElementById('blogPostsContainer');
    if (!container) return;

    container.innerHTML = ''; // Clear previous content

    if (blogs.length === 0) {
        container.innerHTML = '<div class="no-content"><i class="fas fa-exclamation-circle"></i><p>No published blog posts found.</p></div>';
        return;
    }

    blogs.forEach(blog => {
        const post = document.createElement('article');
        post.className = 'blog-post animate-fadeIn';
        post.setAttribute('data-id', blog.id);

        // Limit excerpt to 200 characters for a clean look
        const limitedExcerpt = blog.excerpt.length > 200 ? 
                               blog.excerpt.substring(0, 200) + '...' : 
                               blog.excerpt;

        // Check if user is admin (assuming sessionScope.user.role is handled by JSP or a hidden field)
        const isAdmin = document.querySelector('.admin-controls'); // Simple check for admin UI

        post.innerHTML = `
            <div class="post-header">
                <img src="${blog.featuredImage || 'images/default-featured-image.jpg'}" alt="${blog.title}" class="post-featured-image">
            </div>
            <div class="post-content">
                <h3 class="post-title"><a href="blog.jsp?action=get&id=${blog.id}">${blog.title}</a></h3>
                <div class="post-meta">
                    <span class="meta-item"><i class="fas fa-user"></i> ${blog.author}</span>
                    <span class="meta-item"><i class="fas fa-tag"></i> ${blog.category}</span>
                    <span class="meta-item"><i class="fas fa-calendar-alt"></i> ${new Date(blog.publishedAt).toLocaleDateString()}</span>
                    <span class="meta-item"><i class="fas fa-eye"></i> ${blog.viewCount || 0}</span>
                </div>
                <p class="post-excerpt">${limitedExcerpt}</p>
                <a href="blog.jsp?action=get&id=${blog.id}" class="btn btn-primary read-more">Read More <i class="fas fa-arrow-right"></i></a>
                
                ${isAdmin ? `
                    <div class="post-admin-actions">
                        <button class="btn btn-sm btn-edit" onclick="editBlog(${blog.id})"><i class="fas fa-edit"></i> Edit</button>
                        <button class="btn btn-sm btn-delete" onclick="deleteBlog(${blog.id})"><i class="fas fa-trash-alt"></i> Delete</button>
                    </div>
                ` : ''}
            </div>
        `;
        container.appendChild(post);
    });
}

// --- ADMIN / CRUD OPERATIONS ---

/**
 * Handles the submission of the blog form for create or update.
 * @param {Event} e 
 */
function handleBlogSubmit(e) {
    e.preventDefault();
    
    const form = e.target;
    const blogId = document.getElementById('blogId').value;
    const formData = new FormData(form);

    // Get the status and set the published_at timestamp only if status is published (optional client-side logic)
    // The servlet handles the 'published_at' timestamp based on the 'status', so we don't need to send it explicitly.

    fetch('/EMS/admin/blog', {
        method: 'POST',
        body: formData // FormData object is automatically set with the correct Content-Type for multipart/form-data
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert(result.message);
            closeBlogModal();
            loadBlogs(); // Reload the blog list after success
        } else {
            alert('Operation failed: ' + result.message);
        }
    })
    .catch(error => {
        console.error('Error submitting blog:', error);
        alert('An error occurred during submission.');
    });
}

/**
 * Opens the modal and prepares it for editing a blog post.
 * @param {number} id - The ID of the blog post to edit.
 */
function editBlog(id) {
    document.getElementById('modalTitle').textContent = 'Edit Blog Post';
    
    fetch(`/EMS/Blog?action=get&id=${id}`)
        .then(response => response.json())
        .then(blog => {
            if (blog.id) {
                document.getElementById('blogId').value = blog.id;
                document.getElementById('title').value = blog.title;
                document.getElementById('slug').value = blog.slug;
                document.getElementById('excerpt').value = blog.excerpt;
                document.getElementById('content').value = blog.content;
                document.getElementById('category').value = blog.category;
                document.getElementById('tags').value = blog.tags;
                document.getElementById('author').value = blog.author;
                document.getElementById('status').value = blog.status;

                // Display existing featured image
                const imgPreview = document.getElementById('imagePreview');
                if (blog.featuredImage) {
                    imgPreview.src = `/EMS/${blog.featuredImage}`; // Adjust path as necessary
                    imgPreview.style.display = 'block';
                } else {
                    imgPreview.style.display = 'none';
                }
                
                openBlogModal();
            } else {
                alert('Blog post not found.');
            }
        })
        .catch(error => {
            console.error('Error fetching blog for edit:', error);
            alert('Failed to load blog data for editing.');
        });
}

/**
 * Handles the deletion of a blog post.
 * @param {number} id - The ID of the blog post to delete.
 */
function deleteBlog(id) {
    if (!confirm('Are you sure you want to delete this blog post?')) {
        return;
    }

    fetch(`/EMS/admin/blog?id=${id}`, {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            alert(result.message);
            loadBlogs(); // Reload the blog list
        } else {
            alert('Deletion failed: ' + result.message);
        }
    })
    .catch(error => {
        console.error('Error deleting blog:', error);
        alert('An error occurred during deletion.');
    });
}

// --- UI / MODAL MANAGEMENT ---

/**
 * Opens the blog creation/editing modal.
 */
function openBlogModal() {
    const modal = document.getElementById('blogModal');
    modal.classList.add('active');
    // Ensure categories dropdown is populated before modal is opened
    populateCategoryDropdown();
}

/**
 * Closes the blog creation/editing modal and resets the form.
 */
function closeBlogModal() {
    const modal = document.getElementById('blogModal');
    modal.classList.remove('active');
    
    // Reset form for clean slate
    document.getElementById('blogForm').reset();
    document.getElementById('blogId').value = '';
    document.getElementById('modalTitle').textContent = 'Add New Blog';
    
    // Reset image preview
    const imgPreview = document.getElementById('imagePreview');
    imgPreview.src = '';
    imgPreview.style.display = 'none';
}

/**
 * Populates the category dropdown in the blog modal.
 */
function populateCategoryDropdown() {
    const select = document.getElementById('category');
    
    // Check if options are already loaded to avoid redundant calls
    if (select.options.length > 1 && select.options[1].value !== '') {
        return; 
    }
    
    fetch('/EMS/Blog?action=categories')
        .then(response => response.json())
        .then(data => {
            select.innerHTML = '<option value="">Select Category</option>'; // Keep the default option
            data.forEach(category => {
                const option = document.createElement('option');
                option.value = category.name; // Use name as value for saving
                option.textContent = category.name;
                select.appendChild(option);
            });
        })
        .catch(error => {
            console.error('Error populating category dropdown:', error);
        });
}

/**
 * Previews the selected image file.
 * @param {HTMLInputElement} input - The file input element.
 */
function previewImage(input) {
    const preview = document.getElementById('imagePreview');
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
    } else {
        preview.src = '';
        preview.style.display = 'none';
    }
}

/**
 * Handles the blog search form submission.
 * @param {Event} e 
 */
function searchBlogs(e) {
    e.preventDefault();
    const query = document.getElementById('search-input').value.trim();
    if (query) {
        // Reloads the main blog section with search results
        loadBlogs(query); 
    } else {
        // If search is empty, reload all published blogs
        loadBlogs();
    }
}

// --- BASIC TEXT EDITOR FUNCTIONS (Requires Content to be editable HTML/WYSYWIG or using a library) ---
// Note: This implementation assumes the 'content' textarea is NOT a rich text editor.
// For a simple textarea, these functions will insert basic markdown/HTML tags.

function formatText(command) {
    const textarea = document.getElementById('content');
    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const selectedText = textarea.value.substring(start, end);
    let newText = selectedText;

    switch(command) {
        case 'bold':
            newText = `<b>${selectedText}</b>`;
            break;
        case 'italic':
            newText = `<i>${selectedText}</i>`;
            break;
        case 'underline':
            newText = `<u>${selectedText}</u>`;
            break;
        default:
            return;
    }
    
    textarea.value = textarea.value.substring(0, start) + newText + textarea.value.substring(end);
}

function insertImage() {
    const url = prompt("Enter the image URL:");
    if (url) {
        const textarea = document.getElementById('content');
        const imgTag = `<img src="${url}" alt="image-description">`;
        textarea.value += '\n' + imgTag + '\n';
    }
}

function createLink() {
    const url = prompt("Enter the link URL:");
    const text = prompt("Enter the link text:", "Click Here");
    if (url && text) {
        const textarea = document.getElementById('content');
        const linkTag = `<a href="${url}">${text}</a>`;
        textarea.value += '\n' + linkTag + '\n';
    }
}
