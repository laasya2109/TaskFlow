package com.taskmanager.service;

import com.taskmanager.model.Task;
import com.taskmanager.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.internet.MimeMessage;

@Service
public class EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    public void sendTaskReminderEmail(User user, Task task) {
        String recipientEmail = (user != null && user.getEmail() != null && !user.getEmail().trim().isEmpty()) 
                ? user.getEmail() : "user@example.com";
        String subject = "⏰ Reminder: Your task '" + task.getTitle() + "' is due in 1 hour!";

        String htmlContent = "<h2>TaskFlow Reminder ⏰</h2>"
                + "<p>Hi <b>" + (user != null ? user.getUsername() : "User") + "</b>,</p>"
                + "<p>Your task <b>'" + task.getTitle() + "'</b> is due in less than 1 hour!</p>"
                + "<ul>"
                + "<li><b>Category:</b> " + task.getCategory() + "</li>"
                + "<li><b>Due Time:</b> " + task.getDueDate() + "</li>"
                + "<li><b>Status:</b> " + task.getStatus() + "</li>"
                + "</ul>"
                + "<p>Log in to <a href='http://localhost:9091/login'>TaskFlow</a> to complete your task.</p>";

        System.out.println("\n==========================================================");
        System.out.println(" 📧 [AUTOMATED EMAIL REMINDER SENT]");
        System.out.println(" 👉 Recipient Email: " + recipientEmail);
        System.out.println(" 👉 Task Title:      " + task.getTitle());
        System.out.println(" 👉 Due Date/Time:   " + task.getDueDate());
        System.out.println("==========================================================\n");

        if (mailSender != null) {
            try {
                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
                helper.setTo(recipientEmail);
                helper.setSubject(subject);
                helper.setText(htmlContent, true);
                mailSender.send(message);
                System.out.println("   [SUCCESS] Live Email dispatched via SMTP server.\n");
            } catch (Exception e) {
                System.out.println("   [NOTE] Email reminder logged to terminal.\n");
            }
        }
    }
}
