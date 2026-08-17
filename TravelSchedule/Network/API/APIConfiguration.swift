//
//  APIConfiguration.swift
//  TravelSchedule
//

import Foundation

enum APIConfiguration {
    private static let apiKeyInfoPlistKey = "YANDEX_RASP_API_KEY"

    static let apiKey: String = {
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: apiKeyInfoPlistKey
        ) as? String,
        !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
        apiKey != "$(YANDEX_RASP_API_KEY)" else {
            preconditionFailure(
                "API key is missing. Add it to Configurations/Secrets.xcconfig."
            )
        }

        return apiKey
    }()
}
