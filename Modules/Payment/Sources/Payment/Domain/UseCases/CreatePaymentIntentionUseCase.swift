import Foundation

public class CreatePaymentIntentionUseCase {
    private let repository: PaymentRepositoryProtocol

    public init(repository: PaymentRepositoryProtocol = PaymentRepository()) {
        self.repository = repository
    }

    public func execute(plan: SubscriptionPlan) async throws -> PaymentIntention {
        try await repository.createIntention(plan: plan)
    }
}
