//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

struct Dashboard {
    var todayFocus: TodayFocus
    var progressMetrics: ProgressMetrics
    var todayTasks: [Task]
    var upcomingDeadlines: [UpcomingDeadline]
}
    
struct TodayFocus {
    var courseId: String
    var courseName: String
    var allocatedDuration: String
    var durationMinutes: Float
}

struct Task {
    var taskId: String
    var title: String
    var durationMinutes: Float
    var priority: String
    var isCompleted: Bool
}

struct ProgressMetrics {
    var todayCompletedTasks: Float
    var todayTotalTasks: Float
    var weeklyHoursCompleted: Float
    var weeklyHoursGoal: Float
    var monthlyHoursCompleted: Float
    var monthlyHoursGoal: Float
}

struct UpcomingDeadline {
    var deadlineId: String
    var title: String
    var courseName: String
    var dueText: String
    var dueDate: String
}
