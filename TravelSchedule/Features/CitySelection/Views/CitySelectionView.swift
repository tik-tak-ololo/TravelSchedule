//
//  CitySelectionView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import SwiftUI

@MainActor
struct CitySelectionView: View {

    @State private var viewModel: CitySelectionViewModel
    @FocusState private var isSearchFocused: Bool

    @Environment(\.dismiss) private var dismiss

    private let onCitySelected: (City) -> Void

    init(
        viewModel: CitySelectionViewModel,
        onCitySelected: @escaping (City) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onCitySelected = onCitySelected
    }

    init(
        onCitySelected: @escaping (City) -> Void
    ) {
        _viewModel = State(
            initialValue: CitySelectionViewModel()
        )
        self.onCitySelected = onCitySelected
    }

    var body: some View {
        @Bindable var viewModel = viewModel

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
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .contentShape(Rectangle())
        .onTapGesture {
            isSearchFocused = false
        }
        .task {
            await viewModel.loadCities()
        }
    }

    private var navigationBar: some View {
        ZStack {
            Text("Выбор города")
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
        .toolbar(.hidden, for: .tabBar)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let errorScreenType = viewModel.errorScreenType {
            ErrorView(
                viewModel: ErrorViewModel(
                    errorType: errorScreenType
                )
            )
        } else if viewModel.isCityNotFound {
            cityNotFoundView
        } else {
            cityList
        }
    }

    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var cityList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredCities) { city in
                    CityRow(city: city) {
                        select(city)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var cityNotFoundView: some View {
        VStack {
            Spacer()

            Text("Город не найден")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.textPrimaryIOS)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func select(_ city: City) {
        isSearchFocused = false
        onCitySelected(city)
    }
}

#Preview {
    NavigationStack {
        CitySelectionView(
            viewModel: CitySelectionViewModel(
                cities: [
                    City(name: "Москва"),
                    City(name: "Санкт-Петербург"),
                    City(name: "Сочи"),
                    City(name: "Краснодар"),
                    City(name: "Казань"),
                    City(name: "Омск")
                ]
            )
        ) { city in
            print(city.name)
        }
    }
}
