//
//  NearestStationsService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 04.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestStationsResponse = Components.Schemas.StationsResponse

protocol NearestStationsServiceProtocol: Sendable {
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStationsResponse
}

final class NearestStationsService: NearestStationsServiceProtocol, Sendable {
    private let client: Client
  
    init(client: Client) {
        self.client = client
    }
  
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStationsResponse {
        let response = try await client.getNearestStations(query: .init(
            lat: lat,           // Передаём широту
            lng: lng,           // Передаём долготу
            distance: distance  // Передаём дистанцию
        ))
        return try response.ok.body.json
    }
}
