//
//  StoriesViewModel.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 17.08.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class StoriesViewModel {

    enum Transition {
        case stay
        case dismiss
    }

    private enum Constants {
        static let storyDuration = 10.0
    }

    let stories: [Story]

    private(set) var currentIndex: Int
    private(set) var isPlaybackPaused = false

    private var storyStartedAt = Date()
    private var elapsedTimeBeforePause = 0.0
    private var playbackID = 0

    private let onStoryViewed: (Int) -> Void

    init(
        stories: [Story],
        initialIndex: Int,
        onStoryViewed: @escaping (Int) -> Void
    ) {
        self.stories = stories
        currentIndex = min(
            max(initialIndex, 0),
            max(stories.count - 1, 0)
        )
        self.onStoryViewed = onStoryViewed
    }

    var currentStory: Story? {
        guard stories.indices.contains(currentIndex) else {
            return nil
        }

        return stories[currentIndex]
    }

    var currentStoryTaskID: String {
        "\(currentIndex)-\(playbackID)"
    }

    var playbackTaskID: String {
        "\(currentStoryTaskID)-\(isPlaybackPaused)"
    }

    func markCurrentStoryAsViewed() {
        guard let currentStory else {
            return
        }

        onStoryViewed(currentStory.id)
    }

    func indicatorProgress(at index: Int, date: Date) -> Double {
        if index < currentIndex {
            return 1
        }

        if index == currentIndex {
            let elapsedTime = storyElapsedTime(at: date)

            return min(
                max(elapsedTime / Constants.storyDuration, 0),
                1
            )
        }

        return 0
    }

    func remainingSeconds(at date: Date) -> Int {
        let progress = indicatorProgress(
            at: currentIndex,
            date: date
        )

        return Int(
            ceil((1 - progress) * Constants.storyDuration)
        )
    }

    func startStoryTimer() async -> Transition {
        guard currentStory != nil, !isPlaybackPaused else {
            return .stay
        }

        let remainingDuration = max(
            Constants.storyDuration - elapsedTimeBeforePause,
            0
        )

        do {
            try await Task.sleep(for: .seconds(remainingDuration))
        } catch {
            return .stay
        }

        guard !Task.isCancelled, !isPlaybackPaused else {
            return .stay
        }

        return showNextStory()
    }

    func showPreviousStory() -> Transition {
        guard currentIndex > stories.startIndex else {
            restartCurrentStory()
            return .stay
        }

        updateCurrentIndex(to: currentIndex - 1)
        return .stay
    }

    func showNextStory() -> Transition {
        guard currentIndex < stories.count - 1 else {
            return .dismiss
        }

        updateCurrentIndex(to: currentIndex + 1)
        return .stay
    }

    func pauseStoryPlayback() {
        guard !isPlaybackPaused else {
            return
        }

        elapsedTimeBeforePause = storyElapsedTime(at: .now)
        isPlaybackPaused = true
    }

    func resumeStoryPlayback() {
        guard isPlaybackPaused else {
            return
        }

        storyStartedAt = .now
        isPlaybackPaused = false
    }

    private func restartCurrentStory() {
        resetStoryPlayback()
        playbackID += 1
    }

    private func updateCurrentIndex(to newIndex: Int) {
        resetStoryPlayback()
        currentIndex = newIndex
    }

    private func resetStoryPlayback() {
        elapsedTimeBeforePause = 0
        storyStartedAt = .now
    }

    private func storyElapsedTime(at date: Date) -> TimeInterval {
        let elapsedTimeAfterPause = isPlaybackPaused
            ? 0
            : max(date.timeIntervalSince(storyStartedAt), 0)

        return min(
            elapsedTimeBeforePause + elapsedTimeAfterPause,
            Constants.storyDuration
        )
    }
}
