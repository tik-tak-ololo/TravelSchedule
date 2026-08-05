//
//  ErrorView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 23.07.2026.
//

import SwiftUI

struct ErrorView: View {

    @State private var viewModel: ErrorViewModel

    init(viewModel: ErrorViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(viewModel.errorType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 40,
                        style: .continuous
                    )
                )

            Text(viewModel.errorType.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.primary)

            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background(Color(uiColor: .backgroundColorIOS))
    }
}

#Preview("Нет интернета") {
    ErrorView(
        viewModel: ErrorViewModel(
            errorType: .noInternet
        )
    )
}

#Preview("Ошибка сервера") {
    ErrorView(
        viewModel: ErrorViewModel(
            errorType: .serverError
        )
    )
}
