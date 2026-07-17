//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

struct DashboardDTO: Codable {
    var todayFocus: TodayFocusDTO
    var progressMetrics: ProgressMetricsDTO
    var todayTasks: [TodayTasksDTO]
    var upcomingDeadlines: [UpcomingDeadlinesDTO]
    
    enum CodingKeys: String, CodingKey {
        case todayFocus = "today_focus"
        case progressMetrics = "progress_metrics"
        case todayTasks = "today_tasks"
        case upcomingDeadlines = "upcoming_deadlines"
    }
}

struct TodayFocusDTO: Codable {
    var courseId: String
    var courseName: String
    var allocatedDuration: String
    var durationMinutes: Float
    
    enum CodingKeys: String, CodingKey {
        case courseId = "course_id"
        case courseName = "course_name"
        case allocatedDuration = "allocated_duration"
        case durationMinutes = "duration_minutes"
    }
}

struct ProgressMetricsDTO: Codable {
    var todayCompletedTasks: Float
    var todayTotalTasks: Float
    var weeklyHoursCompleted: Float
    var weeklyHoursGoal: Float
    var monthlyHoursCompleted: Float
    var monthlyHoursGoal: Float
    
    enum CodingKeys: String, CodingKey {
        case todayCompletedTasks = "today_completed_tasks"
        case todayTotalTasks = "today_total_tasks"
        case weeklyHoursCompleted = "weekly_hours_completed"
        case weeklyHoursGoal = "weekly_hours_goal"
        case monthlyHoursCompleted = "monthly_hours_completed"
        case monthlyHoursGoal = "monthly_hours_goal"
    }
}

struct TodayTasksDTO: Codable {
    var taskId: String
    var title: String
    var durationMinutes: Float
    var priority: String
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case taskId = "task_id"
        case title
        case durationMinutes = "duration_minutes"
        case priority
        case isCompleted = "is_completed"
    }
}

struct UpcomingDeadlinesDTO: Codable {
    var deadlineId: String
    var title: String
    var courseName: String
    var dueText: String
    var dueDate: String
    
    enum CodingKeys: String, CodingKey {
        case deadlineId = "deadline_id"
        case title
        case courseName = "course_name"
        case dueText = "due_text"
        case dueDate = "due_date"
    }
}
