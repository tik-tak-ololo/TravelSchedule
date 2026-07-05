//
//  ThreadStationsService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse

protocol ThreadStationsServiceProtocol {
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse
}

final class ThreadStationsService: ThreadStationsServiceProtocol {
    private let client: Client
  
    init(client: Client) {
        self.client = client
    }
  
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse {
        let response = try await client.getRouteStations(query: .init(
            uid: uid
        ))
        return try response.ok.body.json
    }
}
