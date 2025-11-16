package com.ems.controller;

import com.ems.model.Event;
import com.ems.model.User;

import com.ems.model.VendorSelection;
import com.ems.service.EventManager;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;





@WebServlet("/client/event-vendors")
public class EventVendorsServlet extends HttpServlet {
    private EventManager eventManager;
    
    @Override
    public void init() throws ServletException {
        super.init();
        eventManager = new EventManager();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Authorization check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String eventIdStr = request.getParameter("eventId");
        
        if (eventIdStr == null || eventIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        
        try {
            int eventId = Integer.parseInt(eventIdStr);
            Event event = eventManager.getEventById(eventId);
            
            // Verify ownership
            if (event == null || event.getClientId() != loggedInUser.getUserId()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            // Get vendors for this event
            List<VendorSelection> vendors = event.getSelectedVendors();
            
            // Convert to JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            ObjectMapper mapper = new ObjectMapper();
            mapper.writeValue(response.getWriter(), vendors);
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
