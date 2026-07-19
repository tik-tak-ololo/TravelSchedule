//
//  SplashViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import Foundation
import Combine

@MainActor
final class SplashViewModel: ObservableObject {

    @Published private(set) var isFinished = false

    private let displayDuration: Duration

    init(displayDuration: Duration = .seconds(2)) {
        self.displayDuration = displayDuration
    }

    func start() async {
        do {
            try await Task.sleep(for: displayDuration)

            guard !Task.isCancelled else {
                return
            }

            isFinished = true
        } catch is CancellationError {
            // Splash Screen был закрыт раньше окончания задержки.
            // Это ожидаемое поведение, дополнительных действий не требуется.
        } catch {
            assertionFailure("Unexpected error: \(error)")
        }
    }
}
