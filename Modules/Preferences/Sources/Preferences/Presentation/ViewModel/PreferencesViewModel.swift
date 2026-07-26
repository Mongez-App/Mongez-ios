//
//  PreferencesViewModel.swift
//
//
//  Created by Ahmed Mohamed Fathi on 18/07/2026.
//

import Foundation
import Combine

@MainActor
public final class PreferencesViewModel: ObservableObject {
    @Published public var currentStep: Int = 0
    @Published public var studyHoursPerDay: Int = 6
    @Published public var selectedDays: Set<Weekday> = []
    @Published public var isSaving: Bool = false
    @Published public var errorMessage: String?

    public let totalSteps = 3
    public let hoursRange = Array(1...12)

    public var onFinish: (() -> Void)?

    private let useCase: PreferencesUseCaseProtocol

    public init(useCase: PreferencesUseCaseProtocol = PreferencesUseCase()) {
        self.useCase = useCase
    }

    public var isLastStep: Bool {
        currentStep == totalSteps - 1
    }

    public func isSelected(_ day: Weekday) -> Bool {
        selectedDays.contains(day)
    }

    public func toggleDay(_ day: Weekday) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }

    public func nextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
        } else {
            Task { await finish() }
        }
    }

    public func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    public func skip() async {
        await finish()
    }

    public func syncCalendar() async {
        await finish()
    }

    private func finish() async {
        errorMessage = nil
        isSaving = true
        defer { isSaving = false }

        do {
            _ = try await useCase.executeUpdatePreferences(
                dailyStudyHours: studyHoursPerDay,
                availableDays: Array(selectedDays)
            )
        } catch {
            errorMessage = mapError(error)
        }

        onFinish?()
    }

    private func mapError(_ error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection"
            default:
                return "Couldn't save your preferences, please try again"
            }
        }
        return "Couldn't save your preferences, please try again"
    }
}
