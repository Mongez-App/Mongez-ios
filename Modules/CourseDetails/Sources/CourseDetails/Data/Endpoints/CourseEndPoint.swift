//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Foundation
import Common

public enum CourseEndPoint: EndPoint {
    case getCourse(courseId: String)
    case updateCourse(courseId: String, payload: Data)
    case deleteCourse(courseId: String)
    case deleteMaterial(courseId: String, materialId: String)
    
    public var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .getCourse(let courseId),
             .updateCourse(let courseId, _),
             .deleteCourse(let courseId):
            return "/courses/\(courseId)"
        case .deleteMaterial(let courseId, let materialId):
            return "/courses/\(courseId)/materials/\(materialId)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getCourse: return .get
        case .updateCourse: return .patch
        case .deleteCourse, .deleteMaterial: return .delete
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
        case .getCourse, .deleteCourse, .deleteMaterial:
            return nil
        case .updateCourse(_, let payload):
            return payload
        }
    }
}
