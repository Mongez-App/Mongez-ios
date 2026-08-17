import Foundation
import Common
public enum PaymentConfig {
    // Real values live in PaymentSecrets.swift, which is gitignored — see PaymentSecrets.swift.example.
    public static let secretKey = PaymentSecrets.secretKey
    public static let publicKey = PaymentSecrets.publicKey
    public static let apiKey = PaymentSecrets.apiKey
    public static let cardIntegrationID = PaymentSecrets.cardIntegrationID
    public static let walletIntegrationID = PaymentSecrets.walletIntegrationID

    public static var paymentMethods: [Int] {
        [cardIntegrationID]
    }
}

public enum PaymentEndpoint: EndPoint {
    case createIntention(plan: SubscriptionPlan, specialReference: String)
    case authToken
    case transactionInquiry(authToken: String, merchantOrderId: String)

    public var baseURL: String {
        "https://accept.paymob.com"
    }

    public var path: String {
        switch self {
        case .createIntention:
            return "/v1/intention/"
        case .authToken:
            return "/api/auth/tokens"
        case .transactionInquiry:
            return "/api/ecommerce/orders/transaction_inquiry"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .createIntention, .authToken, .transactionInquiry:
            return .post
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .createIntention:
            return [
                "Content-Type": "application/json",
                "Authorization": "Token \(PaymentConfig.secretKey)"
            ]
        case .authToken, .transactionInquiry:
            // These authenticate via a body field (api_key / auth_token), not a header.
            return ["Content-Type": "application/json"]
        }
    }

    public var body: Data? {
        switch self {
        case .createIntention(let plan, let specialReference):
            let amountCents = Int((plan.priceEGP * 100).rounded())
            let payload = CreateIntentionRequest(
                amount: amountCents,
                currency: "EGP",
                paymentMethods: PaymentConfig.paymentMethods,
                items: [
                    CreateIntentionRequest.Item(
                        name: "\(plan.displayName) Subscription",
                        amount: amountCents,
                        description: "\(plan.displayName) subscription plan",
                        quantity: 1
                    )
                ],
                billingData: .placeholder,
                specialReference: specialReference
            )
            return try? JSONEncoder().encode(payload)

        case .authToken:
            return try? JSONEncoder().encode(AuthTokenRequest(apiKey: PaymentConfig.apiKey))

        case .transactionInquiry(let authToken, let merchantOrderId):
            return try? JSONEncoder().encode(
                TransactionInquiryRequest(authToken: authToken, merchantOrderId: merchantOrderId)
            )
        }
    }
}

private struct AuthTokenRequest: Encodable {
    let apiKey: String

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

private struct TransactionInquiryRequest: Encodable {
    let authToken: String
    let merchantOrderId: String

    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case merchantOrderId = "merchant_order_id"
    }
}

private struct CreateIntentionRequest: Encodable {
    let amount: Int
    let currency: String
    let paymentMethods: [Int]
    let items: [Item]
    let billingData: PaymentBillingData
    let specialReference: String

    enum CodingKeys: String, CodingKey {
        case amount, currency, items
        case paymentMethods = "payment_methods"
        case billingData = "billing_data"
        case specialReference = "special_reference"
    }

    struct Item: Encodable {
        let name: String
        let amount: Int
        let description: String
        let quantity: Int
    }
}

// Paymob's Create Intention API requires billing_data even for digital goods with no shipping —
// there's no shared user/billing entity across modules, so this uses generic placeholder values,
// matching Paymob's own documented example payload.
private struct PaymentBillingData: Encodable {
    let firstName: String
    let lastName: String
    let street: String
    let building: String
    let floor: String
    let apartment: String
    let city: String
    let state: String
    let country: String
    let phoneNumber: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case street, building, floor, apartment, city, state, country
        case phoneNumber = "phone_number"
        case email
    }

    static let placeholder = PaymentBillingData(
        firstName: "NA",
        lastName: "NA",
        street: "NA",
        building: "NA",
        floor: "NA",
        apartment: "NA",
        city: "NA",
        state: "NA",
        country: "NA",
        phoneNumber: "+201000000000",
        email: "test@example.com"
    )
}
