//
//  UserAgreementView.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 17.08.2026.
//

import SwiftUI
import WebKit

@MainActor
struct UserAgreementView: View {

    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel: UserAgreementViewModel

    init(offerURL: URL? = UserAgreementViewModel.defaultOfferURL) {
        _viewModel = State(
            initialValue: UserAgreementViewModel(offerURL: offerURL)
        )
    }

    var body: some View {
        Group {
            if let offerURL = viewModel.offerURL {
                WebView(
                    url: offerURL,
                    colorScheme: colorScheme
                )
            }
        }
        .background(Color.backgroundColorIOS)
        .navigationTitle("Пользовательское соглашение")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(edges: .bottom)
    }
}

@MainActor
private struct WebView: View {

    let url: URL
    let colorScheme: ColorScheme

    @State private var webView = WKWebView()

    private var loadConfiguration: LoadConfiguration {
        LoadConfiguration(
            url: url,
            theme: WebsiteTheme(colorScheme: colorScheme)
        )
    }

    var body: some View {
        WebViewRepresentable(
            webView: webView,
            theme: loadConfiguration.theme
        )
        .task(id: loadConfiguration) {
            await loadPage(using: loadConfiguration)
        }
    }

    private func loadPage(using configuration: LoadConfiguration) async {
        if let cookie = configuration.theme.cookie {
            await webView.configuration.websiteDataStore.httpCookieStore
                .setCookie(cookie)
        }

        guard !Task.isCancelled else {
            return
        }

        webView.load(URLRequest(url: configuration.url))
    }
}

private extension WebView {

    struct LoadConfiguration: Equatable {
        let url: URL
        let theme: WebsiteTheme
    }

    struct WebViewRepresentable: UIViewRepresentable {
        let webView: WKWebView
        let theme: WebsiteTheme

        func makeUIView(context: Context) -> WKWebView {
            configure(webView, for: theme)
            return webView
        }

        func updateUIView(_ webView: WKWebView, context: Context) {
            configure(webView, for: theme)
        }

        static func dismantleUIView(
            _ webView: WKWebView,
            coordinator: Void
        ) {
            webView.stopLoading()
        }

        private func configure(
            _ webView: WKWebView,
            for theme: WebsiteTheme
        ) {
            webView.overrideUserInterfaceStyle = theme.userInterfaceStyle
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.backgroundColor = .clear
        }
    }

    enum WebsiteTheme: String {
        case light
        case dark

        init(colorScheme: ColorScheme) {
            self = colorScheme == .dark ? .dark : .light
        }

        var userInterfaceStyle: UIUserInterfaceStyle {
            switch self {
            case .light:
                .light
            case .dark:
                .dark
            }
        }

        var cookie: HTTPCookie? {
            HTTPCookie(
                properties: [
                    .domain: "yandex.ru",
                    .path: "/",
                    .name: "documentation_theme",
                    .value: rawValue,
                    .secure: "TRUE"
                ]
            )
        }
    }
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
