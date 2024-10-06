//
//  DetailRootView.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import UIKit
import WebKit

final class DetailRootView: UIView {
    private var webView: WKWebView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadWebView(url: String) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension DetailRootView {
    private func setupStyle() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubview(webView, autoLayout: [.fill(0)])
    }
}
