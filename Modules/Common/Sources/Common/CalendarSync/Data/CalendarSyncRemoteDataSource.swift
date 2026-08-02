import Foundation

protocol CalendarSyncRemoteDataSourceProtocol {
    func syncEvents(_ events: [CalendarEventEntity]) async throws -> Int
}

final class CalendarSyncRemoteDataSource: CalendarSyncRemoteDataSourceProtocol {
    func syncEvents(_ events: [CalendarEventEntity]) async throws -> Int {
        let response = try await NetworkManger.shared.request(
            endpoint: CalendarSyncEndpoint.syncEvents(events: events.map { $0.mapToDto() }),
            responseType: CalendarSyncResponseDto.self
        )
        return response.syncedCount
    }
}
