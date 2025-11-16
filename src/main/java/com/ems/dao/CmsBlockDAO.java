package com.ems.dao;

import com.ems.model.CmsBlock;
import com.ems.util.DBConnection;

import java.sql.*;
import java.util.*;

public class CmsBlockDAO {

    public List<CmsBlock> getAllBlocks() throws SQLException {
        List<CmsBlock> blocks = new ArrayList<>();
        String sql = "SELECT * FROM cms_blocks ORDER BY position ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                blocks.add(mapRow(rs));
            }
        }
        return blocks;
    }

    public void saveOrUpdate(CmsBlock block) throws SQLException {
        String sql = "REPLACE INTO cms_blocks (id, title, icon, description, position, active) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, block.getId());
            stmt.setString(2, block.getTitle());
            stmt.setString(3, block.getIcon());
            stmt.setString(4, block.getDescription());
            stmt.setInt(5, block.getPosition());
            stmt.setBoolean(6, block.isActive());
            stmt.executeUpdate();
        }
    }

    private CmsBlock mapRow(ResultSet rs) throws SQLException {
        CmsBlock block = new CmsBlock();
        block.setId(rs.getInt("id"));
        block.setTitle(rs.getString("title"));
        block.setIcon(rs.getString("icon"));
        block.setDescription(rs.getString("description"));
        block.setPosition(rs.getInt("position"));
        block.setActive(rs.getBoolean("active"));
        block.setUpdatedAt(rs.getTimestamp("updated_at"));
        return block;
    }
}

