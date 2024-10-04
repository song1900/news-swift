//
//  FileManager+.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import UIKit
import CryptoKit

extension FileManager {
    func saveImage(
        _ image: UIImage,
        for urlString: String
    ) {
        do {
            guard let data = image.pngData() else {
                throw FileManagerError.imageConversionFailed
            }
            let filePath = try getFilePath(for: urlString)
            try data.write(to: filePath)
        } catch {
            NSLog((error as? FileManagerError)?.localizedDescription ?? "Failed to save image: \(error.localizedDescription)")
        }
    }
    
    func loadImage(for urlString: String) -> UIImage? {
        do {
            let filePath = try getFilePath(for: urlString)
            return UIImage(contentsOfFile: filePath.path())
        } catch {
            NSLog((error as? FileManagerError)?.localizedDescription ?? "Failed to load image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteImage(for urlString: String) {
        do {
            let filePath = try getFilePath(for: urlString)
            guard fileExists(atPath: filePath.path()) else { return }
            try removeItem(at: filePath)
        } catch {
            NSLog((error as? FileManagerError)?.localizedDescription ?? "Failed to delete: \(error.localizedDescription)")
        }
    }
}

// MARK: Private
extension FileManager {
    private func getFilePath(for url: String) throws -> URL {
        guard let documentDirectory = urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileManagerError.invalidPath
        }
        guard let fileName = md5(url) ?? URL(string: url)?.lastPathComponent else {
            throw FileManagerError.invalidFileName
        }
        return documentDirectory.appendingPathComponent(fileName)
    }

    private func md5(_ string: String) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        let digest = Insecure.MD5.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
