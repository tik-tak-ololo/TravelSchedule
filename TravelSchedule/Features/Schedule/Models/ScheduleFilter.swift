//
//  ScheduleFilter.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation

struct ScheduleFilter: Hashable {

    var departureTimeOptions: Set<DepartureTimeOption> = []
    var transfersOption: TransfersOption?

    var isEmpty: Bool {
        departureTimeOptions.isEmpty && transfersOption == nil
    }
}

enum DepartureTimeOption: String, CaseIterable, Identifiable, Hashable {

    case morning
    case day
    case evening
    case night

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .morning:
            return "Утро 06:00 – 12:00"

        case .day:
            return "День 12:00 – 18:00"

        case .evening:
            return "Вечер 18:00 – 00:00"

        case .night:
            return "Ночь 00:00 – 06:00"
        }
    }

    func contains(hour: Int) -> Bool {
        switch self {
        case .morning:
            return (6..<12).contains(hour)

        case .day:
            return (12..<18).contains(hour)

        case .evening:
            return (18..<24).contains(hour)

        case .night:
            return (0..<6).contains(hour)
        }
    }
}

enum TransfersOption: String, CaseIterable, Identifiable, Hashable {

    case show
    case hide

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .show:
            return "Да"

        case .hide:
            return "Нет"
        }
    }
}
