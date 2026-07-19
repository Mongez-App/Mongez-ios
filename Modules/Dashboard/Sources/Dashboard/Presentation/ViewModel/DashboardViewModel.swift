//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

class DashboardViewModel : ObservableObject {
    @Published var user: User?
    @Published var todayFocus: TodayFocus?
    @Published var progressMetrics: ProgressMetrics?
    @Published var todayTasks: [Task]?
    @Published var upcomingDeadlines: [UpcomingDeadline]?
    
    var isEmpty: Bool = false
    
    let getDashboardDetailsUseCase: GetDashboardDetailsUseCaseProtocol
    let getUserUseCase: GetUserUseCaseProtocol
    
    init(getDashboardDetailsUseCase: GetDashboardDetailsUseCaseProtocol,
         getUserUseCase: GetUserUseCaseProtocol) {
        
        self.getDashboardDetailsUseCase = getDashboardDetailsUseCase
        
        self.getUserUseCase = getUserUseCase
    }
    
    func fetchUser() {
        // Mock User
        let user = User.getMockUser()
        
        self.user = user
    }
    
    func fetchDashboardDetails() {
        // Mock Dashboard
        let dashboard = Dashboard.getMockDetails()
        
        todayFocus = dashboard.todayFocus
        progressMetrics = dashboard.progressMetrics
        todayTasks = dashboard.todayTasks
        upcomingDeadlines = dashboard.upcomingDeadlines
    }
}
