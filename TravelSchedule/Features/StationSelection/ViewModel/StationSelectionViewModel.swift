//
//  StationSelectionViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import Foundation
import Observation
import OpenAPIRuntime

@MainActor
@Observable
final class StationSelectionViewModel {

    var searchText = ""

    private(set) var stations: [Station]
    private(set) var isLoading = false
    private(set) var errorScreenType: ErrorScreenType?

    private let city: City
    private let stationsProvider: any StationsProviding
    private var hasLoadedStations: Bool

    init(
        city: City,
        stations: [Station] = [],
        stationsProvider: any StationsProviding = NetworkClient.shared
    ) {
        self.city = city
        self.stations = stations
        self.stationsProvider = stationsProvider
        hasLoadedStations = !stations.isEmpty
    }

    var filteredStations: [Station] {
        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {
            return stations
        }

        return stations.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }

    var isStationNotFound: Bool {
        !searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty && filteredStations.isEmpty
    }

    func clearSearch() {
        searchText = ""
    }

    func loadStations() async {
        guard !hasLoadedStations else {
            return
        }

        hasLoadedStations = true
        isLoading = true
        errorScreenType = nil

        do {
            stations = try await stationsProvider.getStations(for: city)
        } catch is CancellationError {
            hasLoadedStations = false
        } catch {
            errorScreenType = Self.errorScreenType(for: error)
        }

        isLoading = false
    }

    private static func errorScreenType(for error: Error) -> ErrorScreenType {
        let underlyingError = if let clientError = error as? ClientError {
            clientError.underlyingError
        } else {
            error
        }
        let networkError = underlyingError as NSError

        guard networkError.domain == NSURLErrorDomain else {
            return .serverError
        }

        let noInternetCodes: Set<URLError.Code> = [
            .notConnectedToInternet,
            .networkConnectionLost,
            .cannotFindHost,
            .cannotConnectToHost,
            .dnsLookupFailed,
            .timedOut
        ]

        return noInternetCodes.contains(
            URLError.Code(rawValue: networkError.code)
        )
            ? .noInternet
            : .serverError
    }
}
