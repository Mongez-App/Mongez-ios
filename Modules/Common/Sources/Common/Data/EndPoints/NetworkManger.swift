//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public class NetworkManger {
    public static let shared = NetworkManger()
    private init() {}
    
    public func request<T:Codable>(endpoint : EndPoint,responseType : T.Type) async throws -> T {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...300).contains(httpResponse.statusCode) else{
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let body = String(data: data, encoding: .utf8) ?? "no body"
            print("❌ API Error [\(endpoint.path)] status: \(statusCode) body: \(body)")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
