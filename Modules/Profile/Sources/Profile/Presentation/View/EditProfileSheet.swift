//
//  EditProfileSheet.swift
//
//
//  Created by Shady Eldakrory on 23/07/2026.
//

import SwiftUI
import Common

struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss

    let currentName: String
    let currentAvatarUrl: String
    let onSave: (String, String?) -> Void
    let onCancel: () -> Void

    private let presetAvatars: [String] = [
        "https://cdn-icons-png.flaticon.com/128/4140/4140037.png",
        "https://cdn-icons-png.flaticon.com/128/4140/4140047.png",
        "https://cdn-icons-png.flaticon.com/128/4333/4333609.png",
        "https://cdn-icons-png.flaticon.com/128/4140/4140039.png",
        "https://cdn-icons-png.flaticon.com/128/4140/4140060.png",
        "https://cdn-icons-png.flaticon.com/128/4140/4140040.png",
        "https://cdn-icons-png.flaticon.com/128/4139/4139981.png",
        "https://cdn-icons-png.flaticon.com/128/4139/4139951.png",
        "https://cdn-icons-png.flaticon.com/128/4526/4526437.png",
        "https://cdn-icons-png.flaticon.com/128/4140/4140062.png"
    ]

    @State private var nameText: String
    @State private var selectedAvatarUrl: String?
    @State private var isAvatarPickerExpanded: Bool = false

    init(
        currentName: String,
        currentAvatarUrl: String,
        onSave: @escaping (String, String?) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.currentName = currentName
        self.currentAvatarUrl = currentAvatarUrl
        self.onSave = onSave
        self.onCancel = onCancel
        _nameText = State(initialValue: currentName)
        _selectedAvatarUrl = State(initialValue: nil)
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Capsule()
                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.15))
                .frame(width: 48, height: 5)
                .padding(.top, AppTheme.Spacing.small)

            Text("Edit Profile")
                .font(AppTheme.textStyle(size: 22, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            avatarSection

            nameSection

            Spacer(minLength: 0)

            actionButtons
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100)
        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        .presentationDetents([.height(580), .large])
        .presentationDragIndicator(.hidden)
    }


    private var displayAvatarUrl: String {
        selectedAvatarUrl ?? currentAvatarUrl
    }

    private var avatarSection: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if !displayAvatarUrl.isEmpty, let url = URL(string: displayAvatarUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 96, height: 96)
                                    .clipShape(Circle())
                                    .appShadow(opacity: 0.15, radius: 5, y: 2)
                            default:
                                initialsCircle(size: 96)
                            }
                        }
                    } else {
                        initialsCircle(size: 96)
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        isAvatarPickerExpanded.toggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.purple200)
                            .frame(width: 30, height: 30)
                            .appShadow(opacity: 0.4, radius: 6, y: 3)

                        Image(systemName: isAvatarPickerExpanded ? "xmark" : "camera.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .offset(x: 2, y: 2)
            }
            .padding(.top, AppTheme.Spacing.xSmall)

            if isAvatarPickerExpanded {
                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text("Choose an Avatar")
                        .font(AppTheme.textStyle(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.xSmall), count: 5), spacing: AppTheme.Spacing.xSmall) {
                        ForEach(presetAvatars, id: \.self) { avatarUrl in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedAvatarUrl = avatarUrl
                                }
                            } label: {
                                AsyncImage(url: URL(string: avatarUrl)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 48, height: 48)
                                            .clipShape(Circle())
                                    default:
                                        Circle()
                                            .fill(AppTheme.Colors.gray200.opacity(0.3))
                                            .frame(width: 48, height: 48)
                                            .overlay(
                                                ProgressView()
                                                    .scaleEffect(0.6)
                                            )
                                    }
                                }
                                .overlay(
                                    Circle()
                                        .stroke(
                                            displayAvatarUrl == avatarUrl ? AppTheme.Colors.purple200 : Color.clear,
                                            lineWidth: 3
                                        )
                                        .frame(width: 52, height: 52)
                                )
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.small)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray200, opacity: 0.1))
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
            }
        }
    }

    private func initialsCircle(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(AppTheme.Colors.purple200.opacity(0.15))
                .frame(width: size, height: size)
                .appShadow(opacity: 0.15, radius: 5, y: 2)

            Text(currentName.prefix(2).uppercased())
                .font(AppTheme.textStyle(size: size * 0.28, weight: .medium))
                .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
        }
    }


    private var nameSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Full Name")
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))

            TextField("Enter your name", text: $nameText)
                .font(AppTheme.textStyle(size: 16, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.vertical, AppTheme.Spacing.small)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray200, opacity: 0.12))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.25), lineWidth: 1)
                )
        }
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
                onSave(nameText.trimmingCharacters(in: .whitespaces), selectedAvatarUrl)
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
            .disabled(nameText.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(nameText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
        }
    }
}
