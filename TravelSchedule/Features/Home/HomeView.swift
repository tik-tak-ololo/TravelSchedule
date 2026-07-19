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
    @State private var selectionType: RoutePointType?

    var body: some View {
        NavigationStack {
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
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .animation(
                .easeInOut(duration: 0.2),
                value: viewModel.isSearchButtonVisible
            )
            .navigationDestination(item: $selectionType) { type in
                RoutePointSelectionView(type: type) { routePoint in
                    viewModel.select(routePoint, for: type)
                    selectionType = nil
                }
            }
        }
    }

    private var routeSelectionView: some View {
        HStack(spacing: 16) {
            VStack(spacing: 0) {
                routePointButton(
                    title: viewModel.departure?.title,
                    placeholder: "Откуда"
                ) {
                    selectionType = .departure
                }

                routePointButton(
                    title: viewModel.destination?.title,
                    placeholder: "Куда"
                ) {
                    selectionType = .destination
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
                            ? Color.secondary
                            : Color.primary
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

    private var swapButton: some View {
        Button {
            viewModel.swapRoutePoints()
        } label: {
            Image(systemName: "arrow.up.arrow.down")
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

    private var searchButton: some View {
        Button {
            viewModel.search()
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
