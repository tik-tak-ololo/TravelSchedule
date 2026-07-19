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
    private var splashTask: Task<Void, Never>?

    init(displayDuration: Duration = .seconds(2)) {
        self.displayDuration = displayDuration
    }

    func start() {
        guard splashTask == nil else {
            return
        }

        splashTask = Task { [weak self] in
            guard let self else {
                return
            }

            try? await Task.sleep(for: displayDuration)

            guard !Task.isCancelled else {
                return
            }

            isFinished = true
        }
    }

    func cancel() {
        splashTask?.cancel()
        splashTask = nil
    }

    deinit {
        splashTask?.cancel()
    }
}
