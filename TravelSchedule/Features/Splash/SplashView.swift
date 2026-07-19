//
//  SplashView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import SwiftUI

struct SplashView: View {

    let onFinished: () -> Void

    @StateObject private var viewModel: SplashViewModel = SplashViewModel()

    var body: some View {
        GeometryReader { proxy in
            Image("SplashScreen")
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
            viewModel.start()
        }
        .onDisappear {
            viewModel.cancel()
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
