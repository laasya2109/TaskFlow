package com.taskmanager.model;

import java.sql.Timestamp;

public class Task {
    private int id;
    private String title;
    private String description;
    private String status;
    private String category;
    private Timestamp dueDate;
    private int userId;
    private boolean hasTime;

    public Task() {}

    public Task(int id, String title, String description, String status, String category, Timestamp dueDate, int userId, boolean hasTime) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.status = status;
        this.category = category;
        this.dueDate = dueDate;
        this.userId = userId;
        this.hasTime = hasTime;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Timestamp getDueDate() { return dueDate; }
    public void setDueDate(Timestamp dueDate) { this.dueDate = dueDate; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public boolean getHasTime() { return hasTime; }
    public void setHasTime(boolean hasTime) { this.hasTime = hasTime; }
}
