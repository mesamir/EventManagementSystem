package com.ems.controller;

import com.ems.model.Service;
import com.ems.model.ServiceFeature;
import com.ems.model.ProcessStep;
import com.ems.service.ServiceManager;
import com.ems.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/services")
public class ServiceServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ServiceServlet.class.getName());
    private ServiceManager serviceManager;
    private ObjectMapper objectMapper;
    
    @Override
    public void init() throws ServletException {
        this.serviceManager = new ServiceManager();
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
        this.objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        this.objectMapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("list".equals(action)) {
                handleListServices(request, response);
            } else if ("get".equals(action)) {
                handleGetService(request, response);
            } else if ("stats".equals(action)) {
                handleGetStats(request, response);
            } else {
                handleGetAllData(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in GET request", e);
            sendErrorResponse(response, "Error processing request: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "add":
                    handleAddService(request, response);
                    break;
                case "update":
                    handleUpdateService(request, response);
                    break;
                case "toggle":
                    handleToggleService(request, response);
                    break;
                case "delete":
                    handleDeleteService(request, response);
                    break;
                case "update-process-step":
                    handleUpdateProcessStep(request, response);
                    break;
                case "add-feature":
                    handleAddFeature(request, response);
                    break;
                case "remove-feature":
                    handleRemoveFeature(request, response);
                    break;
                case "reorder-features":
                    handleReorderFeatures(request, response);
                    break;
                default:
                    sendErrorResponse(response, "Invalid action specified");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in POST request for action: " + action, e);
            sendErrorResponse(response, "Error processing request: " + e.getMessage());
        }
    }
    
    private void handleGetAllData(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> data = new HashMap<>();
        
        try {
            // Get services with features
            List<Service> services = serviceManager.getAllActiveServices();
            data.put("services", services);
            
            // Get process steps
            List<ProcessStep> processSteps = serviceManager.getActiveProcessSteps();
            data.put("processSteps", processSteps);
            
            // Get stats
            Map<String, Object> stats = serviceManager.getServiceStats();
            data.put("stats", stats);
            
            data.put("success", true);
            
        } catch (Exception e) {
            data.put("success", false);
            data.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error getting all data", e);
        }
        
        sendJsonResponse(response, data);
    }
    
    private void handleListServices(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String status = request.getParameter("status");
            List<Service> services;
            
            if ("all".equals(status)) {
                services = serviceManager.getAllServices();
            } else if ("inactive".equals(status)) {
                services = serviceManager.getAllServices().stream()
                    .filter(service -> !service.isActive())
                    .toList();
            } else {
                services = serviceManager.getAllActiveServices();
            }
            
            result.put("success", true);
            result.put("services", services);
            result.put("count", services.size());
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error listing services", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleGetService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Service ID is required");
            }
            
            int serviceId = Integer.parseInt(idParam);
            Service service = serviceManager.getServiceById(serviceId);
            
            if (service != null) {
                result.put("success", true);
                result.put("service", service);
            } else {
                result.put("success", false);
                result.put("error", "Service not found with ID: " + serviceId);
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error getting service", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleGetStats(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Map<String, Object> stats = serviceManager.getServiceStats();
            result.put("success", true);
            result.put("stats", stats);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error getting stats", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleAddService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Service service = parseServiceFromRequest(request);
            
            // Validate service data
            List<String> validationErrors = serviceManager.validateService(service);
            if (!validationErrors.isEmpty()) {
                result.put("success", false);
                result.put("error", String.join(", ", validationErrors));
                sendJsonResponse(response, result);
                return;
            }
            
            Service createdService = serviceManager.createService(
                service.getName(),
                service.getDescription(),
                service.getShortDescription(),
                service.getBasePrice(),
                service.getCurrency(),
                service.getImageUrl(),
                service.getIconClass(),
                service.getFeatures()
            );
            
            result.put("success", true);
            result.put("message", "Service created successfully");
            result.put("service", createdService);
            logger.log(Level.INFO, "Service created: {0}", createdService.getName());
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error adding service", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleUpdateService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Service ID is required");
            }
            
            int serviceId = Integer.parseInt(idParam);
            Service service = parseServiceFromRequest(request);
            
            // Validate service data
            List<String> validationErrors = serviceManager.validateService(service);
            if (!validationErrors.isEmpty()) {
                result.put("success", false);
                result.put("error", String.join(", ", validationErrors));
                sendJsonResponse(response, result);
                return;
            }
            
            Service updatedService = serviceManager.updateService(
                serviceId,
                service.getName(),
                service.getDescription(),
                service.getShortDescription(),
                service.getBasePrice(),
                service.getCurrency(),
                service.getImageUrl(),
                service.getIconClass(),
                service.isActive(),
                service.getFeatures()
            );
            
            result.put("success", true);
            result.put("message", "Service updated successfully");
            result.put("service", updatedService);
            logger.log(Level.INFO, "Service updated: {0} (ID: {1})", 
                      new Object[]{updatedService.getName(), serviceId});
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error updating service", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleToggleService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Service ID is required");
            }
            
            int serviceId = Integer.parseInt(idParam);
            boolean success = serviceManager.toggleServiceStatus(serviceId);
            
            if (success) {
                Service service = serviceManager.getServiceById(serviceId);
                result.put("success", true);
                result.put("message", "Service " + (service.isActive() ? "activated" : "deactivated") + " successfully");
                result.put("service", service);
                logger.log(Level.INFO, "Service status toggled for ID: {0}", serviceId);
            } else {
                result.put("success", false);
                result.put("error", "Failed to toggle service status");
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error toggling service status", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleDeleteService(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                throw new IllegalArgumentException("Service ID is required");
            }
            
            int serviceId = Integer.parseInt(idParam);
            Service service = serviceManager.getServiceById(serviceId);
            
            if (service == null) {
                result.put("success", false);
                result.put("error", "Service not found with ID: " + serviceId);
                sendJsonResponse(response, result);
                return;
            }
            
            boolean success = serviceManager.deleteService(serviceId);
            
            if (success) {
                result.put("success", true);
                result.put("message", "Service deleted successfully");
                logger.log(Level.INFO, "Service deleted: {0} (ID: {1})", 
                          new Object[]{service.getName(), serviceId});
            } else {
                result.put("success", false);
                result.put("error", "Failed to delete service");
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error deleting service", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleUpdateProcessStep(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String stepIdParam = request.getParameter("step_id");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            
            if (stepIdParam == null || title == null || description == null) {
                throw new IllegalArgumentException("Step ID, title, and description are required");
            }
            
            int stepId = Integer.parseInt(stepIdParam);
            ProcessStep updatedStep = serviceManager.updateProcessStep(stepId, title, description);
            
            result.put("success", true);
            result.put("message", "Process step updated successfully");
            result.put("processStep", updatedStep);
            logger.log(Level.INFO, "Process step updated: {0} (ID: {1})", 
                      new Object[]{updatedStep.getTitle(), stepId});
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error updating process step", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleAddFeature(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String serviceIdParam = request.getParameter("service_id");
            String featureText = request.getParameter("feature_text");
            String iconClass = request.getParameter("icon_class");
            
            if (serviceIdParam == null || featureText == null) {
                throw new IllegalArgumentException("Service ID and feature text are required");
            }
            
            int serviceId = Integer.parseInt(serviceIdParam);
            ServiceFeature feature = serviceManager.addFeatureToService(serviceId, featureText, iconClass);
            
            result.put("success", true);
            result.put("message", "Feature added successfully");
            result.put("feature", feature);
            logger.log(Level.INFO, "Feature added to service ID: {0}", serviceId);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error adding feature", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleRemoveFeature(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String featureIdParam = request.getParameter("feature_id");
            
            if (featureIdParam == null) {
                throw new IllegalArgumentException("Feature ID is required");
            }
            
            int featureId = Integer.parseInt(featureIdParam);
            boolean success = serviceManager.removeFeatureFromService(featureId);
            
            if (success) {
                result.put("success", true);
                result.put("message", "Feature removed successfully");
                logger.log(Level.INFO, "Feature removed: ID {0}", featureId);
            } else {
                result.put("success", false);
                result.put("error", "Failed to remove feature");
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error removing feature", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private void handleReorderFeatures(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            String serviceIdParam = request.getParameter("service_id");
            String[] featureIds = request.getParameterValues("feature_ids[]");
            
            if (serviceIdParam == null || featureIds == null) {
                throw new IllegalArgumentException("Service ID and feature IDs are required");
            }
            
            int serviceId = Integer.parseInt(serviceIdParam);
            List<Integer> featureIdsList = new ArrayList<>();
            
            for (String featureId : featureIds) {
                featureIdsList.add(Integer.parseInt(featureId));
            }
            
            boolean success = serviceManager.reorderFeatures(serviceId, featureIdsList);
            
            if (success) {
                result.put("success", true);
                result.put("message", "Features reordered successfully");
                logger.log(Level.INFO, "Features reordered for service ID: {0}", serviceId);
            } else {
                result.put("success", false);
                result.put("error", "Failed to reorder features");
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            logger.log(Level.SEVERE, "Error reordering features", e);
        }
        
        sendJsonResponse(response, result);
    }
    
    private Service parseServiceFromRequest(HttpServletRequest request) {
        Service service = new Service();
        
        // Basic service info
        service.setName(request.getParameter("name"));
        service.setDescription(request.getParameter("description"));
        service.setShortDescription(request.getParameter("short_description"));
        
        // Price and currency
        String basePriceStr = request.getParameter("base_price");
        if (basePriceStr != null && !basePriceStr.trim().isEmpty()) {
            try {
                service.setBasePrice(new BigDecimal(basePriceStr));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Invalid base price format");
            }
        }
        
        service.setCurrency(request.getParameter("currency"));
        service.setImageUrl(request.getParameter("image_url"));
        service.setIconClass(request.getParameter("icon_class"));
        
        // Status
        String status = request.getParameter("status");
        service.setActive("active".equals(status));
        
        // Parse features
        String[] features = request.getParameterValues("features[]");
        String[] featureIcons = request.getParameterValues("feature_icons[]");
        
        if (features != null && features.length > 0) {
            List<ServiceFeature> featureList = new ArrayList<>();
            for (int i = 0; i < features.length; i++) {
                if (features[i] != null && !features[i].trim().isEmpty()) {
                    ServiceFeature feature = new ServiceFeature();
                    feature.setFeatureText(features[i].trim());
                    feature.setIconClass(
                        (featureIcons != null && i < featureIcons.length && featureIcons[i] != null) 
                            ? featureIcons[i].trim() 
                            : "fas fa-check"
                    );
                    feature.setDisplayOrder(i);
                    featureList.add(feature);
                }
            }
            service.setFeatures(featureList);
        }
        
        return service;
    }
     private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    try {
        String json = objectMapper.writeValueAsString(data);
        response.getWriter().write(json);
    } catch (Exception e) {
        logger.log(Level.SEVERE, "Error serializing JSON response", e);
        // Don't call sendErrorResponse here to avoid infinite recursion
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("error", "Error generating response");
        response.getWriter().write("{\"success\":false,\"error\":\"Error generating response\"}");
    }
}
   
    
    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("error", errorMessage);
        sendJsonResponse(response, errorResponse);
    }
    
  
    private String escapeJsonString(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
    
    @Override
    public void destroy() {
        // Cleanup resources if needed
        logger.info("ServiceServlet destroyed");
    }
}