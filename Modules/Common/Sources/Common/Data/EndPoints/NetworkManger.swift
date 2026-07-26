import Foundation

public struct APIError: Error {
    public let statusCode: Int
    public let message: String

    public var localizedDescription: String { message }
}

private struct ServerErrorBody: Decodable {
    let message: String?
    let error: String?
    var resolved: String { message ?? error ?? "Something went wrong, please try again." }
}

public class NetworkManger {
    public static let shared = NetworkManger()
    private init() {}

    public func request<T: Codable>(endpoint: EndPoint, responseType: T.Type) async throws -> T {
        let (data, statusCode) = try await performRequest(endpoint: endpoint)

        guard (200...299).contains(statusCode) else {
            throw buildAPIError(from: data, statusCode: statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw server response: \(jsonString)")
            }
            print("Decoding error in request: \(error)")
            throw APIError(statusCode: statusCode, message: "Parsing Error: \(error.localizedDescription)")
        }
    }

    public func requestWithStatus<T: Codable>(endpoint: EndPoint, responseType: T.Type) async throws -> (decoded: T, statusCode: Int) {
        let (data, statusCode) = try await performRequest(endpoint: endpoint)

        guard (200...299).contains(statusCode) else {
            throw buildAPIError(from: data, statusCode: statusCode)
        }
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return (decoded, statusCode)
        } catch {
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw server response: \(jsonString)")
            }
            print("Decoding error in requestWithStatus: \(error)")
            throw APIError(statusCode: statusCode, message: "Parsing Error: \(error.localizedDescription)")
        }
    }

    private func performRequest(endpoint: EndPoint) async throws -> (Data, Int) {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        return (data, statusCode)
    }

    private func buildAPIError(from data: Data, statusCode: Int) -> APIError {
        if let body = try? JSONDecoder().decode(ServerErrorBody.self, from: data) {
            return APIError(statusCode: statusCode, message: body.resolved)
        }
        return APIError(statusCode: statusCode, message: HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)
    }
}
