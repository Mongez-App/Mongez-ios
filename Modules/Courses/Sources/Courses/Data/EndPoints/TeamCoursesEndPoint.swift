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
            return "organization/getCourses?teamId=\(teamId)"
        case .getTeamEvents(let teamId, _):
            return "organization/getEvents?teamId=\(teamId)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        var headers: [String: String] = [
            "Content-Type": "application/json"
        ]
        
        switch self {
        case .getTeamCourses(_, let orgId), .getTeamEvents(_, let orgId):
            headers["x-user-id"] = orgId
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
