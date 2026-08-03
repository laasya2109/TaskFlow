package com.taskmanager.model;

import javax.persistence.*;
import java.sql.Date;

@Entity
@Table(name = "habits")
public class Habit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String name;

    @Column
    private String description;

    @Column(length = 10)
    private String icon = "📋";

    @Column
    private int streak = 0;

    @Column(name = "last_completed_date")
    private Date lastCompletedDate;

    @Column(name = "user_id")
    private int userId;

    public Habit() {}

    public Habit(int id, String name, String description, String icon, int streak, Date lastCompletedDate, int userId) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.icon = icon;
        this.streak = streak;
        this.lastCompletedDate = lastCompletedDate;
        this.userId = userId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public int getStreak() { return streak; }
    public void setStreak(int streak) { this.streak = streak; }

    public Date getLastCompletedDate() { return lastCompletedDate; }
    public void setLastCompletedDate(Date lastCompletedDate) { this.lastCompletedDate = lastCompletedDate; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
}
