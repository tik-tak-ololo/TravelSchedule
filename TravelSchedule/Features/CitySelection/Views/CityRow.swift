//
//  CityRow.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import SwiftUI

struct CityRow: View {

    let city: City
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(city.name)
                    .font(.system(size: 17))
                    .foregroundStyle(.textPrimaryIOS)
                    .multilineTextAlignment(.leading)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.textPrimaryIOS)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(city.name)
        .accessibilityHint("Выбрать город")
    }
}
