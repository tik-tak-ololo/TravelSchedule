//
//  CitySelectionViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class CitySelectionViewModel {

    var searchText = ""

    private(set) var cities: [City]
    private(set) var isLoading = false
    private(set) var errorScreenType: ErrorScreenType?

    private let citiesProvider: any CitiesProviding
    private var hasLoadedCities: Bool

    init(
        cities: [City] = [],
        citiesProvider: any CitiesProviding = NetworkClient.shared
    ) {
        self.cities = cities
        self.citiesProvider = citiesProvider
        hasLoadedCities = !cities.isEmpty
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

    func loadCities() async {
        guard !hasLoadedCities else {
            return
        }

        hasLoadedCities = true
        isLoading = true
        errorScreenType = nil

        do {
            cities = try await citiesProvider.getCities()
        } catch is CancellationError {
            hasLoadedCities = false
        } catch {
            hasLoadedCities = false
            errorScreenType = NetworkErrorMapper.map(error)
        }

        isLoading = false
    }
}
