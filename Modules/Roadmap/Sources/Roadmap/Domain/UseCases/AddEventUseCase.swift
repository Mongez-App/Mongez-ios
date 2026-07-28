import Foundation

public protocol AddEventUseCaseProtocol {
    func execute(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async throws
}

public class AddEventUseCase: AddEventUseCaseProtocol {
    private let roadmapRepository: RoadmapRepositoryProtocol

    public init(roadmapRepository: RoadmapRepositoryProtocol) {
        self.roadmapRepository = roadmapRepository
    }

    public func execute(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async throws {
        try await roadmapRepository.addEvent(courseId: courseId, eventType: eventType, title: title, dueDate: dueDate, weight: weight)
    }
}
