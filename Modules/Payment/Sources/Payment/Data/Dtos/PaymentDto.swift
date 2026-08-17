import Foundation

public struct PaymentIntentionDTO: Codable {
    public let clientSecret: String

    enum CodingKeys: String, CodingKey {
        case clientSecret = "client_secret"
    }
}

extension PaymentIntentionDTO {
    func mapToPaymentIntention(specialReference: String) -> PaymentIntention {
        PaymentIntention(
            clientSecret: clientSecret,
            publicKey: PaymentConfig.publicKey,
            specialReference: specialReference
        )
    }
}

public struct AuthTokenDTO: Codable {
    public let token: String
}

/// Only the fields needed to decide whether a transaction actually settled — Paymob's inquiry
/// response is very large and the rest is irrelevant here.
public struct TransactionInquiryDTO: Codable {
    public let success: Bool?
    public let pending: Bool?
    public let isVoided: Bool?
    public let isRefunded: Bool?

    enum CodingKeys: String, CodingKey {
        case success, pending
        case isVoided = "is_voided"
        case isRefunded = "is_refunded"
    }

    public var isSettled: Bool {
        (success ?? false)
            && !(pending ?? false)
            && !(isVoided ?? false)
            && !(isRefunded ?? false)
    }
}
