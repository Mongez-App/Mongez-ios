import SwiftUI
import Common

public struct TeamCoursesView: View {
    @StateObject public var viewModel: TeamCoursesViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: @autoclosure @escaping () -> TeamCoursesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    public var body: some View {
        ZStack {
            Color(hex: "#F9F9FF").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                headerSection
                    .zIndex(1)
                
                tabSelectionSection
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .padding(.bottom, AppTheme.Spacing.medium)

                if viewModel.selectedTab == .courses {
                    coursesTabContent
                } else {
                    eventsTabContent
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadData()
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }

    private var headerSection: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
            }
            
            Text(viewModel.teamName)
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.top, AppTheme.Spacing.xSmall)
        .padding(.bottom, AppTheme.Spacing.small)
    }

    private var tabSelectionSection: some View {
        HStack(spacing: 0) {
            tabButton(title: "Courses", tab: .courses)
            tabButton(title: "Events", tab: .events)
        }
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.15))
        )
    }
    
    private func tabButton(title: LocalizedStringKey, tab: TeamCoursesViewModel.Tab) -> some View {
        Button(action: { viewModel.selectedTab = tab }) {
            Text(title)
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(viewModel.selectedTab == tab ? AppTheme.Colors.white100 : AppTheme.Colors.gray200)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(viewModel.selectedTab == tab ? AppTheme.Colors.purple200 : Color.clear)
                        .appShadow(opacity: viewModel.selectedTab == tab ? 0.3 : 0, radius: 4, y: 2)
                )
        }
    }

    private var searchSection: some View {
        HStack(spacing: AppTheme.Spacing.xxSmall) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.gray200)
                .font(.system(size: 16))

            TextField("Search courses...", text: $viewModel.searchText)
                .font(AppTheme.textStyle(size: 14, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)

            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.gray200)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xSmall)
        .padding(.vertical, AppTheme.Spacing.xSmall)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .stroke(AppTheme.Colors.gray100, lineWidth: 1)
        )
        .padding(.horizontal, AppTheme.Spacing.medium)
        .padding(.bottom, AppTheme.Spacing.small)
    }

    private var coursesTabContent: some View {
        VStack(spacing: 0) {
            searchSection
            
            if viewModel.isLoadingCourses && viewModel.courses.isEmpty {
                Spacer()
                ProgressView()
                    .scaleEffect(1.2)
                Spacer()
            } else if viewModel.filteredCourses.isEmpty {
                EmptyTeamCoursesView(isSearching: !viewModel.searchText.isEmpty)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: AppTheme.Spacing.medium) {
                        ForEach(viewModel.filteredCourses) { course in
                            TeamCourseCardView(course: course)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .padding(.top, AppTheme.Spacing.xxSmall)
                    .padding(.bottom, AppTheme.Spacing.large)
                }
                .refreshable {
                    await viewModel.loadCourses()
                }
            }
        }
    }
    
    private var eventsTabContent: some View {
        VStack(spacing: 0) {
            if viewModel.isLoadingEvents && viewModel.events.isEmpty {
                Spacer()
                ProgressView()
                    .scaleEffect(1.2)
                Spacer()
            } else if viewModel.events.isEmpty {
                EmptyTeamEventsView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    let columns = [
                        GridItem(.flexible(), spacing: AppTheme.Spacing.small),
                        GridItem(.flexible(), spacing: AppTheme.Spacing.small)
                    ]
                    
                    LazyVGrid(columns: columns, spacing: AppTheme.Spacing.small) {
                        ForEach(viewModel.events) { event in
                            TeamEventCardView(event: event)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .padding(.top, AppTheme.Spacing.xxSmall)
                    .padding(.bottom, AppTheme.Spacing.large)
                }
                .refreshable {
                    await viewModel.loadEvents()
                }
            }
        }
    }
}

#if DEBUG
struct MockTeamCoursesRepository: TeamCoursesRepositoryProtocol {
    func fetchTeamCourses(teamId: String, organizationId: String) async throws -> [TeamCourse] {
        return [
            TeamCourse(id: "1", name: "Mobile Native", progress: 85),
            TeamCourse(id: "2", name: "UI/UX Design", progress: 40),
            TeamCourse(id: "3", name: "Project Management", progress: 10)
        ]
    }
    
    func fetchTeamEvents(teamId: String, organizationId: String) async throws -> [TeamEvent] {
        return [
            TeamEvent(id: "1", courseName: "Mobile Native", eventType: "Assignment", eventDate: "2026-08-20", daysLeft: 2),
            TeamEvent(id: "2", courseName: "UI/UX Design", eventType: "Quiz", eventDate: "2026-08-25", daysLeft: 7),
            TeamEvent(id: "3", courseName: "Mobile Native", eventType: "Midterm", eventDate: "2026-09-01", daysLeft: 14),
            TeamEvent(id: "4", courseName: "Project Management", eventType: "Exam", eventDate: "2026-09-15", daysLeft: 28)
        ]
    }
}

extension TeamCoursesViewModel {
    static var preview: TeamCoursesViewModel {
        let repo = MockTeamCoursesRepository()
        return TeamCoursesViewModel(
            teamId: "mock_team_id",
            teamName: "Mobile Native",
            organizationId: "mock_org_id",
            fetchTeamCoursesUseCase: FetchTeamCoursesUseCase(repository: repo),
            fetchTeamEventsUseCase: FetchTeamEventsUseCase(repository: repo)
        )
    }
}

struct TeamCoursesView_Previews: PreviewProvider {
    static var previews: some View {
        TeamCoursesView(viewModel: TeamCoursesViewModel.preview)
    }
}
#endif
