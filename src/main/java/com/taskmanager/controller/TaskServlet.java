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
import java.sql.Date;
import java.util.List;

@WebServlet({ "/dashboard", "/new", "/insert", "/delete", "/edit", "/update" })
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
            User user = (User) session.getAttribute("user");
            List<Task> listTasks = taskDAO.getTasksByUserId(user.getId());
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
            Date dueDate = Date.valueOf(request.getParameter("dueDate"));

            Task newTask = new Task(0, title, description, status, dueDate, user.getId());
            taskDAO.addTask(newTask);
            response.sendRedirect("dashboard");
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");
        Date dueDate = Date.valueOf(request.getParameter("dueDate"));

        // userId is not updated, but needed for constructor or we can fetch it.
        // For simplicity, we just update fields.
        // Actually, we need to be careful not to lose userId if we use the constructor.
        // Let's fetch the old task to be safe or just pass 0 if DAO update doesn't
        // touch userId.
        // DAO updateTask uses ID to update other fields, doesn't touch userId.

        Task task = new Task(id, title, description, status, dueDate, 0);
        taskDAO.updateTask(task);
        response.sendRedirect("dashboard");
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        taskDAO.deleteTask(id);
        response.sendRedirect("dashboard");
    }
}
