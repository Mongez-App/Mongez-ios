//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import SwiftUI
import Common

public struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel(
        getProfileUseCase: GetProfileUseCase(
            repository: ProfileRepository(
                remoteDataSource: ProfileRemoteDataSource()
            )
        )
    )
    
    public init(){}
    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.large) {
                if let profile = viewModel.profile {
                    VStack(spacing: AppTheme.Spacing.xSmall) {
                        Image("onboarding_img1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 88, height: 88)
                            .clipShape(Circle())
                            .shadow(
                                color: AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple100, opacity: 0.75),
                                radius: 15 / 2,
                                x: 0,
                                y: 4
                            )
                        
                        VStack(spacing: AppTheme.Spacing.xxxSmall) {
                            Text(profile.name)
                                .font(AppTheme.textStyle(size: 20, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                            
                            Text(profile.email)
                                .font(AppTheme.textStyle(size: 14, weight: .regular))
                                .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))
                        }
                    }
                    .padding(.top, AppTheme.Spacing.xLarge)
                    
                    HStack(spacing: AppTheme.Spacing.small) {
                        StatCard(title: "Studying\nHours", value: "\(profile.stats.totalStudyHours)")
                        StatCard(title: "Completed\nTasks", value: "\(profile.stats.completedTasksCount)")
                        StatCard(title: "Streak\nDays", value: "\(profile.stats.currentStreakDays)")
                    }
                    .padding(.horizontal, AppTheme.Spacing.medium)
                }
                
                VStack(spacing: 0) {
                    SettingRow(
                        iconName: "calendar",
                        iconColor: AppTheme.Colors.green100,
                        bgOpacity: 0.10,
                        title: "Calendar Sync",
                        font: AppTheme.textStyle(size: 16, weight: .medium)
                    ) {
                        Toggle("", isOn: $viewModel.isCalendarSyncEnabled)
                            .labelsHidden()
                            .tint(AppTheme.Colors.green100)
                    }
                    
                    SettingRow(
                        iconName: "moon",
                        iconColor: AppTheme.Colors.black100,
                        bgOpacity: 0.10,
                        title: "Dark Mode",
                        font: AppTheme.textStyle(size: 16, weight: .medium)
                    ) {
                        Toggle("", isOn: $viewModel.isDarkModeEnabled)
                            .labelsHidden()
                    }
                    
                    SettingRow(
                        iconName: "globe",
                        iconColor: AppTheme.Colors.purple100,
                        bgOpacity: 0.15,
                        title: "Language",
                        font: AppTheme.textStyle(size: 16, weight: .medium)
                    ) {
                        HStack(spacing: AppTheme.Spacing.xxxSmall) {
                            Text(viewModel.selectedLanguage)
                                .font(AppTheme.textStyle(size: 14, weight: .regular))
                                .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))
                            Image(systemName: "chevron.down")
                                .font(AppTheme.textStyle(size: 12, weight: .regular))
                                .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))
                        }
                        .padding(.horizontal, AppTheme.Spacing.xSmall)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.Spacing.xxSmall)
                                .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.1))
                        )
                    }
                    
                    SettingRow(
                        iconName: "rectangle.portrait.and.arrow.right",
                        iconColor: AppTheme.Colors.red100,
                        bgOpacity: 0.13,
                        title: "Logout",
                        titleColor: AppTheme.Colors.red100,
                        font: AppTheme.textStyle(size: 16, weight: .medium),
                        showDivider: false
                    ) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.top, AppTheme.Spacing.small)
            }
        }
        .background(AppTheme.Colors.white100)
        .onAppear {
            viewModel.loadProfile()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xSmall) {
            Text(title)
                .font(AppTheme.textStyle(size: 12, weight: .medium))
                .foregroundColor(AppTheme.Colors.black100)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.purple100)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.1), lineWidth: 1)
        )
    }
}

struct SettingRow<TrailingContent: View>: View {
    let iconName: String
    let iconColor: Color
    let bgOpacity: Double
    let title: String
    var titleColor: Color = AppTheme.Colors.black100
    var font: Font
    var showDivider: Bool = true
    @ViewBuilder let trailingContent: TrailingContent
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: AppTheme.Spacing.small) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.Spacing.xxSmall)
                        .fill(AppTheme.Colors.changeOpacity(color: iconColor, opacity: bgOpacity))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(font)
                    .foregroundColor(titleColor)
                
                Spacer()
                
                trailingContent
            }
            .padding(.vertical, AppTheme.Spacing.small)
            
            if showDivider {
                Divider()
                    .padding(.leading, 48)
            }
        }
    }
}
