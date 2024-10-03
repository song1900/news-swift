//
//  URLRequestBuilder.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import Foundation

struct URLRequestBuilder {
    private var url: URL?
    private var method: HTTPMethod
    private var headers: [String: String] = [:]
    
    init(
        url: String,
        method: HTTPMethod = .get
    ) {
        self.url = URL(string: url)
        self.method = method
    }
    
    @discardableResult
    mutating func addHeader(
        field: String,
        value: String
    ) -> URLRequestBuilder {
        headers[field] = value
        return self
    }
    
    @discardableResult
    mutating func addHeaders(_ headers: [String: String]) -> URLRequestBuilder {
        self.headers.merge(headers, uniquingKeysWith: { (_, new) in new } )
        return self
    }
    
    func build() -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}
