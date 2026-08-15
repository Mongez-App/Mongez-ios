//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation

public struct EndSessionRequestDTO: Encodable {
    public let task_completed: Bool
    public let completion_time: String
}
