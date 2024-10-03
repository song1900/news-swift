//
//  Response.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import Foundation

struct Response {
    let data: Data?
    let error: NetworkError?
    
    init(
        data: Data?,
        error: NetworkError?
    ) {
        self.data = data
        self.error = error
    }
    
    func decode<T: Decodable>() -> T? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func decodeString(encoding: String.Encoding = .utf8) -> String? {
        guard let data = data else { return nil }
        return String(data: data, encoding: encoding)
    }
}
