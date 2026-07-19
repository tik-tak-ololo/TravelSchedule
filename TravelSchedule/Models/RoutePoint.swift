//
//  RoutePoint.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import Foundation

struct RoutePoint: Equatable, Hashable {

    let city: String
    let station: String

    var title: String {
        "\(city) (\(station))"
    }
}
