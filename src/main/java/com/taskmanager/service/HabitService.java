package com.taskmanager.service;

import com.taskmanager.model.Habit;
import com.taskmanager.model.HabitLog;
import com.taskmanager.repository.HabitLogRepository;
import com.taskmanager.repository.HabitRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class HabitService {

    @Autowired
    private HabitRepository habitRepository;

    @Autowired
    private HabitLogRepository habitLogRepository;

    public List<Habit> getHabitsByUserId(int userId) {
        List<Habit> habits = habitRepository.findByUserId(userId);
        LocalDate today = LocalDate.now();
        LocalDate yesterday = today.minusDays(1);

        for (Habit habit : habits) {
            if (habit.getLastCompletedDate() != null) {
                LocalDate lastDate = habit.getLastCompletedDate().toLocalDate();
                if (!lastDate.isEqual(today) && !lastDate.isEqual(yesterday)) {
                    habit.setStreak(0);
                    habitRepository.save(habit);
                }
            }
        }
        return habits;
    }

    public Habit saveHabit(Habit habit) {
        return habitRepository.save(habit);
    }

    public void deleteHabit(int id) {
        habitRepository.deleteById(id);
    }

    @Transactional
    public Habit toggleHabitCompletion(int id, int userId) {
        Optional<Habit> optHabit = habitRepository.findById(id);
        if (!optHabit.isPresent()) {
            return null;
        }

        Habit habit = optHabit.get();
        if (habit.getUserId() != userId) {
            return null;
        }

        Date todaySql = Date.valueOf(LocalDate.now());
        Optional<HabitLog> optLog = habitLogRepository.findByHabitIdAndLogDate(id, todaySql);

        if (optLog.isPresent()) {
            habitLogRepository.deleteByHabitIdAndLogDate(id, todaySql);
            
            if (habit.getStreak() > 0) {
                habit.setStreak(habit.getStreak() - 1);
            }
            
            Date yesterdaySql = Date.valueOf(LocalDate.now().minusDays(1));
            Optional<HabitLog> yesterdayLog = habitLogRepository.findByHabitIdAndLogDate(id, yesterdaySql);
            if (yesterdayLog.isPresent()) {
                habit.setLastCompletedDate(yesterdaySql);
            } else {
                habit.setLastCompletedDate(null);
            }
        } else {
            HabitLog log = new HabitLog(0, id, todaySql);
            habitLogRepository.save(log);

            LocalDate today = LocalDate.now();
            LocalDate yesterday = today.minusDays(1);
            if (habit.getLastCompletedDate() != null) {
                LocalDate lastDate = habit.getLastCompletedDate().toLocalDate();
                if (lastDate.isEqual(yesterday)) {
                    habit.setStreak(habit.getStreak() + 1);
                } else if (lastDate.isEqual(today)) {
                    // Do nothing
                } else {
                    habit.setStreak(1);
                }
            } else {
                habit.setStreak(1);
            }
            habit.setLastCompletedDate(todaySql);
        }

        return habitRepository.save(habit);
    }
    
    public boolean isCompletedToday(Habit habit) {
        if (habit.getLastCompletedDate() == null) {
            return false;
        }
        return habit.getLastCompletedDate().toLocalDate().isEqual(LocalDate.now());
    }
}
