//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Foundation
import Common

public enum CourseMaterialEndPoint: EndPoint {
    case getMaterials(courseId: String)
    case uploadMaterial(
        courseId: String,
        payload: Data,
        boundary: String,
        dailyStudyMinutes: Int?,
        preferredDays: String?
    )
    
    public var baseURL: String {
        return "https://api-gateway-production-3fd0.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .getMaterials(let courseId), .uploadMaterial(let courseId, _, _, _, _):
            return "/courses/\(courseId)/materials"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getMaterials:
            return .get
        case .uploadMaterial:
            return .post
        }
    }
    
    public var headers: [String: String]? {
        let userId = UserDefaults.standard.string(forKey: "current_user_id") ?? ""
        
        switch self {
        case .getMaterials:
            return [
                "Content-Type": "application/json",
                "X-User-Id": userId
            ]
        case .uploadMaterial(_, _, let boundary, let dailyStudyMinutes, let preferredDays):
            var requestHeaders = [
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "X-User-Id": userId
            ]
            
            if let minutes = dailyStudyMinutes {
                requestHeaders["X-Daily-Study-Minutes"] = "\(minutes)"
            }
            
            if let days = preferredDays {
                requestHeaders["X-Preferred-Days"] = days
            }
            
            return requestHeaders
        }
    }
    
    public var body: Data? {
        switch self {
        case .getMaterials:
            return nil
        case .uploadMaterial(_, let payload, _, _, _):
            return payload
        }
    }
}
