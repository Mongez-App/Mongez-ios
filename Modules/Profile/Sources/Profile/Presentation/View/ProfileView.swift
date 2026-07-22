//
//  File.swift
//
//
//  Created by Shady Eldakrory on 21/07/2026.
//

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
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.large) {
                if let profile = viewModel.profile {
                    VStack(spacing: AppTheme.Spacing.xSmall) {
                        CircledAsyncImage(urlString: profile.avatarUrl,
                                          size: 88,
                                          name: profile.name)
                        
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
                        iconName: "preferences",
                        iconColor: AppTheme.Colors.purple200,
                        bgOpacity: 0.12,
                        title: "Edit Preferences",
                        font: AppTheme.textStyle(size: 16, weight: .medium)
                    ) {
                        Image(systemName: "chevron.right")
                            .font(AppTheme.textStyle(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.35))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.openEditPreferences()
                    }
                    
                    SettingRow(
                        iconName: "calendar-green",
                        iconColor: AppTheme.Colors.green100,
                        bgOpacity: 0.10,
                        title: "Calendar Sync",
                        font: AppTheme.textStyle(size: 16, weight: .medium)
                    ) {
                        Toggle("", isOn: Binding(
                            get: { viewModel.isCalendarSyncEnabled },
                            set: { viewModel.requestCalendarSyncChange(to: $0) }
                        ))
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
                        iconName: "language",
                        iconColor: AppTheme.Colors.purple100,
                        bgOpacity: 0.15,
                        title: "Language",
                        font: AppTheme.textStyle(size: 16, weight: .medium)
                    ) {
                        Menu {
                            Button {
                                viewModel.selectedLanguage = "EN"
                            } label: {
                                if viewModel.selectedLanguage == "EN" {
                                    Label("English", systemImage: "checkmark")
                                } else {
                                    Text("English")
                                }
                            }
                            Button {
                                viewModel.selectedLanguage = "AR"
                            } label: {
                                if viewModel.selectedLanguage == "AR" {
                                    Label("العربية", systemImage: "checkmark")
                                } else {
                                    Text("العربية")
                                }
                            }
                        } label: {
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
        .alert("Turn off Calendar Sync?", isPresented: $viewModel.showDisableCalendarSyncAlert) {
            Button("Cancel", role: .cancel) {
                viewModel.cancelDisableCalendarSync()
            }
            Button("Turn Off", role: .destructive) {
                viewModel.confirmDisableCalendarSync()
            }
        } message: {
            Text("Your study sessions will stop syncing to your calendar. You can turn this back on anytime.")
        }
        .sheet(isPresented: $viewModel.isEditPreferencesPresented) {
            EditPreferencesSheet(
                initialHours: viewModel.dailyStudyHours,
                initialDays: viewModel.availableDays,
                onSave: { hours, days in
                    viewModel.saveEditPreferences(hours: hours, days: days)
                },
                onCancel: {
                    viewModel.cancelEditPreferences()
                }
            )
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
                    
                    Image(iconName)
                        .renderingMode(.template)
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

struct CircledAsyncImage: View {
    let urlString: String
    var size: CGFloat = 56
    var name: String
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.purple200.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .appShadow(opacity: 0.7, radius: 0)
                    
                    Text(name.prefix(2).capitalized)
                        .font(AppTheme.textStyle(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
                }
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .appShadow(opacity: 0.75, radius: 5)
                
            case .failure:
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.purple200.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .appShadow(opacity: 0.7, radius: 5)
                    
                    Text(name.prefix(2).uppercased())
                        .font(AppTheme.textStyle(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
                }
                
            @unknown default:
                EmptyView()
            }
        }
    }
}
