//
//  ScheduleService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    func getStationSchedule(station: String) async throws -> ScheduleResponse
}

final class ScheduleService: ScheduleServiceProtocol {
    private let client: Client
  
    init(client: Client) {
        self.client = client
    }
  
    func getStationSchedule(station: String) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(query: .init(
            station: station
        ))
        return try response.ok.body.json
    }
}
