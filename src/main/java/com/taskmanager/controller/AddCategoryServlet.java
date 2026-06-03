package com.taskmanager.controller;

import com.taskmanager.dao.CategoryDAO;
import com.taskmanager.model.Category;
import com.taskmanager.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/add-category")
public class AddCategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    public void init() {
        categoryDAO = new CategoryDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String icon = request.getParameter("icon");

            if (name != null && !name.trim().isEmpty()) {
                if (icon == null || icon.trim().isEmpty()) {
                    icon = "📋";
                }
                Category cat = new Category(0, name.trim(), description != null ? description.trim() : "", icon.trim(), user.getId());
                categoryDAO.addCategory(cat);
            }
            response.sendRedirect("select-category.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
