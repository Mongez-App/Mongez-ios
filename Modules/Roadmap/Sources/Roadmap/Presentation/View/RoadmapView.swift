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

            if let roadmap = viewModel.displayedRoadmap {
                if roadmap.weeks.allSatisfy({ $0.studyBlocks.isEmpty }) {
                    VStack(alignment: .center, spacing: AppTheme.Spacing.xLarge) {
                        Image("empty-tasks")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        
                        Text("No study blocks generated yet \n Start by adding some courses and events!")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.gray300)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 85)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
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
                    .padding(.bottom, 85)
                }
            } else {
                Spacer()
            }
        }
        .background(AppTheme.Colors.white100)
        .overlay(
            Group {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.15).ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
                            .scaleEffect(1.5)
                    }
                }
            }
        )
        .onAppear {
            viewModel.loadRoadmap()
        }
        .sheet(isPresented: $viewModel.isAddEventSheetPresented) {
            AddEventSheetView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.isFilterSheetPresented) {
            FilterRoadmapSheetView(viewModel: viewModel)
        }
        .overlay(
            Group {
                if viewModel.isAddEventAlertPresented {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        ValidationAlert(
                            isPresented: $viewModel.isAddEventAlertPresented,
                            title: "Status",
                            description: viewModel.addEventErrorMessage ?? ""
                        )
                    }
                }
            }
        )
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapView(viewModel: RoadmapViewmodel())
    }
}
