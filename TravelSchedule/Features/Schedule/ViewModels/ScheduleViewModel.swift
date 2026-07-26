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
    @Published var filter = ScheduleFilter()

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
            .filter(matchesTransferFilter)
            .filter(matchesDepartureTimeFilter)
            .sorted {
                $0.departureDate < $1.departureDate
            }
    }

    var isFilterApplied: Bool {
        !filter.isEmpty
    }

    func applyFilter(_ filter: ScheduleFilter) {
        self.filter = filter
    }

    private func matchesTransferFilter(
        _ item: ScheduleItem
    ) -> Bool {
        guard let transferOption = filter.transferOption else {
            return true
        }

        switch transferOption {
        case .direct:
            return !item.hasTransfers

        case .withTransfers:
            return item.hasTransfers
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
