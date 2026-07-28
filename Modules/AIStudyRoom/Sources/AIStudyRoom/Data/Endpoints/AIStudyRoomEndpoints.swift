import Foundation
import Common

public enum AIStudyRoomEndpoints: EndPoint {
    case query(body: Data)
    case getChatHistory(courseId: String)

    public var baseURL: String {
        "https://course-import-service.vercel.app/api/v1/"
    }

    public var path: String {
        switch self {
        case .query:
            return "rag/query"
        case .getChatHistory(let courseId):
            return "rag/courses/\(courseId)/chat"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .query:
            return .post
        case .getChatHistory:
            return .get
        }
    }

    public var headers: [String: String]? {
        var headers: [String: String] = [
            "Content-Type": "application/json"
        ]
        if let userId = UserDefaults.standard.string(forKey: "current_user_id") {
            headers["x-user-id"] = userId
        }
        return headers
    }

    public var body: Data? {
        switch self {
        case .query(let body):
            return body
        default:
            return nil
        }
    }
}
