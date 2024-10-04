//
//  ArticleCell.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import UIKit

final class ArticleCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ArticleCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

extension ArticleCell {
    static func layout() -> NSCollectionLayoutSection {
        let isPortrait = UIDevice.current.orientation.isPortrait
        return isPortrait ? createPortraitSection() : createLandscapeSection()
    }

    private static func createPortraitSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 20
        return section
    }

    private static func createLandscapeSection() -> NSCollectionLayoutSection {
        let itemSize = CGSize(width: 300, height: 120)
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(itemSize.width), heightDimension: .absolute(itemSize.height))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemSize.width * 5), heightDimension: .absolute(itemSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 5)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
