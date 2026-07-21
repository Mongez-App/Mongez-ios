//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation

public struct CourseMaterialDTO: Decodable {
    public let material_id: String
    public let name: String
    public let page_count: Int
    public let file_size_mb: Double
    public let status: String
    public let uploaded_at: String
}

public extension CourseMaterialDTO {
    func toDomain() -> CourseMaterial {
        return CourseMaterial(
            id: material_id,
            name: name,
            pageCount: page_count,
            fileSizeMB: file_size_mb
        )
    }
}
