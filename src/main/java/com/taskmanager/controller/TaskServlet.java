package com.taskmanager.controller;

import com.taskmanager.dao.TaskDAO;
import com.taskmanager.model.Task;
import com.taskmanager.model.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet({ "/dashboard", "/new", "/insert", "/delete", "/edit", "/update", "/toggleStatus" })
public class TaskServlet extends HttpServlet {
    private TaskDAO taskDAO;

    public void init() {
        taskDAO = new TaskDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/new":
                    showNewForm(request, response);
                    break;
                case "/insert":
                    insertTask(request, response);
                    break;
                case "/delete":
                    deleteTask(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateTask(request, response);
                    break;
                case "/toggleStatus":
                    toggleStatus(request, response);
                    break;
                case "/dashboard":
                    listTasks(request, response);
                    break;
                default:
                    // If logged in, go to dashboard, else login
                    HttpSession session = request.getSession(false);
                    if (session != null && session.getAttribute("user") != null) {
                        listTasks(request, response);
                    } else {
                        response.sendRedirect("login.jsp");
                    }
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listTasks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Force category retrieval from session
            String category = (String) session.getAttribute("activeCategory");

            if (category == null || category.isEmpty()) {
                response.sendRedirect("select-category.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            String query = request.getParameter("q");
            String filterStatus = request.getParameter("status");
            String filterCategory = request.getParameter("category");

            List<Task> listTasks;
            if (query != null || filterStatus != null || filterCategory != null) {
                // If filterCategory is not provided, we might want to stay in current category or search globally
                // For now, let's assume search bar in dashboard defaults to current category unless explicitly changed
                String searchCat = (filterCategory != null) ? filterCategory : category;
                listTasks = taskDAO.searchTasks(user.getId(), query, searchCat, filterStatus);
            } else {
                listTasks = taskDAO.getTasksByUserIdAndCategory(user.getId(), category);
            }
            
            request.setAttribute("listTasks", listTasks);
            RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("task-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Task existingTask = taskDAO.getTaskById(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("task-form.jsp");
        request.setAttribute("task", existingTask);
        dispatcher.forward(request, response);
    }

    private void insertTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String category = (String) session.getAttribute("activeCategory");
            if (category == null) {
                 category = "Personal"; // Fallback
            }
            
            
            String rawDate = request.getParameter("dueDate");
            String rawTime = request.getParameter("dueTime");
            System.out.println("[DEBUG] Raw Date: " + rawDate + " | Raw Time: " + rawTime);
            
            boolean hasTime = (rawTime != null && !rawTime.trim().isEmpty());
            String timestampStr = rawDate + " " + (hasTime ? rawTime : "00:00") + ":00";
            
            Timestamp dueDate;
            try {
                dueDate = Timestamp.valueOf(timestampStr);
            } catch (Exception e) {
                System.err.println("[ERROR] Failed to parse date: " + timestampStr + ". Using current time.");
                dueDate = new Timestamp(System.currentTimeMillis());
                hasTime = false;
            }
            System.out.println("[DEBUG] Final Timestamp: " + dueDate + " | HasTime: " + hasTime);

            Task newTask = new Task(0, title, description, status, category, dueDate, user.getId(), hasTime);
            taskDAO.addTask(newTask);
            response.sendRedirect("dashboard");
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        String category = (session != null && session.getAttribute("activeCategory") != null) 
                          ? (String) session.getAttribute("activeCategory") : "Personal";
        
        String rawDate = request.getParameter("dueDate");
        String rawTime = request.getParameter("dueTime");
        System.out.println("[DEBUG] Updating Task - Raw Date: " + rawDate + " | Raw Time: " + rawTime);
        
        boolean hasTime = (rawTime != null && !rawTime.trim().isEmpty());
        String timestampStr = rawDate + " " + (hasTime ? rawTime : "00:00") + ":00";

        Timestamp dueDate;
        try {
            dueDate = Timestamp.valueOf(timestampStr);
        } catch (Exception e) {
            System.err.println("[ERROR] Failed to parse date: " + timestampStr + ". Using current time.");
            dueDate = new Timestamp(System.currentTimeMillis());
            hasTime = false;
        }
        System.out.println("[DEBUG] Updating Task - Parsed Timestamp: " + dueDate + " | HasTime: " + hasTime);

        User user = (User) session.getAttribute("user");
        int userId = (user != null) ? user.getId() : 0;
        
        Task task = new Task(id, title, description, status, category, dueDate, userId, hasTime);
        taskDAO.updateTask(task);
        response.sendRedirect("dashboard");
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        taskDAO.deleteTask(id);
        response.sendRedirect("dashboard");
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            if ("Completed".equals(status) || "Pending".equals(status)) {
                taskDAO.updateTaskStatus(id, status);
            }
            response.sendRedirect("dashboard");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
