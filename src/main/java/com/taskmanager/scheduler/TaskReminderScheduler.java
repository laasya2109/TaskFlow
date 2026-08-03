package com.taskmanager.scheduler;

import com.taskmanager.model.Task;
import com.taskmanager.model.User;
import com.taskmanager.repository.TaskRepository;
import com.taskmanager.repository.UserRepository;
import com.taskmanager.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

@Component
public class TaskReminderScheduler {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EmailService emailService;

    // Checks background tasks automatically every 60 seconds (1 minute)
    @Scheduled(fixedRate = 60000)
    public void checkAndSendTaskReminders() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        // 1 Hour in future (60 mins * 60 secs * 1000 ms)
        Timestamp oneHourLater = new Timestamp(System.currentTimeMillis() + (60 * 60 * 1000));

        List<Task> upcomingTasks = taskRepository.findByDueDateBetweenAndReminderSentFalseAndStatusNot(
                now, oneHourLater, "Completed");

        for (Task task : upcomingTasks) {
            Optional<User> userOpt = userRepository.findById(task.getUserId());
            User user = userOpt.orElse(null);

            emailService.sendTaskReminderEmail(user, task);

            task.setReminderSent(true);
            taskRepository.save(task);
        }
    }
}
