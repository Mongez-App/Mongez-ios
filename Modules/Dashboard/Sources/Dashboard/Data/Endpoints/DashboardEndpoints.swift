import Foundation
import Common

public enum DashboardEndpoints : EndPoint {
    case dashboard(method: HTTPMethod, path: String)
    case user(method: HTTPMethod, path: String)

    public var baseURL: String {
        switch self {
        case .dashboard:
            return "https://course-import-service.vercel.app/api/v1/"
        case .user:
            return "https://api-gateway-production-3fd0.up.railway.app/api/v1/"
        }
    }

    public var path: String {
        switch self {
        case .dashboard(_, let pathValue):
            return pathValue
        case .user(_, let pathValue):
            return pathValue
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .dashboard(let methodValue, _):
            return methodValue
        case .user(let methodValue, _):
            return methodValue
        }
    }

    public var headers: [String : String]? {
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        switch self {
        case .user:
            if let token = UserDefaults.standard.string(forKey: "main_token") {
                headers["Authorization"] = "Bearer \(token)"
            }
            headers["x-user-id"] = UserDefaults.standard.string(forKey: "current_user_id") ?? ""
            headers["X-User-Id"] = UserDefaults.standard.string(forKey: "current_user_id") ?? ""
        case .dashboard:
            if let userId = UserDefaults.standard.string(forKey: "current_user_id") {
                headers["x-user-id"] = userId
            }
        }

        return headers
    }

    public var body: Data? {
        nil
    }
}
