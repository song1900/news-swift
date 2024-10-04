//
//  MainViewController.swift
//  News
//
//  Created by 송우진 on 10/3/24.
//

import UIKit

final class MainViewController: UIViewController {
    private var rootView = MainRootView()
    private let viewModel: MainViewModel
    private var collectionViewManager: MainCollectionViewManager?

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
    }
}

extension MainViewController {
    private func setupNavigation() {
        title = "NEWS"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
