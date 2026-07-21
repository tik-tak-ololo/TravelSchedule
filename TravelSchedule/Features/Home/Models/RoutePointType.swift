//
//  RoutePointType.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import Foundation

enum RoutePointType: Hashable {
    case departure
    case destination

    var navigationTitle: String {
        switch self {
        case .departure:
            return "Откуда"
        case .destination:
            return "Куда"
        }
    }
}
