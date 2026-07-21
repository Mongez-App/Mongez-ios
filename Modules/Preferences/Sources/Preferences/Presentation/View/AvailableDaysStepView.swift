//
//  AvailableDaysStepView.swift
//
//
//  Created by Ahmed Mohamed Fathi on 18/07/2026.
//

import SwiftUI
import Common

struct AvailableDaysStepView: View {
    @ObservedObject var viewModel: PreferencesViewModel

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.small),
        count: 3
    )

    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            VStack(spacing: AppTheme.Spacing.small) {
                Text("Which days are available ?")
                    .font(AppTheme.textStyle(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .multilineTextAlignment(.center)

                Text("Select all that apply")
                    .font(AppTheme.textStyle(size: 16, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
            }
            .padding(.top, AppTheme.Spacing.xLarge)

            LazyVGrid(columns: columns, spacing: AppTheme.Spacing.small) {
                ForEach(Weekday.allCases) { day in
                    DayChip(day: day, isSelected: viewModel.isSelected(day)) {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            viewModel.toggleDay(day)
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.large)

            Spacer()
        }
    }
}

private struct DayChip: View {
    let day: Weekday
    let isSelected: Bool
    let action: () -> Void

    private var outlineColor: Color {
        isSelected ? AppTheme.Colors.purple200 : .clear
    }

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Text(day.rawValue)
                    .font(AppTheme.textStyle(size: 18, weight: .bold))
                    .foregroundColor(isSelected ? AppTheme.Colors.white100 : AppTheme.Colors.black100)
                    .frame(maxWidth: .infinity)
                    .frame(height: 90)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                            .fill(isSelected ? AppTheme.Colors.purple200 : AppTheme.Colors.white100)
                            .appShadow(opacity: isSelected ? 0.75 : 0.65, radius: 5, y: 0)
                    )
                    

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(outlineColor)
                        .padding(5)
                        .background(Circle().fill(AppTheme.Colors.white100))
                        .overlay(Circle().stroke(outlineColor, lineWidth: 1.5))
                        .offset(x: 8, y: -8)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
