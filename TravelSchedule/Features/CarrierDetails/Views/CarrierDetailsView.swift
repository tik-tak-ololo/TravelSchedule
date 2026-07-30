//
//  CarrierDetailsView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 26.07.2026.
//

import SwiftUI

struct CarrierDetailsView: View {

    var body: some View {
        Text("Информация о перевозчике")
            .font(.title)
            .fontWeight(.bold)
            .navigationTitle("Перевозчик")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CarrierDetailsView()
    }
}
