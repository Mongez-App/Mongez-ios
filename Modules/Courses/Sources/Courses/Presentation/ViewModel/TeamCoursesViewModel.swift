import Foundation
import Combine
import SwiftUI

public class TeamCoursesViewModel: ObservableObject {
    public let teamId: String
    public let teamName: String
    public let organizationId: String
    
    @Published public var selectedTab: Tab = .courses
    
    @Published public var courses: [TeamCourse] = []
    @Published public var filteredCourses: [TeamCourse] = []
    @Published public var events: [TeamEvent] = []
    
    @Published public var searchText: String = ""
    @Published public var isLoadingCourses: Bool = false
    @Published public var isLoadingEvents: Bool = false
    @Published public var errorMessage: String?
    
    public enum Tab {
        case courses
        case events
    }
    
    private let fetchTeamCoursesUseCase: FetchTeamCoursesUseCase
    private let fetchTeamEventsUseCase: FetchTeamEventsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        teamId: String,
        teamName: String,
        organizationId: String,
        fetchTeamCoursesUseCase: FetchTeamCoursesUseCase,
        fetchTeamEventsUseCase: FetchTeamEventsUseCase
    ) {
        self.teamId = teamId
        self.teamName = teamName
        self.organizationId = organizationId
        self.fetchTeamCoursesUseCase = fetchTeamCoursesUseCase
        self.fetchTeamEventsUseCase = fetchTeamEventsUseCase
        
        setupSearchSubscription()
    }
    
    @MainActor
    public func loadData() async {
        await loadCourses()
        await loadEvents()
    }
    
    @MainActor
    public func loadCourses() async {
        isLoadingCourses = true
        errorMessage = nil
        
        do {
            courses = try await fetchTeamCoursesUseCase.execute(teamId: teamId, organizationId: organizationId)
            applySearch()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingCourses = false
    }
    
    @MainActor
    public func loadEvents() async {
        isLoadingEvents = true
        errorMessage = nil
        
        do {
            events = try await fetchTeamEventsUseCase.execute(teamId: teamId, organizationId: organizationId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingEvents = false
    }
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.applySearch()
            }
            .store(in: &cancellables)
    }
    
    private func applySearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty {
            filteredCourses = courses
        } else {
            filteredCourses = courses.filter {
                $0.name.lowercased().contains(query)
            }
        }
    }
}
