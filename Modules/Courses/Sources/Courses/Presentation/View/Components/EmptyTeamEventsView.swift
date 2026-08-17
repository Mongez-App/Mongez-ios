import SwiftUI
import Common

public struct EmptyTeamEventsView: View {
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppTheme.Colors.white100)
                    .frame(width: 160, height: 160)
                    .appShadow(opacity: 0.05, radius: 10, y: 4)

                Circle()
                    .fill(Color(hex: "#EFEFFF"))
                    .frame(width: 110, height: 110)

                Image(systemName: "calendar")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(Color(hex: "#4D46C8"))
            }

            VStack(spacing: AppTheme.Spacing.xxSmall) {
                Text("No events scheduled")
                    .font(AppTheme.textStyle(size: 18, weight: .bold))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#F9F9FF"))
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}
