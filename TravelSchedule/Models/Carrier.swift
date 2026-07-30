//
//  Carrier.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation

struct Carrier: Identifiable, Hashable {

    let id: UUID
    let title: String
    let logoAssetName: String
    let email: String?
    let phone: String?

    init(
        id: UUID = UUID(),
        title: String,
        logoAssetName: String,
        email: String? = nil,
        phone: String? = nil
    ) {
        self.id = id
        self.title = title
        self.logoAssetName = logoAssetName
        self.email = email
        self.phone = phone
    }
}
