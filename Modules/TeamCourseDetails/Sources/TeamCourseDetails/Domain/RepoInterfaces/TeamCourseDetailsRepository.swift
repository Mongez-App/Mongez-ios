//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import Common

public protocol TeamCourseDetailsRepository {
    func getMaterials(courseId: String, organizationId: String) async throws -> [TeamCourseMaterial]
    func getTasks(courseId: String) async throws -> [TeamCourseTask]
}
