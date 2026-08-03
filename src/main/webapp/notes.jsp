<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Personal Notes & Journal - TaskFlow</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .notes-layout {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 30px;
            height: calc(100vh - 120px);
            margin-top: 10px;
        }

        /* Sidebar */
        .notes-sidebar {
            background-color: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            padding: 20px;
            box-sizing: border-box;
            overflow: hidden;
        }

        .sidebar-header {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .notes-list {
            flex: 1;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 12px;
            padding-right: 5px;
        }

        .note-card-link {
            text-decoration: none;
            color: inherit;
        }

        .note-item {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 16px;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
        }

        .note-item:hover {
            border-color: var(--accent-color);
            background: rgba(41, 121, 255, 0.05);
            transform: translateY(-2px);
        }

        .note-item.active {
            border-color: var(--accent-color);
            background: rgba(41, 121, 255, 0.1);
        }

        .note-item h4 {
            margin: 0 0 8px 0;
            font-size: 1.1rem;
            color: var(--text-color);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            padding-right: 24px;
        }

        .note-item p {
            margin: 0 0 10px 0;
            font-size: 0.9rem;
            color: var(--secondary-text);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.4;
        }

        .note-meta {
            font-size: 0.75rem;
            color: var(--secondary-text);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .delete-note-btn {
            background: none;
            border: none;
            color: var(--danger-color);
            cursor: pointer;
            font-size: 0.95rem;
            padding: 4px;
            border-radius: 4px;
            transition: background 0.2s;
            position: absolute;
            top: 14px;
            right: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .delete-note-btn:hover {
            background: rgba(255, 82, 82, 0.1);
        }

        /* Editor Area */
        .notes-editor {
            background-color: var(--card-bg);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            padding: 30px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .editor-form {
            display: flex;
            flex-direction: column;
            height: 100%;
            gap: 20px;
        }

        .editor-title-input {
            background: transparent !important;
            border: none !important;
            border-bottom: 2px solid var(--border-color) !important;
            border-radius: 0 !important;
            font-size: 1.8rem !important;
            font-weight: bold !important;
            padding: 10px 0 !important;
            color: var(--text-color) !important;
        }

        .editor-title-input:focus {
            outline: none !important;
            border-bottom-color: var(--accent-color) !important;
        }

        .editor-content-textarea {
            flex: 1;
            background: transparent !important;
            border: none !important;
            resize: none !important;
            font-size: 1.05rem !important;
            line-height: 1.6 !important;
            padding: 10px 0 !important;
            color: var(--text-color) !important;
        }

        .editor-content-textarea:focus {
            outline: none !important;
        }

        .editor-footer {
            display: flex;
            justify-content: flex-end;
            border-top: 1px solid var(--border-color);
            padding-top: 20px;
        }

        .empty-editor-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: var(--secondary-text);
            gap: 15px;
            text-align: center;
        }

        .empty-editor-state h3 {
            margin: 0;
            color: var(--text-color);
            font-size: 1.4rem;
        }

        /* Search Input */
        .search-input-wrapper {
            position: relative;
            width: 100%;
        }

        .search-icon {
            position: absolute;
            left: 12px;
            color: var(--secondary-text);
            pointer-events: none;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
            top: 0;
            font-size: 0.9rem;
        }

        .search-bar {
            padding-left: 36px !important;
            width: 100% !important;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-brand">TaskFlow</div>
        <div class="nav-links">
            <span>Welcome, ${sessionScope.user.username}</span>
            <a href="dashboard">Tasks</a>
            <a href="notes" class="active">Notes</a>
            <a href="habits">Habits</a>
            <a href="select-category.jsp" style="color: var(--secondary-text);">Switch Category</a>
            <a href="logout">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="notes-layout">
            <!-- Sidebar list of notes -->
            <div class="notes-sidebar">
                <div class="sidebar-header">
                    <form action="notes" method="get" class="search-input-wrapper">
                        <span class="search-icon">🔍</span>
                        <input type="text" name="q" class="search-bar" placeholder="Search ${sessionScope.activeCategory} notes..." value="<c:out value='${query}'/>">
                        <button type="submit" style="display:none"></button>
                    </form>
                    <a href="notes" class="btn btn-primary" style="width: 100%; display: block; box-sizing: border-box; text-align: center;">+ New Note</a>
                </div>

                <div class="notes-list">
                    <c:forEach var="note" items="${notes}">
                        <div class="note-item <c:if test='${selectedNote != null && selectedNote.id == note.id}'>active</c:if>'">
                            <a href="notes?id=${note.id}<c:if test='${not empty query}'>&q=${query}</c:if>" class="note-card-link">
                                <h4><c:out value="${note.title}"/></h4>
                                <p><c:out value="${note.content}"/></p>
                                <div class="note-meta">
                                    <span>
                                        <c:out value="${note.updatedAt.toString().substring(0, 10)}"/>
                                    </span>
                                </div>
                            </a>
                            <!-- Delete Button -->
                            <a href="notes/delete?id=${note.id}" class="delete-note-btn" title="Delete Note" onclick="return confirm('Are you sure you want to delete this note?')">
                                🗑️
                            </a>
                        </div>
                    </c:forEach>
                    <c:if test="${empty notes}">
                        <div style="text-align: center; color: var(--secondary-text); padding: 40px 10px;">
                            No ${sessionScope.activeCategory} notes found.
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Note Editor Panel -->
            <div class="notes-editor">
                <c:choose>
                    <c:when test="${selectedNote != null || param.id == null}">
                        <form action="notes/save" method="post" class="editor-form">
                            <input type="hidden" name="id" value="${selectedNote != null ? selectedNote.id : ''}">
                            <input type="text" name="title" class="editor-title-input" placeholder="Title" required value="<c:out value='${selectedNote != null ? selectedNote.title : ""}'/>" maxlength="100">
                            <textarea name="content" class="editor-content-textarea" placeholder="Start writing your ${sessionScope.activeCategory.toLowerCase()} thoughts..." required><c:out value="${selectedNote != null ? selectedNote.content : ''}"/></textarea>
                            <div class="editor-footer">
                                <button type="submit" class="btn btn-primary">Save Note</button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-editor-state">
                            <span style="font-size: 3rem;">📝</span>
                            <h3>No Note Selected</h3>
                            <p>Select a ${sessionScope.activeCategory} note from the sidebar list, or click "+ New Note" to write down your thoughts.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
