//
//  ScheduleItem.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation

struct ScheduleItem: Identifiable, Hashable, Sendable {

    let id: UUID
    let carrier: Carrier
    let departureDate: Date
    let arrivalDate: Date
    let transferDescription: String?

    init(
        id: UUID = UUID(),
        carrier: Carrier,
        departureDate: Date,
        arrivalDate: Date,
        transferDescription: String? = nil
    ) {
        self.id = id
        self.carrier = carrier
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.transferDescription = transferDescription
    }

    var duration: TimeInterval {
        arrivalDate.timeIntervalSince(departureDate)
    }

    var hasTransfers: Bool {
        transferDescription != nil
    }
}
