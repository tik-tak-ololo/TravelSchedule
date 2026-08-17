//
//  Carrier.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import Foundation

struct Carrier: Identifiable, Hashable, Sendable {

    let id: UUID
    let code: String?
    let title: String
    let logoURL: URL?
    let website: URL?
    let email: String?
    let phone: String?

    init(
        id: UUID = UUID(),
        code: String? = nil,
        title: String,
        logoURL: URL? = nil,
        website: URL? = nil,
        email: String? = nil,
        phone: String? = nil
    ) {
        self.id = id
        self.code = code
        self.title = title
        self.logoURL = logoURL
        self.website = website
        self.email = email
        self.phone = phone
    }
}

extension Carrier {

    var phoneURL: URL? {
        guard let phone else { return nil }

        let allowedCharacters = CharacterSet(charactersIn: "+0123456789")
        let number = phone.unicodeScalars
            .filter { allowedCharacters.contains($0) }
            .map(String.init)
            .joined()

        guard !number.isEmpty else { return nil }

        return URL(string: "tel:\(number)")
    }
}
