//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

public struct Dashboard {
    var todayFocus: TodayFocus
    var progressMetrics: ProgressMetrics
    var todayTasks: [TodayTask]
    var upcomingDeadlines: [UpcomingDeadline]
}
    
public struct TodayFocus {
    var courseId: String?
    var courseName: String?
    var allocatedDuration: String
    var durationMinutes: Int
}

public struct TodayTask {
    var taskId: String
    var title: String
    var durationMinutes: Int
    var priority: String
    var isCompleted: Bool
    var courseId: String?
}

public struct ProgressMetrics {
    var todayCompletedTasks: Int
    var todayTotalTasks: Int
    var weeklyHoursCompleted: Int
    var weeklyHoursGoal: Int
    var monthlyHoursCompleted: Int
    var monthlyHoursGoal: Int
}

public struct UpcomingDeadline {
    var deadlineId: String
    var title: String
    var courseName: String
    var dueText: String
    var dueDate: String
}

// Mock for testing
extension Dashboard {
    static func getMockDetails() -> Dashboard {
        let dashboard = Dashboard(
            todayFocus: TodayFocus(
                courseId: "course_uuid_9982",
                courseName: "Operating Systems",
                allocatedDuration: "2h 15m",
                durationMinutes: 135
            ),
            progressMetrics: ProgressMetrics(
                todayCompletedTasks: 3,
                todayTotalTasks: 5,
                weeklyHoursCompleted: 12,
                weeklyHoursGoal: 20,
                monthlyHoursCompleted: 45,
                monthlyHoursGoal: 80
            ),
            todayTasks: [
                TodayTask(
                    taskId: "task_001",
                    title: "Read Chapter 4",
                    durationMinutes: 45,
                    priority: "HIGH",
                    isCompleted: true,
                    courseId: "course_uuid_9982"
                ),
                TodayTask(
                    taskId: "task_002",
                    title: "Practice DFS Problems",
                    durationMinutes: 30,
                    priority: "MEDIUM",
                    isCompleted: false,
                    courseId: "course_uuid_9982"
                ),
                TodayTask(
                    taskId: "task_003",
                    title: "Finish Quiz",
                    durationMinutes: 20,
                    priority: "LOW",
                    isCompleted: false,
                    courseId: "course_uuid_9982"
                )
            ],
            upcomingDeadlines: [
                UpcomingDeadline(
                    deadlineId: "dl_881",
                    title: "Midterm",
                    courseName: "Operating Systems",
                    dueText: "4 Days left",
                    dueDate: "2026-07-18T23:59:59Z"
                ),
                UpcomingDeadline(
                    deadlineId: "dl_882",
                    title: "Assignment",
                    courseName: "Networks",
                    dueText: "Tomorrow",
                    dueDate: "2026-07-15T23:59:59Z"
                )
            ]
        )
        
        return dashboard
    }
}
