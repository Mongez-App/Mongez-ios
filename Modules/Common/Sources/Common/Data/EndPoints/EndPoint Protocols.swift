//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public enum HTTPMethod : String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}
public protocol EndPoint {
    var baseURL : String { get }
    var path    : String { get }
    var method  : HTTPMethod { get }
    var headers : [String : String]? { get }
    var body    : Data? { get }
    
}
