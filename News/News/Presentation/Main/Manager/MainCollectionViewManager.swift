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
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension MainCollectionViewManager {
    private func configureCollectionView() {
        collectionView.collectionViewLayout = setCompositinalLayout()
        collectionView.delegate = self
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            if UIDevice.current.orientation.isPortrait {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticlePortraitCell.reuseIdentifier, for: indexPath) as? ArticlePortraitCell else {
                    return .init()
                }
                cell.update(model)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleLandscapeCell.reuseIdentifier, for: indexPath) as? ArticleLandscapeCell else {
                    return .init()
                }
                cell.update(model)
                return cell
            }
            
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
            UIDevice.current.orientation.isPortrait ?
            ArticlePortraitCell.layout() : ArticleLandscapeCell.layout()
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let article = viewModel.articles[indexPath.row]
        viewModel.state = .didSelectArticle(article)
    }
}

