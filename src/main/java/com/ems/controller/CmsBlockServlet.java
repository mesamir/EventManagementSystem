package com.ems.controller;

import com.ems.dao.CmsBlockDAO;
import com.ems.model.CmsBlock;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/cms/blocks")
public class CmsBlockServlet extends HttpServlet {
    private CmsBlockDAO blockDAO;

    @Override
    public void init() {
        blockDAO = new CmsBlockDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<CmsBlock> blocks = blockDAO.getAllBlocks();
            request.setAttribute("blocks", blocks);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Failed to load content blocks.");
        }
        request.getRequestDispatcher("/cms_blocks.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String icon = request.getParameter("icon");
        String description = request.getParameter("description");
        int position = Integer.parseInt(request.getParameter("position"));
        boolean active = "on".equals(request.getParameter("active"));

        CmsBlock block = new CmsBlock();
        block.setTitle(title);
        block.setIcon(icon);
        block.setDescription(description);
        block.setPosition(position);
        block.setActive(active);

        try {
            blockDAO.saveOrUpdate(block);
            response.sendRedirect("blocks?successMessage=Block saved successfully");
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Failed to save block.");
            doGet(request, response);
        }
    }
}

