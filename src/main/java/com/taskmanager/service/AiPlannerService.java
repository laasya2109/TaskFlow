package com.taskmanager.service;

import com.taskmanager.model.Task;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service

public class AiPlannerService {

    public List<Task> generateTaskBreakdown(String goal, int stepCount, int userId, String category) {

        if (stepCount < 3) stepCount = 3;
        if (stepCount > 6) stepCount = 6;
        if (category == null || category.trim().isEmpty()) {
            category = "Personal";
        }

        String lowerGoal = (goal != null) ? goal.toLowerCase().trim() : "";
        String displayGoal = (goal != null && !goal.trim().isEmpty()) ? goal.trim() : "New Goal";
        List<TaskStepProposal> rawSteps = getStepsForGoal(lowerGoal, displayGoal, stepCount);

        List<Task> tasks = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();

        for (int i = 0; i < rawSteps.size(); i++) {
            TaskStepProposal proposal = rawSteps.get(i);
            LocalDateTime dueDateTime = now.plusDays(i).withHour(17).withMinute(0).withSecond(0).withNano(0);
            Timestamp dueDate = Timestamp.valueOf(dueDateTime);

            Task task = new Task(
                0,
                proposal.title,
                proposal.description,
                "Pending",
                category,
                dueDate,
                userId,
                true
            );
            tasks.add(task);
        }

        return tasks;
    }

    private static class TaskStepProposal {
        String title;
        String description;
        TaskStepProposal(String title, String description) {
            this.title = title;
            this.description = description;
        }
    }

    private List<TaskStepProposal> getStepsForGoal(String lowerGoal, String originalGoal, int count) {
        List<TaskStepProposal> proposals = new ArrayList<>();

        if (lowerGoal.contains("interview") || lowerGoal.contains("java") || lowerGoal.contains("coding") || lowerGoal.contains("tech")) {
            proposals.add(new TaskStepProposal("Review Core Concepts & Data Structures", "Brush up on fundamental theory, algorithms, and key syntax."));
            proposals.add(new TaskStepProposal("Solve Practice Problems", "Complete targeted coding challenges on key problem patterns."));
            proposals.add(new TaskStepProposal("Conduct Mock Interview Session", "Practice timed problem solving and verbalizing solution logic out loud."));
            proposals.add(new TaskStepProposal("Review Resume & Past Project Architecture", "Prepare concise STAR stories for key technical achievements."));
            proposals.add(new TaskStepProposal("Final Brush-up & Checklist Review", "Review common system design and behavioral question responses."));
            proposals.add(new TaskStepProposal("Rest & Final Preparation", "Prepare interview setup, outfit, and questions for interviewer."));
        } else if (lowerGoal.contains("app") || lowerGoal.contains("web") || lowerGoal.contains("build") || lowerGoal.contains("project") || lowerGoal.contains("software")) {
            proposals.add(new TaskStepProposal("Define Scope & UI Wireframes", "Outline core user stories, feature set, and basic component layout."));
            proposals.add(new TaskStepProposal("Set Up Project Repository & DB Schema", "Initialize codebase dependencies, database tables, and environment config."));
            proposals.add(new TaskStepProposal("Implement Core Backend API Services", "Build data models, controllers, and service logic for primary features."));
            proposals.add(new TaskStepProposal("Design Frontend User Interface", "Assemble responsive views, styles, and interactive state handlers."));
            proposals.add(new TaskStepProposal("Testing & End-to-End Deployment", "Verify user flows, handle edge cases, and deploy package to production."));
            proposals.add(new TaskStepProposal("Gather User Feedback & Iterate", "Collect initial user reviews and patch initial bugs."));
        } else if (lowerGoal.contains("trip") || lowerGoal.contains("travel") || lowerGoal.contains("vacation") || lowerGoal.contains("flight")) {
            proposals.add(new TaskStepProposal("Research Destinations & Dates", "Compare travel dates, budget limits, and highlight key attractions."));
            proposals.add(new TaskStepProposal("Book Flights & Accommodations", "Secure transport tickets, hotel stays, and local rental arrangements."));
            proposals.add(new TaskStepProposal("Draft Daily Itinerary & Reservations", "Plan activities, restaurant reservations, and key site visits."));
            proposals.add(new TaskStepProposal("Pack Luggage & Essential Documents", "Prepare travel IDs, tickets, clothing, and travel electronics."));
            proposals.add(new TaskStepProposal("Final Pre-trip Check", "Confirm flight status, check-in online, and setup out-of-office response."));
        } else if (lowerGoal.contains("fitness") || lowerGoal.contains("run") || lowerGoal.contains("gym") || lowerGoal.contains("workout") || lowerGoal.contains("health")) {
            proposals.add(new TaskStepProposal("Set Target Milestones & Metric Tracker", "Define clear measurable goals, schedule, and baseline fitness metrics."));
            proposals.add(new TaskStepProposal("Plan Weekly Training & Nutrition Schedule", "Map out workout days, exercise routines, and healthy meal prep."));
            proposals.add(new TaskStepProposal("Execute Session 1: Foundation & Form Check", "Focus on warm-ups, core movements, and proper technique."));
            proposals.add(new TaskStepProposal("Execute Session 2: Endurance & Progression", "Push volume and intensity with monitored rest intervals."));
            proposals.add(new TaskStepProposal("Recovery & Progress Assessment", "Log workout notes, conduct stretching/foam rolling, and evaluate energy levels."));
        } else {
            proposals.add(new TaskStepProposal("Define Goal Objectives for " + originalGoal, "Identify key deliverables, required resources, and success criteria."));
            proposals.add(new TaskStepProposal("Research & Initial Preparation", "Gather necessary information, tools, and background reference material."));
            proposals.add(new TaskStepProposal("Execute Phase 1 Core Tasks", "Focus on primary execution steps and core milestone deliverables."));
            proposals.add(new TaskStepProposal("Review & Refine Implementation", "Check quality of output, fix issues, and gather initial feedback."));
            proposals.add(new TaskStepProposal("Finalize & Complete " + originalGoal, "Perform final polish, document results, and archive completed assets."));
            proposals.add(new TaskStepProposal("Post-completion Retrospective", "Document lessons learned and share outcomes."));
        }

        while (proposals.size() > count) {
            proposals.remove(proposals.size() - 1);
        }

        return proposals;
    }
}
