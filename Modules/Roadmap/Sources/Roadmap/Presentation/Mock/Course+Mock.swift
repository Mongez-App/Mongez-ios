//
//  Course+Mock.swift
//
//
//  Created by Claude on 23/07/2026.
//

import Foundation

// Mock for the Add Event / Filter UI until GetCoursesUseCase is wired up.
extension Course {
    static let mockList: [Course] = [
        Course(courseId: "course_algorithms", courseName: "Algorithms"),
        Course(courseId: "course_database", courseName: "Database Systems"),
        Course(courseId: "course_networks", courseName: "Networks"),
        Course(courseId: "course_os", courseName: "Operating Systems")
    ]
}
