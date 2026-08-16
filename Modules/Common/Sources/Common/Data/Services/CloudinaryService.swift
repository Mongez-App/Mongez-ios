import Foundation
import CryptoKit

public protocol CloudinaryServiceProtocol {
    func uploadImage(imageData: Data) async throws -> String
    func uploadPDF(fileData: Data, fileName: String) async throws -> String
    func deleteFile(publicId: String, resourceType: String) async throws
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
            throw CloudinaryError.imageUploadFailed
        }

        let json = try JSONDecoder().decode(CloudinaryResponseDTO.self, from: data)
        guard let secureUrl = json.secureUrl else {
            throw CloudinaryError.imageUploadFailed
        }

        return secureUrl
    }

    public func uploadPDF(fileData: Data, fileName: String) async throws -> String {
        // Use image/upload for PDFs to avoid Cloudinary's default strict delivery (401) on raw files
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
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: application/pdf\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(fileData)
        body.append("\(lineBreak)".data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CloudinaryError.materialUploadFailed // Changed to material error
        }

        let json = try JSONDecoder().decode(CloudinaryResponseDTO.self, from: data)
        guard let secureUrl = json.secureUrl else {
            throw CloudinaryError.materialUploadFailed // Changed to material error
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

extension CloudinaryService {
    
    public func deleteFile(publicId: String, resourceType: String = "image") async throws {
        guard let infoDict = Bundle.main.infoDictionary,
              let cloudName = infoDict["CloudinaryCloudName"] as? String,
              let apiKey = infoDict["CloudinaryAPIKey"] as? String,
              let apiSecret = infoDict["CloudinaryAPISecret"] as? String else {
            throw CloudinaryError.invalidResponse
        }
        
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let stringToSign = "public_id=\(publicId)&timestamp=\(timestamp)\(apiSecret)"
        let digest = Insecure.SHA1.hash(data: stringToSign.data(using: .utf8)!)
        let signature = digest.map { String(format: "%02hhx", $0) }.joined()
        
        let urlString = "https://api.cloudinary.com/v1_1/\(cloudName)/\(resourceType)/destroy"
        guard let url = URL(string: urlString) else {
            throw CloudinaryError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParameters = [
            "public_id": publicId,
            "api_key": apiKey,
            "timestamp": timestamp,
            "signature": signature
        ]
        
        let bodyString = bodyParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CloudinaryError.invalidResponse
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Delete response: \(jsonString)")
        }
    }
}
