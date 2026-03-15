<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select Category - Task Manager</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .category-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            gap: 40px;
        }

        .category-card {
            background-color: var(--card-bg);
            border-radius: 12px;
            padding: 3rem;
            text-align: center;
            width: 250px;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none; /* remove link underline */
            color: var(--text-color);
        }

        .category-card:hover {
            border-color: var(--accent-color);
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(41, 121, 255, 0.2);
        }

        .category-card h2 {
            margin: 0;
            font-size: 2rem;
            color: var(--accent-color);
        }

        .category-card p {
            color: var(--secondary-text);
            margin-top: 1rem;
        }
        
        .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">TaskFlow</div>
        <div class="nav-links">
            <span>Welcome, ${sessionScope.user.username}</span>
            <a href="logout">Logout</a>
        </div>
    </nav>

    <div class="container category-container">
        <!-- Work Category -->
        <a href="set-category?category=Work" class="category-card">
            <div class="icon">💼</div>
            <h2>Work</h2>
            <p>Manage your professional duties and projects.</p>
        </a>

        <!-- Personal Category -->
        <a href="set-category?category=Personal" class="category-card">
            <div class="icon">🏠</div>
            <h2>Personal</h2>
            <p>Organize your daily life and personal tasks.</p>
        </a>
    </div>
</body>
</html>
