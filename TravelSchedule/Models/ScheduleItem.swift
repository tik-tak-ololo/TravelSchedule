//
//  ScheduleItem.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation

struct ScheduleLeg: Identifiable, Hashable, Sendable {

    let id: UUID
    let carrier: Carrier
    let departureDate: Date
    let arrivalDate: Date
    let departurePoint: String?
    let arrivalPoint: String?
    let threadUID: String?
    let number: String?
    let routeTitle: String?
    let transportType: String?

    init(
        id: UUID = UUID(),
        carrier: Carrier,
        departureDate: Date,
        arrivalDate: Date,
        departurePoint: String? = nil,
        arrivalPoint: String? = nil,
        threadUID: String? = nil,
        number: String? = nil,
        routeTitle: String? = nil,
        transportType: String? = nil
    ) {
        self.id = id
        self.carrier = carrier
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.departurePoint = departurePoint
        self.arrivalPoint = arrivalPoint
        self.threadUID = threadUID
        self.number = number
        self.routeTitle = routeTitle
        self.transportType = transportType
    }

    func replacingCarrier(with carrier: Carrier) -> ScheduleLeg {
        ScheduleLeg(
            id: id,
            carrier: carrier,
            departureDate: departureDate,
            arrivalDate: arrivalDate,
            departurePoint: departurePoint,
            arrivalPoint: arrivalPoint,
            threadUID: threadUID,
            number: number,
            routeTitle: routeTitle,
            transportType: transportType
        )
    }
}

struct ScheduleTransfer: Identifiable, Hashable, Sendable {

    let id: UUID
    let pointCode: String?
    let pointTitle: String
    let duration: TimeInterval?
    let fromStation: String?
    let toStation: String?

    init(
        id: UUID = UUID(),
        pointCode: String? = nil,
        pointTitle: String,
        duration: TimeInterval? = nil,
        fromStation: String? = nil,
        toStation: String? = nil
    ) {
        self.id = id
        self.pointCode = pointCode
        self.pointTitle = pointTitle
        self.duration = duration
        self.fromStation = fromStation
        self.toStation = toStation
    }
}

struct ScheduleItem: Identifiable, Hashable, Sendable {

    let id: UUID
    let departureDate: Date
    let arrivalDate: Date
    let legs: [ScheduleLeg]
    let transfers: [ScheduleTransfer]
    let transferDescription: String?

    init(
        id: UUID = UUID(),
        departureDate: Date,
        arrivalDate: Date,
        legs: [ScheduleLeg],
        transfers: [ScheduleTransfer] = [],
        transferDescription: String? = nil
    ) {
        self.id = id
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.legs = legs
        self.transfers = transfers
        self.transferDescription = transferDescription
    }

    init(
        id: UUID = UUID(),
        carrier: Carrier,
        departureDate: Date,
        arrivalDate: Date,
        transferDescription: String? = nil
    ) {
        self.init(
            id: id,
            departureDate: departureDate,
            arrivalDate: arrivalDate,
            legs: [
                ScheduleLeg(
                    carrier: carrier,
                    departureDate: departureDate,
                    arrivalDate: arrivalDate
                )
            ],
            transferDescription: transferDescription
        )
    }

    var duration: TimeInterval {
        arrivalDate.timeIntervalSince(departureDate)
    }

    var hasTransfers: Bool {
        !transfers.isEmpty || legs.count > 1 || transferDescription != nil
    }

    var primaryCarrier: Carrier? {
        legs.first?.carrier
    }

    var carriers: [Carrier] {
        legs.reduce(into: []) { result, leg in
            let carrier = leg.carrier
            let alreadyAdded = result.contains {
                if let code = carrier.code, let existingCode = $0.code {
                    return code == existingCode
                }

                return carrier.title.caseInsensitiveCompare($0.title)
                    == .orderedSame
            }

            if !alreadyAdded {
                result.append(carrier)
            }
        }
    }

    var carrierTitle: String {
        guard
            let title = primaryCarrier?.title.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            !title.isEmpty
        else {
            return "Перевозчик не указан"
        }

        return title
    }

    func replacingPrimaryCarrier(with carrier: Carrier) -> ScheduleItem {
        guard let firstLeg = legs.first else {
            return self
        }

        var updatedLegs = legs
        updatedLegs[updatedLegs.startIndex] = firstLeg.replacingCarrier(
            with: carrier
        )

        return ScheduleItem(
            id: id,
            departureDate: departureDate,
            arrivalDate: arrivalDate,
            legs: updatedLegs,
            transfers: transfers,
            transferDescription: transferDescription
        )
    }
}
