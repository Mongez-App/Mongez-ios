import Foundation
import Common

public protocol CourseDetailsRemoteDataSourceProtocol {
    func getMaterials(courseId: String) async throws -> [CourseMaterialDTO]
    func getTasks(courseId: String) async throws -> [CourseTaskDTO]
    func uploadDocument(courseId: String, fileData: Data, fileName: String, contentType: String) async throws -> DocumentUploadResultDTO?
    func deleteMaterial(courseId: String, materialId: String) async throws
    func createTasks(courseId: String) async throws
}

public struct DocumentUploadResultDTO: Decodable {
    let success: Bool?
    let data: CourseDocumentDTO?
    let message: String?
}

public struct CourseDocumentDTO: Decodable {
    let documentId: String?
    let filename: String?
    let chunkCount: Int?
    let totalPages: Int?
    let totalChars: Int?
}

public class CourseDetailsRemoteDataSource: CourseDetailsRemoteDataSourceProtocol {

    public init() {}

    private enum Endpoints {
        static let base = "https://course-import-service.vercel.app/api/v1/"

        static func materials(courseId: String) -> String { "\(base)rag/courses/\(courseId)/materials" }
        static func material(courseId: String, materialId: String) -> String { "\(base)rag/courses/\(courseId)/materials/\(materialId)" }
        static func tasks(courseId: String) -> String { "\(base)rag/courses/\(courseId)/tasks" }
    }

    private func headers(boundary: String? = nil) -> [String: String] {
        var headers: [String: String] = [:]
        if let userId = SessionManager.userId {
            headers["x-user-id"] = userId
        }
        if let auth = SessionManager.authorizationHeader {
            headers["Authorization"] = auth["Authorization"]
        }
        if let boundary = boundary {
            headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        } else {
            headers["Content-Type"] = "application/json"
        }
        return headers
    }

    // MARK: - GET materials

    public func getMaterials(courseId: String) async throws -> [CourseMaterialDTO] {
        let urlString = Endpoints.materials(courseId: courseId)
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers()

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== COURSE DETAILS MATERIALS ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(2000))")
        print("================================")

        if statusCode == 401 {
            await MainActor.run {
                SessionManager.clear()
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
            }
        }

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "CourseDetails", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }

        if let wrapper = try? JSONDecoder().decode(CourseDocumentsWrapper.self, from: data),
           let docs = wrapper.data?.documents ?? wrapper.data?.materials {
            return docs
        }
        if let arr = try? JSONDecoder().decode([CourseMaterialDTO].self, from: data) {
            return arr
        }
        return []
    }

    // MARK: - GET tasks

    public func getTasks(courseId: String) async throws -> [CourseTaskDTO] {
        let urlString = Endpoints.tasks(courseId: courseId)
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers()

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== COURSE DETAILS TASKS ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(2000))")
        print("============================")

        if statusCode == 401 {
            await MainActor.run {
                SessionManager.clear()
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
            }
        }

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "CourseDetails", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }

        if let wrapper = try? JSONDecoder().decode(CourseTasksWrapper.self, from: data),
           let tasks = wrapper.data?.tasks {
            return tasks
        }
        if let arr = try? JSONDecoder().decode([CourseTaskDTO].self, from: data) {
            return arr
        }
        return []
    }

    // MARK: - POST upload (multipart, `file` field)

    public func uploadDocument(courseId: String, fileData: Data, fileName: String, contentType: String) async throws -> DocumentUploadResultDTO? {
        let boundary = UUID().uuidString
        let body = buildMultipartBody(fileData: fileData, fileName: fileName, contentType: contentType, boundary: boundary)

        let urlString = Endpoints.materials(courseId: courseId)
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers(boundary: boundary)

        let (data, response) = try await URLSession.shared.upload(for: request, from: body)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== UPLOAD RESULT ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(1000))")
        print("=====================")

        if statusCode == 401 {
            await MainActor.run {
                SessionManager.clear()
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
            }
        }

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "CourseDetails", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }

        return try? JSONDecoder().decode(DocumentUploadResultDTO.self, from: data)
    }

    // MARK: - DELETE material

    public func deleteMaterial(courseId: String, materialId: String) async throws {
        let urlString = Endpoints.material(courseId: courseId, materialId: materialId)
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers()

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== DELETE MATERIAL ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(1000))")
        print("=======================")

        if statusCode == 401 {
            await MainActor.run {
                SessionManager.clear()
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
            }
        }

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "CourseDetails", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }
    }

    // MARK: - POST create tasks

    public func createTasks(courseId: String) async throws {
        let urlString = Endpoints.tasks(courseId: courseId)
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let requestBody = CreateTasksRequestBody(quizQuestionsPerTask: 7)
        let body = try JSONEncoder().encode(requestBody)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers()
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== CREATE TASKS ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(1000))")
        print("====================")

        if statusCode == 401 {
            await MainActor.run {
                SessionManager.clear()
                NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
            }
        }

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "CourseDetails", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }
    }

    // MARK: - Multipart builder

    private func buildMultipartBody(fileData: Data, fileName: String, contentType: String, boundary: String) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: \(contentType)\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(fileData)
        body.append("\(lineBreak)--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        return body
    }
}

// MARK: - Body

private struct CreateTasksRequestBody: Encodable {
    let quizQuestionsPerTask: Int
}

// MARK: - Wrappers

struct CourseDocumentsWrapper: Decodable {
    let success: Bool?
    let data: CourseDocumentsData?
    let message: String?

    enum CodingKeys: String, CodingKey { case success, data, message }

    struct CourseDocumentsData: Decodable {
        let documents: [CourseMaterialDTO]?
        let materials: [CourseMaterialDTO]?
    }
}

struct CourseTasksWrapper: Decodable {
    let success: Bool?
    let data: CourseTasksData?
    let message: String?

    enum CodingKeys: String, CodingKey { case success, data, message }
    struct CourseTasksData: Decodable { let tasks: [CourseTaskDTO]? }
}