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

private struct WebView: UIViewRepresentable {

    let url: URL
    let colorScheme: ColorScheme

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let theme = WebsiteTheme(colorScheme: colorScheme)

        context.coordinator.theme = theme
        configure(webView, for: theme)
        setCookie(for: theme, in: webView) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let theme = WebsiteTheme(colorScheme: colorScheme)

        guard context.coordinator.theme != theme else {
            return
        }

        context.coordinator.theme = theme
        configure(webView, for: theme)
        setCookie(for: theme, in: webView) {
            webView.reload()
        }
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

    private func setCookie(
        for theme: WebsiteTheme,
        in webView: WKWebView,
        completion: @escaping @MainActor @Sendable () -> Void
    ) {
        guard let cookie = theme.cookie else {
            completion()
            return
        }

        webView.configuration.websiteDataStore.httpCookieStore.setCookie(
            cookie
        ) {
            Task { @MainActor in
                completion()
            }
        }
    }
}

private extension WebView {

    final class Coordinator {
        var theme: WebsiteTheme?
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
