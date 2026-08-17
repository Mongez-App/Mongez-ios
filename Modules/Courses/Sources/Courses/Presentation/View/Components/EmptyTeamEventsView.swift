import SwiftUI
import Common

public struct EmptyTeamEventsView: View {
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.orange100, opacity: 0.08))
                    .frame(width: 160, height: 160)

                Circle()
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.orange100, opacity: 0.15))
                    .frame(width: 110, height: 110)

                Image(systemName: "calendar")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(AppTheme.Colors.orange100)
            }

            VStack(spacing: AppTheme.Spacing.xxSmall) {
                Text("No Events Yet")
                    .font(AppTheme.textStyle(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text("This team has no upcoming events.")
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}
