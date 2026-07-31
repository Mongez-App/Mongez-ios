//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation

public struct CourseDTO: Codable {
    public let id: String?
    public let name: String?
    public let imageUrl: String?
    public let isHidden: Bool?
}

public extension CourseDTO {
    func toDomain() -> Course {
        return Course(
            id: id ?? "",
            name: name ?? "",
            imageUrl: imageUrl,
            isHidden: isHidden ?? false
        )
    }
}
