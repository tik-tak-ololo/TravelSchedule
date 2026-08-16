//
//  RoutePoint.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import Foundation

struct RoutePoint: Hashable, Sendable {

    let city: City
    let station: Station

    var title: String {
        "\(city.name) (\(station.name))"
    }
}
