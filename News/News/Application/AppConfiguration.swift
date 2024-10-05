//
//  AppConfiguration.swift
//  News
//
//  Created by 송우진 on 10/5/24.
//

import Foundation

final class AppConfiguration {
    static let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String
}
