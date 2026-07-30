//
//  AppViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class AppViewModel {

    private(set) var screen: AppScreen = .splash

    func showMainScreen() {
        screen = .main
    }
}
