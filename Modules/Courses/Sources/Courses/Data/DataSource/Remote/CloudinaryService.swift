import Foundation

public protocol CloudinaryServiceProtocol {
    func uploadImage(imageData: Data) async throws -> String
}

public final class CloudinaryService: CloudinaryServiceProtocol {
    private let cloudName = "vllwannu"
    private let uploadPreset = "Mongez"

    public init() {}

    public func uploadImage(imageData: Data) async throws -> String {
        let url = URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let lineBreak = "\r\n"

        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append("\(uploadPreset)\(lineBreak)".data(using: .utf8)!)

        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"course_image.jpg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(imageData)
        body.append("\(lineBreak)".data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CoursesError.imageUploadFailed
        }

        let json = try JSONDecoder().decode(CloudinaryResponseDTO.self, from: data)
        guard let secureUrl = json.secureUrl else {
            throw CoursesError.imageUploadFailed
        }

        return secureUrl
    }
}

struct CloudinaryResponseDTO: Codable {
    let secureUrl: String?
    let publicId: String?
    let format: String?
    let resourceType: String?

    enum CodingKeys: String, CodingKey {
        case secureUrl = "secure_url"
        case publicId = "public_id"
        case format
        case resourceType = "resource_type"
    }
}

