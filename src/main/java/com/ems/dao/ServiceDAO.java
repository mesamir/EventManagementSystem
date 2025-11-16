package com.ems.dao;

import com.ems.model.Service;
import com.ems.model.ServiceFeature;
import com.ems.model.ProcessStep;
import com.ems.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ServiceDAO {
    private static final Logger logger = Logger.getLogger(ServiceDAO.class.getName());
    
    // ===== SERVICE METHODS =====
    
    public List<Service> getAllActiveServices() {
        return getServices("SELECT * FROM services WHERE is_active = TRUE ORDER BY created_at DESC, id");
    }
    
    public List<Service> getAllServices() {
        return getServices("SELECT * FROM services ORDER BY created_at DESC, id");
    }
    
    public List<Service> getServicesByStatus(boolean active) {
        String sql = "SELECT * FROM services WHERE is_active = ? ORDER BY created_at DESC, id";
        List<Service> services = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, active);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Service service = extractServiceFromResultSet(rs);
                    service.setFeatures(getServiceFeatures(service.getId()));
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving services by status: " + active, e);
        }
        return services;
    }
    
    private List<Service> getServices(String sql) {
        List<Service> services = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Service service = extractServiceFromResultSet(rs);
                service.setFeatures(getServiceFeatures(service.getId()));
                services.add(service);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving services", e);
        }
        return services;
    }
    
    public Service getServiceById(int id) {
        String sql = "SELECT * FROM services WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Service service = extractServiceFromResultSet(rs);
                    service.setFeatures(getServiceFeatures(service.getId()));
                    return service;
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving service with ID: " + id, e);
        }
        return null;
    }
    
    public boolean addService(Service service) {
        String sql = "INSERT INTO services (name, description, short_description, base_price, currency, image_url, icon_class) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet generatedKeys = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            setServiceStatementParameters(stmt, service);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int serviceId = generatedKeys.getInt(1);
                    
                    // Add features if they exist
                    if (service.getFeatures() != null && !service.getFeatures().isEmpty()) {
                        if (!addServiceFeatures(conn, serviceId, service.getFeatures())) {
                            conn.rollback();
                            return false;
                        }
                    }
                    
                    conn.commit();
                    logger.log(Level.INFO, "Successfully added service: {0} (ID: {1})", 
                              new Object[]{service.getName(), serviceId});
                    return true;
                }
            }
            
            conn.rollback();
            return false;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding service: " + service.getName(), e);
            rollbackConnection(conn);
            return false;
        } finally {
            closeResources(conn, stmt, generatedKeys);
        }
    }
    
    public boolean updateService(Service service) {
        String sql = "UPDATE services SET name = ?, description = ?, short_description = ?, base_price = ?, " +
                     "currency = ?, image_url = ?, icon_class = ?, is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            stmt = conn.prepareStatement(sql);
            setServiceStatementParameters(stmt, service);
            stmt.setBoolean(8, service.isActive());
            stmt.setInt(9, service.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                // Update features
                if (!updateServiceFeatures(conn, service.getId(), service.getFeatures())) {
                    conn.rollback();
                    return false;
                }
                
                conn.commit();
                logger.log(Level.INFO, "Successfully updated service ID: {0}", service.getId());
                return true;
            }
            
            conn.rollback();
            return false;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating service with ID: " + service.getId(), e);
            rollbackConnection(conn);
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }
    
    public boolean toggleServiceStatus(int serviceId) {
        String sql = "UPDATE services SET is_active = NOT is_active, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            boolean success = stmt.executeUpdate() > 0;
            
            if (success) {
                logger.log(Level.INFO, "Successfully toggled service status for ID: {0}", serviceId);
            }
            
            return success;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error toggling service status for ID: " + serviceId, e);
            return false;
        }
    }
    
    public boolean deleteService(int serviceId) {
        String sql = "DELETE FROM services WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // First delete features
            if (!deleteAllServiceFeatures(conn, serviceId)) {
                conn.rollback();
                return false;
            }
            
            // Then delete service
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, serviceId);
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                conn.commit();
                logger.log(Level.INFO, "Successfully deleted service ID: {0}", serviceId);
                return true;
            }
            
            conn.rollback();
            return false;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting service with ID: " + serviceId, e);
            rollbackConnection(conn);
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }
    
    public boolean serviceExists(int serviceId) {
        String sql = "SELECT 1 FROM services WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if service exists: " + serviceId, e);
            return false;
        }
    }
    
    public List<Service> searchServices(String searchTerm) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE (name LIKE ? OR description LIKE ? OR short_description LIKE ?) " +
                     "AND is_active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String likeTerm = "%" + searchTerm + "%";
            stmt.setString(1, likeTerm);
            stmt.setString(2, likeTerm);
            stmt.setString(3, likeTerm);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Service service = extractServiceFromResultSet(rs);
                    service.setFeatures(getServiceFeatures(service.getId()));
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error searching services with term: " + searchTerm, e);
        }
        return services;
    }
    
    // ===== SERVICE FEATURE METHODS =====
    
    public List<ServiceFeature> getServiceFeatures(int serviceId) {
        return getServiceFeatures(serviceId, true);
    }
    
    public List<ServiceFeature> getServiceFeatures(int serviceId, boolean orderByDisplayOrder) {
        List<ServiceFeature> features = new ArrayList<>();
        String sql = orderByDisplayOrder ? 
            "SELECT * FROM service_features WHERE service_id = ? ORDER BY display_order, id" :
            "SELECT * FROM service_features WHERE service_id = ? ORDER BY id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ServiceFeature feature = extractServiceFeatureFromResultSet(rs);
                    features.add(feature);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving features for service ID: " + serviceId, e);
        }
        return features;
    }
    
    public ServiceFeature getServiceFeatureById(int featureId) {
        String sql = "SELECT * FROM service_features WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, featureId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractServiceFeatureFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving feature with ID: " + featureId, e);
        }
        return null;
    }
    
    public boolean addServiceFeature(ServiceFeature feature) {
        String sql = "INSERT INTO service_features (service_id, feature_text, icon_class, display_order) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, feature.getServiceId());
            stmt.setString(2, feature.getFeatureText());
            stmt.setString(3, feature.getIconClass());
            stmt.setInt(4, feature.getDisplayOrder());
            
            boolean success = stmt.executeUpdate() > 0;
            
            if (success) {
                logger.log(Level.INFO, "Successfully added feature for service ID: {0}", feature.getServiceId());
            }
            
            return success;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error adding service feature", e);
            return false;
        }
    }
    
    public boolean updateServiceFeature(ServiceFeature feature) {
        String sql = "UPDATE service_features SET feature_text = ?, icon_class = ?, display_order = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, feature.getFeatureText());
            stmt.setString(2, feature.getIconClass());
            stmt.setInt(3, feature.getDisplayOrder());
            stmt.setInt(4, feature.getId());
            
            boolean success = stmt.executeUpdate() > 0;
            
            if (success) {
                logger.log(Level.INFO, "Successfully updated feature ID: {0}", feature.getId());
            }
            
            return success;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating service feature with ID: " + feature.getId(), e);
            return false;
        }
    }
    
    public boolean updateFeatureDisplayOrder(int featureId, int displayOrder) {
        String sql = "UPDATE service_features SET display_order = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, displayOrder);
            stmt.setInt(2, featureId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating feature display order for ID: " + featureId, e);
            return false;
        }
    }
    
    public boolean deleteServiceFeature(int featureId) {
        String sql = "DELETE FROM service_features WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, featureId);
            boolean success = stmt.executeUpdate() > 0;
            
            if (success) {
                logger.log(Level.INFO, "Successfully deleted feature ID: {0}", featureId);
            }
            
            return success;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting service feature with ID: " + featureId, e);
            return false;
        }
    }
    
    public boolean deleteAllServiceFeatures(int serviceId) {
        String sql = "DELETE FROM service_features WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            int affectedRows = stmt.executeUpdate();
            
            logger.log(Level.INFO, "Deleted {0} features for service ID: {1}", 
                      new Object[]{affectedRows, serviceId});
            return true;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting all features for service ID: " + serviceId, e);
            return false;
        }
    }
    
    private boolean deleteAllServiceFeatures(Connection conn, int serviceId) throws SQLException {
        String sql = "DELETE FROM service_features WHERE service_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            stmt.executeUpdate();
            return true;
        }
    }
    
    public boolean deleteServiceFeaturesByIds(List<Integer> featureIds) {
        if (featureIds == null || featureIds.isEmpty()) {
            return true;
        }
        
        String sql = "DELETE FROM service_features WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (int featureId : featureIds) {
                stmt.setInt(1, featureId);
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            int totalDeleted = 0;
            
            for (int result : results) {
                if (result > 0) {
                    totalDeleted++;
                }
            }
            
            logger.log(Level.INFO, "Deleted {0} features out of {1} requested", 
                      new Object[]{totalDeleted, featureIds.size()});
            
            return totalDeleted > 0;
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting features by IDs: " + featureIds, e);
            return false;
        }
    }
    
    public boolean updateServiceFeaturesBatch(List<ServiceFeature> features) {
        if (features == null || features.isEmpty()) {
            return true;
        }
        
        String sql = "UPDATE service_features SET feature_text = ?, icon_class = ?, display_order = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (ServiceFeature feature : features) {
                stmt.setString(1, feature.getFeatureText());
                stmt.setString(2, feature.getIconClass());
                stmt.setInt(3, feature.getDisplayOrder());
                stmt.setInt(4, feature.getId());
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            int totalUpdated = 0;
            
            for (int result : results) {
                if (result > 0) {
                    totalUpdated++;
                }
            }
            
            logger.log(Level.INFO, "Updated {0} features out of {1} requested", 
                      new Object[]{totalUpdated, features.size()});
            
            return totalUpdated == features.size();
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating features in batch", e);
            return false;
        }
    }
    
    public boolean reorderFeatures(int serviceId, List<Integer> featureIdsInOrder) {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String sql = "UPDATE service_features SET display_order = ? WHERE id = ? AND service_id = ?";
            stmt = conn.prepareStatement(sql);
            
            for (int i = 0; i < featureIdsInOrder.size(); i++) {
                stmt.setInt(1, i);
                stmt.setInt(2, featureIdsInOrder.get(i));
                stmt.setInt(3, serviceId);
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            boolean allSuccessful = true;
            
            for (int result : results) {
                if (result <= 0) {
                    allSuccessful = false;
                    break;
                }
            }
            
            if (allSuccessful) {
                conn.commit();
                logger.log(Level.INFO, "Successfully reordered {0} features for service ID: {1}", 
                          new Object[]{featureIdsInOrder.size(), serviceId});
                return true;
            } else {
                conn.rollback();
                logger.log(Level.WARNING, "Failed to reorder some features for service ID: {0}", serviceId);
                return false;
            }
            
        } catch (SQLException e) {
            rollbackConnection(conn);
            logger.log(Level.SEVERE, "Error reordering features for service ID: " + serviceId, e);
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }
    
    public boolean featureExists(int featureId) {
        String sql = "SELECT 1 FROM service_features WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, featureId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error checking if feature exists: " + featureId, e);
            return false;
        }
    }
    
    public int getFeatureCountForService(int serviceId) {
        String sql = "SELECT COUNT(*) FROM service_features WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting feature count for service ID: " + serviceId, e);
        }
        return 0;
    }
    
    public int getNextDisplayOrderForService(int serviceId) {
        String sql = "SELECT COALESCE(MAX(display_order), -1) + 1 FROM service_features WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error getting next display order for service ID: " + serviceId, e);
        }
        return 0;
    }
    
    // ===== PROCESS STEP METHODS =====
    
    public List<ProcessStep> getActiveProcessSteps() {
        List<ProcessStep> steps = new ArrayList<>();
        String sql = "SELECT * FROM process_steps WHERE is_active = TRUE ORDER BY display_order, step_number";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                ProcessStep step = extractProcessStepFromResultSet(rs);
                steps.add(step);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving active process steps", e);
        }
        return steps;
    }
    
    public List<ProcessStep> getAllProcessSteps() {
        List<ProcessStep> steps = new ArrayList<>();
        String sql = "SELECT * FROM process_steps ORDER BY display_order, step_number";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                ProcessStep step = extractProcessStepFromResultSet(rs);
                steps.add(step);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving all process steps", e);
        }
        return steps;
    }
    
    public ProcessStep getProcessStepById(int stepId) {
        String sql = "SELECT * FROM process_steps WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, stepId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractProcessStepFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving process step with ID: " + stepId, e);
        }
        return null;
    }
    
    public ProcessStep updateProcessStep(ProcessStep step) {
        String sql = "UPDATE process_steps SET title = ?, description = ?, display_order = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, step.getTitle());
            stmt.setString(2, step.getDescription());
            stmt.setInt(3, step.getDisplayOrder());
            stmt.setInt(4, step.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                logger.log(Level.INFO, "Successfully updated process step ID: {0}", step.getId());
                return getProcessStepById(step.getId());
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error updating process step with ID: " + step.getId(), e);
        }
        return null;
    }
    
    public boolean toggleProcessStepStatus(int stepId) {
        String sql = "UPDATE process_steps SET is_active = NOT is_active, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, stepId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error toggling process step status for ID: " + stepId, e);
            return false;
        }
    }
    
    // ===== PRIVATE HELPER METHODS =====
    
    private Service extractServiceFromResultSet(ResultSet rs) throws SQLException {
        Service service = new Service(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getString("short_description"),
            rs.getBigDecimal("base_price"),
            rs.getString("currency"),
            rs.getString("image_url"),
            rs.getString("icon_class"),
            rs.getBoolean("is_active")
        );
        
        // Set timestamps if they exist in the database
        try {
            if (rs.getTimestamp("created_at") != null) {
                service.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            }
            if (rs.getTimestamp("updated_at") != null) {
                service.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            }
        } catch (SQLException e) {
            // Ignore if columns don't exist
        }
        
        return service;
    }
    
    private ServiceFeature extractServiceFeatureFromResultSet(ResultSet rs) throws SQLException {
        ServiceFeature feature = new ServiceFeature(
            rs.getInt("id"),
            rs.getInt("service_id"),
            rs.getString("feature_text"),
            rs.getString("icon_class"),
            rs.getInt("display_order")
        );
        
        // Set timestamp if it exists
        try {
            if (rs.getTimestamp("created_at") != null) {
                feature.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            }
        } catch (SQLException e) {
            // Ignore if column doesn't exist
        }
        
        return feature;
    }
    
    private ProcessStep extractProcessStepFromResultSet(ResultSet rs) throws SQLException {
        ProcessStep step = new ProcessStep(
            rs.getInt("id"),
            rs.getInt("step_number"),
            rs.getString("title"),
            rs.getString("description"),
            rs.getInt("display_order"),
            rs.getBoolean("is_active")
        );
        
        // Set timestamps if they exist
        try {
            if (rs.getTimestamp("created_at") != null) {
                step.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            }
            if (rs.getTimestamp("updated_at") != null) {
                step.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            }
        } catch (SQLException e) {
            // Ignore if columns don't exist
        }
        
        return step;
    }
    
    private void setServiceStatementParameters(PreparedStatement stmt, Service service) throws SQLException {
        stmt.setString(1, service.getName());
        stmt.setString(2, service.getDescription());
        stmt.setString(3, service.getShortDescription());
        stmt.setBigDecimal(4, service.getBasePrice());
        stmt.setString(5, service.getCurrency());
        stmt.setString(6, service.getImageUrl());
        stmt.setString(7, service.getIconClass());
    }
    
    private boolean addServiceFeatures(Connection conn, int serviceId, List<ServiceFeature> features) throws SQLException {
        String sql = "INSERT INTO service_features (service_id, feature_text, icon_class, display_order) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (ServiceFeature feature : features) {
                stmt.setInt(1, serviceId);
                stmt.setString(2, feature.getFeatureText());
                stmt.setString(3, feature.getIconClass());
                stmt.setInt(4, feature.getDisplayOrder());
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
        }
    }
    
    private boolean updateServiceFeatures(Connection conn, int serviceId, List<ServiceFeature> features) throws SQLException {
        // First delete existing features
        if (!deleteAllServiceFeatures(conn, serviceId)) {
            return false;
        }
        
        // Then add new features
        if (features != null && !features.isEmpty()) {
            return addServiceFeatures(conn, serviceId, features);
        }
        
        return true;
    }
    
    // ===== RESOURCE MANAGEMENT METHODS =====
    
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Error closing database resources", e);
        }
    }
    
    private void rollbackConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                logger.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
            }
        }
    }
}