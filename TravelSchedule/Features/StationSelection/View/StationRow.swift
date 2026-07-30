//
//  StationRow.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 22.07.2026.
//

import SwiftUI

struct StationRow: View {

    let station: Station
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(station.name)
                    .font(.system(size: 17))
                    .foregroundStyle(.textPrimaryIOS)
                    .multilineTextAlignment(.leading)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.textPrimaryIOS)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
