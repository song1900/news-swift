//
//  FileManagerError.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import Foundation

extension FileManager {
    enum FileManagerError: Error {
        case imageConversionFailed
        case invalidPath
        case invalidFileName
        
        var localizedDescription: String {
            switch self {
            case .imageConversionFailed:
                "Failed to convert image to data."
            case .invalidPath:
                 "Invalid file path."
            case .invalidFileName:
                "Failed to generate a file name"
            }
        }
    }
}
