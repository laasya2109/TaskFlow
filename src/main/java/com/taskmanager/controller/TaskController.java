package com.taskmanager.controller;

import com.taskmanager.model.Task;
import com.taskmanager.model.User;
import com.taskmanager.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;
import com.taskmanager.repository.TaskRepository;

@Controller
public class TaskController {

    @Autowired
    private TaskService taskService;

    @Autowired
    private TaskRepository taskRepository;

    @GetMapping({"/", "/dashboard"})
    public String listTasks(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        String category = (String) session.getAttribute("activeCategory");
        if (category == null || category.trim().isEmpty()) {
            return "redirect:/select-category.jsp";
        }

        List<Task> listTasks = taskService.getTasksByUserIdAndCategory(user.getId(), category);
        model.addAttribute("listTasks", listTasks);

        Timestamp now = new Timestamp(System.currentTimeMillis());
        Timestamp oneHourLater = new Timestamp(System.currentTimeMillis() + (60 * 60 * 1000));
        List<Task> upcomingDueTasks = taskRepository.findByDueDateBetweenAndReminderSentFalseAndStatusNot(now, oneHourLater, "Completed");
        model.addAttribute("upcomingDueTasks", upcomingDueTasks);

        return "dashboard";
    }

    @GetMapping("/new")
    public String showNewForm(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }
        return "task-form";
    }

    @GetMapping("/edit")
    public String showEditForm(@RequestParam int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        Optional<Task> taskOptional = taskService.getTaskById(id);
        if (taskOptional.isPresent()) {
            model.addAttribute("task", taskOptional.get());
            return "task-form";
        }
        return "redirect:/dashboard";
    }

    @PostMapping("/insert")
    public String insertTask(@RequestParam String title,
                             @RequestParam(required = false) String description,
                             @RequestParam(required = false, defaultValue = "Pending") String status,
                             @RequestParam(required = false) String dueDate,
                             @RequestParam(required = false) String dueTime,
                             HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        String category = (String) session.getAttribute("activeCategory");
        if (category == null || category.trim().isEmpty()) {
            category = "Personal";
        }

        boolean hasTime = (dueTime != null && !dueTime.trim().isEmpty());
        String rawDateStr = (dueDate != null && !dueDate.trim().isEmpty()) ? dueDate : "2026-01-01";
        String timestampStr = rawDateStr + " " + (hasTime ? dueTime : "00:00") + ":00";

        Timestamp parsedDueDate;
        try {
            parsedDueDate = Timestamp.valueOf(timestampStr);
        } catch (Exception e) {
            parsedDueDate = new Timestamp(System.currentTimeMillis());
            hasTime = false;
        }

        Task newTask = new Task(0, title, description, status, category, parsedDueDate, user.getId(), hasTime);
        taskService.saveTask(newTask);
        return "redirect:/dashboard";
    }

    @PostMapping("/update")
    public String updateTask(@RequestParam int id,
                             @RequestParam String title,
                             @RequestParam(required = false) String description,
                             @RequestParam(required = false, defaultValue = "Pending") String status,
                             @RequestParam(required = false) String dueDate,
                             @RequestParam(required = false) String dueTime,
                             HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        String category = (String) session.getAttribute("activeCategory");
        if (category == null || category.trim().isEmpty()) {
            category = "Personal";
        }

        boolean hasTime = (dueTime != null && !dueTime.trim().isEmpty());
        String rawDateStr = (dueDate != null && !dueDate.trim().isEmpty()) ? dueDate : "2026-01-01";
        String timestampStr = rawDateStr + " " + (hasTime ? dueTime : "00:00") + ":00";

        Timestamp parsedDueDate;
        try {
            parsedDueDate = Timestamp.valueOf(timestampStr);
        } catch (Exception e) {
            parsedDueDate = new Timestamp(System.currentTimeMillis());
            hasTime = false;
        }

        Task task = new Task(id, title, description, status, category, parsedDueDate, user.getId(), hasTime);
        taskService.saveTask(task);
        return "redirect:/dashboard";
    }

    @GetMapping("/delete")
    public String deleteTask(@RequestParam int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }
        taskService.deleteTask(id);
        return "redirect:/dashboard";
    }

    @GetMapping("/toggleStatus")
    public String toggleStatus(@RequestParam int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }
        taskService.toggleTaskStatus(id);
        return "redirect:/dashboard";
    }
}
