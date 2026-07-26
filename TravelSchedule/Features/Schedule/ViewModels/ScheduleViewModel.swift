//
//  ScheduleViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation
import Combine

@MainActor
final class ScheduleViewModel: ObservableObject {

    @Published private(set) var scheduleItems: [ScheduleItem]
    @Published private(set) var filter = ScheduleFilter()

    let departureTitle: String
    let destinationTitle: String

    init(
        departureTitle: String,
        destinationTitle: String,
        scheduleItems: [ScheduleItem] = ScheduleMockFactory.makeSchedule()
    ) {
        self.departureTitle = departureTitle
        self.destinationTitle = destinationTitle
        self.scheduleItems = scheduleItems
    }

    var routeTitle: String {
        "\(departureTitle) → \(destinationTitle)"
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
