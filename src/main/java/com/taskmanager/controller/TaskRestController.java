package com.taskmanager.controller;

import com.taskmanager.model.Task;
import com.taskmanager.model.User;
import com.taskmanager.service.AiPlannerService;
import com.taskmanager.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/tasks")
public class TaskRestController {

    @Autowired
    private TaskService taskService;

    @Autowired
    private AiPlannerService aiPlannerService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Task>> getTasksByUser(@PathVariable int userId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        if (user.getId() != userId) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        return ResponseEntity.ok(taskService.getTasksByUserId(userId));
    }

    @PostMapping
    public ResponseEntity<Task> createTask(@RequestBody Task task) {
        return ResponseEntity.ok(taskService.saveTask(task));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable int id) {
        taskService.deleteTask(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/ai/breakdown")
    public ResponseEntity<List<Task>> breakdownGoal(@RequestParam("goal") String goal,
                                                     @RequestParam(value = "stepsCount", defaultValue = "4") int stepsCount,
                                                     HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        int userId = user.getId();
        String category = (String) session.getAttribute("activeCategory");
        if (category == null || category.trim().isEmpty()) {
            category = "Personal";
        }

        List<Task> generatedTasks = aiPlannerService.generateTaskBreakdown(goal, stepsCount, userId, category);
        return ResponseEntity.ok(generatedTasks);
    }

    @PostMapping("/ai/saveTasks")
    public ResponseEntity<List<Task>> batchSaveTasks(@RequestBody List<Task> tasks, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        String category = (String) session.getAttribute("activeCategory");
        if (category == null || category.trim().isEmpty()) {
            category = "Personal";
        }

        List<Task> savedTasks = new ArrayList<>();
        for (Task t : tasks) {
            t.setUserId(user.getId());
            if (t.getCategory() == null || t.getCategory().trim().isEmpty()) {
                t.setCategory(category);
            }
            if (t.getStatus() == null) {
                t.setStatus("Pending");
            }
            savedTasks.add(taskService.saveTask(t));
        }
        return ResponseEntity.ok(savedTasks);
    }
}
