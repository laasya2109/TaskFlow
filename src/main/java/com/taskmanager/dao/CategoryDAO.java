package com.taskmanager.dao;

import com.taskmanager.model.Category;
import com.taskmanager.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public CategoryDAO() {
        checkAndCreateTable();
    }

    private void checkAndCreateTable() {
        String sql = "CREATE TABLE IF NOT EXISTS categories (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY, " +
                     "name VARCHAR(50) NOT NULL, " +
                     "description VARCHAR(255), " +
                     "icon VARCHAR(10) DEFAULT '📋', " +
                     "user_id INT, " +
                     "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, " +
                     "UNIQUE KEY unique_user_category (user_id, name))";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
            System.out.println("[SUCCESS] Categories table checked/created.");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public List<Category> getCategoriesByUserId(int userId) {
        List<Category> list = new ArrayList<>();
        // Default categories that always exist
        list.add(new Category(0, "Work", "Manage your professional duties and projects.", "💼", userId));
        list.add(new Category(0, "Personal", "Organize your daily life and personal tasks.", "🏠", userId));

        String sql = "SELECT * FROM categories WHERE user_id = ? ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString("name");
                    if (name.equalsIgnoreCase("Work") || name.equalsIgnoreCase("Personal")) {
                        continue;
                    }
                    Category cat = new Category(
                        rs.getInt("id"),
                        name,
                        rs.getString("description"),
                        rs.getString("icon"),
                        rs.getInt("user_id")
                    );
                    list.add(cat);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (name, description, icon, user_id) VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE description = ?, icon = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setString(3, category.getIcon());
            pstmt.setInt(4, category.getUserId());
            pstmt.setString(5, category.getDescription());
            pstmt.setString(6, category.getIcon());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
}
