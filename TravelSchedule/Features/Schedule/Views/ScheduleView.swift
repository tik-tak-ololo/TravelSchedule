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

    @State private var isFilterPresented = false
    @State private var isCarrierDetailsPresented = false
    @State private var selectedItem: ScheduleItem?

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
        .navigationDestination(
            isPresented: $isFilterPresented
        ) {
            ScheduleFilterView(
                filter: viewModel.filter
            ) { filter in
                viewModel.applyFilter(filter)
            }
        }
        .navigationDestination(
            isPresented: $isCarrierDetailsPresented
        ) {
            CarrierDetailsView()
        }
    }

    private var scheduleList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                routeTitle

                if viewModel.filteredScheduleItems.isEmpty {
                    emptyState
                } else {
                    scheduleCards
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 92)
        }
        .scrollIndicators(.hidden)
        .toolbar(.hidden, for: .tabBar)
    }

    private var scheduleCards: some View {
        ForEach(viewModel.filteredScheduleItems) { item in
            Button {
                selectedItem = item
                isCarrierDetailsPresented = true
            } label: {
                ScheduleCardView(item: item)
            }
            .buttonStyle(.plain)
        }
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

    private var emptyState: some View {
        Text("Вариантов нет")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .padding(.top, 180)
    }

    private var filterButton: some View {
        Button {
            isFilterPresented = true
        } label: {
            HStack(spacing: 4) {
                Text("Уточнить время")
                    .font(.system(size: 17, weight: .bold))

                if viewModel.isFilterApplied {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                }
            }
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
