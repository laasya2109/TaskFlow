<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Dashboard - Task Manager</title>
            <link rel="stylesheet" href="css/style.css">
            <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

                        <form action="dashboard" method="get" class="search-filter-bar" onsubmit="event.preventDefault();">
                            <div class="search-input-wrapper" style="position: relative; flex: 1;">
                                <span style="position: absolute; left: 12px; color: var(--secondary-text); pointer-events: none; display: flex; align-items: center; justify-content: center; height: 100%; top: 0; font-size: 0.9rem;">🔍</span>
                                <input type="text" name="q" class="search-input" placeholder="Search tasks..." value="${param.q}" oninput="filterTasks()" style="padding-left: 36px !important; width: 100% !important;">
                            </div>
                            <select name="status" class="filter-select" onchange="filterTasks()">
                                <option value="All" ${param.status == 'All' ? 'selected' : ''}>All Status</option>
                                <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                <option value="Completed" ${param.status == 'Completed' ? 'selected' : ''}>Completed</option>
                            </select>
                            <button type="submit" style="display:none"></button>
                        </form>

                        <div class="task-grid">
                            <c:forEach var="task" items="${listTasks}">
                                <div class="task-card" data-id="${task.id}">
                                    <div data-has-time="${task.hasTime}" style="display:none"></div>
                                    <c:choose>
                                        <c:when test="${task.status == 'Completed'}">
                                            <span class="task-status status-completed" data-due-date="${task.dueDate}">Completed</span>
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
                                    <div style="display: flex; align-items: center; gap: 10px; margin-top: 5px; margin-bottom: 12px;">
                                        <input type="checkbox" 
                                               ${task.status == 'Completed' ? 'checked' : ''} 
                                               onchange="toggleTaskStatus(${task.id}, this.checked)"
                                               style="width: 18px; height: 18px; cursor: pointer; accent-color: var(--accent-color); margin: 0;">
                                        <h3 style="margin: 0; ${task.status == 'Completed' ? 'text-decoration: line-through; color: var(--secondary-text);' : ''}">
                                            <c:out value="${task.title}" />
                                        </h3>
                                    </div>
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
                        <!-- Progress Ring Widget -->
                        <div class="card progress-widget" style="margin-bottom: 20px; text-align: center; padding: 1.5rem;">
                            <h3 style="margin-top: 0; margin-bottom: 1rem; font-size: 1.1rem; color: var(--text-color);">Category Progress</h3>
                            <div class="progress-ring-container" style="position: relative; display: inline-block; width: 120px; height: 120px; margin: 0 auto;">
                                <svg width="120" height="120" style="transform: rotate(-90deg);">
                                    <circle cx="60" cy="60" r="50" stroke="rgba(255, 255, 255, 0.05)" stroke-width="8" fill="transparent" />
                                    <circle id="progressCircle" cx="60" cy="60" r="50" stroke="var(--accent-color)" stroke-width="8" fill="transparent"
                                            stroke-dasharray="314.16" stroke-dashoffset="314.16" stroke-linecap="round"
                                            style="transition: stroke-dashoffset 0.3s ease-in-out;" />
                                </svg>
                                <div id="progressText" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 1.2rem; font-weight: bold; color: var(--text-color);">0%</div>
                            </div>
                            <div id="progressSubtitle" style="font-size: 0.85rem; color: var(--secondary-text); margin-top: 0.8rem;">0 of 0 tasks completed</div>
                            <button class="btn btn-sm" onclick="openAnalyticsModal()" 
                                    onmouseover="this.style.background='rgba(255,255,255,0.08)';" 
                                    onmouseout="this.style.background='rgba(255,255,255,0.02)';"
                                    style="margin-top: 1rem; width: 100%; border: 1px solid rgba(255,255,255,0.08); background: rgba(255,255,255,0.02); color: var(--text-color); border-radius: 8px; padding: 0.6rem; cursor: pointer; font-size: 0.85rem; transition: background 0.2s, transform 0.1s; display: flex; align-items: center; justify-content: center; gap: 6px;">
                                📊 View Analytics
                            </button>
                        </div>

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
                                id: ${task.id},
                                date: "${task.dueDate}",
                                status: "${task.status}",
                                hasTime: ${task.hasTime},
                                category: "${task.category}"
                            }${status.last ? '' : ','}
                        </c:forEach>
                    ];

                    let currentDate = new Date();

                    function updateOverdueStatuses() {
                        const now = new Date();
                        const todayStr = now.getFullYear() + "-" + 
                                         String(now.getMonth() + 1).padStart(2, '0') + "-" + 
                                         String(now.getDate()).padStart(2, '0');
                        
                        const nowTimeStr = todayStr + " " +
                                         String(now.getHours()).padStart(2, '0') + ":" +
                                         String(now.getMinutes()).padStart(2, '0');

                        document.querySelectorAll('.task-status').forEach(el => {
                            if (el.classList.contains('status-completed')) return;
                            
                             const dueDate = el.getAttribute('data-due-date');
                             if (dueDate && dueDate !== 'null' && dueDate.trim() !== '') {
                                const card = el.closest('.task-card');
                                const hasTimeAttr = card ? card.querySelector('[data-has-time]') : null;
                                const hasTime = (hasTimeAttr && hasTimeAttr.getAttribute('data-has-time') === 'true');
                                
                                let isOverdue = false;
                                if (hasTime) {
                                    const dueTimeStr = dueDate.substring(0, 16).replace('T', ' ');
                                    isOverdue = (dueTimeStr < nowTimeStr);
                                } else {
                                    const dueDateOnly = dueDate.substring(0, 10);
                                    isOverdue = (dueDateOnly < todayStr);
                                }
                                
                                if (isOverdue) {
                                    el.className = "task-status status-overdue";
                                    el.innerText = "Overdue";
                                } else {
                                    el.className = "task-status status-pending";
                                    el.innerText = "Pending";
                                }
                            }
                        });
                    }

                    function playSuccessSound() {
                        try {
                            const AudioContext = window.AudioContext || window.webkitAudioContext;
                            if (!AudioContext) return;
                            const ctx = new AudioContext();
                            
                            const osc1 = ctx.createOscillator();
                            const gain1 = ctx.createGain();
                            osc1.type = 'sine';
                            osc1.frequency.setValueAtTime(659.25, ctx.currentTime);
                            gain1.gain.setValueAtTime(0.08, ctx.currentTime);
                            gain1.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.3);
                            osc1.connect(gain1);
                            gain1.connect(ctx.destination);
                            
                            const osc2 = ctx.createOscillator();
                            const gain2 = ctx.createGain();
                            osc2.type = 'sine';
                            osc2.frequency.setValueAtTime(880.00, ctx.currentTime + 0.08);
                            gain2.gain.setValueAtTime(0.08, ctx.currentTime + 0.08);
                            gain2.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.4);
                            osc2.connect(gain2);
                            gain2.connect(ctx.destination);
                            
                            osc1.start();
                            osc1.stop(ctx.currentTime + 0.3);
                            
                            osc2.start(ctx.currentTime + 0.08);
                            osc2.stop(ctx.currentTime + 0.4);
                        } catch (e) {
                            console.error("AudioContext failed:", e);
                        }
                    }

                    function triggerConfetti() {
                        if (typeof confetti === 'function') {
                            confetti({
                                particleCount: 100,
                                spread: 70,
                                origin: { y: 0.8 },
                                colors: ['#2979ff', '#00e676', '#ffc107', '#ff5252', '#9c27b0']
                            });
                        }
                    }

                    function renderCalendar() {
                        const monthYear = document.getElementById('monthYear');
                        const calendarGrid = document.getElementById('calendarGrid');

                        updateOverdueStatuses();

                        const today = new Date();
                        const todayStr = today.getFullYear() + "-" + 
                                         String(today.getMonth() + 1).padStart(2, '0') + "-" + 
                                         String(today.getDate()).padStart(2, '0');

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
                             const dayTasks = tasks.filter(t => t.date.substring(0, 10) === dateStr);

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

                    window.toggleTaskStatus = function(taskId, isChecked) {
                        const status = isChecked ? 'Completed' : 'Pending';
                        
                        const card = document.querySelector('.task-card[data-id="' + taskId + '"]');
                        if (card) {
                            const statusEl = card.querySelector('.task-status');
                            const titleEl = card.querySelector('h3');
                            
                            if (isChecked) {
                                if (statusEl) {
                                    statusEl.className = 'task-status status-completed';
                                    statusEl.textContent = 'Completed';
                                }
                                if (titleEl) {
                                    titleEl.style.textDecoration = 'line-through';
                                    titleEl.style.color = 'var(--secondary-text)';
                                }
                                playSuccessSound();
                                triggerConfetti();
                            } else {
                                if (statusEl) {
                                    statusEl.className = 'task-status status-pending';
                                    statusEl.textContent = 'Pending';
                                }
                                if (titleEl) {
                                    titleEl.style.textDecoration = 'none';
                                    titleEl.style.color = '';
                                }
                                updateOverdueStatuses();
                            }
                        }
                        
                        const taskObj = tasks.find(t => t.id === taskId);
                        if (taskObj) {
                            taskObj.status = status;
                        }
                        
                        fetch('toggleStatus?id=' + taskId + '&status=' + status)
                            .then(() => {
                                window.filterTasks();
                                renderCalendar();
                            })
                            .catch(err => {
                                console.error('Error toggling status: ', err);
                            });
                    };

                    window.updateProgressRing = function(completedCount, totalCount) {
                        const circle = document.getElementById('progressCircle');
                        const text = document.getElementById('progressText');
                        const subtitle = document.getElementById('progressSubtitle');
                        
                        if (!circle || !text || !subtitle) return;
                        
                        const percentage = totalCount > 0 ? Math.round((completedCount / totalCount) * 100) : 0;
                        const circumference = 314.16;
                        const offset = circumference - (percentage / 100) * circumference;
                        
                        circle.style.strokeDashoffset = offset;
                        text.textContent = percentage + '%';
                        subtitle.textContent = completedCount + ' of ' + totalCount + ' tasks completed';
                    };

                    window.filterTasks = function() {
                        const searchInput = document.querySelector('.search-input');
                        const filterSelect = document.querySelector('.filter-select');
                        
                        if (!searchInput || !filterSelect) return;
                        
                        const query = searchInput.value.toLowerCase().trim();
                        const status = filterSelect.value;
                        
                        let visibleCount = 0;
                        let completedCount = 0;
                        let totalCount = 0;

                        const cards = document.querySelectorAll('.task-card');
                        cards.forEach(card => {
                            const titleEl = card.querySelector('h3');
                            const descEl = card.querySelector('p');
                            const statusEl = card.querySelector('.task-status');

                            const title = titleEl ? titleEl.textContent.toLowerCase() : '';
                            const desc = descEl ? descEl.textContent.toLowerCase() : '';
                            
                            let cardStatus = "Pending";
                            if (statusEl) {
                                if (statusEl.classList.contains('status-completed')) {
                                    cardStatus = "Completed";
                                } else if (statusEl.classList.contains('status-overdue')) {
                                    cardStatus = "Overdue";
                                }
                            }

                            const matchesQuery = title.includes(query) || desc.includes(query);
                            let matchesStatus = false;
                            if (status === 'All') {
                                matchesStatus = true;
                            } else if (status === 'Completed') {
                                matchesStatus = (cardStatus === 'Completed');
                            } else if (status === 'Pending') {
                                matchesStatus = (cardStatus === 'Pending' || cardStatus === 'Overdue');
                            }

                            if (matchesQuery && matchesStatus) {
                                card.style.display = 'block';
                                visibleCount++;
                            } else {
                                card.style.display = 'none';
                            }

                            totalCount++;
                            if (cardStatus === 'Completed') {
                                completedCount++;
                            }
                        });

                        let noTasksEl = document.getElementById('no-tasks-search-message');
                        if (visibleCount === 0 && totalCount > 0) {
                            if (!noTasksEl) {
                                noTasksEl = document.createElement('div');
                                noTasksEl.id = 'no-tasks-search-message';
                                noTasksEl.style.textAlign = 'center';
                                noTasksEl.style.padding = '4rem';
                                noTasksEl.style.color = 'var(--secondary-text)';
                                noTasksEl.innerHTML = '<h3>No matching tasks found</h3><p>Try refining your search or status filter.</p>';
                                document.querySelector('.task-grid').after(noTasksEl);
                            }
                        } else {
                            if (noTasksEl) {
                                noTasksEl.remove();
                            }
                        }

                        window.updateProgressRing(completedCount, totalCount);
                    };

                    renderCalendar();
                    window.filterTasks();

                    // Live "Auto-Overdue" Tracker (Runs every 30 seconds)
                    setInterval(() => {
                        updateOverdueStatuses();
                        window.filterTasks();
                    }, 30000);

                    let analyticsChartInstance = null;

                    window.openAnalyticsModal = function() {
                        const modal = document.getElementById('analyticsModal');
                        if (!modal) return;
                        
                        modal.style.display = 'flex';
                        modal.style.opacity = '0';
                        setTimeout(() => { modal.style.opacity = '1'; }, 10);
                        
                        let completed = 0;
                        let pending = 0;
                        let overdue = 0;
                        
                        document.querySelectorAll('.task-card').forEach(card => {
                            const statusEl = card.querySelector('.task-status');
                            if (statusEl) {
                                if (statusEl.classList.contains('status-completed')) {
                                    completed++;
                                } else if (statusEl.classList.contains('status-overdue')) {
                                    overdue++;
                                } else {
                                    pending++;
                                }
                            }
                        });
                        
                        const total = completed + pending + overdue;
                        const rate = total > 0 ? Math.round((completed / total) * 100) : 0;
                        
                        document.getElementById('statsCompletionRate').textContent = rate + '%';
                        document.getElementById('statsOverdueCount').textContent = overdue;
                        
                        const ctx = document.getElementById('analyticsChart').getContext('2d');
                        if (analyticsChartInstance) {
                            analyticsChartInstance.destroy();
                        }
                        
                        analyticsChartInstance = new Chart(ctx, {
                            type: 'doughnut',
                            data: {
                                labels: ['Completed', 'Pending', 'Overdue'],
                                datasets: [{
                                    data: [completed, pending, overdue],
                                    backgroundColor: ['#00e676', '#ffc107', '#ff5252'],
                                    borderColor: 'rgba(30, 30, 30, 0.8)',
                                    borderWidth: 2
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        position: 'bottom',
                                        labels: {
                                            color: '#fff',
                                            font: {
                                                family: 'Inter, system-ui, sans-serif',
                                                size: 11
                                            },
                                            padding: 15
                                        }
                                    }
                                },
                                cutout: '70%'
                            }
                        });
                    };

                    window.closeAnalyticsModal = function() {
                        const modal = document.getElementById('analyticsModal');
                        if (!modal) return;
                        modal.style.opacity = '0';
                        setTimeout(() => { modal.style.display = 'none'; }, 300);
                    };

                    // Close modal when clicking outside content
                    const modal = document.getElementById('analyticsModal');
                    if (modal) {
                        modal.addEventListener('click', function(e) {
                            if (e.target === this) {
                                closeAnalyticsModal();
                            }
                        });
                    }

                })();
            </script>

            <!-- Analytics Modal Overlay -->
            <div id="analyticsModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.65); backdrop-filter: blur(10px); z-index: 2000; justify-content: center; align-items: center; transition: opacity 0.3s ease;">
                <div class="modal-content analytics-modal" style="background: rgba(30, 30, 30, 0.75); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 2rem; width: 500px; max-width: 90%; box-shadow: 0 20px 40px rgba(0,0,0,0.5); backdrop-filter: blur(20px); position: relative; color: var(--text-color);">
                    <button class="modal-close-btn" onclick="closeAnalyticsModal()" style="position: absolute; top: 1.2rem; right: 1.2rem; background: transparent; border: none; font-size: 1.5rem; color: var(--secondary-text); cursor: pointer; transition: color 0.2s;">&times;</button>
                    <h2 style="margin-top: 0; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px;">📊 Task Analytics</h2>
                    
                    <div class="charts-container" style="display: flex; flex-direction: column; gap: 1.5rem;">
                        <!-- Chart Container -->
                        <div style="background: rgba(255,255,255,0.02); border-radius: 12px; padding: 1rem; border: 1px solid rgba(255,255,255,0.05); height: 260px; position: relative;">
                            <canvas id="analyticsChart"></canvas>
                        </div>
                        
                        <!-- Mini Stats Grid -->
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div style="background: rgba(255,255,255,0.02); border-radius: 8px; padding: 0.8rem; border: 1px solid rgba(255,255,255,0.05); text-align: center;">
                                <div style="font-size: 0.8rem; color: var(--secondary-text);">Completion Rate</div>
                                <div id="statsCompletionRate" style="font-size: 1.3rem; font-weight: bold; margin-top: 5px; color: var(--accent-color);">0%</div>
                            </div>
                            <div style="background: rgba(255,255,255,0.02); border-radius: 8px; padding: 0.8rem; border: 1px solid rgba(255,255,255,0.05); text-align: center;">
                                <div style="font-size: 0.8rem; color: var(--secondary-text);">Overdue Tasks</div>
                                <div id="statsOverdueCount" style="font-size: 1.3rem; font-weight: bold; margin-top: 5px; color: var(--danger-color);">0</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>

        </html>