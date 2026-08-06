import Foundation
import Common

public enum RoadmapEndpoints: EndPoint {
    case roadmap(method: HTTPMethod, path: String)
    case event(method: HTTPMethod, path: String)
    case courses(method: HTTPMethod, path: String)
    case createEvent(method: HTTPMethod, path: String, body: Data)

    public var baseURL: String {
        "https://course-import-service.vercel.app/api/v1/"
    }

    public var path: String {
        switch self{
        case .roadmap(_, let pathValue):
            return pathValue
        case .event(_, let pathValue):
            return pathValue
        case .courses(_, let pathValue):
            return pathValue
        case .createEvent(_, let pathValue, _):
            return pathValue
        }
    }

    public var method: HTTPMethod {
        switch self{
        case .roadmap(let methodValue, _):
            return methodValue
        case .event(let methodValue, _):
            return methodValue
        case .courses(let methodValue, _):
            return methodValue
        case .createEvent(let methodValue, _, _):
            return methodValue
        }
    }

    public var headers: [String : String]? {
        var headers: [String: String] = [
            "Content-Type": "application/json"
        ]
        if let userId = SessionManager.userId {
            headers["x-user-id"] = userId
        }
        if let auth = SessionManager.authorizationHeader {
            headers["Authorization"] = auth["Authorization"]
        }
        return headers
    }

    public var body: Data? {
        switch self {
        case .createEvent(_, _, let body):
            return body
        default:
            return nil
        }
    }
}
