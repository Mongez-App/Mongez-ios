//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation
import Common

public enum ChatEndPoint: EndPoint {
    case updateTask(taskId: String, request: UpdateTaskRequestDTO)
    case sendMessage(taskId: String, request: SendMessageRequestDTO)
    case getMessages(taskId: String, page: Int, size: Int)
    
    public var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .updateTask(let taskId, _):
            return "/tasks/\(taskId)"
        case .sendMessage(let taskId, _):
            return "/tasks/\(taskId)/chat"
        case .getMessages(let taskId, let page, let size):
            return "/tasks/\(taskId)/chat/messages?page=\(page)&size=\(size)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getMessages: return .get
        case .updateTask: return .patch
        default: return .post
        }
    }
    
    public var headers: [String: String]? {
        let userId = UserDefaults.standard.string(forKey: "current_user_id") ?? ""
        return [
            "Content-Type": "application/json",
            "X-User-Id": userId
        ]
    }
    
    public var body: Data? {
        switch self {
        case .updateTask(_, let request):
            return try? JSONEncoder().encode(request)
        case .sendMessage(_, let request):
            return try? JSONEncoder().encode(request)
        case .getMessages:
            return nil
        }
    }
}
