import Foundation

public class PaymentRepository: PaymentRepositoryProtocol {
    private let remote: PaymentRemoteDataSourceProtocol
    private let localStore: SubscriptionLocalStore

    public init(
        remote: PaymentRemoteDataSourceProtocol = PaymentRemoteDataSource(),
        localStore: SubscriptionLocalStore = SubscriptionLocalStore()
    ) {
        self.remote = remote
        self.localStore = localStore
    }

    public func createIntention(plan: SubscriptionPlan) async throws -> PaymentIntention {
        let specialReference = "\(plan.id)-\(UUID().uuidString)"
        let dto = try await remote.createIntention(plan: plan, specialReference: specialReference)
        return dto.mapToPaymentIntention(specialReference: specialReference)
    }

    public func verifyTransaction(reference: String) async throws -> Bool {
        let auth = try await remote.fetchAuthToken()
        let inquiry = try await remote.inquireTransaction(authToken: auth.token, merchantOrderId: reference)
        return inquiry.isSettled
    }

    public func saveSubscription(plan: SubscriptionPlan, purchaseDate: Date) -> ActiveSubscription {
        let expiryDate = Calendar.current.date(byAdding: .day, value: plan.durationInDays, to: purchaseDate) ?? purchaseDate
        localStore.save(planType: plan.type, purchaseDate: purchaseDate, expiryDate: expiryDate)
        return ActiveSubscription(planType: plan.type, purchaseDate: purchaseDate, expiryDate: expiryDate)
    }

    public func currentSubscription() -> ActiveSubscription? {
        localStore.loadActiveSubscription()
    }
}
