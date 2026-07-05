//
//  CarrierServices.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierResponse
}

final class CarrierService: CarrierServiceProtocol {
    private let client: Client
  
    init(client: Client) {
        self.client = client
    }
  
    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(
            code: code
        ))
        return try response.ok.body.json
    }
}
