import Foundation

public protocol PaymentRepositoryProtocol {
    func createIntention(plan: SubscriptionPlan) async throws -> PaymentIntention
    /// Asks Paymob whether the transaction behind `reference` actually settled. Used when the SDK
    /// reports a non-definitive outcome (cancelled/pending) that may still have been paid.
    func verifyTransaction(reference: String) async throws -> Bool
    func saveSubscription(plan: SubscriptionPlan, purchaseDate: Date) -> ActiveSubscription
    func currentSubscription() -> ActiveSubscription?
}
