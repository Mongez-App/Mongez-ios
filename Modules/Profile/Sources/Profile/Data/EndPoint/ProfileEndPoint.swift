//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation
import Common

enum ProfileEndpoint: EndPoint {
    case getProfile
    
    var baseURL: String {
        return "https://api.smartstudy.app/v3"
    }
    
    var path: String {
        return "/users/me/profile"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": "Bearer <Firebase_ID_Token>",
            "Accept-Language": "en"
        ]
    }
    
    var body: Data? {
        return nil
    }
}
