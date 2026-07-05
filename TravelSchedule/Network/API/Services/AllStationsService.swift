//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
  func getAllStations() async throws -> AllStationsResponse
}

final class AllStationsService: AllStationsServiceProtocol {
    private let client: Client
  
    init(client: Client) {
        self.client = client
    }
  
    func getAllStations() async throws -> AllStationsResponse {
        let response = try await client.getAllStations(query: .init(format: "json"))

        let ok = try response.ok
        let body = try ok.body.text_html_charset_utf_hyphen_8

        let data = try await Data(
            collecting: body,
            upTo: 100 * 1024 * 1024
        )

        return try JSONDecoder().decode(AllStationsResponse.self, from: data)
    }
}
