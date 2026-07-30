//
//  ErrorViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 23.07.2026.
//

import Foundation
import Combine

@MainActor
final class ErrorViewModel: ObservableObject {

    @Published private(set) var errorType: ErrorScreenType

    init(errorType: ErrorScreenType) {
        self.errorType = errorType
    }

    func showError(_ errorType: ErrorScreenType) {
        self.errorType = errorType
    }
}
