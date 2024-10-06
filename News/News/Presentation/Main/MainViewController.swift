//
//  MainViewController.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    private var rootView = MainRootView()
    private let viewModel: MainViewModel
    private var collectionViewManager: MainCollectionViewManager?
    private var cancellables: Set<AnyCancellable> = .init()

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        collectionViewManager = MainCollectionViewManager(collectionView: rootView.collectionView, viewModel: viewModel)
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
        viewModel.state = .fetchTopHeadlines
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionViewManager?.update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        hideLoadingView()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionViewManager?.reloadData()
    }
}

extension MainViewController {
    private func setupNavigation() {
        title = "NEWS"
    }
}

extension MainViewController {
    private func bindAction() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .didFetchTopHeadlines:
                    self?.collectionViewManager?.update()
                case .showLoading(let isLoading):
                    if isLoading {
                        self?.showLoadingView()
                    } else {
                        self?.hideLoadingView()
                    }
                case .showDetail(let article):
                    self?.showDetailViewController(with: article)
                }
            }.store(in: &cancellables)
    }
    
    private func showDetailViewController(with article: Article) {
        let detailViewModel = DetailViewModel(article: article)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController: DetailViewControllerDelegate {
    func didMarkArticleAsRead(_ article: Article) {
        viewModel.state = .updateArticleAsRead(article)
    }
}
