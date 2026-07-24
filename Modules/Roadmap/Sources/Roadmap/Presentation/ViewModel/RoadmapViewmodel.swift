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

//    let getRoadmapUseCase: GetRoadmapUseCaseProtocol
//
//    public init(getRoadmapUseCase: GetRoadmapUseCaseProtocol = GetRoadmapUseCase()) {
//        self.getRoadmapUseCase = getRoadmapUseCase
//    }

    public init() {}

    func loadRoadmap() {
        guard roadmap == nil else { return }
        // Mock Roadmap — swap for getRoadmapUseCase once the Domain/Data layers land.
        roadmap = .mock
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
        isAddEventSheetPresented = true
    }

    func openFilterSheet() {
        isFilterSheetPresented = true
    }
}
