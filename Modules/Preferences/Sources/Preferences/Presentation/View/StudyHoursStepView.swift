//
//  StudyHoursStepView.swift
//
//
//  Created by Ahmed Mohamed Fathi on 18/07/2026.
//

import SwiftUI
import Common

struct StudyHoursStepView: View {
    @ObservedObject var viewModel: PreferencesViewModel

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xLarge) {
            Spacer()

            VStack(spacing: AppTheme.Spacing.small) {
                Text("How many hours would you study daily ?")
                    .font(AppTheme.textStyle(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .multilineTextAlignment(.center)

                Text("We'll personalize your plan based on the time you have")
                    .font(AppTheme.textStyle(size: 16, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppTheme.Spacing.xLarge)

            HourWheelPicker(selection: $viewModel.studyHoursPerDay, range: viewModel.hoursRange)
                .frame(width: 160)

            Spacer()
            Spacer()
        }
    }
}

private struct HourWheelPicker: View {
    static let rowHeight: CGFloat = 64
    static let visibleRows = 5

    @Binding var selection: Int
    let range: [Int]

    @GestureState private var dragTranslation: CGFloat = 0
    @State private var isDragging = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.Spacing.small)
                .fill(AppTheme.Colors.purple200.opacity(0.10))
                .frame(height: Self.rowHeight)

            VStack(spacing: 0) {
                ForEach(range, id: \.self) { value in
                    Text("\(value)")
                        .font(AppTheme.textStyle(size: value == selection ? 28 : 18, weight: value == selection ? .bold : .regular))
                        .foregroundColor(value == selection ? AppTheme.Colors.purple200 : AppTheme.Colors.gray200)
                        .frame(height: Self.rowHeight)
                }
            }
            .offset(y: offset(for: selection) + dragTranslation)
            .animation(isDragging ? nil : .interactiveSpring(), value: selection)
        }
        .frame(height: Self.rowHeight * CGFloat(Self.visibleRows))
        .clipShape(Capsule())
        .contentShape(Capsule())
        .overlay(
            Capsule()
                .stroke(AppTheme.Colors.purple200.opacity(0.5), lineWidth: 1.5)
        )
        .appShadow(opacity: 0.25, radius: 16, y: 8)
        .gesture(
            DragGesture()
                .updating($dragTranslation) { value, state, _ in
                    state = value.translation.height
                }
                .onChanged { _ in isDragging = true }
                .onEnded { value in
                    isDragging = false
                    selection = nearestValue(afterDragging: value.translation.height)
                }
        )
    }

    private func offset(for value: Int) -> CGFloat {
        guard let index = range.firstIndex(of: value) else { return 0 }
        let middleIndex = (Double(range.count) - 1) / 2
        return CGFloat(middleIndex - Double(index)) * Self.rowHeight
    }

    private func nearestValue(afterDragging translation: CGFloat) -> Int {
        guard let currentIndex = range.firstIndex(of: selection) else { return selection }
        let indexDelta = Int((-translation / Self.rowHeight).rounded())
        let clampedIndex = min(max(currentIndex + indexDelta, 0), range.count - 1)
        return range[clampedIndex]
    }
}
