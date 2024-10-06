//
//  DetailViewController.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import UIKit
import Combine

protocol DetailViewControllerDelegate: AnyObject {
    func didMarkArticleAsRead(_ article: Article)
}

final class DetailViewController: UIViewController {
    weak var delegate: DetailViewControllerDelegate?
    private var rootView = DetailRootView()
    private let viewModel: DetailViewModel
    private var webViewManager: DetailWebViewManager?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        webViewManager = DetailWebViewManager(webView: rootView.webView, viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        bindAction()
        viewModel.state = .loadWebView
    }
}

extension DetailViewController {
    private func setupNavigation() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.text = viewModel.article.title
        titleLabel.textColor = .systemBlue
        navigationItem.titleView = titleLabel
    }
}

extension DetailViewController {
    private func bindAction() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .loadWebView(let url):
                    self?.rootView.loadWebView(url: url)
                case .didMarkArticleAsRead(let article):
                    self?.delegate?.didMarkArticleAsRead(article)
                case .showLoading(let isLoading):
                    if isLoading {
                        self?.showLoadingView(isBlocking: false)
                    } else {
                        self?.hideLoadingView()
                    }
                }
            }.store(in: &cancellables)
    }
}
