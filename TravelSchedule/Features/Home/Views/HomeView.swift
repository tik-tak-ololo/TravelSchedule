//
//  HomeView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import SwiftUI

@MainActor
struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()

    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 16) {
                routeSelectionView

                if viewModel.isSearchButtonVisible {
                    searchButton
                        .transition(
                            .move(edge: .top)
                                .combined(with: .opacity)
                        )
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .background(.backgroundColorIOS)
            .animation(
                .easeInOut(duration: 0.2),
                value: viewModel.isSearchButtonVisible
            )
            .navigationDestination(for: HomeRoute.self) { route in
                destination(for: route)
            }
        }
    }

    // MARK: - Navigation

    @ViewBuilder
    private func destination(for route: HomeRoute) -> some View {
        switch route {
        case let .citySelection(type):
            CitySelectionView { city in
                navigationPath.append(
                    HomeRoute.stationSelection(
                        city: city,
                        type: type
                    )
                )
            }

        case let .stationSelection(city, type):
            StationSelectionView(city: city) { station in
                viewModel.selectStation(
                    station,
                    in: city,
                    for: type
                )

                navigationPath.removeLast(
                    navigationPath.count
                )
            }

        case let .schedule(
            departureTitle,
            destinationTitle
        ):
            ScheduleView(
                departureTitle: departureTitle,
                destinationTitle: destinationTitle
            )
        }
    }

    // MARK: - Route selection

    private var routeSelectionView: some View {
        HStack(spacing: 16) {
            VStack(spacing: 0) {
                routePointButton(
                    title: viewModel.departure?.title,
                    placeholder: "Откуда"
                ) {
                    navigationPath.append(
                        HomeRoute.citySelection(.departure)
                    )
                }

                routePointButton(
                    title: viewModel.destination?.title,
                    placeholder: "Куда"
                ) {
                    navigationPath.append(
                        HomeRoute.citySelection(.destination)
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            }

            swapButton
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.travelBlue)
        }
    }

    private func routePointButton(
        title: String?,
        placeholder: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(title ?? placeholder)
                    .font(.system(size: 17))
                    .foregroundStyle(
                        title == nil
                            ? .textFieldPlaceHolderColorIOS
                            : .textFieldColorIOS
                    )
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Swap button

    private var swapButton: some View {
        Button {
            viewModel.swapRoutePoints()
        } label: {
            Image(.swapButton)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.travelBlue)
                .frame(width: 36, height: 36)
                .background {
                    Circle()
                        .fill(.white)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Поменять местами пункты маршрута")
    }

    // MARK: - Search button

    private var searchButton: some View {
        Button {
            guard
                let departure = viewModel.departure,
                let destination = viewModel.destination
            else {
                return
            }

            navigationPath.append(
                HomeRoute.schedule(
                    departureTitle: departure.title,
                    destinationTitle: destination.title
                )
            )
        } label: {
            Text("Найти")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 150, height: 60)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.travelBlue)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
