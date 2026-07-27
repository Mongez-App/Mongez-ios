//
//  CalendarSyncStepView.swift
//
//
//  Created by Ahmed Mohamed Fathi on 18/07/2026.
//

import SwiftUI
import Common

struct CalendarSyncStepView: View {
    @ObservedObject var viewModel: PreferencesViewModel

    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            CalendarSyncIllustration()
                .frame(height: 300)
                .padding(.top, AppTheme.Spacing.large)

            VStack(spacing: AppTheme.Spacing.small) {
                Text("Sync your Calendar")
                    .font(AppTheme.textStyle(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text("Connect your Apple Calendar so AI can avoid conflicts and create the best schedule for you.")
                    .font(AppTheme.textStyle(size: 16, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xLarge)
            }

            Spacer()

            VStack(spacing: AppTheme.Spacing.small) {
                Button(action: {
                    Task { await viewModel.syncCalendar() }
                }) {
                    Text("Sync Apple Calendar")
                        .font(AppTheme.textStyle(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.purple200)
                        .cornerRadius(AppTheme.radius.small)
                }

                Button(action: {
                    Task { await viewModel.skip() }
                }) {
                    Text("Skip for now")
                        .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
                .padding(.vertical, AppTheme.Spacing.xSmall)
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            .padding(.bottom, AppTheme.Spacing.xLarge)
        }
    }
}

private struct CalendarSyncIllustration: View {
    var body: some View {
        ZStack {
            Image(systemName: "sparkle")
                .font(.system(size: 18))
                .foregroundColor(AppTheme.Colors.purple200.opacity(0.4))
                .offset(x: -110, y: -110)

            Image(systemName: "diamond.fill")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.Colors.purple200.opacity(0.25))
                .offset(x: 100, y: -125)

            Circle()
                .fill(AppTheme.Colors.purple200.opacity(0.3))
                .frame(width: 12, height: 12)
                .offset(x: 130, y: -15)

            Image(systemName: "checklist")
                .font(.system(size: 16))
                .foregroundColor(AppTheme.Colors.purple200.opacity(0.35))
                .offset(x: -125, y: 20)

            EventCardMock()
                .offset(y: 55)

            CalendarIcon()
                .offset(y: -50)
        }
    }
}

private struct CalendarIcon: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(AppTheme.Colors.purple200)
                    .frame(height: 28)

                ZStack {
                    Rectangle().fill(AppTheme.Colors.white100)
                    Text("31")
                        .font(AppTheme.textStyle(size: 36, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
            .appShadow(opacity: 0.2, radius: 12, y: 6)

            Image("done_green")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(4)
                .background(Circle().fill(AppTheme.Colors.white100))
                .appShadow(opacity: 0.15, radius: 4, y: 2)
                .offset(x: 14, y: -14)
        }
    }
}

private struct EventCardMock: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            HStack(spacing: AppTheme.Spacing.xSmall) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.Colors.purple200)
                    .frame(width: 28, height: 28)
                    .background(Circle().fill(AppTheme.Colors.purple200.opacity(0.15)))

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                    Capsule().fill(AppTheme.Colors.gray100).frame(width: 120, height: 8)
                    Capsule().fill(AppTheme.Colors.gray100.opacity(0.6)).frame(width: 80, height: 8)
                }
            }

            Divider()

            HStack(spacing: AppTheme.Spacing.small) {
                Circle().fill(AppTheme.Colors.green100).frame(width: 28, height: 28)
                Capsule().fill(AppTheme.Colors.gray100).frame(width: 60, height: 8)

                Spacer()

                Circle().fill(AppTheme.Colors.purple100).frame(width: 28, height: 28)
            }
        }
        .padding(AppTheme.Spacing.small)
        .frame(width: 240)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .fill(AppTheme.Colors.white100)
        )
        .appShadow(opacity: 0.15, radius: 10, y: 6)
    }
}
