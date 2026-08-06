import Foundation

public struct APIError: Error, LocalizedError {
    public let statusCode: Int
    public let message: String

    public var errorDescription: String? { message }
}

private struct ServerErrorBody: Decodable {
    let message: String?
    let error: ServerErrorValue?
    var resolved: String { message ?? error?.resolved ?? "Something went wrong, please try again." }
}

/// The `error` field can be either a plain string or an object like `{ "code": ..., "message": ... }`.
private struct ServerErrorValue: Decodable {
    let code: String?
    let message: String?
    let stringValue: String?

    var resolved: String {
        if let stringValue = stringValue, !stringValue.isEmpty {
            return stringValue
        }
        return message ?? code ?? "Something went wrong, please try again."
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            code = try? container.decodeIfPresent(String.self, forKey: .code)
            message = try? container.decodeIfPresent(String.self, forKey: .message)
            stringValue = nil
        } else if let container = try? decoder.singleValueContainer() {
            stringValue = try? container.decode(String.self)
            code = nil
            message = nil
        } else {
            code = nil
            message = nil
            stringValue = nil
        }
    }

    private enum CodingKeys: String, CodingKey {
        case code
        case message
    }
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

        attachSessionTokenIfNeeded(to: &request, endpoint: endpoint)

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        
        if statusCode == 401 && !endpoint.path.contains("/auth") {
            await MainActor.run {
                SessionManager.clear()
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
            }
        }
        
        return (data, statusCode)
    }

    /// Attaches the student session token as `Authorization: Bearer <token>` to
    /// every data request unless the endpoint already sets its own `Authorization`
    /// header (e.g. login/register) or is the logout call (which must stay unauthenticated).
    private func attachSessionTokenIfNeeded(to request: inout URLRequest, endpoint: EndPoint) {
        guard !endpoint.path.contains("/logout") else { return }
        guard request.value(forHTTPHeaderField: "Authorization") == nil else { return }
        if let auth = SessionManager.authorizationHeader {
            request.setValue(auth["Authorization"], forHTTPHeaderField: "Authorization")
        }
    }

    private func buildAPIError(from data: Data, statusCode: Int, endpoint: EndPoint) -> APIError {
        if let body = try? JSONDecoder().decode(ServerErrorBody.self, from: data) {
            return APIError(statusCode: statusCode, message: "[\(endpoint.path)] \(body.resolved)")
        }
        return APIError(statusCode: statusCode, message: "[\(endpoint.path)] " + HTTPURLResponse.localizedString(forStatusCode: statusCode).capitalized)
    }
}
