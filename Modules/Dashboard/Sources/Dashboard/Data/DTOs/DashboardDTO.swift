//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

public struct DashboardResponseDTO: Decodable {
    let success: Bool?
    let data: DashboardDTO?
    let message: String?
}

public struct DashboardDTO: Decodable {
    var welcomeMessage: String?
    var todayFocus: TodayFocusDTO?
    var progressMetrics: ProgressMetricsDTO?
    var todayTasks: [TodayTaskDTO]
    var upcomingDeadlines: [UpcomingDeadlineDTO]
    var streak: StreakDTO?
    var aiSuggestion: AISuggestionDTO?
    
    enum CodingKeys: String, CodingKey {
        case welcomeMessage = "welcome_message"
        case todayFocus = "today_focus"
        case progressMetrics = "progress_metrics"
        case todayTasks = "today_tasks"
        case upcomingDeadlines = "upcoming_deadlines"
        case streak
        case aiSuggestion = "ai_suggestion"
    }
}

public struct TodayFocusDTO: Codable {
    var courseId: String?
    var courseName: String?
    var allocatedDuration: String
    var durationMinutes: Int
    
    enum CodingKeys: String, CodingKey {
        case courseId = "course_id"
        case courseName = "course_name"
        case allocatedDuration = "allocated_duration"
        case durationMinutes = "duration_minutes"
    }
    
    public static func mapToEntity(todayFocus: TodayFocusDTO) -> TodayFocus {
        let todayFocus = TodayFocus(courseId: todayFocus.courseId,
                                    courseName: todayFocus.courseName,
                                    allocatedDuration: todayFocus.allocatedDuration,
                                    durationMinutes: todayFocus.durationMinutes)
        
        return todayFocus
    }
}

public struct ProgressMetricsDTO: Codable {
    var todayCompletedTasks: Int
    var todayTotalTasks: Int
    var weeklyHoursCompleted: Int
    var weeklyHoursGoal: Int
    var monthlyHoursCompleted: Int
    var monthlyHoursGoal: Int
    
    enum CodingKeys: String, CodingKey {
        case todayCompletedTasks = "today_completed_tasks"
        case todayTotalTasks = "today_total_tasks"
        case weeklyHoursCompleted = "weekly_hours_completed"
        case weeklyHoursGoal = "weekly_hours_goal"
        case monthlyHoursCompleted = "monthly_hours_completed"
        case monthlyHoursGoal = "monthly_hours_goal"
    }
    
    public static func mapToEntity(progressMetrics: ProgressMetricsDTO) -> ProgressMetrics {
        let progressMetrics = ProgressMetrics(todayCompletedTasks:Int(progressMetrics.todayCompletedTasks),
                                              todayTotalTasks: Int(progressMetrics.todayTotalTasks),
                                              weeklyHoursCompleted: Int(progressMetrics.weeklyHoursCompleted),
                                              weeklyHoursGoal: Int(progressMetrics.weeklyHoursGoal),
                                              monthlyHoursCompleted: Int(progressMetrics.monthlyHoursCompleted),
                                              monthlyHoursGoal: Int(progressMetrics.monthlyHoursGoal))
        
        return progressMetrics
    }
}

public struct TodayTaskDTO: Codable {
    var taskId: String
    var title: String
    var durationMinutes: Int
    var priority: String
    var isCompleted: Bool
    var courseId: String?
    
    enum CodingKeys: String, CodingKey {
        case taskId = "task_id"
        case title
        case durationMinutes = "duration_minutes"
        case priority
        case isCompleted = "is_completed"
        case courseId = "course_id"
    }
    
    public static func mapToEntity(task: TodayTaskDTO) -> TodayTask {
        let task = TodayTask(taskId: task.taskId,
                        title: task.title,
                        durationMinutes: task.durationMinutes,
                        priority: task.priority,
                        isCompleted: task.isCompleted,
                        courseId: task.courseId)
        
        return task
    }
}

public struct UpcomingDeadlineDTO: Codable {
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
    
    public static func mapToEntity(upcomingDeadline: UpcomingDeadlineDTO) -> UpcomingDeadline {
        let upcomingDeadline = UpcomingDeadline(deadlineId: upcomingDeadline.deadlineId,
                                                title: upcomingDeadline.title,
                                                courseName: upcomingDeadline.courseName,
                                                dueText: upcomingDeadline.dueText,
                                                dueDate: upcomingDeadline.dueDate)
        
        return upcomingDeadline
    }
}

public struct StreakDTO: Codable {
    var currentStreakDays: Int
    
    enum CodingKeys: String, CodingKey {
        case currentStreakDays = "current_streak_days"
    }
}

public struct AISuggestionDTO: Codable {
    var text: String
}

extension DashboardDTO {
    public static func mapToEntity(dashboard: DashboardDTO) -> Dashboard {
        let dashboardEntity = Dashboard(
            todayFocus: dashboard.todayFocus.map { TodayFocusDTO.mapToEntity(todayFocus: $0) } ?? TodayFocus(courseId: nil, courseName: nil, allocatedDuration: "0m", durationMinutes: 0),
            progressMetrics: dashboard.progressMetrics.map { ProgressMetricsDTO.mapToEntity(progressMetrics: $0) } ?? ProgressMetrics(todayCompletedTasks: 0, todayTotalTasks: 0, weeklyHoursCompleted: 0, weeklyHoursGoal: 0, monthlyHoursCompleted: 0, monthlyHoursGoal: 0),
            todayTasks: dashboard.todayTasks.map { TodayTaskDTO.mapToEntity(task: $0) },
            upcomingDeadlines: dashboard.upcomingDeadlines.map { UpcomingDeadlineDTO.mapToEntity(upcomingDeadline: $0) }
        )
        
        return dashboardEntity
    }
}
