import Foundation
import Observation

enum AppStorageKey {
    static let isDarkTheme = "isDarkTheme"
}

@MainActor
@Observable
final class SettingsViewModel {

    var isDarkTheme: Bool {
        didSet {
            userDefaults.set(
                isDarkTheme,
                forKey: AppStorageKey.isDarkTheme
            )
        }
    }

    private(set) var copyrightText: String?
    private(set) var copyrightLogoURL: URL?
    private(set) var copyrightURL: URL?

    private let copyrightProvider: any CopyrightProviding
    private let userDefaults: UserDefaults
    private var hasLoadedCopyright = false

    init(
        copyrightProvider: any CopyrightProviding = NetworkClient.shared,
        userDefaults: UserDefaults = .standard
    ) {
        self.copyrightProvider = copyrightProvider
        self.userDefaults = userDefaults
        isDarkTheme = userDefaults.bool(
            forKey: AppStorageKey.isDarkTheme
        )
    }

    var versionDescription: String {
        let version = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? "1.0"

        return "Версия \(version) (beta)"
    }

    func loadCopyright() async {
        guard !hasLoadedCopyright else {
            return
        }

        hasLoadedCopyright = true

        do {
            let copyright = try await copyrightProvider.getCopyright().copyright

            copyrightText = copyright.text
            copyrightLogoURL = URL(string: copyright.logo_hy)
            copyrightURL = URL(string: copyright.url)
        } catch is CancellationError {
            hasLoadedCopyright = false
        } catch {
            copyrightText = nil
            copyrightLogoURL = nil
            copyrightURL = nil
        }
    }
}
