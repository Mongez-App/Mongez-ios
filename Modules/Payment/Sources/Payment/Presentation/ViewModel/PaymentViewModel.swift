import Foundation
import UIKit
import Common

public final class PaymentViewModel: ObservableObject {
    @Published public var plans: [SubscriptionPlan] = []
    @Published public var selectedPlan: SubscriptionPlan?
    @Published public var activeSubscription: ActiveSubscription?
    @Published public var isProcessing: Bool = false
    @Published public var showAlert: Bool = false
    @Published public var alertMessage: String = ""
    @Published public var showSuccessAlert: Bool = false

    private let fetchPlansUseCase: FetchSubscriptionPlansUseCase
    private let createIntentionUseCase: CreatePaymentIntentionUseCase
    private let getStatusUseCase: GetSubscriptionStatusUseCase
    private let saveSubscriptionUseCase: SaveSubscriptionUseCase
    private let verifyTransactionUseCase: VerifyTransactionUseCase
    private let checkoutPresenter: PaymobCheckoutPresenting

    public init(
        fetchPlansUseCase: FetchSubscriptionPlansUseCase = FetchSubscriptionPlansUseCase(),
        createIntentionUseCase: CreatePaymentIntentionUseCase = CreatePaymentIntentionUseCase(),
        getStatusUseCase: GetSubscriptionStatusUseCase = GetSubscriptionStatusUseCase(),
        saveSubscriptionUseCase: SaveSubscriptionUseCase = SaveSubscriptionUseCase(),
        verifyTransactionUseCase: VerifyTransactionUseCase = VerifyTransactionUseCase(),
        checkoutPresenter: PaymobCheckoutPresenting = PaymobSDKAdapter()
    ) {
        self.fetchPlansUseCase = fetchPlansUseCase
        self.createIntentionUseCase = createIntentionUseCase
        self.getStatusUseCase = getStatusUseCase
        self.saveSubscriptionUseCase = saveSubscriptionUseCase
        self.verifyTransactionUseCase = verifyTransactionUseCase
        self.checkoutPresenter = checkoutPresenter
    }

    public func loadPlans() {
        plans = fetchPlansUseCase.execute()
        if selectedPlan == nil {
            selectedPlan = plans.first
        }
        activeSubscription = getStatusUseCase.currentSubscription()
    }

    public func selectPlan(_ plan: SubscriptionPlan) {
        selectedPlan = plan
    }

    @MainActor
    public func subscribe(from viewController: UIViewController) async {
        guard let plan = selectedPlan else { return }

        isProcessing = true
        defer { isProcessing = false }

        do {
            let intention = try await createIntentionUseCase.execute(plan: plan)
            await presentCheckout(intention: intention, plan: plan, from: viewController)
        } catch {
            showError(message: mapError(error))
        }
    }

    private func presentCheckout(intention: PaymentIntention, plan: SubscriptionPlan, from viewController: UIViewController) async {
        await withCheckedContinuation { continuation in
            let customization = PaymobCheckoutCustomization(
                appName: "Mongez",
                buttonBackgroundColor: UIColor(AppTheme.Colors.purple200),
                buttonTextColor: UIColor(AppTheme.Colors.white100),
                showSaveCard: true,
                saveCardDefault: false
            )

            // Paymob can invoke its delegate more than once for a single checkout (e.g. pending
            // followed by accepted); resuming a continuation twice is a hard crash, so latch it.
            let hasResumed = ResumeLatch()

            checkoutPresenter.presentCheckout(
                from: viewController,
                publicKey: intention.publicKey,
                clientSecret: intention.clientSecret,
                customization: customization
            ) { [weak self] result in
                guard let self else {
                    if hasResumed.claim() { continuation.resume() }
                    return
                }
                Task { @MainActor in
                    await self.handle(result: result, plan: plan, reference: intention.specialReference)
                    if hasResumed.claim() { continuation.resume() }
                }
            }
        }
    }

    @MainActor
    private func handle(result: PaymobCheckoutResult, plan: SubscriptionPlan, reference: String) async {
        switch result {
        case .accepted:
            activate(plan: plan)

        case .rejected(let message):
            showError(message: message)

        // Neither of these is a definitive "not paid": the customer can cancel at a stage where the
        // charge already went through, and pending can settle moments later. Paymob's guidance is to
        // confirm via Transaction Inquiry rather than trust the SDK result alone.
        case .cancelled:
            if await didTransactionSettle(reference: reference) {
                activate(plan: plan)
            }

        case .pending:
            if await didTransactionSettle(reference: reference) {
                activate(plan: plan)
            } else {
                showError(message: "Your payment is pending confirmation.")
            }
        }
    }

    private func activate(plan: SubscriptionPlan) {
        activeSubscription = saveSubscriptionUseCase.execute(plan: plan)
        showSuccessAlert = true
    }

    private func didTransactionSettle(reference: String) async -> Bool {
        do {
            let settled = try await verifyTransactionUseCase.execute(reference: reference)
            print("[Paymob] inquiry for \(reference): settled = \(settled)")
            return settled
        } catch {
            // Inquiry is a best-effort recovery path — if it fails we simply don't unlock, leaving
            // the user exactly where the SDK's own result left them.
            print("[Paymob] inquiry for \(reference) failed: \(error)")
            return false
        }
    }

    private func showError(message: String) {
        alertMessage = message
        showAlert = true
    }

    /// Ensures a checked continuation is resumed exactly once, even if the SDK reports twice.
    private final class ResumeLatch: @unchecked Sendable {
        private let lock = NSLock()
        private var claimed = false

        func claim() -> Bool {
            lock.lock()
            defer { lock.unlock() }
            if claimed { return false }
            claimed = true
            return true
        }
    }

    private func mapError(_ error: Error) -> String {
        if let apiError = error as? APIError { return apiError.message }
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection. Please check your network and try again."
            default:
                return urlError.localizedDescription
            }
        }
        return error.localizedDescription
    }
}
