//
//  ScheduleView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import SwiftUI

@MainActor
struct ScheduleView: View {

    @StateObject private var viewModel: ScheduleViewModel

    init(
        departureTitle: String,
        destinationTitle: String
    ) {
        _viewModel = StateObject(
            wrappedValue: ScheduleViewModel(
                departureTitle: departureTitle,
                destinationTitle: destinationTitle
            )
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            scheduleList
            filterButton
        }
        .background(.backgroundColorIOS)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var scheduleList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                routeTitle

                ForEach(viewModel.scheduleItems) { item in
                    Button {
                        // TODO: Открыть CarrierDetailsView
                        // после реализации экрана.
                        print(
                            "Выбран рейс перевозчика: \(item.carrier.title)"
                        )
                    } label: {
                        ScheduleCardView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 92)
        }
        .scrollIndicators(.hidden)
    }

    private var routeTitle: some View {
        Text(viewModel.routeTitle)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.primary)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.bottom, 8)
    }

    private var filterButton: some View {
        Button {
            // TODO: Открыть ScheduleFilterView
            // после реализации экрана.
            print(
                "Переход к фильтрам расписания пока не реализован"
            )
        } label: {
            Text("Уточнить время")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.travelBlue)
                }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

#Preview("Light") {
    NavigationStack {
        ScheduleView(
            departureTitle: "Москва (Ярославский вокзал)",
            destinationTitle: "Санкт-Петербург (Балтийский вокзал)"
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        ScheduleView(
            departureTitle: "Москва (Ярославский вокзал)",
            destinationTitle: "Санкт-Петербург (Балтийский вокзал)"
        )
    }
    .preferredColorScheme(.dark)
}
