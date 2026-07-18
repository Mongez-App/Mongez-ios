//
//  AuthView.swift
//
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import SwiftUI
import Common

public struct AuthView: View {

    private enum Field: Hashable {
        case name, email, password, confirmPassword
    }

    @StateObject private var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?

    @MainActor
    public init(viewModel: AuthViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? AuthViewModel())
    }


    public var body: some View {
        ZStack {
            AppTheme.Colors.backGround
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {

                    header

                    if viewModel.mode == .register {
                        fieldBlock(field: .name, title: "Name", icon: "person", text: $viewModel.name, placeholder: "Jhon Doe")
                    }

                    fieldBlock(field: .email, title: "Email", icon: "envelope", text: $viewModel.email, placeholder: "JhonDoe@gmail.com", keyboard: .emailAddress)

                    secureFieldBlock(field: .password, title: "Password", text: $viewModel.password, isVisible: $viewModel.isPasswordVisible)

                    if viewModel.mode == .login {
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                // TODO: forgot password flow
                            }
                            .font(AppTheme.textStyle(size: 13, weight: .medium))
                            .foregroundColor(AppTheme.Colors.primaryColor)
                        }
                    } else {
                        secureFieldBlock(field: .confirmPassword, title: "Confirm Password", text: $viewModel.confirmPassword, isVisible: $viewModel.isConfirmPasswordVisible)
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(AppTheme.textStyle(size: 13, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.top, 4)
                            .transition(.opacity)
                    }

                    primaryButton
                        .padding(.top, AppTheme.Spacing.xSmall)

                    orDivider
                        .padding(.vertical, AppTheme.Spacing.xSmall)

                    VStack(spacing: AppTheme.Spacing.xSmall) {
                        guestButton
                        googleButton
                    }

                    switchModeFooter
                }
                .padding(AppTheme.Spacing.large)
                .animation(.easeInOut(duration: 0.2), value: viewModel.mode)
                .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.mode == .login ? "Welcome back" : "Create account")
                .font(AppTheme.textStyle(size: 28, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            Text(viewModel.mode == .login ? "Let's continue our study journey" : "Start your smart learning journey")
                .font(AppTheme.textStyle(size: 14))
                .foregroundColor(AppTheme.Colors.secondoryText)
        }
        .padding(.bottom, AppTheme.Spacing.small)
    }



    private func fieldBlock(field: Field, title: String, icon: String, text: Binding<String>, placeholder: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.primaryText)
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.Colors.secondoryText)
                TextField(placeholder, text: text)
                    .keyboardType(keyboard)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: field)
            }
            .padding(AppTheme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor(for: field), lineWidth: borderWidth(for: field))
            )
        }
    }

    private func secureFieldBlock(field: Field, title: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.primaryText)
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(AppTheme.Colors.secondoryText)
                Group {
                    if isVisible.wrappedValue {
                        TextField("••••••••", text: text)
                    } else {
                        SecureField("••••••••", text: text)
                    }
                }
                .focused($focusedField, equals: field)
                Button {
                    isVisible.wrappedValue.toggle()
                } label: {
                    Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                        .foregroundColor(AppTheme.Colors.secondoryText)
                }
            }
            .padding(AppTheme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor(for: field), lineWidth: borderWidth(for: field))
            )
        }
    }

    private func borderColor(for field: Field) -> Color {
        if focusedField == field {
            return Color.black.opacity(0.55)
        }
        return AppTheme.Colors.primaryColor.opacity(0.4)
    }

    private func borderWidth(for field: Field) -> CGFloat {
        focusedField == field ? 1.5 : 1
    }


    private var primaryButton: some View {
        Button {
            Task { await viewModel.submit() }
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.BtnText))
                } else {
                    Text(viewModel.mode == .login ? "Sign In" : "Sign Up")
                        .font(AppTheme.textStyle(size: 16, weight: .bold))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.xSmall)
            .background(AppTheme.Colors.primaryColor)
            .foregroundColor(AppTheme.Colors.BtnText)
            .cornerRadius(12)
        }
        .disabled(viewModel.isLoading)
    }

    private var orDivider: some View {
        HStack {
            Rectangle().frame(height: 1).foregroundColor(AppTheme.Colors.primaryColor.opacity(0.2))
            Text("or")
                .font(AppTheme.textStyle(size: 12))
                .foregroundColor(AppTheme.Colors.secondoryText)
            Rectangle().frame(height: 1).foregroundColor(AppTheme.Colors.primaryColor.opacity(0.2))
        }
    }

    private var guestButton: some View {
        Button {
            Task { await viewModel.continueAsGuest() }
        } label: {
            HStack {
                Image(systemName: "person.crop.circle")
                Text("Continue as guest")
                    .font(AppTheme.textStyle(size: 15, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.Colors.primaryColor.opacity(0.4))
            )
            .foregroundColor(AppTheme.Colors.primaryText)
        }
    }

    private var googleButton: some View {
        Button {
        } label: {
            HStack {
                Image("google_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text("Sign in with Google")
                    .font(AppTheme.textStyle(size: 15, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.Colors.primaryColor.opacity(0.4))
            )
            .foregroundColor(AppTheme.Colors.primaryText)
        }
    }

    private var switchModeFooter: some View {
        HStack {
            Spacer()
            Text(viewModel.mode == .login ? "Don't have an account?" : "Already have an account?")
                .font(AppTheme.textStyle(size: 13))
                .foregroundColor(AppTheme.Colors.secondoryText)
            Button(viewModel.mode == .login ? "Sign up" : "Sign In") {
                viewModel.switchMode()
            }
            .font(AppTheme.textStyle(size: 13, weight: .bold))
            .foregroundColor(AppTheme.Colors.primaryColor)
            Spacer()
        }
        .padding(.top, AppTheme.Spacing.small)
    }
}
