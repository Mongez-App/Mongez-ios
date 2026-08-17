import SwiftUI
import Common

public struct EmptyTeamCoursesView: View {
    let isSearching: Bool
    
    public init(isSearching: Bool) {
        self.isSearching = isSearching
    }

    public var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()

            ZStack {
                Circle()
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.08))
                    .frame(width: 160, height: 160)

                Circle()
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.15))
                    .frame(width: 110, height: 110)

                Image(systemName: isSearching ? "magnifyingglass" : "book.closed")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(AppTheme.Colors.purple200)
            }

            VStack(spacing: AppTheme.Spacing.xxSmall) {
                Text(isSearching ? "No results found" : "No Courses Yet")
                    .font(AppTheme.textStyle(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text(isSearching ? "Try a different search term" : "This team has no courses currently.")
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
