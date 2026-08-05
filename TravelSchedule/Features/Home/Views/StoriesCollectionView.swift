//
//  StoriesCollectionView.swift
//  TravelSchedule
//

import SwiftUI

struct StoriesCollectionView: View {

    let stories: [Story]
    let onStoryTap: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(stories) { story in
                    Button {
                        onStoryTap(story.id)
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            Image(story.imageName)
                                .resizable()
                                .scaledToFill()

                            LinearGradient(
                                colors: [.clear, .black.opacity(0.8)],
                                startPoint: .center,
                                endPoint: .bottom
                            )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(story.title)
                                    .font(.system(size: 12, weight: .semibold))
                                    .lineLimit(3)
                            }
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .padding(8)
                        }
                        .frame(width: 92, height: 140)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                        .opacity(story.isViewed ? 0.5 : 1)
                        .overlay {
                            if !story.isViewed {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.travelBlue, lineWidth: 4)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(story.accessibilityLabel)
                    .accessibilityValue(
                        story.isViewed ? "Просмотрено" : "Не просмотрено"
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(height: 140)
    }
}

#Preview {
    StoriesCollectionView(
        stories: Story.mocks,
        onStoryTap: { _ in }
    )
    .padding()
}
