//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import Combine
import PDFKit

@MainActor
public class TeamCourseDetailsViewModel: ObservableObject {
    @Published public var selectedTab: Int = 0
    @Published public var materials: [TeamCourseMaterial] = []
    @Published public var tasks: [TeamCourseTask] = []
    @Published public var courseName: String
    @Published public var courseType: String
    @Published public var courseImageUrl: String?
    @Published public var showFileImporter: Bool = false
    @Published public var isUploading: Bool = false
    @Published public var isLoading: Bool = false
    
    public var onTaskSelected: ((String, String) -> Void)?
    public var completedTasksCount: Int { tasks.filter { $0.isCompleted }.count }
    public var totalTasksCount: Int { tasks.count }
    public var progressPercentage: Double {
        guard totalTasksCount > 0 else { return 0 }
        return Double(completedTasksCount) / Double(totalTasksCount)
    }
    
    private let courseId: String
    private let organizationId: String
    private let getMaterialsUseCase: GetTeamCourseMaterialsUseCase
    private let getTasksUseCase: GetTeamCourseTasksUseCase
    
    nonisolated public init(
        courseId: String,
        organizationId: String,
        courseName: String,
        courseType: String,
        getMaterialsUseCase: GetTeamCourseMaterialsUseCase,
        getTasksUseCase: GetTeamCourseTasksUseCase
    ) {
        self.courseId = courseId
        self.organizationId = organizationId
        self._courseName = Published(wrappedValue: courseName)
        self._courseType = Published(wrappedValue: courseType)
        self.getMaterialsUseCase = getMaterialsUseCase
        self.getTasksUseCase = getTasksUseCase
    }
    
    public func loadData() async {
        isLoading = true
        do {
            materials = try await getMaterialsUseCase.execute(courseId: courseId, organizationId: organizationId)
            tasks = try await getTasksUseCase.execute(courseId: courseId)
            isLoading = false
        } catch is CancellationError {
            isLoading = false
            return
        } catch {
            isLoading = false
            print("Error loading course details: \(error)")
        }
    }
    
    public func selectTask(_ task: TeamCourseTask) {
        if !task.isCompleted {
            onTaskSelected?(task.id, task.title)
        }
    }
    
}
