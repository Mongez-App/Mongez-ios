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

    let onSave: (Int, Set<String>) -> Void
    let onCancel: () -> Void
    @Binding var isLoading: Bool
    @Binding var hours: Int
    @Binding var selectedDays: Set<String>

    private let hoursRange = Array(1...12)
    private let weekdays: [(key: String, label: String)] = [
        ("Sun", "S"), ("Mon", "M"), ("Tue", "T"),
        ("Wed", "W"), ("Thu", "T"), ("Fri", "F"), ("Sat", "S")
    ]

    init(
        hours: Binding<Int>,
        selectedDays: Binding<Set<String>>,
        isLoading: Binding<Bool>,
        onSave: @escaping (Int, Set<String>) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.onSave = onSave
        self.onCancel = onCancel
        self._hours = hours
        self._selectedDays = selectedDays
        self._isLoading = isLoading
    }

    var body: some View {
        ZStack {
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
            .opacity(isLoading ? 0.3 : 1.0)
            .disabled(isLoading)

            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
            }
        }
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

            Picker("Hours", selection: $hours) {
                ForEach(hoursRange, id: \.self) { value in
                    Text("\(value)h")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .tag(value)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
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

    private func dayChip(key: String, label: String) -> some View {
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
