//
//  UIImage+Resize.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
