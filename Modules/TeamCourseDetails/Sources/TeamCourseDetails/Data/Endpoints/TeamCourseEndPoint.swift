//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Foundation
import Common

public enum TeamCourseEndPoint: EndPoint {
    case getTeamCourse(courseId: String)
    case updateTeamCourse(courseId: String, payload: Data)
    case deleteTeamCourse(courseId: String)
    case deleteMaterial(courseId: String, materialId: String)
    
    public var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .getTeamCourse(let courseId),
             .updateTeamCourse(let courseId, _),
             .deleteTeamCourse(let courseId):
            return "/courses/\(courseId)"
        case .deleteMaterial(let courseId, let materialId):
            return "/courses/\(courseId)/materials/\(materialId)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getTeamCourse: return .get
        case .updateTeamCourse: return .patch
        case .deleteTeamCourse, .deleteMaterial: return .delete
        }
    }
    
    public var headers: [String: String]? {
        let userId = UserDefaults.standard.string(forKey: "current_user_id") ?? ""
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-User-Id": userId
        ]
    }
    
    public var body: Data? {
        switch self {
        case .getTeamCourse, .deleteTeamCourse, .deleteMaterial:
            return nil
        case .updateTeamCourse(_, let payload):
            return payload
        }
    }
}
