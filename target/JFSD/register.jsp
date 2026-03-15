<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Register - Task Manager</title>
            <link rel="stylesheet" href="css/style.css">
        </head>

        <body>
            <div class="login-container">
                <div class="card login-card">
                    <div class="login-header">
                        <h2>Create Account</h2>
                        <p style="color: var(--secondary-text);">Join TaskFlow today</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div
                            style="background-color: rgba(255, 82, 82, 0.1); color: var(--danger-color); padding: 10px; border-radius: 4px; margin-bottom: 20px; text-align: center;">
                            <c:out value="${error}" />
                        </div>
                    </c:if>

                    <form action="register" method="post">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" required>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%;">Register</button>
                    </form>

                    <div style="text-align: center; margin-top: 20px; color: var(--secondary-text);">
                        Already have an account? <a href="login.jsp">Login here</a>
                    </div>
                </div>
            </div>
        </body>

        </html>