//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
public protocol CourseDetailsRepository {
    func getMaterials(courseId: String) async throws -> [CourseMaterial]
    func getTasks(courseId: String) async throws -> [CourseTask]
    func uploadMaterial(courseId: String, fileData: Data, fileName: String, contentType: String, pageCount: Int?) async throws
    func deleteMaterial(courseId: String, materialId: String) async throws
    func generateTasks(courseId: String) async throws
}