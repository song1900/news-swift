//
//  ArticleLandscapeCell.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import UIKit

final class ArticleLandscapeCell: DefaultArticleCell {
    static private let cellSize = CGSize(width: 300, height: 120)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateImageView(_ urlToImage: String?) {
        if let urlToImage {
            imageView.isHidden = false
            let imageWidth: CGFloat = ArticleLandscapeCell.cellSize.height
            let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageWidth)
            widthConstraint.priority = .defaultLow
            widthConstraint.isActive = true
            let targetSize = CGSize(width: imageWidth, height: imageWidth)
            loadImage(from: urlToImage, targetSize: targetSize)
        } else {
            imageView.isHidden = true
        }
    }
}

extension ArticleLandscapeCell {
    private func setupLayout() {
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, publishedAtLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 6
        labelStackView.distribution = .fill
        labelStackView.alignment = .leading
        
        let mainStackView = UIStackView(arrangedSubviews: [imageView, labelStackView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .center
        
        contentView.addSubview(mainStackView, autoLayout: [.fillX(0), .top(0), .bottom(0)])
    }
}

extension ArticleLandscapeCell {
    static func layout() -> NSCollectionLayoutSection {
        let itemSize = ArticleLandscapeCell.cellSize
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(itemSize.width), heightDimension: .absolute(itemSize.height))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemSize.width * 5 + 40), heightDimension: .absolute(itemSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 5)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return section
    }
}

