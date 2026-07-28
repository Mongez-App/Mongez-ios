import Foundation
import Common

protocol CoursesRemoteDataSourceProtocol {
    func fetchCourses() async throws -> [CourseDTO]
    func createCourse(requestDTO: CreateCourseRequestDTO) async throws -> CourseDTO
    func deleteCourse(id: String) async throws
    func uploadMaterialFile(courseId: String, fileData: Data, fileName: String, contentType: String) async throws
    func listMaterials(courseId: String) async throws -> [MaterialDTO]
    func createTasks(courseId: String, requestDTO: CreateTasksRequestDTO) async throws
    func listTasks(courseId: String) async throws -> [CourseTaskDTO]
    func createEvent(courseId: String, requestDTO: CreateEventRequestDTO) async throws
    func listEvents(courseId: String) async throws -> [CourseEventDTO]
    func addCourseFromURL(requestDTO: AddCourseFromURLRequestDTO) async throws -> CourseDTO
}

final class CoursesRemoteDataSource: CoursesRemoteDataSourceProtocol {

    func fetchCourses() async throws -> [CourseDTO] {
        let endpoint = CoursesEndPoint.listCourses
        let fullURL = endpoint.baseURL + endpoint.path
        print("=== FETCH COURSES REQUEST ===")
        print("URL: \(fullURL)")
        print("=============================")

        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let responseStr = String(data: data, encoding: .utf8) ?? "?"

        print("=== FETCH COURSES RESPONSE ===")
        print("Status: \(statusCode)")
        print("Body: \(responseStr.prefix(2000))")
        print("===============================")

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "FetchCourses", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error \(statusCode): \(responseStr)"])
        }

        if let wrapper = try? JSONDecoder().decode(CoursesListDataWrapper.self, from: data) {
            let courses = wrapper.data?.courses ?? []
            print("Decoded as CoursesListDataWrapper: \(courses.count) courses")
            return courses
        }

        if let courses = try? JSONDecoder().decode([CourseDTO].self, from: data) {
            print("Decoded as [CourseDTO]: \(courses.count) courses")
            return courses
        }

        print("FAILED to decode courses response")
        throw CoursesError.invalidResponse
    }

    func createCourse(requestDTO: CreateCourseRequestDTO) async throws -> CourseDTO {
        let body = try JSONEncoder().encode(requestDTO)
        let bodyStr = String(data: body, encoding: .utf8) ?? "?"
        let endpoint = CoursesEndPoint.createCourse(body: body)
        let fullURL = endpoint.baseURL + endpoint.path
        print("=== CREATE COURSE REQUEST ===")
        print("URL: \(fullURL)")
        print("Method: \(endpoint.method.rawValue)")
        print("Headers: \(endpoint.headers ?? [:])")
        print("Body: \(bodyStr)")
        print("=============================")

        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let responseStr = String(data: data, encoding: .utf8) ?? "?"

        print("=== CREATE COURSE RESPONSE ===")
        print("Status: \(statusCode)")
        print("Body: \(responseStr)")
        print("==============================")

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "CreateCourse", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error \(statusCode): \(responseStr)"])
        }

        do {
            let response = try JSONDecoder().decode(CreateCourseResponseDTO.self, from: data)
            if let course = response.data, course.id != nil {
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

    func deleteCourse(id: String) async throws {
        let _ = try await NetworkManger.shared.requestRaw(endpoint: CoursesEndPoint.deleteCourse(id: id))
    }

    func uploadMaterialFile(courseId: String, fileData: Data, fileName: String, contentType: String) async throws {
        let boundary = UUID().uuidString
        let body = createMultipartBody(fileData: fileData, fileName: fileName, contentType: contentType, boundary: boundary)

        let endpoint = CoursesEndPoint.uploadMaterialFile(courseId: courseId, body: body, boundary: boundary)
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await URLSession.shared.upload(for: request, from: body)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== UPLOAD RESULT ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(1000))")
        print("=====================")

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "Upload", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Upload failed \(statusCode): \(raw)"])
        }
    }

    func listMaterials(courseId: String) async throws -> [MaterialDTO] {
        let endpoint = CoursesEndPoint.listMaterials(courseId: courseId)
        let fullURL = endpoint.baseURL + endpoint.path
        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== LIST MATERIALS ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(1000))")
        print("======================")

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "ListMaterials", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }

        if let wrapper = try? JSONDecoder().decode(DocumentListResponseDTO.self, from: data),
           let docs = wrapper.data?.documents {
            return docs.map { $0.toMaterialDTO() }
        }
        if let arr = try? JSONDecoder().decode([MaterialDTO].self, from: data) {
            return arr
        }
        return []
    }

    func createTasks(courseId: String, requestDTO: CreateTasksRequestDTO) async throws {
        let body = try JSONEncoder().encode(requestDTO)
        let _ = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.createTasks(courseId: courseId, body: body)
        )
    }

    func listTasks(courseId: String) async throws -> [CourseTaskDTO] {
        let endpoint = CoursesEndPoint.listTasks(courseId: courseId)
        let fullURL = endpoint.baseURL + endpoint.path
        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "ListTasks", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }

        if let wrapper = try? JSONDecoder().decode(TasksListWrapperDTO.self, from: data),
           let tasks = wrapper.data?.tasks {
            return tasks
        }
        if let arr = try? JSONDecoder().decode([CourseTaskDTO].self, from: data) {
            return arr
        }
        return []
    }

    func createEvent(courseId: String, requestDTO: CreateEventRequestDTO) async throws {
        let body = try JSONEncoder().encode(requestDTO)
        let _ = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.createEvent(courseId: courseId, body: body)
        )
    }

    func listEvents(courseId: String) async throws -> [CourseEventDTO] {
        let endpoint = CoursesEndPoint.listEvents(courseId: courseId)
        let fullURL = endpoint.baseURL + endpoint.path
        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "ListEvents", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }

        if let wrapper = try? JSONDecoder().decode(EventsListWrapperDTO.self, from: data),
           let events = wrapper.data?.events {
            return events
        }
        if let arr = try? JSONDecoder().decode([CourseEventDTO].self, from: data) {
            return arr
        }
        return []
    }

    func addCourseFromURL(requestDTO: AddCourseFromURLRequestDTO) async throws -> CourseDTO {
        let body = try JSONEncoder().encode(requestDTO)
        let response: CreateCourseResponseDTO = try await NetworkManger.shared.request(
            endpoint: CoursesEndPoint.addCourseFromURL(body: body),
            responseType: CreateCourseResponseDTO.self
        )
        guard let course = response.data else {
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
