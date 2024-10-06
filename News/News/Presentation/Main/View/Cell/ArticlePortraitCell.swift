//
//  ArticlePortraitCell.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import UIKit

final class ArticlePortraitCell: DefaultArticleCell {
    static let reuseIdentifier = String(describing: ArticlePortraitCell.self)
    
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
            let screenWidth = UIScreen.main.bounds.width
            let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: screenWidth)
            heightConstraint.priority = .defaultLow
            heightConstraint.isActive = true
            let targetSize = CGSize(width: screenWidth, height: screenWidth)
            loadImage(from: urlToImage, targetSize: targetSize)
        } else {
            imageView.isHidden = true
        }
    }
}

extension ArticlePortraitCell {
    private func setupLayout() {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 5).isActive = true

        let stackView = UIStackView(arrangedSubviews: [titleLabel, publishedAtLabel, spacer, imageView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        contentView.addSubview(stackView, autoLayout: [.fillX(0), .top(0), .bottom(0)])
    }
}

extension ArticlePortraitCell {
    static func layout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 20
        return section
    }
}
