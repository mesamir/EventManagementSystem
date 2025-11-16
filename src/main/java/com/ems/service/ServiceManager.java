package com.ems.service;

import com.ems.dao.ServiceDAO;
import com.ems.model.Service;
import com.ems.model.ServiceFeature;
import com.ems.model.ProcessStep;
import com.ems.util.ValidationUtil;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class ServiceManager {
    private ServiceDAO serviceDAO;
    
    public ServiceManager() {
        this.serviceDAO = new ServiceDAO();
    }
    
    // Service Management Methods
    
    public List<Service> getAllActiveServices() {
        return serviceDAO.getAllActiveServices();
    }
    
    public List<Service> getAllServices() {
        return serviceDAO.getAllServices();
    }
    
    public Service getServiceById(int serviceId) {
        ValidationUtil.validatePositive(BigDecimal.valueOf(serviceId), "Service ID");
        return serviceDAO.getServiceById(serviceId);
    }
    
    public Service createService(String name, String description, String shortDescription,
                               BigDecimal basePrice, String currency, String imageUrl, 
                               String iconClass, List<ServiceFeature> features) {
        
        // Enhanced validation
        ValidationUtil.validateNotEmpty(name, "Service name");
        ValidationUtil.validateNotEmpty(description, "Service description");
        ValidationUtil.validatePositive(basePrice, "Base price");
        ValidationUtil.validateMaxLength(name, 100, "Service name");
        ValidationUtil.validateMaxLength(description, 1000, "Service description");
        
        if (shortDescription != null) {
            ValidationUtil.validateMaxLength(shortDescription, 200, "Short description");
        }
        
        Service service = new Service();
        service.setName(name.trim());
        service.setDescription(description.trim());
        service.setShortDescription(shortDescription != null ? shortDescription.trim() : "");
        service.setBasePrice(basePrice);
        service.setCurrency(currency != null ? currency : "NPR");
        service.setImageUrl(imageUrl);
        service.setIconClass(iconClass != null ? iconClass.trim() : "fas fa-cog");
        service.setActive(true);
        
        // Set features with proper ordering
        if (features != null) {
            for (int i = 0; i < features.size(); i++) {
                ServiceFeature feature = features.get(i);
                if (feature != null) {
                    feature.setDisplayOrder(i);
                    // Ensure feature has default icon if not provided
                    if (feature.getIconClass() == null || feature.getIconClass().trim().isEmpty()) {
                        feature.setIconClass("fas fa-check");
                    }
                }
            }
            service.setFeatures(features);
        }
        
        // Save to database
        boolean success = serviceDAO.addService(service);
        
        if (success) {
            return service;
        } else {
            throw new RuntimeException("Failed to create service in database");
        }
    }
    
    public Service updateService(int serviceId, String name, String description, String shortDescription,
                               BigDecimal basePrice, String currency, String imageUrl, 
                               String iconClass, boolean active, List<ServiceFeature> features) {
        
        // Enhanced validation
        ValidationUtil.validateNotEmpty(name, "Service name");
        ValidationUtil.validateNotEmpty(description, "Service description");
        ValidationUtil.validatePositive(basePrice, "Base price");
        
        Service existingService = serviceDAO.getServiceById(serviceId);
        if (existingService == null) {
            throw new IllegalArgumentException("Service not found with ID: " + serviceId);
        }
        
        existingService.setName(name.trim());
        existingService.setDescription(description.trim());
        existingService.setShortDescription(shortDescription != null ? shortDescription.trim() : "");
        existingService.setBasePrice(basePrice);
        existingService.setCurrency(currency != null ? currency : "NPR");
        existingService.setImageUrl(imageUrl);
        existingService.setIconClass(iconClass != null ? iconClass.trim() : "fas fa-cog");
        existingService.setActive(active);
        
        // Update features with proper ordering
        if (features != null) {
            for (int i = 0; i < features.size(); i++) {
                ServiceFeature feature = features.get(i);
                if (feature != null) {
                    feature.setServiceId(serviceId);
                    feature.setDisplayOrder(i);
                    // Ensure feature has default icon if not provided
                    if (feature.getIconClass() == null || feature.getIconClass().trim().isEmpty()) {
                        feature.setIconClass("fas fa-check");
                    }
                }
            }
            existingService.setFeatures(features);
        } else {
            existingService.setFeatures(null);
        }
        
        // Update in database
        boolean success = serviceDAO.updateService(existingService);
        
        if (success) {
            return serviceDAO.getServiceById(serviceId); // Return fresh data
        } else {
            throw new RuntimeException("Failed to update service in database");
        }
    }
    
    public boolean deleteService(int serviceId) {
        Service existingService = serviceDAO.getServiceById(serviceId);
        if (existingService == null) {
            throw new IllegalArgumentException("Service not found with ID: " + serviceId);
        }
        
        // Option 1: Soft delete (recommended)
        existingService.setActive(false);
        boolean success = serviceDAO.updateService(existingService);
        
        // Option 2: Hard delete (if you want permanent deletion)
        // boolean success = serviceDAO.deleteService(serviceId);
        
        return success;
    }
    
    public boolean toggleServiceStatus(int serviceId) {
        Service existingService = serviceDAO.getServiceById(serviceId);
        if (existingService == null) {
            throw new IllegalArgumentException("Service not found with ID: " + serviceId);
        }
        
        existingService.setActive(!existingService.isActive());
        return serviceDAO.updateService(existingService);
    }
    
    // Enhanced feature management
    public ServiceFeature addFeatureToService(int serviceId, String featureText, String iconClass) {
        ValidationUtil.validateNotEmpty(featureText, "Feature text");
        ValidationUtil.validateMaxLength(featureText, 255, "Feature text");
        
        Service service = serviceDAO.getServiceById(serviceId);
        if (service == null) {
            throw new IllegalArgumentException("Service not found with ID: " + serviceId);
        }
        
        // Get current max display order
        int maxOrder = service.getFeatures().stream()
            .mapToInt(ServiceFeature::getDisplayOrder)
            .max()
            .orElse(-1);
        
        ServiceFeature feature = new ServiceFeature();
        feature.setServiceId(serviceId);
        feature.setFeatureText(featureText.trim());
        feature.setIconClass(iconClass != null ? iconClass.trim() : "fas fa-check");
        feature.setDisplayOrder(maxOrder + 1);
        
        boolean success = serviceDAO.addServiceFeature(feature);
        
        if (success) {
            return feature;
        } else {
            throw new RuntimeException("Failed to add feature to service");
        }
    }
    
    public boolean removeFeatureFromService(int featureId) {
        return serviceDAO.deleteServiceFeature(featureId);
    }
    
    public boolean updateFeature(int featureId, String featureText, String iconClass, int displayOrder) {
        ServiceFeature feature = serviceDAO.getServiceFeatureById(featureId);
        if (feature == null) {
            throw new IllegalArgumentException("Feature not found with ID: " + featureId);
        }
        
        feature.setFeatureText(featureText);
        feature.setIconClass(iconClass);
        feature.setDisplayOrder(displayOrder);
        
        return serviceDAO.updateServiceFeature(feature);
    }
    
    public boolean reorderFeatures(int serviceId, List<Integer> featureIdsInOrder) {
        return serviceDAO.reorderFeatures(serviceId, featureIdsInOrder);
    }
    
    // Enhanced process step management
    public List<ProcessStep> getActiveProcessSteps() {
        return serviceDAO.getActiveProcessSteps();
    }
    
    public ProcessStep updateProcessStep(int stepId, String title, String description) {
        ValidationUtil.validateNotEmpty(title, "Step title");
        ValidationUtil.validateNotEmpty(description, "Step description");
        ValidationUtil.validateMaxLength(title, 100, "Step title");
        ValidationUtil.validateMaxLength(description, 500, "Step description");
        
        ProcessStep existingStep = serviceDAO.getProcessStepById(stepId);
        if (existingStep == null) {
            throw new IllegalArgumentException("Process step not found with ID: " + stepId);
        }
        
        existingStep.setTitle(title.trim());
        existingStep.setDescription(description.trim());
        
        ProcessStep updatedStep = serviceDAO.updateProcessStep(existingStep);
        
        if (updatedStep != null) {
            return updatedStep;
        } else {
            throw new RuntimeException("Failed to update process step");
        }
    }
    
    public boolean toggleProcessStepStatus(int stepId) {
        return serviceDAO.toggleProcessStepStatus(stepId);
    }
    
    // Enhanced stats method
    public Map<String, Object> getServiceStats() {
        List<Service> services = serviceDAO.getAllActiveServices();
        List<ProcessStep> processSteps = serviceDAO.getActiveProcessSteps();
        
        int totalServices = services.size();
        int activeServices = (int) services.stream().filter(Service::isActive).count();
        int totalFeatures = services.stream()
            .mapToInt(service -> service.getFeatures() != null ? service.getFeatures().size() : 0)
            .sum();
        int processStepsCount = processSteps.size();
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalServices", totalServices);
        stats.put("activeServices", activeServices);
        stats.put("totalFeatures", totalFeatures);
        stats.put("processSteps", processStepsCount);
        stats.put("inactiveServices", totalServices - activeServices);
        
        return stats;
    }
    
    // Search functionality
    public List<Service> searchServices(String searchTerm) {
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return getAllActiveServices();
        }
        return serviceDAO.searchServices(searchTerm.trim());
    }
    
    // Batch operations
    public boolean updateFeatureOrder(int serviceId, List<Integer> featureIdsInOrder) {
        try {
            return serviceDAO.reorderFeatures(serviceId, featureIdsInOrder);
        } catch (Exception e) {
            throw new RuntimeException("Failed to update feature order: " + e.getMessage());
        }
    }
    
    // Validation helper
    public List<String> validateService(Service service) {
        return service.getValidationErrors();
    }
}