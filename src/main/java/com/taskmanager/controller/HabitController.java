package com.taskmanager.controller;

import com.taskmanager.model.Habit;
import com.taskmanager.model.User;
import com.taskmanager.service.HabitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/habits")
public class HabitController {

    @Autowired
    private HabitService habitService;

    @GetMapping
    public String listHabits(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        List<Habit> habits = habitService.getHabitsByUserId(user.getId());
        model.addAttribute("habits", habits);

        int totalHabits = habits.size();
        long completedToday = habits.stream().filter(habitService::isCompletedToday).count();
        int completionRate = totalHabits > 0 ? (int) Math.round(((double) completedToday / totalHabits) * 100) : 0;
        int longestStreak = habits.stream().mapToInt(Habit::getStreak).max().orElse(0);

        model.addAttribute("totalHabits", totalHabits);
        model.addAttribute("completedToday", completedToday);
        model.addAttribute("completionRate", completionRate);
        model.addAttribute("longestStreak", longestStreak);
        model.addAttribute("habitService", habitService);

        return "habits";
    }

    @PostMapping("/add")
    public String addHabit(@RequestParam("name") String name,
                           @RequestParam(value = "description", required = false) String description,
                           @RequestParam(value = "icon", required = false) String icon,
                           HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        String habitIcon = (icon != null && !icon.trim().isEmpty()) ? icon.trim() : "📋";
        Habit habit = new Habit(0, name.trim(), description != null ? description.trim() : "", habitIcon, 0, null, user.getId());
        habitService.saveHabit(habit);

        return "redirect:/habits";
    }

    @GetMapping("/toggle")
    public String toggleHabit(@RequestParam("id") int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        habitService.toggleHabitCompletion(id, user.getId());
        return "redirect:/habits";
    }

    @GetMapping("/delete")
    public String deleteHabit(@RequestParam("id") int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        habitService.deleteHabit(id);
        return "redirect:/habits";
    }
}
