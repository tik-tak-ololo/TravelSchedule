//
//  UserAgreementViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 17.08.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class UserAgreementViewModel {

    static let defaultOfferURL = URL(
        string: "https://yandex.ru/legal/practicum_offer/"
    )

    let offerURL: URL?

    init(offerURL: URL? = defaultOfferURL) {
        self.offerURL = offerURL
    }
}
