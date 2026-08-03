<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Habit Tracker - TaskFlow</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background-color: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            padding: 24px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
            transition: transform 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
        }

        .stat-card h3 {
            margin: 0;
            color: var(--secondary-text);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-card .value {
            font-size: 2.2rem;
            font-weight: bold;
            margin-top: 10px;
            color: var(--accent-color);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .habits-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .habit-card {
            background-color: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            padding: 24px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
        }

        .habit-card:hover {
            border-color: var(--accent-color);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(41, 121, 255, 0.15);
        }

        .habit-card.completed {
            border-color: #00e676;
            background: linear-gradient(135deg, var(--card-bg), rgba(0, 230, 118, 0.03));
        }

        .habit-icon {
            font-size: 2.5rem;
            margin-bottom: 12px;
        }

        .habit-info h3 {
            margin: 0 0 6px 0;
            font-size: 1.25rem;
            color: var(--text-color);
        }

        .habit-info p {
            margin: 0 0 15px 0;
            font-size: 0.9rem;
            color: var(--secondary-text);
            line-height: 1.4;
            min-height: 40px;
        }

        .streak-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 152, 0, 0.1);
            color: #ff9800;
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            margin-bottom: 15px;
            align-self: flex-start;
        }

        .habit-card.completed .streak-badge {
            background: rgba(0, 230, 118, 0.1);
            color: #00e676;
        }

        .habit-actions {
            margin-top: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .toggle-btn {
            flex: 1;
            padding: 10px 14px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            border: 2px solid transparent;
            text-align: center;
            transition: all 0.2s;
            font-size: 0.9rem;
        }

        .toggle-btn.not-completed {
            background: transparent;
            border-color: var(--accent-color);
            color: var(--accent-color);
        }

        .toggle-btn.not-completed:hover {
            background: rgba(41, 121, 255, 0.1);
        }

        .toggle-btn.is-completed {
            background: #00e676;
            color: #000;
        }

        .toggle-btn.is-completed:hover {
            opacity: 0.9;
        }

        .delete-habit-btn {
            background: transparent;
            border: none;
            color: var(--danger-color);
            cursor: pointer;
            font-size: 1.1rem;
            padding: 8px;
            border-radius: 8px;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .delete-habit-btn:hover {
            background: rgba(255, 82, 82, 0.1);
        }

        /* Dash Card to Add */
        .add-habit-card {
            border: 2px dashed rgba(255, 255, 255, 0.15);
            background-color: transparent;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            text-align: center;
            box-shadow: none;
        }

        .add-habit-card:hover {
            border-color: var(--accent-color);
            background: rgba(41, 121, 255, 0.02);
            color: var(--accent-color);
        }

        .add-habit-card span {
            font-size: 3rem;
            margin-bottom: 10px;
        }

        /* Modal Overlay */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(8px);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            background-color: var(--card-bg);
            border-radius: 16px;
            border: 1px solid var(--border-color);
            padding: 30px;
            width: 400px;
            max-width: 90%;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.5);
            position: relative;
        }

        .modal-content h3 {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 1.4rem;
            color: var(--text-color);
        }

        .modal-actions {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">TaskFlow</div>
        <div class="nav-links">
            <span>Welcome, ${sessionScope.user.username}</span>
            <a href="dashboard">Tasks</a>
            <a href="notes">Notes</a>
            <a href="habits" class="active">Habits</a>
            <a href="select-category.jsp" style="color: var(--secondary-text);">Switch Category</a>
            <a href="logout">Logout</a>
        </div>
    </nav>

    <div class="container">
        <!-- Stats Row -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Tracked Habits</h3>
                <div class="value">📈 <c:out value="${totalHabits}"/></div>
            </div>
            <div class="stat-card">
                <h3>Completed Today</h3>
                <div class="value">✅ <c:out value="${completedToday}"/></div>
            </div>
            <div class="stat-card">
                <h3>Completion Rate</h3>
                <div class="value">🎯 <c:out value="${completionRate}"/>%</div>
            </div>
            <div class="stat-card">
                <h3>Longest Streak</h3>
                <div class="value">🔥 <c:out value="${longestStreak}"/> <span style="font-size: 1.2rem; color: var(--secondary-text);">days</span></div>
            </div>
        </div>

        <!-- Habits Grid -->
        <div class="habits-grid">
            <c:forEach var="habit" items="${habits}">
                <c:set var="isCompleted" value="${habitService.isCompletedToday(habit)}"/>
                <div class="habit-card <c:if test='${isCompleted}'>completed</c:if>">
                    <div>
                        <div class="habit-icon"><c:out value="${habit.icon}"/></div>
                        <div class="habit-info">
                            <h3><c:out value="${habit.name}"/></h3>
                            <p><c:out value="${habit.description}"/></p>
                        </div>
                    </div>
                    <div>
                        <div class="streak-badge">
                            🔥 <c:out value="${habit.streak}"/> day streak
                        </div>
                        <div class="habit-actions">
                            <c:choose>
                                <c:when test="${isCompleted}">
                                    <a href="habits/toggle?id=${habit.id}" class="toggle-btn is-completed">
                                        ✓ Completed
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="habits/toggle?id=${habit.id}" class="toggle-btn not-completed">
                                        Mark Done
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            <a href="habits/delete?id=${habit.id}" class="delete-habit-btn" title="Delete Habit" onclick="return confirm('Are you sure you want to delete this habit?')">
                                🗑️
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <!-- Card to trigger Add modal -->
            <div class="habit-card add-habit-card" onclick="openAddModal()">
                <span>➕</span>
                <h3>Add Custom Habit</h3>
                <p style="min-height: auto; margin-bottom: 0;">Build new daily streaks</p>
            </div>
        </div>
    </div>

    <!-- Add Habit Modal Overlay -->
    <div id="addHabitModal" class="modal-overlay" onclick="closeAddModalOnOverlay(event)">
        <div class="modal-content">
            <h3>Track New Habit</h3>
            <form action="habits/add" method="post">
                <div class="form-group">
                    <label for="habitName">Habit Name</label>
                    <input type="text" id="habitName" name="name" placeholder="e.g., Drink Water, Read Book" required maxlength="50">
                </div>
                <div class="form-group">
                    <label for="habitDesc">Description</label>
                    <input type="text" id="habitDesc" name="description" placeholder="e.g., 3 Liters daily, 10 pages before sleep" maxlength="150">
                </div>
                <div class="form-group">
                    <label for="habitIcon">Icon/Emoji</label>
                    <input type="text" id="habitIcon" name="icon" placeholder="e.g., 💧, 📚, 🏃, 🧘" maxlength="5">
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn" style="background: #333; color: white; flex: 1;" onclick="closeAddModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="flex: 1;">Start Tracking</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddModal() {
            document.getElementById('addHabitModal').style.display = 'flex';
        }
        function closeAddModal() {
            document.getElementById('addHabitModal').style.display = 'none';
        }
        function closeAddModalOnOverlay(event) {
            if (event.target === document.getElementById('addHabitModal')) {
                closeAddModal();
            }
        }
    </script>
</body>
</html>
