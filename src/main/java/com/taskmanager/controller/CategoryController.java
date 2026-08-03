package com.taskmanager.controller;

import com.taskmanager.model.Category;
import com.taskmanager.model.User;
import com.taskmanager.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @GetMapping("/set-category")
    public String setCategory(@RequestParam(required = false) String category, HttpSession session) {
        if (category != null && !category.trim().isEmpty()) {
            session.setAttribute("activeCategory", category.trim());
        }
        return "redirect:/dashboard";
    }

    @PostMapping("/add-category")
    public String addCategory(@RequestParam String name,
                              @RequestParam(required = false) String description,
                              @RequestParam(required = false) String icon,
                              HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        if (name != null && !name.trim().isEmpty()) {
            String catIcon = (icon != null && !icon.trim().isEmpty()) ? icon.trim() : "📋";
            Category cat = new Category(0, name.trim(), description != null ? description.trim() : "", catIcon, user.getId());
            categoryService.saveCategory(cat);
        }
        return "redirect:/select-category.jsp";
    }
}
