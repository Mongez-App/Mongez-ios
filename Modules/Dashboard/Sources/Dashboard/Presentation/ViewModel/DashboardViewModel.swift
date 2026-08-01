//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

public class DashboardViewModel : ObservableObject {
    @Published var user: User?
    @Published var todayFocus: TodayFocus?
    @Published var progressMetrics: ProgressMetrics = ProgressMetrics(todayCompletedTasks: 0, todayTotalTasks: 0, weeklyHoursCompleted: 0, weeklyHoursGoal: 0, monthlyHoursCompleted: 0, monthlyHoursGoal: 0)
    @Published var todayTasks: [TodayTask] = []
    @Published var upcomingDeadlines: [UpcomingDeadline] = []
    
    @Published var isLoading: Bool = false
    @Published var showDefaultPreferencesAlert: Bool = false
    
    let getDashboardDetailsUseCase: GetDashboardDetailsUseCaseProtocol
    let getUserUseCase: GetUserUseCaseProtocol
    
    public init(getDashboardDetailsUseCase: GetDashboardDetailsUseCaseProtocol,
                getUserUseCase: GetUserUseCaseProtocol) {
        
        self.getDashboardDetailsUseCase = getDashboardDetailsUseCase
        
        self.getUserUseCase = getUserUseCase
    }
    
    public var onTaskSelected: ((String, String) -> Void)?
    public var onViewAllTodayTasks: (() -> Void)?
    public var onViewAllUpcomingDeadlines: (() -> Void)?
    public var onNavigateToProfile: (() -> Void)?
    var isEmpty: Bool = false
    
    @MainActor
    func fetchUser() async {
        do {
            let fetchedUser = try await getUserUseCase.execute()
            self.user = fetchedUser
            print("User fetched successfully: \(fetchedUser.name)")
        } catch let decodingError as DecodingError {
            print("User decoding error: \(decodingError)")
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    @MainActor
    func fetchDashboardDetails() async {
        isLoading = true
        checkPreferencesAlert()
        do {
            let dashboard = try await getDashboardDetailsUseCase.execute()
            self.todayFocus = dashboard.todayFocus
            self.progressMetrics = dashboard.progressMetrics
            self.todayTasks = dashboard.todayTasks
            self.upcomingDeadlines = dashboard.upcomingDeadlines
            self.isLoading = false
        } catch {
            self.isLoading = false
            print("Error fetching dashboard details: \(error)")
        }
    }
    
    private func checkPreferencesAlert() {
        if UserDefaults.standard.bool(forKey: "showDefaultPreferencesAlert") {
            self.showDefaultPreferencesAlert = true
            UserDefaults.standard.set(false, forKey: "showDefaultPreferencesAlert")
        }
    }
    
    public func selectTask(courseId: String, taskTitle: String ,isCompleted : Bool) {
        if !isCompleted {
            onTaskSelected?(courseId, taskTitle)
        }
    }
}
