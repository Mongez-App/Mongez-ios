import Foundation
import Combine
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
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var courses: [Course] = []
    @Published var isAddingEvent = false

    let getRoadmapUseCase: GetRoadmapUseCaseProtocol
    private let addEventUseCase: AddEventUseCaseProtocol
    private let roadmapRepository: RoadmapRepositoryProtocol

    public init(getRoadmapUseCase: GetRoadmapUseCaseProtocol, addEventUseCase: AddEventUseCaseProtocol, roadmapRepository: RoadmapRepositoryProtocol) {
        self.getRoadmapUseCase = getRoadmapUseCase
        self.addEventUseCase = addEventUseCase
        self.roadmapRepository = roadmapRepository
    }

    func loadRoadmap() {
        guard roadmap == nil else { return }
        isLoading = true
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.getRoadmapUseCase.execute()
                self.roadmap = result
            } catch {
                print("Error loading roadmap: \(error)")
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }

    func loadCourses() {
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            do {
                self.courses = try await self.roadmapRepository.getCourses()
            } catch {
                print("Error loading courses: \(error)")
            }
        }
    }

    func addEvent(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async -> Bool {
        isAddingEvent = true
        defer { isAddingEvent = false }
        do {
            try await addEventUseCase.execute(courseId: courseId, eventType: eventType, title: title, dueDate: dueDate, weight: weight)
            isAddEventSheetPresented = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
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
        loadCourses()
        isAddEventSheetPresented = true
    }

    func openFilterSheet() {
        isFilterSheetPresented = true
    }
}
