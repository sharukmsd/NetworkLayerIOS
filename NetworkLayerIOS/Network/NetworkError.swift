//
//  NetworkError.swift
//  Holla data
//
//  Created by Shahrukh on 30/10/2023.
//

import Foundation

public enum NetworkError: LocalizedError {
    case decode
    case invalidEndpoint
    case noResponse
    case unauthorized
    case dataNotFound
    case incorrectOTP
    case unexpectedStatusCode
    case forbidden
    case invalidRequest
    case unknown
    case customError(String)
}

extension NetworkError {
    public var errorDescription: String {
        switch self {
        case .decode:
            return "Oops! Something went wrong while processing the data. Please try again later."
        case .invalidEndpoint:
            return "Uh-oh! The app tried to visit an unknown place. Please let us know about this issue."
        case .noResponse:
            return "Oh no! We couldn't reach our server. Check your internet connection and try again."
        case .unauthorized:
            return "Sorry, your session has expired. Please log in again to continue."
        case .dataNotFound:
            return "Hmmm, we couldn't find the information you're looking for. Please try again or contact support."
        case .incorrectOTP:
            return "Oops! That's not the right code. Please double-check and enter the correct one."
        case .unexpectedStatusCode:
            return "Yikes! Something unexpected happened. Please try again later or contact support."
        case .forbidden:
            return "Oops! You don't have permission to access this. Check your settings or contact support."
        case .invalidRequest:
            return "Hmm, something seems off with your request. Please review and try again."
        case .customError(let message):
            return message
        default:
            return "Uh-oh! Something mysterious happened. Please contact support for assistance."
        }
    }
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.decode, .decode),
             (.invalidEndpoint, .invalidEndpoint),
             (.noResponse, .noResponse),
             (.unauthorized, .unauthorized),
             (.dataNotFound, .dataNotFound),
             (.incorrectOTP, .incorrectOTP),
             (.unexpectedStatusCode, .unexpectedStatusCode),
             (.forbidden, .forbidden),
             (.invalidRequest, .invalidRequest),
             (.unknown, .unknown):
            return true
        case let (.customError(lhsMessage), .customError(rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

public class NetworkErrorHandler {
    
    static func mapError(_ code: Int) -> NetworkError {
        switch code {
        case 200...299:
            return .decode
        case 400:
            return .invalidRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .dataNotFound
        case 500...502:
            return .unexpectedStatusCode
        default:
            return .unknown
        }
    }
}
