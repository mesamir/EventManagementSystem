package com.ems.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import com.ems.util.DBConnection;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONObject;
import org.json.JSONArray;
import java.util.stream.Collectors; // Used for tag processing

@WebServlet(
    name = "BlogServlet",
    urlPatterns = {"/Blog", "/admin/blog/*"},
    loadOnStartup = 1
)
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class BlogServlet extends HttpServlet {
    
    // Helper function to write standardized JSON error responses
    private void writeError(PrintWriter out, String message, Exception e) {
        JSONObject error = new JSONObject();
        error.put("success", false);
        error.put("message", message + ": " + e.getMessage());
        out.print(error.toString());
        e.printStackTrace();
    }
    
    // Helper function to write standardized JSON success responses
    private void writeSuccess(PrintWriter out, Object data) {
        JSONObject result = new JSONObject();
        result.put("success", true);
        
        // Check if data is a JSONArray (list requests) or JSONObject (single item/metadata)
        if (data instanceof JSONArray) {
            result.put("data", data);
        } else if (data instanceof JSONObject) {
            JSONObject obj = (JSONObject) data;
            // Transfer keys from the data object to the result object
            for (String key : obj.keySet()) {
                result.put(key, obj.get(key));
            }
        }
        out.print(result.toString());
    }

    // --- GET Handlers (Read Operations) ---
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
         String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.startsWith("/image/")) {
                serveImage(request, response);
                return;
            }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        PrintWriter out = response.getWriter();
        
        try {
            switch (action != null ? action : "default") {
                case "categories":
                    getCategories(out);
                    break;
                case "recent":
                    getRecentPosts(out);
                    break;
                case "tags":
                    getPopularTags(out);
                    break;
                case "get":
                    getBlogById(request, out); // Handles get by ID/Slug
                    break;
                case "list":
                    getBlogs(request, out); // Admin list (all statuses)
                    break;
                case "default":
                default:
                    // Default public view with filters and pagination
                    getAllPublishedBlogs(request, out); 
                    break;
            }
        } catch (Exception e) {
            writeError(out, "Internal Server Error during GET operation", e);
        }
    }
    // Add this method to your BlogServlet:
private void serveImage(HttpServletRequest request, HttpServletResponse response) 
        throws IOException {
    String pathInfo = request.getPathInfo();
    if (pathInfo == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
        return;
    }
    
    String filename = pathInfo.substring("/image/".length()); // Remove "/image/" prefix
    
    // Get the uploads directory path (same as in saveUploadedImage)
    String uploadsPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator;
    File imageFile = new File(uploadsPath + filename);
    
    System.out.println("Serving image from: " + imageFile.getAbsolutePath());
    
    if (!imageFile.exists() || !imageFile.isFile()) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found: " + filename);
        return;
    }
    
    String mimeType = getServletContext().getMimeType(imageFile.getName());
    if (mimeType == null) {
        mimeType = "application/octet-stream";
    }
    
    response.setContentType(mimeType);
    response.setContentLength((int) imageFile.length());
    
    try (FileInputStream in = new FileInputStream(imageFile);
         OutputStream out = response.getOutputStream()) {
        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = in.read(buffer)) != -1) {
            out.write(buffer, 0, bytesRead);
        }
    }
}
  

    
    private void getCategories(PrintWriter out) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.name, c.slug, COUNT(b.id) as count FROM categories c " +
                         "LEFT JOIN blogs b ON c.name = b.category AND b.status = 'published' " +
                         "GROUP BY c.name, c.slug ORDER BY count DESC"; // Group by c.id is not needed if name/slug are unique
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            JSONArray categories = new JSONArray();
            while (rs.next()) {
                JSONObject category = new JSONObject();
                category.put("name", rs.getString("name"));
                category.put("slug", rs.getString("slug"));
                category.put("count", rs.getInt("count"));
                categories.put(category);
            }
            
            writeSuccess(out, categories);
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void getAllPublishedBlogs(HttpServletRequest request, PrintWriter out) throws SQLException {
        // --- 1. Get Parameters ---
        int page = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
        int limit = Integer.parseInt(request.getParameter("limit") != null ? request.getParameter("limit") : "10");
        String searchTerm = request.getParameter("search");
        String category = request.getParameter("category");
        String tag = request.getParameter("tag"); // Added Tag filtering

        int offset = (page - 1) * limit;
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        JSONObject result = new JSONObject();

        try {
            conn = DBConnection.getConnection();

            // --- 2. Build Dynamic SQL Query and Parameters ---
            StringBuilder whereClause = new StringBuilder(" WHERE status = 'published'");
            List<String> params = new ArrayList<>();
            
            // Add Search Filter
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                whereClause.append(" AND (title LIKE ? OR content LIKE ? OR tags LIKE ?)");
                String searchPattern = "%" + searchTerm + "%";
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
            }
            
            // Add Category Filter
            if (category != null && !category.trim().isEmpty()) {
                whereClause.append(" AND category = ?");
                params.add(category);
            }
            
            // Add Tag Filter
            if (tag != null && !tag.trim().isEmpty()) {
                whereClause.append(" AND tags LIKE ?");
                params.add("%" + tag + "%");
            }

            // --- 3. Get Total Count ---
            String countSql = "SELECT COUNT(*) AS total_count FROM blogs" + whereClause.toString();
            stmt = conn.prepareStatement(countSql);
            int paramIndex = 1;
            for (String param : params) {
                stmt.setString(paramIndex++, param);
            }
            rs = stmt.executeQuery();
            int totalBlogs = 0;
            if (rs.next()) {
                totalBlogs = rs.getInt("total_count");
            }
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            
            int totalPages = (int) Math.ceil((double) totalBlogs / limit);
            
            // --- 4. Get Paginated List ---
            String listSql = "SELECT id, title, slug, excerpt, category, author, featured_image, published_at, view_count, tags FROM blogs"
                           + whereClause.toString() + " ORDER BY published_at DESC LIMIT ? OFFSET ?";
            
            stmt = conn.prepareStatement(listSql);
            paramIndex = 1;
            for (String param : params) {
                stmt.setString(paramIndex++, param);
            }
            stmt.setInt(paramIndex++, limit);
            stmt.setInt(paramIndex, offset);
            
            rs = stmt.executeQuery();

            JSONArray blogs = new JSONArray();
            while (rs.next()) {
                JSONObject blog = new JSONObject();
                blog.put("id", rs.getInt("id"));
                blog.put("title", rs.getString("title"));
                blog.put("slug", rs.getString("slug"));
                blog.put("excerpt", rs.getString("excerpt"));
                blog.put("category", rs.getString("category"));
                blog.put("tags", rs.getString("tags"));
                blog.put("author", rs.getString("author"));
                blog.put("featuredImage", rs.getString("featured_image"));
                blog.put("publishedAt", rs.getTimestamp("published_at"));
                blog.put("viewCount", rs.getInt("view_count"));
                blogs.put(blog);
            }

            // --- 5. Assemble Final JSON Response ---
            JSONObject finalResult = new JSONObject();
            finalResult.put("data", blogs);
            finalResult.put("totalBlogs", totalBlogs);
            finalResult.put("totalPages", totalPages);
            finalResult.put("currentPage", page);
            finalResult.put("limit", limit);
            
            writeSuccess(out, finalResult);

        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void getRecentPosts(PrintWriter out) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, title, slug, featured_image, published_at FROM blogs " +
                         "WHERE status = 'published' ORDER BY published_at DESC LIMIT 5";
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            JSONArray posts = new JSONArray();
            while (rs.next()) {
                JSONObject post = new JSONObject();
                post.put("id", rs.getInt("id"));
                post.put("title", rs.getString("title"));
                post.put("slug", rs.getString("slug")); 
                post.put("featuredImage", rs.getString("featured_image"));
                post.put("publishedAt", rs.getTimestamp("published_at"));
                posts.put(post);
            }
            
            writeSuccess(out, posts);
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void getPopularTags(PrintWriter out) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT tags FROM blogs WHERE tags IS NOT NULL AND status = 'published'";
            
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            List<String> allTags = new ArrayList<>();
            while (rs.next()) {
                String tags = rs.getString("tags");
                if (tags != null) {
                    // Split, trim, and flatten into a single list
                    String[] tagArray = tags.split(",");
                    for (String tag : tagArray) {
                        String trimmedTag = tag.trim();
                        // Check for case-insensitive uniqueness
                        if (!trimmedTag.isEmpty() && !allTags.stream().map(String::toLowerCase).anyMatch(trimmedTag.toLowerCase()::equals)) {
                            allTags.add(trimmedTag);
                        }
                    }
                }
            }
            
            // Sort tags alphabetically or by an arbitrary limit for "popular"
            allTags.sort(String.CASE_INSENSITIVE_ORDER); 
            
            JSONArray tagsJson = new JSONArray();
            // You might want to limit this list, e.g., to the top 20
            for (String tag : allTags.stream().limit(20).collect(Collectors.toList())) {
                JSONObject tagObj = new JSONObject();
                tagObj.put("name", tag);
                tagsJson.put(tagObj);
            }
            
            writeSuccess(out, tagsJson);
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void getBlogById(HttpServletRequest request, PrintWriter out) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String idParam = request.getParameter("id");
            String slug = request.getParameter("slug");
            
            String sql;
            // Prioritize slug for public view, fall back to ID (for admin/direct access)
            if (slug != null && !slug.isEmpty()) {
                // Public view access: must be published
                sql = "SELECT * FROM blogs WHERE slug = ? AND status = 'published'"; 
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, slug);
            } else if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                // Admin or direct ID access: no status filter here, let the client check status
                sql = "SELECT * FROM blogs WHERE id = ?"; 
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, id);
            } else {
                // No identifier provided
                JSONObject error = new JSONObject();
                error.put("success", false);
                error.put("message", "Blog ID or slug is required.");
                out.print(error.toString());
                return;
            }

            rs = stmt.executeQuery();
            
            if (rs.next()) {
                JSONObject blog = new JSONObject();
                int blogId = rs.getInt("id");

                blog.put("id", blogId);
                blog.put("title", rs.getString("title"));
                blog.put("slug", rs.getString("slug"));
                blog.put("excerpt", rs.getString("excerpt"));
                blog.put("content", rs.getString("content"));
                blog.put("category", rs.getString("category"));
                blog.put("tags", rs.getString("tags"));
                blog.put("author", rs.getString("author"));
                blog.put("status", rs.getString("status"));
                blog.put("featuredImage", rs.getString("featured_image"));
                blog.put("publishedAt", rs.getTimestamp("published_at"));
                blog.put("viewCount", rs.getInt("view_count"));
                blog.put("createdAt", rs.getTimestamp("created_at"));
                
                writeSuccess(out, blog);
                
                // Increment view count (only on successful public view)
                if ("published".equals(blog.getString("status"))) {
                    incrementViewCount(conn, blogId);
                }
            } else {
                writeError(out, "Blog not found", new Exception("No results for ID/Slug"));
            }
            
        } catch (NumberFormatException e) {
            writeError(out, "Invalid Blog ID format", e);
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void getBlogs(HttpServletRequest request, PrintWriter out) throws SQLException {
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBConnection.getConnection();
        
        // For admin view, get ALL blogs regardless of status
        String sql = "SELECT * FROM blogs ORDER BY created_at DESC";
        
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
        
        JSONArray blogs = new JSONArray();
        while (rs.next()) {
            JSONObject blog = new JSONObject();
            blog.put("id", rs.getInt("id"));
            blog.put("title", rs.getString("title"));
            blog.put("slug", rs.getString("slug"));
            blog.put("excerpt", rs.getString("excerpt"));
            blog.put("content", rs.getString("content")); // Added content
            blog.put("category", rs.getString("category"));
            blog.put("tags", rs.getString("tags")); // Added tags
            blog.put("author", rs.getString("author"));
            blog.put("status", rs.getString("status"));
            
            // Handle featured image - check if column exists and provide fallback
            String featuredImage = rs.getString("featured_image");
            blog.put("featuredImage", featuredImage != null ? featuredImage : "");
            
            // Handle dates safely
            Timestamp createdAt = rs.getTimestamp("created_at");
            blog.put("createdAt", createdAt != null ? createdAt.toString() : new Timestamp(System.currentTimeMillis()).toString());
            
            Timestamp publishedAt = rs.getTimestamp("published_at");
            if (publishedAt != null) {
                blog.put("publishedAt", publishedAt.toString());
            }
            
            blogs.put(blog);
        }
        
        // Return simple array for admin management
        writeSuccess(out, blogs);
        
    } catch (SQLException e) {
        writeError(out, "Database error loading blogs", e);
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
}
    
    // --- POST Handlers (Create/Update Operations) ---
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String id = request.getParameter("id");
            String title = request.getParameter("title");
            String slug = request.getParameter("slug");
            String excerpt = request.getParameter("excerpt");
            String content = request.getParameter("content");
            String category = request.getParameter("category");
            String tags = request.getParameter("tags");
            String author = request.getParameter("author");
            String status = request.getParameter("status");
            Part featuredImage = request.getPart("featuredImage");
            
            String imagePath = null;
            if (featuredImage != null && featuredImage.getSize() > 0) {
                imagePath = saveUploadedImage(featuredImage);
            }
            
            if (id == null || id.isEmpty()) {
                // Create new blog
                createBlog(conn, title, slug, excerpt, content, category, tags, author, status, imagePath, out);
            } else {
                // Update existing blog
                updateBlog(conn, Integer.parseInt(id), title, slug, excerpt, content, category, tags, author, status, imagePath, out);
            }
            
            conn.commit();
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            writeError(out, "Failed to perform blog POST operation", e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private void createBlog(Connection conn, String title, String slug, String excerpt, String content,
                            String category, String tags, String author, String status,
                            String imagePath, PrintWriter out) throws SQLException {
        
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO blogs (title, slug, excerpt, content, category, tags, author, status, featured_image, published_at) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, slug);
            stmt.setString(3, excerpt);
            stmt.setString(4, content);
            stmt.setString(5, category);
            stmt.setString(6, tags);
            stmt.setString(7, author);
            stmt.setString(8, status);
            stmt.setString(9, imagePath);
            
            // Set published_at only if status is 'published'
            if ("published".equals(status)) {
                stmt.setTimestamp(10, new Timestamp(System.currentTimeMillis()));
            } else {
                stmt.setNull(10, Types.TIMESTAMP);
            }
            
            int rows = stmt.executeUpdate();
            
            JSONObject result = new JSONObject();
            if (rows > 0) {
                result.put("message", "Blog created successfully");
                writeSuccess(out, result);
            } else {
                writeError(out, "Failed to create blog", new Exception("JDBC did not report any inserted rows."));
            }
            
        } finally {
            if (stmt != null) stmt.close();
        }
    }
    
    private void updateBlog(Connection conn, int id, String title, String slug, String excerpt, String content,
                            String category, String tags, String author, String status,
                            String imagePath, PrintWriter out) throws SQLException {
        
        PreparedStatement stmt = null;
        try {
            // COALESCE(?, featured_image) keeps the old image if imagePath is null (no new image uploaded)
            String sql = "UPDATE blogs SET title = ?, slug = ?, excerpt = ?, content = ?, category = ?, " +
                         "tags = ?, author = ?, status = ?, featured_image = COALESCE(?, featured_image), " +
                         "published_at = ? WHERE id = ?";
            
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, slug);
            stmt.setString(3, excerpt);
            stmt.setString(4, content);
            stmt.setString(5, category);
            stmt.setString(6, tags);
            stmt.setString(7, author);
            stmt.setString(8, status);
            stmt.setString(9, imagePath); // Will be null if no new file, triggering COALESCE

            // Only update published_at on *status change* to 'published', but for simplicity, 
            // we'll update it to the current time, or set to NULL if not published.
            if ("published".equals(status)) {
                stmt.setTimestamp(10, new Timestamp(System.currentTimeMillis()));
            } else {
                stmt.setNull(10, Types.TIMESTAMP);
            }
            stmt.setInt(11, id);
            
            int rows = stmt.executeUpdate();
            
            JSONObject result = new JSONObject();
            if (rows > 0) {
                result.put("message", "Blog updated successfully");
                writeSuccess(out, result);
            } else {
                writeError(out, "Failed to update blog", new Exception("JDBC did not report any updated rows."));
            }
            
        } finally {
            if (stmt != null) stmt.close();
        }
    }
    
    // --- DELETE Handler ---
    
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            int id = Integer.parseInt(request.getParameter("id"));
            deleteBlog(conn, id, out);
        } catch (NumberFormatException e) {
            writeError(out, "Invalid Blog ID format", e);
        } catch (Exception e) {
            writeError(out, "Failed to perform blog DELETE operation", e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private void deleteBlog(Connection conn, int id, PrintWriter out) throws SQLException {
        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM blogs WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int rows = stmt.executeUpdate();
            
            JSONObject result = new JSONObject();
            if (rows > 0) {
                result.put("message", "Blog deleted successfully");
                writeSuccess(out, result);
            } else {
                writeError(out, "Failed to delete blog", new Exception("Blog with ID " + id + " not found."));
            }
            
        } finally {
            if (stmt != null) stmt.close();
        }
    }
    
    // --- Utility Methods ---

    private void incrementViewCount(Connection conn, int blogId) throws SQLException {
        PreparedStatement stmt = null;
        try {
            // Note: This needs to be committed either by its own connection or passed conn must be managed.
            // Since this is called from getBlogById which closes the connection, 
            // we should perform the update and commit immediately or handle the transaction carefully.
            // Assuming default auto-commit=true for a simple update outside a transaction, OR
            // better: call commit on the passed connection. Since the passed conn is closed in finally, 
            // we'll keep the simplified update logic which relies on a separate transaction or autocommit=true.
            
            // Re-open a connection just for this quick, independent, non-critical update
             try (Connection updateConn = DBConnection.getConnection(); 
                 PreparedStatement updateStmt = updateConn.prepareStatement("UPDATE blogs SET view_count = view_count + 1 WHERE id = ?")) {
                
                updateStmt.setInt(1, blogId);
                updateStmt.executeUpdate();
            }

        } catch (Exception e) {
            // Log the error but don't re-throw, as failing to count a view shouldn't fail the blog display
            System.err.println("Failed to increment view count for blog ID " + blogId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    private String saveUploadedImage(Part filePart) throws IOException {
        String fileName = System.currentTimeMillis() + "_" +
                          filePart.getSubmittedFileName().replace(" ", "_");
        String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator; // Use root context for consistency
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();
        
        String filePath = uploadPath + fileName;
        try (InputStream fileContent = filePart.getInputStream();
             FileOutputStream out = new FileOutputStream(filePath)) {
            int read;
            final byte[] bytes = new byte[1024];
            while ((read = fileContent.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
        }
        
        return "uploads/" + fileName;
    }
}