import SwiftUI
import Common

public struct PaymentView: View {
    @StateObject private var viewModel: PaymentViewModel
    @State private var presentingViewController: UIViewController?
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: PaymentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.large) {
                statusHeader

                VStack(spacing: AppTheme.Spacing.small) {
                    ForEach(viewModel.plans) { plan in
                        PlanCardView(
                            plan: plan,
                            isSelected: viewModel.selectedPlan?.id == plan.id,
                            onTap: { viewModel.selectPlan(plan) }
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.medium)

                Button {
                    guard let presentingViewController else { return }
                    Task { await viewModel.subscribe(from: presentingViewController) }
                } label: {
                    ZStack {
                        if viewModel.isProcessing {
                            ProgressView()
                                .tint(AppTheme.Colors.white100)
                        } else {
                            Text("Subscribe")
                                .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.small)
                    .background(AppTheme.Colors.purple200)
                    .foregroundColor(AppTheme.Colors.white100)
                    .cornerRadius(AppTheme.radius.meduim)
                }
                .disabled(viewModel.isProcessing || viewModel.selectedPlan == nil)
                .padding(.horizontal, AppTheme.Spacing.medium)
            }
            .padding(.vertical, AppTheme.Spacing.large)
        }
        .background(
            ViewControllerResolver { presentingViewController = $0 }
                .frame(width: 0, height: 0)
        )
        .background(AppTheme.Colors.white100)
        .onAppear {
            viewModel.loadPlans()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Payment"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $viewModel.showSuccessAlert) {
            Alert(
                title: Text("Subscribed!"),
                message: Text(successMessage),
                dismissButton: .default(Text("Done")) {
                    dismiss()
                }
            )
        }
    }

    private var successMessage: String {
        guard let subscription = viewModel.activeSubscription else {
            return "Your subscription is now active."
        }
        return "You're now on the \(subscription.planType.rawValue.capitalized) plan. Enjoy unlimited courses!"
    }

    @ViewBuilder
    private var statusHeader: some View {
        VStack(spacing: AppTheme.Spacing.xxSmall) {
            if let subscription = viewModel.activeSubscription, subscription.isActive {
                Text("Active Plan")
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))
                Text(subscription.planType.rawValue.capitalized)
                    .font(AppTheme.textStyle(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.Colors.purple200)
                Text("Renews or expires \(subscription.expiryDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(AppTheme.textStyle(size: 13, weight: .regular))
                    .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.5))
            } else {
                Text("Free Plan")
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))
                Text("Up to 2 courses")
                    .font(AppTheme.textStyle(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
            }
        }
        .padding(.top, AppTheme.Spacing.large)
    }
}
