//
//  ArticleCell.swift
//  News
//
//  Created by 송우진 on 10/4/24.
//

import UIKit

final class ArticleCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ArticleCell.self)
    private let titleLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
    private let publishedAtLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func update(_ model: Article) {
        titleLabel.text = model.title
        titleLabel.textColor = model.isRead ? .red : .label
        publishedAtLabel.text = model.publishedAt
        updateImageView(model.urlToImage)
    }
}

extension ArticleCell {
    private func setupStyle() {
        backgroundColor = .systemPink.withAlphaComponent(0.3)
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 2
        publishedAtLabel.font = .preferredFont(forTextStyle: .caption1)
    }
    
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

extension ArticleCell {
    private func updateImageView(_ urlToImage: String?) {
        if urlToImage == nil {
            imageView.isHidden = true
        } else {
            imageView.isHidden = false
            let screenWidth = UIScreen.main.bounds.width
            let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: screenWidth)
            heightConstraint.priority = .defaultLow
            heightConstraint.isActive = true
            let targetSize = CGSize(width: screenWidth, height: screenWidth)
            loadImage(from: urlToImage, targetSize: targetSize)
        }
    }
    
    private func loadImage(
        from urlString: String?,
        targetSize: CGSize
    ) {
        guard let urlString,
              let url = URL(string: urlString)
        else { return }
        Task {
            let loadImage: UIImage?
            // 파일 매니저에서 데이터 우선 조회
            if let fileImage = FileManager.default.loadImage(for: urlString, targetSize: targetSize) {
                loadImage = fileImage
            } else {
                let image = await ImageCacheManager.shared.loadImage(from: url, targetSize: targetSize)
                if let image {
                    // 파일 매니저에 저장
                    FileManager.default.saveImage(image, for: urlString)
                }
                loadImage = image
            }
            await MainActor.run {
                imageView.image = loadImage
            }
        }
    }
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

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemSize.width * 5 + 40), heightDimension: .absolute(itemSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 5)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return section
    }
}
