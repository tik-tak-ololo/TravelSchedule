//
//  StoriesView.swift
//  TravelSchedule
//

import SwiftUI

struct StoriesView: View {

    private enum Constants {
        static let storyDuration = 10.0
        static let horizontalSwipeThreshold = 50.0
        static let verticalDismissThreshold = 80.0
    }

    let stories: [StoryPreview]

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int
    @State private var storyStartedAt = Date()
    @State private var playbackID = 0

    init(stories: [StoryPreview], initialIndex: Int) {
        self.stories = stories
        _currentIndex = State(
            initialValue: min(max(initialIndex, 0), max(stories.count - 1, 0))
        )
    }

    var body: some View {
        ZStack {
            Color(red: 0.11, green: 0.12, blue: 0.15)
                .ignoresSafeArea()

            if stories.indices.contains(currentIndex) {
                storyContent(stories[currentIndex])
            }
        }
        .preferredColorScheme(.dark)
        .statusBarHidden(false)
        .task(id: "\(currentIndex)-\(playbackID)") {
            await startStoryTimer()
        }
    }

    private func storyContent(_ story: StoryPreview) -> some View {
        GeometryReader { proxy in
            ZStack {
                Image(story.fullImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.82)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                VStack(spacing: 0) {
                    progressIndicators
                        .padding(.horizontal, 12)
                        .padding(.top, 28)

                    HStack {
                        Spacer()

                        closeButton
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 12)

                    Spacer()

                    storyText(story)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .contentShape(Rectangle())
            .onTapGesture { location in
                if location.x < proxy.size.width / 2 {
                    showPreviousStory()
                } else {
                    showNextStory()
                }
            }
            .highPriorityGesture(swipeGesture)
        }
    }

    private var progressIndicators: some View {
        TimelineView(.animation) { context in
            let currentProgress = indicatorProgress(
                at: currentIndex,
                date: context.date
            )

            HStack(spacing: 6) {
                ForEach(stories.indices, id: \.self) { index in
                    GeometryReader { proxy in
                        Capsule()
                            .fill(.white)
                            .overlay(alignment: .leading) {
                                Capsule()
                                    .fill(.blue)
                                    .frame(
                                        width: proxy.size.width * indicatorProgress(
                                            at: index,
                                            date: context.date
                                        )
                                    )
                            }
                    }
                    .frame(height: 6)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Сторис \(currentIndex + 1) из \(stories.count)")
            .accessibilityValue(
                "Осталось \(Int(ceil((1 - currentProgress) * Constants.storyDuration))) секунд"
            )
        }
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(.black.opacity(0.55), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Закрыть сторис")
    }

    private func storyText(_ story: StoryPreview) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(story.title)
                .font(.system(size: 34, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)

            Text(story.description)
                .font(.system(size: 20))
                .lineLimit(3)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let horizontalDistance = value.translation.width
                let verticalDistance = value.translation.height

                if verticalDistance > Constants.verticalDismissThreshold,
                   abs(verticalDistance) > abs(horizontalDistance) {
                    dismiss()
                } else if horizontalDistance < -Constants.horizontalSwipeThreshold {
                    showNextStory()
                } else if horizontalDistance > Constants.horizontalSwipeThreshold {
                    showPreviousStory()
                }
            }
    }

    private func indicatorProgress(at index: Int, date: Date) -> Double {
        if index < currentIndex {
            return 1
        }

        if index == currentIndex {
            let elapsedTime = date.timeIntervalSince(storyStartedAt)
            return min(max(elapsedTime / Constants.storyDuration, 0), 1)
        }

        return 0
    }

    @MainActor
    private func startStoryTimer() async {
        storyStartedAt = .now

        do {
            try await Task.sleep(for: .seconds(Constants.storyDuration))
        } catch {
            return
        }

        showNextStory()
    }

    private func showPreviousStory() {
        guard currentIndex > stories.startIndex else {
            restartCurrentStory()
            return
        }

        updateCurrentIndex(to: currentIndex - 1)
    }

    private func showNextStory() {
        guard currentIndex < stories.count - 1 else {
            dismiss()
            return
        }

        updateCurrentIndex(to: currentIndex + 1)
    }

    private func restartCurrentStory() {
        playbackID += 1
    }

    private func updateCurrentIndex(to newIndex: Int) {
        var transaction = Transaction()
        transaction.disablesAnimations = true

        withTransaction(transaction) {
            storyStartedAt = .now
            currentIndex = newIndex
        }
    }
}

#Preview {
    StoriesView(
        stories: [
            StoryPreview(
                id: 0,
                imageName: "Story1",
                title: "Откройте мир новых маршрутов",
                description: "Находите вдохновение для путешествий и планируйте следующую поездку вместе с нами.",
                accessibilityLabel: "История о путешествии"
            )
        ],
        initialIndex: 0
    )
}
