//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import Combine

@MainActor
public class CourseDetailsViewModel: ObservableObject {
    @Published public var selectedTab: Int = 0
    @Published public var materials: [CourseMaterial] = []
    @Published public var tasks: [CourseTask] = []
    
    // Derived progress values
    public var completedTasksCount: Int { tasks.filter { $0.isCompleted }.count }
    public var totalTasksCount: Int { tasks.count }
    public var progressPercentage: Double {
        guard totalTasksCount > 0 else { return 0 }
        return Double(completedTasksCount) / Double(totalTasksCount)
    }
    
    private let courseId: String
    private let getMaterialsUseCase: GetCourseMaterialsUseCase
    private let getTasksUseCase: GetCourseTasksUseCase
    
    public init(courseId: String, getMaterialsUseCase: GetCourseMaterialsUseCase, getTasksUseCase: GetCourseTasksUseCase) {
        self.courseId = courseId
        self.getMaterialsUseCase = getMaterialsUseCase
        self.getTasksUseCase = getTasksUseCase
    }
    
    public func loadData() async {
        do {
            materials = try await getMaterialsUseCase.execute(courseId: courseId)
            tasks = try await getTasksUseCase.execute(courseId: courseId)
        } catch {
            print("Error loading course details: \(error)")
        }
    }
}
