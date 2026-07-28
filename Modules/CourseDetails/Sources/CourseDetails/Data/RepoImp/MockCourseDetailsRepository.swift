//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation

public class MockCourseDetailsRepository: CourseDetailsRepository {
    
    public init() {}
    
    public func getMaterials(courseId: String) async throws -> [CourseMaterial] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [
            CourseMaterial(id: "mat_01", name: "Chapter 1 - Introduction.pdf", pageCount: 28, fileSizeMB: 2.4),
            CourseMaterial(id: "mat_02", name: "Chapter 2 - Processes.pdf", pageCount: 45, fileSizeMB: 3.1),
            CourseMaterial(id: "mat_03", name: "Chapter 3 - Memory.pdf", pageCount: 36, fileSizeMB: 2.8),
            CourseMaterial(id: "mat_04", name: "Chapter 4 - CPU Scheduling.pdf", pageCount: 29, fileSizeMB: 2.2)
        ]
    }
    
    public func getTasks(courseId: String) async throws -> [CourseTask] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return [
            CourseTask(id: "tsk_01", title: "Read Chapter 4", durationMinutes: 45, priority: .high, isCompleted: true, group: .today),
            CourseTask(id: "tsk_02", title: "Practice DFS Problems", durationMinutes: 30, priority: .medium, isCompleted: false, group: .today),
            CourseTask(id: "tsk_03", title: "Finish Quiz", durationMinutes: 20, priority: .low, isCompleted: false, group: .today),
            CourseTask(id: "tsk_04", title: "Practice DFS Problems", durationMinutes: 30, priority: .medium, isCompleted: false, group: .upcoming),
            CourseTask(id: "tsk_05", title: "Read Chapter 4", durationMinutes: 45, priority: .high, isCompleted: false, group: .upcoming)
        ]
    }

    public func uploadMaterial(courseId: String, fileData: Data, fileName: String, contentType: String, pageCount: Int?) async throws {
        // no-op for mock
    }

    public func generateTasks(courseId: String) async throws {
        // no-op for mock
    }
}
