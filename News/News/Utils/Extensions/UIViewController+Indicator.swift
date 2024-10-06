//
//  UIViewController+Indicator.swift
//  News
//
//  Created by 송우진 on 10/5/24.
//

import UIKit

extension UIViewController {
    func showLoadingView(isBlocking: Bool = true) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first(where: { $0.isKeyWindow })
        else { return }
        Task { @MainActor in
            guard window.viewWithTag(999) == nil else { return }
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.center = window.center
            spinner.color = .systemBlue
            spinner.tag = 999
            if isBlocking {
                let backgroundView = UIView(frame: window.bounds)
                backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                backgroundView.tag = 998
                backgroundView.addSubview(spinner)
                window.addSubview(backgroundView)
            } else {
                window.addSubview(spinner)
            }
            spinner.startAnimating()
        }
    }
    
    func hideLoadingView() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first(where: { $0.isKeyWindow })
        else { return }
        Task { @MainActor in
            window.viewWithTag(999)?.removeFromSuperview()
            window.viewWithTag(998)?.removeFromSuperview()
        }
    }
}
