import Foundation

enum AppStorageKey {
    static let isDarkTheme = "isDarkTheme"
}

struct SettingsViewModel {
    let apiDescription = "Приложение использует API «Яндекс.Расписания»"

    var versionDescription: String {
        let version = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? "1.0"

        return "Версия \(version) (beta)"
    }
}
