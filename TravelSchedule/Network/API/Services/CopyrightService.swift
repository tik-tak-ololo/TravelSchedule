//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol: Sendable {
    func getCopyright() async throws -> CopyrightResponse
}

final class CopyrightService: CopyrightServiceProtocol, Sendable {
    private let client: Client
  
    init(client: Client) {
        self.client = client
    }
  
    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(query: .init(format: .json))
        return try response.ok.body.json
    }
}
