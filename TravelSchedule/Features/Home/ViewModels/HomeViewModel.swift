//
//  HomeViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

    private(set) var stories = Story.mocks

    private(set) var departure: RoutePoint?
    private(set) var destination: RoutePoint?

    var isSearchButtonVisible: Bool {
        departure != nil && destination != nil
    }

    func markStoryAsViewed(id: Int) {
        guard
            let index = stories.firstIndex(where: { $0.id == id }),
            !stories[index].isViewed
        else {
            return
        }

        stories[index].isViewed = true
    }

    func select(
        _ routePoint: RoutePoint,
        for type: RoutePointType
    ) {
        switch type {
        case .departure:
            departure = routePoint

        case .destination:
            destination = routePoint
        }
    }

    func swapRoutePoints() {
        let currentDeparture = departure

        departure = destination
        destination = currentDeparture
    }

    func search() {
        guard
            let departure,
            let destination
        else {
            return
        }

        print("Поиск маршрута")
        print("Откуда: \(departure.title)")
        print("Куда: \(destination.title)")
    }
    
    func selectStation(
        _ station: Station,
        in city: City,
        for type: RoutePointType
    ) {
        let routePoint = RoutePoint(
            city: city,
            station: station
        )

        switch type {
        case .departure:
            departure = routePoint

        case .destination:
            destination = routePoint
        }
    }
}
