//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation
import Common

public enum RoadmapEndpoints: EndPoint {
    case roadmap(method: HTTPMethod, path: String)
    case event(method: HTTPMethod, path: String, event: Event)
    case courses(method: HTTPMethod, path: String)
    
    public var idToken: String? {
        UserDefaults.standard.string(forKey: "main_token")
    }
    
    public var baseURL: String {
        "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self{
        case.roadmap(_, let pathValue):
            return pathValue
            
        case.event(_, let pathValue, _):
            return pathValue
            
        case.courses(_, let pathValue):
            return pathValue
        }
    }
    
    public var method: HTTPMethod {
        switch self{
        case.roadmap(let methodValue, _):
            return methodValue
            
        case.event(let methodValue, _, _):
            return methodValue
            
        case.courses(let methodValue, _):
            return methodValue
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(idToken ?? "")"
        ]
    }
    
    public var body: Data? {
        switch self{
        case.roadmap(_, _):
            return nil
            
        case .event(_, _, let event):
            let bodyParams: [String: String] = [
                "title": event.title,
                "event_type": event.eventType.uppercased(),
                "event_date": event.eventDate
            ]
            return try? JSONSerialization.data(withJSONObject: bodyParams)
            
        case.courses(_, _):
            return nil
        }
    }
    
    
}

