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
    @Published var filterState = RoadmapFilterState()

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
        if courses.isEmpty {
            loadCourses()
        }
        isFilterSheetPresented = true
    }

    /// The roadmap with `filterState` applied — everything renders against this, not `roadmap` directly.
    var displayedRoadmap: Roadmap? {
        guard let roadmap else { return nil }
        guard filterState.isActive else { return roadmap }
        return Self.filterRoadmap(roadmap, with: filterState)
    }

    private static func filterRoadmap(_ roadmap: Roadmap, with filter: RoadmapFilterState) -> Roadmap {
        let hasTypeOrDateFilter = filter.dateRange != nil || !filter.eventTypes.isEmpty

        let filteredWeeks = roadmap.weeks.map { week -> Week in
            let filteredBlocks = week.studyBlocks.compactMap { block -> StudyBlock? in
                if !filter.courseIds.isEmpty, !filter.courseIds.contains(block.courseId) {
                    return nil
                }

                if block.tasks.isEmpty, block.events.isEmpty {
                    return hasTypeOrDateFilter ? nil : block
                }

                let includeTasks = filter.eventTypes.isEmpty || filter.eventTypes.contains(.study)
                let filteredTasks = includeTasks
                    ? block.tasks.filter { matchesDateRange($0.taskDate, isEventDate: false, filter: filter) }
                    : []

                let filteredEvents = block.events.filter { event in
                    let typeMatches = filter.eventTypes.isEmpty || filter.eventTypes.contains { $0.matches(event.eventType) }
                    return typeMatches && matchesDateRange(event.eventDate, isEventDate: true, filter: filter)
                }

                guard !filteredTasks.isEmpty || !filteredEvents.isEmpty else { return nil }

                return StudyBlock(
                    blockId: block.blockId,
                    courseId: block.courseId,
                    courseName: block.courseName,
                    tasks: filteredTasks,
                    isCompleted: block.isCompleted,
                    events: filteredEvents
                )
            }

            return Week(
                weekNumber: week.weekNumber,
                startDate: week.startDate,
                endDate: week.endDate,
                studyBlocks: filteredBlocks
            )
        }

        return Roadmap(roadmapStartDate: roadmap.roadmapStartDate, weeks: filteredWeeks)
    }

    private static func matchesDateRange(_ dateString: String, isEventDate: Bool, filter: RoadmapFilterState) -> Bool {
        guard let range = filter.dateRange else { return true }

        let date: Date?
        if isEventDate {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            date = formatter.date(from: dateString)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            date = formatter.date(from: dateString)
        }

        guard let date else { return true }

        let calendar = Calendar.current
        let day = calendar.startOfDay(for: date)
        let start = calendar.startOfDay(for: range.lowerBound)
        let end = calendar.startOfDay(for: range.upperBound)
        return day >= start && day <= end
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
