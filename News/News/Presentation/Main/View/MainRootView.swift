//
//  MainRootView.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import UIKit

final class MainRootView: UIView {
    private(set) var collectionView = MainCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainRootView {
    private func setupStyle() {
        backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        addSubview(collectionView, autoLayout: [.fill(0)])
    }
}
