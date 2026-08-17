import Foundation
import Common

enum TeamCoursesEndPoint: EndPoint {
    case getTeamCourses(teamId: String, organizationId: String)
    case getTeamEvents(teamId: String, organizationId: String)
    
    var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1/"
    }
    
    var path: String {
        switch self {
        case .getTeamCourses(let teamId, _):
            return "teams/\(teamId)/courses"
        case .getTeamEvents(let teamId, _):
            return "teams/team/\(teamId)/events"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [
            "Content-Type": "application/json"
        ]
        
        if let userId = UserDefaults.standard.string(forKey: "current_user_id") {
            headers["x-user-id"] = userId
            headers["X-User-Id"] = userId
        }
        
        if let token = UserDefaults.standard.string(forKey: "main_token") {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    var body: Data? {
        return nil
    }
}
