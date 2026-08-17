import Foundation

public class FetchSubscriptionPlansUseCase {
    public init() {}

    public func execute() -> [SubscriptionPlan] {
        SubscriptionPlanCatalog.all
    }
}
