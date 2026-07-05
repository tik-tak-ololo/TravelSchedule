//
//  SegmentsService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias SegmentsResponse = Components.Schemas.SegmentsResponse

protocol SegmentsServiceProtocol {
    func getSchedualBetweenStations(from: String, to: String) async throws -> SegmentsResponse
}

final class SegmentsService: SegmentsServiceProtocol {
    private let client: Client
  
    init(client: Client) {
        self.client = client
    }
  
    func getSchedualBetweenStations(from: String, to: String) async throws -> SegmentsResponse {
        let response = try await client.getSchedualBetweenStations(query: .init(
            from: from,
            to: to
        ))
        return try response.ok.body.json
    }
}
