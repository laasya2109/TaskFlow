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
                    <a href="select-category.jsp" style="color: var(--secondary-text);">Switch Category</a>
                    <a href="logout">Logout</a>
                </div>
            </nav>

            <div class="container">
                <div class="dashboard-layout">
                    <!-- Main Content: Tasks -->
                    <div class="main-content">
                        <div class="dashboard-header">
                            <h1>My ${sessionScope.activeCategory} Tasks</h1>
                            <a href="new" class="btn btn-primary">+ Add New Task</a>
                        </div>

                        <div class="search-filter-bar">
                            <form action="dashboard" method="get" style="display: contents;">
                                <input type="text" name="q" class="search-input" placeholder="Search tasks..." value="${param.q}">
                                <select name="status" class="filter-select" onchange="this.form.submit()">
                                    <option value="All" ${param.status == 'All' ? 'selected' : ''}>All Status</option>
                                    <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="Completed" ${param.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                </select>
                                <button type="submit" style="display:none"></button>
                            </form>
                        </div>

                        <div class="task-grid">
                            <c:forEach var="task" items="${listTasks}">
                                <div class="task-card">
                                    <div data-has-time="${task.hasTime}" style="display:none"></div>
                                    <c:choose>
                                        <c:when test="${task.status == 'Completed'}">
                                            <span class="task-status status-completed">Completed</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span id="task-status-${task.id}" class="task-status status-pending" data-due-date="${task.dueDate}">
                                                ${task.status}
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="category-badge">
                                        <c:out value="${task.category}" />
                                    </div>
                                    <h3>
                                        <c:out value="${task.title}" />
                                    </h3>
                                    <p style="color: var(--secondary-text); margin-bottom: 1rem;">
                                        <c:out value="${task.description}" />
                                    </p>
                                    <div style="font-size: 0.9rem; color: var(--secondary-text); margin-bottom: 1rem;">
                                        Due:
                                        <c:out value="${task.dueDate.toString().substring(0, 10)}" />
                                        <c:if test="${task.hasTime}">
                                            <span> @ <c:out value="${task.dueDate.toString().substring(11, 16)}" /></span>
                                        </c:if>
                                    </div>
                                    <div class="task-actions">
                                        <a href="edit?id=<c:out value='${task.id}' />" class="btn btn-sm"
                                            style="background: #333; color: white;">Edit</a>
                                        <a href="delete?id=<c:out value='${task.id}' />" class="btn btn-sm btn-danger"
                                            onclick="return confirm('Are you sure?')">Delete</a>
                                    </div> <!-- End task-actions -->
                                </div> <!-- End task-card -->
                            </c:forEach>
                        </div> <!-- End task-grid -->

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
                                <div><span class="dot overdue"></span> Overdue</div>
                                <div><span class="dot remaining"></span> Remaining</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                (function() {
                    const tasks = [
                        <c:forEach items="${listTasks}" var="task" varStatus="status">
                            {
                                date: "${task.dueDate}",
                                status: "${task.status}",
                                hasTime: ${task.hasTime}
                            }${status.last ? '' : ','}
                        </c:forEach>
                    ];

                    let currentDate = new Date();

                    function renderCalendar() {
                        const monthYear = document.getElementById('monthYear');
                        const calendarGrid = document.getElementById('calendarGrid');

                        // Handle overdue status for cards and calendar
                        const today = new Date();
                        const todayStr = today.getFullYear() + "-" + 
                                         String(today.getMonth() + 1).padStart(2, '0') + "-" + 
                                         String(today.getDate()).padStart(2, '0');

                        document.querySelectorAll('.task-status.status-pending').forEach(el => {
                            const dueDate = el.getAttribute('data-due-date');
                            if (dueDate && dueDate < todayStr) {
                                el.className = "task-status status-overdue";
                                el.innerText = "Overdue";
                            }
                        });

                        const year = currentDate.getFullYear();
                        const month = currentDate.getMonth();

                        const firstDay = new Date(year, month, 1);
                        const lastDay = new Date(year, month + 1, 0);
                        const daysInMonth = lastDay.getDate();
                        const startingDay = firstDay.getDay();

                        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

                        monthYear.textContent = monthNames[month] + " " + year;
                        calendarGrid.innerHTML = "";

                        // Headers
                        ["S", "M", "T", "W", "T", "F", "S"].forEach(day => {
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

                        for (let i = 1; i <= daysInMonth; i++) {
                            const div = document.createElement('div');
                            div.className = 'cal-day';
                            div.textContent = i;

                            if (year === today.getFullYear() && month === today.getMonth() && i === today.getDate()) {
                                div.classList.add('today');
                            }

                            const dateStr = year + "-" + String(month + 1).padStart(2, '0') + "-" + String(i).padStart(2, '0');
                            const dayTasks = tasks.filter(t => t.date === dateStr);

                            if (dayTasks.length > 0) {
                                if (dayTasks.some(t => t.status !== 'Completed')) {
                                    if (dateStr < todayStr) {
                                        div.classList.add('overdue');
                                    } else {
                                        div.classList.add('pending');
                                    }
                                } else {
                                    div.classList.add('completed');
                                }
                            } else {
                                div.classList.add('empty');
                            }

                            calendarGrid.appendChild(div);
                        }
                    }

                    window.changeMonth = function(delta) {
                        currentDate.setMonth(currentDate.getMonth() + delta);
                        renderCalendar();
                    };

                    renderCalendar();

                    // Live "Auto-Overdue" Tracker (Runs every 30 seconds)
                    setInterval(() => {
                        const now = new Date();
                        const todayStr = now.getFullYear() + "-" + 
                                         String(now.getMonth() + 1).padStart(2, '0') + "-" + 
                                         String(now.getDate()).padStart(2, '0');
                        
                        const nowTimeStr = todayStr + " " +
                                         String(now.getHours()).padStart(2, '0') + ":" +
                                         String(now.getMinutes()).padStart(2, '0');

                        document.querySelectorAll('.task-status.status-pending').forEach(el => {
                            const dueDate = el.getAttribute('data-due-date'); 
                            if (dueDate) {
                                const hasTimeAttr = el.closest('.task-card').querySelector('[data-has-time]');
                                const hasTime = (hasTimeAttr && hasTimeAttr.getAttribute('data-has-time') === 'true');
                                
                                if (hasTime) {
                                    const dueTimeStr = dueDate.substring(0, 16).replace('T', ' ');
                                    if (dueTimeStr < nowTimeStr) {
                                        el.className = "task-status status-overdue";
                                        el.innerText = "Overdue";
                                    }
                                } else {
                                    const dueDateOnly = dueDate.substring(0, 10);
                                    if (dueDateOnly < todayStr) {
                                        el.className = "task-status status-overdue";
                                        el.innerText = "Overdue";
                                    }
                                }
                            }
                        });
                    }, 30000);
                })();
            </script>
        </body>

        </html>