<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Dashboard - Task Manager</title>
            <link rel="stylesheet" href="css/style.css">
        </head>

        <body>
            <nav class="navbar">
                <div class="nav-brand">TaskFlow</div>
                <div class="nav-links">
                    <span>Welcome, ${sessionScope.user.username}</span>
                    <a href="dashboard" class="active">Dashboard</a>
                    <a href="logout">Logout</a>
                </div>
            </nav>

            <div class="container">
                <div class="dashboard-layout">
                    <!-- Main Content: Tasks -->
                    <div class="main-content">
                        <div class="dashboard-header">
                            <h1>My Tasks</h1>
                            <a href="new" class="btn btn-primary">+ Add New Task</a>
                        </div>

                        <div class="task-grid">
                            <c:forEach var="task" items="${listTasks}">
                                <div class="task-card">
                                    <span
                                        class="task-status ${task.status == 'Completed' ? 'status-completed' : 'status-pending'}">
                                        ${task.status}
                                    </span>
                                    <h3>
                                        <c:out value="${task.title}" />
                                    </h3>
                                    <p style="color: var(--secondary-text); margin-bottom: 1rem;">
                                        <c:out value="${task.description}" />
                                    </p>
                                    <div style="font-size: 0.9rem; color: var(--secondary-text); margin-bottom: 1rem;">
                                        Due:
                                        <c:out value="${task.dueDate}" />
                                    </div>
                                    <div class="task-actions">
                                        <a href="edit?id=<c:out value='${task.id}' />" class="btn btn-sm"
                                            style="background: #333; color: white;">Edit</a>
                                        <a href="delete?id=<c:out value='${task.id}' />" class="btn btn-sm btn-danger"
                                            onclick="return confirm('Are you sure?')">Delete</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <c:if test="${empty listTasks}">
                            <div style="text-align: center; padding: 4rem; color: var(--secondary-text);">
                                <h3>No tasks found</h3>
                                <p>Get started by creating a new task!</p>
                            </div>
                        </c:if>
                    </div>

                    <!-- Sidebar: Calendar -->
                    <div class="sidebar">
                        <div class="card calendar-widget">
                            <div class="calendar-header">
                                <button class="btn-icon" onclick="changeMonth(-1)">&lt;</button>
                                <h3 id="monthYear" style="margin:0"></h3>
                                <button class="btn-icon" onclick="changeMonth(1)">&gt;</button>
                            </div>
                            <div class="calendar-grid-mini" id="calendarGrid"></div>
                            <div class="calendar-legend">
                                <div><span class="dot pending"></span> Pending</div>
                                <div><span class="dot completed"></span> Completed</div>
                                <div><span class="dot remaining"></span> Remaining</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                const tasks = [
                    <c:forEach items="${listTasks}" var="task">
                        {
                            date: "${task.dueDate}",
                        status: "${task.status}"
                },
                    </c:forEach>
                ];

                let currentDate = new Date();

                function renderCalendar() {
                    const monthYear = document.getElementById('monthYear');
                    const calendarGrid = document.getElementById('calendarGrid');

                    const year = currentDate.getFullYear();
                    const month = currentDate.getMonth();

                    const firstDay = new Date(year, month, 1);
                    const lastDay = new Date(year, month + 1, 0);
                    const daysInMonth = lastDay.getDate();
                    const startingDay = firstDay.getDay();

                    const monthNames = ["January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December"
                    ];

                    monthYear.textContent = monthNames[month] + " " + year;
                    calendarGrid.innerHTML = "";

                    // Headers
                    const days = ["S", "M", "T", "W", "T", "F", "S"];
                    days.forEach(day => {
                        const div = document.createElement('div');
                        div.className = 'cal-header';
                        div.textContent = day;
                        calendarGrid.appendChild(div);
                    });

                    // Empty slots
                    for (let i = 0; i < startingDay; i++) {
                        calendarGrid.appendChild(document.createElement('div'));
                    }

                    // Days
                    const today = new Date();
                    for (let i = 1; i <= daysInMonth; i++) {
                        const div = document.createElement('div');
                        div.className = 'cal-day';
                        div.textContent = i;

                        if (year === today.getFullYear() && month === today.getMonth() && i === today.getDate()) {
                            div.classList.add('today');
                        }

                        // Check tasks
                        const dateStr = year + "-" + String(month + 1).padStart(2, '0') + "-" + String(i).padStart(2, '0');
                        const dayTasks = tasks.filter(t => t.date === dateStr);

                        if (dayTasks.length > 0) {
                            // If any pending, show pending color (Yellow)
                            if (dayTasks.some(t => t.status !== 'Completed')) {
                                div.classList.add('pending');
                                div.title = "Pending Tasks";
                            } else {
                                // All completed (Green)
                                div.classList.add('completed');
                                div.title = "All Completed";
                            }
                        } else {
                            // No tasks (White)
                            div.classList.add('empty');
                        }

                        calendarGrid.appendChild(div);
                    }
                }

                function changeMonth(delta) {
                    currentDate.setMonth(currentDate.getMonth() + delta);
                    renderCalendar();
                }

                renderCalendar();
            </script>
        </body>

        </html>