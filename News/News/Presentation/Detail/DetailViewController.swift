//
//  DetailViewController.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    private var rootView = DetailRootView()
    private let viewModel: DetailViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
                }
            }.store(in: &cancellables)
    }
}
