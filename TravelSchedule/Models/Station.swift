//
//  Station.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import Foundation

struct Station: Identifiable, Hashable {

    let id: UUID
    let name: String

    init(
        id: UUID = UUID(),
        name: String
    ) {
        self.id = id
        self.name = name
    }
}

extension Station {

    static func mockStations(for city: City) -> [Station] {
        switch city.name {
        case "Москва":
            return [
                Station(name: "Киевский вокзал"),
                Station(name: "Курский вокзал"),
                Station(name: "Ярославский вокзал"),
                Station(name: "Белорусский вокзал"),
                Station(name: "Савёловский вокзал"),
                Station(name: "Ленинградский вокзал")
            ]

        case "Санкт Петербург", "Санкт-Петербург":
            return [
                Station(name: "Московский вокзал"),
                Station(name: "Ладожский вокзал"),
                Station(name: "Финляндский вокзал"),
                Station(name: "Витебский вокзал"),
                Station(name: "Балтийский вокзал")
            ]

        case "Сочи":
            return [
                Station(name: "Сочи"),
                Station(name: "Адлер"),
                Station(name: "Мацеста"),
                Station(name: "Хоста"),
                Station(name: "Лазаревская")
            ]

        case "Краснодар":
            return [
                Station(name: "Краснодар-1"),
                Station(name: "Краснодар-2"),
                Station(name: "Пашковская")
            ]

        case "Казань":
            return [
                Station(name: "Казань-Пассажирская"),
                Station(name: "Восстание-Пассажирская"),
                Station(name: "Компрессорный")
            ]

        case "Омск":
            return [
                Station(name: "Омск-Пассажирский"),
                Station(name: "Омск-Северный"),
                Station(name: "Карбышево-1")
            ]

        default:
            return [
                Station(name: "\(city.name), центральный вокзал"),
                Station(name: "\(city.name), автовокзал")
            ]
        }
    }
}
