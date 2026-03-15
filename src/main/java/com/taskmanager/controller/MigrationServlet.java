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

            out.println("<p>Updating any NULL categories to 'Personal'...</p>");
            int rows = stmt.executeUpdate("UPDATE tasks SET category = 'Personal' WHERE category IS NULL OR category = ''");
            out.println("<p>Updated " + rows + " rows.</p>");

            out.println("<h3>Final Schema Check:</h3><ul>");
            try (ResultSet rs2 = stmt.executeQuery("DESCRIBE tasks")) {
                while (rs2.next()) {
                    out.println("<li>" + rs2.getString(1) + " - " + rs2.getString(2) + "</li>");
                }
            }
            out.println("</ul>");
            
            out.println("<h3>Diagnostics</h3>");
            out.println("<p>Session Category: " + request.getSession().getAttribute("activeCategory") + "</p>");
            out.println("<p><a href='set-category?category=Work'>Set to Work and Go to Dashboard</a></p>");
            out.println("<p><a href='set-category?category=Personal'>Set to Personal and Go to Dashboard</a></p>");

        } catch (Exception e) {
            out.println("<p style='color:red;'>[ERROR] Migration failed: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        out.println("</body></html>");
    }
}
