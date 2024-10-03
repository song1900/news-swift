//
//  Request.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import Foundation

final class Request {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func responseAsync(with urlRequestBuilder: URLRequestBuilder) async throws -> Response {
        guard let urlRequest = urlRequestBuilder.build() else {
            return .init(data: nil, error: .invalidURL)
        }
        do {
            let data = try await execute(with: urlRequest)
            return Response(data: data, error: nil)
        } catch {
            guard let networkError = error as? NetworkError else {
                return Response(data: nil, error: .custom(error.localizedDescription))
            }
            return Response(data: nil, error: networkError)
        }
    }
}

extension Request {
    private func execute(with urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        let statusCode = httpResponse.statusCode
        switch statusCode {
        case 200..<300:
            break
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.apiKeyInvalid
        case 429:
            throw NetworkError.tooManyRequests
        case 500:
            throw NetworkError.serverError
        default:
            throw NetworkError.custom("Unhandled server error with status code: \(statusCode)")
        }
        
        guard let data = data as Data? else {
            throw NetworkError.noData
        }
        
        return data
    }
}
