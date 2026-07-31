//
//  File.swift
//
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation
import SwiftUI

public enum RoadmapDetailTab: String, CaseIterable, Identifiable {
    case events = "Events"
    case tasks = "Tasks"

    public var id: String { rawValue }
}

@MainActor
public final class RoadmapViewmodel: ObservableObject {
    @Published var roadmap: Roadmap?
    @Published private(set) var expandedBlockId: String?
    @Published private var selectedTabByBlock: [String: RoadmapDetailTab] = [:]
    @Published var isAddEventSheetPresented = false
    @Published var isFilterSheetPresented = false
    
    @Published var courses: [Course] = []
    @Published var isLoading = false
    @Published var addEventErrorMessage: String?
    @Published var isAddEventAlertPresented = false

    private let getRoadmapUseCase: GetRoadmapUseCaseProtocol
    private let getCoursesUseCase: GetCoursesUseCaseProtocol
    private let addEventUseCase: AddEventUseCaseProtocol

    public init(
        getRoadmapUseCase: GetRoadmapUseCaseProtocol = GetRoadmapUseCase(roadmapRepository: RoadmapRepository(remoteDataSource: RoadmapRemoteDataSource())),
        getCoursesUseCase: GetCoursesUseCaseProtocol = GetCoursesUseCase(roadmapRepository: RoadmapRepository(remoteDataSource: RoadmapRemoteDataSource())),
        addEventUseCase: AddEventUseCaseProtocol = AddEventUseCase(roadmapRepository: RoadmapRepository(remoteDataSource: RoadmapRemoteDataSource()))
    ) {
        self.getRoadmapUseCase = getRoadmapUseCase
        self.getCoursesUseCase = getCoursesUseCase
        self.addEventUseCase = addEventUseCase
    }

    func loadRoadmap() {
        Task {
            isLoading = true
            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: Date())
                
                let fetchedRoadmap = try await getRoadmapUseCase.execute(date: dateString)
                self.roadmap = fetchedRoadmap
            } catch {
                print("Failed to load roadmap: \(error)")
            }
            isLoading = false
        }
    }
    
    func loadCourses() {
        Task {
            do {
                self.courses = try await getCoursesUseCase.execute()
            } catch {
                print("Failed to load courses: \(error)")
            }
        }
    }
    
    func addEvent(title: String, eventType: String, courseId: String, date: Date) {
        Task {
            isLoading = true
            do {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime]
                let dateString = formatter.string(from: date)
                
                let event = Event(title: title, eventType: eventType, eventDate: dateString)
                let message = try await addEventUseCase.execute(courseId: courseId, event: event)
                
                self.addEventErrorMessage = message
                self.isAddEventAlertPresented = true
                self.isAddEventSheetPresented = false
                
                // Refresh roadmap
                self.loadRoadmap()
            } catch {
                self.addEventErrorMessage = error.localizedDescription
                self.isAddEventAlertPresented = true
            }
            isLoading = false
        }
    }

    func isExpanded(_ blockId: String) -> Bool {
        expandedBlockId == blockId
    }

    func toggleBlock(_ blockId: String) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            expandedBlockId = isExpanded(blockId) ? nil : blockId
        }
    }

    func selectedTab(for blockId: String) -> RoadmapDetailTab {
        selectedTabByBlock[blockId] ?? .events
    }

    func selectTab(_ tab: RoadmapDetailTab, for blockId: String) {
        selectedTabByBlock[blockId] = tab
    }

    func openAddEventSheet() {
        if courses.isEmpty {
            loadCourses()
        }
        isAddEventSheetPresented = true
    }

    func openFilterSheet() {
        isFilterSheetPresented = true
    }
}

extension String {
    /// Formats "2026-08-04" to "Aug 4"
    func toRoadmapDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: self) else { return self }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d"
        return outputFormatter.string(from: date)
    }
    
    /// Formats "2026-08-05T09:00:00Z" to "Aug 5 - 9:00 AM"
    func toRoadmapDateTime() -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime]
        
        let date: Date
        if let parsedDate = inputFormatter.date(from: self) {
            date = parsedDate
        } else {
            // Fallback for mock data that might not be proper ISO8601
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let parsedDate = fallbackFormatter.date(from: self) {
                date = parsedDate
            } else {
                return self
            }
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d - h:mm a"
        return outputFormatter.string(from: date)
    }
}
