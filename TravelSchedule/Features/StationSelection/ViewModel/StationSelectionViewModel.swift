//
//  StationSelectionViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class StationSelectionViewModel {

    var searchText = ""

    private let stations: [Station]

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

    init(stations: [Station]) {
        self.stations = stations
    }

    func clearSearch() {
        searchText = ""
    }
}
