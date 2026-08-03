package com.taskmanager.service;

import com.taskmanager.model.Task;
import com.taskmanager.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    public List<Task> getTasksByUserId(int userId) {
        return taskRepository.findByUserId(userId);
    }

    public List<Task> getTasksByUserIdAndCategory(int userId, String category) {
        if (category == null || category.equalsIgnoreCase("All")) {
            return getTasksByUserId(userId);
        }
        return taskRepository.findByUserIdAndCategory(userId, category);
    }

    public Optional<Task> getTaskById(int id) {
        return taskRepository.findById(id);
    }

    public Task saveTask(Task task) {
        return taskRepository.save(task);
    }

    public void deleteTask(int id) {
        taskRepository.deleteById(id);
    }

    public Task toggleTaskStatus(int id) {
        Optional<Task> optionalTask = taskRepository.findById(id);
        if (optionalTask.isPresent()) {
            Task task = optionalTask.get();
            String newStatus = "Completed".equalsIgnoreCase(task.getStatus()) ? "Pending" : "Completed";
            task.setStatus(newStatus);
            return taskRepository.save(task);
        }
        return null;
    }
}
