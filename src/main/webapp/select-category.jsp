<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.taskmanager.dao.CategoryDAO" %>
<%@ page import="com.taskmanager.model.Category" %>
<%@ page import="com.taskmanager.model.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    CategoryDAO categoryDAO = new CategoryDAO();
    List<Category> categoriesList = categoryDAO.getCategoriesByUserId(currentUser.getId());
    pageContext.setAttribute("categoriesList", categoriesList);
%>
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
            flex-wrap: wrap;
            padding: 2rem;
            box-sizing: border-box;
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
            text-decoration: none;
            color: var(--text-color);
            box-sizing: border-box;
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

        .category-card.add-card {
            border: 2px dashed rgba(255, 255, 255, 0.15);
            background-color: transparent;
        }

        .category-card.add-card:hover {
            border-color: var(--accent-color);
            background-color: rgba(41, 121, 255, 0.05);
        }
        
        /* Modal styling */
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
            padding: 2.5rem;
            width: 400px;
            max-width: 90%;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.5);
            position: relative;
        }

        .modal-content h3 {
            margin-top: 0;
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            color: var(--text-color);
        }

        .modal-form-group {
            margin-bottom: 1.25rem;
            text-align: left;
        }

        .modal-form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--secondary-text);
            font-size: 0.9rem;
        }

        .modal-form-group input, .modal-form-group textarea {
            width: 100%;
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background-color: var(--input-bg);
            color: var(--text-color);
            box-sizing: border-box;
            font-size: 0.95rem;
            transition: border-color 0.2s;
        }

        .modal-form-group input:focus, .modal-form-group textarea:focus {
            border-color: var(--accent-color);
            outline: none;
        }

        .modal-actions {
            display: flex;
            gap: 12px;
            margin-top: 2rem;
        }

        .modal-btn {
            flex: 1;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            transition: opacity 0.2s;
        }

        .modal-btn.primary {
            background-color: var(--accent-color);
            color: #000;
        }

        .modal-btn.secondary {
            background-color: #333;
            color: #fff;
        }

        .modal-btn:hover {
            opacity: 0.9;
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
        <c:forEach var="cat" items="${categoriesList}">
            <a href="set-category?category=${cat.name}" class="category-card">
                <div class="icon"><c:out value="${cat.icon}"/></div>
                <h2><c:out value="${cat.name}"/></h2>
                <p><c:out value="${cat.description}"/></p>
            </a>
        </c:forEach>

        <!-- Add Category Card -->
        <div class="category-card add-card" onclick="openAddModal()">
            <div class="icon">➕</div>
            <h2>Add Custom</h2>
            <p>Create a custom workspace category.</p>
        </div>
    </div>

    <!-- Add Category Modal -->
    <div id="addCategoryModal" class="modal-overlay" onclick="closeAddModalOnOverlay(event)">
        <div class="modal-content">
            <h3>Add New Category</h3>
            <form action="add-category" method="post">
                <div class="modal-form-group">
                    <label for="catName">Category Name</label>
                    <input type="text" id="catName" name="name" placeholder="e.g., Studies, Fitness" required maxlength="20">
                </div>
                <div class="modal-form-group">
                    <label for="catDesc">Description</label>
                    <textarea id="catDesc" name="description" rows="3" placeholder="Brief description of this workspace" maxlength="100"></textarea>
                </div>
                <div class="modal-form-group">
                    <label for="catIcon">Icon/Emoji</label>
                    <input type="text" id="catIcon" name="icon" placeholder="e.g., 🎓, 💪, 🎨" maxlength="5">
                </div>
                <div class="modal-actions">
                    <button type="button" class="modal-btn secondary" onclick="closeAddModal()">Cancel</button>
                    <button type="submit" class="modal-btn primary">Create</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAddModal() {
            document.getElementById('addCategoryModal').style.display = 'flex';
        }
        function closeAddModal() {
            document.getElementById('addCategoryModal').style.display = 'none';
        }
        function closeAddModalOnOverlay(event) {
            if (event.target === document.getElementById('addCategoryModal')) {
                closeAddModal();
            }
        }
    </script>
</body>
</html>
