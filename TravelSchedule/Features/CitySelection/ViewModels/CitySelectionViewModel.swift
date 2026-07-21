//
//  CitySelectionViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import Foundation
import Combine

@MainActor
final class CitySelectionViewModel: ObservableObject {

    @Published var searchText = ""

    private let cities: [City]

    init(cities: [City] = City.mockCities) {
        self.cities = cities
    }

    var filteredCities: [City] {
        let normalizedSearchText = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedSearchText.isEmpty else {
            return cities
        }

        return cities.filter { city in
            city.name.localizedCaseInsensitiveContains(normalizedSearchText)
        }
    }

    var isCityNotFound: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && filteredCities.isEmpty
    }

    func clearSearch() {
        searchText = ""
    }
}
