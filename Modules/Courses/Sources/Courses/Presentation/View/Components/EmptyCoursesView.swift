import SwiftUI
import Common

struct EmptyCoursesView: View {
    let isSearching: Bool
    let onAddCourse: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        AppTheme.Colors.changeOpacity(
                            color: AppTheme.Colors.purple200,
                            opacity: 0.08
                        )
                    )
                    .frame(width: 160, height: 160)

                Circle()
                    .fill(
                        AppTheme.Colors.changeOpacity(
                            color: AppTheme.Colors.purple200,
                            opacity: 0.15
                        )
                    )
                    .frame(width: 110, height: 110)

                Image(systemName: isSearching ? "magnifyingglass" : "book.closed")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(AppTheme.Colors.purple200)
            }

            VStack(spacing: AppTheme.Spacing.xxSmall) {
                Text(isSearching ? "No results found" : "No courses yet")
                    .font(AppTheme.textStyle(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text(
                    isSearching
                    ? "Try a different search term or\nadjust your filters"
                    : "Start your learning journey by\nadding your first course"
                )
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            if !isSearching {

            }

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}

struct EmptyCoursesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyCoursesView(isSearching: false, onAddCourse: {})
                .previewDisplayName("Empty State")

            EmptyCoursesView(isSearching: true, onAddCourse: {})
                .previewDisplayName("Search State")
        }
    }
}

