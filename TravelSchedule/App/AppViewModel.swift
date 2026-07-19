//
//  AppViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {

    @Published private(set) var screen: AppScreen = .splash

    func showMainScreen() {
        screen = .main
    }
}
