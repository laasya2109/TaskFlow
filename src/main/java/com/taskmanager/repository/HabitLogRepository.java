package com.taskmanager.repository;

import com.taskmanager.model.HabitLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

@Repository
public interface HabitLogRepository extends JpaRepository<HabitLog, Integer> {
    List<HabitLog> findByHabitId(int habitId);
    Optional<HabitLog> findByHabitIdAndLogDate(int habitId, Date logDate);
    void deleteByHabitIdAndLogDate(int habitId, Date logDate);
}
