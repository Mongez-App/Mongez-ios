import Foundation
import Common

public enum DashboardEndpoints : EndPoint {
    case dashboard(method: HTTPMethod, path: String)
    case user(method: HTTPMethod, path: String)
    case delayed(method: HTTPMethod, path: String, body: Data?)

    public var baseURL: String {
        switch self {
        case .dashboard:
            return "https://course-import-service.vercel.app/api/v1/"
        case .user:
            return "https://api-gateway-production-3fd0.up.railway.app/api/v1/"
        case .delayed:
            return "https://course-import-service.vercel.app/api/v1/"
        }
    }

    public var path: String {
        switch self {
        case .dashboard(_, let pathValue), .user(_, let pathValue), .delayed(_, let pathValue, _):
            return pathValue
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .dashboard(let methodValue, _), .user(let methodValue, _), .delayed(let methodValue, _, _):
            return methodValue
        }
    }

    public var headers: [String : String]? {
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        switch self {
        case .user, .dashboard, .delayed:
            if let userId = SessionManager.userId {
                headers["x-user-id"] = userId
                headers["X-User-Id"] = userId
            }
            if let auth = SessionManager.authorizationHeader {
                headers["Authorization"] = auth["Authorization"]
            }
        }

        return headers
    }

    public var body: Data? {
        switch self {
        case .delayed(_, _, let bodyValue):
            return bodyValue
        case .dashboard, .user:
            return nil
        }
    }
}