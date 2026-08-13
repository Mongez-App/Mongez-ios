import Foundation

protocol CalendarSyncRemoteDataSourceProtocol {
    func syncEvents(_ events: [CalendarEventEntity]) async throws -> Int
    func getStatus() async throws -> CalendarSyncStatus
    func updateFlags(calendarConnected: Bool, calendarSynced: Bool) async throws -> CalendarSyncStatus
}

final class CalendarSyncRemoteDataSource: CalendarSyncRemoteDataSourceProtocol {
    func syncEvents(_ events: [CalendarEventEntity]) async throws -> Int {
        let response = try await NetworkManger.shared.request(
            endpoint: CalendarSyncEndpoint.syncEvents(events: events.map { $0.mapToDto() }),
            responseType: CalendarSyncResponseDto.self
        )
        return response.syncedCount
    }

    func getStatus() async throws -> CalendarSyncStatus {
        let response = try await NetworkManger.shared.request(
            endpoint: CalendarSyncEndpoint.getStatus,
            responseType: CalendarSyncStatusDto.self
        )
        return response.mapToEntity()
    }

    func updateFlags(calendarConnected: Bool, calendarSynced: Bool) async throws -> CalendarSyncStatus {
        let response = try await NetworkManger.shared.request(
            endpoint: CalendarSyncEndpoint.updateFlags(calendarConnected: calendarConnected, calendarSynced: calendarSynced),
            responseType: CalendarSyncStatusDto.self
        )
        return response.mapToEntity()
    }
}
