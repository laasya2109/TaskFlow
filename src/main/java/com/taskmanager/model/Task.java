package com.taskmanager.model;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "tasks")
public class Task {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 20)
    private String status = "Pending";

    @Column(length = 50)
    private String category = "Personal";

    @Column(name = "due_date")
    private Timestamp dueDate;

    @Column(name = "user_id")
    private int userId;

    @Column(name = "has_time")
    private boolean hasTime;

    @Column(name = "reminder_sent")
    private Boolean reminderSent = false;

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
        this.reminderSent = false;
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

    public Boolean isReminderSent() { return reminderSent != null ? reminderSent : false; }
    public void setReminderSent(Boolean reminderSent) { this.reminderSent = reminderSent; }
}
