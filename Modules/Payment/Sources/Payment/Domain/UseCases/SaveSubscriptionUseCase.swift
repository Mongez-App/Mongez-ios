import Foundation

public class SaveSubscriptionUseCase {
    private let repository: PaymentRepositoryProtocol

    public init(repository: PaymentRepositoryProtocol = PaymentRepository()) {
        self.repository = repository
    }

    public func execute(plan: SubscriptionPlan, purchaseDate: Date = Date()) -> ActiveSubscription {
        repository.saveSubscription(plan: plan, purchaseDate: purchaseDate)
    }
}
