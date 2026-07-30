//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation
public struct UpdateCourseRequestDTO: Encodable {
    public let name: String?
    public let image_url: String?
    public let is_hidden: Bool?
    
    public init(name: String? = nil, image_url: String? = nil, is_hidden: Bool? = nil) {
        self.name = name
        self.image_url = image_url
        self.is_hidden = is_hidden
    }
}
