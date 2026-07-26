//
//  ScheduleFilterViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation
import Combine

@MainActor
final class ScheduleFilterViewModel: ObservableObject {

    @Published var filter: ScheduleFilter

    init(filter: ScheduleFilter) {
        self.filter = filter
    }

    var isApplyButtonVisible: Bool {
        !filter.isEmpty
    }

    func toggleDepartureTime(
        _ option: DepartureTimeOption
    ) {
        if filter.departureTimeOptions.contains(option) {
            filter.departureTimeOptions.remove(option)
        } else {
            filter.departureTimeOptions.insert(option)
        }
    }

    func isDepartureTimeSelected(
        _ option: DepartureTimeOption
    ) -> Bool {
        filter.departureTimeOptions.contains(option)
    }

    func selectTransfersOption(
        _ option: TransfersOption
    ) {
        filter.transfersOption = option
    }

    func isTransfersOptionSelected(
        _ option: TransfersOption
    ) -> Bool {
        filter.transfersOption == option
    }
}
