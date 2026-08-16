import Foundation
import Common

protocol CoursesRemoteDataSourceProtocol {
    func fetchCourses() async throws -> [CourseDTO]
    func createCourse(requestDTO: CreateCourseRequestDTO) async throws -> CourseDTO
    func createMaterialCourse(requestDTO: CreateMaterialCourseRequestDTO) async throws -> CourseDTO
    func updateCourse(id: String, requestDTO: UpdateCourseRequestDTO) async throws -> CourseDTO
    func deleteCourse(id: String) async throws
    func createMaterial(courseId: String, requestDTO: CreateMaterialRequestDTO) async throws -> MaterialDTO
    func listMaterials(courseId: String) async throws -> [MaterialDTO]
    func deleteMaterial(courseId: String, materialId: String) async throws
}

final class CoursesRemoteDataSource: CoursesRemoteDataSourceProtocol {

    func fetchCourses() async throws -> [CourseDTO] {
        do {
            return try await NetworkManger.shared.request(
                endpoint: CoursesEndPoint.listCourses,
                responseType: [CourseDTO].self
            )
        } catch {
            let response = try await NetworkManger.shared.request(
                endpoint: CoursesEndPoint.listCourses,
                responseType: CoursesListResponseDTO.self
            )
            return response.courses ?? []
        }
    }

    func createCourse(requestDTO: CreateCourseRequestDTO) async throws -> CourseDTO {
        let body = try JSONEncoder().encode(requestDTO)
        let (data, _) = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.createCourse(body: body)
        )

        do {
            let response = try JSONDecoder().decode(CreateCourseResponseDTO.self, from: data)
            if let course = response.course, course.id != nil {
                return course
            }
        } catch {}

        do {
            let directCourse = try JSONDecoder().decode(CourseDTO.self, from: data)
            if directCourse.id != nil {
                return directCourse
            }
        } catch {}

        let str = String(data: data, encoding: .utf8) ?? "Unreadable data"
        throw NSError(domain: "CreateCourse", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response: \(str)"])
    }

    func createMaterialCourse(requestDTO: CreateMaterialCourseRequestDTO) async throws -> CourseDTO {
        let body = try JSONEncoder().encode(requestDTO)
        let (data, _) = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.createCourse(body: body)
        )

        do {
            let response = try JSONDecoder().decode(CreateCourseResponseDTO.self, from: data)
            if let course = response.course, course.id != nil {
                return course
            }
        } catch {}

        do {
            let directCourse = try JSONDecoder().decode(CourseDTO.self, from: data)
            if directCourse.id != nil {
                return directCourse
            }
        } catch {}

        let str = String(data: data, encoding: .utf8) ?? "Unreadable data"
        throw NSError(domain: "CreateMaterialCourse", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response: \(str)"])
    }

    func updateCourse(id: String, requestDTO: UpdateCourseRequestDTO) async throws -> CourseDTO {
        let body = try JSONEncoder().encode(requestDTO)
        let (data, _) = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.updateCourse(id: id, body: body)
        )

        do {
            let response = try JSONDecoder().decode(CreateCourseResponseDTO.self, from: data)
            if let course = response.course, course.id != nil {
                return course
            }
        } catch {}

        do {
            let directCourse = try JSONDecoder().decode(CourseDTO.self, from: data)
            if directCourse.id != nil {
                return directCourse
            }
        } catch {}

        let str = String(data: data, encoding: .utf8) ?? "Unreadable data"
        throw NSError(domain: "UpdateCourse", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response: \(str)"])
    }

    func deleteCourse(id: String) async throws {
        let _ = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.deleteCourse(id: id)
        )
    }

    // Step 1: Create material metadata (JSON)
    func createMaterial(courseId: String, requestDTO: CreateMaterialRequestDTO) async throws -> MaterialDTO {
        let body = try JSONEncoder().encode(requestDTO)
        let (data, _) = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.createMaterial(courseId: courseId, body: body)
        )

        do {
            let response = try JSONDecoder().decode(AddMaterialResponseDTO.self, from: data)
            if let material = response.material, material.id != nil {
                return material
            }
        } catch {}

        do {
            let material = try JSONDecoder().decode(MaterialDTO.self, from: data)
            if material.id != nil {
                return material
            }
        } catch {
            print("Failed to decode MaterialDTO from createMaterial: \(error)")
        }

        let str = String(data: data, encoding: .utf8) ?? "Unreadable data"
        throw NSError(domain: "CreateMaterial", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response: \(str)"])
    }


    func listMaterials(courseId: String) async throws -> [MaterialDTO] {
        do {
            return try await NetworkManger.shared.request(
                endpoint: CoursesEndPoint.listMaterials(courseId: courseId),
                responseType: [MaterialDTO].self
            )
        } catch {
            let response = try await NetworkManger.shared.request(
                endpoint: CoursesEndPoint.listMaterials(courseId: courseId),
                responseType: MaterialsListResponseDTO.self
            )
            return response.materials ?? []
        }
    }

    func deleteMaterial(courseId: String, materialId: String) async throws {
        let _ = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.deleteMaterial(courseId: courseId, materialId: materialId)
        )
    }
}

enum CoursesError: Error, LocalizedError {
    case invalidResponse
    case materialUploadFailed
    case materialCreationFailed
    case courseCreationFailed
    case imageUploadFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response from server"
        case .materialUploadFailed: return "Failed to upload material"
        case .materialCreationFailed: return "Failed to create material"
        case .courseCreationFailed: return "Failed to create course"
        case .imageUploadFailed: return "Failed to upload image"
        }
    }
}
