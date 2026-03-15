package com.taskmanager.util;

import com.taskmanager.model.Task;
import com.taskmanager.dao.TaskDAO;
import java.util.List;

public class DatabaseCheck {
    public static void main(String[] args) {
        try {
            TaskDAO dao = new TaskDAO();
            // Assuming admin user ID is 1 for check
            List<Task> tasks = dao.getTasksByUserIdAndCategory(1, "Personal");
            System.out.println("PERSONAL TASKS COUNT: " + tasks.size());
            for (Task t : tasks) {
                System.out.println("- " + t.getTitle() + " (Category: " + t.getCategory() + ")");
            }

            tasks = dao.getTasksByUserIdAndCategory(1, "Work");
            System.out.println("WORK TASKS COUNT: " + tasks.size());
            for (Task t : tasks) {
                System.out.println("- " + t.getTitle() + " (Category: " + t.getCategory() + ")");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
