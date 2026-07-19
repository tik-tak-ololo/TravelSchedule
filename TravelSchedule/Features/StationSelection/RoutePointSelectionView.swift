//
//  RoutePointSelectionView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import SwiftUI

@MainActor
struct RoutePointSelectionView: View {

    let type: RoutePointType
    let onSelected: (RoutePoint) -> Void

    @Environment(\.dismiss) private var dismiss

    private let routePoints: [RoutePoint] = [
        RoutePoint(
            city: "Москва",
            station: "Курский вокзал"
        ),
        RoutePoint(
            city: "Москва",
            station: "Ярославский вокзал"
        ),
        RoutePoint(
            city: "Москва",
            station: "Казанский вокзал"
        ),
        RoutePoint(
            city: "Санкт-Петербург",
            station: "Балтийский вокзал"
        ),
        RoutePoint(
            city: "Санкт-Петербург",
            station: "Московский вокзал"
        )
    ]

    var body: some View {
        List(routePoints, id: \.self) { routePoint in
            Button {
                onSelected(routePoint)
                dismiss()
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(routePoint.city)
                        .font(.body)
                        .foregroundStyle(Color.primary)

                    Text(routePoint.station)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle(type.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
