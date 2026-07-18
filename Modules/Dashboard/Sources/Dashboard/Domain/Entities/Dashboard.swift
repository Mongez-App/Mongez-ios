//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

struct TodayFocus {
    var courseId: String
    var courseName: String
    var allocatedDuration: String
    var durationMinutes: Float
}

struct TodayTasks {
    var todayCompletedTasks: Float
    var todayTotalTasks: Float
    var weeklyHoursCompleted: Float
    var weeklyHoursGoal: Float
    var monthlyHoursCompleted: Float
    var monthlyHoursGoal: Float
}

struct ProgressMetrics {
    var taskId: String
    var title: String
    var durationMinutes: Float
    var priority: String
    var isCompleted: Bool
}

struct UpcomingDeadlines {
    var deadlineId: String
    var title: String
    var courseName: String
    var dueText: String
    var dueDate: String
}
