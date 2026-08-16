//
//  NearestCityService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol: Sendable {
    func getNearestCity(lat: Double, lng: Double, distance: Int) async throws -> NearestCityResponse
}

final class NearestCityService: NearestCityServiceProtocol, Sendable {
    private let client: Client
    
    init(client: Client) {
        self.client = client
    }
  
    func getNearestCity(lat: Double, lng: Double, distance: Int) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(query: .init(
            lat: lat,           // Передаём широту
            lng: lng,           // Передаём долготу
            distance: distance  // Передаём дистанцию
        ))
        return try response.ok.body.json
    }
}
