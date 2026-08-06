//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation
import Common

public class DashboardViewModel : ObservableObject {
    @Published var user: User?
    @Published var todayFocus: TodayFocus?
    @Published var progressMetrics: ProgressMetrics = ProgressMetrics(todayCompletedTasks: 0, todayTotalTasks: 0, weeklyHoursCompleted: 0, weeklyHoursGoal: 0, monthlyHoursCompleted: 0, monthlyHoursGoal: 0)
    @Published var todayTasks: [TodayTask] = []
    @Published var upcomingDeadlines: [UpcomingDeadline] = []
    
    @Published var isLoading: Bool = false

    // Delayed tasks (smart rescheduling)
    @Published var delayedTasks: [DelayedTask] = []
    @Published var showDelayedTasksAlert: Bool = false
    @Published var isRescheduling: Bool = false
    @Published var delayedErrorMessage: String?
    
    let getDashboardDetailsUseCase: GetDashboardDetailsUseCaseProtocol
    let getUserUseCase: GetUserUseCaseProtocol
    let getDelayedTasksUseCase: GetDelayedTasksUseCaseProtocol
    let rescheduleDelayedTasksUseCase: RescheduleDelayedTasksUseCaseProtocol
    
    public init(getDashboardDetailsUseCase: GetDashboardDetailsUseCaseProtocol,
                getUserUseCase: GetUserUseCaseProtocol,
                getDelayedTasksUseCase: GetDelayedTasksUseCaseProtocol,
                rescheduleDelayedTasksUseCase: RescheduleDelayedTasksUseCaseProtocol) {
        
        self.getDashboardDetailsUseCase = getDashboardDetailsUseCase
        self.getUserUseCase = getUserUseCase
        self.getDelayedTasksUseCase = getDelayedTasksUseCase
        self.rescheduleDelayedTasksUseCase = rescheduleDelayedTasksUseCase
    }
    
    public var onTaskSelected: ((String, String) -> Void)?
    public var onViewAllTodayTasks: (() -> Void)?
    var isEmpty: Bool = false
    
    @MainActor
    func fetchUser() async {
        do {
            let fetchedUser = try await getUserUseCase.execute()
            var newUser = fetchedUser
            if let existingUser = self.user {
                newUser.streakCount = existingUser.streakCount
            }
            self.user = newUser
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
        do {
            let dashboard = try await getDashboardDetailsUseCase.execute()
            self.todayFocus = dashboard.todayFocus
            self.progressMetrics = dashboard.progressMetrics
            self.todayTasks = dashboard.todayTasks
            self.upcomingDeadlines = dashboard.upcomingDeadlines
            if self.user != nil {
                self.user?.streakCount = dashboard.streakCount
            } else {
                self.user = User(name: "Loading...", avatarUrl: "", streakCount: dashboard.streakCount)
            }
            self.isLoading = false
        } catch {
            self.isLoading = false
            print("Error fetching dashboard details: \(error)")
        }
    }

    // MARK: - Delayed tasks

    /// Checks for uncompleted tasks from previous days. If any exist, the UI
    /// presents the rescheduling alert.
    @MainActor
    func checkDelayedTasks() async {
        do {
            let result = try await getDelayedTasksUseCase.execute()
            self.delayedTasks = result.tasks
            if result.totalDelayed > 0 {
                self.showDelayedTasksAlert = true
            }
        } catch {
            print("Error fetching delayed tasks: \(error)")
        }
    }

    /// Applies the given action to a single delayed task, then refreshes the schedule.
    @MainActor
    func applyAction(_ action: DelayedAction, to task: DelayedTask) async {
        guard !isRescheduling else { return }
        isRescheduling = true
        delayedErrorMessage = nil

        do {
            try await rescheduleDelayedTasksUseCase.execute(tasks: [
                (taskId: task.taskId, courseId: task.courseId, action: action)
            ])
            delayedTasks.removeAll { $0.taskId == task.taskId }
            await refreshScheduleAfterReschedule()
        } catch {
            delayedErrorMessage = mapError(error)
        }
        isRescheduling = false
    }

    /// Applies the same action to every currently delayed task (bulk action).
    @MainActor
    func applyBulkAction(_ action: DelayedAction) async {
        guard !isRescheduling, !delayedTasks.isEmpty else { return }
        isRescheduling = true
        delayedErrorMessage = nil

        do {
            try await rescheduleDelayedTasksUseCase.execute(tasks: delayedTasks.map {
                (taskId: $0.taskId, courseId: $0.courseId, action: action)
            })
            delayedTasks.removeAll()
            await refreshScheduleAfterReschedule()
        } catch {
            delayedErrorMessage = mapError(error)
        }
        isRescheduling = false
    }

    private func refreshScheduleAfterReschedule() async {
        showDelayedTasksAlert = delayedTasks.isEmpty
        // Refresh the main schedule UI to reflect updated study dates and streaks.
        await fetchDashboardDetails()
    }
    
    public func selectTask(courseId: String, taskTitle: String ,isCompleted : Bool) {
        if !isCompleted {
            onTaskSelected?(courseId, taskTitle)
        }
    }

    private func mapError(_ error: Error) -> String {
        if let apiError = error as? APIError {
            return apiError.message
        }
        return error.localizedDescription
    }
}