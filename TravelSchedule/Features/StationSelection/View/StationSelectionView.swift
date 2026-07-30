//
//  StationSelectionView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import SwiftUI

@MainActor
struct StationSelectionView: View {

    @StateObject private var viewModel: StationSelectionViewModel
    @FocusState private var isSearchFocused: Bool

    @Environment(\.dismiss) private var dismiss

    private let city: City
    private let onStationSelected: (Station) -> Void

    init(
        city: City,
        stations: [Station],
        onStationSelected: @escaping (Station) -> Void
    ) {
        self.city = city

        _viewModel = StateObject(
            wrappedValue: StationSelectionViewModel(
                stations: stations
            )
        )

        self.onStationSelected = onStationSelected
    }

    init(
        city: City,
        onStationSelected: @escaping (Station) -> Void
    ) {
        self.city = city

        _viewModel = StateObject(
            wrappedValue: StationSelectionViewModel(
                stations: Station.mockStations(for: city)
            )
        )

        self.onStationSelected = onStationSelected
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            CitySearchField(
                text: $viewModel.searchText,
                isFocused: $isSearchFocused,
                onClear: viewModel.clearSearch
            )
            .padding(.horizontal, 16)

            content
        }
        .background(.backgroundColorIOS)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .contentShape(Rectangle())
        .onTapGesture {
            isSearchFocused = false
        }
    }

    private var navigationBar: some View {
        ZStack {
            Text("Выбор станции")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.textPrimaryIOS)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.textPrimaryIOS)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Назад")

                Spacer()
            }
        }
        .frame(height: 56)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isStationNotFound {
            stationNotFoundView
        } else {
            stationList
        }
    }

    private var stationList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredStations) { station in
                    StationRow(station: station) {
                        select(station)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var stationNotFoundView: some View {
        VStack {
            Spacer()

            Text("Станция не найдена")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.textPrimaryIOS)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func select(_ station: Station) {
        isSearchFocused = false
        onStationSelected(station)
    }
}

#Preview {
    NavigationStack {
        StationSelectionView(
            city: City(name: "Москва"),
            stations: [
                Station(name: "Киевский вокзал"),
                Station(name: "Курский вокзал"),
                Station(name: "Ярославский вокзал"),
                Station(name: "Белорусский вокзал"),
                Station(name: "Савёловский вокзал"),
                Station(name: "Ленинградский вокзал")
            ]
        ) { station in
            print(station.name)
        }
    }
}
