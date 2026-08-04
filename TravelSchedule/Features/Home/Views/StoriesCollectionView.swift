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
        stories: [
            StoryPreview(
                id: 0,
                imageName: "Story1",
                title: "Откройте мир новых маршрутов",
                description: "Находите вдохновение для путешествий и планируйте следующую поездку вместе с нами.",
                accessibilityLabel: "История о путешествии, 1"
            ),
            StoryPreview(
                id: 1,
                imageName: "Story2",
                title: "Путешествуйте с комфортом",
                description: "Выбирайте удобное время отправления и подходящего перевозчика для каждой поездки.",
                accessibilityLabel: "История о путешествии, 2"
            ),
            StoryPreview(
                id: 2,
                imageName: "Story3",
                title: "Билеты в любимые города",
                description: "Сравнивайте варианты и составляйте маршрут за несколько простых шагов.",
                accessibilityLabel: "История о путешествии, 3"
            ),
            StoryPreview(
                id: 3,
                imageName: "Story4",
                title: "Новые впечатления рядом",
                description: "Иногда самое интересное путешествие начинается всего в нескольких станциях от дома.",
                accessibilityLabel: "История о путешествии, 4"
            ),
            StoryPreview(
                id: 4,
                imageName: "Story5",
                title: "В путь без лишних забот",
                description: "Проверяйте расписание заранее и оставляйте больше времени для важных моментов.",
                accessibilityLabel: "История о путешествии, 5"
            ),
            StoryPreview(
                id: 5,
                imageName: "Story6",
                title: "Маршруты для ярких выходных",
                description: "Соберите друзей, выберите направление и отправляйтесь навстречу приключениям.",
                accessibilityLabel: "История о путешествии, 6"
            ),
            StoryPreview(
                id: 6,
                imageName: "Story7",
                title: "Каждая поездка — это история",
                description: "Сохраняйте любимые направления и возвращайтесь туда, где хочется оказаться снова.",
                accessibilityLabel: "История о путешествии, 7"
            ),
            StoryPreview(
                id: 7,
                imageName: "Story8",
                title: "Открывайте города по-новому",
                description: "Знакомые места могут удивить, если посмотреть на них глазами путешественника.",
                accessibilityLabel: "История о путешествии, 8"
            ),
            StoryPreview(
                id: 8,
                imageName: "Story9",
                title: "Следующая остановка — мечта",
                description: "Выберите пункт назначения, а мы поможем найти удобный путь до него.",
                accessibilityLabel: "История о путешествии, 9"
            )
        ],
        onStoryTap: { _ in }
    )
    .padding()
}
