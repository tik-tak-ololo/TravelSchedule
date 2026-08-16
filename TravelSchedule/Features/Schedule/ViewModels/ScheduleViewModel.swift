//
//  ScheduleViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation
import Observation
import OpenAPIRuntime

@MainActor
@Observable
final class ScheduleViewModel {

    private(set) var scheduleItems: [ScheduleItem]
    private(set) var filter = ScheduleFilter()
    private(set) var isLoading = false
    private(set) var errorScreenType: ErrorScreenType?

    private let departure: RoutePoint
    private let destination: RoutePoint
    private let scheduleProvider: any ScheduleProviding
    private var hasLoadedSchedule: Bool

    init(
        departure: RoutePoint,
        destination: RoutePoint,
        scheduleItems: [ScheduleItem] = [],
        scheduleProvider: any ScheduleProviding = NetworkClient.shared
    ) {
        self.departure = departure
        self.destination = destination
        self.scheduleItems = scheduleItems
        self.scheduleProvider = scheduleProvider
        hasLoadedSchedule = !scheduleItems.isEmpty
        isLoading = scheduleItems.isEmpty
    }

    var routeTitle: String {
        "\(departure.title) → \(destination.title)"
    }

    var filteredScheduleItems: [ScheduleItem] {
        scheduleItems
            .filter(matchesTransfersFilter)
            .filter(matchesDepartureTimeFilter)
            .sorted {
                $0.departureDate < $1.departureDate
            }
    }

    var isFilterApplied: Bool {
        !filter.isEmpty
    }

    func applyFilter(
        _ filter: ScheduleFilter
    ) {
        self.filter = filter
    }

    func loadSchedule() async {
        guard !hasLoadedSchedule else {
            return
        }

        hasLoadedSchedule = true
        isLoading = true
        errorScreenType = nil

        do {
            scheduleItems = try await scheduleProvider.getSchedule(
                from: departure,
                to: destination
            )
        } catch is CancellationError {
            hasLoadedSchedule = false
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

    private func matchesTransfersFilter(
        _ item: ScheduleItem
    ) -> Bool {
        guard let transfersOption = filter.transfersOption else {
            return true
        }

        switch transfersOption {
        case .show:
            // Показываем как прямые рейсы,
            // так и рейсы с пересадками.
            return true

        case .hide:
            // Оставляем только прямые рейсы.
            return !item.hasTransfers
        }
    }

    private func matchesDepartureTimeFilter(
        _ item: ScheduleItem
    ) -> Bool {
        guard !filter.departureTimeOptions.isEmpty else {
            return true
        }

        let departureHour = Calendar.current.component(
            .hour,
            from: item.departureDate
        )

        return filter.departureTimeOptions.contains {
            $0.contains(hour: departureHour)
        }
    }
}
