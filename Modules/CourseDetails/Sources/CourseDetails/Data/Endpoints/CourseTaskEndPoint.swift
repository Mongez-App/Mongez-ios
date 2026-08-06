//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation
import Common

public enum CourseTaskEndPoint: EndPoint {
    case getTasks(courseId: String)
    
    public var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .getTasks(let courseId):
            return "/courses/\(courseId)/tasks"
        }
    }
    
    public var method: HTTPMethod {
        return .get
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
        return nil
    }
}
