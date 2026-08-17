//
//  CarrierDetailsViewModel.swift
//  TravelSchedule
//

import Foundation
import Observation

@MainActor
@Observable
final class CarrierDetailsViewModel {

    private(set) var carrier: Carrier
    private(set) var isLoading: Bool
    private(set) var errorScreenType: ErrorScreenType?

    private let carrierProvider: any CarrierProviding
    private var hasLoadedCarrier: Bool

    init(
        carrier: Carrier,
        carrierProvider: any CarrierProviding = NetworkClient.shared
    ) {
        self.carrier = carrier
        self.carrierProvider = carrierProvider
        isLoading = carrier.code != nil
        hasLoadedCarrier = carrier.code == nil
    }

    func loadCarrier() async {
        guard !hasLoadedCarrier, let code = carrier.code else {
            return
        }

        hasLoadedCarrier = true
        isLoading = true
        errorScreenType = nil

        do {
            let loadedCarrier = try await carrierProvider.getCarrierInfo(
                code: code
            )
            carrier = Self.merged(
                current: carrier,
                loaded: loadedCarrier
            )
        } catch is CancellationError {
            hasLoadedCarrier = false
        } catch {
            errorScreenType = NetworkErrorMapper.map(error)
        }

        isLoading = false
    }

    private static func merged(
        current: Carrier,
        loaded: Carrier
    ) -> Carrier {
        let loadedTitle = loaded.title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return Carrier(
            id: current.id,
            code: loaded.code ?? current.code,
            title: loadedTitle.isEmpty ? current.title : loadedTitle,
            logoURL: loaded.logoURL ?? current.logoURL,
            website: loaded.website ?? current.website,
            email: loaded.email ?? current.email,
            phone: loaded.phone ?? current.phone
        )
    }
}
