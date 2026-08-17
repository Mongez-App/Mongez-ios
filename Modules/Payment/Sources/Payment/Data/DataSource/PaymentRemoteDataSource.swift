import Foundation
import Common

public protocol PaymentRemoteDataSourceProtocol {
    func createIntention(plan: SubscriptionPlan, specialReference: String) async throws -> PaymentIntentionDTO
    func fetchAuthToken() async throws -> AuthTokenDTO
    func inquireTransaction(authToken: String, merchantOrderId: String) async throws -> TransactionInquiryDTO
}

// Deliberately does not go through Common.NetworkManger: NetworkManger auto-logs the user out of the
// app on any 401 whose path doesn't contain "/auth", which would misfire on a bad/placeholder Paymob
// secret key and wipe an unrelated, already-authenticated session. This talks to Paymob's own domain
// directly instead, using the same EndPoint-enum config style as the rest of the app.
public class PaymentRemoteDataSource: PaymentRemoteDataSourceProtocol {
    public init() {}

    public func createIntention(plan: SubscriptionPlan, specialReference: String) async throws -> PaymentIntentionDTO {
        try await perform(
            endpoint: PaymentEndpoint.createIntention(plan: plan, specialReference: specialReference),
            responseType: PaymentIntentionDTO.self
        )
    }

    public func fetchAuthToken() async throws -> AuthTokenDTO {
        try await perform(endpoint: PaymentEndpoint.authToken, responseType: AuthTokenDTO.self)
    }

    public func inquireTransaction(authToken: String, merchantOrderId: String) async throws -> TransactionInquiryDTO {
        try await perform(
            endpoint: PaymentEndpoint.transactionInquiry(authToken: authToken, merchantOrderId: merchantOrderId),
            responseType: TransactionInquiryDTO.self
        )
    }

    private func perform<T: Decodable>(endpoint: EndPoint, responseType: T.Type) async throws -> T {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        guard (200...299).contains(statusCode) else {
            let rawResponse = String(data: data, encoding: .utf8) ?? "unknown"
            throw APIError(statusCode: statusCode, message: "Paymob request to \(endpoint.path) failed: \(rawResponse)")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            let rawResponse = String(data: data, encoding: .utf8) ?? "unknown"
            throw APIError(statusCode: statusCode, message: "Parsing Error: \(error.localizedDescription) | Raw: \(rawResponse)")
        }
    }
}
