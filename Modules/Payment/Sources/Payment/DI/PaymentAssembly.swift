import Foundation
import Swinject
import Common

public class PaymentAssembly: DIAssembly {

    public init() {}

    public func assemble(container: Container) {
        container.register(PaymentRemoteDataSourceProtocol.self) { _ in
            PaymentRemoteDataSource()
        }

        container.register(SubscriptionLocalStore.self) { _ in
            SubscriptionLocalStore()
        }.inObjectScope(.container)

        container.register(PaymentRepositoryProtocol.self) { resolver in
            let remote = resolver.resolve(PaymentRemoteDataSourceProtocol.self)!
            let localStore = resolver.resolve(SubscriptionLocalStore.self)!
            return PaymentRepository(remote: remote, localStore: localStore)
        }

        container.register(FetchSubscriptionPlansUseCase.self) { _ in
            FetchSubscriptionPlansUseCase()
        }

        container.register(CreatePaymentIntentionUseCase.self) { resolver in
            let repository = resolver.resolve(PaymentRepositoryProtocol.self)!
            return CreatePaymentIntentionUseCase(repository: repository)
        }

        container.register(GetSubscriptionStatusUseCase.self) { resolver in
            let repository = resolver.resolve(PaymentRepositoryProtocol.self)!
            return GetSubscriptionStatusUseCase(repository: repository)
        }

        container.register(SaveSubscriptionUseCase.self) { resolver in
            let repository = resolver.resolve(PaymentRepositoryProtocol.self)!
            return SaveSubscriptionUseCase(repository: repository)
        }

        container.register(VerifyTransactionUseCase.self) { resolver in
            let repository = resolver.resolve(PaymentRepositoryProtocol.self)!
            return VerifyTransactionUseCase(repository: repository)
        }

        container.register(PaymobCheckoutPresenting.self) { _ in
            PaymobSDKAdapter()
        }

        container.register(PaymentViewModel.self) { resolver in
            PaymentViewModel(
                fetchPlansUseCase: resolver.resolve(FetchSubscriptionPlansUseCase.self)!,
                createIntentionUseCase: resolver.resolve(CreatePaymentIntentionUseCase.self)!,
                getStatusUseCase: resolver.resolve(GetSubscriptionStatusUseCase.self)!,
                saveSubscriptionUseCase: resolver.resolve(SaveSubscriptionUseCase.self)!,
                verifyTransactionUseCase: resolver.resolve(VerifyTransactionUseCase.self)!,
                checkoutPresenter: resolver.resolve(PaymobCheckoutPresenting.self)!
            )
        }
    }
}
