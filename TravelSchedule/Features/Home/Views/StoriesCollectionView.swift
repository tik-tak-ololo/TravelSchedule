//
//  StoriesCollectionView.swift
//  TravelSchedule
//

import SwiftUI

struct StoriesCollectionView: View {

    let stories: [StoryPreview]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(stories) { story in
                    Image(story.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 92, height: 140)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
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
                accessibilityLabel: "История о путешествии"
            )
        ]
    )
    .padding()
}
