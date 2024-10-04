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
    
}
