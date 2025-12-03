<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Login - Task Manager</title>
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body>
        <div class="login-container">
            <div class="card login-card">
                <div class="login-header">
                    <h2>Task Manager</h2>
                    <p>Please login to continue</p>
                </div>

                <% if(request.getAttribute("error") !=null) { %>
                    <div style="color: var(--danger-color); text-align: center; margin-bottom: 1rem;">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                        <form action="login" method="post">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" id="username" name="username" required
                                    placeholder="Enter your username">
                            </div>
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" id="password" name="password" required
                                    placeholder="Enter your password">
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%">Login</button>
                        </form>

                        <div style="text-align: center; margin-top: 20px; color: var(--secondary-text);">
                            Don't have an account? <a href="register.jsp">Register here</a>
                        </div>
                        <div
                            style="text-align: center; margin-top: 1rem; font-size: 0.9rem; color: var(--secondary-text);">
                            <p>Demo: admin / admin123</p>
                        </div>
            </div>
        </div>
    </body>

    </html>