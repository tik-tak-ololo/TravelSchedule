//
//  RadioButtonView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import SwiftUI

struct RadioButtonView: View {

    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.primary,
                    lineWidth: 2
                )

            if isSelected {
                Circle()
                    .fill(Color.primary)
                    .padding(5)
            }
        }
        .frame(width: 20, height: 20)
        .animation(
            .easeInOut(duration: 0.15),
            value: isSelected
        )
    }
}
