import Foundation

public struct ActiveSubscription: Equatable {
    public let planType: PlanType
    public let purchaseDate: Date
    public let expiryDate: Date

    public init(planType: PlanType, purchaseDate: Date, expiryDate: Date) {
        self.planType = planType
        self.purchaseDate = purchaseDate
        self.expiryDate = expiryDate
    }

    public var isActive: Bool {
        expiryDate > Date()
    }
}

public struct PaymentIntention: Equatable {
    public let clientSecret: String
    public let publicKey: String
    /// Our own per-purchase reference (Paymob's `merchant_order_id`), used to look the
    /// transaction up afterwards if the SDK never reports a definitive result.
    public let specialReference: String

    public init(clientSecret: String, publicKey: String, specialReference: String) {
        self.clientSecret = clientSecret
        self.publicKey = publicKey
        self.specialReference = specialReference
    }
}
