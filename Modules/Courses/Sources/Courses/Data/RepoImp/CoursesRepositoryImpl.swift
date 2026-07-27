import Foundation
import Common

final class CoursesRepositoryImpl: CoursesRepositoryProtocol {
    private let remoteDataSource: CoursesRemoteDataSourceProtocol

    init(remoteDataSource: CoursesRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchCourses() async throws -> [Course] {
        let dtos = try await remoteDataSource.fetchCourses()
        return dtos.map { $0.toDomain() }
    }

    func createCourse(name: String, courseCode: String, imageUrl: String?, startDate: Date, endDate: Date?, examDate: Date, hasMaterials: Bool) async throws -> Course {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]

        let requestDTO = CreateCourseRequestDTO(
            name: name,
            courseCode: courseCode.isEmpty ? nil : courseCode,
            imageUrl: imageUrl,
            startDate: dateFormatter.string(from: startDate),
            endDate: endDate.map { dateFormatter.string(from: $0) },
            examDate: dateFormatter.string(from: examDate),
            hasMaterials: hasMaterials
        )

        let courseDTO = try await remoteDataSource.createCourse(requestDTO: requestDTO)
        return courseDTO.toDomain()
    }

    func deleteCourse(id: String) async throws {
        try await remoteDataSource.deleteCourse(id: id)
    }

    func addMaterialMetadata(courseId: String, fileName: String, contentType: String, fileSizeBytes: Int, pageCount: Int?) async throws -> Material {
        let requestDTO = AddMaterialMetadataRequestDTO(
            fileName: fileName,
            contentType: contentType,
            fileSizeBytes: fileSizeBytes,
            pageCount: pageCount
        )

        guard let body = try? JSONEncoder().encode(requestDTO) else {
            throw URLError(.cannotParseResponse)
        }

        let (data, _) = try await NetworkManger.shared.requestRaw(
            endpoint: CoursesEndPoint.addMaterialMetadata(courseId: courseId, body: body)
        )

        let rawJsonStr = String(data: data, encoding: .utf8) ?? "unknown"

        do {
            let response = try JSONDecoder().decode(AddMaterialResponseDTO.self, from: data)
            if let materialId = response.materialId {

                return Material(
                    id: materialId,
                    fileName: fileName,
                    contentType: contentType,
                    fileSizeBytes: fileSizeBytes,
                    pageCount: pageCount ?? 0,
                    courseId: courseId,
                    uploadId: response.materialId ?? materialId
                )
            }
        } catch {

        }

        throw NSError(domain: "AddMaterial", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse material ID. Raw JSON: \(rawJsonStr)"])
    }

    func uploadMaterialFile(uploadId: String, fileData: Data, fileName: String, contentType: String) async throws {
        try await remoteDataSource.uploadMaterialFile(uploadId: uploadId, fileData: fileData, fileName: fileName, contentType: contentType)
    }

    func addCourseFromURL(url: String) async throws -> Course {
        let requestDTO = AddCourseFromURLRequestDTO(url: url)
        let courseDTO = try await remoteDataSource.addCourseFromURL(requestDTO: requestDTO)
        return courseDTO.toDomain()
    }
}

