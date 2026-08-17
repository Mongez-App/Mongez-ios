//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation

public struct TeamCourseDTO: Codable {
    public let id: String?
    public let name: String?
    public let imageUrl: String?
    public let isHidden: Bool?
}

public extension TeamCourseDTO {
    func toDomain() -> TeamCourse {
        return TeamCourse(
            id: id ?? "",
            name: name ?? "",
            imageUrl: imageUrl,
            isHidden: isHidden ?? false
        )
    }
}
