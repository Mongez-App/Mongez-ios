//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation

public struct Course {
    public let id: String
    public let name: String
    public let imageUrl: String?
    public let isHidden: Bool
    
    public init(id: String, name: String, imageUrl: String?, isHidden: Bool) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.isHidden = isHidden
    }
}
