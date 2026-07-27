import Foundation
import Common

protocol CoursesRemoteDataSourceProtocol {
    func fetchCourses() async throws -> [CourseDTO]
    func createCourse(requestDTO: CreateCourseRequestDTO) async throws -> CourseDTO
    func deleteCourse(id: String) async throws
    func addMaterialMetadata(courseId: String, requestDTO: AddMaterialMetadataRequestDTO) async throws -> AddMaterialResponseDTO
    func uploadMaterialFile(uploadId: String, fileData: Data, fileName: String, contentType: String) async throws
    func addCourseFromURL(requestDTO: AddCourseFromURLRequestDTO) async throws -> CourseDTO
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
        } catch {

        }

        do {
            let directCourse = try JSONDecoder().decode(CourseDTO.self, from: data)
            if directCourse.id != nil {
                return directCourse
            }
        } catch {

        }

        let str = String(data: data, encoding: .utf8) ?? "Unreadable data"
        throw NSError(domain: "CreateCourse", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response: \(str)"])
    }

    func deleteCourse(id: String) async throws {
        let _ = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.deleteCourse(id: id)
        )
    }

    func addMaterialMetadata(courseId: String, requestDTO: AddMaterialMetadataRequestDTO) async throws -> AddMaterialResponseDTO {
        let body = try JSONEncoder().encode(requestDTO)

        let maxRetries = 3
        for attempt in 1...maxRetries {
            do {
                let response: AddMaterialResponseDTO = try await NetworkManger.shared.request(
                    endpoint: CoursesEndPoint.addMaterialMetadata(courseId: courseId, body: body),
                    responseType: AddMaterialResponseDTO.self
                )
                return response
            } catch {
                if attempt == maxRetries { throw error }
                let delay = UInt64(pow(2.0, Double(attempt))) * 1_000_000_000
                try await Task.sleep(nanoseconds: delay)
            }
        }
        throw CoursesError.invalidResponse
    }

    func uploadMaterialFile(uploadId: String, fileData: Data, fileName: String, contentType: String) async throws {
        let boundary = UUID().uuidString
        let body = createMultipartBody(fileData: fileData, fileName: fileName, contentType: contentType, boundary: boundary)

        let endpoint = CoursesEndPoint.uploadMaterialFile(uploadId: uploadId, body: body, boundary: boundary)
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        let maxRetries = 1
        for attempt in 1...maxRetries {
            do {
                let (_, response) = try await URLSession.shared.upload(for: request, from: body)
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                if (200...299).contains(statusCode) {
                    return
                } else {
                    throw NSError(domain: "Upload", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Upload failed with status \(statusCode)"])
                }
            } catch {
                if attempt == maxRetries { throw error }
                try await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }

    func addCourseFromURL(requestDTO: AddCourseFromURLRequestDTO) async throws -> CourseDTO {
        let body = try JSONEncoder().encode(requestDTO)
        let response: CreateCourseResponseDTO = try await NetworkManger.shared.request(
            endpoint: CoursesEndPoint.addCourseFromURL(body: body),
            responseType: CreateCourseResponseDTO.self
        )
        guard let course = response.course else {
            throw CoursesError.invalidResponse
        }
        return course
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

