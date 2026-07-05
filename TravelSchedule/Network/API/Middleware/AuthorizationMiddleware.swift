//
//  AuthorizationMiddleware.swift
//  TravelSchedule
//
//  Created by Сергей Хмелёв on 05.07.2026.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

struct AuthorizationMiddleware: ClientMiddleware {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @concurrent @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        
        var request = request
        request.headerFields[.authorization] = apiKey
        
        return try await next(request, body, baseURL)
    }
}
