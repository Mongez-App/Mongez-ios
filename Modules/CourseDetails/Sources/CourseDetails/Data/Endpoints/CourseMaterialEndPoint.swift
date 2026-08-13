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
    case initializeUpload(courseId: String, payload: Data)
    case uploadFile(materialId: String, payload: Data, boundary: String)
    
    public var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .getMaterials(let courseId), .initializeUpload(let courseId, _):
            return "/courses/\(courseId)/materials"
        case .uploadFile(let materialId, _, _):
            return "/upload/\(materialId)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getMaterials:
            return .get
        case .initializeUpload, .uploadFile:
            return .post
        }
    }
    
    public var headers: [String: String]? {
        let userId = UserDefaults.standard.string(forKey: "current_user_id") ?? ""
        
        switch self {
        case .getMaterials, .initializeUpload:
            return [
                "Content-Type": "application/json",
                "X-User-Id": userId
            ]
        case .uploadFile(_, _, let boundary):
            return [
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "X-User-Id": userId
            ]
        }
    }
    
    public var body: Data? {
        switch self {
        case .getMaterials:
            return nil
        case .initializeUpload(_, let payload), .uploadFile(_, let payload, _):
            return payload
        }
    }
}
