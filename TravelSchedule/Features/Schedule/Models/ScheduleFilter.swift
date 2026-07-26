//
//  ScheduleFilter.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation

struct ScheduleFilter: Hashable {

    var departureTimeOptions: Set<DepartureTimeOption> = []
    var transferOption: TransferOption?

    var isEmpty: Bool {
        departureTimeOptions.isEmpty && transferOption == nil
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
            "Утро 06:00 – 12:00"
        case .day:
            "День 12:00 – 18:00"
        case .evening:
            "Вечер 18:00 – 00:00"
        case .night:
            "Ночь 00:00 – 06:00"
        }
    }

    func contains(hour: Int) -> Bool {
        switch self {
        case .morning:
            (6..<12).contains(hour)
        case .day:
            (12..<18).contains(hour)
        case .evening:
            (18..<24).contains(hour)
        case .night:
            (0..<6).contains(hour)
        }
    }
}

enum TransferOption: String, CaseIterable, Identifiable, Hashable {

    case direct
    case withTransfers

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .direct:
            "Без пересадок"
        case .withTransfers:
            "С пересадками"
        }
    }
}
