package com.taskmanager.model;

import javax.persistence.*;
import java.sql.Date;

@Entity
@Table(name = "habit_logs")
public class HabitLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "habit_id")
    private int habitId;

    @Column(name = "log_date")
    private Date logDate;

    public HabitLog() {}

    public HabitLog(int id, int habitId, Date logDate) {
        this.id = id;
        this.habitId = habitId;
        this.logDate = logDate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getHabitId() { return habitId; }
    public void setHabitId(int habitId) { this.habitId = habitId; }

    public Date getLogDate() { return logDate; }
    public void setLogDate(Date logDate) { this.logDate = logDate; }
}
