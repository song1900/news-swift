//
//  DetailWebViewManager.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import WebKit

final class DetailWebViewManager: NSObject {
    private let webView: WKWebView
    private let viewModel: DetailViewModel
    
    init(
        webView: WKWebView,
        viewModel: DetailViewModel
    ) {
        self.webView = webView
        self.viewModel = viewModel
        super.init()
        configureWebView()
    }
}

extension DetailWebViewManager {
    private func configureWebView() {
        webView.navigationDelegate = self
    }
}

extension DetailWebViewManager: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        viewModel.state = .didFinishLoadWebView
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        viewModel.state = .didFailLoadView(error)
    }
}
