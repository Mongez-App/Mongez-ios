//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
public enum DashboardRoute: Hashable {
    case studyRoom(taskId: String, taskTitle: String)
    case courseDetails(courseId: String, courseName: String, courseType: String)
    case todayTasks
}
