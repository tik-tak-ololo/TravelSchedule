//
//  SegmentsService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias SegmentsResponse = Components.Schemas.SegmentsResponse

enum SegmentsServiceError: Error, Sendable {
    case unexpectedStatus(Int)

    var statusCode: Int {
        switch self {
        case let .unexpectedStatus(statusCode):
            return statusCode
        }
    }
}

protocol SegmentsServiceProtocol: Sendable {
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?,
        resultTimezone: String?,
        transfers: Bool?
    ) async throws -> SegmentsResponse
}

final class SegmentsService: SegmentsServiceProtocol, Sendable {
    private let client: Client
  
    init(client: Client) {
        self.client = client
    }
  
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String? = nil,
        resultTimezone: String? = nil,
        transfers: Bool? = nil
    ) async throws -> SegmentsResponse {
        let response = try await client.getSchedualBetweenStations(query: .init(
            from: from,
            to: to,
            date: date,
            result_timezone: resultTimezone,
            transfers: transfers
        ))

        switch response {
        case let .ok(response):
            return try response.body.json

        case let .undocumented(statusCode, _):
            throw SegmentsServiceError.unexpectedStatus(statusCode)
        }
    }
}
