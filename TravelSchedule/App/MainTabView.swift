//
//  MainTabView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import SwiftUI
import UIKit

struct MainTabView: View {

    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(Tab.home)
                .tabItem {
                    tabIcon(
                        resource: .tabHome,
                        isSelected: selectedTab == .home
                    )
                }

            SettingsView()
                .tag(Tab.settings)
                .tabItem {
                    tabIcon(
                        resource: .tabSettings,
                        isSelected: selectedTab == .settings
                    )
                }
        }
    }

    private func tabIcon(
        resource: ImageResource,
        isSelected: Bool
    ) -> Image {
        let color: UIColor = isSelected ? .tabBarActive : .tabBarInactive

        let image = UIImage(resource: resource)
            .withTintColor(
                color,
                renderingMode: .alwaysOriginal
            )

        return Image(uiImage: image)
    }
}

private extension MainTabView {

    enum Tab: Hashable {
        case home
        case settings
    }
}

#Preview {
    MainTabView()
}
