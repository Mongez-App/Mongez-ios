//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

public struct ChatHistoryResponseDTO: Decodable {
    public let pagination: PaginationDTO
    public let messages: [ChatMessageDTO]
}
