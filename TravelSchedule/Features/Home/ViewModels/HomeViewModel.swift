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

    let stories = [
        StoryPreview(
            id: 0,
            imageName: "Story1",
            accessibilityLabel: "История о путешествии, 1"
        ),
        StoryPreview(
            id: 1,
            imageName: "Story2",
            accessibilityLabel: "История о путешествии, 2"
        ),
        StoryPreview(
            id: 2,
            imageName: "Story3",
            accessibilityLabel: "История о путешествии, 3"
        ),
        StoryPreview(
            id: 3,
            imageName: "Story4",
            accessibilityLabel: "История о путешествии, 4"
        ),
        StoryPreview(
            id: 4,
            imageName: "Story5",
            accessibilityLabel: "История о путешествии, 5"
        ),
        StoryPreview(
            id: 5,
            imageName: "Story6",
            accessibilityLabel: "История о путешествии, 6"
        ),
        StoryPreview(
            id: 6,
            imageName: "Story7",
            accessibilityLabel: "История о путешествии, 7"
        ),
        StoryPreview(
            id: 7,
            imageName: "Story8",
            accessibilityLabel: "История о путешествии, 8"
        ),
        StoryPreview(
            id: 8,
            imageName: "Story9",
            accessibilityLabel: "История о путешествии, 9"
        )
    ]

    private(set) var departure: RoutePoint?
    private(set) var destination: RoutePoint?

    var isSearchButtonVisible: Bool {
        departure != nil && destination != nil
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
