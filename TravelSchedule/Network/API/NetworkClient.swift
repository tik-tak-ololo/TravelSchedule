//
//  NetworkClient.swift
//  TravelSchedule
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

protocol CitiesProviding: Sendable {
    func getCities() async throws -> [City]
}

actor NetworkClient: CitiesProviding {

    static let shared: NetworkClient = {
        do {
            return try NetworkClient()
        } catch {
            preconditionFailure("Не удалось создать сетевой клиент: \(error)")
        }
    }()

    private let client: Client
    private var cachedCities: [City]?

    init(apiKey: String = APIConfiguration.apiKey) throws {
        client = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [
                AuthorizationMiddleware(apiKey: apiKey)
            ]
        )
    }

    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(
            query: .init(format: .json)
        )

        return try response.ok.body.json
    }

    func getNearestStations(
        lat: Double,
        lng: Double,
        distance: Int
    ) async throws -> NearestStationsResponse {
        let response = try await client.getNearestStations(
            query: .init(
                lat: lat,
                lng: lng,
                distance: distance
            )
        )

        return try response.ok.body.json
    }

    func getScheduleBetweenStations(
        from: String,
        to: String
    ) async throws -> SegmentsResponse {
        let response = try await client.getSchedualBetweenStations(
            query: .init(
                from: from,
                to: to
            )
        )

        return try response.ok.body.json
    }

    func getStationSchedule(station: String) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(
            query: .init(station: station)
        )

        return try response.ok.body.json
    }

    func getRouteStations(uid: String) async throws -> ThreadStationsResponse {
        let response = try await client.getRouteStations(
            query: .init(uid: uid)
        )

        return try response.ok.body.json
    }

    func getNearestCity(
        lat: Double,
        lng: Double,
        distance: Int
    ) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(
            query: .init(
                lat: lat,
                lng: lng,
                distance: distance
            )
        )

        return try response.ok.body.json
    }

    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        let response = try await client.getCarrierInfo(
            query: .init(code: code)
        )

        return try response.ok.body.json
    }

    func getAllStations() async throws -> AllStationsResponse {
        let response = try await client.getAllStations(
            query: .init(
                lang: "ru_RU",
                format: "json"
            )
        )
        let body = try response.ok.body.text_html_charset_utf_hyphen_8
        let data = try await Data(
            collecting: body,
            upTo: 100 * 1024 * 1024
        )

        return try JSONDecoder().decode(
            AllStationsResponse.self,
            from: data
        )
    }

    func getCities() async throws -> [City] {
        if let cachedCities {
            return cachedCities
        }

        let response = try await getAllStations()
        var citiesByName: [String: City] = [:]

        for country in response.countries ?? [] {
            for region in country.regions ?? [] {
                for settlement in region.settlements ?? [] {
                    guard let name = settlement.title?
                        .trimmingCharacters(in: .whitespacesAndNewlines),
                          !name.isEmpty else {
                        continue
                    }

                    let normalizedName = name.folding(
                        options: [.caseInsensitive, .diacriticInsensitive],
                        locale: Locale(identifier: "ru_RU")
                    )

                    if citiesByName[normalizedName] == nil {
                        let code = settlement.codes?.yandex_code
                        citiesByName[normalizedName] = City(
                            name: name,
                            code: code
                        )
                    }
                }
            }
        }

        let cities = citiesByName.values.sorted {
            $0.name.localizedStandardCompare($1.name) == .orderedAscending
        }
        cachedCities = cities

        return cities
    }
}
