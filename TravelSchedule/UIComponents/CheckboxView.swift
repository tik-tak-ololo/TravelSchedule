//
//  CheckboxView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import SwiftUI

struct CheckboxView: View {

    let isSelected: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(
                    Color.primary,
                    lineWidth: 2
                )

            if isSelected {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary)

                Image(systemName: "checkmark")
                    .font(
                        .system(
                            size: 13,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.backgroundColorIOS)
            }
        }
        .frame(width: 20, height: 20)
        .animation(
            .easeInOut(duration: 0.15),
            value: isSelected
        )
    }
}
