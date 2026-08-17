import Foundation

public class GetSubscriptionStatusUseCase {
    private let repository: PaymentRepositoryProtocol

    public init(repository: PaymentRepositoryProtocol = PaymentRepository()) {
        self.repository = repository
    }

    public func execute() -> Bool {
        repository.currentSubscription()?.isActive ?? false
    }

    public func currentSubscription() -> ActiveSubscription? {
        repository.currentSubscription()
    }
}
