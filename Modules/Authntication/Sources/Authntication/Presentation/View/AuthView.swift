//
//  AuthView.swift
//
//
//  Created by Shady Eldakrory on 18/07/2026.
//

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

    @ObservedObject public var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?

    @MainActor
    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AppTheme.Colors.white100
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {

                        header

                        if viewModel.mode == .register {
                            fieldBlock(field: .name, title: "Name", icon: "name", text: $viewModel.name, placeholder: "Jhon Doe")
                        }

                        fieldBlock(field: .email, title: "Email", icon: "email", text: $viewModel.email, placeholder: "JhonDoe@gmail.com", keyboard: .emailAddress)

                        secureFieldBlock(field: .password, title: "Password", text: $viewModel.password, isVisible: $viewModel.isPasswordVisible)

                        if viewModel.mode == .login {
                            HStack {
                                Spacer()
                                Button("Forgot Password?") {
                                }
                                .font(AppTheme.textStyle(size: 13, weight: .medium))
                                .foregroundColor(AppTheme.Colors.purple200)
                            }
                        } else {
                            secureFieldBlock(field: .confirmPassword, title: "Confirm Password", text: $viewModel.confirmPassword, isVisible: $viewModel.isConfirmPasswordVisible)
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(AppTheme.textStyle(size: 13, weight: .medium))
                                .foregroundColor(AppTheme.Colors.red100)
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
                    }
                    .padding(AppTheme.Spacing.large)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.mode)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
                }

                switchModeFooter
                    .padding(.bottom, 32)
            }
        }
    }

    private var secondaryTextColor: Color {
        AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.55)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.mode == .login ? "Welcome back" : "Create account")
                .font(AppTheme.textStyle(size: 28, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            Text(viewModel.mode == .login ? "Let's continue our study journey" : "Start your smart learning journey")
                .font(AppTheme.textStyle(size: 14))
                .foregroundColor(secondaryTextColor)
        }
        .padding(.bottom, AppTheme.Spacing.small)
    }

    private func fieldBlock(field: Field, title: String, icon: String, text: Binding<String>, placeholder: String, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            HStack {
                Image(icon)
                    .foregroundColor(AppTheme.Colors.gray300)
                TextField(placeholder, text: text)
                    .keyboardType(keyboard)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: field)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(borderColor(for: field), lineWidth: borderWidth(for: field))
            )
        }
    }

    private func secureFieldBlock(field: Field, title: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            HStack {
                Image("password")
                    .foregroundColor(AppTheme.Colors.gray300)
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
                    Image(isVisible.wrappedValue ? "eye_shown" : "eye_hidden")
                        .foregroundColor(secondaryTextColor)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(borderColor(for: field), lineWidth: borderWidth(for: field))
            )
        }
    }

    private func borderColor(for field: Field) -> Color {
        if focusedField == field {
            return AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.4)
        }
        
        return AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.55)
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
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                } else {
                    Text(viewModel.mode == .login ? "Sign In" : "Sign Up")
                        .font(AppTheme.textStyle(size: 16, weight: .bold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(AppTheme.Colors.purple200)
            .foregroundColor(AppTheme.Colors.white100)
            .cornerRadius(AppTheme.radius.meduim)
        }
        .disabled(viewModel.isLoading)
    }

    private var orDivider: some View {
        HStack {
            Rectangle().frame(height: 1).foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2))
            Text("or")
                .font(AppTheme.textStyle(size: 12))
                .foregroundColor(secondaryTextColor)
            Rectangle().frame(height: 1).foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.2))
        }
    }

    private var guestButton: some View {
        Button {
            Task { await viewModel.continueAsGuest() }
        } label: {
            HStack {
                Image("guest")
                Text("Continue as guest")
                    .font(AppTheme.textStyle(size: 15, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.4))
            )
            .foregroundColor(AppTheme.Colors.black100)
        }
    }

    private var googleButton: some View {
        Button {
            Task { await viewModel.signInWithGoogle() }
        } label: {
            HStack {
                Image("google_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text("Continue with Google")
                    .font(AppTheme.textStyle(size: 15, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.4))
            )
            .foregroundColor(AppTheme.Colors.black100)
        }
    }

    private var switchModeFooter: some View {
        HStack {
            Spacer()
            Text(viewModel.mode == .login ? "Don't have an account?" : "Already have an account?")
                .font(AppTheme.textStyle(size: 13))
                .foregroundColor(secondaryTextColor)
            Button(viewModel.mode == .login ? "Sign up" : "Sign In") {
                viewModel.switchMode()
            }
            .font(AppTheme.textStyle(size: 13, weight: .bold))
            .foregroundColor(AppTheme.Colors.purple200)
            Spacer()
        }
        .padding(.top, AppTheme.Spacing.small)
    }
}
