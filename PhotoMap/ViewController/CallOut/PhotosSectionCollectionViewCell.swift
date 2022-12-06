//
//  PhotosSectionCollectionViewCell.swift
//  PhotoMap
//
//  Created by 이재훈 on 2022/12/02.
//

import UIKit
import SnapKit

class PhotosSectionCollectionViewCell: UICollectionViewCell {

    var buttonTapped: (() -> Void)?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        let image = UIImageView(image: UIImage(systemName: "x.circle.fill"))
        button.addSubview(image)
        image.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        image.tintColor = .systemPurple
        return button
    }()

    func setup(Photo: UIImage) {
        setupLayout()
        imageView.image = Photo
    }
    
    func setupDeleteButton(Photo: UIImage) {
        [
            imageView,
            button
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints{
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(32)
        }
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
    
    @objc func deleteButtonTapped() {
        buttonTapped?()
    }
}
