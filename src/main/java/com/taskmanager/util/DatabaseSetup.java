package com.taskmanager.util;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;

public class DatabaseSetup {
    public static void main(String[] args) {
        System.out.println("--- Initializing Database ---");

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement()) {

            // 1. Create Users Table
            String createUsers = "CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(50) NOT NULL UNIQUE, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "email VARCHAR(100))";
            stmt.executeUpdate(createUsers);
            System.out.println("[SUCCESS] Users table created.");

            // 2. Create Tasks Table
            String createTasks = "CREATE TABLE IF NOT EXISTS tasks (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "title VARCHAR(255) NOT NULL, " +
                    "description TEXT, " +
                    "status VARCHAR(20) DEFAULT 'Pending', " +
                    "due_date DATE, " +
                    "user_id INT, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)";
            stmt.executeUpdate(createTasks);
            System.out.println("[SUCCESS] Tasks table created.");

            // 3. Seed Admin User
            String seedUser = "INSERT IGNORE INTO users (username, password, email) " +
                    "VALUES ('admin', 'admin123', 'admin@example.com')";
            stmt.executeUpdate(seedUser);
            System.out.println("[SUCCESS] Admin user seeded.");

        } catch (Exception e) {
            System.out.println("[FAILED] Database setup failed.");
            e.printStackTrace();
        }
        System.out.println("--- Setup Finished ---");
    }
}
