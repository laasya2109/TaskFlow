package com.taskmanager.controller;

import com.taskmanager.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/migrate")
public class MigrationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body><h1>Database Migration Progress</h1>");

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            out.println("<p>Checking 'tasks' table columns...</p>");
            ResultSet rs = conn.getMetaData().getColumns(null, null, "tasks", "category");
            
            if (!rs.next()) {
                out.println("<p style='color:blue;'>Column 'category' missing. Adding it now...</p>");
                stmt.executeUpdate("ALTER TABLE tasks ADD COLUMN category VARCHAR(50) DEFAULT 'Personal' AFTER status");
                out.println("<p style='color:green;'>[SUCCESS] Column 'category' added.</p>");
            } else {
                out.println("<p style='color:green;'>Column 'category' already exists.</p>");
            }

            out.println("<p>UPGRADING 'due_date' to DATETIME...</p>");
            try {
                stmt.executeUpdate("ALTER TABLE tasks MODIFY due_date DATETIME");
                out.println("<p style='color:green;'>[SUCCESS] Column 'due_date' upgraded to DATETIME.</p>");
            } catch (Exception e) {
                out.println("<p style='color:orange;'>[INFO] Upgrade already applied or minor error: " + e.getMessage() + "</p>");
            }

            out.println("<p>Updating any NULL categories to 'Personal'...</p>");
            int rows = stmt.executeUpdate("UPDATE tasks SET category = 'Personal' WHERE category IS NULL OR category = ''");
            out.println("<p>Updated " + rows + " rows.</p>");

            out.println("<p style='color:blue;'>Checking 'has_time' column...</p>");
            ResultSet rs3 = conn.getMetaData().getColumns(null, null, "tasks", "has_time");
            if (!rs3.next()) {
                out.println("<p style='color:blue;'>Column 'has_time' missing. Adding it now...</p>");
                stmt.executeUpdate("ALTER TABLE tasks ADD COLUMN has_time BOOLEAN DEFAULT FALSE");
                out.println("<p style='color:green;'>[SUCCESS] Column 'has_time' added.</p>");
            }

            out.println("<h3>Final Schema Check:</h3><ul>");
            try (ResultSet rs2 = stmt.executeQuery("DESCRIBE tasks")) {
                while (rs2.next()) {
                    String colName = rs2.getString(1);
                    String colType = rs2.getString(2);
                    out.println("<li>" + colName + " - " + colType + "</li>");
                }
            }
            out.println("</ul>");

            out.println("<h2>Data Inspector (Debug)</h2>");
            out.println("<table border='1' style='width:100%; border-collapse:collapse;'>");
            out.println("<tr style='background:#444; color:white;'><th>ID</th><th>Title</th><th>UserID</th><th>Category</th><th>HasTime</th><th>DueDate</th></tr>");
            try (ResultSet rsTasks = stmt.executeQuery("SELECT id, title, user_id, category, has_time, due_date FROM tasks ORDER BY id DESC LIMIT 50")) {
                while (rsTasks.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rsTasks.getInt("id") + "</td>");
                    out.println("<td>" + rsTasks.getString("title") + "</td>");
                    out.println("<td>" + rsTasks.getInt("user_id") + "</td>");
                    out.println("<td>" + rsTasks.getString("category") + "</td>");
                    out.println("<td>" + rsTasks.getBoolean("has_time") + "</td>");
                    out.println("<td>" + rsTasks.getTimestamp("due_date") + "</td>");
                    out.println("</tr>");
                }
            }
            out.println("</table>");
            
            out.println("<h2>Environment Overview</h2>");
            out.println("<p><b>Correct Debug Link:</b> <a href='http://localhost:9091/JFSD/migrate'>http://localhost:9091/JFSD/migrate</a></p>");
            out.println("<p><b>Active User:</b> " + (request.getSession().getAttribute("user") != null ? ((com.taskmanager.model.User)request.getSession().getAttribute("user")).getUsername() + " (ID: " + ((com.taskmanager.model.User)request.getSession().getAttribute("user")).getId() + ")" : "NONE") + "</p>");
            out.println("<p><b>Current Category:</b> " + request.getSession().getAttribute("activeCategory") + "</p>");

            out.println("<h2>Full Task Table Dump (Top 50 Recently Added)</h2>");
            out.println("<table border='1' style='width:100%; border-collapse:collapse; background:#f9f9f9;'>");
            out.println("<tr style='background:#222; color:white;'><th>ID</th><th>Title</th><th>UserID</th><th>Category</th><th>Status</th><th>HasTime</th><th>DueDate</th></tr>");
            try (ResultSet rsTasks = stmt.executeQuery("SELECT * FROM tasks ORDER BY id DESC LIMIT 50")) {
                boolean found = false;
                while (rsTasks.next()) {
                    found = true;
                    out.println("<tr>");
                    out.println("<td>" + rsTasks.getInt("id") + "</td>");
                    out.println("<td><b>" + rsTasks.getString("title") + "</b></td>");
                    out.println("<td>" + rsTasks.getInt("user_id") + "</td>");
                    out.println("<td>" + rsTasks.getString("category") + "</td>");
                    out.println("<td>" + rsTasks.getString("status") + "</td>");
                    out.println("<td>" + rsTasks.getBoolean("has_time") + "</td>");
                    out.println("<td>" + rsTasks.getTimestamp("due_date") + "</td>");
                    out.println("</tr>");
                }
                if (!found) out.println("<tr><td colspan='7' style='text-align:center;'>NO TASKS IN DATABASE</td></tr>");
            }
            out.println("</table>");
            
            out.println("<hr>");
            out.println("<h3>Actions</h3>");
            out.println("<ul>");
            out.println("<li><a href='dashboard'>Go to Dashboard</a></li>");
            out.println("<li><a href='select-category.jsp'>Switch Category</a></li>");
            out.println("</ul>");

        } catch (Exception e) {
            out.println("<p style='color:red;'>[ERROR] Migration failed: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        out.println("</body></html>");
    }
}
