//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

public struct ChatMessage: Identifiable {
    public let id: String
    public let role: ChatRole
    public let content: String
    public let createdAt: Date
}
