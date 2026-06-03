package com.taskmanager.dao;

import com.taskmanager.model.Task;
import com.taskmanager.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {

    public void addTask(Task task) {
        String sql = "INSERT INTO tasks (title, description, status, category, due_date, user_id, has_time) VALUES (?, ?, ?, TRIM(?), ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, task.getTitle());
            pstmt.setString(2, task.getDescription());
            pstmt.setString(3, task.getStatus());
            pstmt.setString(4, task.getCategory());
            pstmt.setTimestamp(5, task.getDueDate());
            pstmt.setInt(6, task.getUserId());
            pstmt.setBoolean(7, task.getHasTime());

            pstmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException("Error adding task: " + e.getMessage(), e);
        }
    }

    public List<Task> getTasksByUserIdAndCategory(int userId, String category) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE user_id = ? AND TRIM(category) = ? ORDER BY due_date ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setString(2, category);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setId(rs.getInt("id"));
                    task.setTitle(rs.getString("title"));
                    task.setDescription(rs.getString("description"));
                    task.setStatus(rs.getString("status"));
                    task.setCategory(rs.getString("category"));
                    task.setDueDate(rs.getTimestamp("due_date"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setHasTime(rs.getBoolean("has_time"));
                    tasks.add(task);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    public Task getTaskById(int id) {
        Task task = null;
        String sql = "SELECT * FROM tasks WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    task = new Task();
                    task.setId(rs.getInt("id"));
                    task.setTitle(rs.getString("title"));
                    task.setDescription(rs.getString("description"));
                    task.setStatus(rs.getString("status"));
                    task.setCategory(rs.getString("category"));
                    task.setDueDate(rs.getTimestamp("due_date"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setHasTime(rs.getBoolean("has_time"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return task;
    }

    public void updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, description = ?, status = ?, category = TRIM(?), due_date = ?, has_time = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, task.getTitle());
            pstmt.setString(2, task.getDescription());
            pstmt.setString(3, task.getStatus());
            pstmt.setString(4, task.getCategory());
            pstmt.setTimestamp(5, task.getDueDate());
            pstmt.setBoolean(6, task.getHasTime());
            pstmt.setInt(7, task.getId());

            pstmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException("Error updating task: " + e.getMessage(), e);
        }
    }

    public void deleteTask(int id) {
        String sql = "DELETE FROM tasks WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void updateTaskStatus(int id, String status) {
        String sql = "UPDATE tasks SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            pstmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException("Error updating task status: " + e.getMessage(), e);
        }
    }


    public List<Task> searchTasks(int userId, String query, String category, String status) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM tasks WHERE user_id = ?");
        
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND title LIKE ?");
        }
        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All")) {
            sql.append(" AND category = ?");
        }
        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("All")) {
            sql.append(" AND status = ?");
        }
        
        sql.append(" ORDER BY due_date ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            pstmt.setInt(paramIndex++, userId);
            
            if (query != null && !query.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + query + "%");
            }
            if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All")) {
                pstmt.setString(paramIndex++, category);
            }
            if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("All")) {
                pstmt.setString(paramIndex++, status);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setId(rs.getInt("id"));
                    task.setTitle(rs.getString("title"));
                    task.setDescription(rs.getString("description"));
                    task.setStatus(rs.getString("status"));
                    task.setCategory(rs.getString("category"));
                    task.setDueDate(rs.getTimestamp("due_date"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setHasTime(rs.getBoolean("has_time"));
                    tasks.add(task);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return tasks;
    }
}
