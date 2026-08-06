//
//  TeamDetailsView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

private enum TeamDetailsTab: String, CaseIterable {
    case courses = "Courses"
    case events = "Events"
}

/// Destination reached by tapping the chevron on a team card. Shows the team's
/// courses and upcoming/past events loaded from `GET teams/{id}/courses` and
/// `GET teams/{id}/events`.
struct TeamDetailsView: View {
    let team: Team?
    @ObservedObject var viewModel: OrganizationViewModel
    @State private var selectedTab: TeamDetailsTab = .courses
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            header

            detailsTabs

            ScrollView(.vertical, showsIndicators: false) {
                Group {
                    switch selectedTab {
                    case .courses:
                        coursesTab
                    case .events:
                        eventsTab
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.large)
                .padding(.vertical, AppTheme.Spacing.medium)
            }
            .background(OrganizationTheme.Colors.background)
        }
        .background(OrganizationTheme.Colors.background.ignoresSafeArea())
        .task {
            if let teamId = team?.id {
                await viewModel.loadTeamDetails(teamId: teamId)
            }
        }
    }

    private var header: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(OrganizationTheme.Colors.accent)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(PlainButtonStyle())

            Text(team?.name ?? "Team")
                .font(AppTheme.textStyle(size: 22, weight: .semibold))
                .foregroundColor(OrganizationTheme.Colors.primaryText)
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.vertical, AppTheme.Spacing.small)
        .background(OrganizationTheme.Colors.background.ignoresSafeArea(edges: .top))
    }

    private var detailsTabs: some View {
        HStack(spacing: 0) {
            ForEach(TeamDetailsTab.allCases, id: \.self) { tab in
                let isSelected = selectedTab == tab

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 6) {
                        Text(tab.rawValue)
                            .font(AppTheme.textStyle(
                                size: isSelected ? 16 : 14,
                                weight: isSelected ? .semibold : .medium
                            ))
                            .foregroundColor(
                                isSelected
                                    ? OrganizationTheme.Colors.accent
                                    : OrganizationTheme.Colors.secondaryText
                            )

                        Rectangle()
                            .fill(isSelected ? OrganizationTheme.Colors.accent : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(1.5)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(OrganizationTheme.Colors.background)
    }

    @ViewBuilder
    private var coursesTab: some View {
        if viewModel.teamCourses.isEmpty {
            EmptyStateView(
                icon: "book.closed",
                title: "No Courses Yet",
                message: "Courses assigned to this team will appear here."
            )
        } else {
            VStack(spacing: AppTheme.Spacing.small) {
                ForEach(viewModel.teamCourses) { course in
                    CourseCardView(course: course)
                }
            }
        }
    }

    @ViewBuilder
    private var eventsTab: some View {
        if viewModel.teamEvents.upcoming.isEmpty && viewModel.teamEvents.past.isEmpty {
            EmptyStateView(
                icon: "calendar",
                title: "No Events Yet",
                message: "Upcoming and past events for this team will appear here."
            )
        } else {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                if !viewModel.teamEvents.upcoming.isEmpty {
                    eventsSection(title: "Upcoming", events: viewModel.teamEvents.upcoming)
                }

                if !viewModel.teamEvents.past.isEmpty {
                    eventsSection(title: "Past", events: viewModel.teamEvents.past)
                }
            }
        }
    }

    private func eventsSection(title: String, events: [TeamEvent]) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(title)
                .font(AppTheme.textStyle(size: 18, weight: .semibold))
                .foregroundColor(OrganizationTheme.Colors.primaryText)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: AppTheme.Spacing.xSmall), GridItem(.flexible())],
                spacing: AppTheme.Spacing.small
            ) {
                ForEach(events) { event in
                    EventCardView(event: event)
                }
            }
        }
    }
}
