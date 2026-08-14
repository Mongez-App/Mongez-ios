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
        ),
        getPreferencesUseCase: GetPreferencesUseCase(
            repository: ProfileRepository(
                remoteDataSource: ProfileRemoteDataSource()
            )
        ),
        updateProfileUseCase: UpdateProfileUseCase(
            repository: ProfileRepository(
                remoteDataSource: ProfileRemoteDataSource()
            )
        ),
        updatePreferencesUseCase: UpdatePreferencesUseCase(
            repository: ProfileRepository(
                remoteDataSource: ProfileRemoteDataSource()
            )
        ),
        updateCalendarSyncUseCase: UpdateCalendarSyncUseCase(
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
                        
                        ZStack(alignment: .bottomTrailing) {
                            if let data = viewModel.localSelectedImageData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 88, height: 88)
                                    .clipShape(Circle())
                                    .appShadow(opacity: 0.75, radius: 5)
                            } else {
                                CircledAsyncImage(urlString: profile.avatarUrl ?? "",
                                                  size: 88,
                                                  name: profile.name ?? "")
                            }
                            
                            
                            Button {
                                viewModel.openEditProfile()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(AppTheme.Colors.purple200)
                                        .frame(width: 26, height: 26)
                                        .appShadow(opacity: 0.4, radius: 6, y: 3)
                                    
                                    Image(systemName: "pencil")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .offset(x: 2, y: 2)
                        }
                        
                        VStack(spacing: AppTheme.Spacing.xxxSmall) {
                            Text(profile.name ?? "")
                                .font(AppTheme.textStyle(size: 20, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                            
                            Text(profile.email ?? "")
                                .font(AppTheme.textStyle(size: 14, weight: .regular))
                                .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))
                        }
                    }
                    .padding(.top, AppTheme.Spacing.xLarge)
                    
                    HStack(spacing: AppTheme.Spacing.small) {
                        StatCard(title: "Studying\nHours", value: String(format: "%.1f", profile.stats?.totalStudyHours ?? 0.0))
                        StatCard(title: "Completed\nTasks", value: "\(profile.stats?.completedTasksCount ?? 0)")
                        StatCard(title: "Streak\nDays", value: "\(profile.stats?.currentStreakDays ?? 0)")
                    }
                    .padding(.horizontal, AppTheme.Spacing.medium)
                }
                
                VStack(spacing: 0) {
                    SettingRow(
                        iconName: "calendar-green",
                        iconColor: AppTheme.Colors.green100,
                        bgOpacity: 0.10,
                        title: "Calendar Sync",
                        font: AppTheme.textStyle(size: 16, weight: .regular)
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
                        title: "Appearance",
                        font: AppTheme.textStyle(size: 16, weight: .regular)
                    ) {
                        Menu {
                            Button {
                                viewModel.updateAppearance("Light Mode")
                            } label: {
                                if viewModel.appearanceMode == "Light Mode" {
                                    Label("Light", systemImage: "checkmark")
                                } else {
                                    Label("Light", systemImage: "sun.max")
                                }
                            }
                            Button {
                                viewModel.updateAppearance("Dark Mode")
                            } label: {
                                if viewModel.appearanceMode == "Dark Mode" {
                                    Label("Dark", systemImage: "checkmark")
                                } else {
                                    Label("Dark", systemImage: "moon.fill")
                                }
                            }
                            Button {
                                viewModel.updateAppearance("System")
                            } label: {
                                if viewModel.appearanceMode == "System" {
                                    Label("System", systemImage: "checkmark")
                                } else {
                                    Label("System", systemImage: "iphone")
                                }
                            }
                        } label: {
                            HStack(spacing: AppTheme.Spacing.xxxSmall) {
                                Text(viewModel.appearanceMode == "Light Mode" ? "Light" :
                                     viewModel.appearanceMode == "Dark Mode" ? "Dark" : "System")
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
                        iconName: "language",
                        iconColor: AppTheme.Colors.purple100,
                        bgOpacity: 0.15,
                        title: "Language",
                        font: AppTheme.textStyle(size: 16, weight: .regular)
                    ) {
                        Menu {
                            Button {
                                viewModel.updateLanguage("EN")
                            } label: {
                                if viewModel.selectedLanguage == "EN" {
                                    Label("English", systemImage: "checkmark")
                                } else {
                                    Text("English")
                                }
                            }
                            Button {
                                viewModel.updateLanguage("AR")
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
                        iconName: "preferences",
                        iconColor: AppTheme.Colors.yellow100,
                        bgOpacity: 0.13,
                        title: "Edit Preferences",
                        font: AppTheme.textStyle(size: 16, weight: .regular)
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
                        iconName: "logout",
                        iconColor: AppTheme.Colors.red100,
                        bgOpacity: 0.12,
                        title: "Logout",
                        titleColor: AppTheme.Colors.red100,
                        font: AppTheme.textStyle(size: 16, weight: .regular),
                        showDivider: false
                    ) {
                        EmptyView()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.requestLogout()
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.medium)
            }
        }
        .background(AppTheme.Colors.white100)
        .onAppear {
            viewModel.loadProfile()
        }
        .overlay {
            if viewModel.showDisableCalendarSyncAlert || viewModel.showLogoutAlert {
                Color.black.opacity(0.3).ignoresSafeArea()
            }
            if viewModel.showDisableCalendarSyncAlert {
                NegativeActionAlertView(
                    isPresented: $viewModel.showDisableCalendarSyncAlert,
                    title: "Turn off Calendar Sync?",
                    description: "Your study sessions will stop syncing to your calendar. You can turn this back on anytime.",
                    primaryButtonTitle: "Cancel",
                    secondaryButtonTitle: "Disconnect",
                    secondaryAction: {
                        viewModel.confirmDisableCalendarSync()
                    }
                )
            } else if viewModel.showLogoutAlert {
                NegativeActionAlertView(
                    isPresented: $viewModel.showLogoutAlert,
                    title: "Are you sure you want to log out?",
                    description: "You will need to enter your username and password to sign back in.",
                    primaryButtonTitle: "Cancel",
                    secondaryButtonTitle: "Logout",
                    secondaryAction: {
                        viewModel.logout()
                    }
                )
            }
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $viewModel.isEditPreferencesPresented) {
            EditPreferencesSheet(
                hours: $viewModel.dailyStudyHours,
                selectedDays: $viewModel.availableDays,
                isLoading: $viewModel.isPreferencesLoading,
                onSave: { hours, days in
                    viewModel.saveEditPreferences(hours: hours, days: days)
                },
                onCancel: {
                    viewModel.cancelEditPreferences()
                }
            )
        }
        .sheet(isPresented: $viewModel.isEditProfilePresented) {
            if let profile = viewModel.profile {
                EditProfileSheet(
                    currentName: profile.name ?? "",
                    currentAvatarUrl: profile.avatarUrl ?? "",
                    onSave: { name, avatarUrl in
                        viewModel.saveEditProfile(name: name, avatarUrl: avatarUrl)
                    },
                    onCancel: {
                        viewModel.cancelEditProfile()
                    }
                )
            }
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
                .foregroundColor(AppTheme.Colors.purple200.opacity(0.9))
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
                        .fill(AppTheme.Colors.purple200.opacity(0.15))
                        .frame(width: size, height: size)
                        .appShadow(opacity: 0.18, radius: 10, y: 0)
                    
                    Text(name.prefix(2).capitalized)
                        .font(AppTheme.textStyle(size: size * 0.35, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
                }
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .appShadow(opacity: 0.18, radius: 10, y: 0)
                
            case .failure:
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.purple200.opacity(0.15))
                        .frame(width: size, height: size)
                        .appShadow(opacity: 0.18, radius: 10, y: 0)
                    
                    Text(name.prefix(2).uppercased())
                        .font(AppTheme.textStyle(size: size * 0.35, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
                }
                
            @unknown default:
                EmptyView()
            }
        }
    }
}
