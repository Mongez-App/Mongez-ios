import Foundation

public enum PlanType: String, CaseIterable, Codable {
    case daily
    case monthly
    case yearly
}

public struct SubscriptionPlan: Identifiable, Equatable {
    public let id: String
    public let type: PlanType
    public let priceEGP: Double
    public let durationInDays: Int

    public init(id: String, type: PlanType, priceEGP: Double, durationInDays: Int) {
        self.id = id
        self.type = type
        self.priceEGP = priceEGP
        self.durationInDays = durationInDays
    }

    public var displayName: String {
        switch type {
        case .daily: return "Daily"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }

    public var formattedPrice: String {
        "\(Int(priceEGP)) EGP"
    }
}

public enum SubscriptionPlanCatalog {
    // PLACEHOLDER — replace with real pricing before shipping.
    public static let all: [SubscriptionPlan] = [
        SubscriptionPlan(id: "daily", type: .daily, priceEGP: 19, durationInDays: 1),
        SubscriptionPlan(id: "monthly", type: .monthly, priceEGP: 149, durationInDays: 30),
        SubscriptionPlan(id: "yearly", type: .yearly, priceEGP: 999, durationInDays: 365)
    ]
}
