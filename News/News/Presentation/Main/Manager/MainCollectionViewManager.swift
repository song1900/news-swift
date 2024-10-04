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
    
    init(
        collectionView: UICollectionView,
        viewModel: MainViewModel
    ) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
    }
}

