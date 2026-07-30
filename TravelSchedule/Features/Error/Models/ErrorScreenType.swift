//
//  ErrorScreenType.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 23.07.2026.
//

import Foundation

enum ErrorScreenType {
    case noInternet
    case serverError

    var imageName: String {
        switch self {
        case .noInternet:
            return "NoInternetError"

        case .serverError:
            return "ServerError"
        }
    }

    var title: String {
        switch self {
        case .noInternet:
            return "Нет интернета"

        case .serverError:
            return "Ошибка сервера"
        }
    }
}
