import SwiftUI
import Common

struct PlanCardView: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppTheme.Spacing.small) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                    Text(plan.displayName)
                        .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.black100)
                    Text(plan.formattedPrice)
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(
                        isSelected
                            ? AppTheme.Colors.purple200
                            : AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.25)
                    )
            }
            .padding(AppTheme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .fill(
                        isSelected
                            ? AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.08)
                            : AppTheme.Colors.white100
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .stroke(
                        isSelected
                            ? AppTheme.Colors.purple200
                            : AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.1),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
