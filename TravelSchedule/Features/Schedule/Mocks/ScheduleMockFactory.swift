//
//  ScheduleMockFactory.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation

enum ScheduleMockFactory {

    static func makeSchedule(
        relativeTo date: Date = Date(),
        calendar: Calendar = .current
    ) -> [ScheduleItem] {
        let rzd = Carrier(
            title: "РЖД",
            logoAssetName: "CarrierRZD",
            email: "info@rzd.ru",
            phone: "+7 (800) 775-00-00"
        )

        let fgk = Carrier(
            title: "ФГК",
            logoAssetName: "CarrierFGK",
            email: "info@railfgk.ru",
            phone: "+7 (495) 988-20-00"
        )

        let uralLogistics = Carrier(
            title: "Урал логистика",
            logoAssetName: "CarrierUralLogistics",
            email: "info@ural-logistics.ru",
            phone: "+7 (343) 000-00-00"
        )

        return [
            ScheduleItem(
                carrier: rzd,
                departureDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 0,
                    hour: 22,
                    minute: 30
                ),
                arrivalDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 1,
                    hour: 8,
                    minute: 15
                ),
                transferDescription: "С пересадкой в Костроме"
            ),

            ScheduleItem(
                carrier: fgk,
                departureDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 1,
                    hour: 1,
                    minute: 15
                ),
                arrivalDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 1,
                    hour: 9,
                    minute: 0
                )
            ),

            ScheduleItem(
                carrier: uralLogistics,
                departureDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 2,
                    hour: 12,
                    minute: 30
                ),
                arrivalDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 2,
                    hour: 21,
                    minute: 0
                )
            ),

            ScheduleItem(
                carrier: rzd,
                departureDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 3,
                    hour: 22,
                    minute: 30
                ),
                arrivalDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 4,
                    hour: 8,
                    minute: 15
                ),
                transferDescription: "С пересадкой в Костроме"
            ),

            ScheduleItem(
                carrier: rzd,
                departureDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 4,
                    hour: 22,
                    minute: 30
                ),
                arrivalDate: makeDate(
                    relativeTo: date,
                    calendar: calendar,
                    dayOffset: 5,
                    hour: 8,
                    minute: 15
                )
            )
        ]
    }

    private static func makeDate(
        relativeTo date: Date,
        calendar: Calendar,
        dayOffset: Int,
        hour: Int,
        minute: Int
    ) -> Date {
        let startOfDay = calendar.startOfDay(for: date)

        guard
            let shiftedDate = calendar.date(
                byAdding: .day,
                value: dayOffset,
                to: startOfDay
            ),
            let result = calendar.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: shiftedDate
            )
        else {
            assertionFailure("Не удалось сформировать дату мокового рейса")
            return date
        }

        return result
    }
}
