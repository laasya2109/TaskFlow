package com.taskmanager.controller;

import com.taskmanager.model.Task;
import com.taskmanager.model.User;
import com.taskmanager.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class CalendarController {

    @Autowired
    private TaskService taskService;

    @GetMapping("/calendar")
    public String showCalendar(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        String category = (String) session.getAttribute("activeCategory");
        if (category == null || category.trim().isEmpty()) {
            return "redirect:/select-category.jsp";
        }

        List<Task> tasks = taskService.getTasksByUserIdAndCategory(user.getId(), category);
        model.addAttribute("tasks", tasks);
        return "calendar";
    }
}
