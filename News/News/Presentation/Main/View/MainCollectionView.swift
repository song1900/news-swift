//
//  MainCollectionView.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import UIKit

final class MainCollectionView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCollectionView {
    private func setupCollectionView() {
        register(ArticleCell.self, forCellWithReuseIdentifier: ArticleCell.reuseIdentifier)
    }
}
