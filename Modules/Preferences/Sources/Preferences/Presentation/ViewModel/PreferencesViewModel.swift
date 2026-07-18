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

    public let totalSteps = 3
    public let hoursRange = Array(1...12)

    public init() {}

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
            finish()
        }
    }

    public func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    public func skip() {
        finish()
    }

    public func syncCalendar() {
        finish()
    }

    private func finish() {
        print("Preferences finished")
    }
}
