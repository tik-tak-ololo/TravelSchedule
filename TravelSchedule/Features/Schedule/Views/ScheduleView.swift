//
//  ScheduleView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import SwiftUI

@MainActor
struct ScheduleView: View {

    @State private var viewModel: ScheduleViewModel

    @State private var isFilterPresented = false
    @State private var selectedCarrier: Carrier?

    init(
        departure: RoutePoint,
        destination: RoutePoint,
        scheduleItems: [ScheduleItem] = []
    ) {
        _viewModel = State(
            initialValue: ScheduleViewModel(
                departure: departure,
                destination: destination,
                scheduleItems: scheduleItems
            )
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content

            if !viewModel.isLoading && viewModel.errorScreenType == nil {
                filterButton
            }
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
        .navigationDestination(item: $selectedCarrier) { carrier in
            CarrierDetailsView(carrier: carrier)
        }
        .task {
            await viewModel.loadSchedule()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorScreenType = viewModel.errorScreenType {
            ErrorView(
                viewModel: ErrorViewModel(
                    errorType: errorScreenType
                )
            )
        } else {
            scheduleList
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
            if let carrier = item.primaryCarrier {
                Button {
                    selectedCarrier = carrier
                } label: {
                    ScheduleCardView(item: item)
                }
                .buttonStyle(.plain)
            } else {
                ScheduleCardView(item: item)
            }
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
            departure: RoutePoint(
                city: City(name: "Москва"),
                station: Station(name: "Ярославский вокзал")
            ),
            destination: RoutePoint(
                city: City(name: "Санкт-Петербург"),
                station: Station(name: "Балтийский вокзал")
            ),
            scheduleItems: ScheduleMockFactory.makeSchedule()
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        ScheduleView(
            departure: RoutePoint(
                city: City(name: "Москва"),
                station: Station(name: "Ярославский вокзал")
            ),
            destination: RoutePoint(
                city: City(name: "Санкт-Петербург"),
                station: Station(name: "Балтийский вокзал")
            ),
            scheduleItems: ScheduleMockFactory.makeSchedule()
        )
    }
    .preferredColorScheme(.dark)
}
