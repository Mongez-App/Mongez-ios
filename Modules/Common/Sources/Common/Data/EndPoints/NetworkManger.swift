import Foundation

public struct APIError: Error, LocalizedError {
    public let statusCode: Int
    public let message: String

    public var errorDescription: String? { message }
}

private struct ServerErrorBody: Decodable {
    let message: String?
    let error: String?
    var resolved: String { message ?? error ?? "Something went wrong, please try again." }
}

public class NetworkManger {
    public static let shared = NetworkManger()
    private init() {}

    public func request<T: Decodable>(endpoint: EndPoint, responseType: T.Type) async throws -> T {
        let (data, statusCode) = try await performRequest(endpoint: endpoint)

        guard (200...299).contains(statusCode) else {
            throw buildAPIError(from: data, statusCode: statusCode, endpoint: endpoint)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            let rawResponse = String(data: data, encoding: .utf8) ?? "unknown"
            print("Raw server response: \(rawResponse)")
            throw APIError(statusCode: statusCode, message: "Parsing Error: \(error.localizedDescription) | Raw: \(rawResponse)")
        }
    }

    public func requestWithStatus<T: Decodable>(endpoint: EndPoint, responseType: T.Type) async throws -> (decoded: T, statusCode: Int) {
        let (data, statusCode) = try await performRequest(endpoint: endpoint)

        guard (200...299).contains(statusCode) else {
            throw buildAPIError(from: data, statusCode: statusCode, endpoint: endpoint)
        }
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return (decoded, statusCode)
        } catch {
            let rawResponse = String(data: data, encoding: .utf8) ?? "unknown"
            print("Raw server response: \(rawResponse)")
            throw APIError(statusCode: statusCode, message: "Parsing Error: \(error.localizedDescription) | Raw: \(rawResponse)")
        }
    }

    public func requestRaw(endpoint: EndPoint) async throws -> (Data, Int) {
        let (data, statusCode) = try await performRequest(endpoint: endpoint)
        guard (200...299).contains(statusCode) else {
            throw buildAPIError(from: data, statusCode: statusCode, endpoint: endpoint)
        }
        return (data, statusCode)
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
        
        if statusCode == 401 && !endpoint.path.contains("/auth") {
            await MainActor.run {
                UserDefaults.standard.removeObject(forKey: "current_user_id")
                UserDefaults.standard.removeObject(forKey: "main_token")
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
            }
        }
        
        return (data, statusCode)
    }

    private func buildAPIError(from data: Data, statusCode: Int, endpoint: EndPoint) -> APIError {
        if let body = try? JSONDecoder().decode(ServerErrorBody.self, from: data) {
            return APIError(statusCode: statusCode, message: "[\(endpoint.path)] \(body.resolved)")
        }
        return APIError(statusCode: statusCode, message: "[\(endpoint.path)] " + HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)
    }
}
