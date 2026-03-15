<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>${task != null ? 'Edit Task' : 'New Task'} - Task Manager</title>
            <link rel="stylesheet" href="css/style.css">
        </head>

        <body>
            <nav class="navbar">
                <div class="nav-brand">TaskFlow</div>
                <div class="nav-links">
                    <a href="dashboard">Back to Dashboard</a>
                    <a href="logout">Logout</a>
                </div>
            </nav>

            <div class="container">
                <div style="max-width: 600px; margin: 2rem auto;">
                    <div class="card">
                        <h2 style="margin-top: 0; margin-bottom: 1.5rem;">
                            ${task != null ? 'Edit Task' : 'Add New Task'}
                        </h2>

                        <c:if test="${task != null}">
                            <form action="update" method="post">
                                <input type="hidden" name="id" value="<c:out value='${task.id}' />" />
                        </c:if>
                        <c:if test="${task == null}">
                            <form action="insert" method="post">
                        </c:if>

                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" id="title" name="title" value="<c:out value='${task.title}' />" required>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="4"
                                required><c:out value='${task.description}' /></textarea>
                        </div>

                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status">
                                <option value="Pending" ${task.status=='Pending' ? 'selected' : '' }>Pending</option>
                                <option value="Completed" ${task.status=='Completed' ? 'selected' : '' }>Completed
                                </option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="dueDate">Due Date</label>
                            <input type="date" id="dueDate" name="dueDate" value="<c:out value='${task.dueDate}' />"
                                required>
                        </div>

                        <div style="display: flex; gap: 10px; margin-top: 2rem;">
                            <button type="submit" class="btn btn-primary" style="flex: 1">Save Task</button>
                            <a href="dashboard" class="btn"
                                style="background: #333; color: white; flex: 1; text-decoration: none; display: flex; align-items: center; justify-content: center;">Cancel</a>
                        </div>

                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>