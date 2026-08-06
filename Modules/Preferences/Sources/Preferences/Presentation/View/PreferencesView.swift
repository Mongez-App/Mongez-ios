//
//  PreferencesView.swift
//
//
//  Created by Ahmed Mohamed Fathi on 18/07/2026.
//

import SwiftUI
import Common

public struct PreferencesView: View {
    @ObservedObject public var viewModel: PreferencesViewModel

    public init(viewModel: PreferencesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if !viewModel.isLastStep {
                    Button(action: {
                        Task { await viewModel.skip() }
                    }) {
                        Text("Skip")
                            .font(AppTheme.textStyle(size: 18, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.purple200)
                    }
                }
            }
            .frame(height: 24)
            .padding(.trailing, AppTheme.Spacing.large)
            .padding(.top, AppTheme.Spacing.medium)

            StepIndicatorView(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)
                .padding(.top, AppTheme.Spacing.large)

            TabView(selection: $viewModel.currentStep) {
                StudyHoursStepView(viewModel: viewModel)
                    .tag(0)
                AvailableDaysStepView(viewModel: viewModel)
                    .tag(1)
                CalendarSyncStepView(viewModel: viewModel)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxHeight: .infinity)

            if !viewModel.isLastStep {
                HStack {
                    if viewModel.currentStep > 0 {
                        Button(action: {
                            withAnimation {
                                viewModel.previousStep()
                            }
                        }) {
                            Text("Previous")
                                .font(AppTheme.textStyle(size: 18, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.black100)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                                )
                        }

                        Spacer(minLength: AppTheme.Spacing.medium)
                    }

                    Button(action: {
                        withAnimation {
                            viewModel.nextStep()
                        }
                    }) {
                        Text("Next")
                            .font(AppTheme.textStyle(size: 18, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.Colors.purple200)
                            .cornerRadius(AppTheme.radius.small)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.large)
                .padding(.bottom, AppTheme.Spacing.xLarge)
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .task {
            await viewModel.loadCurrentPreferences()
        }
    }
}

struct StepIndicatorView: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxSmall) {
            Text("Step \(currentStep + 1) of \(totalSteps)")
                .font(AppTheme.textStyle(size: 16, weight: .bold))
                .foregroundColor(AppTheme.Colors.purple200)

            HStack(spacing: AppTheme.Spacing.xxSmall) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    Capsule()
                        .fill(index == currentStep ? AppTheme.Colors.purple200 : AppTheme.Colors.gray100)
                        .frame(width: 32, height: 4)
                }
            }
        }
    }
}
