import SwiftUI
import Common

struct TypingIndicatorView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 4) {
            DotView(delay: 0, isAnimating: isAnimating)
            DotView(delay: 0.2, isAnimating: isAnimating)
            DotView(delay: 0.4, isAnimating: isAnimating)
        }
        .padding(AppTheme.Spacing.small)
        .background(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.6))
        .cornerRadius(AppTheme.radius.meduim)
        .onAppear {
            isAnimating = true
        }
    }
}

private struct DotView: View {
    let delay: Double
    let isAnimating: Bool
    
    var body: some View {
        Circle()
            .fill(AppTheme.Colors.black100)
            .frame(width: 6, height: 6)
            .offset(y: isAnimating ? -4 : 4)
            .animation(
                Animation.easeInOut(duration: 0.5)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: isAnimating
            )
    }
}
