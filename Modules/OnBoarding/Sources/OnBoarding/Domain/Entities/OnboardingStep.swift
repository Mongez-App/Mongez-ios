//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 17/07/2026.
//

import Foundation

public struct OnboardingStep :Identifiable{
    public let id = UUID()
    public let image : String
    public let title : String
    public let descreption : String
    
    public init(image: String, title: String, descreption: String) {
        self.image = image
        self.title = title
        self.descreption = descreption
    }
}
