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
    @Published var todayTasks: [Task] = []
    @Published var upcomingDeadlines: [UpcomingDeadline] = []
    
    @Published var isLoading: Bool = false
    
    let getDashboardDetailsUseCase: GetDashboardDetailsUseCaseProtocol
//    let getUserUseCase: GetUserUseCaseProtocol
    
    public init(getDashboardDetailsUseCase: GetDashboardDetailsUseCaseProtocol) {
        
        self.getDashboardDetailsUseCase = getDashboardDetailsUseCase
        
//        self.getUserUseCase = getUserUseCase
    }
    
    public var onTaskSelected: ((String, String) -> Void)?
    var isEmpty: Bool = false
    
    func fetchUser() {
        // Mock User
        let user = User.getMockUser()
        
        self.user = user
    }
    
    @MainActor
    func fetchDashboardDetails() async {
        isLoading = true
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
    
    public func selectTask(courseId: String, taskTitle: String ,isCompleted : Bool) {
        if !isCompleted {
            onTaskSelected?(courseId, taskTitle)
        }
    }
}
