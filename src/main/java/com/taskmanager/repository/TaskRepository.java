package com.taskmanager.repository;

import com.taskmanager.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.sql.Timestamp;
import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Integer> {
    List<Task> findByUserId(int userId);
    List<Task> findByUserIdAndCategory(int userId, String category);
    List<Task> findByUserIdAndStatus(int userId, String status);
    List<Task> findByDueDateBetweenAndReminderSentFalseAndStatusNot(Timestamp start, Timestamp end, String status);
    List<Task> findByUserIdAndReminderSentTrueAndStatusNot(int userId, String status);
}
