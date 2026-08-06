//
//  File.swift
//
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import SwiftUI
import Common

public struct RoadmapView: View {
    @ObservedObject var viewModel: RoadmapViewmodel

    public init(viewModel: RoadmapViewmodel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            RoadmapHeaderView(
                onFilterTapped: { viewModel.openFilterSheet() },
                onAddTapped: { viewModel.openAddEventSheet() }
            )
            .zIndex(1)

            ScrollView(.vertical, showsIndicators: false) {
                if let roadmap = viewModel.roadmap {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                        ForEach(roadmap.weeks, id: \.weekNumber) { week in
                            WeekSectionView(
                                week: week,
                                expandedBlockId: viewModel.expandedBlockId,
                                selectedTab: viewModel.selectedTab(for:),
                                onToggleBlock: viewModel.toggleBlock,
                                onSelectTab: { tab, blockId in
                                    viewModel.selectTab(tab, for: blockId)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.small)
                }
            }
            .padding(.bottom, 85)
        }
        .background(AppTheme.Colors.white100)
        .onAppear {
            viewModel.loadRoadmap()
        }
        .sheet(isPresented: $viewModel.isAddEventSheetPresented) {
            AddEventSheetView(
                courses: viewModel.courses,
                onSubmit: { courseId, eventType, title, dueDate, weight in
                    return await viewModel.addEvent(courseId: courseId, eventType: eventType, title: title, dueDate: dueDate, weight: weight)
                }
            )
        }
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            FilterRoadmapSheetView()
        }
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = RoadmapRepository(remoteDataSource: RoadmapRemoteDataSource())
        RoadmapView(viewModel: RoadmapViewmodel(
            getRoadmapUseCase: GetRoadmapUseCase(roadmapRepository: repo),
            addEventUseCase: AddEventUseCase(roadmapRepository: repo),
            roadmapRepository: repo
        ))
    }
}
