//
//  NetworkError.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badRequest
    case noData
    case decodingFailed
    case tooManyRequests
    case apiKeyInvalid
    case serverError
    case missingApiBaseURL
    case missingApiKey
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: 
            "Invalid URL"
        case .invalidResponse: 
            "Invalid Response"
        case .noData: 
            "No data received"
        case .decodingFailed: 
            "Failed to decode the data"
        case .badRequest:
            "Bad Request"
        case .tooManyRequests:
            "Too many requests. Please try again later."
        case .apiKeyInvalid: 
            "API key is invalid."
        case .serverError:
            "Server Error."
        case .missingApiBaseURL:
            "API Base URL is missing"
        case .missingApiKey:
            "API Key is missing"
        case .custom(let message):
            message
        }
    }
}
