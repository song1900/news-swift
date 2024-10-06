//
//  ArticleLandscapeCell.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import UIKit

final class ArticleLandscapeCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ArticleLandscapeCell.self)
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

extension ArticleLandscapeCell {
    private func setupStyle() {
        backgroundColor = .systemPink.withAlphaComponent(0.3)
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 2
        publishedAtLabel.font = .preferredFont(forTextStyle: .caption1)
    }
    
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
    private func updateImageView(_ urlToImage: String?) {
        if urlToImage == nil {
            imageView.isHidden = true
        } else {
            imageView.isHidden = false
            
            let imageWidth: CGFloat = 120
            let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageWidth)
            widthConstraint.priority = .defaultLow
            widthConstraint.isActive = true
            let targetSize = CGSize(width: imageWidth, height: imageWidth)
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

extension ArticleLandscapeCell {
    static func layout() -> NSCollectionLayoutSection {
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

