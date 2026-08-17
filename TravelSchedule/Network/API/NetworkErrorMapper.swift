//
//  NetworkErrorMapper.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 18.08.2026.
//

import Foundation
import OpenAPIRuntime

enum NetworkErrorMapper {

    private static let noInternetCodes: Set<URLError.Code> = [
        .notConnectedToInternet,
        .networkConnectionLost,
        .cannotFindHost,
        .cannotConnectToHost,
        .dnsLookupFailed,
        .timedOut
    ]

    static func map(_ error: Error) -> ErrorScreenType {
        let underlyingError = if let clientError = error as? ClientError {
            clientError.underlyingError
        } else {
            error
        }
        let networkError = underlyingError as NSError

        guard networkError.domain == NSURLErrorDomain else {
            return .serverError
        }

        let urlErrorCode = URLError.Code(rawValue: networkError.code)

        return noInternetCodes.contains(urlErrorCode)
            ? .noInternet
            : .serverError
    }
}
