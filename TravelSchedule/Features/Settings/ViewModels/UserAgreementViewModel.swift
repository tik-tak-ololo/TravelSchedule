//
//  UserAgreementViewModel.swift
//  TravelSchedule
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
