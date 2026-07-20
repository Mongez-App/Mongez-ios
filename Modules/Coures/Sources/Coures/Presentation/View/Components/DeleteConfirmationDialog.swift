import SwiftUI
import Common

struct DeleteConfirmationDialog: View {
    let courseName: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            
            VStack(spacing: AppTheme.Spacing.medium) {
                
                ZStack {
                    Circle()
                        .fill(
                            AppTheme.Colors.changeOpacity(
                                color: AppTheme.Colors.red100,
                                opacity: 0.1
                            )
                        )
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "trash.fill")
                        .font(.system(size: 26))
                        .foregroundColor(AppTheme.Colors.red100)
                }
                
                
                Text("Delete Course?")
                    .font(AppTheme.textStyle(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                
                Text("Are you sure you want to delete \"\(courseName)\"? This action cannot be undone and all associated materials will be removed.")
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                
                
                VStack(spacing: AppTheme.Spacing.xSmall) {
                    Button(action: onConfirm) {
                        Text("Delete")
                            .font(AppTheme.textStyle(size: 15, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.xSmall)
                            .background(AppTheme.Colors.red100)
                            .cornerRadius(AppTheme.radius.small)
                    }
                    
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(AppTheme.textStyle(size: 15, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.black100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.xSmall)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(AppTheme.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .fill(Color.white)
            )
            .padding(.horizontal, AppTheme.Spacing.xxLarge)
            .appShadow(opacity: 0.15, radius: 20, y: 10)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: true)
    }
}

struct DeleteConfirmationDialog_Previews: PreviewProvider {
    static var previews: some View {
        DeleteConfirmationDialog(
            courseName: "Operating Systems",
            onConfirm: {},
            onCancel: {}
        )
    }
}
