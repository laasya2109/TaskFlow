package com.taskmanager.repository;

import com.taskmanager.model.Habit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HabitRepository extends JpaRepository<Habit, Integer> {
    List<Habit> findByUserId(int userId);
}
