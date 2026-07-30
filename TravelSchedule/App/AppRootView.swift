//
//  AppRootView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import SwiftUI

struct AppRootView: View {

    @State private var viewModel = AppViewModel()

    var body: some View {
        ZStack {
            switch viewModel.screen {
            case .splash:
                SplashView {
                    viewModel.showMainScreen()
                }
                .transition(.opacity)

            case .main:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(
            .easeInOut(duration: 0.3),
            value: viewModel.screen
        )
    }
}

#Preview {
    AppRootView()
}
