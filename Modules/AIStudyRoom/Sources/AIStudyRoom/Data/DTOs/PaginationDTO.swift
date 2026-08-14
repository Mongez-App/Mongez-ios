//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation

public struct PaginationDTO: Decodable {
    public let page: Int
    public let size: Int
    public let has_next: Bool
}
