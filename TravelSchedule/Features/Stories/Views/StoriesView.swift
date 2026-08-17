//
//  StoriesView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 17.08.2026.
//

import SwiftUI

@MainActor
struct StoriesView: View {

    private enum Constants {
        static let horizontalSwipeThreshold = 50.0
        static let verticalDismissThreshold = 120.0
    }

    private enum DragAxis {
        case horizontal
        case vertical
    }

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: StoriesViewModel
    @State private var verticalDragOffset = 0.0
    @State private var dragAxis: DragAxis?

    init(
        stories: [Story],
        initialIndex: Int,
        onStoryViewed: @escaping (Int) -> Void
    ) {
        _viewModel = State(
            initialValue: StoriesViewModel(
                stories: stories,
                initialIndex: initialIndex,
                onStoryViewed: onStoryViewed
            )
        )
    }

    var body: some View {
        ZStack {
            Color(red: 0.11, green: 0.12, blue: 0.15)
                .ignoresSafeArea()

            if let currentStory = viewModel.currentStory {
                storyContent(currentStory)
                    .offset(y: verticalDragOffset)
            }
        }
        .preferredColorScheme(.dark)
        .statusBarHidden(false)
        .task(id: viewModel.currentStoryTaskID) {
            viewModel.markCurrentStoryAsViewed()
        }
        .task(id: viewModel.playbackTaskID) {
            let transition = await viewModel.startStoryTimer()
            handle(transition)
        }
    }

    private func storyContent(_ story: Story) -> some View {
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
                    handle(viewModel.showPreviousStory())
                } else {
                    handle(viewModel.showNextStory())
                }
            }
            .highPriorityGesture(swipeGesture)
            .simultaneousGesture(playbackPauseGesture)
        }
    }

    private var progressIndicators: some View {
        TimelineView(.animation) { context in
            HStack(spacing: 6) {
                ForEach(viewModel.stories.indices, id: \.self) { index in
                    GeometryReader { proxy in
                        Capsule()
                            .fill(.white)
                            .overlay(alignment: .leading) {
                                Capsule()
                                    .fill(.blue)
                                    .frame(
                                        width: proxy.size.width
                                            * viewModel.indicatorProgress(
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
            .accessibilityLabel(
                "Сторис \(viewModel.currentIndex + 1) из \(viewModel.stories.count)"
            )
            .accessibilityValue(
                "Осталось \(viewModel.remainingSeconds(at: context.date)) секунд"
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

    private func storyText(_ story: Story) -> some View {
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
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onChanged { value in
                let horizontalDistance = value.translation.width
                let verticalDistance = value.translation.height

                if dragAxis == nil {
                    dragAxis = abs(verticalDistance) > abs(horizontalDistance)
                        ? .vertical
                        : .horizontal
                }

                guard dragAxis == .vertical else {
                    return
                }

                verticalDragOffset = max(verticalDistance, 0)
            }
            .onEnded { value in
                let horizontalDistance = value.translation.width
                let verticalDistance = value.translation.height
                let completedDragAxis = dragAxis

                dragAxis = nil

                switch completedDragAxis {
                case .vertical:
                    if verticalDistance > Constants.verticalDismissThreshold {
                        dismiss()
                    } else {
                        resetVerticalDragOffset()
                    }

                case .horizontal:
                    verticalDragOffset = 0

                    if horizontalDistance < -Constants.horizontalSwipeThreshold {
                        handle(viewModel.showNextStory())
                    } else if horizontalDistance > Constants.horizontalSwipeThreshold {
                        handle(viewModel.showPreviousStory())
                    }

                case nil:
                    resetVerticalDragOffset()
                }
            }
    }

    private var playbackPauseGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { _ in
                viewModel.pauseStoryPlayback()
            }
            .onEnded { _ in
                viewModel.resumeStoryPlayback()
            }
    }

    private func resetVerticalDragOffset() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            verticalDragOffset = 0
        }
    }

    private func handle(_ transition: StoriesViewModel.Transition) {
        if case .dismiss = transition {
            dismiss()
        }
    }
}

#Preview {
    StoriesView(
        stories: Story.mocks,
        initialIndex: 0,
        onStoryViewed: { _ in }
    )
}
