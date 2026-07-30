//
//  City.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import Foundation

struct City: Identifiable, Hashable {

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

extension City {

    static let mockCities: [City] = [
        City(name: "Москва"),
        City(name: "Санкт Петербург"),
        City(name: "Сочи"),
        City(name: "Горный воздух"),
        City(name: "Краснодар"),
        City(name: "Казань"),
        City(name: "Омск")
    ]
}
