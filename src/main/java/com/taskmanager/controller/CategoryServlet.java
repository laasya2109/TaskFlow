package com.taskmanager.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/set-category")
public class CategoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");
        if (category != null && !category.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("activeCategory", category.trim());
            System.out.println("[DEBUG] Category set in session: " + category);
        }
        response.sendRedirect("dashboard");
    }
}
