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

protocol ScheduleProviding: Sendable {
    func getSchedule(
        from departure: RoutePoint,
        to destination: RoutePoint
    ) async throws -> [ScheduleItem]
}

actor NetworkClient: CitiesProviding, StationsProviding, ScheduleProviding {

    static let shared: NetworkClient = {
        do {
            return try NetworkClient()
        } catch {
            preconditionFailure("Не удалось создать сетевой клиент: \(error)")
        }
    }()

    private let copyrightService: any CopyrightServiceProtocol
    private let nearestStationsService: any NearestStationsServiceProtocol
    private let segmentsService: any SegmentsServiceProtocol
    private let scheduleService: any ScheduleServiceProtocol
    private let threadStationsService: any ThreadStationsServiceProtocol
    private let nearestCityService: any NearestCityServiceProtocol
    private let carrierService: any CarrierServiceProtocol
    private let allStationsService: any AllStationsServiceProtocol
    private var cachedCities: [City]?
    private var cachedStationsByCityKey: [String: [Station]]?

    init(apiKey: String = APIConfiguration.apiKey) throws {
        let client = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [
                AuthorizationMiddleware(apiKey: apiKey)
            ]
        )

        copyrightService = CopyrightService(client: client)
        nearestStationsService = NearestStationsService(client: client)
        segmentsService = SegmentsService(client: client)
        scheduleService = ScheduleService(client: client)
        threadStationsService = ThreadStationsService(client: client)
        nearestCityService = NearestCityService(client: client)
        carrierService = CarrierService(client: client)
        allStationsService = AllStationsService(client: client)
    }

    func getCopyright() async throws -> CopyrightResponse {
        try await copyrightService.getCopyright()
    }

    func getNearestStations(
        lat: Double,
        lng: Double,
        distance: Int
    ) async throws -> NearestStationsResponse {
        try await nearestStationsService.getNearestStations(
            lat: lat,
            lng: lng,
            distance: distance
        )
    }

    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String? = nil,
        resultTimezone: String? = nil,
        transfers: Bool? = nil
    ) async throws -> SegmentsResponse {
        try await segmentsService.getScheduleBetweenStations(
            from: from,
            to: to,
            date: date,
            resultTimezone: resultTimezone,
            transfers: transfers
        )
    }

    func getSchedule(
        from departure: RoutePoint,
        to destination: RoutePoint
    ) async throws -> [ScheduleItem] {
        let codePairs = try Self.scheduleCodePairs(
            departure: departure,
            destination: destination
        )
        var lastNotFoundError: SegmentsServiceError?

        for codePair in codePairs {
            do {
                let response = try await getScheduleBetweenStations(
                    from: codePair.from,
                    to: codePair.to,
                    date: Self.apiDateFormatter.string(from: Date()),
                    resultTimezone: TimeZone.current.identifier,
                    transfers: true
                )

                return (response.segments ?? []).compactMap(Self.scheduleItem)
            } catch let error as SegmentsServiceError
                where error.statusCode == 404 {
                lastNotFoundError = error
            }
        }

        throw lastNotFoundError ?? ScheduleProviderError.missingStationCode
    }

    func getStationSchedule(station: String) async throws -> ScheduleResponse {
        try await scheduleService.getStationSchedule(station: station)
    }

    func getRouteStations(uid: String) async throws -> ThreadStationsResponse {
        try await threadStationsService.getRouteStations(uid: uid)
    }

    func getNearestCity(
        lat: Double,
        lng: Double,
        distance: Int
    ) async throws -> NearestCityResponse {
        try await nearestCityService.getNearestCity(
            lat: lat,
            lng: lng,
            distance: distance
        )
    }

    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        try await carrierService.getCarrierInfo(code: code)
    }

    func getAllStations() async throws -> AllStationsResponse {
        try await allStationsService.getAllStations()
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

    private static func scheduleItem(
        from segment: Components.Schemas.Segment
    ) -> ScheduleItem? {
        guard
            let departure = date(from: segment.departure),
            let arrival = date(from: segment.arrival),
            arrival >= departure
        else {
            return nil
        }

        let apiCarrier = segment.thread?.carrier
        let carrier = Carrier(
            title: nonempty(apiCarrier?.title) ?? "Перевозчик не указан",
            logoURL: url(from: apiCarrier?.logo),
            website: url(from: apiCarrier?.url),
            email: nonempty(apiCarrier?.email),
            phone: nonempty(apiCarrier?.phone)
        )

        return ScheduleItem(
            carrier: carrier,
            departureDate: departure,
            arrivalDate: arrival,
            transferDescription: segment.has_transfers == true
                ? "С пересадками"
                : nil
        )
    }

    private static func scheduleCodePairs(
        departure: RoutePoint,
        destination: RoutePoint
    ) throws -> [(from: String, to: String)] {
        guard
            let departureStationCode = code(departure.station.code),
            let destinationStationCode = code(destination.station.code)
        else {
            throw ScheduleProviderError.missingStationCode
        }

        let departureCodes = uniqueCodes([
            departureStationCode,
            code(departure.city.code)
        ])
        let destinationCodes = uniqueCodes([
            destinationStationCode,
            code(destination.city.code)
        ])

        return departureCodes.flatMap { departureCode in
            destinationCodes.map { destinationCode in
                (from: departureCode, to: destinationCode)
            }
        }
    }

    private static func uniqueCodes(_ codes: [String?]) -> [String] {
        codes.compactMap { $0 }.reduce(into: []) { result, code in
            if !result.contains(code) {
                result.append(code)
            }
        }
    }

    private static func code(_ value: String?) -> String? {
        nonempty(value)
    }

    private static func date(from value: String?) -> Date? {
        guard let value = nonempty(value) else {
            return nil
        }

        let normalizedValue = value.replacingOccurrences(
            of: " ",
            with: "T"
        )
        let isoFormatter = ISO8601DateFormatter()

        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        if let date = isoFormatter.date(from: normalizedValue) {
            return date
        }

        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: normalizedValue) {
            return date
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return formatter.date(from: normalizedValue)
    }

    private static func url(from value: String?) -> URL? {
        guard let value = nonempty(value) else {
            return nil
        }

        if value.hasPrefix("//") {
            return URL(string: "https:\(value)")
        }

        return URL(string: value)
    }

    private static func nonempty(_ value: String?) -> String? {
        guard
            let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
            !value.isEmpty
        else {
            return nil
        }

        return value
    }

    private static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

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

private enum ScheduleProviderError: Error, Sendable {
    case missingStationCode
}
