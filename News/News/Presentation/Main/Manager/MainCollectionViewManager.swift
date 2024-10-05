//
//  MainCollectionViewManager.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import UIKit

final class MainCollectionViewManager: NSObject {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Article>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Article>
    
    private enum Section: Int {
        case main
    }
    
    private let collectionView: UICollectionView
    private let viewModel: MainViewModel
    private lazy var dataSource: DataSource = setDataSource()
    
    init(
        collectionView: UICollectionView,
        viewModel: MainViewModel
    ) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        configureCollectionView()
    }

    func update() {
        applySnapShot()
    }
}

extension MainCollectionViewManager {
    private func configureCollectionView() {
        collectionView.collectionViewLayout = setCompositinalLayout()
        collectionView.delegate = self
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as? ArticleCell else {
                return .init()
            }
            return cell
        }
        return dataSource
    }
    
    private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.articles, toSection: .main)
        dataSource.apply(snapShot)
    }
    
    private func setCompositinalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            ArticleCell.layout()
        }
    }
}

extension MainCollectionViewManager: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let totalItems = viewModel.articles.count
        if indexPath.item == (totalItems - 1) {
            viewModel.state = .fetchTopHeadlinesNextPage
        }
    }
}

