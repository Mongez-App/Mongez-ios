//
//  EditProfileSheet.swift
//
//
//  Created by Shady Eldakrory on 23/07/2026.
//

import SwiftUI
import PhotosUI
import Common

struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss

    // Callbacks
    let currentName: String
    let currentAvatarUrl: String
    let onSave: (String, Data?) -> Void
    let onCancel: () -> Void

    // Local state
    @State private var nameText: String
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    init(
        currentName: String,
        currentAvatarUrl: String,
        onSave: @escaping (String, Data?) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.currentName = currentName
        self.currentAvatarUrl = currentAvatarUrl
        self.onSave = onSave
        self.onCancel = onCancel
        _nameText = State(initialValue: currentName)
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            // Drag indicator
            Capsule()
                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.15))
                .frame(width: 48, height: 5)
                .padding(.top, AppTheme.Spacing.small)

            Text("Edit Profile")
                .font(AppTheme.textStyle(size: 22, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            // Avatar picker
            avatarSection

            // Name field
            nameSection

            Spacer(minLength: 0)

            // Action buttons
            actionButtons
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100)
        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        .presentationDetents([.height(480), .large])
        .presentationDragIndicator(.hidden)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }

    // MARK: - Avatar Section

    private var avatarSection: some View {
        ZStack(alignment: .bottomTrailing) {
            // Avatar display
            Group {
                if let data = selectedImageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                        .appShadow(opacity: 0.75, radius: 5)
                } else if !currentAvatarUrl.isEmpty, let url = URL(string: currentAvatarUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())
                                .appShadow(opacity: 0.75, radius: 5)
                        default:
                            initialsCircle(size: 96)
                        }
                    }
                } else {
                    initialsCircle(size: 96)
                }
            }

            // Camera badge button
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.purple200)
                        .frame(width: 30, height: 30)
                        .appShadow(opacity: 0.4, radius: 6, y: 3)

                    Image(systemName: "camera.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .offset(x: 2, y: 2)
        }
        .padding(.top, AppTheme.Spacing.xSmall)
    }

    private func initialsCircle(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(AppTheme.Colors.purple200.opacity(0.2))
                .frame(width: size, height: size)
                .appShadow(opacity: 0.7, radius: 0)

            Text(currentName.prefix(2).uppercased())
                .font(AppTheme.textStyle(size: size * 0.28, weight: .medium))
                .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
        }
    }

    // MARK: - Name Section

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

    // MARK: - Action Buttons

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
                onSave(nameText.trimmingCharacters(in: .whitespaces), selectedImageData)
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
