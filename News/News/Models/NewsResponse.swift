//
//  NewsResponse.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
