//
//  Article.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import Foundation

struct Article: Decodable, Hashable {
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    var isRead: Bool = false
    
    var publishedDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: publishedAt)
    }
}
