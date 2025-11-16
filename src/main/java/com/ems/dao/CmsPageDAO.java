package com.ems.dao;

import com.ems.model.CmsPage;
import com.ems.util.DBConnection;

import java.sql.*;
import java.util.*;

public class CmsPageDAO {

    // -------------------------------------------------------------------
    // 1. READ OPERATIONS
    // -------------------------------------------------------------------

    public List<CmsPage> getAllPages() throws SQLException {
        List<CmsPage> pages = new ArrayList<>();
        String sql = "SELECT id, slug, title, content, status, created_at, updated_at FROM cms_pages ORDER BY updated_at DESC"; 

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                pages.add(mapRow(rs));
            }
        }
        return pages;
    }

    public CmsPage getPageBySlug(String slug) throws SQLException {
        String sql = "SELECT id, slug, title, content, status, created_at, updated_at FROM cms_pages WHERE slug = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slug);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }
    
    public CmsPage getPageById(long id) throws SQLException {
        String sql = "SELECT id, slug, title, content, status, created_at, updated_at FROM cms_pages WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // -------------------------------------------------------------------
    // 2. SLUG VALIDATION METHODS (FIXED - no recursion)
    // -------------------------------------------------------------------

    /**
     * Check if a slug exists (for new pages)
     */
    public boolean slugExists(String slug) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cms_pages WHERE slug = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slug);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /**
     * Check if a slug exists excluding a specific page ID (for updates)
     */
    public boolean slugExists(String slug, long excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cms_pages WHERE slug = ? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, slug);
            stmt.setLong(2, excludeId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
    /**
 * Get pages by status
 */
public List<CmsPage> getPagesByStatus(String status) throws SQLException {
    List<CmsPage> pages = new ArrayList<>();
    String sql = "SELECT id, slug, title, content, status, created_at, updated_at " +
                 "FROM cms_pages WHERE status = ? ORDER BY title ASC";
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, status);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                pages.add(mapRow(rs));
            }
        }
    }
    return pages;
}

    // -------------------------------------------------------------------
    // 3. CREATE / UPDATE OPERATIONS
    // -------------------------------------------------------------------
    
    public void saveOrUpdate(CmsPage page) throws SQLException {
        if (page.getId() == 0) {
            insert(page);
        } else {
            update(page);
        }
    }

    private void insert(CmsPage page) throws SQLException {
        String sql = "INSERT INTO cms_pages (slug, title, content, status, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, page.getSlug());
            stmt.setString(2, page.getTitle());
            stmt.setString(3, page.getContent());
            stmt.setString(4, page.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        page.setId(rs.getLong(1));
                    }
                }
            }
        }
    }

    private void update(CmsPage page) throws SQLException {
        String sql = "UPDATE cms_pages SET slug = ?, title = ?, content = ?, status = ?, updated_at = NOW() WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, page.getSlug());
            stmt.setString(2, page.getTitle());
            stmt.setString(3, page.getContent());
            stmt.setString(4, page.getStatus());
            stmt.setLong(5, page.getId());
            
            stmt.executeUpdate();
        }
    }

    // -------------------------------------------------------------------
    // 4. DELETE OPERATION
    // -------------------------------------------------------------------
    
    public void delete(long id) throws SQLException {
        String sql = "DELETE FROM cms_pages WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }

    // -------------------------------------------------------------------
    // 5. MAPPER UTILITY
    // -------------------------------------------------------------------

    private CmsPage mapRow(ResultSet rs) throws SQLException {
        CmsPage page = new CmsPage();
        page.setId(rs.getLong("id"));
        page.setSlug(rs.getString("slug"));
        page.setTitle(rs.getString("title"));
        page.setContent(rs.getString("content"));
        page.setStatus(rs.getString("status"));
        page.setCreatedAt(rs.getTimestamp("created_at"));
        page.setUpdatedAt(rs.getTimestamp("updated_at"));
        return page;
    }
}