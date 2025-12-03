package com.taskmanager.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckUsers {
    public static void main(String[] args) {
        System.out.println("--- Checking Users in Database ---");

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT id, username, password, email FROM users")) {

            boolean found = false;
            while (rs.next()) {
                found = true;
                System.out.printf("User Found: ID=%d, Username='%s', Password='%s', Email='%s'%n",
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"));
            }

            if (!found) {
                System.out.println("[WARNING] No users found in the 'users' table!");
            }

        } catch (Exception e) {
            System.out.println("[FAILED] Could not query users table.");
            e.printStackTrace();
        }
        System.out.println("--- Check Finished ---");
    }
}
