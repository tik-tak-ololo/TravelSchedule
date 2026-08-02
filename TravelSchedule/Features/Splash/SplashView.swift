//
//  SplashView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import SwiftUI

struct SplashView: View {

    let onFinished: () -> Void

    @State
    private var viewModel = SplashViewModel()

    var body: some View {
        GeometryReader { proxy in
            Image(.splashScreen)
                .resizable()
                .scaledToFill()
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height
                )
                .clipped()
        }
        .ignoresSafeArea()
        .task {
            await viewModel.start()
        }
        .onChange(of: viewModel.isFinished) { _, isFinished in
            guard isFinished else {
                return
            }

            onFinished()
        }
    }
}

#Preview {
    SplashView {}
}
