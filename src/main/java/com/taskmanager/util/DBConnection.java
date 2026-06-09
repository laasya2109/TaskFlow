package com.taskmanager.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String HOST = System.getenv("MYSQLHOST") != null ? System.getenv("MYSQLHOST") : "localhost";
    private static final String PORT = System.getenv("MYSQLPORT") != null ? System.getenv("MYSQLPORT") : "3306";
    private static final String DATABASE = System.getenv("MYSQLDATABASE") != null ? System.getenv("MYSQLDATABASE") : "task_manager_db";
    
    private static final String URL = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE;
    private static final String USERNAME = System.getenv("MYSQLUSER") != null ? System.getenv("MYSQLUSER") : "root";
    private static final String PASSWORD = System.getenv("MYSQLPASSWORD") != null ? System.getenv("MYSQLPASSWORD") : "icecream";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
