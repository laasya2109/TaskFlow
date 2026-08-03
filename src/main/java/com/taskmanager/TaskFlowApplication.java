package com.taskmanager;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.event.EventListener;

import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class TaskFlowApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(TaskFlowApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(TaskFlowApplication.class, args);
    }

    @EventListener(ApplicationReadyEvent.class)
    public void printApplicationUrl() {
        System.out.println("\n==========================================================");
        System.out.println(" 🚀 TaskFlow Spring Boot Application is Running!");
        System.out.println(" 👉 Access URL: http://localhost:9091/login");
        System.out.println("==========================================================\n");
    }
}
