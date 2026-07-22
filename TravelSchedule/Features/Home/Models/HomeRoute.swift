//
//  HomeRoute.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import Foundation

enum HomeRoute: Hashable {
    case citySelection(RoutePointType)
    case stationSelection(
        city: City,
        type: RoutePointType
    )
}
