//
//  DefaultArticleCell.swift
//  News
//
//  Created by 송우진 on 10/6/24.
//

import UIKit

class DefaultArticleCell: UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    let titleLabel: UILabel = .init()
    let imageView: UIImageView = .init()
    let publishedAtLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // 공통 이미지 업데이트 로직
    func updateImageView(_ urlToImage: String?) {}
}
extension DefaultArticleCell {
    func update(_ model: Article) {
        titleLabel.text = model.title
        titleLabel.textColor = model.isRead ? .red : .label
        publishedAtLabel.text = model.publishedAtInLocalTime ?? model.publishedAt
        updateImageView(model.urlToImage)
    }
    
    private func setupStyle() {
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 2
        publishedAtLabel.font = .preferredFont(forTextStyle: .caption1)
    }

    func loadImage(
        from urlString: String,
        targetSize: CGSize
    ) {
        guard let url = URL(string: urlString) else { return }
        Task {
            let loadImage: UIImage?
            if let fileImage = FileManager.default.loadImage(for: urlString, targetSize: targetSize) {
                loadImage = fileImage
            } else {
                let image = await ImageCacheManager.shared.loadImage(from: url, targetSize: targetSize)
                if let image {
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
