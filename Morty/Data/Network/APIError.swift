//
//  APIError.swift
//  Morty
//
//  Created by Vokal-Ican on 21/11/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case transport(URLError)
    case httpStatus(Int, message: String?)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid response from server."
        case .transport(let error):
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection."
            case .timedOut:
                return "Request timed out. Please try again."
            default:
                return "Network error. Please try again."
            }
        case .httpStatus(let code, let message):
            return message ?? "Server error (\(code))."
        case .decoding:
            return "Couldn't read the data from server"
        }
    }
}
