<%@ page import="java.sql.*, com.taskmanager.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>DB Debug</title></head>
<body>
<h2>Raw Tasks Table Content</h2>
<table border="1">
    <tr>
        <th>ID</th><th>Title</th><th>Category</th><th>Status</th><th>User ID</th>
    </tr>
    <%
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM tasks")) {
            while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getString("status") %></td>
        <td><%= rs.getInt("user_id") %></td>
    </tr>
    <%
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>
</table>
</body>
</html>
