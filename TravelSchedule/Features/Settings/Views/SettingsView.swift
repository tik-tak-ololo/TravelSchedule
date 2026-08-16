//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 19.07.2026.
//

import SwiftUI

@MainActor
struct SettingsView: View {

    @State private var viewModel: SettingsViewModel

    init(
        copyrightProvider: any CopyrightProviding = NetworkClient.shared
    ) {
        _viewModel = State(
            initialValue: SettingsViewModel(
                copyrightProvider: copyrightProvider
            )
        )
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            VStack(spacing: 0) {
                themeRow(isDarkTheme: $viewModel.isDarkTheme)

                NavigationLink {
                    UserAgreementView()
                } label: {
                    agreementRow
                }
                .buttonStyle(.plain)

                Spacer()

                footer
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .background(Color.backgroundColorIOS)
            .task {
                await viewModel.loadCopyright()
            }
        }
    }

    private func themeRow(isDarkTheme: Binding<Bool>) -> some View {
        HStack(spacing: 16) {
            Text("Темная тема")
                .font(.system(size: 17))
                .foregroundStyle(.textPrimaryIOS)

            Spacer()

            Toggle("", isOn: isDarkTheme)
                .labelsHidden()
                .tint(.travelBlue)
        }
        .frame(height: 60)
    }

    private var agreementRow: some View {
        HStack(spacing: 16) {
            Text("Пользовательское соглашение")
                .font(.system(size: 17))
                .foregroundStyle(.textPrimaryIOS)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.textPrimaryIOS)
        }
        .frame(height: 60)
        .contentShape(Rectangle())
    }

    private var footer: some View {
        VStack(spacing: 16) {
            if let copyrightText = viewModel.copyrightText {
                Text(copyrightText)
            }

            if let copyrightLogoURL = viewModel.copyrightLogoURL, false {
                // отключил потому что отсутствует в дизайн проекте, возможно в будущем потребуется вывод логотипа
                AsyncImage(url: copyrightLogoURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error == nil {
                        ProgressView()
                    }
                }
                .frame(height: 32)
            }

            if let copyrightURL = viewModel.copyrightURL, false {
                // отключил потому что отсутствует в дизайн проекте, возможно в будущем потребуется вывод ссылки
                Link(
                    copyrightURL.absoluteString,
                    destination: copyrightURL
                )
                .foregroundStyle(.travelBlue)
            }

            Text(viewModel.versionDescription)
        }
        .font(.system(size: 12))
        .foregroundStyle(.textPrimaryIOS)
        .multilineTextAlignment(.center)
    }
}

#Preview("Light") {
    SettingsView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    SettingsView()
        .preferredColorScheme(.dark)
}
