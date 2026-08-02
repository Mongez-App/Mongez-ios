import Foundation
import Common

protocol CoursesRemoteDataSourceProtocol {
    func fetchCourses() async throws -> [CourseDTO]
    func createCourse(requestDTO: CreateCourseRequestDTO) async throws -> CourseDTO
    func updateCourse(id: String, requestDTO: UpdateCourseRequestDTO) async throws -> CourseDTO
    func deleteCourse(id: String) async throws
    func addMaterial(courseId: String, fileData: Data, fileName: String, contentType: String, dailyStudyMinutes: Int, preferredDays: String) async throws -> MaterialDTO
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

    func addMaterial(courseId: String, fileData: Data, fileName: String, contentType: String, dailyStudyMinutes: Int, preferredDays: String) async throws -> MaterialDTO {
        let boundary = UUID().uuidString
        let body = createMultipartBody(fileData: fileData, fileName: fileName, contentType: contentType, boundary: boundary)

        let endpoint = CoursesEndPoint.addMaterial(
            courseId: courseId,
            body: body,
            boundary: boundary,
            dailyStudyMinutes: dailyStudyMinutes,
            preferredDays: preferredDays
        )

        let (data, _) = try await NetworkManger.shared.requestRaw(endpoint: endpoint)

        do {
            let material = try JSONDecoder().decode(MaterialDTO.self, from: data)
            if material.id != nil {
                return material
            }
        } catch {
            print("Failed to decode MaterialDTO: \(error)")
        }

        let str = String(data: data, encoding: .utf8) ?? "Unreadable data"
        throw NSError(domain: "AddMaterial", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response: \(str)"])
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

    private func createMultipartBody(fileData: Data, fileName: String, contentType: String, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"

        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: \(contentType)\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(fileData)
        body.append("\(lineBreak)".data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)

        return body
    }
}

enum CoursesError: Error, LocalizedError {
    case invalidResponse
    case materialUploadFailed
    case courseCreationFailed
    case imageUploadFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response from server"
        case .materialUploadFailed: return "Failed to upload material"
        case .courseCreationFailed: return "Failed to create course"
        case .imageUploadFailed: return "Failed to upload image"
        }
    }
}
