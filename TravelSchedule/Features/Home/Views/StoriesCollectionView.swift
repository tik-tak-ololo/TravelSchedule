//
//  StoriesCollectionView.swift
//  TravelSchedule
//

import SwiftUI

struct StoriesCollectionView: View {

    let stories: [StoryPreview]
    let onStoryTap: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(stories) { story in
                    Button {
                        onStoryTap(story.id)
                    } label: {
                        Image(story.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 92, height: 140)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(story.accessibilityLabel)
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(height: 140)
    }
}

#Preview {
    StoriesCollectionView(
        stories: [
            StoryPreview(
                id: 0,
                imageName: "Story1",
                title: "История путешествия",
                description: "Найдите вдохновение для следующей поездки.",
                accessibilityLabel: "История о путешествии"
            )
        ],
        onStoryTap: { _ in }
    )
    .padding()
}
