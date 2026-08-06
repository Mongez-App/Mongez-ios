//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation
import SwiftUI
import Common

struct EditPreferencesSheet: View {
    @Environment(\.dismiss) private var dismiss

    let onSave: (Float, Set<Int>) -> Void
    let onCancel: () -> Void

    @State private var hours: Float
    @State private var selectedDays: Set<Int>

    private let weekdays: [(key: Int, label: String)] = [
        (0, "S"), (1, "M"), (2, "T"),
        (3, "W"), (4, "T"), (5, "F"), (6, "S")
    ]

    init(
        initialHours: Float,
        initialDays: Set<Int>,
        onSave: @escaping (Float, Set<Int>) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.onSave = onSave
        self.onCancel = onCancel
        _hours = State(initialValue: initialHours)
        _selectedDays = State(initialValue: initialDays)
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Capsule()
                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.15))
                .frame(width: 48, height: 5)
                .padding(.top, AppTheme.Spacing.small)

            Text("Edit Preferences")
                .font(AppTheme.textStyle(size: 22, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            hoursSection
            daysSection

            Spacer(minLength: 0)

            actionButtons
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100)
        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        .presentationDetents([.height(500), .large])
        .presentationDragIndicator(.hidden)
        //.presentationCornerRadius(36)
    }

    private var hoursSection: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            Text("How many hours would you study daily?")
                .font(AppTheme.textStyle(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
                .multilineTextAlignment(.center)

            HStack {
                Text(String(format: "%.1f h", hours))
                    .font(AppTheme.textStyle(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.purple200)
                    .frame(width: 80, alignment: .leading)
                
                Stepper("", value: $hours, in: 0.5...16.0, step: 0.5)
                    .labelsHidden()
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(AppTheme.Colors.white100)
                    .appShadow(opacity: 0.08, radius: 12, y: 6)
            )
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2), lineWidth: 1)
            )
        }
    }

    private var daysSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            Text("Which days are available?")
                .font(AppTheme.textStyle(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            HStack(spacing: 0) {
                Spacer()
                ForEach(weekdays, id: \.key) { day in
                    dayChip(key: day.key, label: day.label)
                    Spacer()
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray200, opacity: 0.15))
            )
        }
    }

    private func dayChip(key: Int, label: String) -> some View {
        let isSelected = selectedDays.contains(key)
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.5)) {
                if isSelected {
                    selectedDays.remove(key)
                } else {
                    selectedDays.insert(key)
                }
            }
        } label: {
            Text(label)
                .font(AppTheme.textStyle(size: 15, weight: .bold))
                .foregroundColor(isSelected ? AppTheme.Colors.white100 : AppTheme.Colors.black100)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(isSelected ? AppTheme.Colors.purple200 : AppTheme.Colors.white100)
                        .appShadow(opacity: isSelected ? 0.4 : 0.15, radius: isSelected ? 6 : 4, y: isSelected ? 3 : 2)
                )
        }
        .buttonStyle(.plain)
    }

    private var actionButtons: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            Button {
                onCancel()
                dismiss()
            } label: {
                Text("Cancel")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray200, opacity: 0.2))
                    )
            }

            Button {
                onSave(hours, selectedDays)
                dismiss()
            } label: {
                Text("Save")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.white100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.Colors.purple200)
                            .appShadow(opacity: 0.4, radius: 12, y: 6)
                    )
            }
            .disabled(selectedDays.isEmpty)
            .opacity(selectedDays.isEmpty ? 0.5 : 1)
        }
    }
}
