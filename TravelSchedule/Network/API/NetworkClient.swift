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

protocol StationsProviding: Sendable {
    func getStations(for city: City) async throws -> [Station]
}

actor NetworkClient: CitiesProviding, StationsProviding {

    static let shared: NetworkClient = {
        do {
            return try NetworkClient()
        } catch {
            preconditionFailure("Не удалось создать сетевой клиент: \(error)")
        }
    }()

    private let client: Client
    private var cachedCities: [City]?
    private var cachedStationsByCityKey: [String: [Station]]?

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

        try await loadStationDirectory()

        return cachedCities ?? []
    }

    func getStations(for city: City) async throws -> [Station] {
        if cachedStationsByCityKey == nil {
            try await loadStationDirectory()
        }

        if let code = city.code?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ), !code.isEmpty,
           let stations = cachedStationsByCityKey?[Self.codeKey(code)] {
            return stations
        }

        return cachedStationsByCityKey?[Self.nameKey(city.name)] ?? []
    }

    private func loadStationDirectory() async throws {
        let response = try await getAllStations()
        var citiesByName: [String: City] = [:]
        var stationsByCityKey: [String: [Station]] = [:]

        for country in response.countries ?? [] {
            for region in country.regions ?? [] {
                for settlement in region.settlements ?? [] {
                    guard let name = settlement.title?
                        .trimmingCharacters(in: .whitespacesAndNewlines),
                          !name.isEmpty else {
                        continue
                    }

                    let normalizedName = Self.normalized(name)
                    let code = settlement.codes?.yandex_code?
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    let stations = Self.stations(from: settlement.stations ?? [])

                    if citiesByName[normalizedName] == nil {
                        citiesByName[normalizedName] = City(
                            name: name,
                            code: code?.isEmpty == false ? code : nil
                        )
                    }

                    if let code, !code.isEmpty {
                        stationsByCityKey[Self.codeKey(code)] = stations
                    }

                    let nameKey = Self.nameKey(name)
                    if stationsByCityKey[nameKey] == nil {
                        stationsByCityKey[nameKey] = stations
                    }
                }
            }
        }

        let cities = citiesByName.values.sorted {
            $0.name.localizedStandardCompare($1.name) == .orderedAscending
        }
        cachedCities = cities
        cachedStationsByCityKey = stationsByCityKey
    }

    private static func stations(
        from apiStations: [Components.Schemas.Station]
    ) -> [Station] {
        var stationsByIdentifier: [String: Station] = [:]

        for apiStation in apiStations {
            guard let name = apiStation.title?
                .trimmingCharacters(in: .whitespacesAndNewlines),
                  !name.isEmpty else {
                continue
            }

            let code = (
                apiStation.codes?.yandex_code ?? apiStation.code
            )?.trimmingCharacters(in: .whitespacesAndNewlines)
            let identifier: String

            if let code, !code.isEmpty {
                identifier = codeKey(code)
            } else {
                identifier = nameKey(name)
            }

            if stationsByIdentifier[identifier] == nil {
                stationsByIdentifier[identifier] = Station(
                    name: name,
                    code: code?.isEmpty == false ? code : nil
                )
            }
        }

        return stationsByIdentifier.values.sorted {
            $0.name.localizedStandardCompare($1.name) == .orderedAscending
        }
    }

    private static func codeKey(_ code: String) -> String {
        "code:\(code)"
    }

    private static func nameKey(_ name: String) -> String {
        "name:\(normalized(name))"
    }

    private static func normalized(_ value: String) -> String {
        value.folding(
            options: [.caseInsensitive, .diacriticInsensitive],
            locale: Locale(identifier: "ru_RU")
        )
    }
}
