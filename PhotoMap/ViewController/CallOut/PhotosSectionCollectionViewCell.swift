//
//  PhotosSectionCollectionViewCell.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/02.
//

import UIKit
import SnapKit

class PhotosSectionCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    func setup(Photo: UIImage) {
        setupLayout()
        imageView.image = Photo
    }
}

private extension PhotosSectionCollectionViewCell {
    func setupLayout() {
        [
            imageView
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
