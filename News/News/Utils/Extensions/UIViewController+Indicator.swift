//
//  UIViewController+Indicator.swift
//  News
//
//  Created by 송우진 on 10/5/24.
//

import UIKit

extension UIViewController {
    func showLoadingView() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first(where: { $0.isKeyWindow })
        else { return }
        Task { @MainActor in
            guard window.viewWithTag(999) == nil else { return }
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.center = window.center
            let backgroundView = UIView(frame: window.bounds)
            backgroundView.tag = 999
            backgroundView.addSubview(spinner)
            window.addSubview(backgroundView)
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
        }
    }
}
