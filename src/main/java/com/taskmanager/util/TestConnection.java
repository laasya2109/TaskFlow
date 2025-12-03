package com.taskmanager.util;

import com.taskmanager.model.User;
import com.taskmanager.dao.UserDAO;
import java.sql.Connection;
import java.sql.SQLException;

public class TestConnection {
    public static void main(String[] args) {
        System.out.println("--- Starting Diagnostic Test ---");

        // 1. Test Connection
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("[SUCCESS] Database connection established!");
        } catch (Exception e) {
            System.out.println("[FAILED] Could not connect to database.");
            e.printStackTrace();
            return; // Stop if connection fails
        }

        // 2. Test User Retrieval
        System.out.println("Testing User Retrieval for 'admin'...");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.validateUser("admin", "admin123");

        if (user != null) {
            System.out.println("[SUCCESS] User 'admin' found! Login should work.");
        } else {
            System.out.println("[FAILED] User 'admin' with password 'admin123' NOT found.");
            System.out.println("Possible causes:");
            System.out.println(" - The 'users' table is empty (Run schema.sql).");
            System.out.println(" - The password in the DB is different.");
        }
        System.out.println("--- Test Finished ---");
    }
}
