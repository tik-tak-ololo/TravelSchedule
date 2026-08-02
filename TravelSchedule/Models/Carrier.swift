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
    let logoSmallAssetName: String
    let logoAssetName: String
    let website: URL?
    let email: String?
    let phone: String?

    init(
        id: UUID = UUID(),
        title: String,
        logoSmallAssetName: String,
        logoAssetName: String,
        website: URL? = nil,
        email: String? = nil,
        phone: String? = nil
    ) {
        self.id = id
        self.title = title
        self.logoSmallAssetName = logoSmallAssetName
        self.logoAssetName = logoAssetName
        self.website = website
        self.email = email
        self.phone = phone
    }
}
