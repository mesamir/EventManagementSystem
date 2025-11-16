package com.ems.dao;

import com.ems.model.CmsBanner;
import com.ems.util.DBConnection;

import java.sql.*;
import java.util.*;

public class CmsBannerDAO {

    public List<CmsBanner> getAllBanners() throws SQLException {
        List<CmsBanner> banners = new ArrayList<>();
        String sql = "SELECT * FROM cms_banners ORDER BY uploaded_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                banners.add(mapRow(rs));
            }
        }
        return banners;
    }

    public void saveBanner(CmsBanner banner) throws SQLException {
        String sql = "INSERT INTO cms_banners (image_url, alt_text, position, active) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, banner.getImageUrl());
            stmt.setString(2, banner.getAltText());
            stmt.setString(3, banner.getPosition());
            stmt.setBoolean(4, banner.isActive());
            stmt.executeUpdate();
        }
    }

    private CmsBanner mapRow(ResultSet rs) throws SQLException {
        CmsBanner banner = new CmsBanner();
        banner.setId(rs.getInt("id"));
        banner.setImageUrl(rs.getString("image_url"));
        banner.setAltText(rs.getString("alt_text"));
        banner.setPosition(rs.getString("position"));
        banner.setActive(rs.getBoolean("active"));
        banner.setUploadedAt(rs.getTimestamp("uploaded_at"));
        return banner;
    }
}

