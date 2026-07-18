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
    var todayTasks: [TaskDTO]
    var upcomingDeadlines: [UpcomingDeadlineDTO]
    
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
    
    static func mapToEntity(todayFocus: TodayFocusDTO) -> TodayFocus {
        let todayFocus = TodayFocus(courseId: todayFocus.courseId,
                                    courseName: todayFocus.courseName,
                                    allocatedDuration: todayFocus.allocatedDuration,
                                    durationMinutes: todayFocus.durationMinutes)
        
        return todayFocus
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
    
    static func mapToEntity(progressMetrics: ProgressMetricsDTO) -> ProgressMetrics {
        let progressMetrics = ProgressMetrics(todayCompletedTasks: progressMetrics.todayCompletedTasks,
                                              todayTotalTasks: progressMetrics.todayTotalTasks,
                                              weeklyHoursCompleted: progressMetrics.weeklyHoursCompleted,
                                              weeklyHoursGoal: progressMetrics.weeklyHoursGoal,
                                              monthlyHoursCompleted: progressMetrics.monthlyHoursCompleted,
                                              monthlyHoursGoal: progressMetrics.monthlyHoursGoal)
        
        return progressMetrics
    }
}

struct TaskDTO: Codable {
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
    
    static func mapToEntity(task: TaskDTO) -> Task {
        let task = Task(taskId: task.taskId,
                        title: task.title,
                        durationMinutes: task.durationMinutes,
                        priority: task.priority,
                        isCompleted: task.isCompleted)
        
        return task
    }
}

struct UpcomingDeadlineDTO: Codable {
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
    
    static func mapToEntity(upcomingDeadline: UpcomingDeadlineDTO) -> UpcomingDeadline {
        let upcomingDeadline = UpcomingDeadline(deadlineId: upcomingDeadline.deadlineId,
                                                title: upcomingDeadline.title,
                                                courseName: upcomingDeadline.courseName,
                                                dueText: upcomingDeadline.dueText,
                                                dueDate: upcomingDeadline.dueDate)
        
        return upcomingDeadline
    }
}

extension DashboardDTO {
    static func mapToEntity(dashboard: DashboardDTO) -> Dashboard {
        let dashboardEntity = Dashboard(
            todayFocus: TodayFocusDTO.mapToEntity(todayFocus: dashboard.todayFocus),
            progressMetrics: ProgressMetricsDTO.mapToEntity(progressMetrics: dashboard.progressMetrics),
            todayTasks: dashboard.todayTasks.map { TaskDTO.mapToEntity(task: $0) },
            upcomingDeadlines: dashboard.upcomingDeadlines.map { UpcomingDeadlineDTO.mapToEntity(upcomingDeadline: $0) }
        )
        
        return dashboardEntity
    }
}
