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
                    <a href="dashboard" class="active">Tasks</a>
                    <a href="notes">Notes</a>
                    <a href="habits">Habits</a>
                    <a href="select-category.jsp" style="color: var(--secondary-text);">Switch Category</a>
                    <a href="logout">Logout</a>
                </div>
            </nav>

            <div class="container">
                <div class="dashboard-layout">
                    <!-- Main Content: Tasks -->
                    <div class="main-content">
                        <c:if test="${not empty upcomingDueTasks}">
                            <c:forEach var="dueTask" items="${upcomingDueTasks}">
                                <div style="background: linear-gradient(135deg, rgba(255, 152, 0, 0.2), rgba(255, 87, 34, 0.3)); border: 1px solid #ff9800; border-radius: 8px; padding: 14px 20px; margin-bottom: 20px; color: #ffeb3b; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);">
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <span style="font-size: 1.5rem;">⏰</span>
                                        <div>
                                            <strong>1-Hour Task Reminder:</strong> Task <b>"<c:out value="${dueTask.title}" />"</b> is due in less than 1 hour (at <c:out value="${dueTask.dueDate.toString().substring(11, 16)}" />)!
                                        </div>
                                    </div>
                                    <span style="background: #ff9800; color: #000; font-weight: bold; padding: 4px 10px; border-radius: 20px; font-size: 0.85rem;">Due Soon</span>
                                </div>
                            </c:forEach>
                        </c:if>

                        <div class="dashboard-header">
                            <h1>My ${sessionScope.activeCategory} Tasks</h1>
                            <div style="display: flex; gap: 10px; align-items: center;">
                                <button class="btn" onclick="openAiPlannerModal()" style="background: linear-gradient(135deg, #7c4dff, #2979ff); color: white; border: none; font-weight: 600; box-shadow: 0 4px 15px rgba(124, 77, 255, 0.35); display: flex; align-items: center; gap: 6px; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s;">
                                    ✨ AI Auto-Plan Goal
                                </button>
                                <a href="new" class="btn btn-primary">+ Add New Task</a>
                            </div>
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

            <!-- AI Auto-Planner Modal Overlay -->
            <div id="aiPlannerModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); backdrop-filter: blur(12px); z-index: 2100; justify-content: center; align-items: center; transition: opacity 0.3s ease; opacity: 0;">
                <div class="modal-content" style="background: linear-gradient(145deg, rgba(25, 30, 45, 0.95), rgba(15, 18, 28, 0.98)); border: 1px solid rgba(124, 77, 255, 0.3); border-radius: 20px; padding: 2rem; width: 560px; max-width: 92%; box-shadow: 0 25px 50px rgba(0,0,0,0.6), 0 0 30px rgba(124, 77, 255, 0.15); position: relative; color: #ffffff;">
                    <button class="modal-close-btn" onclick="closeAiPlannerModal()" style="position: absolute; top: 1.2rem; right: 1.2rem; background: transparent; border: none; font-size: 1.5rem; color: #8a8d9b; cursor: pointer; transition: color 0.2s;">&times;</button>
                    
                    <h2 style="margin-top: 0; margin-bottom: 0.5rem; display: flex; align-items: center; gap: 10px; font-size: 1.4rem;">
                        ✨ AI Task Breakdown & Auto-Planner
                    </h2>
                    <p style="color: #a0a5b5; font-size: 0.88rem; margin-top: 0; margin-bottom: 1.5rem; line-height: 1.4;">
                        Enter any goal or project, and AI will automatically break it down into scheduled, actionable step-by-step tasks.
                    </p>

                    <!-- Initial State: Prompt Input -->
                    <div id="aiPlannerInitialState">
                        <div style="margin-bottom: 1.2rem;">
                            <label style="display: block; font-size: 0.85rem; font-weight: 600; color: #d0d5e5; margin-bottom: 6px;">Your High-Level Goal or Project</label>
                            <input type="text" id="aiGoalInput" placeholder="e.g. Prepare for Java Tech Interview, Build Web App, Plan Trip..." 
                                   style="width: 100%; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.12); border-radius: 10px; padding: 12px 14px; color: #fff; font-size: 0.95rem; outline: none; box-sizing: border-box;">
                        </div>

                        <!-- Sample Prompt Chips -->
                        <div style="margin-bottom: 1.5rem;">
                            <div style="font-size: 0.78rem; color: #8a8d9b; margin-bottom: 8px; font-weight: 500;">Or pick a sample prompt:</div>
                            <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                                <button type="button" onclick="selectPromptChip('Prepare for Java Technical Interview')" style="background: rgba(124, 77, 255, 0.12); border: 1px solid rgba(124, 77, 255, 0.3); color: #b388ff; padding: 5px 12px; border-radius: 16px; font-size: 0.8rem; cursor: pointer; transition: all 0.2s;">☕ Java Interview Prep</button>
                                <button type="button" onclick="selectPromptChip('Build & Deploy Fullstack Web App')" style="background: rgba(41, 121, 255, 0.12); border: 1px solid rgba(41, 121, 255, 0.3); color: #82b1ff; padding: 5px 12px; border-radius: 16px; font-size: 0.8rem; cursor: pointer; transition: all 0.2s;">💻 Build Web App</button>
                                <button type="button" onclick="selectPromptChip('Plan Weekend Getaway Trip')" style="background: rgba(0, 230, 118, 0.12); border: 1px solid rgba(0, 230, 118, 0.3); color: #69f0ae; padding: 5px 12px; border-radius: 16px; font-size: 0.8rem; cursor: pointer; transition: all 0.2s;">✈️ Plan Trip</button>
                                <button type="button" onclick="selectPromptChip('Train & Prepare for 5K Marathon')" style="background: rgba(255, 152, 0, 0.12); border: 1px solid rgba(255, 152, 0, 0.3); color: #ffd180; padding: 5px 12px; border-radius: 16px; font-size: 0.8rem; cursor: pointer; transition: all 0.2s;">🏃 5K Fitness Plan</button>
                            </div>
                        </div>

                        <!-- Steps Count Selector -->
                        <div style="margin-bottom: 1.8rem; display: flex; align-items: center; justify-content: space-between;">
                            <span style="font-size: 0.85rem; color: #d0d5e5; font-weight: 500;">Number of Steps:</span>
                            <div style="display: flex; gap: 8px;">
                                <button type="button" class="step-count-btn" onclick="setStepCount(3, this)" style="background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: #a0a5b5; padding: 5px 12px; border-radius: 8px; cursor: pointer; font-size: 0.85rem; font-weight: 600;">3 Steps</button>
                                <button type="button" class="step-count-btn" onclick="setStepCount(4, this)" style="background: linear-gradient(135deg, #7c4dff, #2979ff); border: 1px solid #7c4dff; color: #ffffff; padding: 5px 12px; border-radius: 8px; cursor: pointer; font-size: 0.85rem; font-weight: 600;">4 Steps</button>
                                <button type="button" class="step-count-btn" onclick="setStepCount(5, this)" style="background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: #a0a5b5; padding: 5px 12px; border-radius: 8px; cursor: pointer; font-size: 0.85rem; font-weight: 600;">5 Steps</button>
                            </div>
                        </div>

                        <button type="button" onclick="generateAiPlan()" style="width: 100%; background: linear-gradient(135deg, #7c4dff, #2979ff); color: white; border: none; padding: 13px; border-radius: 12px; font-weight: 700; font-size: 1rem; cursor: pointer; box-shadow: 0 6px 20px rgba(124, 77, 255, 0.4); transition: transform 0.15s, box-shadow 0.15s;">
                            ⚡ Generate AI Task Breakdown
                        </button>
                    </div>

                    <!-- Loading State -->
                    <div id="aiLoadingState" style="display: none; flex-direction: column; align-items: center; justify-content: center; padding: 2rem 0; text-align: center;">
                        <div style="width: 48px; height: 48px; border: 4px solid rgba(124, 77, 255, 0.2); border-top-color: #7c4dff; border-radius: 50%; animation: spinAiLoader 1s linear infinite; margin-bottom: 1.2rem;"></div>
                        <style>
                            @keyframes spinAiLoader { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
                        </style>
                        <h4 style="margin: 0 0 6px 0; color: #fff; font-size: 1.1rem;">AI Analyzing & Decomposing Goal...</h4>
                        <p style="margin: 0; color: #8a8d9b; font-size: 0.85rem;">Structuring step-by-step milestones & scheduling target due dates.</p>
                    </div>

                    <!-- Results Preview State -->
                    <div id="aiResultsPreviewState" style="display: none;">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem;">
                            <span style="font-size: 0.9rem; font-weight: 600; color: #b388ff;">Generated Action Plan:</span>
                            <span style="font-size: 0.78rem; color: #8a8d9b;">Uncheck steps you don't need</span>
                        </div>

                        <div id="aiTasksContainer" style="max-height: 280px; overflow-y: auto; display: flex; flex-direction: column; gap: 10px; padding-right: 4px; margin-bottom: 1.5rem;">
                            <!-- Dynamic tasks preview populated here -->
                        </div>

                        <div style="display: flex; gap: 12px;">
                            <button type="button" onclick="resetAiPlannerModal()" style="flex: 1; background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); color: #d0d5e5; padding: 11px; border-radius: 10px; font-weight: 600; cursor: pointer;">
                                Back / Edit
                            </button>
                            <button type="button" id="btnImportAiTasks" onclick="importAiTasks()" style="flex: 2; background: linear-gradient(135deg, #00e676, #00b0ff); color: #000; border: none; padding: 11px; border-radius: 10px; font-weight: 700; cursor: pointer; box-shadow: 0 6px 20px rgba(0, 230, 118, 0.3);">
                                ✨ Import All Tasks to Dashboard
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                (function() {
                    let generatedAiTasksList = [];
                    let selectedStepCount = 4;

                    window.openAiPlannerModal = function() {
                        const modal = document.getElementById('aiPlannerModal');
                        if (!modal) return;
                        modal.style.display = 'flex';
                        setTimeout(() => { modal.style.opacity = '1'; }, 10);
                        resetAiPlannerModal();
                    };

                    window.closeAiPlannerModal = function() {
                        const modal = document.getElementById('aiPlannerModal');
                        if (!modal) return;
                        modal.style.opacity = '0';
                        setTimeout(() => { modal.style.display = 'none'; }, 300);
                    };

                    window.resetAiPlannerModal = function() {
                        document.getElementById('aiGoalInput').value = '';
                        document.getElementById('aiPlannerInitialState').style.display = 'block';
                        document.getElementById('aiLoadingState').style.display = 'none';
                        document.getElementById('aiResultsPreviewState').style.display = 'none';
                        generatedAiTasksList = [];
                    };

                    window.selectPromptChip = function(text) {
                        document.getElementById('aiGoalInput').value = text;
                    };

                    window.setStepCount = function(count, btn) {
                        selectedStepCount = count;
                        document.querySelectorAll('.step-count-btn').forEach(b => {
                            b.style.background = 'rgba(255,255,255,0.05)';
                            b.style.color = '#a0a5b5';
                            b.style.borderColor = 'rgba(255,255,255,0.1)';
                        });
                        btn.style.background = 'linear-gradient(135deg, #7c4dff, #2979ff)';
                        btn.style.color = '#ffffff';
                        btn.style.borderColor = '#7c4dff';
                    };

                    window.generateAiPlan = function() {
                        const goal = document.getElementById('aiGoalInput').value.trim();
                        if (!goal) {
                            alert('Please enter a goal or select a sample prompt!');
                            return;
                        }

                        document.getElementById('aiPlannerInitialState').style.display = 'none';
                        document.getElementById('aiLoadingState').style.display = 'flex';
                        document.getElementById('aiResultsPreviewState').style.display = 'none';

                        fetch('${pageContext.request.contextPath}/api/tasks/ai/breakdown?goal=' + encodeURIComponent(goal) + '&stepsCount=' + selectedStepCount, {
                            method: 'POST'
                        })
                        .then(res => res.json())
                        .then(tasks => {
                            generatedAiTasksList = tasks;
                            renderAiTasksPreview(tasks);
                            document.getElementById('aiLoadingState').style.display = 'none';
                            document.getElementById('aiResultsPreviewState').style.display = 'block';
                        })
                        .catch(err => {
                            console.error("AI Generation error:", err);
                            alert("Failed to generate AI plan. Please try again.");
                            resetAiPlannerModal();
                        });
                    };

                    function renderAiTasksPreview(tasks) {
                        const container = document.getElementById('aiTasksContainer');
                        container.innerHTML = '';

                        tasks.forEach((task, idx) => {
                            const item = document.createElement('div');
                            item.style.cssText = 'background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 10px; padding: 12px 16px; display: flex; align-items: flex-start; gap: 12px;';
                            
                            const dateStr = task.dueDate ? String(task.dueDate).substring(0, 10) : '';

                            item.innerHTML = `
                                <input type="checkbox" id="ai-task-chk-` + idx + `" checked style="width: 18px; height: 18px; margin-top: 3px; cursor: pointer; accent-color: #7c4dff;">
                                <div style="flex: 1;">
                                    <div style="font-weight: 600; font-size: 0.95rem; color: #fff; margin-bottom: 4px;">` + escapeHtml(task.title) + `</div>
                                    <div style="font-size: 0.82rem; color: var(--secondary-text); margin-bottom: 6px;">` + escapeHtml(task.description) + `</div>
                                    <div style="font-size: 0.75rem; color: #b388ff; font-weight: 500;">📅 Target Due: ` + dateStr + `</div>
                                </div>
                            `;
                            container.appendChild(item);
                        });
                    }

                    function escapeHtml(text) {
                        if (!text) return '';
                        return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
                    }

                    window.importAiTasks = function() {
                        const selectedTasks = [];
                        generatedAiTasksList.forEach((task, idx) => {
                            const chk = document.getElementById('ai-task-chk-' + idx);
                            if (chk && chk.checked) {
                                selectedTasks.push(task);
                            }
                        });

                        if (selectedTasks.length === 0) {
                            alert("Please select at least one task to import!");
                            return;
                        }

                        const btn = document.getElementById('btnImportAiTasks');
                        btn.disabled = true;
                        btn.innerText = 'Importing Tasks...';

                        fetch('${pageContext.request.contextPath}/api/tasks/ai/saveTasks', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(selectedTasks)
                        })
                        .then(res => {
                            if (res.ok) {
                                window.location.reload();
                            } else {
                                alert("Failed to save tasks.");
                                btn.disabled = false;
                                btn.innerText = '✨ Import Selected Tasks';
                            }
                        })
                        .catch(err => {
                            console.error("Save tasks error:", err);
                            alert("Error saving tasks.");
                            btn.disabled = false;
                            btn.innerText = '✨ Import Selected Tasks';
                        });
                    };

                    const modal = document.getElementById('aiPlannerModal');
                    if (modal) {
                        modal.addEventListener('click', function(e) {
                            if (e.target === this) {
                                closeAiPlannerModal();
                            }
                        });
                    }
                })();
            </script>
        </body>

        </html>